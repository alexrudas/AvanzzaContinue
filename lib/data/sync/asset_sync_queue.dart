// ============================================================================
// lib/data/sync/asset_sync_queue.dart
// ASSET SYNC QUEUE — Cola de sincronización para activos vehiculares
//
// QUÉ HACE:
// - Encola operaciones idempotentes (upsert) para activos vehiculares.
// - Define contractualmente el coalescing por partitionKey.
// - Garantiza que múltiples cambios rápidos sobre el mismo asset NO generen
//   múltiples writes innecesarios en Firestore.
// - [enqueueFromBuilderResult]: encola documentos v1.3.4 completos desde
//   AssetDocumentBuilderResult sin recalcular ningún campo. Serializa
//   Timestamp → ISO string para almacenamiento seguro en Isar; el dispatcher
//   reconvierte los campos de governance antes del write a Firestore.
//
// QUÉ NO HACE:
// - No ejecuta sync (eso es SyncDispatcher / SyncEngine).
// - No decide cuándo sincronizar.
// - No aplica lógica de conflictos.
// - No recalcula payloadHash, domainsTouched ni expectedDomainVersions.
// - No reconvierte ISO strings a Timestamp (eso lo hace el dispatcher).
//
// ─────────────────────────────────────────────────────────────────────────────
// COALESCING (CRÍTICO — DISEÑO DE COSTO Y PERFORMANCE)
//
// partitionKey: 'vehicle:{assetId}'
//
// CONTRATO:
//
// - Puede haber múltiples entradas en el outbox para el mismo partitionKey.
// - El SyncDispatcher DEBE:
//     → seleccionar SOLO la entrada MÁS RECIENTE
//     → descartar (o ignorar) las anteriores
//
// ESCENARIO REAL:
//
// Usuario edita:
//   1. kilometraje
//   2. color
//   3. SOAT
//
// Resultado en cola:
//   → 3 entradas con mismo partitionKey
//
// El dispatcher debe reducir esto a:
//   → 1 sola operación (la última)
//
// BENEFICIO:
//   → reducción de writes (hasta -66% o más)
//   → menor costo Firebase
//   → menor latencia
//
// ⚠️ IMPORTANTE:
// Este archivo NO implementa el coalescing.
// SOLO define el contrato que el dispatcher debe respetar.
//
// ─────────────────────────────────────────────────────────────────────────────
// IDEMPOTENCY KEY
//
// Legacy (enqueueUpsert):
//   vehicle:upsert:{assetId}:{updatedAtMs}
//
// v1.3.4 (enqueueFromBuilderResult):
//   vehicle:v2:upsert:{assetId}:{payloadHash}
//
// - payloadHash incluye el contenido exacto del documento — misma key = mismo
//   contenido, no se duplica en el outbox aunque se encole más de una vez.
//
// ─────────────────────────────────────────────────────────────────────────────
// SERIALIZACIÓN DE TIMESTAMPS (v1.3.4)
//
// El documento v1.3.4 puede contener Timestamp de Firestore (governance
// block). Isar no puede almacenar Timestamp directamente. Por eso:
//
//   _toOutboxSafeDocument() → convierte Timestamp → ISO string
//
// El dispatcher aplica la reconversión inversa antes de cada write a Firestore
// para que governance.historyPendingSince sea un Timestamp real (requerido
// por la query del reconciliation worker).
//
// ─────────────────────────────────────────────────────────────────────────────
// ENTERPRISE NOTES
// CREADO: Fase 3 — Asset Schema v1.3.4.
// EXTENDIDO (2026-03): Fase 5 — enqueueFromBuilderResult().
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/firestore_paths.dart';
import '../../domain/entities/sync/sync_outbox_entry.dart';
import '../../domain/repositories/sync_outbox_repository.dart';
import '../models/asset/special/asset_vehiculo_model.dart';
import 'asset_document_builder.dart';
import 'asset_firestore_adapter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// QUEUE
// ─────────────────────────────────────────────────────────────────────────────

class AssetSyncQueue {
  final SyncOutboxRepository _outboxRepo;
  final AssetFirestoreAdapter _adapter;

  static const _uuid = Uuid();

  const AssetSyncQueue({
    required SyncOutboxRepository outboxRepo,
    required AssetFirestoreAdapter adapter,
  })  : _outboxRepo = outboxRepo,
        _adapter = adapter;

  // ==========================================================================
  // ENQUEUE UPSERT
  // ==========================================================================

