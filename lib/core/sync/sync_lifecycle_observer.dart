// ============================================================================
// lib/core/sync/sync_lifecycle_observer.dart
// SYNC LIFECYCLE OBSERVER — Enterprise Ultra Pro (Core / Platform Hook)
//
// QUÉ HACE:
// - Traduce AppLifecycleState del SO a start()/stop() del SyncEngineService.
// - resumed → start().
// - cualquier otro estado → stop(graceful:false).
//
// COMPATIBILIDAD:
// - Usa default en switch para manejar AppLifecycleState.hidden y futuros
//   estados sin romper compilación en SDKs antiguos.
//
// IDEMPOTENCIA:
// - register(): registra UNA vez.
// - dispose(): desregistra UNA vez (best-effort stop).
// ============================================================================

import 'package:flutter/widgets.dart';

import '../../domain/services/sync/sync_engine.dart';

class SyncLifecycleObserver with WidgetsBindingObserver {
  final SyncEngineService _engine;
  bool _registered = false;

  SyncLifecycleObserver({required SyncEngineService engine}) : _engine = engine;

  void register() {
    if (_registered) return;
    WidgetsBinding.instance.addObserver(this);
    _registered = true;
  }

  void dispose() {
    if (!_registered) return;
    WidgetsBinding.instance.removeObserver(this);
    _registered = false;
    _engine.stop(graceful: false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Guard: si no está registrado, este observer no debe controlar el engine.
    if (!_registered) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _engine.start();
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      default:
        // Catch-all: Maneja 'hidden' y futuros estados.
        _engine.stop(graceful: false);
        break;
    }
  }

  void startIfResumed() {
    if (!_registered) return;

    final state = WidgetsBinding.instance.lifecycleState;
    if (state == AppLifecycleState.resumed) {
      _engine.start();
    }
  }
}
