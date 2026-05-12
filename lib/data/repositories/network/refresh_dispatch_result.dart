// ============================================================================
// lib/data/repositories/network/refresh_dispatch_result.dart
// Decisión del SCHEDULER del controller. Ortogonal a RefreshNetworkOutcome.
// ============================================================================
// Skipped NO es resultado remoto — es decisión local del controller (cooldown,
// in-flight, fresh, workspace mismatch). Mantener separado evita confundir
// "no ejecutado" con "ejecutado exitosamente".
// ============================================================================

enum RefreshDispatchResult {
  /// Se inició efectivamente el refresh (luego habrá un RefreshNetworkOutcome).
  dispatched,

  /// La sección está FRESH (≤ 5 min). No vale la pena refrescar.
  skippedFresh,

  /// Hubo un intento muy reciente (< 10 s). Cooldown activo.
  skippedCooldown,

  /// Ya hay un refresh en curso para el mismo (workspace, section).
  skippedInflight,

  /// El workspace activo cambió antes de poder dispatchar — protección
  /// anti-contaminación cross-workspace.
  skippedWorkspaceMismatch,
}
