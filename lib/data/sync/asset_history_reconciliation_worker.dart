// ============================================================================
// lib/data/sync/asset_history_reconciliation_worker.dart
// ASSET HISTORY RECONCILIATION WORKER — Enterprise Ultra Pro Premium 10/10
// ----------------------------------------------------------------------------
// QUÉ HACE
// - Recupera archives pendientes que quedaron marcados en Firestore con:
//   governance.hasPendingHistory == true
//   governance.historyPendingSince < now - 5min
// - Usa discovery durable en Firestore + tracking optimista en memoria.
// - Aplica throttle global + backoff por assetId para evitar hot loops.
// - Reintenta SOLO domains en estado PENDING.
// - Respeta FAILED_RETRY como estado terminal-operativo-manual.
// - Nunca procesa FAILED_RETRY automáticamente.
// - Nunca propaga excepciones al caller.
//
// QUÉ NO HACE
// - No construye el documento principal del asset.
// - No calcula payloadHash.
// - No decide OCC.
// - No escribe history directamente: delega al archive service.
// - No reemplaza el documento principal completo del asset.
// - No persiste estado interno del worker entre sesiones.
//
// CONTRATOS IMPORTANTES
// - Discovery durable:
//   asset_vehiculo
//     .where('governance.hasPendingHistory', isEqualTo: true)
//     .where('governance.historyPendingSince', isLessThan: cutoff)
// - Estados válidos:
//   PENDING | COMPLETED | FAILED_RETRY
// - El worker procesa ÚNICAMENTE PENDING.
// - FAILED_RETRY queda visible para intervención manual.
// - El documento principal YA debe venir persistido con PENDING antes del
//   archive async. Este worker es la red de seguridad oficial.
//
// DOS TIPOS DE WRITE EN FIRESTORE
// 1. Write principal del activo:
//    - Lo hace el dispatcher.
//    - Escribe el documento v1.3.4 completo.
// 2. Updates parciales post-archive:
//    - Los hace archive service / worker.
//    - Usan set(merge:true) + paths punteados de governance.
//    - NUNCA reemplazan el documento completo.
//
// GARANTÍAS DE DISEÑO
// - Cero hot loop: throttle global + _perAssetNextAllowedAt.
// - Cero overlap concurrente: _isRunning.
// - Recovery durable tras restart: query Firestore.
// - Tracking en memoria solo complementario.
// - Best effort: jamás rompe el pipeline principal.
//
// NOTAS DE INTEGRACIÓN
// Este archivo asume que AssetHistoryArchiveService expone:
//
//   Future<ArchiveResult> archiveDomain(
//     String assetId,
//     Map<String, dynamic> archivableFragments,
//   )
//
// El worker pasa únicamente los fragments del scope actual (scopedFragments).
// No pasa domainsTouched — el service itera sobre archivableFragments.keys.
//
// AssetAuditService puede ser adaptado mediante callback opcional
// [onReconciliationFailedAudit] para no acoplar este worker a un método
// concreto de auditoría.
//
// CREADO (2026-03)
// - Fase 5 — Asset Schema v1.3.4
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../core/telemetry/sync_telemetry.dart';
import 'asset_history_archive_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TYPEDEFS
// ─────────────────────────────────────────────────────────────────────────────

typedef ReconciliationFailureAuditEmitter = Future<void> Function({
  required String assetId,
  required List<String> domains,
  required int attempts,
  required String reason,
});

// ─────────────────────────────────────────────────────────────────────────────
// WORKER
// ─────────────────────────────────────────────────────────────────────────────

class AssetHistoryReconciliationWorker {
  AssetHistoryReconciliationWorker({
    required FirebaseFirestore firestore,
    required AssetHistoryArchiveService archiveService,
    required SyncTelemetry telemetry,
    ReconciliationFailureAuditEmitter? onReconciliationFailedAudit,
  })  : _firestore = firestore,
        _archiveService = archiveService,
        _telemetry = telemetry,
        _onReconciliationFailedAudit = onReconciliationFailedAudit;

