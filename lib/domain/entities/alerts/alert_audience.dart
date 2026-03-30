// ============================================================================
// lib/domain/entities/alerts/alert_audience.dart
// ALERT AUDIENCE — Rol objetivo canónico de una alerta
//
// QUÉ HACE:
// - Define AlertAudience: el rol operativo al que está dirigida la alerta.
// - Expone wireName y fromWire() para wire-stability consistente con el
//   resto de enums del pipeline canónico.
//
// QUÉ NO HACE:
// - No importa Flutter, GetX ni infraestructura.
// - No implementa filtrado por rol (no hay lógica de filtrado en V1).
// - No determina visibilidad UI — solo declara la intención de audiencia.
// - No mapea audiencias a workspaces de producto — ese mapeo es
//   interpretación UX mutable y vive en ALERTS_SYSTEM_V4.md §6.4.
//
// PRINCIPIOS:
// - En V1, la implementación activa usa solo [assetAdmin] como audiencia.
//   Los demás valores están declarados para prevenir migración breaking en V2.
//   REGLA: ningún evaluador V1 debe usar un valor distinto de [assetAdmin]
//   sin actualizar primero el documento rector (ALERTS_SYSTEM_V4.md).
// - Wire-stability obligatoria: NO cambiar wireName sin migración.
//   (V4 §19 regla 12: todos los enums nuevos deben tener wireName + fromWire)
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Estándar canónico v1. Ver ALERTS_SYSTEM_V4.md §6.4.
// ACTUALIZADO (2026-03): Agregados wireName + fromWire. Removido mapeo a
//   workspaces (pertenece a docs, no al enum). Clarificada convención V1/V2.
// ============================================================================

/// Rol operativo al que está dirigida la alerta.
///
/// En V1, la implementación activa usa exclusivamente [assetAdmin].
/// Los valores marcados como "reservado V2" están declarados para evitar
/// breaking changes futuros, pero NO deben usarse en evaluadores V1.
///
/// Wire-stable: usar [wireName] al serializar o incluir en contratos remotos.
enum AlertAudience {
  /// Administrador de activos.
  ///
  /// Único valor usado en V1. Wire value: `asset_admin`.
  assetAdmin,

  // ── Reservados para V2 — NO usar en evaluadores V1 ───────────────────────

  /// Propietario del activo. Wire value: `owner`. Reservado V2.
  owner,

  /// Responsable del módulo de mantenimiento. Wire value: `maintenance_manager`. Reservado V2.
  maintenanceManager,

  /// Responsable del módulo de contabilidad. Wire value: `accounting_manager`. Reservado V2.
  accountingManager,

  /// Responsable del módulo de compras. Wire value: `purchasing_manager`. Reservado V2.
  purchasingManager,

  /// Rol con acceso de solo lectura. Wire value: `viewer`. Reservado V2.
  viewer;

  // ─────────────────────────────────────────────────────────────────────────
  // WIRE MAP
  // ─────────────────────────────────────────────────────────────────────────

  static const Map<String, AlertAudience> _byWire = {
    'asset_admin': AlertAudience.assetAdmin,
    'owner': AlertAudience.owner,
    'maintenance_manager': AlertAudience.maintenanceManager,
    'accounting_manager': AlertAudience.accountingManager,
    'purchasing_manager': AlertAudience.purchasingManager,
    'viewer': AlertAudience.viewer,
  };

  /// Construye el enum desde su wire value.
  ///
  /// Retorna null ante cualquier valor no reconocido.
  static AlertAudience? fromWire(String? value) =>
      _byWire[value?.toLowerCase()];

  /// Wire value estable de esta audiencia.
  ///
  /// NO cambiar sin migración de datos (wire-stability).
  String get wireName => switch (this) {
        AlertAudience.assetAdmin => 'asset_admin',
        AlertAudience.owner => 'owner',
        AlertAudience.maintenanceManager => 'maintenance_manager',
        AlertAudience.accountingManager => 'accounting_manager',
        AlertAudience.purchasingManager => 'purchasing_manager',
        AlertAudience.viewer => 'viewer',
      };
}
