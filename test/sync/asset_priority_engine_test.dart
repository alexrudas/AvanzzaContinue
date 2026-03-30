// ============================================================================
// test/sync/asset_priority_engine_test.dart
// ASSET PRIORITY ENGINE TESTS
//
// QUÉ HACE:
// - Valida el scoring de computePriority() para todos los casos de referencia.
// - Verifica que score == breakdown.sum (pre-clamp) o 100 (clamped).
// - Verifica determinismo: mismo input → mismo output en múltiples llamadas.
// - Valida reasonHuman con el catálogo cerrado de plantillas.
// - Valida safeParseDate() con ISO-8601 válido, null e inválido.
// - Verifica composición de hasta 3 fragmentos en reasonHuman.
//
// QUÉ NO HACE:
// - No prueba Isar ni Firestore.
// - No valida UI ni controllers.
//
// SCORING VIGENTE (asset_priority_engine.dart):
//   compliance  → EXPIRED=40  | WARNING=20 | OK=0
//   legal       → DISPUTED=30 | ENCUMBERED=15 | CLEAR=0
//   alerts      → CRITICAL=25 | HIGH=15 | MEDIUM=8 | LOW=3 | null=0
//   timePenalty → >60d=15 | 30-60d=10 | 1-29d=5 | not-expired=0
//   alertCount  → >=10=6 | >=5=4 | >=2=2 | else=0
// ============================================================================

