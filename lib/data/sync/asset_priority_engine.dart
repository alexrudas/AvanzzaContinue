// ============================================================================
// lib/data/sync/asset_priority_engine.dart
// ASSET PRIORITY ENGINE — Motor unificado de prioridad de activo
//
// QUÉ HACE:
// - Calcula el score de prioridad de un activo (0–100) desde su estado de
//   cumplimiento, legal, alertas y tiempo vencido.
// - Produce un breakdown detallado de puntos por dimensión.
// - Genera `reason` (machine-readable) y `reasonHuman` (UX, catálogo cerrado)
//   desde el mismo cálculo, garantizando coherencia total.
// - Expone `safeParseDate()` como utilidad para el document builder.
//
// QUÉ NO HACE:
// - No accede a Isar ni Firestore.
// - No produce texto libre: reasonHuman siempre sale de un catálogo cerrado.
// - No depende de Flutter.
//
// PRINCIPIOS:
// - Función pura: mismo input → mismo output siempre.
// - `score`, `reason` y `reasonHuman` salen del mismo breakdown.
// - `reasonHuman` usa ComplianceLabelResolver como única fuente de labels de
//   complianceType.
// - score = min(breakdown.sum, 100).
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Asset Schema v1.3.4.
// SCORING:
//   compliance  → EXPIRED=40  | WARNING=20 | OK=0
//   legal       → DISPUTED=30 | ENCUMBERED=15 | CLEAR=0
//   alerts      → CRITICAL=25 | HIGH=15 | MEDIUM=8 | LOW=3 | null=0
//   timePenalty → >60d=15 | 30-60d=10 | 1-29d=5 | not-expired=0
//   alertCount  → >=10=6 | >=5=4 | >=2=2 | else=0
// ============================================================================

import 'domains/compliance_label_resolver.dart';

// ─────────────────────────────────────────────────────────────────────────────
// VALUE OBJECTS — Input / Output
// ─────────────────────────────────────────────────────────────────────────────

/// Estado de cumplimiento de documentos del activo.
enum ComplianceStatus {
  /// Uno o más documentos obligatorios vencidos.
  expired,

  /// Uno o más documentos próximos a vencer.
  warning,

  /// Todos los documentos en regla.
  ok,
}

/// Estado legal del activo.
enum LegalStatus {
  /// Gravamen activo (embargo, hipoteca, prenda).
  encumbered,

  /// Activo en litigio judicial.
  disputed,

  /// Sin afectaciones legales.
  clear,
}

/// Severidad máxima de alertas activas.
enum AlertSeverity {
  critical,
  high,
  medium,
  low,
}

/// Input para [AssetPriorityEngine.computePriority].
final class PriorityInput {
  /// Estado de cumplimiento documental del activo.
  final ComplianceStatus complianceStatus;

  /// Wire string del tipo de documento vencido o próximo a vencer.
  ///
  /// Ej: 'soat', 'rc_contractual', 'rtm', 'fire_insurance'.
  final String complianceType;

  /// Días transcurridos desde el vencimiento.
  ///
  /// Solo relevante cuando [complianceStatus] == [ComplianceStatus.expired].
  /// Debe ser >= 0.
  final int daysExpired;

  /// Estado legal del activo.
  final LegalStatus legalStatus;

  /// Severidad máxima de alertas activas. Null si no hay alertas.
  final AlertSeverity? alertsMaxSeverity;

  /// Cantidad total de alertas activas.
  final int alertsCount;

  const PriorityInput({
    required this.complianceStatus,
    this.complianceType = 'unknown',
    this.daysExpired = 0,
    required this.legalStatus,
    this.alertsMaxSeverity,
    this.alertsCount = 0,
  })  : assert(daysExpired >= 0, 'daysExpired must be >= 0'),
        assert(alertsCount >= 0, 'alertsCount must be >= 0'),
        assert(
          alertsCount > 0 || alertsMaxSeverity == null,
          'alertsMaxSeverity must be null when alertsCount == 0',
        );
}

