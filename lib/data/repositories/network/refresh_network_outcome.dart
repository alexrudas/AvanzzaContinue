// ============================================================================
// lib/data/repositories/network/refresh_network_outcome.dart
// Resultado de una llamada de refresh REMOTO (Core API).
// ============================================================================
// Estrictamente ortogonal a RefreshDispatchResult (scheduler decision).
// Solo se obtiene un valor de este enum si el scheduler DISPATCHÓ el refresh.
// ============================================================================

enum RefreshNetworkOutcome {
  /// 2xx, datos válidos, reconcile aplicado.
  success,

  /// Timeout, DNS, conexión cerrada, host inalcanzable.
  networkError,

  /// 401 — token inválido o expirado.
  authError,

  /// 403 — usuario sin acceso al workspace.
  forbidden,

  /// 5xx — error de servidor.
  serverError,

  /// Cualquier otro fallo no categorizado (4xx desconocido, parse error, etc.).
  unknownError,
}
