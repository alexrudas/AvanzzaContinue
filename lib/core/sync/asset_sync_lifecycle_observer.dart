// ============================================================================
// lib/core/sync/asset_sync_lifecycle_observer.dart
//
// ASSET SYNC LIFECYCLE OBSERVER — Lifecycle owner del Asset Sync Stack
//
// QUÉ HACE:
// - Traduce AppLifecycleState del SO a start()/stop() del Asset Sync Stack
//   (AssetSyncDispatcher + AssetSyncEngine).
// - resumed  → startIfResumed(): dispatcher.start() + engine.start().
// - paused / inactive / detached / hidden → stop(): engine.stop() + dispatcher.stop().
// - register()/dispose() son idempotentes.
// - Serializa operaciones de lifecycle con versionado interno para evitar
//   race conditions entre start y stop disparados en rápida sucesión.
//
// QUÉ NO HACE:
// - No toca SyncEngineService genérico.
// - No lanza excepciones al caller — errores silenciosos con debugPrint.
// - No bloquea UI: desde didChangeAppLifecycleState usa unawaited(), pero
//   los métodos públicos pueden await-earse directamente desde Bootstrap.
//
// PRINCIPIOS:
// - El lifecycle real del stack vehicle-specific vive aquí, no en Bootstrap.
// - Orden de start: dispatcher (consumer) → engine (producer).
// - Orden de stop: engine (producer) → dispatcher (consumer).
// - Stop cooperativo y best-effort en dispose().
// - Protección anti-race: cada operación start/stop invalida la anterior.
//
// ENTERPRISE NOTES:
// - Este observer reemplaza a SyncLifecycleObserver como lifecycle principal
//   del stack vehicle-specific.
// - SyncLifecycleObserver puede seguir existiendo por compatibilidad legacy,
//   pero NO debe ser el owner principal del sync vehicular.
// - El versionado interno no “cancela” Futures en curso, pero sí evita que una
//   operación vieja deje trazas lógicas engañosas o gane semánticamente sobre
//   la más reciente.
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../data/sync/asset_sync_dispatcher.dart';
import '../../data/sync/asset_sync_engine.dart';

class AssetSyncLifecycleObserver with WidgetsBindingObserver {
  final AssetSyncEngine _engine;
  final AssetSyncDispatcher _dispatcher;

  /// True si el observer ya fue registrado en WidgetsBinding.
  bool _registered = false;

  /// Versión monotónica de operación de lifecycle.
  ///
  /// Cada start/stop incrementa este contador. Si una operación async termina
  /// con una versión obsoleta, se considera stale y no se reporta como vigente.
  int _opVersion = 0;

  AssetSyncLifecycleObserver({
    required AssetSyncEngine engine,
    required AssetSyncDispatcher dispatcher,
  })  : _engine = engine,
        _dispatcher = dispatcher;

  // ==========================================================================
  // REGISTRO
  // ==========================================================================

  /// Registra el observer en WidgetsBinding. Idempotente.
  void register() {
    if (_registered) return;
    WidgetsBinding.instance.addObserver(this);
    _registered = true;
    _debugLog('register()');
  }

  /// Desregistra el observer y detiene el stack. Idempotente.
  ///
  /// Importante:
  /// - Siempre intenta stop() best-effort, incluso si no estaba registrado.
  /// - removeObserver() solo se ejecuta si realmente estaba registrado.
  void dispose() {
    if (_registered) {
      WidgetsBinding.instance.removeObserver(this);
      _registered = false;
      _debugLog('dispose() — observer removido');
    } else {
      _debugLog('dispose() — observer no registrado, stop best-effort igual');
    }

    unawaited(stop());
  }

  // ==========================================================================
  // LIFECYCLE HOOK
  // ==========================================================================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_registered) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _debugLog('didChangeAppLifecycleState: resumed → startIfResumed()');
        unawaited(startIfResumed());
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _debugLog('didChangeAppLifecycleState: $state → stop()');
        unawaited(stop());
        break;
    }
  }

  // ==========================================================================
  // START / STOP
  // ==========================================================================

  /// Arranca el stack vehicle-specific.
  ///
  /// ORDEN OBLIGATORIO:
  /// 1. dispatcher (consumer) primero — evita backlog temporal sin consumidor.
  /// 2. engine (producer) después — los watchers arrancan cuando ya hay consumer.
  ///
  /// PROTECCIÓN ANTI-RACE:
  /// - Cada invocación toma una nueva versión.
  /// - Si una operación más reciente la invalida antes de terminar, esta queda
  ///   marcada como stale y no se reporta como la operación vigente.
  Future<void> startIfResumed() async {
    final op = ++_opVersion;

    try {
      _dispatcher.start();
      await _engine.start();

      if (op != _opVersion) {
        _debugLog('startIfResumed() stale — op=$op current=$_opVersion');
        return;
      }

      _debugLog('startIfResumed() completado — op=$op');
    } catch (e) {
      if (op != _opVersion) {
        _debugLog(
          'startIfResumed() ERROR stale ignorado — op=$op current=$_opVersion error=$e',
        );
        return;
      }
      _debugLog('startIfResumed() ERROR: $e');
    }
  }

  /// Detiene el stack vehicle-specific.
  ///
  /// ORDEN OBLIGATORIO (inverso al start):
  /// 1. engine (producer) primero — cancela watchers y debounces.
  /// 2. dispatcher (consumer) después — descarta ciclos nuevos.
  ///
  /// PROTECCIÓN ANTI-RACE:
  /// - Igual que startIfResumed(), usa versionado para invalidar operaciones viejas.
  Future<void> stop() async {
    final op = ++_opVersion;

    try {
      await _engine.stop();
      _dispatcher.stop();

      if (op != _opVersion) {
        _debugLog('stop() stale — op=$op current=$_opVersion');
        return;
      }

      _debugLog('stop() completado — op=$op');
    } catch (e) {
      if (op != _opVersion) {
        _debugLog(
          'stop() ERROR stale ignorado — op=$op current=$_opVersion error=$e',
        );
        return;
      }
      _debugLog('stop() ERROR: $e');
    }
  }

  // ==========================================================================
  // DEBUG
  // ==========================================================================

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[AssetSyncLifecycleObserver] $message');
    }
  }
}
