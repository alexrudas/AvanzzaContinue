// ============================================================================
// test/domain/services/onboarding/shell_mode_test.dart
// Tests del enum ShellMode.
// ============================================================================

import 'package:avanzza/domain/services/onboarding/shell_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShellMode — wireName', () {
    test('cada valor tiene wireName canónico (snake_case)', () {
      expect(ShellMode.assetOwner.wireName, 'asset_owner');
      expect(ShellMode.renter.wireName, 'renter');
      expect(ShellMode.providerArticulos.wireName, 'provider_articulos');
      expect(ShellMode.providerServicios.wireName, 'provider_servicios');
      expect(ShellMode.advisor.wireName, 'advisor');
      expect(ShellMode.broker.wireName, 'broker');
      expect(ShellMode.legal.wireName, 'legal');
      expect(ShellMode.insurer.wireName, 'insurer');
    });

    test('todos los wireName son únicos', () {
      final wires = ShellMode.values.map((s) => s.wireName).toList();
      expect(wires.toSet().length, wires.length);
    });
  });

  group('ShellMode — fromWire (estricto)', () {
    test('parsea valores válidos', () {
      for (final s in ShellMode.values) {
        expect(ShellModeX.fromWire(s.wireName), s);
      }
    });

    test('throws en valor desconocido', () {
      expect(() => ShellModeX.fromWire(''), throwsArgumentError);
      expect(() => ShellModeX.fromWire('AssetOwner'), throwsArgumentError);
      expect(() => ShellModeX.fromWire('foo'), throwsArgumentError);
    });
  });

  group('ShellMode — tryFromWire (no-throw)', () {
    test('null ⇒ null', () {
      expect(ShellModeX.tryFromWire(null), isNull);
    });

    test('válido ⇒ enum', () {
      expect(ShellModeX.tryFromWire('asset_owner'), ShellMode.assetOwner);
      expect(ShellModeX.tryFromWire('insurer'), ShellMode.insurer);
    });

    test('desconocido ⇒ null', () {
      expect(ShellModeX.tryFromWire(''), isNull);
      expect(ShellModeX.tryFromWire('AssetOwner'), isNull);
      expect(ShellModeX.tryFromWire('asset_owner '), isNull);
    });
  });

  group('ShellMode — allWireNames', () {
    test('contiene 8 entradas en orden de declaración', () {
      expect(ShellModeX.allWireNames, [
        'asset_owner',
        'renter',
        'provider_articulos',
        'provider_servicios',
        'advisor',
        'broker',
        'legal',
        'insurer',
      ]);
    });

    test('coincide con ShellMode.values.length', () {
      expect(ShellModeX.allWireNames.length, ShellMode.values.length);
    });
  });

  group('ShellMode — roundtrip', () {
    test('enum → wireName → enum preserva identidad', () {
      for (final s in ShellMode.values) {
        expect(ShellModeX.fromWire(s.wireName), s);
      }
    });
  });

  group('ShellMode — separación broker vs insurer (frontera v3.1)', () {
    test('broker e insurer son shells distintos', () {
      expect(ShellMode.broker, isNot(ShellMode.insurer));
      expect(ShellModeX.fromWire('broker'), ShellMode.broker);
      expect(ShellModeX.fromWire('insurer'), ShellMode.insurer);
    });
  });
}
