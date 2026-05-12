// ============================================================================
// test/domain/value/capability/capability_profile_test.dart
// Tests para CapabilityProfile (entidad agregadora con invariante estricta)
// ============================================================================
// Cubre:
//   - Construcción válida para los 5 kinds (provider/advisor/broker/legal/insurer).
//   - Invariante de exclusividad:
//       · sin spec ⇒ throws
//       · 2+ specs ⇒ throws
//       · spec correcta pero kind distinto ⇒ throws
//       · kind sin spec, otra spec poblada ⇒ throws (mensaje claro)
//   - Validación de campos comunes:
//       · assetTypeIds duplicados ⇒ throws
//       · coverageCities duplicados ⇒ throws
//       · branchId vacío/whitespace ⇒ throws
//   - copyWith: limita a campos comunes; preserva invariante.
//   - JSON roundtrip para los 5 kinds.
//   - JSON inválido:
//       · kind ausente / desconocido
//       · spec correspondiente ausente
//       · specs extras presentes (kind=provider con advisorSpec) ⇒ throws
//       · tipos incorrectos en assetTypeIds / coverageCities
//   - Igualdad por valor.
// ============================================================================

import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/domain/value/capability/advisor_spec.dart';
import 'package:avanzza/domain/value/capability/broker_spec.dart';
import 'package:avanzza/domain/value/capability/capability_profile.dart';
import 'package:avanzza/domain/value/capability/insurance_line.dart';
import 'package:avanzza/domain/value/capability/insurer_spec.dart';
import 'package:avanzza/domain/value/capability/legal_spec.dart';
import 'package:avanzza/domain/value/capability/legal_specialty.dart';
import 'package:avanzza/domain/value/capability/profile_kind.dart';
import 'package:avanzza/domain/value/capability/provider_spec.dart';
import 'package:avanzza/domain/value/capability/provider_type.dart';
import 'package:avanzza/domain/value/capability/refs/business_category_ref.dart';
import 'package:avanzza/domain/value/capability/refs/coverage_city_path.dart';
import 'package:avanzza/domain/value/capability/refs/regulator_license_ref.dart';
import 'package:flutter_test/flutter_test.dart';

ProviderSpec _stubProviderSpec() => const ProviderSpec(
      providerType: ProviderType.servicios,
    );

AdvisorSpec _stubAdvisorSpec() => const AdvisorSpec(
      market: AssetRegistrationType.vehiculo,
    );

BrokerSpec _stubBrokerSpec() => const BrokerSpec(
      market: AssetRegistrationType.inmueble,
    );

LegalSpec _stubLegalSpec() => const LegalSpec(specialty: LegalSpecialty.civil);

InsurerSpec _stubInsurerSpec() => InsurerSpec(
      insuranceLines: const [InsuranceLine.soat],
      isCarrier: true,
    );

