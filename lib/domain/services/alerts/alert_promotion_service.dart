// ============================================================================
// lib/domain/services/alerts/alert_promotion_service.dart
// ALERT PROMOTION SERVICE — Filtra alertas promovibles hacia Home
//
// QUÉ HACE:
// - Aplica las reglas de promoción de ALERTS_SYSTEM_V4.md §14.1 a una lista
//   de DomainAlert y retorna solo las que deben aparecer en Home.
// - Implementa umbral explícito: due_soon se promueve solo si daysRemaining <= 7.
// - Respeta la política aggregateOnly: nunca promovida individualmente.
// - Excluye alertas con alertKind != compliance: oportunidades y exenciones
//   nunca se promueven individualmente en Home (V5 §4).
// - Diferencia alertas RC por categoría canónica de servicio (VehicleServiceCategory):
//     publicTransport → RC equivale a SOAT/RTM (cumplimiento operativo crítico).
//     privateUse → solo rc_extracontractual_expired como riesgo patrimonial.
//     unknown → falla segura, no se promueve RC agresivamente.
//
// QUÉ NO HACE:
// - No evalúa alertas — recibe la lista ya producida por el pipeline.
// - No agrega ni agrupa (eso es responsabilidad de HomeAlertAggregationService).
// - No importa Flutter, GetX ni infraestructura.
// - No persiste ni cachea resultados.
//
// PRINCIPIOS:
// - Función pura: sin estado, sin side effects.
// - Reglas explícitas y verificables en código (V4 §19 regla 4).
// - alertKind != compliance bloquea antes de cualquier otra regla (V5 §4).
// - aggregateOnly es innegociable: ninguna otra condición puede superarlo.
// - Falla segura en umbral: si daysRemaining no existe o no es int → no promover.
// - Falla segura en servicio: si vehicleServiceCategory no existe o es unknown →
//   no promover RC. Nunca promover RC agresivamente ante datos incompletos.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 4 — Promotion Layer v1. Ver ALERTS_SYSTEM_V4.md §14.1.
// ACTUALIZADO (2026-03): Diferenciación RC por servicio (público vs particular).
// ACTUALIZADO (2026-03): V5 — Gate alertKind != compliance al inicio de
//   _shouldPromote(). Oportunidades y exenciones nunca suben a Home. Ver V5 §4.
// ============================================================================

import '../../entities/alerts/alert_code.dart';
import '../../entities/alerts/alert_fact_keys.dart';
import '../../entities/alerts/alert_kind.dart';
import '../../entities/alerts/alert_promotion_policy.dart';
import '../../entities/alerts/domain_alert.dart';
import '../../entities/alerts/vehicle_service_category.dart';

abstract final class AlertPromotionService {
  AlertPromotionService._();

  /// Días máximos para promover alertas due_soon (V4 §14.1).
  static const int _dueSoonThresholdDays = 7;

  // ─────────────────────────────────────────────────────────────────────────
  // API PÚBLICA
  // ─────────────────────────────────────────────────────────────────────────

  /// Filtra [alerts] y retorna solo las que deben aparecer individualmente en Home.
  ///
  /// Aplica las reglas de §14.1 en orden de prioridad:
  /// 1. [aggregateOnly] → nunca promovida individualmente.
  /// 2. [alwaysPromote] → promovida incondicionalmente.
  /// 3. Reglas por código: expired siempre; due_soon solo si daysRemaining <= 7.
  /// 4. Cualquier otro código → no promovido en V1.
  static List<DomainAlert> promote(List<DomainAlert> alerts) =>
      alerts.where(_shouldPromote).toList();

  // ─────────────────────────────────────────────────────────────────────────
  // LÓGICA DE PROMOCIÓN (verificable en código, no en comentarios — V4 §19)
  // ─────────────────────────────────────────────────────────────────────────

