// ============================================================================
// lib/core/network/connectivity_service.dart
// CONNECTIVITY SERVICE — Enterprise Ultra Pro (Core)
//
// QUÉ HACE:
// - Mantiene un estado de conectividad (online/offline) como Single Source of Truth.
// - Expone un stream broadcast de cambios de conectividad (solo cuando CAMBIA).
// - Arranca fail-safe en offline hasta que una fuente real confirme conectividad.
// - Es seguro ante dispose múltiple (idempotente) y ante llamadas post-dispose.
//
// QUÉ NO HACE:
// - NO "fabrica" conectividad (sin timers, sin heartbeats falsos).
// - NO deduce conectividad por sí mismo (eso es de infraestructura/adapters).
// - NO logs / prints / asserts.
// - NO retries/backoff/jitter (eso es SyncEngine).
//
// NOTAS:
// - El stream es broadcast y no emite duplicados consecutivos.
// - Los consumidores pueden usar `.distinct()` sin romper semántica (ya viene limpio).
// ============================================================================

import 'dart:async';

class ConnectivityService {
  // --------------------------------------------------------------------------
  // STATE
  // --------------------------------------------------------------------------

  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  /// Fail-safe: inicia OFFLINE hasta que una fuente real llame setOnline(true).
  bool _online = false;

  bool _disposed = false;

  // --------------------------------------------------------------------------
  // PUBLIC API
  // --------------------------------------------------------------------------

  /// Estado actual de conectividad.
  bool get isOnline => _online;

  /// Stream broadcast de cambios de conectividad.
  ///
  /// - Emite SOLO cuando el estado cambia.
  /// - No emite duplicados consecutivos.
  /// - Broadcast: múltiples listeners permitidos.
  Stream<bool> get online$ => _controller.stream;

  /// Actualiza el estado de conectividad.
  ///
  /// Semántica:
  /// - Si el valor NO cambia, no emite (sin heartbeats falsos).
  /// - Si está disposed, no hace nada (no lanza, no emite).
  void setOnline(bool online) {
    if (_disposed) return;
    if (_online == online) return;

    _online = online;

    // Guard adicional: si por alguna razón el controller ya está cerrado,
    // evitamos StateError en escenarios de cierre async.
    if (_controller.isClosed) return;

    _controller.add(_online);
  }

  /// Libera recursos. Idempotente.
  ///
  /// PRO:
  /// - Retorna Future para permitir a Bootstrap esperar el cierre real.
  /// - Múltiples llamadas no lanzan.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;

    // Close puede ser async; se espera para shutdown limpio.
    if (!_controller.isClosed) {
      await _controller.close();
    }
  }
}
