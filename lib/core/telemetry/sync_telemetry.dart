// ============================================================================
// lib/core/telemetry/sync_telemetry.dart
// SYNC TELEMETRY — Enterprise Ultra Pro Premium 10/10
// ----------------------------------------------------------------------------
// QUÉ HACE
// - Mantiene métricas operativas en memoria del sync stack v1.3.4.
// - Expone contratos tipados para OCC, dedup, archive, reconciliation y batch.
// - Emite logs en debug vía debugPrint.
// - Emite eventos en release/profile vía Analytics.track() (best-effort, sin
//   propagar excepciones).
// - Provee snapshot tipado para inspección, tests y debugging.
//
// QUÉ NO HACE
// - No persiste métricas entre sesiones.
// - No bloquea la UI.
// - No implementa el backend de analítica.
// - No reemplaza logs estructurados de backend.
// - No decide políticas de negocio.
//
// PRINCIPIOS
// - Hot path barato: O(1), sin I/O bloqueante.
// - Contrato tipado: evita strings frágiles.
// - Best-effort analytics: si Analytics falla, jamás rompe el sync.
// - Separación estricta:
//   - debug => debugPrint
//   - profile/release => Analytics.track
// - Programación defensiva: clamps y sanitización para no aceptar basura.
//
// NOTAS DE ARQUITECTURA
// - Esta clase funciona como FACADE unificado temporal del pipeline de
//   telemetría del sync v1.3.4.
// - Agrupa métricas del dispatcher, archive, reconciliation y audit routing.
// - Si el módulo crece mucho en el futuro, puede separarse en:
//   DispatcherTelemetry / ArchiveTelemetry / AuditTelemetry.
//
// CREADO (2026-03)
// - Fase 5 — Asset Schema v1.3.4
// ============================================================================

import 'package:flutter/foundation.dart';

import 'analytics.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CONTRATOS TIPADOS
// ─────────────────────────────────────────────────────────────────────────────

/// Tipos canónicos de conflicto OCC.
///
/// Mantener alineado con el contrato del plan:
/// - real_conflict
/// - stale_client
/// - retry_loop
enum SyncOccConflictType {
  realConflict('real_conflict'),
  staleClient('stale_client'),
  retryLoop('retry_loop');

  const SyncOccConflictType(this.wireValue);

  /// Wire name estable (snake_case) para persistencia y analytics.
  /// No usar .name builtin aquí — retornaría 'realConflict', no 'real_conflict'.
  final String wireValue;
}

/// Fase en la que ocurrió la deduplicación.
enum SyncDedupPhase {
  precheck('precheck'),
  transaction('transaction');

  const SyncDedupPhase(this.wireValue);

  final String wireValue;
}

/// Motivo estructurado de fallo final de archive.
///
/// Evita depender de strings sueltos en observabilidad.
enum SyncArchiveFailureReason {
  unknown('unknown'),
  network('network'),
  timeout('timeout'),
  permissionDenied('permission_denied'),
  failedPrecondition('failed_precondition'),
  payloadOversized('payload_oversized'),
  invalidFragment('invalid_fragment'),
  firestoreWriteFailed('firestore_write_failed'),
  governanceUpdateFailed('governance_update_failed');

  const SyncArchiveFailureReason(this.wireValue);

  final String wireValue;
}

/// Motivo por el cual el worker no procesó algo.
enum SyncWorkerSkipReason {
  globalThrottle('global_throttle'),
  perAssetBackoff('per_asset_backoff'),
  noPendingWork('no_pending_work');

  const SyncWorkerSkipReason(this.wireValue);

  final String wireValue;
}

// ─────────────────────────────────────────────────────────────────────────────
// VALUE OBJECTS
// ─────────────────────────────────────────────────────────────────────────────

/// Snapshot tipado y estable de la telemetría acumulada.
///
/// No usar este objeto como payload de red. Es para:
/// - tests
/// - dumps
/// - diagnóstico local
@immutable
class SyncTelemetrySnapshot {
  const SyncTelemetrySnapshot({
    required this.occConflictsCount,
    required this.occConflictsByType,
    required this.deduplicationSkipsCount,
    required this.deduplicationSkipsByPhase,
    required this.auditEventsWrittenCount,
    required this.auditEventsBatchedCount,
    required this.historyRetryCount,
    required this.archiveSuccessCount,
    required this.archiveFailureCount,
    required this.historyReconciliationFailedCount,
    required this.archivableFragmentsOversizedCount,
    required this.workerGlobalThrottleSkipsCount,
    required this.workerPerAssetBackoffSkipsCount,
    required this.workerNoPendingWorkSkipsCount,
    required this.pendingHistoryDetectedCount,
    required this.lastFirestoreDocumentSizeBytes,
    required this.maxFirestoreDocumentSizeBytes,
    required this.firestoreDocumentWarningCount,
    required this.firestoreDocumentSamples,
    required this.totalFirestoreDocumentBytes,
    required this.batchesProcessed,
    required this.totalEligible,
    required this.totalPushed,
    required this.totalRetried,
    required this.totalDedupSkippedInBatches,
    required this.totalOccConflictsInBatches,
    required this.totalDeadLettersInBatches,
    required this.totalLegacyProcessedInBatches,
    required this.entrySkippedStoppedCount,
    required this.entrySkippedLeaseCount,
  });

