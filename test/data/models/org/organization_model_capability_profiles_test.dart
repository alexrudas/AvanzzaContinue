// ============================================================================
// test/data/models/org/organization_model_capability_profiles_test.dart
// Tests del campo OrganizationModel.capabilityProfilesJson y sus mappers
// ============================================================================
// Cubre solo los paths que NO requieren FirebaseFirestore vivo:
//   - fromEntity → encode JSON String
//   - toEntity   → decode JSON String (parsedCapabilityProfiles)
//   - toIsarJson incluye la clave
//   - Helpers estáticos a través de los outputs de fromEntity/toEntity:
//       · _encodeCapabilityProfilesJson(empty) ⇒ null (verificable vía
//         capabilityProfilesJson tras fromEntity con [] explícito).
//       · roundtrip preservation (entity → model → entity).
//   - Compat legacy:
//       · OrganizationModel construido sin capabilityProfilesJson ⇒
//         toEntity().capabilityProfiles == [].
//
// Excluye (cubrir en integration tests separados):
//   - fromFirestore (requiere FirebaseFirestore para refs).
//   - fromIsar     (requiere FirebaseFirestore para refs).
// ============================================================================

import 'dart:convert';

import 'package:avanzza/data/models/org/organization_model.dart';
import 'package:avanzza/domain/entities/org/organization_entity.dart';
import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/domain/value/capability/advisor_spec.dart';
import 'package:avanzza/domain/value/capability/capability_profile.dart';
import 'package:avanzza/domain/value/capability/insurance_line.dart';
import 'package:avanzza/domain/value/capability/insurer_spec.dart';
import 'package:avanzza/domain/value/capability/profile_kind.dart';
import 'package:avanzza/domain/value/capability/provider_spec.dart';
import 'package:avanzza/domain/value/capability/provider_type.dart';
import 'package:avanzza/domain/value/capability/refs/business_category_ref.dart';
import 'package:avanzza/domain/value/capability/refs/regulator_license_ref.dart';
import 'package:flutter_test/flutter_test.dart';

CapabilityProfile _provider() => CapabilityProfile(
      kind: ProfileKind.provider,
      providerSpec: ProviderSpec(
        providerType: ProviderType.servicios,
        market: AssetRegistrationType.vehiculo,
        businessCategoryRef:
            BusinessCategoryRef('mecanico_independiente'),
      ),
    );

CapabilityProfile _advisor() => CapabilityProfile(
      kind: ProfileKind.advisor,
      advisorSpec: const AdvisorSpec(market: AssetRegistrationType.inmueble),
    );

CapabilityProfile _insurer() => CapabilityProfile(
      kind: ProfileKind.insurer,
      insurerSpec: InsurerSpec(
        insuranceLines: const [InsuranceLine.soat],
        isCarrier: true,
        regulatorLicenseRef: RegulatorLicenseRef('SFC-12345'),
      ),
    );

OrganizationEntity _entityWithCapabilities(
  List<CapabilityProfile> profiles,
) {
  return OrganizationEntity(
    id: 'org-1',
    nombre: 'Acme S.A.S.',
    tipo: 'empresa',
    countryId: 'CO',
    capabilityProfiles: profiles,
  );
}

