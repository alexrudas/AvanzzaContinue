// ============================================================================
// lib/data/sync/asset_sync_dispatcher.dart
// ASSET SYNC DISPATCHER — Orquestador específico para activos vehiculares
//
// QUÉ HACE:
// - Lee entradas del outbox con partitionKey 'vehicle:{assetId}'.
// - Aplica coalescing: por cada partitionKey mantiene SOLO la más reciente.
// - Marca entradas supersedidas como completed (ahorro de escrituras).
// - Empuja el payload a Firestore según el schema de la entry:
//     · schemaVersion=1 (legacy):  set(merge:true) directo.
//     · schemaVersion=2 (v1.3.4):  dedup pre-check → OCC (si aplica) → write
//       → _triggerArchivePostWrite().
// - Dedup pre-check (v1.3.4): compara payloadHash con Firestore antes de write.
// - OCC (v1.3.4): runTransaction() para domains compliance/legal en
//   domainsTouched. Dentro de transaction: hash PRIMERO, versiones DESPUÉS.
// - _triggerArchivePostWrite(): lanza archive async con captura total de
//   excepciones. NUNCA usa unawaited() crudo fuera de este método.
// - Llama AssetSyncService.markAsApplied() para cerrar el ciclo anti-ping-pong.
// - Retry con exponential backoff propio: 2s → 5s → 10s → 30s → 60s (cap).
// - Lifecycle: start() / stop() / triggerNow(). Idempotente y thread-safe.
// - Máximo [_maxConcurrency] pushes simultáneos (uno por asset).
//
// QUÉ NO HACE:
// - No toca entradas con partitionKey != 'vehicle:*'.
// - No duplica la lógica genérica de SyncEngineService/SyncDispatcher.
// - No modifica el esquema del outbox ni del modelo Isar.
// - No propaga excepciones al caller.
// - No bloquea la UI.
// - No recalcula payloadHash.
// - No reconstruye governance desde metadata (solo lee payload.governance).
//
// PRINCIPIOS:
// - Coalescing por partitionKey antes de push → reduce writes redundantes.
// - Lease por winner → previene doble-push con el SyncEngineService genérico.
// - Payload limpio del outbox → no contamina Firestore con campos Isar.
// - markAsApplied() → fingerprint in-memory actualizado post-push exitoso.
// - Aislamiento total de errores: todos los catch son internos.
// - Stop cooperativo: si el dispatcher se detiene, no inicia trabajo nuevo.
// - Orden OCC (inamovible): hash (dedup tardía) PRIMERO, versiones DESPUÉS.
//   Invertir genera conflictos falsos sobre payloads idénticos.
//
// ENTERPRISE NOTES:
// CREADO: Fase 3 — asset sync pipeline.
// EXTENDIDO (2026-03): Fase 5 — OCC, dedup, archive, telemetry (v1.3.4).
// - COEXISTENCIA CON SyncEngineService:
//   Ambos leen del mismo SyncOutboxRepository. El lease locking garantiza que
//   solo uno procesa cada entry.
// - PAYLOAD vs MODEL.toJson():
//   Este dispatcher empuja entry.payload directamente a Firestore para evitar
//   contaminar con isarId u otros campos locales.
// - BACKOFF PROPIO:
//   Tabla específica para writes vehiculares ligeras: 2s/5s/10s/30s/60s.
// ============================================================================

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../core/telemetry/sync_telemetry.dart';
import '../../domain/entities/sync/sync_outbox_entry.dart';
import '../../domain/repositories/sync_outbox_repository.dart';
import '../sources/remote/asset_remote_ds.dart';
import 'asset_firestore_adapter.dart';
import 'asset_history_archive_service.dart';
import 'asset_history_reconciliation_worker.dart';
import 'asset_sync_models.dart';
import 'asset_sync_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// REPORT — MÉTRICAS INMUTABLES POR BATCH
// ─────────────────────────────────────────────────────────────────────────────

class AssetDispatchReport {
  final int eligible;
  final int coalesced;
  final int superseded;
  final int pushed;
  final int retried;
  final int deadLettered;

  /// Entries saltadas porque el dispatcher se detuvo cooperativamente.
  final int skippedStopped;

  /// Entries saltadas porque el lease no pudo adquirirse (contención).
  final int skippedLease;

  /// Entries saltadas por deduplicación (hash igual en Firestore).
  final int skippedDedup;

  const AssetDispatchReport({
    required this.eligible,
    required this.coalesced,
    required this.superseded,
    required this.pushed,
    required this.retried,
    required this.deadLettered,
    required this.skippedStopped,
    required this.skippedLease,
    required this.skippedDedup,
  });

  const AssetDispatchReport.empty()
      : eligible = 0,
        coalesced = 0,
        superseded = 0,
        pushed = 0,
        retried = 0,
        deadLettered = 0,
        skippedStopped = 0,
        skippedLease = 0,
        skippedDedup = 0;