  final int occConflictsCount;
  final Map<String, int> occConflictsByType;

  final int deduplicationSkipsCount;
  final Map<String, int> deduplicationSkipsByPhase;

  final int auditEventsWrittenCount;
  final int auditEventsBatchedCount;

  final int historyRetryCount;
  final int archiveSuccessCount;
  final int archiveFailureCount;
  final int historyReconciliationFailedCount;

  final int archivableFragmentsOversizedCount;

  final int workerGlobalThrottleSkipsCount;
  final int workerPerAssetBackoffSkipsCount;
  final int workerNoPendingWorkSkipsCount;
  final int pendingHistoryDetectedCount;

  final int lastFirestoreDocumentSizeBytes;
  final int maxFirestoreDocumentSizeBytes;
  final int firestoreDocumentWarningCount;
  final int firestoreDocumentSamples;
  final int totalFirestoreDocumentBytes;

  final int batchesProcessed;
  final int totalEligible;
  final int totalPushed;
  final int totalRetried;
  final int totalDedupSkippedInBatches;
  final int totalOccConflictsInBatches;
  final int totalDeadLettersInBatches;
  final int totalLegacyProcessedInBatches;

  /// Entries saltadas porque el dispatcher se detuvo cooperativamente.
  final int entrySkippedStoppedCount;

  /// Entries saltadas porque el lease no pudo adquirirse (contención).
  final int entrySkippedLeaseCount;

  double get batchSizeAvg {
    if (batchesProcessed == 0) return 0;
    return totalEligible / batchesProcessed;
  }

  double get cumulativeSyncRetryRate {
    if (totalEligible == 0) return 0;
    return (totalRetried / totalEligible) * 100.0;
  }

