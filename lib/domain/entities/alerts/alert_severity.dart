// ============================================================================
// lib/domain/entities/alerts/alert_severity.dart
// ALERT SEVERITY — Nivel de urgencia canónico de una alerta
//
// QUÉ HACE:
// - Define AlertSeverity con 4 niveles de urgencia.
// - Documenta el mapeo obligatorio desde enums legacy del proyecto.
// - Expone comparación ordinal mediante [index] (critical > high > medium > low).
// - Expone wireName y fromWire() para wire-stability consistente con el
//   resto de enums del pipeline canónico.
//
// QUÉ NO HACE:
// - No importa Flutter, GetX ni infraestructura.
// - No duplica ni reemplaza los enums legacy directamente —
//   los adapters/evaluadores usan este enum como destino del mapeo.
//
// PRINCIPIOS:
// - Enum ascendente por urgencia: low=0, medium=1, high=2, critical=3.
//   El ORDEN DE DECLARACIÓN es parte del contrato: isAtLeast() y toda
//   comparación ordinal dependen de él. NO reordenar sin migración.
// - Regla: no crear un quinto enum paralelo después de AlertSeverity.
// - Wire-stability obligatoria: NO cambiar wireName sin migración.
//   (V4 §19 regla 12: todos los enums nuevos deben tener wireName + fromWire)
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Estándar canónico v1. Ver ALERTS_SYSTEM_V4.md §6.2.
// ACTUALIZADO (2026-03): Agregados wireName + fromWire para paridad wire-stable
//   con AlertCode, AlertScope y AlertAudience.
//
// MAPEO LEGACY OBLIGATORIO (para adapters y evaluadores):
//
//   _ModuleSeverity.critical      → AlertSeverity.critical
//   _ModuleSeverity.attention     → AlertSeverity.medium
//   _ModuleSeverity.neutral       → AlertSeverity.low (o sin alerta según contexto)
//
//   AIAlertPriority.critica       → AlertSeverity.critical
//   AIAlertPriority.alta          → AlertSeverity.high
//   AIAlertPriority.media         → AlertSeverity.medium
//   AIAlertPriority.oportunidad   → AlertSeverity.low
//
//   SoatPriority.critical         → AlertSeverity.critical
//   SoatPriority.high             → AlertSeverity.high
//   SoatPriority.medium           → AlertSeverity.medium
//   SoatPriority.low              → AlertSeverity.low
//   SoatPriority.none             → no genera alerta
//
//   AlertType.critical            → AlertSeverity.critical
//   AlertType.warning             → AlertSeverity.medium
//   AlertType.info                → AlertSeverity.low
//   AlertType.success             → NO es alerta canónica — no migrar
// ============================================================================

/// Nivel de urgencia canónico de una alerta.
///
/// Ordenado de menor a mayor urgencia para comparación ordinal via [index]:
/// low (0) < medium (1) < high (2) < critical (3).
///
/// Wire-stable: usar [wireName] al serializar o incluir en contratos remotos.
enum AlertSeverity {
  /// Urgencia baja — informativo, sin acción inmediata requerida.
  /// Wire value: `low`.
  low,

  /// Urgencia media — atención recomendada, acción planificable.
  /// Wire value: `medium`.
  medium,

  /// Urgencia alta — acción requerida próximamente.
  /// Wire value: `high`.
  high,

  /// Urgencia crítica — acción inmediata requerida.
  /// Wire value: `critical`.
  critical;

  // ─────────────────────────────────────────────────────────────────────────
  // WIRE MAP
  // ─────────────────────────────────────────────────────────────────────────

  static const Map<String, AlertSeverity> _byWire = {
    'low': AlertSeverity.low,
    'medium': AlertSeverity.medium,
    'high': AlertSeverity.high,
    'critical': AlertSeverity.critical,
  };

  /// Construye el enum desde su wire value. Retorna null si no se reconoce.
  ///
  /// La tolerancia a mayúsculas es robustez defensiva, no un contrato:
  /// los productores canónicos siempre emiten snake_case minúsculas.
  static AlertSeverity? fromWire(String? value) =>
      _byWire[value?.toLowerCase()];

  /// Wire value estable de esta severidad.
  ///
  /// NO cambiar sin migración de datos (wire-stability).
  String get wireName => switch (this) {
        AlertSeverity.low => 'low',
        AlertSeverity.medium => 'medium',
        AlertSeverity.high => 'high',
        AlertSeverity.critical => 'critical',
      };

  /// True si esta severidad es al menos tan urgente como [other].
  bool isAtLeast(AlertSeverity other) => index >= other.index;
}