import 'package:avanzza/data/sync/asset_priority_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ==========================================================================
  // Score — casos de referencia
  // ==========================================================================

  group('computePriority() — score', () {
    test('todo en regla → score 0', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.ok,
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.score, 0);
      expect(result.breakdown.sum, 0);
      expect(result.reasonHuman, 'Al día');
      expect(result.reason, '');
    });

    test('solo WARNING → score 20', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.warning,
          complianceType: 'soat',
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.score, 20);
      expect(result.breakdown.compliance, 20);
      expect(result.breakdown.legal, 0);
      expect(result.breakdown.timePenalty, 0);
    });

    test('EXPIRED 45 días (SOAT) → score 50', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 45,
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.score, 50);
      expect(result.breakdown.compliance, 40);
      expect(result.breakdown.timePenalty, 10);
      expect(result.breakdown.legal, 0);
      expect(result.daysExpired, 45);
    });

    test('EXPIRED 45d + ENCUMBERED → score 65', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 45,
          legalStatus: LegalStatus.encumbered,
        ),
      );

      expect(result.score, 65);
      expect(result.breakdown.compliance, 40);
      expect(result.breakdown.timePenalty, 10);
      expect(result.breakdown.legal, 15);
    });

    test('EXPIRED 45d + DISPUTED → score 80', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 45,
          legalStatus: LegalStatus.disputed,
        ),
      );

      expect(result.score, 80);
      expect(result.breakdown.compliance, 40);
      expect(result.breakdown.timePenalty, 10);
      expect(result.breakdown.legal, 30);
    });

    test('peor caso posible → score 100 (clamped)', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 90,
          legalStatus: LegalStatus.disputed,
          alertsMaxSeverity: AlertSeverity.critical,
          alertsCount: 10,
        ),
      );

      expect(result.breakdown.sum, 116); // 40 + 30 + 25 + 15 + 6
      expect(result.score, 100);
    });

    test('timePenalty <30d → 5 puntos', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 15,
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.breakdown.timePenalty, 5);
      expect(result.score, 45);
    });

    test('timePenalty >=30d y <=60d → 10 puntos', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 30,
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.breakdown.timePenalty, 10);
      expect(result.score, 50);
    });

    test('timePenalty >60d → 15 puntos', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 61,
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.breakdown.timePenalty, 15);
      expect(result.score, 55);
    });

    test('timePenalty NO aplica cuando compliance=WARNING', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.warning,
          complianceType: 'soat',
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.breakdown.timePenalty, 0);
      expect(result.score, 20);
    });

    test('alertCountBonus — >=2 → 2 puntos', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.ok,
          legalStatus: LegalStatus.clear,
          alertsMaxSeverity: AlertSeverity.low,
          alertsCount: 2,
        ),
      );

      expect(result.breakdown.alertCountBonus, 2);
      expect(result.breakdown.alerts, 3);
      expect(result.score, 5);
    });

    test('alertCountBonus — >=5 → 4 puntos', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.ok,
          legalStatus: LegalStatus.clear,
          alertsMaxSeverity: AlertSeverity.high,
          alertsCount: 5,
        ),
      );

      expect(result.breakdown.alertCountBonus, 4);
      expect(result.breakdown.alerts, 15);
      expect(result.score, 19);
    });

    test('alertCountBonus — >=10 → 6 puntos', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.ok,
          legalStatus: LegalStatus.clear,
          alertsMaxSeverity: AlertSeverity.critical,
          alertsCount: 10,
        ),
      );

      expect(result.breakdown.alertCountBonus, 6);
      expect(result.breakdown.alerts, 25);
      expect(result.score, 31);
    });

    test('score == min(breakdown.sum, 100) — propiedad invariante', () {
      final cases = [
        const PriorityInput(
          complianceStatus: ComplianceStatus.warning,
          legalStatus: LegalStatus.encumbered,
          alertsMaxSeverity: AlertSeverity.medium,
          alertsCount: 3,
        ),
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 30,
          legalStatus: LegalStatus.disputed,
          alertsMaxSeverity: AlertSeverity.high,
          alertsCount: 5,
        ),
      ];

      for (final input in cases) {
        final result = AssetPriorityEngine.computePriority(input);
        expect(result.score, result.breakdown.sum.clamp(0, 100));
      }
    });
  });

  // ==========================================================================
  // reasonHuman — catálogo de plantillas
  // ==========================================================================

  group('computePriority() — reasonHuman', () {
    test('score=0 → "Al día"', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.ok,
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.reasonHuman, 'Al día');
    });

    test('EXPIRED SOAT 45d → plantilla con label y días', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 45,
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.reasonHuman, 'SOAT vencido hace 45 días');
    });

    test('EXPIRED SOAT 1d → singular "día"', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 1,
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.reasonHuman, 'SOAT vencido hace 1 día');
    });

    test('WARNING RTM → plantilla de warning con label correcto', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.warning,
          complianceType: 'rtm',
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.reasonHuman, 'Revisión técnica próximo a vencer');
    });

    test('ENCUMBERED solo → "Gravamen activo"', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.ok,
          legalStatus: LegalStatus.encumbered,
        ),
      );

      expect(result.reasonHuman, 'Gravamen activo');
    });

    test('DISPUTED solo → "En litigio"', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.ok,
          legalStatus: LegalStatus.disputed,
        ),
      );

      expect(result.reasonHuman, 'En litigio');
    });

    test('EXPIRED(45d) + DISPUTED → composición con "+"', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 45,
          legalStatus: LegalStatus.disputed,
        ),
      );

      expect(result.reasonHuman, 'SOAT vencido hace 45 días + En litigio');
    });

    test('3 fragmentos: compliance + legal + alerts en orden estable', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 45,
          legalStatus: LegalStatus.disputed,
          alertsMaxSeverity: AlertSeverity.critical,
          alertsCount: 3,
        ),
      );

      expect(
        result.reasonHuman,
        'SOAT vencido hace 45 días + En litigio + 3 alertas críticas',
      );
    });

    test('CRITICAL 1 alerta → singular', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.ok,
          legalStatus: LegalStatus.clear,
          alertsMaxSeverity: AlertSeverity.critical,
          alertsCount: 1,
        ),
      );

      expect(result.reasonHuman, '1 alerta crítica');
    });

    test('CRITICAL 3 alertas → plural', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.ok,
          legalStatus: LegalStatus.clear,
          alertsMaxSeverity: AlertSeverity.critical,
          alertsCount: 3,
        ),
      );

      expect(result.reasonHuman, '3 alertas críticas');
    });

    test('HIGH 2 alertas', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.ok,
          legalStatus: LegalStatus.clear,
          alertsMaxSeverity: AlertSeverity.high,
          alertsCount: 2,
        ),
      );

      expect(result.reasonHuman, '2 alertas altas');
    });

    test('complianceType desconocido EXPIRED → fallback "Documento"', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'tipo_desconocido',
          daysExpired: 10,
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.reasonHuman, 'Documento vencido hace 10 días');
    });

    test('complianceType desconocido WARNING → fallback "Documento"', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.warning,
          complianceType: 'tipo_desconocido',
          legalStatus: LegalStatus.clear,
        ),
      );

      expect(result.reasonHuman, 'Documento próximo a vencer');
    });

    test('reasonHuman es determinístico: mismo input → mismo texto', () {
      const input = PriorityInput(
        complianceStatus: ComplianceStatus.expired,
        complianceType: 'soat',
        daysExpired: 45,
        legalStatus: LegalStatus.encumbered,
        alertsMaxSeverity: AlertSeverity.high,
        alertsCount: 3,
      );

      final r1 = AssetPriorityEngine.computePriority(input);
      final r2 = AssetPriorityEngine.computePriority(input);

      expect(r1.reasonHuman, r2.reasonHuman);
      expect(r1.score, r2.score);
      expect(r1.reason, r2.reason);
    });

    test('reason y reasonHuman son coherentes (mismo breakdown)', () {
      final result = AssetPriorityEngine.computePriority(
        const PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          complianceType: 'soat',
          daysExpired: 45,
          legalStatus: LegalStatus.disputed,
        ),
      );

      expect(result.reason, contains('EXPIRED'));
      expect(result.reasonHuman, contains('SOAT'));
      expect(result.reason, contains('DISPUTED'));
      expect(result.reasonHuman, contains('En litigio'));
    });
  });

  // ==========================================================================
  // safeParseDate
  // ==========================================================================

  group('safeParseDate()', () {
    test('ISO-8601 válido → parsea correctamente', () {
      final dt = AssetPriorityEngine.safeParseDate('2025-06-15T00:00:00.000Z');
      expect(dt.year, 2025);
      expect(dt.month, 6);
      expect(dt.day, 15);
      expect(dt.isUtc, isTrue);
    });

    test('null → DateTime.utc(0)', () {
      final dt = AssetPriorityEngine.safeParseDate(null);
      expect(dt, DateTime.utc(0));
    });

    test('string vacío → DateTime.utc(0)', () {
      final dt = AssetPriorityEngine.safeParseDate('');
      expect(dt, DateTime.utc(0));
    });

    test('string inválido → DateTime.utc(0)', () {
      final dt = AssetPriorityEngine.safeParseDate('no-es-una-fecha');
      expect(dt, DateTime.utc(0));
    });

    test('retorna UTC siempre con input ISO con zona explícita', () {
      final dt = AssetPriorityEngine.safeParseDate('2025-01-01T12:00:00Z');
      expect(dt.isUtc, isTrue);
    });
  });

  // ==========================================================================
  // PriorityInput — asserts
  // ==========================================================================

  group('PriorityInput — asserts', () {
    test('daysExpired negativo → AssertionError en debug', () {
      expect(
        () => PriorityInput(
          complianceStatus: ComplianceStatus.expired,
          legalStatus: LegalStatus.clear,
          daysExpired: -1,
        ),
        throwsAssertionError,
      );
    });

    test('alertsCount negativo → AssertionError en debug', () {
      expect(
        () => PriorityInput(
          complianceStatus: ComplianceStatus.ok,
          legalStatus: LegalStatus.clear,
          alertsCount: -1,
        ),
        throwsAssertionError,
      );
    });

    test('alertsMaxSeverity con alertsCount=0 → AssertionError en debug', () {
      expect(
        () => PriorityInput(
          complianceStatus: ComplianceStatus.ok,
          legalStatus: LegalStatus.clear,
          alertsMaxSeverity: AlertSeverity.critical,
          alertsCount: 0,
        ),
        throwsAssertionError,
      );
    });
  });
}
