// ============================================================================
// lib/domain/services/alerts/evaluators/rc_alert_evaluator.dart
// RC ALERT EVALUATOR — Evaluador de alertas de pólizas RC
//
// QUÉ HACE:
// - Evalúa el estado de pólizas RC Contractual y RC Extracontractual.
// - Genera DomainAlert con code rc_*_expired o rc_*_due_soon si hay póliza.
// - Genera DomainAlert compliance (missing) para ausencia de póliza RC cuando
//   el tipo de servicio lo requiere (ver reglas en _evaluateMissing).
// - Genera DomainAlert opportunity (rcExtracontractualOpportunity) para
//   vehículos de servicio particular sin RC Extracontractual.
// - Retorna lista vacía si ninguna condición aplica.
//
// QUÉ NO HACE:
// - NO importa Flutter, GetX ni infraestructura.
// - NO accede a repositorios — recibe el snapshot ya construido.
// - NO decide qué alertas suben a Home (esa responsabilidad es de AlertPromotionService).
// - NO usa vehicleServiceType raw para tomar decisiones. — usa snapshot.vehicleServiceCategory.
//
// PRINCIPIOS:
// - Función pura: sin estado, sin side effects.
// - Umbrales alineados con SoatCampaignEvaluator y RtmAlertEvaluator.
// - Procesa ambos tipos RC en una sola llamada para reducir boilerplate.
// - Ausencia de RC se evalúa solo cuando la política de servicio lo justifica.
//   Servicio desconocido → falla segura → no genera alertas missing.
// - vehicleServiceCategory es la fuente canónica: el evaluador nunca
//   interpreta vehicleServiceType raw. El assembler normaliza antes.
// - evidenceRefs en missing/opportunity: ancla la alerta al activo (la
//   ausencia es observable sobre el activo mismo). Nunca lista vacía.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 — Evaluador RC v1.
// ACTUALIZADO (2026-03): Soporte para alertas missing por ausencia de póliza RC
//   según tipo de servicio del vehículo.
// ACTUALIZADO (2026-03): evidenceRefs en missing anclados al activo para
//   mantener trazabilidad cuando no existe documento de póliza.
// ACTUALIZADO (2026-03): V5 — Migrado a snapshot.vehicleServiceCategory como
//   fuente canónica para decisiones de servicio vehicular.
// ACTUALIZADO (2026-03): V5 — Particular sin RC extracontractual modelado como
//   rcExtracontractualOpportunity con alertKind opportunity,
//   severity low y promotionPolicy aggregateOnly.
// ============================================================================

import 'package:uuid/uuid.dart';

import '../../../entities/alerts/alert_audience.dart';
import '../../../entities/alerts/alert_code.dart';
import '../../../entities/alerts/alert_evidence_keys.dart';
import '../../../entities/alerts/alert_fact_keys.dart';
import '../../../entities/alerts/alert_kind.dart';
import '../../../entities/alerts/alert_promotion_policy.dart';
import '../../../entities/alerts/alert_scope.dart';
import '../../../entities/alerts/alert_severity.dart';
import '../../../entities/alerts/domain_alert.dart';
import '../../../entities/alerts/vehicle_service_category.dart';
import '../../../entities/insurance/insurance_policy_entity.dart';
import '../asset_alert_snapshot.dart';

// ─────────────────────────────────────────────────────────────────────────────
// API PÚBLICA
// ─────────────────────────────────────────────────────────────────────────────

/// Genera alertas RC para el activo descrito en [snapshot].
///
/// Por cada tipo RC evalúa en orden de exclusión:
/// 1. Si hay póliza → evalúa estado (expired / due_soon).
/// 2. Si no hay póliza → evalúa ausencia según vehicleServiceCategory.
///
/// Retorna lista vacía si ninguna condición aplica.
List<DomainAlert> buildRcAlerts(AssetAlertSnapshot snapshot) {
  final alerts = <DomainAlert>[];

  // ── RC Contractual ────────────────────────────────────────────────────────
  if (snapshot.rcContractualPolicy != null) {
    final alert = _evaluate(
      snapshot: snapshot,
      policy: snapshot.rcContractualPolicy!,
      expiredCode: AlertCode.rcContractualExpired,
      dueSoonCode: AlertCode.rcContractualDueSoon,
      policyTypeWire: InsurancePolicyType.rcContractual.toWireString(),
    );
    if (alert != null) alerts.add(alert);
  } else {
    final missing = _evaluateMissing(
      snapshot: snapshot,
      code: AlertCode.rcContractualMissing,
      policyTypeWire: InsurancePolicyType.rcContractual.toWireString(),
      isContractual: true,
    );
    if (missing != null) alerts.add(missing);
  }

  // ── RC Extracontractual ───────────────────────────────────────────────────
  if (snapshot.rcExtracontractualPolicy != null) {
    final alert = _evaluate(
      snapshot: snapshot,
      policy: snapshot.rcExtracontractualPolicy!,
      expiredCode: AlertCode.rcExtracontractualExpired,
      dueSoonCode: AlertCode.rcExtracontractualDueSoon,
      policyTypeWire: InsurancePolicyType.rcExtracontractual.toWireString(),
    );
    if (alert != null) alerts.add(alert);
  } else {
    final missing = _evaluateMissing(
      snapshot: snapshot,
      code: AlertCode.rcExtracontractualMissing,
      policyTypeWire: InsurancePolicyType.rcExtracontractual.toWireString(),
      isContractual: false,
    );
    if (missing != null) alerts.add(missing);
  }

  return alerts;
}