void main() {
  group('CapabilityProfile — construcción válida por kind', () {
    test('kind=provider con providerSpec', () {
      final p = CapabilityProfile(
        kind: ProfileKind.provider,
        providerSpec: _stubProviderSpec(),
      );
      expect(p.kind, ProfileKind.provider);
      expect(p.providerSpec, isNotNull);
      expect(p.advisorSpec, isNull);
      expect(p.brokerSpec, isNull);
      expect(p.legalSpec, isNull);
      expect(p.insurerSpec, isNull);
    });

    test('kind=advisor con advisorSpec', () {
      final p = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
      );
      expect(p.kind, ProfileKind.advisor);
      expect(p.advisorSpec, isNotNull);
    });

    test('kind=broker con brokerSpec', () {
      final p = CapabilityProfile(
        kind: ProfileKind.broker,
        brokerSpec: _stubBrokerSpec(),
      );
      expect(p.kind, ProfileKind.broker);
      expect(p.brokerSpec, isNotNull);
    });

    test('kind=legal con legalSpec', () {
      final p = CapabilityProfile(
        kind: ProfileKind.legal,
        legalSpec: _stubLegalSpec(),
      );
      expect(p.kind, ProfileKind.legal);
      expect(p.legalSpec, isNotNull);
    });

    test('kind=insurer con insurerSpec', () {
      final p = CapabilityProfile(
        kind: ProfileKind.insurer,
        insurerSpec: _stubInsurerSpec(),
      );
      expect(p.kind, ProfileKind.insurer);
      expect(p.insurerSpec, isNotNull);
    });

    test('campos comunes opcionales: lista vacía y branchId null por default',
        () {
      final p = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
      );
      expect(p.assetTypeIds, isEmpty);
      expect(p.coverageCities, isEmpty);
      expect(p.branchId, isNull);
    });

    test('campos comunes poblados', () {
      final p = CapabilityProfile(
        kind: ProfileKind.provider,
        providerSpec: _stubProviderSpec(),
        assetTypeIds: const [
          AssetRegistrationType.vehiculo,
          AssetRegistrationType.maquinaria,
        ],
        coverageCities: [
          CoverageCityPath.fromString('CO/col-ant/col-ant-med'),
          CoverageCityPath.fromString('CO/col-bog/col-bog-bog'),
        ],
        branchId: 'branch-123',
      );
      expect(p.assetTypeIds.length, 2);
      expect(p.coverageCities.length, 2);
      expect(p.branchId, 'branch-123');
    });
  });

  group('CapabilityProfile — invariante de exclusividad', () {
    test('sin ninguna spec poblada ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile(kind: ProfileKind.provider),
        throwsArgumentError,
      );
      expect(
        () => CapabilityProfile(kind: ProfileKind.insurer),
        throwsArgumentError,
      );
    });

    test('kind=provider con advisorSpec (kind no coincide) ⇒ ArgumentError',
        () {
      expect(
        () => CapabilityProfile(
          kind: ProfileKind.provider,
          advisorSpec: _stubAdvisorSpec(),
        ),
        throwsArgumentError,
      );
    });

    test('kind=insurer con brokerSpec (kind no coincide) ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile(
          kind: ProfileKind.insurer,
          brokerSpec: _stubBrokerSpec(),
        ),
        throwsArgumentError,
      );
    });

    test('múltiples specs pobladas ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile(
          kind: ProfileKind.provider,
          providerSpec: _stubProviderSpec(),
          advisorSpec: _stubAdvisorSpec(),
        ),
        throwsArgumentError,
      );
      expect(
        () => CapabilityProfile(
          kind: ProfileKind.legal,
          legalSpec: _stubLegalSpec(),
          insurerSpec: _stubInsurerSpec(),
        ),
        throwsArgumentError,
      );
      expect(
        () => CapabilityProfile(
          kind: ProfileKind.broker,
          brokerSpec: _stubBrokerSpec(),
          legalSpec: _stubLegalSpec(),
          insurerSpec: _stubInsurerSpec(),
        ),
        throwsArgumentError,
      );
    });

    test('mensaje de error es informativo (incluye kind y spec esperada)', () {
      try {
        CapabilityProfile(
          kind: ProfileKind.provider,
          advisorSpec: _stubAdvisorSpec(),
        );
        fail('Esperaba ArgumentError');
      } on ArgumentError catch (e) {
        final msg = e.toString();
        expect(msg, contains('provider'));
        expect(msg, contains('advisor'));
      }
    });
  });

  group('CapabilityProfile — campos comunes (validación)', () {
    test('assetTypeIds con duplicados ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile(
          kind: ProfileKind.advisor,
          advisorSpec: _stubAdvisorSpec(),
          assetTypeIds: const [
            AssetRegistrationType.vehiculo,
            AssetRegistrationType.vehiculo,
          ],
        ),
        throwsArgumentError,
      );
    });

    test('coverageCities con duplicados ⇒ ArgumentError', () {
      final c = CoverageCityPath.fromString('CO/col-ant/col-ant-med');
      expect(
        () => CapabilityProfile(
          kind: ProfileKind.advisor,
          advisorSpec: _stubAdvisorSpec(),
          coverageCities: [c, c],
        ),
        throwsArgumentError,
      );
    });

    test('branchId vacío ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile(
          kind: ProfileKind.advisor,
          advisorSpec: _stubAdvisorSpec(),
          branchId: '',
        ),
        throwsArgumentError,
      );
    });

    test('branchId solo whitespace ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile(
          kind: ProfileKind.advisor,
          advisorSpec: _stubAdvisorSpec(),
          branchId: '   ',
        ),
        throwsArgumentError,
      );
    });
  });

  group('CapabilityProfile — copyWith', () {
    test('copyWith preserva kind y spec, actualiza campos comunes', () {
      final base = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
        branchId: 'old-branch',
      );
      final updated = base.copyWith(
        assetTypeIds: const [AssetRegistrationType.maquinaria],
        branchId: 'new-branch',
      );
      expect(updated.kind, ProfileKind.advisor);
      expect(updated.advisorSpec, base.advisorSpec);
      expect(updated.assetTypeIds, [AssetRegistrationType.maquinaria]);
      expect(updated.branchId, 'new-branch');
    });

    test('copyWith re-valida (assetTypeIds duplicados ⇒ throws)', () {
      final base = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
      );
      expect(
        () => base.copyWith(
          assetTypeIds: const [
            AssetRegistrationType.vehiculo,
            AssetRegistrationType.vehiculo,
          ],
        ),
        throwsArgumentError,
      );
    });
  });

  group('CapabilityProfile — JSON roundtrip por kind', () {
    test('kind=provider', () {
      final original = CapabilityProfile(
        kind: ProfileKind.provider,
        providerSpec: ProviderSpec(
          providerType: ProviderType.servicios,
          market: AssetRegistrationType.vehiculo,
          businessCategoryRef: BusinessCategoryRef('mecanico_independiente'),
        ),
        assetTypeIds: const [AssetRegistrationType.vehiculo],
        coverageCities: [
          CoverageCityPath.fromString('CO/col-ant/col-ant-med'),
        ],
        branchId: 'b1',
      );
      final restored = CapabilityProfile.fromJson(original.toJson());
      expect(restored, equals(original));
    });

    test('kind=advisor', () {
      final original = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
        coverageCities: [CoverageCityPath.fromString('US/ny/nyc')],
      );
      final restored = CapabilityProfile.fromJson(original.toJson());
      expect(restored, equals(original));
    });

    test('kind=broker', () {
      final original = CapabilityProfile(
        kind: ProfileKind.broker,
        brokerSpec: _stubBrokerSpec(),
      );
      final restored = CapabilityProfile.fromJson(original.toJson());
      expect(restored, equals(original));
    });

    test('kind=legal', () {
      final original = CapabilityProfile(
        kind: ProfileKind.legal,
        legalSpec: const LegalSpec(specialty: LegalSpecialty.ambas),
        branchId: 'firm-001',
      );
      final restored = CapabilityProfile.fromJson(original.toJson());
      expect(restored, equals(original));
    });

    test('kind=insurer con todos los campos', () {
      final original = CapabilityProfile(
        kind: ProfileKind.insurer,
        insurerSpec: InsurerSpec(
          insuranceLines: const [
            InsuranceLine.auto,
            InsuranceLine.responsabilidadCivil,
          ],
          isCarrier: true,
          market: AssetRegistrationType.vehiculo,
          regulatorLicenseRef: RegulatorLicenseRef('SFC-12345'),
        ),
        assetTypeIds: const [AssetRegistrationType.vehiculo],
        coverageCities: [
          CoverageCityPath.fromString('CO/col-ant/col-ant-med'),
        ],
      );
      final restored = CapabilityProfile.fromJson(original.toJson());
      expect(restored, equals(original));
    });
  });

  group('CapabilityProfile — toJson estructura', () {
    test('omite specs no aplicables y branchId null', () {
      final p = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
      );
      final json = p.toJson();
      expect(json.containsKey('advisorSpec'), isTrue);
      expect(json.containsKey('providerSpec'), isFalse);
      expect(json.containsKey('brokerSpec'), isFalse);
      expect(json.containsKey('legalSpec'), isFalse);
      expect(json.containsKey('insurerSpec'), isFalse);
      expect(json.containsKey('branchId'), isFalse);
    });

    test('serializa assetTypeIds como wireNames', () {
      final p = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
        assetTypeIds: const [
          AssetRegistrationType.vehiculo,
          AssetRegistrationType.maquinaria,
        ],
      );
      expect(p.toJson()['assetTypeIds'], ['vehiculo', 'maquinaria']);
    });

    test('serializa coverageCities como strings PAIS/REGION/CIUDAD', () {
      final p = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
        coverageCities: [
          CoverageCityPath.fromString('CO/col-ant/col-ant-med'),
          CoverageCityPath.fromString('US/ny/nyc'),
        ],
      );
      expect(p.toJson()['coverageCities'], [
        'CO/col-ant/col-ant-med',
        'US/ny/nyc',
      ]);
    });
  });

  group('CapabilityProfile — fromJson rechazos', () {
    test('kind ausente ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile.fromJson(<String, dynamic>{}),
        throwsArgumentError,
      );
    });

    test('kind desconocido ⇒ ArgumentError (vía ProfileKindX.fromWire)', () {
      expect(
        () => CapabilityProfile.fromJson({'kind': 'underwriter'}),
        throwsArgumentError,
      );
    });

    test('kind=provider sin providerSpec en JSON ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile.fromJson({'kind': 'provider'}),
        throwsArgumentError,
      );
    });

    test('kind=advisor con providerSpec extra ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile.fromJson({
          'kind': 'advisor',
          'advisorSpec': {'market': 'vehiculo'},
          'providerSpec': {'providerType': 'servicios'},
        }),
        throwsArgumentError,
      );
    });

    test('kind=insurer con legalSpec extra ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile.fromJson({
          'kind': 'insurer',
          'insurerSpec': {
            'insuranceLines': ['soat'],
            'isCarrier': true,
          },
          'legalSpec': {'specialty': 'civil'},
        }),
        throwsArgumentError,
      );
    });

    test('assetTypeIds no es List ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile.fromJson({
          'kind': 'advisor',
          'assetTypeIds': 'vehiculo',
          'advisorSpec': {'market': 'vehiculo'},
        }),
        throwsArgumentError,
      );
    });

    test('elemento de assetTypeIds no es String ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile.fromJson({
          'kind': 'advisor',
          'assetTypeIds': [42],
          'advisorSpec': {'market': 'vehiculo'},
        }),
        throwsArgumentError,
      );
    });

    test('coverageCities con path malformado ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile.fromJson({
          'kind': 'advisor',
          'coverageCities': ['CO/col-ant'], // 2 segmentos
          'advisorSpec': {'market': 'vehiculo'},
        }),
        throwsArgumentError,
      );
    });

    test('branchId no-string ⇒ ArgumentError', () {
      expect(
        () => CapabilityProfile.fromJson({
          'kind': 'advisor',
          'branchId': 42,
          'advisorSpec': {'market': 'vehiculo'},
        }),
        throwsArgumentError,
      );
    });

    test('providerSpec malformado ⇒ ArgumentError (heredado del spec)', () {
      expect(
        () => CapabilityProfile.fromJson({
          'kind': 'provider',
          'providerSpec': {
            'providerType': 'productos', // wire desconocido
          },
        }),
        throwsArgumentError,
      );
    });
  });

  group('CapabilityProfile — igualdad', () {
    test('mismas configuraciones ⇒ iguales', () {
      final a = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
        assetTypeIds: const [AssetRegistrationType.vehiculo],
      );
      final b = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
        assetTypeIds: const [AssetRegistrationType.vehiculo],
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('orden distinto en assetTypeIds ⇒ distintos', () {
      final a = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
        assetTypeIds: const [
          AssetRegistrationType.vehiculo,
          AssetRegistrationType.maquinaria,
        ],
      );
      final b = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
        assetTypeIds: const [
          AssetRegistrationType.maquinaria,
          AssetRegistrationType.vehiculo,
        ],
      );
      expect(a, isNot(equals(b)));
    });

    test('kind distinto ⇒ distintos', () {
      final a = CapabilityProfile(
        kind: ProfileKind.advisor,
        advisorSpec: _stubAdvisorSpec(),
      );
      final b = CapabilityProfile(
        kind: ProfileKind.broker,
        brokerSpec: _stubBrokerSpec(),
      );
      expect(a, isNot(equals(b)));
    });
  });
}