  double get firestoreDocumentSizeAvg {
    if (firestoreDocumentSamples == 0) return 0;
    return totalFirestoreDocumentBytes / firestoreDocumentSamples;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'occConflictsCount': occConflictsCount,
      'occConflictsByType': Map<String, int>.from(occConflictsByType),
      'deduplicationSkipsCount': deduplicationSkipsCount,
      'deduplicationSkipsByPhase':
          Map<String, int>.from(deduplicationSkipsByPhase),
      'auditEventsWrittenCount': auditEventsWrittenCount,
      'auditEventsBatchedCount': auditEventsBatchedCount,
      'historyRetryCount': historyRetryCount,
      'archiveSuccessCount': archiveSuccessCount,
      'archiveFailureCount': archiveFailureCount,
      'historyReconciliationFailedCount': historyReconciliationFailedCount,
      'archivableFragmentsOversizedCount': archivableFragmentsOversizedCount,
      'workerGlobalThrottleSkipsCount': workerGlobalThrottleSkipsCount,
      'workerPerAssetBackoffSkipsCount': workerPerAssetBackoffSkipsCount,
      'workerNoPendingWorkSkipsCount': workerNoPendingWorkSkipsCount,
      'pendingHistoryDetectedCount': pendingHistoryDetectedCount,
      'lastFirestoreDocumentSizeBytes': lastFirestoreDocumentSizeBytes,
      'maxFirestoreDocumentSizeBytes': maxFirestoreDocumentSizeBytes,
      'firestoreDocumentWarningCount': firestoreDocumentWarningCount,
      'firestoreDocumentSamples': firestoreDocumentSamples,
      'totalFirestoreDocumentBytes': totalFirestoreDocumentBytes,
      'firestoreDocumentSizeAvg': firestoreDocumentSizeAvg,
      'batchesProcessed': batchesProcessed,
      'totalEligible': totalEligible,
      'totalPushed': totalPushed,
      'totalRetried': totalRetried,
      'totalDedupSkippedInBatches': totalDedupSkippedInBatches,
      'totalOccConflictsInBatches': totalOccConflictsInBatches,
      'totalDeadLettersInBatches': totalDeadLettersInBatches,
      'totalLegacyProcessedInBatches': totalLegacyProcessedInBatches,
      'entrySkippedStoppedCount': entrySkippedStoppedCount,
      'entrySkippedLeaseCount': entrySkippedLeaseCount,
      'batchSizeAvg': batchSizeAvg,
      'cumulativeSyncRetryRate': cumulativeSyncRetryRate,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TELEMETRY SERVICE
// ─────────────────────────────────────────────────────────────────────────────

class SyncTelemetry {
  SyncTelemetry();

  // ==========================================================================
  // UMBRALES OPERATIVOS
  // ==========================================================================

  static const int _kFirestoreDocumentWarningBytes = 18 * 1024; // 18 KB
  static const double _kHighRetryRateWarningPercent = 20.0;
  static const int _kMaxTrackedStringLength = 160;

  // ==========================================================================
  // CONTADORES EN MEMORIA
  // ==========================================================================

  int _occConflictsCount = 0;
  final Map<String, int> _occConflictsByType = <String, int>{};

  int _deduplicationSkipsCount = 0;
  final Map<String, int> _deduplicationSkipsByPhase = <String, int>{};

  int _auditEventsWrittenCount = 0;
  int _auditEventsBatchedCount = 0;

  int _historyRetryCount = 0;
  int _archiveSuccessCount = 0;
  int _archiveFailureCount = 0;
  int _historyReconciliationFailedCount = 0;

  int _archivableFragmentsOversizedCount = 0;

  int _workerGlobalThrottleSkipsCount = 0;
  int _workerPerAssetBackoffSkipsCount = 0;
  int _workerNoPendingWorkSkipsCount = 0;
  int _pendingHistoryDetectedCount = 0;

  int _lastFirestoreDocumentSizeBytes = 0;
  int _maxFirestoreDocumentSizeBytes = 0;
  int _firestoreDocumentWarningCount = 0;
  int _firestoreDocumentSamples = 0;
  int _totalFirestoreDocumentBytes = 0;

  int _batchesProcessed = 0;
  int _totalEligible = 0;
  int _totalPushed = 0;
  int _totalRetried = 0;
  int _totalDedupSkippedInBatches = 0;
  int _totalOccConflictsInBatches = 0;
  int _totalDeadLettersInBatches = 0;
  int _totalLegacyProcessedInBatches = 0;

  // Skip granular — diferencia razones operativas distintas.
  int _entrySkippedStoppedCount = 0;
  int _entrySkippedLeaseCount = 0;

  // ==========================================================================
  // GETTERS DE LECTURA
  // ==========================================================================

  int get occConflictsCount => _occConflictsCount;

  Map<String, int> get occConflictsByType =>
      Map<String, int>.unmodifiable(_occConflictsByType);

  int get deduplicationSkipsCount => _deduplicationSkipsCount;

  Map<String, int> get deduplicationSkipsByPhase =>
      Map<String, int>.unmodifiable(_deduplicationSkipsByPhase);

  int get auditEventsWrittenCount => _auditEventsWrittenCount;

  int get auditEventsBatchedCount => _auditEventsBatchedCount;

  int get historyRetryCount => _historyRetryCount;

  int get archiveSuccessCount => _archiveSuccessCount;

  int get archiveFailureCount => _archiveFailureCount;

  int get historyReconciliationFailedCount => _historyReconciliationFailedCount;

  int get archivableFragmentsOversizedCount =>
      _archivableFragmentsOversizedCount;

  int get workerGlobalThrottleSkipsCount => _workerGlobalThrottleSkipsCount;

  int get workerPerAssetBackoffSkipsCount => _workerPerAssetBackoffSkipsCount;

  int get workerNoPendingWorkSkipsCount => _workerNoPendingWorkSkipsCount;

  int get pendingHistoryDetectedCount => _pendingHistoryDetectedCount;

  int get lastFirestoreDocumentSizeBytes => _lastFirestoreDocumentSizeBytes;

  int get maxFirestoreDocumentSizeBytes => _maxFirestoreDocumentSizeBytes;

  int get firestoreDocumentWarningCount => _firestoreDocumentWarningCount;

  int get firestoreDocumentSamples => _firestoreDocumentSamples;

  int get totalFirestoreDocumentBytes => _totalFirestoreDocumentBytes;

  int get batchesProcessed => _batchesProcessed;

  int get totalEligible => _totalEligible;

  int get totalPushed => _totalPushed;

  int get totalRetried => _totalRetried;

  int get totalDedupSkippedInBatches => _totalDedupSkippedInBatches;

  int get totalOccConflictsInBatches => _totalOccConflictsInBatches;

  int get totalDeadLettersInBatches => _totalDeadLettersInBatches;

  int get totalLegacyProcessedInBatches => _totalLegacyProcessedInBatches;

  int get entrySkippedStoppedCount => _entrySkippedStoppedCount;

  int get entrySkippedLeaseCount => _entrySkippedLeaseCount;

  double get batchSizeAvg {
    if (_batchesProcessed == 0) return 0;
    return _totalEligible / _batchesProcessed;
  }

  double get cumulativeSyncRetryRate {
    if (_totalEligible == 0) return 0;
    return (_totalRetried / _totalEligible) * 100.0;
  }

  double get firestoreDocumentSizeAvg {
    if (_firestoreDocumentSamples == 0) return 0;
    return _totalFirestoreDocumentBytes / _firestoreDocumentSamples;
  }

  // ==========================================================================
  // REGISTRO DE MÉTRICAS
  // ==========================================================================

  /// Registra un conflicto OCC tipado.
  void recordOccConflict(
    SyncOccConflictType type, {
    String? assetId,
    String? domain,
    int? expectedVersion,
    int? serverVersion,
  }) {
    _occConflictsCount++;
    _occConflictsByType[type.wireValue] =
        (_occConflictsByType[type.wireValue] ?? 0) + 1;

    _debugLog(
      'occ_conflict '
      'type=${type.wireValue} '
      'asset=${assetId ?? "-"} '
      'domain=${domain ?? "-"} '
      'expected=${expectedVersion ?? "-"} '
      'server=${serverVersion ?? "-"} '
      'total=$_occConflictsCount',
    );

    _track(
      'sync_occ_conflict',
      <String, dynamic>{
        'type': type.wireValue,
        if (assetId != null) 'assetId': assetId,
        if (domain != null) 'domain': domain,
        if (expectedVersion != null) 'expectedVersion': expectedVersion,
        if (serverVersion != null) 'serverVersion': serverVersion,
        'total': _occConflictsCount,
      },
    );
  }

  /// Registra un skip de deduplicación.
  void recordDeduplicationSkip({
    required SyncDedupPhase phase,
    String? assetId,
  }) {
    _deduplicationSkipsCount++;
    _deduplicationSkipsByPhase[phase.wireValue] =
        (_deduplicationSkipsByPhase[phase.wireValue] ?? 0) + 1;

    _debugLog(
      'dedup_skip '
      'phase=${phase.wireValue} '
      'asset=${assetId ?? "-"} '
      'total=$_deduplicationSkipsCount',
    );

    _track(
      'sync_dedup_skip',
      <String, dynamic>{
        'phase': phase.wireValue,
        if (assetId != null) 'assetId': assetId,
        'total': _deduplicationSkipsCount,
      },
    );
  }

  /// Registra que se bypaseó la deduplicación por override.isLocked.
  ///
  /// Ojo:
  /// - esto NO implica write exitoso.
  /// - esto NO bypasea OCC.
  /// - solo indica que NO se aplicó el atajo de dedup.
  void recordOverrideLockedDedupBypass({
    required String assetId,
    String? domain,
  }) {
    _debugLog(
      'override_locked_dedup_bypass '
      'asset=$assetId '
      'domain=${domain ?? "-"}',
    );

    _track(
      'sync_override_locked_dedup_bypass',
      <String, dynamic>{
        'assetId': assetId,
        if (domain != null) 'domain': domain,
      },
    );
  }

  /// Registra un audit event escrito directamente a Firestore.
  void recordAuditEventWritten({String? eventType}) {
    _auditEventsWrittenCount++;

    _debugLog(
      'audit_written '
      'eventType=${eventType ?? "-"} '
      'total=$_auditEventsWrittenCount',
    );

    _track(
      'sync_audit_written',
      <String, dynamic>{
        if (eventType != null) 'eventType': eventType,
        'total': _auditEventsWrittenCount,
      },
    );
  }

  /// Registra un audit event encolado en outbox.
  void recordAuditEventBatched({String? eventType}) {
    _auditEventsBatchedCount++;

    _debugLog(
      'audit_batched '
      'eventType=${eventType ?? "-"} '
      'total=$_auditEventsBatchedCount',
    );

    _track(
      'sync_audit_batched',
      <String, dynamic>{
        if (eventType != null) 'eventType': eventType,
        'total': _auditEventsBatchedCount,
      },
    );
  }

  /// Registra un retry del archive service.
  void recordHistoryRetry({
    required String assetId,
    required String domain,
    int? attempt,
  }) {
    _historyRetryCount++;

    _debugLog(
      'history_retry '
      'asset=$assetId '
      'domain=$domain '
      'attempt=${attempt ?? "-"} '
      'total=$_historyRetryCount',
    );

    _track(
      'sync_history_retry',
      <String, dynamic>{
        'assetId': assetId,
        'domain': domain,
        if (attempt != null) 'attempt': attempt,
        'total': _historyRetryCount,
      },
    );
  }

  /// Registra éxito definitivo de archive.
  void recordArchiveSuccess({
    required String assetId,
    required String domain,
  }) {
    _archiveSuccessCount++;

    _debugLog(
      'archive_success '
      'asset=$assetId '
      'domain=$domain '
      'total=$_archiveSuccessCount',
    );

    _track(
      'sync_archive_success',
      <String, dynamic>{
        'assetId': assetId,
        'domain': domain,
        'total': _archiveSuccessCount,
      },
    );
  }

  /// Registra fallo definitivo de archive.
  void recordArchiveFailure({
    required String assetId,
    required String domain,
    SyncArchiveFailureReason reason = SyncArchiveFailureReason.unknown,
    String? errorCode,
  }) {
    _archiveFailureCount++;

    _debugLog(
      'archive_failure '
      'asset=$assetId '
      'domain=$domain '
      'reason=${reason.wireValue} '
      'errorCode=${errorCode ?? "-"} '
      'total=$_archiveFailureCount',
    );

    _track(
      'sync_archive_failure',
      <String, dynamic>{
        'assetId': assetId,
        'domain': domain,
        'reason': reason.wireValue,
        if (errorCode != null) 'errorCode': errorCode,
        'total': _archiveFailureCount,
      },
    );
  }

  /// Registra fallo definitivo del reconciliation worker tras agotar retries.
  ///
  /// Distinto de [recordArchiveFailure]: ese registra fallos por domain;
  /// este registra que el worker agotó los 3 intentos y emitió
  /// `history_reconciliation_failed`. Estado final: FAILED_RETRY.
  void recordHistoryReconciliationFailed({
    required String assetId,
    required String domain,
  }) {
    _historyReconciliationFailedCount++;

    _debugLog(
      'history_reconciliation_failed '
      'asset=$assetId '
      'domain=$domain '
      'total=$_historyReconciliationFailedCount',
    );

    _track(
      'sync_history_reconciliation_failed',
      <String, dynamic>{
        'assetId': assetId,
        'domain': domain,
        'total': _historyReconciliationFailedCount,
      },
    );
  }

  /// Registra oversize de archivableFragments.
  void recordArchivableFragmentsOversized({
    required String assetId,
    required String domain,
    required int sizeBytes,
  }) {
    _archivableFragmentsOversizedCount++;

    _debugLog(
      'archivable_fragments_oversized '
      'asset=$assetId '
      'domain=$domain '
      'sizeBytes=$sizeBytes '
      'total=$_archivableFragmentsOversizedCount',
    );

    _track(
      'sync_archivable_oversized',
      <String, dynamic>{
        'assetId': assetId,
        'domain': domain,
        'sizeBytes': sizeBytes,
        'total': _archivableFragmentsOversizedCount,
      },
    );
  }

  /// Registra cuántos activos pendientes reales encontró el worker.
  void recordPendingHistoryDetected({
    required int count,
  }) {
    final int safeCount = count < 0 ? 0 : count;
    _pendingHistoryDetectedCount += safeCount;

    _debugLog(
      'pending_history_detected '
      'count=$safeCount '
      'total=$_pendingHistoryDetectedCount',
    );

    _track(
      'sync_pending_history_detected',
      <String, dynamic>{
        'count': safeCount,
        'total': _pendingHistoryDetectedCount,
      },
    );
  }

  /// Registra que el worker salió por throttle o backoff.
  void recordWorkerSkip({
    required SyncWorkerSkipReason reason,
    String? assetId,
  }) {
    switch (reason) {
      case SyncWorkerSkipReason.globalThrottle:
        _workerGlobalThrottleSkipsCount++;
        break;
      case SyncWorkerSkipReason.perAssetBackoff:
        _workerPerAssetBackoffSkipsCount++;
        break;
      case SyncWorkerSkipReason.noPendingWork:
        _workerNoPendingWorkSkipsCount++;
        break;
    }

    _debugLog(
      'worker_skip '
      'reason=${reason.wireValue} '
      'asset=${assetId ?? "-"} '
      'globalThrottle=$_workerGlobalThrottleSkipsCount '
      'perAssetBackoff=$_workerPerAssetBackoffSkipsCount '
      'noPendingWork=$_workerNoPendingWorkSkipsCount',
    );

    _track(
      'sync_worker_skip',
      <String, dynamic>{
        'reason': reason.wireValue,
        if (assetId != null) 'assetId': assetId,
        'globalThrottleCount': _workerGlobalThrottleSkipsCount,
        'perAssetBackoffCount': _workerPerAssetBackoffSkipsCount,
        'noPendingWorkCount': _workerNoPendingWorkSkipsCount,
      },
    );
  }

  /// Registra el tamaño serializado del documento Firestore.
  ///
  /// Mantiene:
  /// - último tamaño observado
  /// - tamaño máximo observado
  /// - promedio acumulado
  /// - contador de warnings por encima del umbral operativo
  void recordFirestoreDocumentSizeBytes({
    required String assetId,
    required int sizeBytes,
  }) {
    final int safeSizeBytes = sizeBytes < 0 ? 0 : sizeBytes;

    _lastFirestoreDocumentSizeBytes = safeSizeBytes;
    _firestoreDocumentSamples++;
    _totalFirestoreDocumentBytes += safeSizeBytes;

    if (safeSizeBytes > _maxFirestoreDocumentSizeBytes) {
      _maxFirestoreDocumentSizeBytes = safeSizeBytes;
    }

    _debugLog(
      'firestore_document_size '
      'asset=$assetId '
      'sizeBytes=$safeSizeBytes '
      'avg=${firestoreDocumentSizeAvg.toStringAsFixed(1)} '
      'max=$_maxFirestoreDocumentSizeBytes',
    );

    if (safeSizeBytes > _kFirestoreDocumentWarningBytes) {
      _firestoreDocumentWarningCount++;

      _track(
        'sync_firestore_document_warning',
        <String, dynamic>{
          'assetId': assetId,
          'sizeBytes': safeSizeBytes,
          'avgSizeBytes': firestoreDocumentSizeAvg,
          'maxSizeBytes': _maxFirestoreDocumentSizeBytes,
          'warningThresholdBytes': _kFirestoreDocumentWarningBytes,
          'warningCount': _firestoreDocumentWarningCount,
        },
      );
    }
  }

  /// Registra estadísticas agregadas de batch.
  ///
  /// Además de lo mínimo operativo, incluye señales reales del pipeline:
  /// - dedupSkipped
  /// - occConflicts
  /// - deadLetters
  /// - legacyProcessed
  ///
  /// Todos los inputs se clamped a cero para robustez defensiva.
  ///
  /// Asserts semánticos (solo en debug):
  /// - No-negatividad de todos los campos.
  /// - pushed y retried no pueden superar eligible.
  /// - Guardrail operativo: dedupSkipped + pushed + occConflicts + deadLetters
  ///   no puede superar eligible. No es contabilidad perfecta universal —
  ///   legacyProcessed y retried viven fuera de este conjunto.
  void recordBatchStats({
    required int eligible,
    required int pushed,
    required int retried,
    int dedupSkipped = 0,
    int occConflicts = 0,
    int deadLetters = 0,
    int legacyProcessed = 0,
  }) {
    assert(eligible >= 0, 'eligible must be non-negative, got $eligible');
    assert(pushed >= 0, 'pushed must be non-negative, got $pushed');
    assert(retried >= 0, 'retried must be non-negative, got $retried');
    assert(dedupSkipped >= 0,
        'dedupSkipped must be non-negative, got $dedupSkipped');
    assert(occConflicts >= 0,
        'occConflicts must be non-negative, got $occConflicts');
    assert(
        deadLetters >= 0, 'deadLetters must be non-negative, got $deadLetters');
    assert(legacyProcessed >= 0,
        'legacyProcessed must be non-negative, got $legacyProcessed');
    assert(
      pushed <= eligible,
      'pushed ($pushed) cannot exceed eligible ($eligible)',
    );
    assert(
      retried <= eligible,
      'retried ($retried) cannot exceed eligible ($eligible)',
    );
    assert(
      dedupSkipped + pushed + occConflicts + deadLetters <= eligible,
      'guardrail operativo: dedupSkipped=$dedupSkipped + pushed=$pushed + '
      'occConflicts=$occConflicts + deadLetters=$deadLetters '
      'supera eligible ($eligible)',
    );

    final int safeEligible = eligible < 0 ? 0 : eligible;
    final int safePushed = pushed < 0 ? 0 : pushed;
    final int safeRetried = retried < 0 ? 0 : retried;
    final int safeDedupSkipped = dedupSkipped < 0 ? 0 : dedupSkipped;
    final int safeOccConflicts = occConflicts < 0 ? 0 : occConflicts;
    final int safeDeadLetters = deadLetters < 0 ? 0 : deadLetters;
    final int safeLegacyProcessed = legacyProcessed < 0 ? 0 : legacyProcessed;

    _batchesProcessed++;
    _totalEligible += safeEligible;
    _totalPushed += safePushed;
    _totalRetried += safeRetried;
    _totalDedupSkippedInBatches += safeDedupSkipped;
    _totalOccConflictsInBatches += safeOccConflicts;
    _totalDeadLettersInBatches += safeDeadLetters;
    _totalLegacyProcessedInBatches += safeLegacyProcessed;

    final double retryRate =
        safeEligible == 0 ? 0 : (safeRetried / safeEligible) * 100.0;

    _debugLog(
      'batch_stats '
      'eligible=$safeEligible '
      'pushed=$safePushed '
      'retried=$safeRetried '
      'dedupSkipped=$safeDedupSkipped '
      'occConflicts=$safeOccConflicts '
      'deadLetters=$safeDeadLetters '
      'legacyProcessed=$safeLegacyProcessed '
      'retryRate=${retryRate.toStringAsFixed(1)}% '
      'batchAvg=${batchSizeAvg.toStringAsFixed(1)} '
      'cumulativeRetryRate=${cumulativeSyncRetryRate.toStringAsFixed(1)}%',
    );

    _track(
      'sync_batch_stats',
      <String, dynamic>{
        'eligible': safeEligible,
        'pushed': safePushed,
        'retried': safeRetried,
        'dedupSkipped': safeDedupSkipped,
        'occConflicts': safeOccConflicts,
        'deadLetters': safeDeadLetters,
        'legacyProcessed': safeLegacyProcessed,
        'retryRate': retryRate,
        'batchAvg': batchSizeAvg,
        'cumulativeRetryRate': cumulativeSyncRetryRate,
      },
    );

    if (retryRate > _kHighRetryRateWarningPercent) {
      _track(
        'sync_high_retry_rate',
        <String, dynamic>{
          'eligible': safeEligible,
          'pushed': safePushed,
          'retried': safeRetried,
          'retryRate': retryRate,
          'threshold': _kHighRetryRateWarningPercent,
        },
      );
    }
  }

  // ==========================================================================
  // ENTRY SKIPS GRANULARES
  // ==========================================================================

  /// Registra un skip por dispatcher detenido cooperativamente.
  ///
  /// Ocurre cuando [_running] == false al inicio de [_processEntry].
  void recordStoppedSkip() {
    _entrySkippedStoppedCount++;
    _debugLog('entry_skip reason=stopped');
    // No se emite a Analytics: evento de ciclo de vida normal, no operativo.
  }

  /// Registra un skip por lease no adquirido.
  ///
  /// Indica contención concurrente — otro proceso ya está procesando la entry.
  void recordLeaseSkip({String? assetId}) {
    _entrySkippedLeaseCount++;
    _debugLog('entry_skip reason=lease_not_acquired assetId=${assetId ?? '-'}');
    _track('sync_entry_skip_lease', <String, dynamic>{
      if (assetId != null) 'assetId': assetId,
    });
  }

  // ==========================================================================
  // DISPATCH LOOP ERRORS
  // ==========================================================================

  /// Registra un error inesperado en el loop principal del dispatcher.
  ///
  /// Este evento cubre errores que escapan de _dispatchBatch() y son
  /// capturados por el catch defensivo de _runOnce(). En debug → debugPrint.
  /// En release → Firebase Analytics para visibilidad operativa.
  void recordDispatchLoopError({required String reason}) {
    _debugLog('dispatch_loop_error reason=$reason');
    _track('sync_dispatch_loop_error', <String, dynamic>{'reason': reason});
  }

  // ==========================================================================
  // SNAPSHOT / RESET
  // ==========================================================================

  /// Retorna snapshot tipado de todas las métricas acumuladas.
  SyncTelemetrySnapshot snapshot() {
    return SyncTelemetrySnapshot(
      occConflictsCount: _occConflictsCount,
      occConflictsByType: Map<String, int>.from(_occConflictsByType),
      deduplicationSkipsCount: _deduplicationSkipsCount,
      deduplicationSkipsByPhase:
          Map<String, int>.from(_deduplicationSkipsByPhase),
      auditEventsWrittenCount: _auditEventsWrittenCount,
      auditEventsBatchedCount: _auditEventsBatchedCount,
      historyRetryCount: _historyRetryCount,
      archiveSuccessCount: _archiveSuccessCount,
      archiveFailureCount: _archiveFailureCount,
      historyReconciliationFailedCount: _historyReconciliationFailedCount,
      archivableFragmentsOversizedCount: _archivableFragmentsOversizedCount,
      workerGlobalThrottleSkipsCount: _workerGlobalThrottleSkipsCount,
      workerPerAssetBackoffSkipsCount: _workerPerAssetBackoffSkipsCount,
      workerNoPendingWorkSkipsCount: _workerNoPendingWorkSkipsCount,
      pendingHistoryDetectedCount: _pendingHistoryDetectedCount,
      lastFirestoreDocumentSizeBytes: _lastFirestoreDocumentSizeBytes,
      maxFirestoreDocumentSizeBytes: _maxFirestoreDocumentSizeBytes,
      firestoreDocumentWarningCount: _firestoreDocumentWarningCount,
      firestoreDocumentSamples: _firestoreDocumentSamples,
      totalFirestoreDocumentBytes: _totalFirestoreDocumentBytes,
      batchesProcessed: _batchesProcessed,
      totalEligible: _totalEligible,
      totalPushed: _totalPushed,
      totalRetried: _totalRetried,
      totalDedupSkippedInBatches: _totalDedupSkippedInBatches,
      totalOccConflictsInBatches: _totalOccConflictsInBatches,
      totalDeadLettersInBatches: _totalDeadLettersInBatches,
      totalLegacyProcessedInBatches: _totalLegacyProcessedInBatches,
      entrySkippedStoppedCount: _entrySkippedStoppedCount,
      entrySkippedLeaseCount: _entrySkippedLeaseCount,
    );
  }

  /// Resetea métricas en memoria.
  ///
  /// Útil para tests o benchmarks controlados.
  void reset() {
    _occConflictsCount = 0;
    _occConflictsByType.clear();

    _deduplicationSkipsCount = 0;
    _deduplicationSkipsByPhase.clear();

    _auditEventsWrittenCount = 0;
    _auditEventsBatchedCount = 0;

    _historyRetryCount = 0;
    _archiveSuccessCount = 0;
    _archiveFailureCount = 0;
    _historyReconciliationFailedCount = 0;

    _archivableFragmentsOversizedCount = 0;

    _workerGlobalThrottleSkipsCount = 0;
    _workerPerAssetBackoffSkipsCount = 0;
    _workerNoPendingWorkSkipsCount = 0;
    _pendingHistoryDetectedCount = 0;

    _lastFirestoreDocumentSizeBytes = 0;
    _maxFirestoreDocumentSizeBytes = 0;
    _firestoreDocumentWarningCount = 0;
    _firestoreDocumentSamples = 0;
    _totalFirestoreDocumentBytes = 0;

    _batchesProcessed = 0;
    _totalEligible = 0;
    _totalPushed = 0;
    _totalRetried = 0;
    _totalDedupSkippedInBatches = 0;
    _totalOccConflictsInBatches = 0;
    _totalDeadLettersInBatches = 0;
    _totalLegacyProcessedInBatches = 0;

    _entrySkippedStoppedCount = 0;
    _entrySkippedLeaseCount = 0;

    _debugLog('reset');
  }

  // ==========================================================================
  // HELPERS INTERNOS
  // ==========================================================================

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[SyncTelemetry] $message');
    }
  }