  /// Total de entries saltadas (todas las razones combinadas).
  int get skipped => skippedStopped + skippedLease + skippedDedup;

  bool get hadWork => eligible > 0;

  @override
  String toString() => 'AssetDispatchReport('
      'eligible:$eligible '
      'coalesced:$coalesced '
      'superseded:$superseded '
      'pushed:$pushed '
      'retried:$retried '
      'dead:$deadLettered '
      'skippedStopped:$skippedStopped '
      'skippedLease:$skippedLease '
      'skippedDedup:$skippedDedup)';
}

// ─────────────────────────────────────────────────────────────────────────────
// DISPATCHER
// ─────────────────────────────────────────────────────────────────────────────

class AssetSyncDispatcher {
  final SyncOutboxRepository _outboxRepo;
  final AssetRemoteDataSource _remoteDs;
  final AssetSyncService _syncService;
  final AssetFirestoreAdapter _adapter;

  // Fase 5 — v1.3.4 services
  final AssetHistoryArchiveService _archiveService;
  final AssetHistoryReconciliationWorker _reconciliationWorker;
  final SyncTelemetry _telemetry;

  // ── Configuración ──────────────────────────────────────────────────────────

  static const _vehiclePartitionPrefix = 'vehicle:';
  static const _firestoreCollection = 'asset_vehiculo';
  static const _workerId = 'asset_sync_dispatcher';

  /// Máximo de entries elegibles leídas por ciclo antes de coalescing.
  static const _batchLimit = 100;

  /// Máximo de winners procesados en un solo ciclo.
  /// Evita ciclos demasiado largos cuando hay muchos assets distintos.
  static const _maxWinnersPerCycle = 20;

  static const _leaseDuration = Duration(minutes: 2);
  static const _maxConcurrency = 4;
  static const _pollingInterval = Duration(seconds: 30);

