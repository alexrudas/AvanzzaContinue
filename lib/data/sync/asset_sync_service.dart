// ============================================================================
// lib/data/sync/asset_sync_service.dart
// ENTERPRISE REFINEMENT:
// - Evita fingerprint innecesario
// - Protege contra modelos inconsistentes
// - Reduce carga en bootstrap masivo
// ============================================================================

import 'package:flutter/foundation.dart';

import '../../data/models/asset/special/asset_vehiculo_model.dart';
import '../../data/sources/local/asset_local_ds.dart';
import '../../data/sources/remote/asset_remote_ds.dart';
import 'asset_firestore_adapter.dart';
import 'asset_sync_models.dart';
import 'asset_sync_queue.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SERVICE
// ─────────────────────────────────────────────────────────────────────────────

class AssetSyncService {
  final AssetLocalDataSource _localDs;
  final AssetRemoteDataSource _remoteDs;
  final AssetSyncQueue _queue;
  final AssetFirestoreAdapter _adapter;

  final Map<String, VehicleSyncState> _state = {};

  AssetSyncService({
    required AssetLocalDataSource localDs,
    required AssetRemoteDataSource remoteDs,
    required AssetSyncQueue queue,
    required AssetFirestoreAdapter adapter,
  })  : _localDs = localDs,
        _remoteDs = remoteDs,
        _queue = queue,
        _adapter = adapter;

  // ==========================================================================
  // PUSH — local → remoto
  // ==========================================================================

  Future<PushResult> schedulePush(AssetVehiculoModel model) async {
    final state = _stateFor(model.assetId);

    // 🔥 GUARDRAIL: sin updatedAt no hay control de estado
    if (model.updatedAt == null) {
      _debugLog(
        'schedulePush SKIP (sin updatedAt): ${model.assetId}',
      );
      return const PushResultSkipped();
    }

    final fingerprint = _adapter.computeFingerprint(model);

    // 🔥 ANTI-PING-PONG
    if (state.matchesFingerprint(fingerprint)) {
      _debugLog(
        'schedulePush SKIP (fingerprint match): ${model.assetId}',
      );
      return const PushResultSkipped();
    }

    try {
      final now = DateTime.now().toUtc();

      await _queue.enqueueUpsert(
        model: model,
        nowUtc: now,
      );

      _state[model.assetId] = state.acceptSnapshot(
        fingerprint: fingerprint,
        origin: SyncOrigin.local,
        updatedAt: model.updatedAt,
        touchedAt: now,
      );

      return const PushResultPushed();
    } catch (e) {
      _debugLog('schedulePush ERROR: ${model.assetId} → $e');
      return PushResultError(e.toString());
    }
  }

  // ==========================================================================
  // PULL — remoto → local
  // ==========================================================================

  Future<PullResult> pullFromRemote(String assetId) async {
    try {
      final remoteModel = await _remoteDs.getVehiculo(assetId);

      if (remoteModel == null) {
        return const PullResultNotFound();
      }

      final remoteUpdatedAt = remoteModel.updatedAt;

      if (remoteUpdatedAt == null) {
        return const PullResultSkipped();
      }

      final localModel = await _localDs.getVehiculo(assetId);
      final localUpdatedAt = localModel?.updatedAt;

      // 🔥 CASO: local >= remoto
      if (localUpdatedAt != null && !remoteUpdatedAt.isAfter(localUpdatedAt)) {
        // ⚠️ Solo calcular fingerprint si timestamps empatan
        if (remoteUpdatedAt.isAtSameMomentAs(localUpdatedAt)) {
          final remoteFp = _adapter.computeFingerprint(remoteModel);
          final localFp = localModel != null
              ? _adapter.computeFingerprint(localModel)
              : null;

          if (localFp != null && localFp == remoteFp) {
            return const PullResultUpToDate();
          }

          // conflicto → remoto gana
        } else {
          return const PullResultUpToDate();
        }
      }

      // 🔥 APLICAR REMOTO
      await _localDs.upsertVehiculo(remoteModel);

      markAsApplied(
        assetId: assetId,
        model: remoteModel,
        origin: SyncOrigin.remote,
      );

      return const PullResultApplied();
    } catch (e) {
      _debugLog('pullFromRemote ERROR: $assetId → $e');
      return PullResultError(e.toString());
    }
  }

  // ==========================================================================
  // BATCH PULL
  // ==========================================================================

  Future<Map<String, PullResult>> pullAllForAssets(
    List<String> assetIds,
  ) async {
    final results = <String, PullResult>{};

    for (final id in assetIds) {
      results[id] = await pullFromRemote(id);
    }

    return results;
  }

  // ==========================================================================
  // STATE
  // ==========================================================================

  void markAsApplied({
    required String assetId,
    required AssetVehiculoModel model,
    required SyncOrigin origin,
  }) {
    final fingerprint = _adapter.computeFingerprint(model);
    final current = _stateFor(assetId);

    _state[assetId] = current.acceptSnapshot(
      fingerprint: fingerprint,
      origin: origin,
      updatedAt: model.updatedAt,
      touchedAt: DateTime.now().toUtc(),
    );
  }

  VehicleSyncState stateFor(String assetId) => _stateFor(assetId);

  // ==========================================================================
  // PRIVADOS
  // ==========================================================================

  VehicleSyncState _stateFor(String assetId) =>
      _state[assetId] ??= VehicleSyncState.initial(assetId);

  void _debugLog(String message) {
    if (kDebugMode) debugPrint('[AssetSyncService] $message');
  }
}