  /// Emisión best-effort.
  ///
  /// REGLA:
  /// - Solo fuera de debug. En profile y release sí emite.
  /// - Nunca propaga excepción.
  /// - Nunca debe romper el sync pipeline.
  void _track(String event, Map<String, dynamic> props) {
    if (kDebugMode) return;

    try {
      Analytics.track(event, _sanitizeProps(props));
    } catch (_) {
      // Silencio intencional.
      // La telemetría NO puede romper el hot path del sync.
    }
  }

  Map<String, dynamic> _sanitizeProps(Map<String, dynamic> props) {
    final Map<String, dynamic> sanitized = <String, dynamic>{};

    props.forEach((String key, dynamic value) {
      sanitized[key] = _sanitizeValue(value);
    });

    return sanitized;
  }

  dynamic _sanitizeValue(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return _truncate(value);
    }

    if (value is num || value is bool) {
      return value;
    }

    // Evitar mandar listas/maps arbitrarios al backend de analytics.
    if (value is List || value is Map || value is Set) {
      return _truncate(value.toString());
    }

    // Usa el .name builtin de Dart (camelCase del member) como fallback seguro.
    // Los enums contractuales del service nunca llegan aquí — siempre se pasan
    // ya convertidos a su .wireValue antes de llamar a _track().
    if (value is Enum) {
      return _truncate(value.name);
    }

    return _truncate(value.toString());
  }

  String _truncate(String input) {
    if (input.length <= _kMaxTrackedStringLength) return input;
    return input.substring(0, _kMaxTrackedStringLength);
  }
}
