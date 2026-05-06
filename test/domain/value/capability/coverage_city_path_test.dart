// ============================================================================
// test/domain/value/capability/coverage_city_path_test.dart
// Tests para CoverageCityPath (VO PAIS/REGION/CIUDAD)
// ============================================================================
// Cubre:
//   - Construcción válida por named params y por fromString.
//   - Validación de cada segmento (no vacío, charset, longitud).
//   - Rechazo de formatos malformados (separadores incorrectos, segmentos
//     extra, segmentos vacíos).
//   - tryParse no-throw.
//   - Igualdad por valor, hashCode, toString.
//   - Roundtrip JSON.
// ============================================================================

import 'package:avanzza/domain/value/capability/refs/coverage_city_path.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoverageCityPath — construcción válida', () {
    test('named params con formato típico CO', () {
      final p = CoverageCityPath(
        countryId: 'CO',
        regionId: 'col-ant',
        cityId: 'col-ant-med',
      );
      expect(p.countryId, 'CO');
      expect(p.regionId, 'col-ant');
      expect(p.cityId, 'col-ant-med');
      expect(p.value, 'CO/col-ant/col-ant-med');
    });

    test('fromString equivalente a named params', () {
      final a = CoverageCityPath.fromString('CO/col-ant/col-ant-med');
      final b = CoverageCityPath(
        countryId: 'CO',
        regionId: 'col-ant',
        cityId: 'col-ant-med',
      );
      expect(a, equals(b));
    });

    test('soporta underscore en segmentos', () {
      final p = CoverageCityPath.fromString('US/ny/new_york_city');
      expect(p.cityId, 'new_york_city');
    });

    test('soporta segmento de 1 char (límite inferior)', () {
      final p = CoverageCityPath.fromString('A/B/C');
      expect(p.value, 'A/B/C');
    });

    test('soporta segmento de 32 chars (límite superior)', () {
      final long = 'a' * 32;
      final p = CoverageCityPath.fromString('CO/$long/med');
      expect(p.regionId, long);
    });

    test('preserva case original (no normaliza)', () {
      final p = CoverageCityPath.fromString('CO/Col-Ant/COL-ANT-MED');
      expect(p.countryId, 'CO');
      expect(p.regionId, 'Col-Ant');
      expect(p.cityId, 'COL-ANT-MED');
    });
  });

  group('CoverageCityPath — rechazo de formato', () {
    test('falta separador', () {
      expect(
        () => CoverageCityPath.fromString('COcol-antcol-ant-med'),
        throwsArgumentError,
      );
    });

    test('un solo separador (2 segmentos)', () {
      expect(
        () => CoverageCityPath.fromString('CO/col-ant'),
        throwsArgumentError,
      );
    });

    test('demasiados separadores (4 segmentos)', () {
      expect(
        () => CoverageCityPath.fromString('CO/col-ant/col-ant-med/extra'),
        throwsArgumentError,
      );
    });

    test('segmento vacío en el medio', () {
      expect(
        () => CoverageCityPath.fromString('CO//col-ant-med'),
        throwsArgumentError,
      );
    });

    test('segmento vacío al inicio', () {
      expect(
        () => CoverageCityPath.fromString('/col-ant/col-ant-med'),
        throwsArgumentError,
      );
    });

    test('segmento vacío al final', () {
      expect(
        () => CoverageCityPath.fromString('CO/col-ant/'),
        throwsArgumentError,
      );
    });

    test('string completamente vacío', () {
      expect(() => CoverageCityPath.fromString(''), throwsArgumentError);
    });
  });

  group('CoverageCityPath — rechazo de segmentos', () {
    test('segmento con espacio', () {
      expect(
        () => CoverageCityPath.fromString('CO/col ant/med'),
        throwsArgumentError,
      );
    });

    test('segmento con punto', () {
      expect(
        () => CoverageCityPath.fromString('CO/col.ant/med'),
        throwsArgumentError,
      );
    });

    test('segmento con símbolo no permitido', () {
      expect(
        () => CoverageCityPath.fromString('CO/col#ant/med'),
        throwsArgumentError,
      );
      expect(
        () => CoverageCityPath.fromString('CO/col@ant/med'),
        throwsArgumentError,
      );
    });

    test('segmento non-ASCII', () {
      expect(
        () => CoverageCityPath.fromString('CO/región/med'),
        throwsArgumentError,
      );
      expect(
        () => CoverageCityPath.fromString('CO/col/medellín'),
        throwsArgumentError,
      );
    });

    test('segmento excede 32 chars', () {
      final tooLong = 'a' * 33;
      expect(
        () => CoverageCityPath.fromString('CO/$tooLong/med'),
        throwsArgumentError,
      );
    });

    test('named params: countryId vacío', () {
      expect(
        () => CoverageCityPath(
          countryId: '',
          regionId: 'col-ant',
          cityId: 'med',
        ),
        throwsArgumentError,
      );
    });

    test('named params: regionId vacío', () {
      expect(
        () => CoverageCityPath(
          countryId: 'CO',
          regionId: '',
          cityId: 'med',
        ),
        throwsArgumentError,
      );
    });

    test('named params: cityId vacío', () {
      expect(
        () => CoverageCityPath(
          countryId: 'CO',
          regionId: 'col-ant',
          cityId: '',
        ),
        throwsArgumentError,
      );
    });
  });

  group('CoverageCityPath — tryParse', () {
    test('null → null', () {
      expect(CoverageCityPath.tryParse(null), isNull);
    });

    test('formato inválido → null', () {
      expect(CoverageCityPath.tryParse('CO/col-ant'), isNull);
      expect(CoverageCityPath.tryParse(''), isNull);
      expect(CoverageCityPath.tryParse('CO/col ant/med'), isNull);
    });

    test('válido → instancia', () {
      final p = CoverageCityPath.tryParse('CO/col-ant/col-ant-med');
      expect(p, isNotNull);
      expect(p!.value, 'CO/col-ant/col-ant-med');
    });
  });

  group('CoverageCityPath — igualdad y serialización', () {
    test('igualdad por valor', () {
      final a = CoverageCityPath.fromString('CO/col-ant/col-ant-med');
      final b = CoverageCityPath(
        countryId: 'CO',
        regionId: 'col-ant',
        cityId: 'col-ant-med',
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('case distinto NO es igual (no se normaliza)', () {
      final a = CoverageCityPath.fromString('CO/col-ant/col-ant-med');
      final b = CoverageCityPath.fromString('co/col-ant/col-ant-med');
      expect(a, isNot(equals(b)));
    });

    test('toJson retorna string canónico', () {
      final p = CoverageCityPath.fromString('CO/col-ant/col-ant-med');
      expect(p.toJson(), 'CO/col-ant/col-ant-med');
    });

    test('fromJson roundtrip', () {
      final original = CoverageCityPath.fromString('US/ny/nyc');
      final restored = CoverageCityPath.fromJson(original.toJson());
      expect(restored, equals(original));
    });

    test('toString incluye value', () {
      final p = CoverageCityPath.fromString('CO/col-ant/col-ant-med');
      expect(p.toString(), contains('CO/col-ant/col-ant-med'));
    });
  });
}