/// Desglose de puntos por dimensión.
final class PriorityBreakdown {
  final int compliance;
  final int legal;
  final int alerts;
  final int timePenalty;
  final int alertCountBonus;

  const PriorityBreakdown({
    required this.compliance,
    required this.legal,
    required this.alerts,
    required this.timePenalty,
    required this.alertCountBonus,
  });

  /// Suma total pre-clamp (puede superar 100).
  int get sum => compliance + legal + alerts + timePenalty + alertCountBonus;

  @override
  String toString() =>
      'PriorityBreakdown(compliance=$compliance, legal=$legal, '
      'alerts=$alerts, timePenalty=$timePenalty, '
      'alertCountBonus=$alertCountBonus, sum=$sum)';
}

/// Resultado completo del cálculo de prioridad.
final class PriorityResult {
  /// Score final (0–100, clamped).
  final int score;

  /// Desglose de puntos por dimensión.
  final PriorityBreakdown breakdown;

  /// Razón machine-readable (para logs, diagnóstico, Firestore priorityReason).
  final String reason;

  /// Razón UX legible en español (para Firestore priorityReasonHuman).
  final String reasonHuman;

  /// Días vencidos pasados a través (útil para trazabilidad y tests).
  final int daysExpired;

  const PriorityResult({
    required this.score,
    required this.breakdown,
    required this.reason,
    required this.reasonHuman,
    required this.daysExpired,
  });

  @override
  String toString() =>
      'PriorityResult(score=$score, reason=$reason, reasonHuman=$reasonHuman)';
}

// ─────────────────────────────────────────────────────────────────────────────
// ENGINE
// ─────────────────────────────────────────────────────────────────────────────

/// Motor unificado de cálculo de prioridad de activos.
///
/// Todas las llamadas son estáticas — no mantiene estado.
abstract final class AssetPriorityEngine {
  // ==========================================================================
  // API PÚBLICA
  // ==========================================================================

  /// Calcula el score de prioridad y produce el resultado completo.
  ///
  /// Garantías:
  /// - [PriorityResult.score] == `min(breakdown.sum, 100)`.
  /// - [PriorityResult.reason] y [PriorityResult.reasonHuman] son coherentes
  ///   con el mismo [breakdown].
  /// - Mismo input → mismo output siempre (función pura).
  static PriorityResult computePriority(PriorityInput input) {
    final compliancePts = _compliancePoints(input.complianceStatus);
    final legalPts = _legalPoints(input.legalStatus);
    final alertsPts = _alertsPoints(input.alertsMaxSeverity);
    final timePts = input.complianceStatus == ComplianceStatus.expired
        ? _timePenalty(input.daysExpired)
        : 0;
    final countBonus = _alertCountBonus(input.alertsCount);

    final breakdown = PriorityBreakdown(
      compliance: compliancePts,
      legal: legalPts,
      alerts: alertsPts,
      timePenalty: timePts,
      alertCountBonus: countBonus,
    );

    final score = breakdown.sum.clamp(0, 100);

    return PriorityResult(
      score: score,
      breakdown: breakdown,
      reason: _buildReason(input, breakdown),
      reasonHuman: _buildReasonHuman(input, breakdown),
      daysExpired: input.daysExpired,
    );
  }

  /// Parsea una fecha string de forma segura.
  ///
  /// - Acepta ISO-8601.
  /// - Fallback: `DateTime.utc(0)` si el valor es null o no parseable.
  ///
  /// Uso: en AssetDocumentBuilder para calcular daysExpired desde fechas.
  static DateTime safeParseDate(String? value) {
    if (value == null || value.isEmpty) return DateTime.utc(0);

    try {
      return DateTime.parse(value).toUtc();
    } catch (_) {
      return DateTime.utc(0);
    }
  }

  // ==========================================================================
  // SCORING — puntos por dimensión
  // ==========================================================================