  Future<void> enqueueUpsert({
    required AssetVehiculoModel model,
    required DateTime nowUtc,
  }) async {
    // 🔥 GUARDRAIL: UTC obligatorio
    assert(
      nowUtc.isUtc,
      '[AssetSyncQueue] nowUtc debe estar en UTC.',
    );

    final idempotencyKey = _buildIdempotencyKey(model, nowUtc);

    // 🔥 IDEMPOTENCIA
    final alreadyExists =
        await _outboxRepo.existsByIdempotencyKey(idempotencyKey);

    if (alreadyExists) {
      if (kDebugMode) {
        debugPrint(
          '[AssetSyncQueue] Skip enqueue (idempotent): $idempotencyKey',
        );
      }
      return;
    }

    final payload = _adapter.toOutboxPayload(model);

    // 🔥 VALIDACIÓN JSON-safe
    _adapter.assertPayloadIsJsonSafe(payload);

    final entry = SyncOutboxEntry(
      id: _uuid.v4(),
      idempotencyKey: idempotencyKey,

      // 🔥 CLAVE DE COALESCING
      partitionKey: _buildPartitionKey(model.assetId),

      operationType: SyncOperationType.batch,
      entityType: SyncEntityType.asset,
      entityId: model.assetId,
      firestorePath: '${FirestorePaths.assetVehiculo}/${model.assetId}',

      payload: payload,

      schemaVersion: 1,
      status: SyncStatus.pending,
      createdAt: nowUtc,

      metadata: {
        'source': 'asset_sync_queue',
        'assetId': model.assetId,
        'placa': model.placa,
        'updatedAt': model.updatedAt?.toUtc().toIso8601String(),

        // 🔥 PARA DEBUG / ENGINE
        'coalescingKey': 'vehicle:${model.assetId}',
      },
    );

    await _outboxRepo.upsert(entry);
  }

  // ==========================================================================
  // ENQUEUE FROM BUILDER RESULT (v1.3.4)
  // ==========================================================================

  /// Encola un documento v1.3.4 completo desde [AssetDocumentBuilderResult].
  ///
  /// Contrato estricto (plan §10.2):
  /// - NO recalcula payloadHash, domainsTouched ni expectedDomainVersions.
  /// - NO llama a domain builders ni a la priority engine.
  /// - Serializa Timestamp → ISO string para almacenamiento seguro en Isar.
  /// - El dispatcher detecta v1.3.4 por presencia de 'payloadHash' en metadata.
  /// - El dispatcher es responsable de reconvertir ISO strings a Timestamp
  ///   en los campos de governance antes del write a Firestore.
  ///
  /// CONTRATO DE HASH (inamovible):
  /// [result.payloadHash] corresponde al documento canónico producido por
  /// [AssetDocumentBuilder] ANTES de la serialización de transporte para
  /// outbox. safePayload es una transformación transitoria (Timestamp → ISO
  /// string) que el dispatcher debe revertir antes del write a Firestore.
  /// PROHIBIDO recalcular hash sobre safePayload.
  Future<void> enqueueFromBuilderResult({
    required AssetDocumentBuilderResult result,
    required AssetVehiculoModel model,
    required DateTime nowUtc,
  }) async {
    assert(
      nowUtc.isUtc,
      '[AssetSyncQueue] nowUtc debe estar en UTC.',
    );

    // GUARDRAIL: el builder garantiza fragments vacíos cuando oversized.
    // Este assert detecta regresiones si el builder cambia ese contrato.
    assert(
      !result.archivableFragmentsOversized ||
          result.archivableFragments.isEmpty,
      '[AssetSyncQueue] archivableFragmentsOversized=true exige archivableFragments vacío.',
    );

    // GUARDRAIL: document y result deben tener el mismo payloadHash.
    // Si el builder produce divergencia entre ambos, se encola basura silenciosa.
    assert(
      result.document['metadata']?['payloadHash'] == result.payloadHash,
      '[AssetSyncQueue] result.document.metadata.payloadHash debe coincidir '
      'con result.payloadHash.',
    );

    // GUARDRAIL: historyWriteStatusSeed solo puede referenciar domains
    // presentes en archivableFragments.
    assert(
      result.historyWriteStatusSeed.keys
          .every(result.archivableFragments.containsKey),
      '[AssetSyncQueue] historyWriteStatusSeed contiene domains ausentes '
      'en archivableFragments.',
    );

    // Idempotency key basada en payloadHash: mismo contenido → no duplicar.
    final idempotencyKey =
        'vehicle:v2:upsert:${model.assetId}:${result.payloadHash}';

    final alreadyExists =
        await _outboxRepo.existsByIdempotencyKey(idempotencyKey);

    if (alreadyExists) {
      if (kDebugMode) {
        debugPrint(
          '[AssetSyncQueue] Skip enqueue v1.3.4 (idempotent): $idempotencyKey',
        );
      }
      return;
    }

    // Serializar Timestamp → ISO string para almacenamiento seguro en Isar.
    // El dispatcher reconvierte governance.historyPendingSince y otros campos
    // conocidos a Timestamp antes del write a Firestore.
    // PROHIBIDO recalcular payloadHash sobre safePayload — el hash pertenece
    // al documento original del builder, no al payload serializado.
    final safePayload = _toOutboxSafeDocument(result.document);

    // Verificar que la serialización eliminó todos los Timestamp.
    _adapter.assertPayloadIsJsonSafe(safePayload);

    // PRECEDENCIA CONTRACTUAL (inamovible):
    // payload = fuente de verdad del documento Firestore a escribir.
    // metadata = hints operativos / trazabilidad para el dispatcher.
    // En caso de divergencia entre ambos, metadata NO reemplaza ni
    // reconstruye payload. El dispatcher escribe payload directamente.
    final entry = SyncOutboxEntry(
      id: _uuid.v4(),
      idempotencyKey: idempotencyKey,
      partitionKey: _buildPartitionKey(model.assetId),
      operationType: SyncOperationType.batch,
      entityType: SyncEntityType.asset,
      entityId: model.assetId,
      firestorePath: '${FirestorePaths.assetVehiculo}/${model.assetId}',
      payload: safePayload,

      // schemaVersion=2: versión del outbox entry envelope (v1.3.4 document).
      // metadata.documentSchemaVersion es la versión del documento Firestore.
      schemaVersion: 2,
      status: SyncStatus.pending,
      createdAt: nowUtc,
      metadata: {
        'source': 'asset_sync_queue',
        'assetId': model.assetId,
        'placa': model.placa,
        'updatedAt': model.updatedAt?.toUtc().toIso8601String(),
        'coalescingKey': 'vehicle:${model.assetId}',

        // Versión del documento Firestore — semánticamente distinta de
        // schemaVersion (versión del outbox envelope, campo estructural
        // del SyncOutboxEntry, no fuente de decisión del dispatcher).
        'documentSchemaVersion': '1.3.4',

        // Campos v1.3.4 — el dispatcher los consume SIN recalcular.
        'payloadHash': result.payloadHash,
        'domainsTouched': result.domainsTouched,
        'expectedDomainVersions': result.expectedDomainVersions,
        'archivableFragments': result.archivableFragments,

        // Solo para trazabilidad / debugging / assertions.
        // NO usar este campo para construir writes ni para corregir
        // payload.governance. La fuente de verdad del write principal
        // es payload.governance.
        'historyWriteStatusSeed': result.historyWriteStatusSeed,

        'wasSnapshotTruncated': result.wasSnapshotTruncated,
        'rawSnapshotsOriginalSizeBytes': result.rawSnapshotsOriginalSizeBytes,
        'rawSnapshotsPersistedSizeBytes': result.rawSnapshotsPersistedSizeBytes,
        'archivableFragmentsOversized': result.archivableFragmentsOversized,
        'documentSizeBytes': result.documentSizeBytes,

        // override.isLocked — el dispatcher lo usa para saltarse dedup
        // manteniendo OCC activo (plan §8.5, regla 33).
        'overrideIsLocked': result.hasLockedOverride,
      },
    );

    await _outboxRepo.upsert(entry);
  }

