// ============================================================================
// lib/domain/services/alerts/support/alert_sort.dart
// ALERT SORT — Ordenamiento canónico del pipeline de alertas
//
// QUÉ HACE:
// - Ordena una lista de DomainAlert según las 5 reglas canónicas de prioridad.
// - Aplica las reglas en orden descendente (mayor urgencia primero).
//
// QUÉ NO HACE:
// - NO importa Flutter, GetX ni infraestructura.
// - NO aplica reglas de negocio — solo ordenamiento técnico.
// - NO filtra alertas (aplicar dedupeAlerts antes).
//
// PRINCIPIOS:
// - Función pura: sin estado, sin side effects. Retorna nueva lista ordenada.
// - 5 reglas de sort (ver ALERTS_SYSTEM_V4.md §12.2):
//     1. severity (critical > high > medium > low)
//     2. Vencido sobre due_soon (expired > due_soon para mismo dominio)
//     3. Riesgo legal crítico sobre documental ordinario
//        (embargo_active y legal_limitation_active antes de due_soon ordinario)
//     4. Menor daysRemaining en facts (si aplica)
//     5. sourceUpdatedAt más reciente como desempate final
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 — Soporte canónico v1. Ver ALERTS_SYSTEM_V4.md §12.2.
// MOVIDO (2026-03): de lib/core/alerts/support/ → lib/domain/services/alerts/support/
//   Razón: solo depende de domain (AlertCode, AlertFactKeys, DomainAlert).
//   Moverlo aquí elimina la violación de dependencias del orquestador.
// ============================================================================

import '../../../entities/alerts/alert_code.dart';
import '../../../entities/alerts/alert_fact_keys.dart';
import '../../../entities/alerts/domain_alert.dart';

/// Ordena [alerts] según las 5 reglas canónicas de prioridad.
///
/// Retorna una nueva lista ordenada; la original no se modifica.
List<DomainAlert> sortAlerts(List<DomainAlert> alerts) {
  if (alerts.length <= 1) return List.of(alerts);

  final sorted = List.of(alerts)
    ..sort((a, b) {
      // Regla 1: severity descendente (critical=3 > low=0)
      final severityDiff = b.severity.index - a.severity.index;
      if (severityDiff != 0) return severityDiff;

      // Regla 2: vencido antes de due_soon.
      // DECISIÓN DE DISEÑO: Regla 2 tiene precedencia sobre Regla 3. Si un documental
      // vencido (e.g. soat_expired) y una alerta jurídica (e.g. embargo_active) tienen
      // el mismo severity (ambos critical), el documental vencido aparece primero.
      // Justificación: SOAT vencido = ilegalidad inmediata en vía pública. El embargo
      // es una restricción patrimonial, no operativa. Revisable en Fase 4.
      final aExpired = _isExpired(a.code);
      final bExpired = _isExpired(b.code);
      if (aExpired != bExpired) return aExpired ? -1 : 1;

      // Regla 3: alertas jurídicas críticas antes de documentales ordinarias
      final aLegal = _isLegalCritical(a.code);
      final bLegal = _isLegalCritical(b.code);
      if (aLegal != bLegal) return aLegal ? -1 : 1;

      // Regla 4: menor daysRemaining primero (más urgente)
      final aDays = _daysRemaining(a);
      final bDays = _daysRemaining(b);
      if (aDays != null && bDays != null) {
        final daysDiff = aDays - bDays;
        if (daysDiff != 0) return daysDiff;
      } else if (aDays != null) {
        return -1; // a tiene días, b no → a primero
      } else if (bDays != null) {
        return 1;
      }

      // Regla 5: sourceUpdatedAt más reciente como desempate final
      return b.sourceUpdatedAt.compareTo(a.sourceUpdatedAt);
    });

  return sorted;
}

// ─────────────────────────────────────────────────────────────────────────────
// UTILIDADES PRIVADAS
// ─────────────────────────────────────────────────────────────────────────────

/// True si el código corresponde a un documento ya vencido.
bool _isExpired(AlertCode code) => switch (code) {
      AlertCode.soatExpired ||
      AlertCode.rtmExpired ||
      AlertCode.rcContractualExpired ||
      AlertCode.rcExtracontractualExpired =>
        true,
      _ => false,
    };

/// True si el código corresponde a una alerta jurídica crítica de alta precedencia.
bool _isLegalCritical(AlertCode code) => switch (code) {
      AlertCode.embargoActive || AlertCode.legalLimitationActive => true,
      _ => false,
    };

/// Extrae daysRemaining de facts si existe y es int.
int? _daysRemaining(DomainAlert alert) {
  final v = alert.facts[AlertFactKeys.daysRemaining];
  if (v is int) return v;
  return null;
}