  // ==========================================================================
  // DEPENDENCIAS
  // ==========================================================================

  final FirebaseFirestore _firestore;
  final AssetHistoryArchiveService _archiveService;
  final SyncTelemetry _telemetry;
  final ReconciliationFailureAuditEmitter? _onReconciliationFailedAudit;

  // ==========================================================================
  // CONTRATOS CANÓNICOS
  // ==========================================================================

  static const String _kAssetVehiculoCollection = 'asset_vehiculo';

  static const String _kGovernanceField = 'governance';
  static const String _kHasPendingHistoryField = 'hasPendingHistory';
  static const String _kHistoryPendingSinceField = 'historyPendingSince';
  static const String _kHistoryWriteStatusByDomainField =
      'historyWriteStatusByDomain';

  static const String _kDomainsField = 'domains';
  static const String _kComplianceDomain = 'compliance';
  static const String _kLegalDomain = 'legal';

  static const String _kPoliciesField = 'policies';
  static const String _kLiensField = 'liens';
  static const String _kLimitationsField = 'limitations';

  static const String _kPending = 'PENDING';
  static const String _kFailedRetry = 'FAILED_RETRY';

  // ==========================================================================
  // TUNING OPERATIVO
  // ==========================================================================

  /// Throttle global del worker.
  static const Duration _kMinRunInterval = Duration(minutes: 2);

  /// El worker solo toma trabajo durable si el pending tiene al menos esta edad.
  static const Duration _kDurablePendingAge = Duration(minutes: 5);

  /// Máximo de assets por corrida.
  static const int _kMaxAssetsPerRun = 10;

  /// Máximo de domains por asset en una corrida.
  ///
  /// Evita spikes de writes cuando un asset tiene demasiados domains pendientes.
  static const int _kMaxDomainsPerAssetPerRun = 3;

  /// Backoff por assetId para evitar hot loops sobre activos dañados.
  static const List<Duration> _kPerAssetBackoffTable = <Duration>[
    Duration(minutes: 2),
    Duration(minutes: 5),
    Duration(minutes: 10),
  ];

  // ==========================================================================
  // ESTADO EN MEMORIA
  // ==========================================================================

  /// Previene overlap entre dos llamadas concurrentes a runIfNeeded().
  bool _isRunning = false;

  /// Throttle global.
  DateTime? _lastRunAtUtc;

  /// Tracking optimista en sesión.
  ///
  /// Estructura:
  ///   assetId -> {domain1, domain2, ...}
  final Map<String, Set<String>> _pendingArchives = <String, Set<String>>{};

  /// Próximo instante permitido para reintentar por assetId.
  final Map<String, DateTime> _perAssetNextAllowedAt = <String, DateTime>{};

  /// Conteo de fallos consecutivos por assetId.
  final Map<String, int> _perAssetFailureCount = <String, int>{};

  // ==========================================================================
  // API PÚBLICA
  // ==========================================================================

  /// Registra pending optimista en memoria.
  ///
  /// Esto NO reemplaza el recovery durable por Firestore.
  /// Solo permite reaccionar más rápido dentro de la misma sesión.
  void registerPending(String assetId, Iterable<String> domains) {
    if (assetId.trim().isEmpty) return;

    final Set<String> sanitizedDomains = domains
        .map((String d) => d.trim())
        .where((String d) => d.isNotEmpty)
        .toSet();

    if (sanitizedDomains.isEmpty) return;

    final Set<String> current =
        _pendingArchives.putIfAbsent(assetId, () => <String>{});
    current.addAll(sanitizedDomains);

    _debugLog(
      'registerPending asset=$assetId domains=${sanitizedDomains.join(",")}',
    );
  }

  /// Elimina pending en memoria para un asset completo o para domains concretos.
  void clearPending(
    String assetId, {
    Iterable<String>? domains,
  }) {
    if (!_pendingArchives.containsKey(assetId)) return;

    if (domains == null) {
      _pendingArchives.remove(assetId);
      return;
    }

    final Set<String>? current = _pendingArchives[assetId];
    if (current == null) return;

    for (final String domain in domains) {
      current.remove(domain);
    }

    if (current.isEmpty) {
      _pendingArchives.remove(assetId);
    }
  }