void main() {
  group('OrganizationModel.fromEntity — encode capabilityProfilesJson', () {
    test('lista vacía ⇒ capabilityProfilesJson es null (omit)', () {
      final entity = _entityWithCapabilities(const []);
      final model = OrganizationModel.fromEntity(entity);
      expect(model.capabilityProfilesJson, isNull);
    });

    test('un capability ⇒ JSON Array con 1 item', () {
      final entity = _entityWithCapabilities([_provider()]);
      final model = OrganizationModel.fromEntity(entity);
      expect(model.capabilityProfilesJson, isNotNull);
      final decoded = jsonDecode(model.capabilityProfilesJson!);
      expect(decoded, isA<List>());
      expect((decoded as List).length, 1);
      expect((decoded.first as Map)['kind'], 'provider');
    });

    test('múltiples capabilities ⇒ orden preservado en el JSON', () {
      final entity = _entityWithCapabilities([
        _provider(),
        _advisor(),
        _insurer(),
      ]);
      final model = OrganizationModel.fromEntity(entity);
      final decoded = jsonDecode(model.capabilityProfilesJson!) as List;
      expect(decoded.length, 3);
      expect((decoded[0] as Map)['kind'], 'provider');
      expect((decoded[1] as Map)['kind'], 'advisor');
      expect((decoded[2] as Map)['kind'], 'insurer');
    });
  });

  group('OrganizationModel.toEntity — decode capabilityProfilesJson', () {
    test('capabilityProfilesJson null ⇒ entity con [] default', () {
      final model = OrganizationModel(
        id: 'org-legacy',
        nombre: 'Legacy',
        tipo: 'empresa',
        countryId: 'CO',
      );
      final entity = model.toEntity();
      expect(entity.capabilityProfiles, isEmpty);
    });

    test('capabilityProfilesJson vacío ⇒ entity con [] (resilencia)', () {
      final model = OrganizationModel(
        id: 'org-x',
        nombre: 'X',
        tipo: 'empresa',
        countryId: 'CO',
        capabilityProfilesJson: '',
      );
      final entity = model.toEntity();
      expect(entity.capabilityProfiles, isEmpty);
    });

    test('capabilityProfilesJson con datos válidos ⇒ entity recupera profiles',
        () {
      final original = _entityWithCapabilities([
        _provider(),
        _advisor(),
      ]);
      final model = OrganizationModel.fromEntity(original);
      final restored = model.toEntity();
      expect(restored.capabilityProfiles.length, 2);
      expect(restored.capabilityProfiles, equals(original.capabilityProfiles));
    });

    test('capabilityProfilesJson corrupto ⇒ fallback seguro a []', () {
      final model = OrganizationModel(
        id: 'org-corrupt',
        nombre: 'Corrupt',
        tipo: 'empresa',
        countryId: 'CO',
        capabilityProfilesJson: '{not valid json',
      );
      final entity = model.toEntity();
      expect(entity.capabilityProfiles, isEmpty);
    });

    test('capabilityProfilesJson con estructura inválida ⇒ fallback []', () {
      // JSON válido pero no es array (es un objeto suelto).
      final model = OrganizationModel(
        id: 'org-corrupt',
        nombre: 'Corrupt',
        tipo: 'empresa',
        countryId: 'CO',
        capabilityProfilesJson: '{"kind":"provider"}',
      );
      final entity = model.toEntity();
      expect(entity.capabilityProfiles, isEmpty);
    });

    test('capabilityProfilesJson con un item malformado ⇒ fallback total []',
        () {
      // Política: si UN item está corrupto, fallback total. Preferimos
      // "sin capabilities" sobre mezclar buenas y malas.
      final model = OrganizationModel(
        id: 'org-corrupt',
        nombre: 'Corrupt',
        tipo: 'empresa',
        countryId: 'CO',
        capabilityProfilesJson:
            '[{"kind":"provider","providerSpec":{"providerType":"servicios"}},'
            '{"kind":"underwriter"}]',
      );
      final entity = model.toEntity();
      expect(entity.capabilityProfiles, isEmpty);
    });
  });

  group('OrganizationModel — roundtrip entity → model → entity', () {
    test('preserva capabilityProfiles a través del modelo', () {
      final original = _entityWithCapabilities([
        _provider(),
        _advisor(),
        _insurer(),
      ]);
      final model = OrganizationModel.fromEntity(original);
      final restored = model.toEntity();
      expect(restored.capabilityProfiles, equals(original.capabilityProfiles));
    });

    test('roundtrip preserva todos los demás campos (no afecta tipo/contract)',
        () {
      final original = _entityWithCapabilities([_provider()]);
      final restored =
          OrganizationModel.fromEntity(original).toEntity();
      expect(restored.id, original.id);
      expect(restored.nombre, original.nombre);
      expect(restored.tipo, original.tipo);
      expect(restored.countryId, original.countryId);
      expect(restored.contract, original.contract);
      expect(restored.isActive, original.isActive);
    });
  });

  group('OrganizationModel.toIsarJson — incluye capabilityProfilesJson', () {
    test('serializa el campo cuando hay capabilities', () {
      final model = OrganizationModel.fromEntity(
        _entityWithCapabilities([_provider()]),
      );
      final isarJson = model.toIsarJson();
      expect(isarJson.containsKey('capabilityProfilesJson'), isTrue);
      expect(isarJson['capabilityProfilesJson'], isNotNull);
    });

    test('serializa null cuando no hay capabilities', () {
      final model = OrganizationModel.fromEntity(
        _entityWithCapabilities(const []),
      );
      final isarJson = model.toIsarJson();
      expect(isarJson.containsKey('capabilityProfilesJson'), isTrue);
      expect(isarJson['capabilityProfilesJson'], isNull);
    });
  });

  group('OrganizationModel.toFirestoreJson — emite lista nativa', () {
    test('cuando hay capabilities ⇒ "capabilityProfiles" key con List', () {
      final model = OrganizationModel.fromEntity(
        _entityWithCapabilities([_provider(), _advisor()]),
      );
      final firestoreJson = model.toFirestoreJson();
      expect(firestoreJson.containsKey('capabilityProfiles'), isTrue);
      final list = firestoreJson['capabilityProfiles'];
      expect(list, isA<List>());
      expect((list as List).length, 2);
      // Cada item debe ser Map (no string JSON).
      expect(list.first, isA<Map>());
    });

    test('cuando NO hay capabilities ⇒ key omitida', () {
      final model = OrganizationModel.fromEntity(
        _entityWithCapabilities(const []),
      );
      final firestoreJson = model.toFirestoreJson();
      expect(firestoreJson.containsKey('capabilityProfiles'), isFalse);
    });
  });

  group('OrganizationModel.parsedCapabilityProfiles — getter', () {
    test('null ⇒ []', () {
      final model = OrganizationModel(
        id: 'o1',
        nombre: 'X',
        tipo: 'empresa',
        countryId: 'CO',
      );
      expect(model.parsedCapabilityProfiles, isEmpty);
    });

    test('JSON válido ⇒ lista parseada', () {
      final model = OrganizationModel.fromEntity(
        _entityWithCapabilities([_advisor()]),
      );
      expect(model.parsedCapabilityProfiles.length, 1);
      expect(model.parsedCapabilityProfiles.first.kind, ProfileKind.advisor);
    });

    test('JSON corrupto ⇒ [] (fallback seguro)', () {
      final model = OrganizationModel(
        id: 'o1',
        nombre: 'X',
        tipo: 'empresa',
        countryId: 'CO',
        capabilityProfilesJson: '@@@ basura @@@',
      );
      expect(model.parsedCapabilityProfiles, isEmpty);
    });
  });
}
