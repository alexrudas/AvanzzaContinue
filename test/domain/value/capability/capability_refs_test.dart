// ============================================================================
// test/domain/value/capability/capability_refs_test.dart
// Tests para BusinessCategoryRef y RegulatorLicenseRef
// ============================================================================
// Cubre:
//   - Validación sintáctica en construcción (formato, longitud, charset).
//   - Normalización (RegulatorLicenseRef: trim + uppercase).
//   - tryParse no-throw.
//   - Igualdad por valor, hashCode, toString.
//   - toJson / fromJson roundtrip.
//   - Rechazo explícito de patrones prohibidos.
// ============================================================================

import 'package:avanzza/domain/value/capability/refs/business_category_ref.dart';
import 'package:avanzza/domain/value/capability/refs/regulator_license_ref.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BusinessCategoryRef — construcción válida', () {
    test('snake_case ASCII simple', () {
      final ref = BusinessCategoryRef('lubricentro');
      expect(ref.value, 'lubricentro');
    });

    test('snake_case con underscore', () {
      expect(
        BusinessCategoryRef('mecanico_independiente').value,
        'mecanico_independiente',
      );
      expect(
        BusinessCategoryRef('autopartes_originales').value,
        'autopartes_originales',
      );
    });

    test('con dígitos después de letra inicial', () {
      expect(BusinessCategoryRef('taller_v2').value, 'taller_v2');
    });

    test('un solo carácter (límite inferior)', () {
      expect(BusinessCategoryRef('a').value, 'a');
    });

    test('64 caracteres (límite superior)', () {
      final long = 'a' * 64;
      expect(BusinessCategoryRef(long).value, long);
    });
  });

  group('BusinessCategoryRef — rechazo sintáctico', () {
    test('vacío', () {
      expect(() => BusinessCategoryRef(''), throwsArgumentError);
    });

    test('mayúscula', () {
      expect(() => BusinessCategoryRef('Lubricentro'), throwsArgumentError);
      expect(() => BusinessCategoryRef('LUB'), throwsArgumentError);
    });

    test('empieza con dígito', () {
      expect(() => BusinessCategoryRef('1_taller'), throwsArgumentError);
      expect(() => BusinessCategoryRef('123'), throwsArgumentError);
    });

    test('empieza con underscore', () {
      expect(() => BusinessCategoryRef('_taller'), throwsArgumentError);
    });

    test('contiene guion', () {
      expect(() => BusinessCategoryRef('cat-egoria'), throwsArgumentError);
    });

    test('contiene espacios o whitespace', () {
      expect(() => BusinessCategoryRef('cat egoria'), throwsArgumentError);
      expect(() => BusinessCategoryRef(' lubricentro'), throwsArgumentError);
      expect(() => BusinessCategoryRef('lubricentro '), throwsArgumentError);
    });

    test('contiene símbolos', () {
      expect(() => BusinessCategoryRef('cat.egoria'), throwsArgumentError);
      expect(() => BusinessCategoryRef('cat#egoria'), throwsArgumentError);
      expect(() => BusinessCategoryRef('cat@egoria'), throwsArgumentError);
    });

    test('non-ASCII', () {
      expect(() => BusinessCategoryRef('mecánico'), throwsArgumentError);
      expect(() => BusinessCategoryRef('niño'), throwsArgumentError);
    });

    test('excede 64 chars', () {
      final tooLong = 'a' * 65;
      expect(() => BusinessCategoryRef(tooLong), throwsArgumentError);
    });
  });

  group('BusinessCategoryRef — tryParse', () {
    test('retorna null para null', () {
      expect(BusinessCategoryRef.tryParse(null), isNull);
    });

    test('retorna null para string inválido', () {
      expect(BusinessCategoryRef.tryParse('Lubricentro'), isNull);
      expect(BusinessCategoryRef.tryParse(''), isNull);
      expect(BusinessCategoryRef.tryParse('cat-egoria'), isNull);
    });

    test('retorna ref para string válido', () {
      final ref = BusinessCategoryRef.tryParse('lubricentro');
      expect(ref, isNotNull);
      expect(ref!.value, 'lubricentro');
    });
  });

  group('BusinessCategoryRef — igualdad y serialización', () {
    test('igualdad por valor', () {
      final a = BusinessCategoryRef('lubricentro');
      final b = BusinessCategoryRef('lubricentro');
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('valores distintos no son iguales', () {
      final a = BusinessCategoryRef('lubricentro');
      final b = BusinessCategoryRef('mecanico_independiente');
      expect(a, isNot(equals(b)));
    });

    test('toJson retorna el id plano', () {
      expect(BusinessCategoryRef('lubricentro').toJson(), 'lubricentro');
    });

    test('fromJson roundtrip', () {
      final original = BusinessCategoryRef('autopartes_originales');
      final restored = BusinessCategoryRef.fromJson(original.toJson());
      expect(restored, equals(original));
    });

    test('toString incluye el value', () {
      expect(
        BusinessCategoryRef('lubricentro').toString(),
        contains('lubricentro'),
      );
    });
  });

  group('RegulatorLicenseRef — construcción válida', () {
    test('formato típico SFC con guion', () {
      expect(RegulatorLicenseRef('SFC-12345').value, 'SFC-12345');
    });

    test('formato con punto', () {
      expect(RegulatorLicenseRef('NAIC.67890').value, 'NAIC.67890');
    });

    test('formato compuesto', () {
      expect(RegulatorLicenseRef('REG-ABC-2026').value, 'REG-ABC-2026');
    });

    test('un solo carácter (límite inferior)', () {
      expect(RegulatorLicenseRef('A').value, 'A');
    });

    test('32 caracteres (límite superior)', () {
      final long = 'A' * 32;
      expect(RegulatorLicenseRef(long).value, long);
    });
  });

  group('RegulatorLicenseRef — normalización', () {
    test('lowercase se normaliza a uppercase', () {
      expect(RegulatorLicenseRef('sfc-12345').value, 'SFC-12345');
    });

    test('mixed case se normaliza a uppercase', () {
      expect(RegulatorLicenseRef('Sfc-AbC').value, 'SFC-ABC');
    });

    test('whitespace alrededor se trimea', () {
      expect(RegulatorLicenseRef('  SFC-12345  ').value, 'SFC-12345');
      expect(RegulatorLicenseRef('\tNAIC.67890\n').value, 'NAIC.67890');
    });

    test('trim + uppercase combinados', () {
      expect(RegulatorLicenseRef(' sfc-12345 ').value, 'SFC-12345');
    });
  });

  group('RegulatorLicenseRef — rechazo sintáctico', () {
    test('vacío o solo whitespace', () {
      expect(() => RegulatorLicenseRef(''), throwsArgumentError);
      expect(() => RegulatorLicenseRef('   '), throwsArgumentError);
      expect(() => RegulatorLicenseRef('\t\n'), throwsArgumentError);
    });

    test('contiene espacio interno', () {
      expect(() => RegulatorLicenseRef('SFC 12345'), throwsArgumentError);
    });

    test('contiene símbolos no permitidos', () {
      expect(() => RegulatorLicenseRef('SFC#12345'), throwsArgumentError);
      expect(() => RegulatorLicenseRef('SFC_12345'), throwsArgumentError);
      expect(() => RegulatorLicenseRef('SFC@12345'), throwsArgumentError);
      expect(() => RegulatorLicenseRef('SFC/12345'), throwsArgumentError);
    });

    test('non-ASCII', () {
      expect(() => RegulatorLicenseRef('LICÉNCIA'), throwsArgumentError);
    });

    test('excede 32 chars (post-trim)', () {
      final tooLong = 'A' * 33;
      expect(() => RegulatorLicenseRef(tooLong), throwsArgumentError);
    });
  });

  group('RegulatorLicenseRef — tryParse', () {
    test('retorna null para null', () {
      expect(RegulatorLicenseRef.tryParse(null), isNull);
    });

    test('retorna null para string inválido', () {
      expect(RegulatorLicenseRef.tryParse(''), isNull);
      expect(RegulatorLicenseRef.tryParse('SFC#1'), isNull);
    });

    test('retorna ref normalizado para string válido', () {
      final ref = RegulatorLicenseRef.tryParse(' sfc-12345 ');
      expect(ref, isNotNull);
      expect(ref!.value, 'SFC-12345');
    });
  });

  group('RegulatorLicenseRef — igualdad y serialización', () {
    test('igualdad por valor normalizado', () {
      final a = RegulatorLicenseRef('SFC-12345');
      final b = RegulatorLicenseRef('sfc-12345'); // case distinto, normaliza
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('valores distintos no son iguales', () {
      final a = RegulatorLicenseRef('SFC-12345');
      final b = RegulatorLicenseRef('SFC-99999');
      expect(a, isNot(equals(b)));
    });

    test('toJson retorna forma normalizada', () {
      expect(RegulatorLicenseRef('  sfc-12345  ').toJson(), 'SFC-12345');
    });

    test('fromJson roundtrip', () {
      final original = RegulatorLicenseRef('SFC-12345');
      final restored = RegulatorLicenseRef.fromJson(original.toJson());
      expect(restored, equals(original));
    });
  });
}