  /// Ejecuta el worker si corresponde.
  ///
  /// REGLAS:
  /// - Si ya hay una corrida en curso => sale.
  /// - Si no pasó el throttle global => sale.
  /// - Nunca propaga excepción.
  Future<void> runIfNeeded({
    DateTime? nowUtc,
    bool ignoreGlobalThrottle = false,
  }) async {
    final DateTime now = (nowUtc ?? DateTime.now()).toUtc();

    if (_isRunning) {
      _debugLog('runIfNeeded skipped => already running');
      return;
    }

    if (!ignoreGlobalThrottle && _isGlobalThrottleActive(now)) {
      _telemetry.recordWorkerSkip(
        reason: SyncWorkerSkipReason.globalThrottle,
      );
      _debugLog('runIfNeeded skipped => global throttle active');
      return;
    }

    _isRunning = true;

    try {
      final List<_PendingAssetWorkItem> workItems =
          await _discoverPendingWork(now);

      if (workItems.isEmpty) {
        _telemetry.recordWorkerSkip(
          reason: SyncWorkerSkipReason.noPendingWork,
        );
        _lastRunAtUtc = now;
        _debugLog('runIfNeeded => no pending work');
        return;
      }

      _telemetry.recordPendingHistoryDetected(count: workItems.length);

      int processedAssets = 0;

      for (final _PendingAssetWorkItem item in workItems) {
        if (processedAssets >= _kMaxAssetsPerRun) break;

        if (_isPerAssetBackoffActive(item.assetId, now)) {
          _telemetry.recordWorkerSkip(
            reason: SyncWorkerSkipReason.perAssetBackoff,
            assetId: item.assetId,
          );
          _debugLog(
            'asset skipped by per-asset backoff => asset=${item.assetId}',
          );
          continue;
        }

        await _processAsset(item, now);
        processedAssets++;
      }

      _lastRunAtUtc = now;
    } catch (error, stackTrace) {
      _lastRunAtUtc = now;
      _debugLog('runIfNeeded error => $error\n$stackTrace');
      // Silencio intencional. Nunca romper al caller.
    } finally {
      _isRunning = false;
    }
  }

  // ==========================================================================
  // DISCOVERY
  // ==========================================================================

  Future<List<_PendingAssetWorkItem>> _discoverPendingWork(
      DateTime nowUtc) async {
    final Map<String, _PendingAssetWorkItem> merged =
        <String, _PendingAssetWorkItem>{};

    final List<_PendingAssetWorkItem> durable =
        await _discoverPendingWorkFromFirestore(nowUtc);

    for (final _PendingAssetWorkItem item in durable) {
      merged[item.assetId] = item;
    }

    final List<_PendingAssetWorkItem> inMemory =
        await _discoverPendingWorkFromMemory(nowUtc);

    for (final _PendingAssetWorkItem item in inMemory) {
      final _PendingAssetWorkItem? existing = merged[item.assetId];

      if (existing == null) {
        merged[item.assetId] = item;
        continue;
      }

      merged[item.assetId] = existing.mergeDomains(item.pendingDomains);
    }

    final List<_PendingAssetWorkItem> items = merged.values.toList()
      ..sort(
        (_PendingAssetWorkItem a, _PendingAssetWorkItem b) =>
            a.historyPendingSinceUtc.compareTo(b.historyPendingSinceUtc),
      );

    return items;
  }