  // ==========================================================================
  // SERIALIZACIÓN (TIMESTAMP SAFETY)
  // ==========================================================================

  /// Convierte recursivamente [Timestamp] → ISO string para almacenamiento
  /// seguro en Isar. El dispatcher aplica la reconversión inversa antes de
  /// cada write a Firestore.
  static Map<String, dynamic> _toOutboxSafeDocument(
    Map<String, dynamic> doc,
  ) {
    return _sanitize(doc) as Map<String, dynamic>;
  }

  static dynamic _sanitize(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toUtc().toIso8601String();
    }
    if (value is Map) {
      // Acepta Map<Object?, Object?>, Map<dynamic,dynamic>, etc. que pueden
      // aparecer en transformaciones intermedias del pipeline.
      return <String, dynamic>{
        for (final e in value.entries) e.key.toString(): _sanitize(e.value),
      };
    }
    if (value is List) {
      // Preserva el orden original de la lista.
      // No reordena arrays; el builder ya debió canonicalizar donde corresponda.
      return value.map(_sanitize).toList(growable: false);
    }

    // Solo se permiten primitivos JSON-safe (String, num, bool, null).
    // Cualquier otro tipo Firestore (DocumentReference, GeoPoint, FieldValue)
    // o custom object es inválido para el outbox y se rechaza explícitamente.
    if (value is String || value is num || value is bool || value == null) {
      return value;
    }

    throw UnsupportedError(
      '[AssetSyncQueue] Tipo no soportado para serialización de outbox: '
      '${value.runtimeType}. Solo se permiten primitivos, Map, List y Timestamp.',
    );
  }

  // ==========================================================================
  // KEYS
  // ==========================================================================

  static String _buildIdempotencyKey(
    AssetVehiculoModel model,
    DateTime nowUtc,
  ) {
    final ts = model.updatedAt?.toUtc().millisecondsSinceEpoch ??
        nowUtc.millisecondsSinceEpoch;

    return 'vehicle:upsert:${model.assetId}:$ts';
  }

  /// 🔥 CLAVE CENTRAL DEL DISEÑO
  ///
  /// Todas las operaciones del mismo asset comparten esta key.
  ///
  /// El dispatcher debe:
  /// - agrupar por partitionKey
  /// - tomar la MÁS RECIENTE
  static String _buildPartitionKey(String assetId) {
    return 'vehicle:$assetId';
  }
}