  static bool _shouldPromote(DomainAlert alert) {
    // Regla 0: solo alertas compliance pueden promoverse individualmente (V5 §4).
    // Oportunidades y exenciones no contaminan el conteo de riesgo en Home.
    if (alert.alertKind != AlertKind.compliance) return false;

    // Regla 1: aggregateOnly nunca pasa como individual — innegociable.
    if (alert.promotionPolicy == AlertPromotionPolicy.aggregateOnly) {
      return false;
    }

    // Regla 2: alwaysPromote pasa incondicionalmente.
    if (alert.promotionPolicy == AlertPromotionPolicy.alwaysPromote) {
      return true;
    }

    // Reglas 3/4/5: verificación explícita por AlertCode (V4 §14.1).
    return switch (alert.code) {
      // ── Siempre promovidas: documentos vencidos + riesgo jurídico crítico ──
      AlertCode.soatExpired ||
      AlertCode.rtmExpired ||
      AlertCode.embargoActive ||
      AlertCode.legalLimitationActive =>
        true,

      // ── Promovidas solo si el vencimiento está dentro del umbral ──────────
      AlertCode.soatDueSoon ||
      AlertCode.rtmDueSoon =>
        _withinThreshold(alert),

      // ── RC: diferenciadas por tipo de servicio del vehículo (V4 §14.1) ────
      AlertCode.rcContractualExpired ||
      AlertCode.rcExtracontractualExpired ||
      AlertCode.rcContractualDueSoon ||
      AlertCode.rcExtracontractualDueSoon ||
      AlertCode.rcContractualMissing ||
      AlertCode.rcExtracontractualMissing =>
        _shouldPromoteRc(alert),

      // ── Todo lo demás: no promovido en V1 ─────────────────────────────────
      _ => false,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────
  // RC — LÓGICA DE PROMOCIÓN DIFERENCIADA POR SERVICIO (V4 §14.1 — Fase 4)
  // ─────────────────────────────────────────────────────────────────────────

  /// Decide si una alerta RC debe subir al Home según el servicio del vehículo.
  ///
  /// PÚBLICO: RC es cumplimiento operativo crítico.
  ///   - rc_*_expired → siempre (equivalente a soat/rtm).
  ///   - rc_*_due_soon → solo si daysRemaining <= [_dueSoonThresholdDays].
  ///
  /// PARTICULAR: RC es riesgo patrimonial, no ruido operativo.
  ///   - rc_extracontractual_expired → promover (riesgo alto).
  ///   - todo lo demás → no promover en V1.
  ///
  /// UNKNOWN: falla segura → no promover RC.
  static bool _shouldPromoteRc(DomainAlert alert) {
    return switch (_resolveVehicleServiceCategory(alert)) {
      VehicleServiceCategory.publicTransport => switch (alert.code) {
          AlertCode.rcContractualExpired ||
          AlertCode.rcExtracontractualExpired ||
          AlertCode.rcContractualMissing ||
          AlertCode.rcExtracontractualMissing =>
            true,
          AlertCode.rcContractualDueSoon ||
          AlertCode.rcExtracontractualDueSoon =>
            _withinThreshold(alert),
          _ => false,
        },
      VehicleServiceCategory.privateUse => switch (alert.code) {
          AlertCode.rcExtracontractualExpired ||
          AlertCode.rcExtracontractualMissing =>
            true,
          _ => false,
        },
      // Unknown: datos incompletos → falla segura, no promover RC.
      VehicleServiceCategory.unknown => false,
    };
  }

  /// Lee la categoría canónica de servicio desde [alert.facts].
  ///
  /// Usa [AlertFactKeys.vehicleServiceCategory] (wire value poblado por el
  /// evaluador RC). Cualquier valor ausente o no reconocido → [unknown].
  static VehicleServiceCategory _resolveVehicleServiceCategory(
      DomainAlert alert) {
    final wire = alert.facts[AlertFactKeys.vehicleServiceCategory];
    if (wire is! String || wire.isEmpty) return VehicleServiceCategory.unknown;
    return VehicleServiceCategory.fromWire(wire);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS COMPARTIDOS
  // ─────────────────────────────────────────────────────────────────────────

  /// True si [alert.facts[daysRemaining]] <= [_dueSoonThresholdDays].
  ///
  /// Falla segura: si el fact no existe, no es int, o es null → retorna false.
  /// No promueve ante datos incompletos.
  static bool _withinThreshold(DomainAlert alert) {
    final days = alert.facts[AlertFactKeys.daysRemaining];
    return days is int && days <= _dueSoonThresholdDays;
  }
}