  Future<List<_PendingAssetWorkItem>> _discoverPendingWorkFromFirestore(
    DateTime nowUtc,
  ) async {
    final DateTime cutoff = nowUtc.subtract(_kDurablePendingAge);

    final QuerySnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await _firestore
          .collection(_kAssetVehiculoCollection)
          .where(
            '$_kGovernanceField.$_kHasPendingHistoryField',
            isEqualTo: true,
          )
          .where(
            '$_kGovernanceField.$_kHistoryPendingSinceField',
            isLessThan: Timestamp.fromDate(cutoff),
          )
          .limit(_kMaxAssetsPerRun)
          .get();
    } on FirebaseException catch (e) {
      if (e.code == 'failed-precondition') {
        // El índice composite governance.hasPendingHistory +
        // governance.historyPendingSince no existe aún en Firestore.
        // Degrade a lista vacía — in-memory discovery sigue funcionando.
        // Prerequisito: crear el índice en firestore.indexes.json antes
        // del go-live de Fase 5 (ver Plan §9 Regla 27).
        _debugLog(
          'discoverFromFirestore => FAILED_PRECONDITION: índice compuesto '
          'governance.hasPendingHistory + governance.historyPendingSince '
          'no existe. Firestore discovery omitido hasta que se cree el índice.',
        );
        return <_PendingAssetWorkItem>[];
      }
      rethrow;
    }

