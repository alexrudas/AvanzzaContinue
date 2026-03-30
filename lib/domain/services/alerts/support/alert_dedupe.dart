// ============================================================================
// lib/domain/services/alerts/support/alert_dedupe.dart
// ALERT DEDUPE — Deduplicación del pipeline de alertas canónicas
//
// QUÉ HACE:
// - Recibe una lista de DomainAlert y elimina duplicados por dedupeKey.
// - Ante duplicados con el mismo dedupeKey, retiene la alerta con
//   detectedAt más reciente.
//
// QUÉ NO HACE:
// - NO importa Flutter, GetX ni infraestructura.
// - NO aplica reglas de negocio — solo deduplicación técnica.
// - NO modifica el dedupeKey (es responsabilidad del productor).
//
// PRINCIPIOS:
// - Función pura: sin estado, sin side effects.
// - dedupeKey es calculado por el productor:
//   "{code.wireName}:{scope.wireName}:{sourceEntityId}:{primaryEvidenceId}"
//   (Ver ALERTS_SYSTEM_V4.md §12.1 — separador ':', cuatro segmentos)
// - Si dos alertas tienen el mismo dedupeKey, gana la de detectedAt más reciente.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 — Soporte canónico v1. Ver ALERTS_SYSTEM_V4.md §12.1.
// MOVIDO (2026-03): de lib/core/alerts/support/ → lib/domain/services/alerts/support/
//   Razón: solo depende de DomainAlert (domain puro). Domain no puede importar core;
//   moverlo aquí elimina la violación de dependencias del orquestador.
// ============================================================================

import '../../../entities/alerts/domain_alert.dart';

/// Deduplicación canónica del pipeline de alertas.
///
/// Retiene la alerta con [DomainAlert.detectedAt] más reciente por
/// [DomainAlert.dedupeKey]. El orden del resultado no debe asumirse como
/// estable para render — aplicar [sortAlerts] después.
List<DomainAlert> dedupeAlerts(List<DomainAlert> alerts) {
  if (alerts.isEmpty) return alerts;

  // Mapa: dedupeKey → alerta más reciente
  final Map<String, DomainAlert> best = {};

  for (final alert in alerts) {
    final existing = best[alert.dedupeKey];
    if (existing == null || alert.detectedAt.isAfter(existing.detectedAt)) {
      best[alert.dedupeKey] = alert;
    }
  }

  return best.values.toList();
}
