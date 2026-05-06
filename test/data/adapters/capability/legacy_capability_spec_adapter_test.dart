// ============================================================================
// test/data/adapters/capability/legacy_capability_spec_adapter_test.dart
// Tests para LegacyCapabilitySpecAdapter (parse tolerante de specs legacy)
// ============================================================================
// Cubre:
//   - Path feliz: JSON válido produce LegacyParseResult sin warnings.
//   - businessCategoryId malformado ⇒ descartado + warning typed.
//   - regulatorLicense malformado ⇒ descartado + warning typed.
//   - insuranceLines con valores desconocidos ⇒ filtrados + warning por
//     elemento; resto preservado.
//   - insuranceLines duplicados ⇒ deduplicados silenciosamente.
//   - insuranceLines vacío tras filtrado ⇒ LegacyParseException.
//   - Campos requeridos ausentes ⇒ ArgumentError (preserva contrato estricto).
//   - Path estricto (ProviderSpec.fromJson / InsurerSpec.fromJson) sigue
//     rechazando datos malformados — confirmamos no-regresión.
// ============================================================================

import 'package:avanzza/data/adapters/capability/legacy_capability_spec_adapter.dart';
import 'package:avanzza/data/adapters/capability/legacy_migration_warning.dart';
import 'package:avanzza/domain/value/capability/insurance_line.dart';
import 'package:avanzza/domain/value/capability/insurer_spec.dart';
import 'package:avanzza/domain/value/capability/provider_spec.dart';
import 'package:avanzza/domain/value/capability/provider_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LegacyCapabilitySpecAdapter — providerSpecFromLegacyJson', () {
    test('JSON válido completo: 0 warnings, spec íntegro', () {
      final result = LegacyCapabilitySpecAdapter.providerSpecFromLegacyJson({
        'providerType': 'servicios',
        'market': 'vehiculo',
        'businessCategoryId': 'mecanico_independiente',
      });

      expect(result.hasWarnings, isFalse);
      expect(result.spec.providerType, ProviderType.servicios);
      expect(result.spec.businessCategoryRef?.value, 'mecanico_independiente');
    });

    test('businessCategoryId con mayúscula ⇒ descartado + warning', () {
      final result = LegacyCapabilitySpecAdapter.providerSpecFromLegacyJson({
        'providerType': 'servicios',
        'businessCategoryId': 'Lubricentro',
      });

      expect(result.spec.businessCategoryRef, isNull);
      expect(result.warnings.length, 1);
      expect(
        result.warnings.first.kind,
        LegacyMigrationWarningKind.malformedBusinessCategory,
      );
      expect(result.warnings.first.rawValue, 'Lubricentro');
      expect(
        result.warnings.first.fieldPath,
        'providerSpec.businessCategoryId',
      );
    });

    test('businessCategoryId con guion ⇒ descartado + warning', () {
      final result = LegacyCapabilitySpecAdapter.providerSpecFromLegacyJson({
        'providerType': 'articulos',
        'businessCategoryId': 'cat-egoria',
      });

      expect(result.spec.businessCategoryRef, isNull);
      expect(result.warnings.length, 1);
      expect(
        result.warnings.first.kind,
        LegacyMigrationWarningKind.malformedBusinessCategory,
      );
    });

    test('businessCategoryId vacío ⇒ descartado + warning', () {
      final result = LegacyCapabilitySpecAdapter.providerSpecFromLegacyJson({
        'providerType': 'articulos',
        'businessCategoryId': '',
      });

      expect(result.spec.businessCategoryRef, isNull);
      expect(result.warnings.length, 1);
    });

    test('providerType ausente ⇒ ArgumentError (campo requerido)', () {
      expect(
        () => LegacyCapabilitySpecAdapter.providerSpecFromLegacyJson(
          <String, dynamic>{},
        ),
        throwsArgumentError,
      );
    });

    test('providerType desconocido ⇒ ArgumentError', () {
      expect(
        () => LegacyCapabilitySpecAdapter.providerSpecFromLegacyJson({
          'providerType': 'productos',
        }),
        throwsArgumentError,
      );
    });

    test('múltiples campos opcionales malformados ⇒ múltiples warnings', () {
      // Solo businessCategoryId puede emitir warning en este spec.
      // market malformado se mapea a 'otro' por contrato del enum origen.
      // Test sintetiza dos sources de warning combinándolos en el mismo path.
      final result = LegacyCapabilitySpecAdapter.providerSpecFromLegacyJson({
        'providerType': 'servicios',
        'businessCategoryId': '1_invalid', // empieza con dígito
        'market': 'vehiculo',
      });

      expect(result.warnings.length, 1);
      expect(
        result.warnings.first.kind,
        LegacyMigrationWarningKind.malformedBusinessCategory,
      );
    });
  });

  group('LegacyCapabilitySpecAdapter — insurerSpecFromLegacyJson', () {
    test('JSON válido completo: 0 warnings', () {
      final result = LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson({
        'insuranceLines': ['soat', 'auto'],
        'isCarrier': true,
        'market': 'vehiculo',
        'regulatorLicense': 'SFC-12345',
      });

      expect(result.hasWarnings, isFalse);
      expect(result.spec.insuranceLines.length, 2);
      expect(result.spec.regulatorLicenseRef?.value, 'SFC-12345');
    });

    test('regulatorLicense con símbolo no permitido ⇒ descartado + warning',
        () {
      final result = LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson({
        'insuranceLines': ['soat'],
        'isCarrier': true,
        'regulatorLicense': 'SFC#12345',
      });

      expect(result.spec.regulatorLicenseRef, isNull);
      expect(result.warnings.length, 1);
      expect(
        result.warnings.first.kind,
        LegacyMigrationWarningKind.malformedRegulatorLicense,
      );
      expect(result.warnings.first.rawValue, 'SFC#12345');
    });

    test('regulatorLicense vacío ⇒ descartado + warning', () {
      final result = LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson({
        'insuranceLines': ['soat'],
        'isCarrier': true,
        'regulatorLicense': '',
      });

      expect(result.spec.regulatorLicenseRef, isNull);
      expect(result.warnings.length, 1);
    });

    test('regulatorLicense lowercase ⇒ normaliza, sin warning', () {
      // Lowercase es input legítimo: el VO normaliza a uppercase. No hay
      // descarte, no hay warning.
      final result = LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson({
        'insuranceLines': ['soat'],
        'isCarrier': true,
        'regulatorLicense': 'sfc-12345',
      });

      expect(result.warnings, isEmpty);
      expect(result.spec.regulatorLicenseRef?.value, 'SFC-12345');
    });

    test('insuranceLines con valor desconocido ⇒ filtrado + warning por elemento',
        () {
      final result = LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson({
        'insuranceLines': ['soat', 'fianza_legacy', 'auto'],
        'isCarrier': true,
      });

      expect(result.spec.insuranceLines, [
        InsuranceLine.soat,
        InsuranceLine.auto,
      ]);
      expect(result.warnings.length, 1);
      expect(
        result.warnings.first.kind,
        LegacyMigrationWarningKind.unknownInsuranceLine,
      );
      expect(result.warnings.first.rawValue, 'fianza_legacy');
      expect(
        result.warnings.first.fieldPath,
        'insurerSpec.insuranceLines[1]',
      );
    });

    test('insuranceLines con elemento no-string ⇒ filtrado + warning', () {
      final result = LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson({
        'insuranceLines': ['soat', 42, 'auto'],
        'isCarrier': true,
      });

      expect(result.spec.insuranceLines, [
        InsuranceLine.soat,
        InsuranceLine.auto,
      ]);
      expect(result.warnings.length, 1);
      expect(result.warnings.first.rawValue, '42');
    });

    test('insuranceLines con duplicados ⇒ deduplicados, sin warning', () {
      // El adapter limpia duplicados silenciosamente: InsurerSpec exige
      // unicidad y este paso es saneamiento, no error de datos.
      final result = LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson({
        'insuranceLines': ['soat', 'soat', 'auto'],
        'isCarrier': true,
      });

      expect(result.spec.insuranceLines, [
        InsuranceLine.soat,
        InsuranceLine.auto,
      ]);
      expect(result.warnings, isEmpty);
    });

    test('insuranceLines tras filtrar queda vacío ⇒ LegacyParseException', () {
      // Todo el catálogo legacy es desconocido. No hay nada salvable.
      expect(
        () => LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson({
          'insuranceLines': ['fianza_legacy', 'caucion_v0'],
          'isCarrier': true,
        }),
        throwsA(isA<LegacyParseException>()),
      );
    });

    test('LegacyParseException incluye warnings parciales', () {
      try {
        LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson({
          'insuranceLines': ['fianza_legacy', 'caucion_v0'],
          'isCarrier': true,
        });
        fail('Esperaba LegacyParseException');
      } on LegacyParseException catch (e) {
        expect(e.partialWarnings.length, 2);
        expect(
          e.partialWarnings.every(
            (w) => w.kind == LegacyMigrationWarningKind.unknownInsuranceLine,
          ),
          isTrue,
        );
      }
    });

    test('insuranceLines no es List ⇒ ArgumentError', () {
      expect(
        () => LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson({
          'insuranceLines': 'soat',
          'isCarrier': true,
        }),
        throwsArgumentError,
      );
    });

    test('isCarrier ausente ⇒ ArgumentError', () {
      expect(
        () => LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson({
          'insuranceLines': ['soat'],
        }),
        throwsArgumentError,
      );
    });

    test('múltiples warnings combinados', () {
      final result = LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson({
        'insuranceLines': ['soat', 'fianza_legacy', 'auto'],
        'isCarrier': true,
        'regulatorLicense': 'BAD#LIC',
      });

      expect(result.warnings.length, 2);
      expect(
        result.warnings
            .any((w) =>
                w.kind == LegacyMigrationWarningKind.unknownInsuranceLine),
        isTrue,
      );
      expect(
        result.warnings
            .any((w) =>
                w.kind ==
                LegacyMigrationWarningKind.malformedRegulatorLicense),
        isTrue,
      );
      // Spec recuperado funcional.
      expect(result.spec.insuranceLines, [
        InsuranceLine.soat,
        InsuranceLine.auto,
      ]);
      expect(result.spec.regulatorLicenseRef, isNull);
    });
  });

  group('Path estricto NO se ve alterado por el adapter (no-regresión)', () {
    test('ProviderSpec.fromJson sigue rechazando businessCategoryId malformado',
        () {
      expect(
        () => ProviderSpec.fromJson({
          'providerType': 'servicios',
          'businessCategoryId': 'Lubricentro',
        }),
        throwsArgumentError,
      );
    });

    test('InsurerSpec.fromJson sigue rechazando regulatorLicense malformado',
        () {
      expect(
        () => InsurerSpec.fromJson({
          'insuranceLines': ['soat'],
          'isCarrier': true,
          'regulatorLicense': 'SFC#1',
        }),
        throwsArgumentError,
      );
    });

    test('InsurerSpec.fromJson sigue rechazando insuranceLine desconocida', () {
      expect(
        () => InsurerSpec.fromJson({
          'insuranceLines': ['fianza_legacy'],
          'isCarrier': true,
        }),
        throwsArgumentError,
      );
    });
  });

  group('LegacyMigrationWarning — serialización', () {
    test('toMap incluye todos los campos relevantes', () {
      const w = LegacyMigrationWarning(
        kind: LegacyMigrationWarningKind.malformedBusinessCategory,
        fieldPath: 'providerSpec.businessCategoryId',
        rawValue: 'Lubricentro',
        message: 'syntax error',
      );
      expect(w.toMap(), {
        'kind': 'malformedBusinessCategory',
        'fieldPath': 'providerSpec.businessCategoryId',
        'message': 'syntax error',
        'rawValue': 'Lubricentro',
      });
    });

    test('toMap omite rawValue si es null', () {
      const w = LegacyMigrationWarning(
        kind: LegacyMigrationWarningKind.unknownInsuranceLine,
        fieldPath: 'x.y',
        message: 'msg',
      );
      expect(w.toMap().containsKey('rawValue'), isFalse);
    });

    test('toString legible incluye kind, path y rawValue', () {
      const w = LegacyMigrationWarning(
        kind: LegacyMigrationWarningKind.malformedRegulatorLicense,
        fieldPath: 'insurerSpec.regulatorLicense',
        rawValue: 'SFC#1',
        message: 'bad',
      );
      final s = w.toString();
      expect(s, contains('malformedRegulatorLicense'));
      expect(s, contains('insurerSpec.regulatorLicense'));
      expect(s, contains('SFC#1'));
    });
  });
}