    final List<_PendingAssetWorkItem> items = <_PendingAssetWorkItem>[];

    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in snapshot.docs) {
      final Map<String, dynamic> data = doc.data();

      final Map<String, dynamic> governance = _asMap(data[_kGovernanceField]);

      final DateTime historyPendingSinceUtc =
          _readTimestampAsUtc(governance[_kHistoryPendingSinceField]) ?? nowUtc;

      final Map<String, dynamic> statusMap =
          _asMap(governance[_kHistoryWriteStatusByDomainField]);

      final List<String> pendingDomains = statusMap.entries
          .where((MapEntry<String, dynamic> entry) {
            final String value = '${entry.value}'.trim().toUpperCase();
            return value == _kPending;
          })
          .map((MapEntry<String, dynamic> entry) => entry.key.trim())
          .where((String domain) => domain.isNotEmpty)
          .toList();

      if (pendingDomains.isEmpty) continue;

      final Map<String, dynamic> archivableFragments =
          _buildArchivableFragmentsFromDocument(
        document: data,
        pendingDomains: pendingDomains,
      );

      items.add(
        _PendingAssetWorkItem(
          assetId: doc.id,
          pendingDomains: pendingDomains.toSet(),
          archivableFragments: archivableFragments,
          historyPendingSinceUtc: historyPendingSinceUtc,
          source: _PendingWorkSource.firestore,
        ),
      );
    }

    return items;
  }

  Future<List<_PendingAssetWorkItem>> _discoverPendingWorkFromMemory(
    DateTime nowUtc,
  ) async {
    if (_pendingArchives.isEmpty) {
      return <_PendingAssetWorkItem>[];
    }

    final List<_PendingAssetWorkItem> items = <_PendingAssetWorkItem>[];

    for (final MapEntry<String, Set<String>> entry
        in _pendingArchives.entries) {
      final String assetId = entry.key;
      final Set<String> pendingDomains = entry.value;

      if (pendingDomains.isEmpty) continue;

      final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection(_kAssetVehiculoCollection)
          .doc(assetId)
          .get();

      if (!doc.exists) continue;

      final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
      final Map<String, dynamic> governance = _asMap(data[_kGovernanceField]);

      final DateTime historyPendingSinceUtc =
          _readTimestampAsUtc(governance[_kHistoryPendingSinceField]) ?? nowUtc;

      final Map<String, dynamic> archivableFragments =
          _buildArchivableFragmentsFromDocument(
        document: data,
        pendingDomains: pendingDomains.toList(),
      );

      items.add(
        _PendingAssetWorkItem(
          assetId: assetId,
          pendingDomains: pendingDomains,
          archivableFragments: archivableFragments,
          historyPendingSinceUtc: historyPendingSinceUtc,
          source: _PendingWorkSource.memory,
        ),
      );
    }

    return items;
  }

  // ==========================================================================
  // PROCESSING
  // ==========================================================================

  Future<void> _processAsset(
    _PendingAssetWorkItem item,
    DateTime nowUtc,
  ) async {
    final List<String> domainsToProcess =
        item.pendingDomains.take(_kMaxDomainsPerAssetPerRun).toList();

    if (domainsToProcess.isEmpty) return;

    final Map<String, dynamic> scopedFragments = <String, dynamic>{};
    for (final String domain in domainsToProcess) {
      if (item.archivableFragments.containsKey(domain)) {
        scopedFragments[domain] = item.archivableFragments[domain];
      }
    }

    if (scopedFragments.isEmpty) {
      // Domains marcados PENDING en governance pero sin datos archivables en el
      // documento actual. Semánticamente: "nada que archivar" = ya completado.
      // NO es un failure operativo — marcarlo FAILED_RETRY confundiría operators.
      // Causa probable: el documento fue actualizado entre el write y este run,
      // eliminando los datos que originaron el PENDING. Resolución: COMPLETED.
      _debugLog(
        'asset=${item.assetId} — domains PENDING sin fragments: '
        '${domainsToProcess.join(",")} → marcando COMPLETED (nada que archivar)',
      );
      for (final String domain in domainsToProcess) {
        try {
          await _firestore
              .collection(_kAssetVehiculoCollection)
              .doc(item.assetId)
              .update(<String, dynamic>{
            '$_kGovernanceField.$_kHistoryWriteStatusByDomainField.$domain':
                'COMPLETED',
          });
        } catch (_) {
          // Non-fatal. hasPendingHistory permanece true; siguiente run lo resuelve.
        }
      }
      clearPending(item.assetId, domains: domainsToProcess);
      return;
    }

    try {
      final dynamic result = await _archiveService.archiveDomain(
        item.assetId,
        scopedFragments,
      );

      // Si no lanzó excepción, lo consideramos éxito operativo del intento.
      // La semántica interna detallada queda en manos del archive service.
      _clearAssetFailureState(item.assetId);
      clearPending(item.assetId, domains: domainsToProcess);

      _debugLog(
        'archive success => asset=${item.assetId} '
        'domains=${domainsToProcess.join(",")} '
        'result=${result.runtimeType}',
      );
    } catch (error, stackTrace) {
      _debugLog(
        'archive failure => asset=${item.assetId} '
        'domains=${domainsToProcess.join(",")} '
        'error=$error\n$stackTrace',
      );

      await _handleProcessingFailure(
        assetId: item.assetId,
        domains: domainsToProcess,
        nowUtc: nowUtc,
        reason: error.runtimeType.toString(),
      );
    }
  }

  Future<void> _handleProcessingFailure({
    required String assetId,
    required List<String> domains,
    required DateTime nowUtc,
    required String reason,
  }) async {
    final int nextFailureCount = (_perAssetFailureCount[assetId] ?? 0) + 1;
    _perAssetFailureCount[assetId] = nextFailureCount;

    final Duration backoff = _backoffForAttempt(nextFailureCount);
    _perAssetNextAllowedAt[assetId] = nowUtc.add(backoff);

    for (final String domain in domains) {
      _telemetry.recordHistoryRetry(
        assetId: assetId,
        domain: domain,
        attempt: nextFailureCount,
      );
    }

    if (nextFailureCount < 3) {
      _debugLog(
        'asset scheduled for retry => asset=$assetId '
        'attempt=$nextFailureCount backoff=${backoff.inMinutes}min',
      );
      return;
    }

    await _markDomainsFailedRetry(
      assetId: assetId,
      domains: domains,
      nowUtc: nowUtc,
    );

    for (final String domain in domains) {
      _telemetry.recordHistoryReconciliationFailed(
        assetId: assetId,
        domain: domain,
      );
      _telemetry.recordArchiveFailure(
        assetId: assetId,
        domain: domain,
        reason: SyncArchiveFailureReason.unknown,
      );
    }

    try {
      await _onReconciliationFailedAudit?.call(
        assetId: assetId,
        domains: domains,
        attempts: nextFailureCount,
        reason: reason,
      );
    } catch (_) {
      // Silencio intencional. La auditoría no puede romper el worker.
    }

    clearPending(assetId, domains: domains);

    _debugLog(
      'asset moved to FAILED_RETRY => asset=$assetId '
      'domains=${domains.join(",")} reason=$reason',
    );
  }

  // ==========================================================================
  // GOVERNANCE PARTIAL UPDATES
  // ==========================================================================

  Future<void> _markDomainsFailedRetry({
    required String assetId,
    required List<String> domains,
    required DateTime nowUtc,
  }) async {
    final DocumentReference<Map<String, dynamic>> docRef =
        _firestore.collection(_kAssetVehiculoCollection).doc(assetId);

    await _firestore.runTransaction<void>(
      (Transaction tx) async {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await tx.get(docRef);

        final Map<String, dynamic> data =
            snapshot.data() ?? <String, dynamic>{};

        final Map<String, dynamic> governance = _asMap(data[_kGovernanceField]);

        final Map<String, dynamic> statusMap =
            _asMap(governance[_kHistoryWriteStatusByDomainField]);

        for (final String domain in domains) {
          statusMap[domain] = _kFailedRetry;
        }

        final bool hasPendingHistory = statusMap.values.any((dynamic value) {
          final String normalized = '$value'.trim().toUpperCase();
          return normalized == _kPending || normalized == _kFailedRetry;
        });

        final Map<String, dynamic> patch = <String, dynamic>{
          for (final String domain in domains)
            '$_kGovernanceField.$_kHistoryWriteStatusByDomainField.$domain':
                _kFailedRetry,
          '$_kGovernanceField.$_kHasPendingHistoryField': hasPendingHistory,
          '$_kGovernanceField.$_kHistoryPendingSinceField': hasPendingHistory
              ? governance[_kHistoryPendingSinceField]
              : FieldValue.delete(),
        };

        tx.set(docRef, patch, SetOptions(merge: true));
      },
    );
  }

  // ==========================================================================
  // HELPERS DE ESTADO
  // ==========================================================================

  bool _isGlobalThrottleActive(DateTime nowUtc) {
    if (_lastRunAtUtc == null) return false;
    return nowUtc.difference(_lastRunAtUtc!) < _kMinRunInterval;
  }

  bool _isPerAssetBackoffActive(String assetId, DateTime nowUtc) {
    final DateTime? nextAllowedAt = _perAssetNextAllowedAt[assetId];
    if (nextAllowedAt == null) return false;
    return nowUtc.isBefore(nextAllowedAt);
  }

  Duration _backoffForAttempt(int attempt) {
    if (attempt <= 1) return _kPerAssetBackoffTable[0];
    if (attempt == 2) return _kPerAssetBackoffTable[1];
    return _kPerAssetBackoffTable[2];
  }

  void _clearAssetFailureState(String assetId) {
    _perAssetFailureCount.remove(assetId);
    _perAssetNextAllowedAt.remove(assetId);
  }

  // ==========================================================================
  // EXTRACTION / NORMALIZATION
  // ==========================================================================

  Map<String, dynamic> _buildArchivableFragmentsFromDocument({
    required Map<String, dynamic> document,
    required List<String> pendingDomains,
  }) {
    final Map<String, dynamic> domainsRoot = _asMap(document[_kDomainsField]);
    final Map<String, dynamic> result = <String, dynamic>{};

    if (pendingDomains.contains(_kComplianceDomain)) {
      final Map<String, dynamic> compliance =
          _asMap(domainsRoot[_kComplianceDomain]);

      final List<Map<String, dynamic>> policies = _normalizePolicies(
        _asListOfMaps(compliance[_kPoliciesField]),
      );

      if (policies.isNotEmpty) {
        result[_kComplianceDomain] = policies;
      }
    }

    if (pendingDomains.contains(_kLegalDomain)) {
      final Map<String, dynamic> legal = _asMap(domainsRoot[_kLegalDomain]);

      final List<Map<String, dynamic>> liens = _normalizeLiens(
        _asListOfMaps(
          legal[_kLiensField] ?? legal[_kLimitationsField],
        ),
      );

      if (liens.isNotEmpty) {
        result[_kLegalDomain] = liens;
      }
    }

    return result;
  }

  List<Map<String, dynamic>> _normalizePolicies(
    List<Map<String, dynamic>> input,
  ) {
    final List<Map<String, dynamic>> output = <Map<String, dynamic>>[];

    for (final Map<String, dynamic> item in input) {
      final String policyId = _readString(item['policyId']);
      if (policyId.isEmpty) continue;

      output.add(
        <String, dynamic>{
          'policyId': policyId,
          if (_readString(item['policyNumber']).isNotEmpty)
            'policyNumber': _readString(item['policyNumber']),
          if (_readString(item['policyType']).isNotEmpty)
            'policyType': _readString(item['policyType']),
          if (_readString(item['status']).isNotEmpty)
            'status': _readString(item['status']),
          if (item['premium'] != null) 'premium': item['premium'],
          if (_readString(item['effectiveDate']).isNotEmpty)
            'effectiveDate': _readString(item['effectiveDate']),
          if (_readString(item['expirationDate']).isNotEmpty)
            'expirationDate': _readString(item['expirationDate']),
          if (item['isActive'] != null) 'isActive': item['isActive'],
        },
      );
    }

    output.sort(
      (Map<String, dynamic> a, Map<String, dynamic> b) =>
          _readString(a['policyId']).compareTo(_readString(b['policyId'])),
    );

    return output;
  }

  List<Map<String, dynamic>> _normalizeLiens(
    List<Map<String, dynamic>> input,
  ) {
    final List<Map<String, dynamic>> output = <Map<String, dynamic>>[];

    for (final Map<String, dynamic> item in input) {
      final String limitationId = _readString(
        item['limitationId'] ?? item['id'],
      );
      if (limitationId.isEmpty) continue;

      output.add(
        <String, dynamic>{
          'limitationId': limitationId,
          if (_readString(item['type']).isNotEmpty)
            'type': _readString(item['type']),
          if (item['amount'] != null) 'amount': item['amount'],
          if (_readString(item['creditor']).isNotEmpty)
            'creditor': _readString(item['creditor']),
          if (_readString(item['registrationDate']).isNotEmpty)
            'registrationDate': _readString(item['registrationDate']),
          if (_readString(item['status']).isNotEmpty)
            'status': _readString(item['status']),
        },
      );
    }

    output.sort(
      (Map<String, dynamic> a, Map<String, dynamic> b) =>
          _readString(a['limitationId'])
              .compareTo(_readString(b['limitationId'])),
    );

    return output;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map(
        (dynamic key, dynamic val) => MapEntry('$key', val),
      );
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asListOfMaps(dynamic value) {
    if (value is! List) return <Map<String, dynamic>>[];

    return value
        .whereType<Object>()
        .map((Object item) => _asMap(item))
        .where((Map<String, dynamic> item) => item.isNotEmpty)
        .toList();
  }

  DateTime? _readTimestampAsUtc(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate().toUtc();
    if (value is DateTime) return value.toUtc();
    return null;
  }

  String _readString(dynamic value) {
    if (value == null) return '';
    return '$value'.trim();
  }

  // ==========================================================================
  // DEBUG
  // ==========================================================================

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[AssetHistoryReconciliationWorker] $message');
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WORK ITEM INTERNO
// ─────────────────────────────────────────────────────────────────────────────

enum _PendingWorkSource {
  firestore,
  memory,
}

@immutable
class _PendingAssetWorkItem {
  const _PendingAssetWorkItem({
    required this.assetId,
    required this.pendingDomains,
    required this.archivableFragments,
    required this.historyPendingSinceUtc,
    required this.source,
  });

  final String assetId;
  final Set<String> pendingDomains;
  final Map<String, dynamic> archivableFragments;
  final DateTime historyPendingSinceUtc;
  final _PendingWorkSource source;

  _PendingAssetWorkItem mergeDomains(Set<String> extraDomains) {
    return _PendingAssetWorkItem(
      assetId: assetId,
      pendingDomains: <String>{...pendingDomains, ...extraDomains},
      archivableFragments: archivableFragments,
      historyPendingSinceUtc: historyPendingSinceUtc,
      source: source,
    );
  }
}
