// ============================================================================
// lib/data/sync/asset_history_archive_service.dart
// ASSET HISTORY ARCHIVE SERVICE — Enterprise Ultra Pro Premium (v1.3.4)
//
// QUÉ HACE:
// - Escribe items de historial operativo en la subcollection Firestore:
//     asset_vehiculo/{assetId}/history/{domain}/items/{itemId}
//   Abreviado en el plan como: asset_vehiculo/{assetId}/history/{domain}/{itemId}
//   La subcollection 'items' es el nivel colección requerido por Firestore entre
//   el documento {domain} y el documento {itemId} (alternancia col/doc obligatoria).
// - Garantiza idempotencia: no duplica items ya escritos (check por itemId).
// - Poda items cuando count > 100 por domain, eliminando los más antiguos
//   por archivedAtUtc (Timestamp Firestore — criterio operativo, no de negocio).
// - Actualiza governance.historyWriteStatusByDomain.{domain} = 'COMPLETED'
//   tras archive exitoso (notación punteada — nunca reemplaza el mapa completo).
// - Marca governance.historyWriteStatusByDomain.{domain} = 'FAILED_RETRY'
//   cuando se agotan los 3 reintentos. Contrato: ESTE servicio es quien marca
//   FAILED_RETRY. El reconciliation worker solo procesa estados PENDING.
// - Evalúa el mapa completo de governance tras cada run: si TODOS los domains
//   están COMPLETED, cierra hasPendingHistory = false + historyPendingSince = null.
// - Emite audit event 'history_pruned' cuando poda ocurre.
//
// QUÉ NO HACE:
// - No re-parsea el payload del dispatcher.
// - No accede al SyncOutbox ni al modelo Isar.
// - No decide qué domains archivar (eso viene en archivableFragments).
// - No persiste métricas más allá de delegar a SyncTelemetry.
// - No retiene fragmentos para recuperación (el reconciliation worker
//   resuelve el caso de governance fallida post-archive para PENDING).
//
// PRINCIPIOS:
// - Idempotencia por itemId SHA-256 determinístico.
// - Pruning SOLO por archivedAtUtc (Timestamp) — PROHIBIDO campos de negocio.
// - Governance update: notación punteada field-by-field.
// - hasPendingHistory = false SOLO cuando TODOS los domains están COMPLETED.
// - FAILED_RETRY es marcado por este service, no por el worker.
// - Archive es fuego-y-olvido para el dispatcher; excepciones capturadas upstream.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 5 — Asset Schema v1.3.4.
// PATH CANÓNICO: asset_vehiculo/{assetId}/history/{domain}/items/{itemId}
//   donde 'items' = _kHistoryItemsSubcollection (nivel Firestore obligatorio).
// PROHIBIDO: assets/{assetId}/history/... — no es el write-model del sync v1.3.4.
// PROHIBIDO: history_{domain}/... — usar siempre FirestorePaths.assetHistory + /domain/items.
// ============================================================================

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

import '../../core/telemetry/sync_telemetry.dart';
import '../../core/utils/firestore_paths.dart';
import '../../core/utils/map_canonicalizer.dart';
import 'asset_audit_service.dart';

// ============================================================================
// RESULT VALUE OBJECT
// ============================================================================

/// Resultado de un ciclo de archive por asset.
///
/// - [succeeded]: domains archivados exitosamente en este run.
/// - [failed]: domains que agotaron los 3 reintentos — marcados FAILED_RETRY
///   en governance por este service.
/// - [skipped]: domains en [domainsTouched] sin fragments en [archivableFragments].
final class ArchiveResult {
  ArchiveResult({
    required List<String> succeeded,
    required List<String> failed,
    required List<String> skipped,
  })  : succeeded = List<String>.unmodifiable(succeeded),
        failed = List<String>.unmodifiable(failed),
        skipped = List<String>.unmodifiable(skipped);

  /// Todos los domains en archivableFragments estaban vacíos o el mapa era vacío.
  ArchiveResult.empty()
      : succeeded = const [],
        failed = const [],
        skipped = const [];

  final List<String> succeeded;
  final List<String> failed;
  final List<String> skipped;

