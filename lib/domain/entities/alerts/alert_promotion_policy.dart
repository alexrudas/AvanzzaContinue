// ============================================================================
// lib/domain/entities/alerts/alert_promotion_policy.dart
// ALERT PROMOTION POLICY — Política de promoción de alertas hacia Home
//
// QUÉ HACE:
// - Define AlertPromotionPolicy: la intención contractual de visibilidad de una
//   alerta respecto a Home. Es el contrato que los evaluadores asignan y que
//   AlertPromotionService interpreta y ejecuta.
// - Expone wireName y fromWire() para wire-stability consistente con el
//   resto de enums del pipeline canónico.
//
// QUÉ NO HACE:
// - No importa Flutter, GetX ni infraestructura.
// - No implementa la lógica de promoción — esa vive en AlertPromotionService.
// - No determina el orden de aparición en Home.
// - No ejecuta ninguna regla: declara intención, no comportamiento.
//
// PRINCIPIOS:
// - Este enum define el contrato. AlertPromotionService (Fase 4) lo ejecuta.
//   Usar políticas distintas de [none] antes de implementar Fase 4 es seguro:
//   los evaluadores pueden asignarlas en Fase 2; simplemente no tendrán efecto
//   hasta que el Promotion Layer esté activo.
// - Wire-stability obligatoria: NO cambiar wireName sin migración.
//   (V4 §19 regla 12: todos los enums nuevos deben tener wireName + fromWire)
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Contrato canónico v1. Ver ALERTS_SYSTEM_V4.md §6.5.
//   Este enum es parte del contrato de dominio; la ejecución de sus reglas
//   comienza en Fase 4 con AlertPromotionService.
// ACTUALIZADO (2026-03): Agregados wireName + fromWire. Tono de PRINCIPIOS
//   ajustado de ejecutivo a declarativo.
// ============================================================================

/// Política contractual que declara cómo una alerta debe proyectarse hacia Home.
///
/// Asignada por los evaluadores al construir [DomainAlert].
/// Interpretada y ejecutada por AlertPromotionService (Fase 4).
/// La UI de Home solo consume el resultado — no decide semántica.
///
/// Wire-stable: usar [wireName] al serializar o incluir en contratos remotos.
enum AlertPromotionPolicy {
  /// Intención: la alerta no debe subir a Home.
  /// Wire value: `none`.
  none,

  /// Intención: la alerta debe subir si su severidad es alta o superior.
  /// Wire value: `promote_if_high`.
  promoteIfHigh,

  /// Intención: la alerta debe subir solo si su severidad es crítica.
  /// Wire value: `promote_if_critical`.
  promoteIfCritical,

  /// Intención: la alerta debe subir independientemente de su severidad.
  /// Wire value: `always_promote`.
  alwaysPromote,

  /// Intención: la alerta nunca debe aparecer individualmente en Home.
  ///
  /// Solo puede formar parte de un resumen agregado multi-activo
  /// (ej: "5 vehículos con RTM vencida").
  /// AlertPromotionService garantiza que ninguna otra condición la haga individual.
  /// Wire value: `aggregate_only`.
  aggregateOnly;

  // ─────────────────────────────────────────────────────────────────────────
  // WIRE MAP
  // ─────────────────────────────────────────────────────────────────────────

  static const Map<String, AlertPromotionPolicy> _byWire = {
    'none': AlertPromotionPolicy.none,
    'promote_if_high': AlertPromotionPolicy.promoteIfHigh,
    'promote_if_critical': AlertPromotionPolicy.promoteIfCritical,
    'always_promote': AlertPromotionPolicy.alwaysPromote,
    'aggregate_only': AlertPromotionPolicy.aggregateOnly,
  };

  /// Construye el enum desde su wire value. Retorna null si no se reconoce.
  ///
  /// La tolerancia a mayúsculas es robustez defensiva, no un contrato:
  /// los productores canónicos siempre emiten snake_case minúsculas.
  static AlertPromotionPolicy? fromWire(String? value) =>
      _byWire[value?.toLowerCase()];

  /// Wire value estable de esta política.
  ///
  /// NO cambiar sin migración de datos (wire-stability).
  String get wireName => switch (this) {
        AlertPromotionPolicy.none => 'none',
        AlertPromotionPolicy.promoteIfHigh => 'promote_if_high',
        AlertPromotionPolicy.promoteIfCritical => 'promote_if_critical',
        AlertPromotionPolicy.alwaysPromote => 'always_promote',
        AlertPromotionPolicy.aggregateOnly => 'aggregate_only',
      };
}
