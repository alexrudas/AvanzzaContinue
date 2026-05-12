// ============================================================================
// test/domain/value/capability/capability_kinds_test.dart
// Tests para los 4 enums helper de CapabilityProfile
// ============================================================================
// Cubre: ProfileKind, InsuranceLine, ProviderType, LegalSpecialty.
// Para cada uno valida: wireName, fromWire (throws), tryFromWire (no-throw),
// isValidWireName, allWireNames (snapshot), unicidad, roundtrip.
// ============================================================================

import 'package:avanzza/domain/value/capability/insurance_line.dart';
import 'package:avanzza/domain/value/capability/legal_specialty.dart';
import 'package:avanzza/domain/value/capability/profile_kind.dart';
import 'package:avanzza/domain/value/capability/provider_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileKind', () {
    test('wireName mapping', () {
      expect(ProfileKind.provider.wireName, 'provider');
      expect(ProfileKind.advisor.wireName, 'advisor');
      expect(ProfileKind.broker.wireName, 'broker');
      expect(ProfileKind.legal.wireName, 'legal');
      expect(ProfileKind.insurer.wireName, 'insurer');
    });

    test('wireNames son únicos', () {
      final wires = ProfileKind.values.map((k) => k.wireName).toList();
      expect(wires.toSet().length, wires.length);
    });

    test('fromWire en valores válidos', () {
      for (final k in ProfileKind.values) {
        expect(ProfileKindX.fromWire(k.wireName), k);
      }
    });

    test('fromWire throws en desconocido', () {
      expect(() => ProfileKindX.fromWire(''), throwsArgumentError);
      expect(() => ProfileKindX.fromWire('Provider'), throwsArgumentError);
      expect(() => ProfileKindX.fromWire('owner'), throwsArgumentError);
      expect(() => ProfileKindX.fromWire('asesor'), throwsArgumentError);
    });

    test('tryFromWire retorna null en desconocido', () {
      expect(ProfileKindX.tryFromWire(''), isNull);
      expect(ProfileKindX.tryFromWire('Provider'), isNull);
      expect(ProfileKindX.tryFromWire('insurance'), isNull);
    });

    test('allWireNames orden estable', () {
      expect(ProfileKindX.allWireNames, [
        'provider',
        'advisor',
        'broker',
        'legal',
        'insurer',
      ]);
    });

    test('insurer está separado de broker (frontera v3.1)', () {
      // Confirma que insurer NO es alias de broker.
      expect(ProfileKind.insurer != ProfileKind.broker, isTrue);
      expect(ProfileKindX.fromWire('insurer'), ProfileKind.insurer);
      expect(ProfileKindX.fromWire('broker'), ProfileKind.broker);
    });
  });

  group('InsuranceLine', () {
    test('wireName mapping (incluye snake_case)', () {
      expect(InsuranceLine.soat.wireName, 'soat');
      expect(InsuranceLine.auto.wireName, 'auto');
      expect(InsuranceLine.hogar.wireName, 'hogar');
      expect(InsuranceLine.vida.wireName, 'vida');
      expect(InsuranceLine.salud.wireName, 'salud');
      expect(InsuranceLine.empresarial.wireName, 'empresarial');
      expect(
        InsuranceLine.responsabilidadCivil.wireName,
        'responsabilidad_civil',
      );
      expect(InsuranceLine.transporte.wireName, 'transporte');
    });

    test('wireNames son únicos', () {
      final wires = InsuranceLine.values.map((l) => l.wireName).toList();
      expect(wires.toSet().length, wires.length);
    });

    test('roundtrip enum → wireName → enum', () {
      for (final l in InsuranceLine.values) {
        expect(InsuranceLineX.fromWire(l.wireName), l);
      }
    });

    test('fromWire throws en desconocido', () {
      expect(() => InsuranceLineX.fromWire(''), throwsArgumentError);
      expect(() => InsuranceLineX.fromWire('vehicular'), throwsArgumentError);
      expect(
        () => InsuranceLineX.fromWire('responsabilidadCivil'),
        throwsArgumentError,
        reason: 'el camelCase NO es wire-stable; debe ser snake_case',
      );
    });

    test('isValidWireName', () {
      expect(InsuranceLineX.isValidWireName('soat'), isTrue);
      expect(
        InsuranceLineX.isValidWireName('responsabilidad_civil'),
        isTrue,
      );
      expect(InsuranceLineX.isValidWireName('rc'), isFalse);
      expect(InsuranceLineX.isValidWireName(''), isFalse);
    });

    test('allWireNames contiene 8 entradas', () {
      expect(InsuranceLineX.allWireNames.length, 8);
    });
  });

  group('ProviderType', () {
    test('wireName mapping', () {
      expect(ProviderType.articulos.wireName, 'articulos');
      expect(ProviderType.servicios.wireName, 'servicios');
    });

    test('roundtrip', () {
      for (final t in ProviderType.values) {
        expect(ProviderTypeX.fromWire(t.wireName), t);
      }
    });

    test('fromWire throws en desconocido', () {
      expect(() => ProviderTypeX.fromWire(''), throwsArgumentError);
      expect(() => ProviderTypeX.fromWire('productos'), throwsArgumentError);
      expect(() => ProviderTypeX.fromWire('Articulos'), throwsArgumentError);
    });

    test('allWireNames orden estable', () {
      expect(ProviderTypeX.allWireNames, ['articulos', 'servicios']);
    });
  });

  group('LegalSpecialty', () {
    test('wireName mapping', () {
      expect(LegalSpecialty.civil.wireName, 'civil');
      expect(LegalSpecialty.penal.wireName, 'penal');
      expect(LegalSpecialty.ambas.wireName, 'ambas');
    });

    test('roundtrip', () {
      for (final s in LegalSpecialty.values) {
        expect(LegalSpecialtyX.fromWire(s.wireName), s);
      }
    });

    test('fromWire throws en desconocido', () {
      expect(() => LegalSpecialtyX.fromWire(''), throwsArgumentError);
      expect(() => LegalSpecialtyX.fromWire('comercial'), throwsArgumentError);
      expect(() => LegalSpecialtyX.fromWire('laboral'), throwsArgumentError);
    });

    test('allWireNames orden estable', () {
      expect(LegalSpecialtyX.allWireNames, ['civil', 'penal', 'ambas']);
    });
  });
}
