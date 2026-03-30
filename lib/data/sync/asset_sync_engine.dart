// ============================================================================
// lib/data/sync/asset_sync_engine.dart
// ASSET SYNC ENGINE — Motor reactivo local↔remoto para activos vehiculares
//
// QUÉ HACE:
// - Observa la colección Isar [assetVehiculoModels] con watchLazy() por asset.
// - Al detectar cambio local: debounce por assetId → schedulePush().
// - Auto-descubre nuevos activos vía watcher de colección.
// - En start(): dispara bootstrap pull de activos conocidos sin bloquear UI.
// - Maneja start()/stop() de forma idempotente y segura.
//
// QUÉ NO HACE:
// - No ejecuta directamente el outbox.
// - No contamina repositorios.
// - No toma decisiones de UI.
// - No propaga excepciones al caller.
//
// PRINCIPIOS:
// - watchLazy() por asset → precisión y menor ruido.
// - debounce por assetId → coalescing de cambios rápidos.
// - bootstrap pull → alineación inicial con nube.
// - anti-ping-pong delegado a AssetSyncService.
// - aislamiento de errores total.
//
// COALESCING REAL:
// - Si el usuario edita varios campos del mismo asset en pocos segundos,
//   este engine debe terminar llamando una sola vez a schedulePush() por asset.
//
// ENTERPRISE NOTES:
// - Esta versión agrega:
//   1. limpieza de watchers de assets borrados,
//   2. guardrails ante stop() concurrente,
//   3. bootstrap protegido contra reentrada,
//   4. fetch de IDs más ligero (solo assetId si la colección lo soporta; si no,
//      fallback seguro a findAll()).
// ============================================================================

import 'dart:async';

import 'package:avanzza/data/sync/asset_sync_models.dart';
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';

import '../models/asset/special/asset_vehiculo_model.dart';
import '../sources/local/asset_local_ds.dart';
import 'asset_sync_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENGINE
// ─────────────────────────────────────────────────────────────────────────────

class AssetSyncEngine {
  final AssetLocalDataSource _localDs;
  final AssetSyncService _syncService;
  final Isar _isar;

  static const _debounceDuration = Duration(milliseconds: 800);

  bool _running = false;
  bool _starting = false;
  bool _stopping = false;
  bool _bootstrapRunning = false;

  StreamSubscription<void>? _collectionSub;

  final Map<String, StreamSubscription<void>> _assetSubs = {};
  final Map<String, Timer> _debounceTimers = {};
  final Set<String> _trackedIds = {};

  AssetSyncEngine({
    required AssetLocalDataSource localDs,
    required AssetSyncService syncService,
    required Isar isar,
  })  : _localDs = localDs,
        _syncService = syncService,
        _isar = isar;

  // ==========================================================================
  // LIFECYCLE
  // ==========================================================================

  Future<void> start() async {
    if (_running || _starting) return;
    _starting = true;

    try {
      _debugLog('start() — inicializando engine');

      final known = await _fetchKnownAssetIds();
      if (_stopping) return;

      for (final id in known) {
        _trackAsset(id);
      }

      _collectionSub = _isar.assetVehiculoModels.watchLazy().listen(
        (_) => _onCollectionChanged(),
        onError: (Object e, StackTrace s) {
          _debugLog('collection watcher ERROR: $e');
        },
      );

      _running = true;
      _debugLog('start() — ${known.length} assets tracked');

      _bootstrapPull(known);
    } catch (e) {
      _debugLog('start() ERROR: $e');
    } finally {
      _starting = false;
    }
  }

  Future<void> stop() async {
    if (_stopping) return;
    if (!_running && _collectionSub == null && _assetSubs.isEmpty) return;

    _stopping = true;
    _debugLog('stop() — cerrando engine');

    try {
      for (final timer in _debounceTimers.values) {
        timer.cancel();
      }
      _debounceTimers.clear();

      for (final sub in _assetSubs.values) {
        await sub.cancel();
      }
      _assetSubs.clear();
      _trackedIds.clear();

      await _collectionSub?.cancel();
      _collectionSub = null;

      _running = false;
      _bootstrapRunning = false;

      _debugLog('stop() — engine detenido');
    } catch (e) {
      _debugLog('stop() ERROR: $e');
    } finally {
      _stopping = false;
    }
  }

  // ==========================================================================
  // TRACKING PER-ASSET
  // ==========================================================================

