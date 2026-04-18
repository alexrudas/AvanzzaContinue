// ============================================================================
// lib/domain/services/alerts/evaluators/rtm_alert_evaluator.dart
// ============================================================================

import 'dart:developer' as dev;

import 'package:uuid/uuid.dart';

import '../../../entities/alerts/alert_audience.dart';
import '../../../entities/alerts/alert_code.dart';
import '../../../entities/alerts/alert_fact_keys.dart';
import '../../../entities/alerts/alert_promotion_policy.dart';
import '../../../entities/alerts/alert_scope.dart';
import '../../../entities/alerts/alert_severity.dart';
import '../../../entities/alerts/domain_alert.dart';
import '../asset_alert_snapshot.dart';

// Placas bajo diagnóstico activo — remover tras validar WPV583/WPV585/WGA960.
const _kRtmDebugTargets = {'WPV583', 'WPV585', 'WGA960'};

DomainAlert? buildRtmAlert(AssetAlertSnapshot snapshot) {
  final nowUtc = DateTime.now().toUtc();
  final today = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);

  // ── 1. EXENCIÓN ───────────────────────────────────────────────────────────
  final exemptUntil = snapshot.rtmExemptUntil;

  if (exemptUntil != null) {
    final exemptDay =
        DateTime.utc(exemptUntil.year, exemptUntil.month, exemptUntil.day);

    if (!exemptDay.isBefore(today)) {
      final diasRestantes = exemptDay.difference(today).inDays;

      final dedupeKey = '${AlertCode.rtmExempt.wireName}:${snapshot.assetId}';

      return DomainAlert(
        id: const Uuid().v4(),
        code: AlertCode.rtmExempt,
        severity: AlertSeverity.low,
        scope: AlertScope.asset,
        audience: AlertAudience.assetAdmin,
        promotionPolicy: AlertPromotionPolicy.none,
        sourceEntityId: snapshot.assetId,
        titleKey: 'alerts.rtm_exempt.title',
        bodyKey: 'alerts.rtm_exempt.body',
        facts: {
          AlertFactKeys.daysRemaining: diasRestantes,
          AlertFactKeys.expirationDate: _isoDate(exemptUntil),
          AlertFactKeys.assetPrimaryLabel: snapshot.assetPrimaryLabel,
          if (snapshot.assetSecondaryLabel != null)
            AlertFactKeys.assetSecondaryLabel: snapshot.assetSecondaryLabel,
          if (snapshot.assetType != null)
            AlertFactKeys.assetType: snapshot.assetType,
        },
        evidenceRefs: [],
        detectedAt: nowUtc,
        sourceUpdatedAt: snapshot.sourceUpdatedAt,
        dedupeKey: dedupeKey,
      );
    }
  }

  // ── 2. SIN RTM (NO EXENTO) → RIESGO ALTO ──────────────────────────────────
  final vigencia = snapshot.rtmVigencia;

  if (vigencia == null) {
    if (_kRtmDebugTargets.contains(snapshot.assetPrimaryLabel.toUpperCase())) {
      dev.log(
        '[${snapshot.assetPrimaryLabel}] rtmVigencia=NULL → '
        'generando rtmExpired FALSO (revisar runtMetaJson del assembler)',
        name: 'RTM_EVALUATOR',
      );
    }
    final dedupeKey = '${AlertCode.rtmExpired.wireName}:${snapshot.assetId}';

    return DomainAlert(
      id: const Uuid().v4(),
      code: AlertCode.rtmExpired,
      severity: AlertSeverity.critical,
      scope: AlertScope.asset,
      audience: AlertAudience.assetAdmin,
      promotionPolicy: AlertPromotionPolicy.alwaysPromote,
      sourceEntityId: snapshot.assetId,
      titleKey: 'alerts.rtm_expired.title',
      bodyKey: 'alerts.rtm_expired.body',
      facts: {
        AlertFactKeys.daysRemaining: -1,
        AlertFactKeys.assetPrimaryLabel: snapshot.assetPrimaryLabel,
        if (snapshot.assetSecondaryLabel != null)
          AlertFactKeys.assetSecondaryLabel: snapshot.assetSecondaryLabel,
        if (snapshot.assetType != null)
          AlertFactKeys.assetType: snapshot.assetType,
      },
      evidenceRefs: [],
      detectedAt: nowUtc,
      sourceUpdatedAt: snapshot.sourceUpdatedAt,
      dedupeKey: dedupeKey,
    );
  }

  // ── 3. EVALUACIÓN NORMAL ──────────────────────────────────────────────────
  final vigenciaDay = DateTime.utc(vigencia.year, vigencia.month, vigencia.day);

  final diasRestantes = vigenciaDay.difference(today).inDays;

  if (_kRtmDebugTargets.contains(snapshot.assetPrimaryLabel.toUpperCase())) {
    final codePreview = diasRestantes < 0 ? 'rtmExpired' : 'rtmDueSoon';
    dev.log(
      '[${snapshot.assetPrimaryLabel}] '
      'vigencia_raw=$vigencia vigenciaDay=$vigenciaDay today=$today '
      'diasRestantes=$diasRestantes → code=$codePreview',
      name: 'RTM_EVALUATOR',
    );
  }

  if (diasRestantes > 30) return null;

  final code = diasRestantes < 0 ? AlertCode.rtmExpired : AlertCode.rtmDueSoon;

  final severity = diasRestantes < 0
      ? AlertSeverity.critical
      : _resolveSeverity(diasRestantes);

  final dedupeKey = '${code.wireName}:${snapshot.assetId}';

  return DomainAlert(
    id: const Uuid().v4(),
    code: code,
    severity: severity!,
    scope: AlertScope.asset,
    audience: AlertAudience.assetAdmin,
    promotionPolicy: _promotionPolicy(code),
    sourceEntityId: snapshot.assetId,
    titleKey: 'alerts.${code.wireName}.title',
    bodyKey: 'alerts.${code.wireName}.body',
    facts: {
      AlertFactKeys.daysRemaining: diasRestantes,
      AlertFactKeys.expirationDate: _isoDate(vigencia),
      AlertFactKeys.assetPrimaryLabel: snapshot.assetPrimaryLabel,
      if (snapshot.assetSecondaryLabel != null)
        AlertFactKeys.assetSecondaryLabel: snapshot.assetSecondaryLabel,
      if (snapshot.assetType != null)
        AlertFactKeys.assetType: snapshot.assetType,
    },
    evidenceRefs: [],
    detectedAt: nowUtc,
    sourceUpdatedAt: snapshot.sourceUpdatedAt,
    dedupeKey: dedupeKey,
  );
}

AlertSeverity? _resolveSeverity(int diasRestantes) {
  if (diasRestantes <= 2) return AlertSeverity.critical;
  if (diasRestantes <= 7) return AlertSeverity.high;
  if (diasRestantes <= 15) return AlertSeverity.medium;
  if (diasRestantes <= 30) return AlertSeverity.low;
  return null;
}

AlertPromotionPolicy _promotionPolicy(AlertCode code) => switch (code) {
      AlertCode.rtmExpired => AlertPromotionPolicy.alwaysPromote,
      AlertCode.rtmDueSoon => AlertPromotionPolicy.promoteIfHigh,
      _ => AlertPromotionPolicy.none,
    };

String _isoDate(DateTime date) {
  final d = date.toUtc();
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