  bool get hasFailures => failed.isNotEmpty;
  bool get isFullSuccess => failed.isEmpty && skipped.isEmpty;
  bool get isEmpty => succeeded.isEmpty && failed.isEmpty && skipped.isEmpty;
}

// ============================================================================
// SERVICE
// ============================================================================

/// Servicio de archive operativo de historial de activos.
///
/// Responsable de la escritura, deduplicación, poda y actualización de
/// governance para la subcollection history del schema v1.3.4.
///
/// Uso esperado (desde _triggerArchivePostWrite del dispatcher):
/// ```dart
/// final result = await archiveService.archiveDomain(
///   assetId,
///   domainsTouched,
///   archivableFragments,
/// );
/// ```
class AssetHistoryArchiveService {
  AssetHistoryArchiveService({
    required FirebaseFirestore firestore,
    required AssetAuditService auditService,
    required SyncTelemetry telemetry,
  })  : _firestore = firestore,
        _auditService = auditService,
        _telemetry = telemetry;

  final FirebaseFirestore _firestore;
  final AssetAuditService _auditService;
  final SyncTelemetry _telemetry;

  // ==========================================================================
  // CONSTANTES OPERATIVAS
  // ==========================================================================

  /// Máximo items por domain antes de podar los más antiguos.
  static const int _kMaxHistoryItemsPerDomain = 100;

  /// Backoff entre reintentos: 2s → 5s → 10s.
  static const List<Duration> _kRetryBackoff = [
    Duration(seconds: 2),
    Duration(seconds: 5),
    Duration(seconds: 10),
  ];

  static const int _kMaxRetries = 3;

  /// Subcollection de items bajo cada documento de domain en 'history'.
  ///
  /// Path Firestore real: history/{domain}/items/{itemId}
  /// Firestore requiere alternancia colección/documento. 'items' es el nivel
  /// colección entre el documento {domain} y el documento {itemId}.
  /// Sin esta subcollection el path history/{domain}/{itemId} sería inválido.
  static const String _kHistoryItemsSubcollection = 'items';

  // ==========================================================================
  // API PÚBLICA
  // ==========================================================================

