// ============================================================================
// test/domain/value/capability/capability_specs_test.dart
// Tests para los 5 specs de CapabilityProfile
// ============================================================================
// Cubre: ProviderSpec, AdvisorSpec, BrokerSpec, LegalSpec, InsurerSpec.
// Para cada uno valida: construcción, igualdad por valor, toJson/fromJson
// roundtrip, validación de campos requeridos y errores en fromJson con datos
// inválidos. Para InsurerSpec valida adicionalmente assertions del constructor.
// ============================================================================

import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/domain/value/capability/advisor_spec.dart';
import 'package:avanzza/domain/value/capability/broker_spec.dart';
import 'package:avanzza/domain/value/capability/insurance_line.dart';
import 'package:avanzza/domain/value/capability/insurer_spec.dart';
import 'package:avanzza/domain/value/capability/legal_spec.dart';
import 'package:avanzza/domain/value/capability/legal_specialty.dart';
import 'package:avanzza/domain/value/capability/provider_spec.dart';
import 'package:avanzza/domain/value/capability/provider_type.dart';
import 'package:avanzza/domain/value/capability/refs/business_category_ref.dart';
import 'package:avanzza/domain/value/capability/refs/regulator_license_ref.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProviderSpec', () {
    test('construcción mínima (solo providerType)', () {
      const s = ProviderSpec(providerType: ProviderType.servicios);
      expect(s.providerType, ProviderType.servicios);
      expect(s.market, isNull);
      expect(s.businessCategoryRef, isNull);
    });

    test('igualdad por valor (incluye businessCategoryRef)', () {
      final a = ProviderSpec(
        providerType: ProviderType.articulos,
        market: AssetRegistrationType.vehiculo,
        businessCategoryRef: BusinessCategoryRef('autopartes'),
      );
      final b = ProviderSpec(
        providerType: ProviderType.articulos,
        market: AssetRegistrationType.vehiculo,
        businessCategoryRef: BusinessCategoryRef('autopartes'),
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('copyWith', () {
      const base = ProviderSpec(providerType: ProviderType.servicios);
      final updated = base.copyWith(market: AssetRegistrationType.maquinaria);
      expect(updated.market, AssetRegistrationType.maquinaria);
      expect(updated.providerType, ProviderType.servicios);
    });

    test('toJson omite campos null', () {
      const s = ProviderSpec(providerType: ProviderType.servicios);
      expect(s.toJson(), {'providerType': 'servicios'});
    });

    test('toJson con todos los campos serializa BusinessCategoryRef como string',
        () {
      final s = ProviderSpec(
        providerType: ProviderType.articulos,
        market: AssetRegistrationType.vehiculo,
        businessCategoryRef: BusinessCategoryRef('autopartes'),
      );
      expect(s.toJson(), {
        'providerType': 'articulos',
        'market': 'vehiculo',
        'businessCategoryId': 'autopartes',
      });
    });

    test('fromJson roundtrip preserva BusinessCategoryRef', () {
      final original = ProviderSpec(
        providerType: ProviderType.servicios,
        market: AssetRegistrationType.inmueble,
        businessCategoryRef: BusinessCategoryRef('admin_inmuebles'),
      );
      final restored = ProviderSpec.fromJson(original.toJson());
      expect(restored, equals(original));
      expect(restored.businessCategoryRef?.value, 'admin_inmuebles');
    });

    test('fromJson throws si providerType ausente', () {
      expect(
        () => ProviderSpec.fromJson(<String, dynamic>{}),
        throwsArgumentError,
      );
    });

    test('fromJson throws si providerType es desconocido', () {
      expect(
        () => ProviderSpec.fromJson({'providerType': 'productos'}),
        throwsArgumentError,
      );
    });

    test('fromJson throws si businessCategoryId tiene formato inválido', () {
      // Sintaxis del Ref es validada por el VO, que rechaza mayúsculas, guiones
      // y strings vacíos.
      expect(
        () => ProviderSpec.fromJson({
          'providerType': 'servicios',
          'businessCategoryId': 'Lubricentro',
        }),
        throwsArgumentError,
        reason: 'BusinessCategoryRef rechaza mayúsculas',
      );
      expect(
        () => ProviderSpec.fromJson({
          'providerType': 'servicios',
          'businessCategoryId': 'cat-egoria',
        }),
        throwsArgumentError,
        reason: 'BusinessCategoryRef rechaza guion',
      );
    });
  });

  group('AdvisorSpec', () {
    test('requiere market', () {
      const s = AdvisorSpec(market: AssetRegistrationType.vehiculo);
      expect(s.market, AssetRegistrationType.vehiculo);
    });

    test('igualdad por valor', () {
      const a = AdvisorSpec(market: AssetRegistrationType.maquinaria);
      const b = AdvisorSpec(market: AssetRegistrationType.maquinaria);
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('toJson / fromJson roundtrip', () {
      const original = AdvisorSpec(market: AssetRegistrationType.equipo);
      final restored = AdvisorSpec.fromJson(original.toJson());
      expect(restored, equals(original));
    });

    test('fromJson throws si market ausente', () {
      expect(
        () => AdvisorSpec.fromJson(<String, dynamic>{}),
        throwsArgumentError,
      );
    });
  });

  group('BrokerSpec', () {
    test('toJson / fromJson roundtrip', () {
      const original = BrokerSpec(market: AssetRegistrationType.inmueble);
      final restored = BrokerSpec.fromJson(original.toJson());
      expect(restored, equals(original));
    });

    test('igualdad por valor', () {
      const a = BrokerSpec(market: AssetRegistrationType.vehiculo);
      const b = BrokerSpec(market: AssetRegistrationType.vehiculo);
      expect(a, equals(b));
    });

    test('distinto market ⇒ distinto valor', () {
      const a = BrokerSpec(market: AssetRegistrationType.vehiculo);
      const b = BrokerSpec(market: AssetRegistrationType.inmueble);
      expect(a, isNot(equals(b)));
    });
  });

  group('LegalSpec', () {
    test('toJson / fromJson roundtrip', () {
      const original = LegalSpec(specialty: LegalSpecialty.ambas);
      final restored = LegalSpec.fromJson(original.toJson());
      expect(restored, equals(original));
    });

    test('toJson contiene wireName de specialty', () {
      const s = LegalSpec(specialty: LegalSpecialty.civil);
      expect(s.toJson(), {'specialty': 'civil'});
    });

    test('fromJson throws si specialty desconocida', () {
      expect(
        () => LegalSpec.fromJson({'specialty': 'comercial'}),
        throwsArgumentError,
      );
    });

    test('fromJson throws si specialty ausente', () {
      expect(
        () => LegalSpec.fromJson(<String, dynamic>{}),
        throwsArgumentError,
      );
    });
  });

  group('InsurerSpec — construcción y validación', () {
    test('construcción mínima válida', () {
      final s = InsurerSpec(
        insuranceLines: [InsuranceLine.soat, InsuranceLine.auto],
        isCarrier: true,
      );
      expect(s.insuranceLines.length, 2);
      expect(s.isCarrier, isTrue);
      expect(s.market, isNull);
      expect(s.regulatorLicenseRef, isNull);
    });

    test('insuranceLines vacía dispara assertion', () {
      expect(
        () => InsurerSpec(insuranceLines: const [], isCarrier: true),
        throwsA(isA<AssertionError>()),
      );
    });

    test('insuranceLines duplicadas dispara assertion', () {
      expect(
        () => InsurerSpec(
          insuranceLines: [InsuranceLine.soat, InsuranceLine.soat],
          isCarrier: true,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('isCarrier false es válido (aseguradora en runoff)', () {
      final s = InsurerSpec(
        insuranceLines: [InsuranceLine.empresarial],
        isCarrier: false,
      );
      expect(s.isCarrier, isFalse);
    });
  });

  group('InsurerSpec — serialización', () {
    test('toJson omite campos null', () {
      final s = InsurerSpec(
        insuranceLines: [InsuranceLine.soat],
        isCarrier: true,
      );
      expect(s.toJson(), {
        'insuranceLines': ['soat'],
        'isCarrier': true,
      });
    });

    test('toJson con todos los campos serializa RegulatorLicenseRef como string',
        () {
      final s = InsurerSpec(
        insuranceLines: [
          InsuranceLine.auto,
          InsuranceLine.responsabilidadCivil,
        ],
        isCarrier: true,
        market: AssetRegistrationType.vehiculo,
        regulatorLicenseRef: RegulatorLicenseRef('SFC-12345'),
      );
      expect(s.toJson(), {
        'insuranceLines': ['auto', 'responsabilidad_civil'],
        'isCarrier': true,
        'market': 'vehiculo',
        'regulatorLicense': 'SFC-12345',
      });
    });

    test('fromJson roundtrip preserva orden y RegulatorLicenseRef', () {
      final original = InsurerSpec(
        insuranceLines: [
          InsuranceLine.vida,
          InsuranceLine.salud,
          InsuranceLine.transporte,
        ],
        isCarrier: true,
        market: AssetRegistrationType.inmueble,
        regulatorLicenseRef: RegulatorLicenseRef('REG-1'),
      );
      final restored = InsurerSpec.fromJson(original.toJson());
      expect(restored, equals(original));
      expect(
        restored.insuranceLines.map((l) => l.wireName).toList(),
        ['vida', 'salud', 'transporte'],
      );
      expect(restored.regulatorLicenseRef?.value, 'REG-1');
    });

    test('toJson normaliza licencia a uppercase', () {
      // El VO normaliza en construcción; toJson preserva la forma normalizada.
      final s = InsurerSpec(
        insuranceLines: [InsuranceLine.soat],
        isCarrier: true,
        regulatorLicenseRef: RegulatorLicenseRef('  sfc-12345  '),
      );
      expect(s.toJson()['regulatorLicense'], 'SFC-12345');
    });

    test('fromJson throws si regulatorLicense tiene formato inválido', () {
      expect(
        () => InsurerSpec.fromJson({
          'insuranceLines': ['soat'],
          'isCarrier': true,
          'regulatorLicense': '',
        }),
        throwsArgumentError,
        reason: 'RegulatorLicenseRef rechaza string vacío',
      );
      expect(
        () => InsurerSpec.fromJson({
          'insuranceLines': ['soat'],
          'isCarrier': true,
          'regulatorLicense': 'SFC#12345',
        }),
        throwsArgumentError,
        reason: 'RegulatorLicenseRef rechaza símbolos no permitidos',
      );
    });

    test('fromJson throws si insuranceLines ausente', () {
      expect(
        () => InsurerSpec.fromJson({'isCarrier': true}),
        throwsArgumentError,
      );
    });

    test('fromJson throws si isCarrier ausente', () {
      expect(
        () => InsurerSpec.fromJson({
          'insuranceLines': ['soat'],
        }),
        throwsArgumentError,
      );
    });

    test('fromJson throws si línea desconocida', () {
      expect(
        () => InsurerSpec.fromJson({
          'insuranceLines': ['fianza'],
          'isCarrier': true,
        }),
        throwsArgumentError,
      );
    });

    test('fromJson throws si elemento de insuranceLines no es String', () {
      expect(
        () => InsurerSpec.fromJson({
          'insuranceLines': [123],
          'isCarrier': true,
        }),
        throwsArgumentError,
      );
    });
  });

  group('InsurerSpec — igualdad', () {
    test('mismas insuranceLines en mismo orden ⇒ iguales', () {
      final a = InsurerSpec(
        insuranceLines: [InsuranceLine.soat, InsuranceLine.auto],
        isCarrier: true,
      );
      final b = InsurerSpec(
        insuranceLines: [InsuranceLine.soat, InsuranceLine.auto],
        isCarrier: true,
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('orden distinto de insuranceLines ⇒ distintos', () {
      final a = InsurerSpec(
        insuranceLines: [InsuranceLine.soat, InsuranceLine.auto],
        isCarrier: true,
      );
      final b = InsurerSpec(
        insuranceLines: [InsuranceLine.auto, InsuranceLine.soat],
        isCarrier: true,
      );
      expect(a, isNot(equals(b)));
    });

    test('isCarrier distinto ⇒ distintos', () {
      final a = InsurerSpec(
        insuranceLines: [InsuranceLine.soat],
        isCarrier: true,
      );
      final b = InsurerSpec(
        insuranceLines: [InsuranceLine.soat],
        isCarrier: false,
      );
      expect(a, isNot(equals(b)));
    });
  });
}