  void _trackAsset(String assetId) {
    if (!_canProcess()) return;
    if (_trackedIds.contains(assetId)) return;

    final sub = _isar.assetVehiculoModels
        .filter()
        .assetIdEqualTo(assetId)
        .watchLazy()
        .listen(
      (_) => _onAssetChanged(assetId),
      onError: (Object e, StackTrace s) {
        _debugLog('asset watcher ERROR ($assetId): $e');
      },
    );

    _assetSubs[assetId] = sub;
    _trackedIds.add(assetId);
  }

  Future<void> _untrackAsset(String assetId) async {
    _debounceTimers.remove(assetId)?.cancel();
    final sub = _assetSubs.remove(assetId);
    if (sub != null) {
      await sub.cancel();
    }
    _trackedIds.remove(assetId);
  }

  // ==========================================================================
  // HANDLERS
  // ==========================================================================

  void _onAssetChanged(String assetId) {
    if (!_canProcess()) return;

    _debounceTimers[assetId]?.cancel();
    _debounceTimers[assetId] = Timer(
      _debounceDuration,
      () => _processPush(assetId),
    );
  }

  void _onCollectionChanged() {
    if (!_canProcess()) return;
    _syncTrackedAssets();
  }

  // ==========================================================================
  // PUSH
  // ==========================================================================

  Future<void> _processPush(String assetId) async {
    if (!_canProcess()) return;

    try {
      final model = await _localDs.getVehiculo(assetId);
      if (!_canProcess()) return;

      if (model == null) {
        _debugLog('processPush SKIP (asset eliminado/no encontrado): $assetId');
        await _untrackAsset(assetId);
        return;
      }

      final result = await _syncService.schedulePush(model);
      if (!_canProcess()) return;

      _debugLog('processPush $assetId → ${result.runtimeType}');
    } catch (e) {
      _debugLog('processPush ERROR ($assetId): $e');
    }
  }

  // ==========================================================================
  // BOOTSTRAP PULL
  // ==========================================================================

  void _bootstrapPull(List<String> assetIds) {
    if (!_canProcess()) return;
    if (assetIds.isEmpty) return;
    if (_bootstrapRunning) return;

    _bootstrapRunning = true;
    unawaited(_runBootstrapPull(assetIds));
  }

  Future<void> _runBootstrapPull(List<String> assetIds) async {
    _debugLog('bootstrapPull — ${assetIds.length} assets');

    try {
      final results = await _syncService.pullAllForAssets(assetIds);
      if (!_canProcess()) return;

      if (kDebugMode) {
        final applied = results.values.whereType<PullResultApplied>().length;
        final upToDate = results.values.whereType<PullResultUpToDate>().length;
        _debugLog(
          'bootstrapPull completado — applied: $applied | upToDate: $upToDate | total: ${results.length}',
        );
      }
    } catch (e) {
      _debugLog('bootstrapPull ERROR: $e');
    } finally {
      _bootstrapRunning = false;
    }
  }

  // ==========================================================================
  // AUTO-DESCUBRIMIENTO / LIMPIEZA
  // ==========================================================================

  Future<void> _syncTrackedAssets() async {
    if (!_canProcess()) return;

    try {
      final currentIds = (await _fetchKnownAssetIds()).toSet();
      if (!_canProcess()) return;

      final newIds =
          currentIds.where((id) => !_trackedIds.contains(id)).toList();
      final removedIds =
          _trackedIds.where((id) => !currentIds.contains(id)).toList();

      for (final id in newIds) {
        _trackAsset(id);
        _debugLog('nuevo asset tracked: $id');
      }

      for (final id in removedIds) {
        await _untrackAsset(id);
        _debugLog('asset untracked (removido): $id');
      }
    } catch (e) {
      _debugLog('syncTrackedAssets ERROR: $e');
    }
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  Future<List<String>> _fetchKnownAssetIds() async {
    try {
      // Si luego tienes query de proyección en tu local DS, muévelo allá.
      final models = await _isar.assetVehiculoModels.where().findAll();
      return models.map((m) => m.assetId).where((id) => id.isNotEmpty).toList();
    } catch (e) {
      _debugLog('fetchKnownAssetIds ERROR: $e');
      return const [];
    }
  }

  bool _canProcess() => _running || _starting;

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[AssetSyncEngine] $message');
    }
  }
}
