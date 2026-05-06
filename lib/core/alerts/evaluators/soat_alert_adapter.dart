// ============================================================================
// lib/core/alerts/evaluators/soat_alert_adapter.dart
// SOAT ALERT ADAPTER — Adapter entre SoatCampaignEvaluator y DomainAlert
//
// QUÉ HACE:
// - Llama evaluateSoat() y getSoatPriority() del evaluador existente.
// - Traduce SoatPriority → AlertSeverity usando el mapeo canónico.
// - Construye y retorna DomainAlert con code soat_expired o soat_due_soon.
// - Retorna null si la póliza SOAT no existe o la prioridad es none.
//
// QUÉ NO HACE:
// - NO duplica ni reescribe la lógica de evaluateSoat() ni getSoatPriority().
// - NO importa Flutter ni GetX.
// - NO persiste alertas.
//
// PRINCIPIOS:
// - Ubicado en core/ porque importa soat_campaign_evaluator.dart (core).
//   Domain no puede importar core — pero core puede importar domain.
// - Función pura: sin estado, sin side effects.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 — Adapter SOAT canónico v1.
//   Ver ALERTS_SYSTEM_V4.md §9. Decisión de ubicación en §3.4.
// ============================================================================

import 'dart:developer' as dev;

import 'package:uuid/uuid.dart';

import '../../../domain/entities/alerts/alert_audience.dart';
import '../../../domain/entities/alerts/alert_code.dart';
import '../../../domain/entities/alerts/alert_promotion_policy.dart';
import '../../../domain/entities/alerts/alert_scope.dart';
import '../../../domain/entities/alerts/alert_severity.dart';
import '../../../domain/entities/alerts/domain_alert.dart';
import '../../../domain/entities/insurance/insurance_policy_entity.dart';
import '../../../domain/services/alerts/asset_alert_snapshot.dart';
import '../../campaign/soat/soat_campaign_evaluator.dart';
import '../../../domain/entities/alerts/alert_evidence_keys.dart';
import '../../../domain/entities/alerts/alert_fact_keys.dart';

// @audit-temp [AUDIT_VRC_DEBUG] — diagnóstico end-to-end VRC → AlertCenter.
// Eliminar tras validar las 4 placas. Buscar prefijo "[AUDIT_VRC_DEBUG]".
const Set<String> _kSoatAuditPlates = {
  'WPV760',
  'WPV583',
  'WPV585',
  'WGA960',
};
bool _soatAuditMatch(String? placa) =>
    placa != null && _kSoatAuditPlates.contains(placa.trim().toUpperCase());

/// Genera la alerta SOAT canónica para el activo descrito en [snapshot].
///
/// Retorna null si:
/// - [snapshot.soatPolicy] es null (no existe póliza SOAT).
/// - La prioridad calculada es [SoatPriority.none] (> 30 días: sin urgencia).
DomainAlert? buildSoatAlert(AssetAlertSnapshot snapshot) {
  // @audit-temp [AUDIT_VRC_DEBUG]
  final auditOn = _soatAuditMatch(snapshot.placa);

  final policy = snapshot.soatPolicy;
  if (policy == null) {
    // @audit-temp [AUDIT_VRC_DEBUG]
    if (auditOn) {
      dev.log(
        '[AUDIT_VRC_DEBUG] [${snapshot.placa}] [SOAT_ADAPTER] '
        'policy=null → return null. '
        'CONSECUENCIA: NO se genera alerta SOAT (ni soat_missing existe en V1).',
        name: 'AUDIT_VRC',
      );
    }
    return null;
  }

  // Delegar cálculo al evaluador existente (FUENTE ÚNICA DE VERDAD para SOAT)
  final evaluation = evaluateSoat(policy.fechaFin);
  final priority = getSoatPriority(evaluation.diasRestantes);

  // @audit-temp [AUDIT_VRC_DEBUG]
  if (auditOn) {
    dev.log(
      '[AUDIT_VRC_DEBUG] [${snapshot.placa}] [SOAT_ADAPTER] '
      'policy.id=${policy.id} fechaFin=${policy.fechaFin.toIso8601String()} '
      'evalState=${evaluation.state.name} diasRestantes=${evaluation.diasRestantes} '
      'priority=${priority.name}',
      name: 'AUDIT_VRC',
    );
  }

  // Sin urgencia — no se genera alerta
  if (priority == SoatPriority.none) {
    // @audit-temp [AUDIT_VRC_DEBUG]
    if (auditOn) {
      dev.log(
        '[AUDIT_VRC_DEBUG] [${snapshot.placa}] [SOAT_ADAPTER] '
        'priority=none (>30 días) → return null. Sin alerta SOAT en este ciclo.',
        name: 'AUDIT_VRC',
      );
    }
    return null;
  }

  final severity = _mapPriority(priority);
  final code = evaluation.state == SoatState.expired
      ? AlertCode.soatExpired
      : AlertCode.soatDueSoon;

  // @audit-temp [AUDIT_VRC_DEBUG]
  if (auditOn) {
    dev.log(
      '[AUDIT_VRC_DEBUG] [${snapshot.placa}] [SOAT_ADAPTER] EXIT '
      'code=${code.wireName} severity=${severity.name}',
      name: 'AUDIT_VRC',
    );
  }

  // primaryEvidenceId = policy.id (sourceId del primer evidenceRef)
  final dedupeKey =
      '${code.wireName}:${AlertScope.asset.wireName}:${snapshot.assetId}:${policy.id}';

  return DomainAlert(
    // id es efímero por ejecución — la identidad estable de deduplicación es dedupeKey.
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
      AlertFactKeys.daysRemaining: evaluation.diasRestantes,
      // Contrato AlertFactKeys.expirationDate: YYYY-MM-DD (no timestamp completo).
      // Parseo manual a UTC para evitar que toIso8601String() emita la zona horaria.
      AlertFactKeys.expirationDate: _isoDate(policy.fechaFin),
      AlertFactKeys.policyType: InsurancePolicyType.soat.toWireString(),
      AlertFactKeys.sourceName: policy.aseguradora,
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
// MAPEO DE PRIORIDAD (Ver ALERTS_SYSTEM_V4.md §6.2)
// ─────────────────────────────────────────────────────────────────────────────

AlertSeverity _mapPriority(SoatPriority priority) => switch (priority) {
      SoatPriority.critical => AlertSeverity.critical,
      SoatPriority.high => AlertSeverity.high,
      SoatPriority.medium => AlertSeverity.medium,
      SoatPriority.low => AlertSeverity.low,
      // none es unreachable por contrato: se filtra antes de llamar a _mapPriority.
      // StateError para disciplina dura — si llega aquí es un bug del llamador.
      SoatPriority.none => throw StateError(
          '_mapPriority: SoatPriority.none no debe llegar aquí. '
          'Filtrar antes con: if (priority == SoatPriority.none) return null.',
        ),
    };

AlertPromotionPolicy _promotionPolicy(AlertCode code) => switch (code) {
      AlertCode.soatExpired => AlertPromotionPolicy.alwaysPromote,
      AlertCode.soatDueSoon => AlertPromotionPolicy.promoteIfHigh,
      _ => AlertPromotionPolicy.none,
    };

/// Formatea [date] como YYYY-MM-DD en UTC.
///
/// Parseo manual para garantizar salida date-only conforme al contrato de
/// [AlertFactKeys.expirationDate]. No usar toIso8601String(): emite timestamp
/// completo con zona horaria.
String _isoDate(DateTime date) {
  final d = date.toUtc();
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
