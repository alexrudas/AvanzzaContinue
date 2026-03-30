// ============================================================================
// lib/domain/entities/alerts/alert_kind.dart
// ALERT KIND — Naturaleza semántica de una señal del sistema de alertas
//
// QUÉ HACE:
// - Define AlertKind: discriminador que separa incumplimientos (compliance),
//   señales comerciales (opportunity) y condiciones informativas (exemption).
// - Expone wireName y fromWire() para serialización estable.
//
// QUÉ NO HACE:
// - No importa Flutter, GetX ni infraestructura.
// - No define severidad ni política de promoción (son enums separados).
// - No contiene lógica de evaluación.
//
// PRINCIPIOS:
// - AlertKind define la naturaleza de la señal.
//   AlertSeverity define la urgencia. Son ortogonales.
// - fromWire() NUNCA lanza excepción y NUNCA retorna null.
//   Fallback defensivo a compliance — ver nota en fromWire().
// - Si este enum se persiste o transporta, wireName debe tratarse como
//   valor estable.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): V5 — Extensión canónica para soporte de oportunidades
//   comerciales y exenciones sin contaminar semántica de riesgo.
//   Ver ALERTS_SYSTEM_V5.md §3 y §4.
// ============================================================================

/// Naturaleza semántica de una señal del sistema de alertas.
///
/// Clasifica la señal según su naturaleza canónica.
/// Si se serializa, usar [wireName].
enum AlertKind {
  /// Riesgo operativo o incumplimiento legal.
  /// Wire value: `compliance`.
  compliance,

  /// Señal comercial sin incumplimiento.
  /// Wire value: `opportunity`.
  opportunity,

  /// Condición informativa de exención aplicada.
  /// Wire value: `exemption`.
  exemption;

  // ---------------------------------------------------------------------------
  // WIRE MAP
  // ---------------------------------------------------------------------------

  static const Map<String, AlertKind> _byWire = {
    'compliance': AlertKind.compliance,
    'opportunity': AlertKind.opportunity,
    'exemption': AlertKind.exemption,
  };

  /// Construye el enum desde su wire value.
  ///
  /// FALLBACK DEFENSIVO — Compatibilidad offline-first V1:
  /// null o valor desconocido → [AlertKind.compliance].
  ///
  /// Este fallback NO es semánticamente perfecto: un alertKind desconocido
  /// puede representar una oportunidad que termina tratándose como compliance.
  /// Es una decisión conservadora: nunca descartar señales críticas ante
  /// incompatibilidad de versiones entre cliente y servidor.
  ///
  /// NO lanza excepción. NO retorna null.
  static AlertKind fromWire(String? value) =>
      _byWire[value?.trim().toLowerCase()] ?? AlertKind.compliance;

  /// Wire value estable de esta naturaleza.
  String get wireName => switch (this) {
        AlertKind.compliance => 'compliance',
        AlertKind.opportunity => 'opportunity',
        AlertKind.exemption => 'exemption',
      };
}
