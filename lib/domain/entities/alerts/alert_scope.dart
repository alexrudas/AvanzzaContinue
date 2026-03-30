// ============================================================================
// lib/domain/entities/alerts/alert_scope.dart
// ALERT SCOPE — Dominio operativo de origen de una alerta
//
// QUÉ HACE:
// - Define AlertScope: el dominio operativo donde nace la alerta.
// - Expone wireName (wire value estable) y fromWire() para consistencia
//   con el principio wire-stable de todos los enums del sistema canónico.
//
// QUÉ NO HACE:
// - No importa Flutter, GetX ni infraestructura.
// - No determina a qué vista se proyecta la alerta (eso es responsabilidad
//   de AlertPromotionPolicy y la promotion layer).
//
// PRINCIPIOS:
// - Una alerta siempre tiene un scope de origen canónico.
// - El scope no cambia al promover hacia Home.
// - Wire-stability obligatoria: NO cambiar wireName sin migración.
//   (V4 §19 regla 12: todos los enums nuevos deben tener wireName + fromWire)
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Estándar canónico v1. Ver ALERTS_SYSTEM_V4.md §6.3.
// ACTUALIZADO (2026-03): Agregados wireName + fromWire para wire-stability
//   consistente con AlertCode. Usado en dedupeKey del pipeline canónico.
// ============================================================================

/// Dominio operativo donde nació la alerta.
///
/// El scope identifica el módulo de origen, no el destino de renderizado.
/// Wire-stable: usar [wireName] al construir [DomainAlert.dedupeKey].
enum AlertScope {
  /// Alerta nacida en un activo o su cumplimiento documental/jurídico.
  asset,

  /// Alerta agregada o promovida a nivel organización.
  organization,

  /// Alerta nacida en operaciones de mantenimiento.
  maintenance,

  /// Alerta nacida en riesgo contable, tributario o de cartera.
  accounting,

  /// Alerta nacida en compras o abastecimiento.
  purchasing;

  // ─────────────────────────────────────────────────────────────────────────
  // WIRE MAP
  // ─────────────────────────────────────────────────────────────────────────

  static const Map<String, AlertScope> _byWire = {
    'asset': AlertScope.asset,
    'organization': AlertScope.organization,
    'maintenance': AlertScope.maintenance,
    'accounting': AlertScope.accounting,
    'purchasing': AlertScope.purchasing,
  };

  /// Construye el enum desde su wire value.
  ///
  /// Retorna null ante cualquier valor no reconocido.
  static AlertScope? fromWire(String? value) =>
      _byWire[value?.toLowerCase()];

  /// Wire value estable de este scope.
  ///
  /// NO cambiar sin migración de datos (wire-stability).
  /// Usar siempre este getter al construir [DomainAlert.dedupeKey].
  String get wireName => switch (this) {
        AlertScope.asset => 'asset',
        AlertScope.organization => 'organization',
        AlertScope.maintenance => 'maintenance',
        AlertScope.accounting => 'accounting',
        AlertScope.purchasing => 'purchasing',
      };
}