  static int _compliancePoints(ComplianceStatus status) => switch (status) {
        ComplianceStatus.expired => 40,
        ComplianceStatus.warning => 20,
        ComplianceStatus.ok => 0,
      };

  static int _legalPoints(LegalStatus status) => switch (status) {
        LegalStatus.disputed => 30,
        LegalStatus.encumbered => 15,
        LegalStatus.clear => 0,
      };

  static int _alertsPoints(AlertSeverity? severity) => switch (severity) {
        AlertSeverity.critical => 25,
        AlertSeverity.high => 15,
        AlertSeverity.medium => 8,
        AlertSeverity.low => 3,
        null => 0,
      };

  /// Penalización temporal por días vencidos (solo cuando compliance=EXPIRED).
  static int _timePenalty(int daysExpired) {
    if (daysExpired > 60) return 15;
    if (daysExpired >= 30) return 10;
    if (daysExpired > 0) return 5;
    return 0;
  }

  /// Bonus por cantidad de alertas activas.
  static int _alertCountBonus(int count) {
    if (count >= 10) return 6;
    if (count >= 5) return 4;
    if (count >= 2) return 2;
    return 0;
  }

  // ==========================================================================
  // REASON — machine-readable
  // ==========================================================================

  static String _buildReason(PriorityInput input, PriorityBreakdown bd) {
    if (bd.sum == 0) return '';

    final parts = <String>[];

    if (bd.compliance > 0) {
      final status = input.complianceStatus.name.toUpperCase();
      parts.add('compliance=$status(${input.complianceType})');

      if (bd.timePenalty > 0) {
        parts.add('daysExpired=${input.daysExpired}');
      }
    }

    if (bd.legal > 0) {
      parts.add('legal=${input.legalStatus.name.toUpperCase()}');
    }

    if (bd.alerts > 0 && input.alertsCount > 0) {
      final sev = input.alertsMaxSeverity?.name.toUpperCase() ?? '';
      parts.add('alerts=$sev(count=${input.alertsCount})');
    }

    return parts.join(' | ');
  }

  // ==========================================================================
  // REASON HUMAN — catálogo cerrado de plantillas UX
  // ==========================================================================

  static String _buildReasonHuman(PriorityInput input, PriorityBreakdown bd) {
    if (bd.sum == 0) return 'Al día';

    final fragments = <String>[];

    // 1. Compliance
    if (bd.compliance > 0) {
      final label = ComplianceLabelResolver.resolve(input.complianceType);

      final complianceFragment = switch (input.complianceStatus) {
        ComplianceStatus.expired =>
          '$label vencido hace ${input.daysExpired} día${input.daysExpired == 1 ? '' : 's'}',
        ComplianceStatus.warning => '$label próximo a vencer',
        ComplianceStatus.ok => '',
      };

      if (complianceFragment.isNotEmpty) {
        fragments.add(complianceFragment);
      }
    }

    // 2. Legal
    if (bd.legal > 0) {
      final legalFragment = switch (input.legalStatus) {
        LegalStatus.encumbered => 'Gravamen activo',
        LegalStatus.disputed => 'En litigio',
        LegalStatus.clear => '',
      };

      if (legalFragment.isNotEmpty) {
        fragments.add(legalFragment);
      }
    }

    // 3. Alerts
    if (bd.alerts > 0 &&
        input.alertsMaxSeverity != null &&
        input.alertsCount > 0) {
      final count = input.alertsCount;
      final plural = count == 1 ? '' : 's';

      final alertsFragment = switch (input.alertsMaxSeverity!) {
        AlertSeverity.critical => '$count alerta$plural crítica$plural',
        AlertSeverity.high => '$count alerta$plural alta$plural',
        AlertSeverity.medium => '$count alerta$plural media$plural',
        AlertSeverity.low => '$count alerta$plural baja$plural',
      };

      fragments.add(alertsFragment);
    }

    final nonEmpty = fragments.take(3).toList();
    return nonEmpty.isEmpty ? 'Al día' : nonEmpty.join(' + ');
  }
}