  static const _backoffTable = [
    Duration(seconds: 2),
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 30),
    Duration(seconds: 60),
  ];

  /// Domains que participan en OCC via runTransaction().
  /// Solo compliance y legal tienen versionado semántico en este schema.
  static const _kOccDomains = {'compliance', 'legal'};

  // ── Estado ─────────────────────────────────────────────────────────────────

  bool _running = false;
  bool _processing = false;

  /// Si llega trigger mientras _processing == true, queda marcado y al terminar
  /// el ciclo actual se ejecuta uno adicional inmediatamente.
  bool _runRequested = false;

  Timer? _timer;

  AssetSyncDispatcher({
    required SyncOutboxRepository outboxRepo,
    required AssetRemoteDataSource remoteDs,
    required AssetSyncService syncService,
    required AssetFirestoreAdapter adapter,
    required AssetHistoryArchiveService archiveService,
    required AssetHistoryReconciliationWorker reconciliationWorker,
    required SyncTelemetry telemetry,
  })  : _outboxRepo = outboxRepo,
        _remoteDs = remoteDs,
        _syncService = syncService,
        _adapter = adapter,
        _archiveService = archiveService,
        _reconciliationWorker = reconciliationWorker,
        _telemetry = telemetry;

  // ==========================================================================
  // TEST SEAM — solo para tests unitarios de dispatcher
  // ==========================================================================

  /// Ejecuta exactamente un ciclo de dispatch y retorna el reporte.
  ///
  /// SOLO para tests. Elimina la necesidad de `start()` + timer en pruebas
  /// unitarias de lógica de dispatch (evita mezclar scheduler y dispatcher).
  ///
  /// Contrato: setea `_running = true` antes del ciclo y lo restaura a
  /// `false` en finally — el dispatcher no queda arrancado después de la llamada.
  @visibleForTesting
  Future<AssetDispatchReport> runBatchForTest() async {
    _running = true;
    try {
      return await _dispatchBatch();
    } finally {
      _running = false;
    }
  }

  // ==========================================================================
  // LIFECYCLE
  // ==========================================================================

  void start() {
    if (_running) return;
    _running = true;

    _timer = Timer.periodic(
      _pollingInterval,
      (_) => _tryRun(),
    );

    _tryRun();

    _debugLog('start() — polling cada ${_pollingInterval.inSeconds}s');
  }

  void stop() {
    if (!_running) return;
    _running = false;
    _timer?.cancel();
    _timer = null;
    _debugLog('stop()');
  }

  void triggerNow() {
    _debugLog('triggerNow()');
    _tryRun();
  }

  // ==========================================================================
  // LOOP CONTROLADO
  // ==========================================================================

  void _tryRun() {
    if (!_running) return;

    if (_processing) {
      _runRequested = true;
      return;
    }

    unawaited(_runOnce());
  }

  Future<void> _runOnce() async {
    if (_processing) return;
    _processing = true;

    try {
      do {
        _runRequested = false;

        if (!_running) break;

        final report = await _dispatchBatch();

        if (report.hadWork) {
          _telemetry.recordBatchStats(
            eligible: report.eligible,
            pushed: report.pushed,
            retried: report.retried,
            deadLetters: report.deadLettered,
            dedupSkipped: report.skippedDedup,
          );
          if (kDebugMode) _debugLog(report.toString());
        }
      } while (_running && _runRequested);
    } catch (e) {
      // Catch defensivo: protege el loop de crashear por errores inesperados.
      // _debugLog es no-op en release → telemetría obligatoria para visibilidad.
      _debugLog('_runOnce ERROR: $e');
      _telemetry.recordDispatchLoopError(reason: e.toString());
    } finally {
      _processing = false;
    }
  }

  // ==========================================================================
  // DISPATCH BATCH — ORQUESTACIÓN PRINCIPAL
  // ==========================================================================

  Future<AssetDispatchReport> _dispatchBatch() async {
    if (!_running) return const AssetDispatchReport.empty();

    final now = DateTime.now().toUtc();

    // Reconciliation worker: recovery durable de history pendiente.
    // Blindado explícitamente aquí: aunque el worker garantice aislamiento
    // interno, el contrato debe estar defendido en el punto de llamada.
    // Si el worker propaga, el batch continúa y la telemetría registra el fallo.
    try {
      await _reconciliationWorker.runIfNeeded(nowUtc: now);
    } catch (e) {
      _debugLog('reconciliationWorker.runIfNeeded ERROR (non-blocking): $e');
      _telemetry.recordDispatchLoopError(
        reason: 'reconciliationWorker.runIfNeeded: $e',
      );
    }

    final all = await _outboxRepo.findEligible(now: now, limit: _batchLimit);
    if (!_running) return const AssetDispatchReport.empty();

    final vehicleEntries = all
        .where((e) => e.partitionKey.startsWith(_vehiclePartitionPrefix))
        .toList();

    if (vehicleEntries.isEmpty) return const AssetDispatchReport.empty();

    _debugLog('elegibles: ${vehicleEntries.length}');

    final winners = _coalescedByPartition(vehicleEntries);
    final limitedWinners = winners.take(_maxWinnersPerCycle).toList();

    final winnerIds = {for (final e in limitedWinners) e.id};

    final superseded = vehicleEntries.where((e) {
      // Supersedidas solo dentro del subconjunto efectivamente ganado por ciclo.
      if (winnerIds.contains(e.id)) return false;
      return limitedWinners.any((w) => w.partitionKey == e.partitionKey);
    }).toList();

    final supersededCount = await _markSuperseded(superseded, now);
    if (!_running) {
      return AssetDispatchReport(
        eligible: vehicleEntries.length,
        coalesced: limitedWinners.length,
        superseded: supersededCount,
        pushed: 0,
        retried: 0,
        deadLettered: 0,
        skippedStopped: 0,
        skippedLease: 0,
        skippedDedup: 0,
      );
    }

    final results = await _processWithConcurrency(limitedWinners, now);

    return AssetDispatchReport(
      eligible: vehicleEntries.length,
      coalesced: limitedWinners.length,
      superseded: supersededCount,
      pushed: results.where((r) => r == _EntryResult.pushed).length,
      retried: results.where((r) => r == _EntryResult.retried).length,
      // stateUnknown se agrega a deadLettered: no fue pushed ni retried
      // correctamente — es la aproximación conservadora más honesta.
      deadLettered: results
          .where((r) =>
              r == _EntryResult.deadLettered || r == _EntryResult.stateUnknown)
          .length,
      skippedStopped:
          results.where((r) => r == _EntryResult.skippedStopped).length,
      skippedLease: results.where((r) => r == _EntryResult.skippedLease).length,
      skippedDedup: results.where((r) => r == _EntryResult.skippedDedup).length,
    );
  }

  // ==========================================================================
  // COALESCING
  // ==========================================================================

  List<SyncOutboxEntry> _coalescedByPartition(List<SyncOutboxEntry> entries) {
    final latest = <String, SyncOutboxEntry>{};

    for (final entry in entries) {
      final current = latest[entry.partitionKey];

      if (current == null) {
        latest[entry.partitionKey] = entry;
        continue;
      }

      final isNewer = entry.createdAt.isAfter(current.createdAt) ||
          (entry.createdAt.isAtSameMomentAs(current.createdAt) &&
              entry.idempotencyKey.compareTo(current.idempotencyKey) > 0);

      if (isNewer) {
        latest[entry.partitionKey] = entry;
      }
    }

    final result = latest.values.toList();

    if (kDebugMode && entries.length > result.length) {
      _debugLog(
        'coalescing: ${entries.length} → ${result.length} '
        '(${entries.length - result.length} supersedidas)',
      );
    }

    return result;
  }

  // ==========================================================================
  // SUPERSEDED — LIMPIEZA INMEDIATA
  // ==========================================================================

  Future<int> _markSuperseded(
    List<SyncOutboxEntry> superseded,
    DateTime now,
  ) async {
    var count = 0;

    for (final entry in superseded) {
      if (!_running) break;

      try {
        await _outboxRepo.markCompleted(entryId: entry.id, now: now);
        count++;
        _debugLog(
          'superseded completed: ${entry.id} '
          '(partitionKey: ${entry.partitionKey})',
        );
      } catch (e) {
        _debugLog('superseded markCompleted ERROR (${entry.id}): $e');
      }
    }

    return count;
  }

  // ==========================================================================
  // CONCURRENCIA — PROCESAMIENTO DE WINNERS
  // ==========================================================================

  Future<List<_EntryResult>> _processWithConcurrency(
    List<SyncOutboxEntry> winners,
    DateTime now,
  ) async {
    final results = <_EntryResult>[];
    final chunks = _chunked(winners, _maxConcurrency);

    for (final chunk in chunks) {
      if (!_running) break;

      final chunkResults = await Future.wait(
        chunk.map((entry) => _processEntry(entry, now)),
      );

      results.addAll(chunkResults);
    }

    return results;
  }

  // ==========================================================================
  // ENTRY PROCESSING — FLUJO PRINCIPAL
  // ==========================================================================

  Future<_EntryResult> _processEntry(
    SyncOutboxEntry entry,
    DateTime now,
  ) async {
    if (!_running) {
      _telemetry.recordStoppedSkip();
      return _EntryResult.skippedStopped;
    }

    final leased = await _safeAcquireLease(entry, now);
    if (!leased) {
      final assetId = _assetIdFromPartitionKey(entry.partitionKey);
      _telemetry.recordLeaseSkip(assetId: assetId);
      _debugLog('skip (lease no adquirido): ${entry.id}');
      return _EntryResult.skippedLease;
    }

    try {
      if (!_running) return _EntryResult.skippedStopped;

      final assetId = _assetIdFromPartitionKey(entry.partitionKey);
      if (assetId == null) {
        await _moveToDeadLetter(
          entry: entry,
          now: now,
          reason: 'partitionKey inválido: "${entry.partitionKey}"',
        );
        return _EntryResult.deadLettered;
      }

      // Branch: v1.3.4 (schemaVersion=2, payloadHash en metadata) vs legacy.
      if (_isV2Entry(entry)) {
        return await _processV2Entry(entry, assetId, now);
      }

      // ── LEGACY PATH ────────────────────────────────────────────────────────

      // Guardrails de payload antes del push.
      if (entry.payload.isEmpty) {
        await _moveToDeadLetter(
          entry: entry,
          now: now,
          reason: 'payload vacío',
        );
        return _EntryResult.deadLettered;
      }

      final payloadAssetId = entry.payload['assetId']?.toString().trim();
      if (payloadAssetId == null || payloadAssetId.isEmpty) {
        await _moveToDeadLetter(
          entry: entry,
          now: now,
          reason: 'payload sin assetId',
        );
        return _EntryResult.deadLettered;
      }

      if (payloadAssetId != assetId) {
        await _moveToDeadLetter(
          entry: entry,
          now: now,
          reason:
              'assetId inconsistente entre partitionKey ($assetId) y payload ($payloadAssetId)',
        );
        return _EntryResult.deadLettered;
      }

      _adapter.assertPayloadIsJsonSafe(entry.payload);

      if (!_running) return _EntryResult.skippedStopped;

      await _remoteDs.db
          .collection(_firestoreCollection)
          .doc(assetId)
          .set(entry.payload, SetOptions(merge: true));

      if (!_running) return _EntryResult.skippedStopped;

      // Push exitoso. Actualizar fingerprint para cerrar ciclo anti-ping-pong.
      // Si fromFirestoreMap falla: el dato YA está en Firestore; NO reintentar.
      // El error se eleva como [ERROR] visible (no silencioso). El siguiente
      // ciclo pullFromRemote() reconciliará el fingerprint vía SyncOrigin.remote.
      try {
        final model = _adapter.fromFirestoreMap(assetId, entry.payload);
        _syncService.markAsApplied(
          assetId: assetId,
          model: model,
          origin: SyncOrigin.local,
        );
      } on Object catch (e, st) {
        if (kDebugMode) {
          debugPrint(
            '[AssetSyncDispatcher][ERROR] markAsApplied post-push falló '
            'para assetId=$assetId: $e\n$st\n'
            '→ push completado, fingerprint desincronizado hasta próximo pull.',
          );
        }
        // No relanzar: el push ya ocurrió. Continuar a markCompleted.
      }

      if (!_running) return _EntryResult.skippedStopped;

      await _outboxRepo.markCompleted(entryId: entry.id, now: now);

      _debugLog('pushed OK: $assetId (${entry.idempotencyKey})');
      return _EntryResult.pushed;
    } catch (e) {
      _debugLog('push ERROR (${entry.id}): $e');
      return await _handleFailure(entry: entry, now: now, error: e.toString());
    } finally {
      await _safeReleaseLease(entry);
    }
  }

  // ==========================================================================
  // V1.3.4 PATH — OCC + DEDUP + ARCHIVE
  // ==========================================================================

  /// Procesa una entry v1.3.4 con dedup pre-check, OCC y archive post-write.
  ///
  /// Contrato de orden dentro de transaction (inamovible):
  ///   1. Hash check (dedup tardía) PRIMERO.
  ///   2. Version check (OCC) DESPUÉS.
  /// Invertir genera conflictos falsos sobre payloads idénticos.
  Future<_EntryResult> _processV2Entry(
    SyncOutboxEntry entry,
    String assetId,
    DateTime now,
  ) async {
    // FAIL-FAST v2: el dispatcher confía en que la queue blindó el payload,
    // pero un mínimo de defensa evita writes silenciosamente corruptos.
    if (entry.payload.isEmpty) {
      await _moveToDeadLetter(
        entry: entry,
        now: now,
        reason: 'v2: payload vacío',
      );
      return _EntryResult.deadLettered;
    }

    final entryHash = entry.metadata['payloadHash'] as String?;
    if (entryHash == null || entryHash.isEmpty) {
      await _moveToDeadLetter(
        entry: entry,
        now: now,
        reason: 'v2: payloadHash ausente o vacío en metadata',
      );
      return _EntryResult.deadLettered;
    }

    final docRef = _remoteDs.db.collection(_firestoreCollection).doc(assetId);

    // override.isLocked bypasea dedup ÚNICAMENTE (plan §8.5, regla 33).
    // OCC sigue ejecutándose normalmente — versiones se validan siempre.
    final isOverrideLocked = entry.metadata['overrideIsLocked'] == true;

    // 8. DEDUP PRE-CHECK — 1 read fuera de transaction.
    // Salteado cuando override.isLocked == true: el locked write debe llegar
    // siempre a Firestore independientemente del hash del servidor.
    if (!isOverrideLocked) {
      try {
        final serverSnap = await docRef.get();
        if (serverSnap.exists) {
          final serverHash =
              serverSnap.data()?['metadata']?['payloadHash'] as String?;
          if (serverHash != null && serverHash == entryHash) {
            await _outboxRepo.markCompleted(entryId: entry.id, now: now);
            _telemetry.recordDeduplicationSkip(
              phase: SyncDedupPhase.precheck,
              assetId: assetId,
            );
            _debugLog('dedup pre-check skip: $assetId');
            return _EntryResult.skippedDedup;
          }
        }
      } catch (e) {
        // Non-blocking: si el pre-check falla, continúa con el write normal.
        _debugLog('dedup pre-check ERROR (non-blocking): $assetId — $e');
      }
    }

    // 9. SCOPE OCC
    final domainsTouched = (entry.metadata['domainsTouched'] as List<dynamic>?)
            ?.whereType<String>()
            .toList() ??
        const <String>[];

    final occDomains = domainsTouched.where(_kOccDomains.contains).toList();

    final expectedVersions = (entry.metadata['expectedDomainVersions'] as Map?)
            ?.cast<String, dynamic>()
            .map((k, v) => MapEntry(k, (v as num?)?.toInt() ?? 0)) ??
        const <String, int>{};

    // Restaurar Timestamps para el write a Firestore.
    // safePayload en el outbox tiene ISO strings para governance timestamps.
    // Firestore requiere Timestamp para historyPendingSince (worker query).
    final firestorePayload = _restoreTimestampsForFirestore(entry.payload);

    if (occDomains.isNotEmpty) {
      // 10. OCC TRANSACTION — solo compliance/legal en domainsTouched.
      var dedupTardia = false;

      try {
        await _remoteDs.db.runTransaction((txn) async {
          final serverSnap = await txn.get(docRef);
          final serverData = serverSnap.data() ?? const <String, dynamic>{};

          // DEDUP TARDÍA — PRIMERO (contrato inamovible).
          // ⚠️ Hash check ANTES de versiones. Si se invierte, un payload
          //    idéntico lanza conflicto OCC falso.
          // Salteado cuando override.isLocked == true (plan §8.5, regla 33).
          final serverHash = serverData['metadata']?['payloadHash'] as String?;
          if (!isOverrideLocked &&
              serverHash != null &&
              serverHash == entryHash) {
            dedupTardia = true;
            return; // Transaction commits sin writes.
          }

          // OCC VERSION CHECK — DESPUÉS del hash check.
          for (final domain in occDomains) {
            final serverVersion = _domainVersion(serverData, domain);
            final expectedVersion = expectedVersions[domain] ?? 0;
            if (serverVersion > expectedVersion) {
              throw _OccConflictException(
                domain: domain,
                serverVersion: serverVersion,
                expectedVersion: expectedVersion,
                retryCount: entry.retryCount,
              );
            }
          }

          // OCC pasó — write completo con merge:true.
          //
          // CONTRATO DEL WRITE-MODEL (inamovible, plan §9.7):
          // asset_vehiculo/{assetId} es propiedad exclusiva del builder v1.3.4.
          // Ningún otro proceso escribe campos en el root de este documento.
          // Las subcollections (history/) y updates parciales de governance
          // post-archive se hacen con merge punteado por AssetHistoryArchiveService.
          //
          // merge:true protege contra campos residuales no anticipados y es
          // semánticamente equivalente a reemplazo completo dado que el builder
          // emite el documento root en su totalidad. Si en el futuro cualquier
          // otro proceso escribiera en el root → este contrato debe revisarse.
          txn.set(docRef, firestorePayload, SetOptions(merge: true));
        });
      } on _OccConflictException catch (e) {
        _telemetry.recordOccConflict(
          e.conflictType,
          assetId: assetId,
          domain: e.domain,
          serverVersion: e.serverVersion,
          expectedVersion: e.expectedVersion,
        );
        _debugLog(
          'OCC conflict: $assetId '
          'domain=${e.domain} '
          'server=${e.serverVersion} '
          'expected=${e.expectedVersion} '
          'type=${e.conflictType.wireValue}',
        );
        if (e.conflictType == SyncOccConflictType.retryLoop) {
          await _moveToDeadLetter(
            entry: entry,
            now: now,
            reason: 'OCC conflict (${e.conflictType.wireValue}): ${e.domain}',
          );
          return _EntryResult.deadLettered;
        }
        return await _handleFailure(
          entry: entry,
          now: now,
          error: 'OCC conflict (${e.conflictType.wireValue}): ${e.domain}',
        );
      }

      // Dedup tardía: transaction committed empty.
      if (dedupTardia) {
        await _outboxRepo.markCompleted(entryId: entry.id, now: now);
        _telemetry.recordDeduplicationSkip(
          phase: SyncDedupPhase.transaction,
          assetId: assetId,
        );
        _debugLog('dedup tardía (transaction): $assetId');
        return _EntryResult.skippedDedup;
      }
    } else {
      // 11. Sin OCC domains — set directo para v1.3.4.
      await docRef.set(firestorePayload, SetOptions(merge: true));
    }

    // 12. POST-WRITE
    // NOTA: entry.payload ya contiene governance con historyWriteStatus=PENDING.
    // El write anterior lo persistió en Firestore. El worker puede hacer
    // recovery durable desde este momento.
    _triggerArchivePostWrite(entry, assetId);

    // Push v2 exitoso. Actualizar fingerprint anti-ping-pong.
    // Mismo contrato que path legacy: si fromFirestoreMap falla, el dato ya
    // está en Firestore. Error visible, NO retry, NO relanzar.
    // DEPENDENCIA IMPLÍCITA: fromFirestoreMap auto-detecta v1.3.4 cuando el
    // documento contiene 'domains' y delega a fromFullDocument() (plan §3).
    assert(
      firestorePayload.containsKey('domains'),
      '[AssetSyncDispatcher] markAsApplied v2: firestorePayload debe ser '
      'v1.3.4 (contener "domains") para que el adapter auto-detecte.',
    );
    try {
      final model = _adapter.fromFirestoreMap(assetId, firestorePayload);
      _syncService.markAsApplied(
        assetId: assetId,
        model: model,
        origin: SyncOrigin.local,
      );
    } on Object catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[AssetSyncDispatcher][ERROR] markAsApplied v2 post-push falló '
          'para assetId=$assetId: $e\n$st\n'
          '→ push completado, fingerprint desincronizado hasta próximo pull.',
        );
      }
      // No relanzar: el push ya ocurrió. Continuar a markCompleted.
    }

    await _outboxRepo.markCompleted(entryId: entry.id, now: now);

    _debugLog('v2 pushed OK: $assetId (${entry.idempotencyKey})');
    return _EntryResult.pushed;
  }

  // ==========================================================================
  // ARCHIVE POST-WRITE
  // ==========================================================================

  /// Lanza el archive de history de forma asíncrona y completamente aislada.
  ///
  /// - NUNCA propaga excepciones al caller.
  /// - NUNCA usar unawaited() crudo fuera de este método.
  /// - En falla: telemetría + registerPending en worker (recovery durable).
  void _triggerArchivePostWrite(
    SyncOutboxEntry entry,
    String assetId,
  ) {
    final archivableFragments =
        (entry.metadata['archivableFragments'] as Map<String, dynamic>?) ??
            const <String, dynamic>{};

    if (archivableFragments.isEmpty) return;

    // ignore: unawaited_futures
    _archiveService.archiveDomain(assetId, archivableFragments).then((result) {
      for (final domain in result.succeeded) {
        _telemetry.recordArchiveSuccess(assetId: assetId, domain: domain);
      }
      if (result.failed.isNotEmpty) {
        _debugLog(
          'archive partial failure: $assetId — failed=${result.failed}',
        );
        _reconciliationWorker.registerPending(assetId, result.failed);
      }
    }).catchError((Object e) {
      _debugLog('archive ERROR (post-write): $assetId — $e');
      // ⚠️ Usar archivableFragments.keys, NO domainsTouched.
      // domainsTouched incluye domains no archivables (e.g. financial).
      // Solo los domains con fragments reales merecen failure + pending.
      final archivableDomains = archivableFragments.keys.toList();
      for (final domain in archivableDomains) {
        _telemetry.recordArchiveFailure(
          assetId: assetId,
          domain: domain,
          reason: SyncArchiveFailureReason.unknown,
        );
      }
      _reconciliationWorker.registerPending(assetId, archivableDomains);
    });
  }

  // ==========================================================================
  // TIMESTAMP RESTORE
  // ==========================================================================

  /// Convierte campos Timestamp de governance de ISO string → Timestamp.
  ///
  /// Operación inversa de AssetSyncQueue._toOutboxSafeDocument():
  /// el outbox serializa Timestamp → ISO string (Isar no soporta Timestamp).
  /// El dispatcher debe restaurarlos antes del write a Firestore.
  ///
  /// REGISTRO OBLIGATORIO (extensibilidad):
  /// Cualquier campo Timestamp nuevo en governance.* DEBE registrarse en
  /// [_kGovernanceTimestampFields]. Omitirlo deja el campo como String en
  /// Firestore, rompiendo queries que esperen Timestamp.
  ///
  /// Campos actuales:
  /// - historyPendingSince: queryable por el reconciliation worker.
  static const Set<String> _kGovernanceTimestampFields = {
    'historyPendingSince', // Firestore Timestamp — requerido para query del worker.
  };

  static Map<String, dynamic> _restoreTimestampsForFirestore(
    Map<String, dynamic> doc,
  ) {
    final governance = doc['governance'];
    if (governance is! Map<String, dynamic>) return doc;

    var changed = false;
    final restoredGovernance = Map<String, dynamic>.from(governance);

    for (final field in _kGovernanceTimestampFields) {
      final value = governance[field];
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) {
          restoredGovernance[field] = Timestamp.fromDate(parsed.toUtc());
          changed = true;
        }
      }
    }

    if (!changed) return doc;
    return <String, dynamic>{...doc, 'governance': restoredGovernance};
  }

  // ==========================================================================
  // V2 HELPERS
  // ==========================================================================

  /// True si la entry es v1.3.4 (contiene payloadHash en metadata).
  static bool _isV2Entry(SyncOutboxEntry entry) {
    return entry.metadata.containsKey('payloadHash');
  }

  /// Lee domainVersion del documento Firestore para un domain dado.
  /// Retorna 0 si el doc es legacy (sin 'domains') o el campo no existe.
  static int _domainVersion(Map<String, dynamic> serverData, String domain) {
    final domains = serverData['domains'] as Map<String, dynamic>?;
    if (domains == null) return 0;
    final domainMap = domains[domain] as Map<String, dynamic>?;
    if (domainMap == null) return 0;
    return (domainMap['domainVersion'] as num?)?.toInt() ?? 0;
  }

  // ==========================================================================
  // FAILURE HANDLING — RETRY / DEAD LETTER
  // ==========================================================================

  Future<_EntryResult> _handleFailure({
    required SyncOutboxEntry entry,
    required DateTime now,
    required String error,
  }) async {
    try {
      if (!_running) return _EntryResult.skippedStopped;

      if (entry.retryCount >= entry.maxRetries) {
        await _moveToDeadLetter(
          entry: entry,
          now: now,
          reason:
              'Reintentos agotados (maxRetries=${entry.maxRetries}): $error',
        );
        _debugLog(
          'deadLetter: ${entry.id} '
          '(${entry.retryCount}/${entry.maxRetries} retries)',
        );
        return _EntryResult.deadLettered;
      }

      final nextRetry = entry.retryCount + 1;
      final delay = _backoffDuration(nextRetry);
      final nextAttemptAt = now.add(delay);

      await _outboxRepo.markFailed(
        entryId: entry.id,
        now: now,
        errorMessage: error,
        nextAttemptAt: nextAttemptAt,
        incrementRetry: true,
      );

      _debugLog(
        'retry $nextRetry/${entry.maxRetries}: ${entry.id} '
        '→ +${delay.inSeconds}s (${nextAttemptAt.toIso8601String()})',
      );

      return _EntryResult.retried;
    } catch (e) {
      // markFailed() o moveToDeadLetter() fallaron — estado incierto real.
      // La entry no confirmó ni retry ni dead letter en el outbox.
      // stateUnknown es semánticamente honesto; el reporte lo agrega a
      // deadLettered como aproximación conservadora (no fue pushed ni retried).
      _debugLog('handleFailure ERROR (${entry.id}): $e');
      _telemetry.recordDispatchLoopError(
        reason: 'handleFailure internal error: $e',
      );
      return _EntryResult.stateUnknown;
    }
  }

  Future<void> _moveToDeadLetter({
    required SyncOutboxEntry entry,
    required DateTime now,
    required String reason,
  }) async {
    try {
      await _outboxRepo.moveToDeadLetter(
        entryId: entry.id,
        now: now,
        reason: reason,
      );
    } catch (e) {
      _debugLog('moveToDeadLetter ERROR (${entry.id}): $e');
    }
  }

  // ==========================================================================
  // LEASE HELPERS
  // ==========================================================================

  Future<bool> _safeAcquireLease(SyncOutboxEntry entry, DateTime now) async {
    try {
      return await _outboxRepo.acquireLease(
        entryId: entry.id,
        workerId: _workerId,
        leaseDuration: _leaseDuration,
        now: now,
      );
    } catch (e) {
      _debugLog('acquireLease ERROR (${entry.id}): $e');
      return false;
    }
  }

  Future<void> _safeReleaseLease(SyncOutboxEntry entry) async {
    try {
      await _outboxRepo.releaseLease(
        entryId: entry.id,
        workerId: _workerId,
      );
    } catch (e) {
      _debugLog('releaseLease ERROR (${entry.id}): $e');
    }
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  String? _assetIdFromPartitionKey(String partitionKey) {
    if (!partitionKey.startsWith(_vehiclePartitionPrefix)) return null;
    final assetId = partitionKey.substring(_vehiclePartitionPrefix.length);
    return assetId.isNotEmpty ? assetId : null;
  }

  List<List<T>> _chunked<T>(List<T> list, int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += size) {
      chunks.add(list.sublist(i, (i + size).clamp(0, list.length)));
    }
    return chunks;
  }

  Duration _backoffDuration(int retryNumber) {
    final index = (retryNumber - 1).clamp(0, _backoffTable.length - 1);
    return _backoffTable[index];
  }

  void _debugLog(String message) {
    if (kDebugMode) debugPrint('[AssetSyncDispatcher] $message');
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RESULT — PRIVADO (POR ENTRY)
// ─────────────────────────────────────────────────────────────────────────────

enum _EntryResult {
  pushed,
  retried,
  deadLettered,

  /// Estado incierto: la operación de fallo (markFailed/moveToDeadLetter)
  /// falló internamente. La entry no confirmó ni retry ni dead letter.
  /// Semánticamente distinto de [deadLettered]: aquí no sabemos el estado real.
  /// En el reporte público se agrega a deadLettered como aproximación conservadora
  /// (no fue pushed, no fue retried correctamente).
  stateUnknown,

  // Skips — internamente diferenciados para diagnóstico operativo.
  // El reporte público los agrega todos via isSkipped.
  /// Dispatcher detenido cooperativamente (_running == false).
  skippedStopped,

  /// Lease no adquirido — otro proceso ya procesa esta entry concurrentemente.
  skippedLease,

  /// Payload idéntico detectado en Firestore (dedup pre-check o tardía).
  skippedDedup;

  /// True para cualquier variante de skip — permite agregación limpia en
  /// AssetDispatchReport.skipped sin actualizar el report en cada extensión.
  bool get isSkipped =>
      this == skippedStopped || this == skippedLease || this == skippedDedup;
}

// ─────────────────────────────────────────────────────────────────────────────
// OCC CONFLICT EXCEPTION — PRIVADA
// ─────────────────────────────────────────────────────────────────────────────

/// Lanzada dentro de runTransaction() cuando la versión del servidor supera
/// la versión esperada por el cliente para un domain con OCC activo.
///
/// NUNCA se propaga fuera de _processV2Entry. Se captura en el on-catch
/// inmediato y se clasifica para decidir retry vs dead letter.
class _OccConflictException implements Exception {
  final String domain;
  final int serverVersion;
  final int expectedVersion;
  final int retryCount;

  const _OccConflictException({
    required this.domain,
    required this.serverVersion,
    required this.expectedVersion,
    required this.retryCount,
  });

  /// Clasificación del conflicto (inamovible — ver §8.4 del plan).
  ///
  /// - retryLoop: retryCount > 2 → ciclo de reintentos, dead letter
  /// - staleClient: serverVersion - expectedVersion > 1 → cliente muy atrasado
  /// - realConflict: write concurrente normal → retry con backoff
  SyncOccConflictType get conflictType {
    if (retryCount > 2) return SyncOccConflictType.retryLoop;
    if (serverVersion - expectedVersion > 1) {
      return SyncOccConflictType.staleClient;
    }
    return SyncOccConflictType.realConflict;
  }

  @override
  String toString() => '_OccConflictException(domain=$domain, '
      'server=$serverVersion, expected=$expectedVersion, '
      'retries=$retryCount, type=${conflictType.wireValue})';
}