// ─────────────────────────────────────────────────────────────────────────────
// EVALUACIÓN INTERNA — reutilizable por ambos tipos RC
// ─────────────────────────────────────────────────────────────────────────────

/// Evalúa el estado de una póliza RC existente y retorna la alerta correspondiente.
///
/// [policy] es no-nullable: el caller ya verificó su presencia antes de llamar.
/// Retorna null si la póliza tiene más de 30 días restantes (sin urgencia).
DomainAlert? _evaluate({
  required AssetAlertSnapshot snapshot,
  required InsurancePolicyEntity policy,
  required AlertCode expiredCode,
  required AlertCode dueSoonCode,
  required String policyTypeWire,
}) {
  // Comparación por fecha calendario (UTC): normalizar ambos extremos a medianoche
  // para evitar off-by-1 cuando fechaFin es medianoche UTC y now es mediodía.
  final nowUtc = DateTime.now().toUtc();
  final today = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);
  final finDay = DateTime.utc(
      policy.fechaFin.year, policy.fechaFin.month, policy.fechaFin.day);
  final diasRestantes = finDay.difference(today).inDays;

  final severity = _resolveSeverity(diasRestantes);
  if (severity == null) return null; // > 30 días: sin urgencia

  final code = diasRestantes < 0 ? expiredCode : dueSoonCode;
  // primaryEvidenceId = policy.id (sourceId del primer evidenceRef)
  final dedupeKey =
      '${code.wireName}:${AlertScope.asset.wireName}:${snapshot.assetId}:${policy.id}';

  return DomainAlert(
    id: const Uuid().v4(),
    code: code,
    severity: severity,
    scope: AlertScope.asset,
    audience: AlertAudience.assetAdmin,
    promotionPolicy: _promotionPolicy(code),
    sourceEntityId: snapshot.assetId,
    titleKey: 'alerts.${code.wireName}.title',
    bodyKey: 'alerts.${code.wireName}.body',
    facts: {
      AlertFactKeys.daysRemaining: diasRestantes,
      // Contrato AlertFactKeys.expirationDate: YYYY-MM-DD (no timestamp completo).
      AlertFactKeys.expirationDate: _isoDate(policy.fechaFin),
      AlertFactKeys.policyType: policyTypeWire,
      AlertFactKeys.sourceName: policy.aseguradora,
      // Clasificación canónica — fuente para AlertPromotionService (V5).
      AlertFactKeys.vehicleServiceCategory: snapshot.vehicleServiceCategory.wireName,
      // Raw conservado por compatibilidad/trazabilidad.
      AlertFactKeys.vehicleServiceType: snapshot.vehicleServiceType,
      // Identidad del activo — snapshot del evaluador (mismo objeto que evaluación).
      AlertFactKeys.assetPrimaryLabel: snapshot.assetPrimaryLabel,
      if (snapshot.assetSecondaryLabel != null)
        AlertFactKeys.assetSecondaryLabel: snapshot.assetSecondaryLabel,
      if (snapshot.assetType != null)
        AlertFactKeys.assetType: snapshot.assetType,
    },
    evidenceRefs: [
      {
        AlertEvidenceKeys.sourceType: 'insurance_policy',
        AlertEvidenceKeys.sourceId: policy.id,
        AlertEvidenceKeys.sourceCollection: 'insurance_policies',
        AlertEvidenceKeys.documentId: policy.policyId,
      }
    ],
    detectedAt: DateTime.now().toUtc(),
    sourceUpdatedAt: policy.updatedAt ?? snapshot.sourceUpdatedAt,
    dedupeKey: dedupeKey,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// ALERTAS MISSING / OPPORTUNITY — ausencia total de póliza RC
// ─────────────────────────────────────────────────────────────────────────────

/// Genera alerta de ausencia de póliza RC según [vehicleServiceCategory].
///
/// PUBLIC_TRANSPORT:
///   Contractual y extracontractual son obligatorias →
///   compliance, critical, alwaysPromote.
///
/// PRIVATE_USE + extracontractual:
///   Señal comercial, no incumplimiento →
///   opportunity (rcExtracontractualOpportunity), low, aggregateOnly.
///
/// PRIVATE_USE + contractual:
///   No generar en V1. Ver ALERTS_SYSTEM_V5.md §14.1.
///
/// UNKNOWN:
///   Falla segura → no generar alertas.
DomainAlert? _evaluateMissing({
  required AssetAlertSnapshot snapshot,
  required AlertCode code,
  required String policyTypeWire,
  required bool isContractual,
}) {
  final category = snapshot.vehicleServiceCategory;

  final AlertCode effectiveCode;
  final AlertKind alertKind;
  final AlertSeverity severity;
  final AlertPromotionPolicy promotionPolicy;

  if (category == VehicleServiceCategory.publicTransport) {
    // Público: ambas RC son de cumplimiento obligatorio → crítico, siempre promover.
    effectiveCode = code;
    alertKind = AlertKind.compliance;
    severity = AlertSeverity.critical;
    promotionPolicy = AlertPromotionPolicy.alwaysPromote;
  } else if (category == VehicleServiceCategory.privateUse && !isContractual) {
    // Particular extracontractual: ausencia es señal comercial, no incumplimiento.
    effectiveCode = AlertCode.rcExtracontractualOpportunity;
    alertKind = AlertKind.opportunity;
    severity = AlertSeverity.low;
    promotionPolicy = AlertPromotionPolicy.aggregateOnly;
  } else {
    // Particular contractual → no generar en V1.
    // Unknown → falla segura, no promover.
    return null;
  }

  final dedupeKey =
      '${effectiveCode.wireName}:${AlertScope.asset.wireName}:${snapshot.assetId}:missing';

  return DomainAlert(
    id: const Uuid().v4(),
    code: effectiveCode,
    severity: severity,
    alertKind: alertKind,
    scope: AlertScope.asset,
    audience: AlertAudience.assetAdmin,
    promotionPolicy: promotionPolicy,
    sourceEntityId: snapshot.assetId,
    titleKey: 'alerts.${effectiveCode.wireName}.title',
    bodyKey: 'alerts.${effectiveCode.wireName}.body',
    facts: {
      // Clasificación canónica — fuente para AlertPromotionService (V5).
      AlertFactKeys.vehicleServiceCategory: snapshot.vehicleServiceCategory.wireName,
      // Raw conservado por compatibilidad/trazabilidad.
      AlertFactKeys.vehicleServiceType: snapshot.vehicleServiceType,
      AlertFactKeys.policyType: policyTypeWire,
      // Identidad del activo — snapshot del evaluador (mismo objeto que evaluación).
      AlertFactKeys.assetPrimaryLabel: snapshot.assetPrimaryLabel,
      if (snapshot.assetSecondaryLabel != null)
        AlertFactKeys.assetSecondaryLabel: snapshot.assetSecondaryLabel,
      if (snapshot.assetType != null)
        AlertFactKeys.assetType: snapshot.assetType,
    },
    // Ausencia de póliza: la evidencia es el activo mismo.
    // No existe documento RC → se ancla al activo para mantener trazabilidad.
    evidenceRefs: [
      {
        AlertEvidenceKeys.sourceType: 'asset',
        AlertEvidenceKeys.sourceId: snapshot.assetId,
        AlertEvidenceKeys.sourceCollection: 'assets',
        AlertEvidenceKeys.documentId: snapshot.assetId,
      }
    ],
    detectedAt: DateTime.now().toUtc(),
    sourceUpdatedAt: snapshot.sourceUpdatedAt,
    dedupeKey: dedupeKey,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// RESOLUCIÓN DE SEVERIDAD
// ─────────────────────────────────────────────────────────────────────────────

AlertSeverity? _resolveSeverity(int diasRestantes) {
  if (diasRestantes <= 2) {
    return AlertSeverity.critical; // incluye vencida (< 0)
  }
  if (diasRestantes <= 7) return AlertSeverity.high;
  if (diasRestantes <= 15) return AlertSeverity.medium;
  if (diasRestantes <= 30) return AlertSeverity.low;
  return null;
}

// DECISIÓN V1: rcExpired → promoteIfCritical (no alwaysPromote).
// V4 §14.1 lista soat_expired, rtm_expired, embargo_active y legal_limitation_active
// como "promover siempre". RC expired no está en esa lista — se considera menos
// crítico que SOAT/RTM (RC cubre responsabilidad civil, no circulación ilegal).
// RC missing para servicio público: promovida con alwaysPromote desde _evaluateMissing,
// nunca pasa por aquí. Esta función aplica exclusivamente a alertas con póliza presente.
AlertPromotionPolicy _promotionPolicy(AlertCode code) => switch (code) {
      AlertCode.rcContractualExpired ||
      AlertCode.rcExtracontractualExpired =>
        AlertPromotionPolicy.promoteIfCritical,
      AlertCode.rcContractualDueSoon ||
      AlertCode.rcExtracontractualDueSoon =>
        AlertPromotionPolicy.promoteIfHigh,
      _ => AlertPromotionPolicy.none,
    };

/// Formatea [date] como YYYY-MM-DD en UTC.
///
/// Garantiza salida date-only conforme al contrato de [AlertFactKeys.expirationDate].
String _isoDate(DateTime date) {
  final d = date.toUtc();
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