  /// Archiva items de historial para los domains presentes en [archivableFragments].
  ///
  /// Pre-condición: si [archivableFragments] vacío → [ArchiveResult.empty].
  ///
  /// Por domain en [archivableFragments].keys:
  /// 1. Intenta archive hasta [_kMaxRetries] veces.
  /// 2. En éxito: governance.historyWriteStatusByDomain.{domain} = COMPLETED.
  /// 3. En 3 fallos: governance.historyWriteStatusByDomain.{domain} = FAILED_RETRY.
  ///    CONTRATO: este service es quien marca FAILED_RETRY.
  ///    El reconciliation worker solo procesa estados PENDING, no FAILED_RETRY.
  ///
  /// Tras procesar todos los domains:
  /// - Si al menos uno tuvo éxito → evalúa el mapa completo de governance.
  /// - Si TODOS los domains archivables están COMPLETED → cierra hasPendingHistory.
  ///
  /// CONTRATO DE ITERACIÓN:
  /// El service opera exclusivamente sobre [archivableFragments].keys.
  /// No recibe [domainsTouched] — el caller es responsable de pasar solo los
  /// fragments relevantes. Dominios tocados sin fragments no deben incluirse.
  Future<ArchiveResult> archiveDomain(
    String assetId,
    Map<String, dynamic> archivableFragments,
  ) async {
    if (archivableFragments.isEmpty) {
      return ArchiveResult.empty();
    }

    final succeeded = <String>[];
    final failed = <String>[];
    final skipped = <String>[];

    for (final domain in archivableFragments.keys) {
      final rawItems = archivableFragments[domain];
      if (rawItems == null) {
        skipped.add(domain);
        continue;
      }

      final List<Map<String, dynamic>> items;
      try {
        items = (rawItems as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList(growable: false);
      } catch (_) {
        skipped.add(domain);
        continue;
      }

      if (items.isEmpty) {
        skipped.add(domain);
        continue;
      }

      bool domainSuccess = false;
      Object? lastError;

      for (int attempt = 0; attempt < _kMaxRetries; attempt++) {
        if (attempt > 0) {
          await Future<void>.delayed(_kRetryBackoff[attempt - 1]);
          _telemetry.recordHistoryRetry(
            assetId: assetId,
            domain: domain,
            attempt: attempt + 1,
          );
        }

        try {
          await _archiveSingleDomain(assetId, domain, items);
          domainSuccess = true;
          break;
        } catch (e) {
          lastError = e;
        }
      }

      if (domainSuccess) {
        succeeded.add(domain);
        _telemetry.recordArchiveSuccess(assetId: assetId, domain: domain);

        // Actualizar governance para este domain.
        // Excepción no-fatal: el reconciliation worker puede recuperar.
        try {
          await _updateGovernanceStatus(assetId, domain, 'COMPLETED');
        } catch (_) {
          // Non-fatal. hasPendingHistory permanece true; worker lo resuelve.
        }
      } else {
        failed.add(domain);
        _telemetry.recordArchiveFailure(
          assetId: assetId,
          domain: domain,
          reason: _classifyError(lastError),
        );

        // CONTRATO EXPLÍCITO: este service marca FAILED_RETRY al agotar reintentos.
        // El reconciliation worker NO procesa FAILED_RETRY — requiere intervención manual.
        // Excepción no-fatal: governance puede quedar en PENDING; el worker eventualmente
        // re-intentará el archive, fallará 3 veces, y marcará FAILED_RETRY entonces.
        try {
          await _updateGovernanceStatus(assetId, domain, 'FAILED_RETRY');
        } catch (_) {
          // Non-fatal.
        }
      }
    }

    // Evaluar el mapa completo de governance si algún domain tuvo éxito.
    if (succeeded.isNotEmpty) {
      try {
        await _evaluateAndMaybeClosePendingHistory(assetId);
      } catch (_) {
        // Non-fatal. Worker lo detecta por historyPendingSince query.
      }
    }

    return ArchiveResult(
      succeeded: succeeded,
      failed: failed,
      skipped: skipped,
    );
  }

  // ==========================================================================
  // ESCRITURA — DOMAIN ÚNICO
  // ==========================================================================

  /// Escribe todos los items de un domain en su subcollection Firestore.
  ///
  /// Path: asset_vehiculo/{assetId}/history/{domain}/items/{itemId}
  ///
  /// Idempotente: items ya existentes son skipped (no se actualiza archivedAtUtc).
  /// Post-write: poda si count > [_kMaxHistoryItemsPerDomain].
  Future<void> _archiveSingleDomain(
    String assetId,
    String domain,
    List<Map<String, dynamic>> items,
  ) async {
    final now = DateTime.now().toUtc();
    final itemsCollection = _historyItemsRef(assetId, domain);

    // Verificar existencia de todos los items en paralelo (idempotencia).
    // Future.wait() paraleliza los N reads — evita latencia acumulada en loop.
    // archivedAtUtc NO se actualiza en retry; el primer write es canónico.
    final computedItems = items.map((item) {
      final itemId = _computeItemId(assetId, domain, item);
      return (itemId, item);
    }).toList(growable: false);

    final snapshots = await Future.wait(
      computedItems.map((pair) => itemsCollection.doc(pair.$1).get()),
    );

    final toWrite = <String, Map<String, dynamic>>{};
    for (var i = 0; i < computedItems.length; i++) {
      final (itemId, item) = computedItems[i];
      if (snapshots[i].exists) continue; // ya archivado

      toWrite[itemId] = <String, dynamic>{
        ...item,
        'assetId': assetId,
        'domain': domain,
        // archivedAtUtc: Timestamp Firestore — primer write únicamente.
        // Campo operativo de poda; no participa en identidad ni deduplicación.
        'archivedAtUtc': Timestamp.fromDate(now),
      };
    }

    if (toWrite.isNotEmpty) {
      final batch = _firestore.batch();
      toWrite.forEach((itemId, payload) {
        batch.set(itemsCollection.doc(itemId), payload);
      });
      await batch.commit();
    }

    // Podar si se supera el límite por domain.
    await _pruneIfNeeded(itemsCollection, assetId, domain);
  }

  // ==========================================================================
  // PODA
  // ==========================================================================

  /// Elimina los items más antiguos si el count supera [_kMaxHistoryItemsPerDomain].
  ///
  /// Criterio de poda: `archivedAtUtc` (Timestamp) ASC — más antiguo primero.
  /// PROHIBIDO usar campos de negocio (effectiveDate, issueDate, etc.) para podar.
  ///
  /// Emite [AuditEventType.historyPruned] si hay poda (importantBatched → outbox).
  Future<void> _pruneIfNeeded(
    CollectionReference<Map<String, dynamic>> itemsCollection,
    String assetId,
    String domain,
  ) async {
    final snapshot = await itemsCollection
        .orderBy('archivedAtUtc', descending: false)
        .get();

    final count = snapshot.docs.length;
    if (count <= _kMaxHistoryItemsPerDomain) return;

    final excess = count - _kMaxHistoryItemsPerDomain;
    final toDelete = snapshot.docs.take(excess).toList();

    final batch = _firestore.batch();
    for (final doc in toDelete) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    // Audit: history_pruned → importantBatched (outbox Isar).
    try {
      await _auditService.logEvent(
        eventType: AuditEventType.historyPruned,
        assetId: assetId,
        data: <String, dynamic>{
          'domain': domain,
          'prunedCount': excess,
          'remainingCount': _kMaxHistoryItemsPerDomain,
        },
      );
    } catch (_) {
      // Audit failure es non-fatal. La poda ya se commitió.
    }
  }

  // ==========================================================================
  // GOVERNANCE — ACTUALIZACIÓN PUNTUAL
  // ==========================================================================

  /// Actualiza governance.historyWriteStatusByDomain.{domain} = [status].
  ///
  /// [status] debe ser uno de: 'COMPLETED', 'FAILED_RETRY'.
  /// Usa notación punteada (update) — NUNCA reemplaza el mapa completo.
  /// El estado de otros domains en historyWriteStatusByDomain NO se modifica.
  Future<void> _updateGovernanceStatus(
    String assetId,
    String domain,
    String status,
  ) async {
    await _assetDocRef(assetId).update(<String, dynamic>{
      'governance.historyWriteStatusByDomain.$domain': status,
    });
  }

  /// Evalúa el mapa completo de governance y cierra hasPendingHistory si
  /// TODOS los domains están COMPLETED.
  ///
  /// Ejecutado en transacción corta para evitar race conditions entre runs
  /// concurrentes del worker o llamadas simultáneas del dispatcher.
  ///
  /// Regla inamovible:
  /// - hasPendingHistory = false SOLO cuando TODOS los domains son COMPLETED.
  /// - hasPendingHistory permanece true mientras cualquier domain sea PENDING
  ///   o FAILED_RETRY.
  Future<void> _evaluateAndMaybeClosePendingHistory(String assetId) async {
    final docRef = _assetDocRef(assetId);

    await _firestore.runTransaction<void>((transaction) async {
      final snap = await transaction.get(docRef);
      if (!snap.exists) return;

      final governance =
          snap.data()?['governance'] as Map<String, dynamic>?;
      if (governance == null) return;

      final rawStatusMap = governance['historyWriteStatusByDomain'];
      if (rawStatusMap == null) return;

      final Map<String, dynamic> statusByDomain =
          Map<String, dynamic>.from(rawStatusMap as Map);

      if (statusByDomain.isEmpty) return;

      final allCompleted =
          statusByDomain.values.every((v) => v == 'COMPLETED');

      if (!allCompleted) {
        // Al menos un domain sigue en PENDING o FAILED_RETRY.
        // PROHIBIDO apagar hasPendingHistory en este estado.
        return;
      }

      // Todos COMPLETED: cerrar pending history.
      transaction.update(docRef, <String, dynamic>{
        'governance.hasPendingHistory': false,
        // historyPendingSince = null: campo queryable del worker.
        'governance.historyPendingSince': FieldValue.delete(),
      });
    });
  }

  // ==========================================================================
  // IDENTIDAD — itemId DETERMINÍSTICO
  // ==========================================================================

  /// Calcula el itemId determinístico para un item de archive.
  ///
  /// Fórmula (plan §9.6, inamovible):
  ///   itemId = sha256(assetId + ':' + domain + ':' + functionalHash(item))
  ///   functionalHash = sha256(jsonEncode(deepSortKeys(identityFields(domain, item))))
  ///
  /// Garantía: N retries sobre el mismo item producen el mismo itemId.
  /// archivedAtUtc NO participa en identidad.
  String _computeItemId(
    String assetId,
    String domain,
    Map<String, dynamic> item,
  ) {
    final identity = _identityFields(domain, item);
    final canonical = deepSortKeys(identity);
    final functionalHash = sha256
        .convert(utf8.encode(jsonEncode(canonical)))
        .toString();
    return sha256
        .convert(utf8.encode('$assetId:$domain:$functionalHash'))
        .toString();
  }

  /// Campos de identidad funcional por domain (plan §9.6, inamovibles).
  ///
  /// compliance: {policyId, policyType, effectiveDate, expirationDate, status}
  /// legal:      {limitationId, type, registrationDate, creditor, status}
  /// default:    item completo (safe fallback para domains nuevos)
  ///
  /// EXCLUIDOS sin excepción: archivedAtUtc, updatedAt, createdAt, domainVersion,
  /// payloadHash, y cualquier campo operativo temporal.
  Map<String, dynamic> _identityFields(
    String domain,
    Map<String, dynamic> item,
  ) {
    switch (domain) {
      case 'compliance':
        return <String, dynamic>{
          'policyId': item['policyId'],
          'policyType': item['policyType'],
          'effectiveDate': item['effectiveDate'],
          'expirationDate': item['expirationDate'],
          'status': item['status'],
        };
      case 'legal':
        return <String, dynamic>{
          'limitationId': item['limitationId'],
          'type': item['type'],
          'registrationDate': item['registrationDate'],
          'creditor': item['creditor'],
          'status': item['status'],
        };
      default:
        // Domain desconocido: usar item completo como identidad.
        // Evita colisiones en domains que aún no tienen campos canónicos.
        return Map<String, dynamic>.from(item);
    }
  }

  // ==========================================================================
  // CLASIFICACIÓN DE ERRORES
  // ==========================================================================

  /// Clasifica el error de archive para telemetría estructurada.
  SyncArchiveFailureReason _classifyError(Object? error) {
    if (error == null) return SyncArchiveFailureReason.unknown;
    final msg = error.toString().toLowerCase();
    if (msg.contains('network') || msg.contains('socket')) {
      return SyncArchiveFailureReason.network;
    }
    if (msg.contains('timeout') || msg.contains('deadline')) {
      return SyncArchiveFailureReason.timeout;
    }
    if (msg.contains('permission') || msg.contains('unauthorized')) {
      return SyncArchiveFailureReason.permissionDenied;
    }
    if (msg.contains('precondition') || msg.contains('failed-precondition')) {
      return SyncArchiveFailureReason.failedPrecondition;
    }
    return SyncArchiveFailureReason.firestoreWriteFailed;
  }

  // ==========================================================================
  // REFS DE FIRESTORE
  // ==========================================================================

  /// Items subcollection para un domain específico.
  ///
  /// Path Firestore: asset_vehiculo/{assetId}/history/{domain}/items/{itemId}
  ///
  /// Estructura Firestore (alternancia colección/documento obligatoria):
  ///   collection('asset_vehiculo') → doc(assetId)
  ///   → collection('history')      → doc(domain)
  ///   → collection('items')        → doc(itemId)
  ///
  /// Path conceptual del plan (§9.5): history/{domain}/{itemId}
  /// 'items' es [_kHistoryItemsSubcollection] — nivel Firestore obligatorio.
  CollectionReference<Map<String, dynamic>> _historyItemsRef(
    String assetId,
    String domain,
  ) {
    return _firestore
        .collection(FirestorePaths.assetVehiculo)
        .doc(assetId)
        .collection(FirestorePaths.assetHistory)
        .doc(domain)
        .collection(_kHistoryItemsSubcollection);
  }

  DocumentReference<Map<String, dynamic>> _assetDocRef(String assetId) {
    return _firestore
        .collection(FirestorePaths.assetVehiculo)
        .doc(assetId);
  }
}
