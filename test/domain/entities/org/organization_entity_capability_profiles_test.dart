// ============================================================================
// test/domain/entities/org/organization_entity_capability_profiles_test.dart
// Tests del campo OrganizationEntity.capabilityProfiles
// ============================================================================
// Cubre:
//   - Default seguro: lista vacía cuando no se pasa.
//   - Construcción con múltiples profiles (provider + advisor en una org).
//   - JSON roundtrip vía CapabilityProfileListConverter.
//   - Compatibilidad legacy: JSON sin la clave 'capabilityProfiles' ⇒ [] default.
//   - JSON con lista vacía explícita ⇒ [] (idempotente).
//   - JSON con item malformado ⇒ ArgumentError (path estricto).
//   - El campo NO afecta los demás (Organization.tipo, contract, etc.).
// ============================================================================

import 'dart:convert';

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

OrganizationEntity _baseEntity({
  List<CapabilityProfile>? capabilityProfiles,
}) {
  return OrganizationEntity(
    id: 'org-1',
    nombre: 'Acme S.A.S.',
    tipo: 'empresa',
    countryId: 'CO',
    capabilityProfiles:
        capabilityProfiles ?? const <CapabilityProfile>[],
  );
}

CapabilityProfile _providerCapability() => CapabilityProfile(
      kind: ProfileKind.provider,
      providerSpec: ProviderSpec(
        providerType: ProviderType.servicios,
        market: AssetRegistrationType.vehiculo,
        businessCategoryRef:
            BusinessCategoryRef('mecanico_independiente'),
      ),
    );

CapabilityProfile _advisorCapability() => CapabilityProfile(
      kind: ProfileKind.advisor,
      advisorSpec: const AdvisorSpec(market: AssetRegistrationType.inmueble),
    );

CapabilityProfile _insurerCapability() => CapabilityProfile(
      kind: ProfileKind.insurer,
      insurerSpec: InsurerSpec(
        insuranceLines: const [InsuranceLine.soat, InsuranceLine.auto],
        isCarrier: true,
        market: AssetRegistrationType.vehiculo,
        regulatorLicenseRef: RegulatorLicenseRef('SFC-12345'),
      ),
    );

void main() {
  group('OrganizationEntity.capabilityProfiles — defaults', () {
    test('omitir el campo ⇒ lista vacía por default', () {
      const org = OrganizationEntity(
        id: 'o1',
        nombre: 'Personal Workspace',
        tipo: 'personal',
        countryId: 'CO',
      );
      expect(org.capabilityProfiles, isEmpty);
    });

    test('pasar [] explícito ⇒ lista vacía', () {
      final org = _baseEntity();
      expect(org.capabilityProfiles, isEmpty);
    });

    test('default [] no rompe Organization.tipo ni contract', () {
      const org = OrganizationEntity(
        id: 'o1',
        nombre: 'Personal',
        tipo: 'personal',
        countryId: 'CO',
      );
      expect(org.tipo, 'personal');
      expect(org.contract, isNotNull);
      expect(org.isActive, isTrue);
    });
  });

  group('OrganizationEntity.capabilityProfiles — construcción válida', () {
    test('un solo capability profile (provider)', () {
      final org = _baseEntity(capabilityProfiles: [_providerCapability()]);
      expect(org.capabilityProfiles.length, 1);
      expect(org.capabilityProfiles.first.kind, ProfileKind.provider);
    });

    test('múltiples capabilities (provider + advisor + insurer)', () {
      final org = _baseEntity(
        capabilityProfiles: [
          _providerCapability(),
          _advisorCapability(),
          _insurerCapability(),
        ],
      );
      expect(org.capabilityProfiles.length, 3);
      final kinds =
          org.capabilityProfiles.map((c) => c.kind).toList();
      expect(kinds, [
        ProfileKind.provider,
        ProfileKind.advisor,
        ProfileKind.insurer,
      ]);
    });
  });

  group('OrganizationEntity.capabilityProfiles — JSON roundtrip', () {
    test('toJson incluye capabilityProfiles serializadas como lista', () {
      final org = _baseEntity(
        capabilityProfiles: [_providerCapability(), _advisorCapability()],
      );
      final json = org.toJson();
      expect(json['capabilityProfiles'], isA<List>());
      expect((json['capabilityProfiles'] as List).length, 2);
      expect(
        (json['capabilityProfiles'] as List).first,
        isA<Map<String, dynamic>>(),
      );
      expect(
        ((json['capabilityProfiles'] as List).first
            as Map<String, dynamic>)['kind'],
        'provider',
      );
    });

    test('fromJson(toJson()) preserva capabilityProfiles', () {
      // NOTA: forzamos roundtrip vía jsonEncode/jsonDecode porque
      // OrganizationEntity (preexistente al ítem 4) no usa
      // explicitToJson:true en su anotación, por lo que su `toJson()`
      // emite objetos Dart anidados (no Maps puros). jsonEncode los
      // canoniza vía toJson recursivo de cada subobjeto, lo que
      // refleja el comportamiento real al persistir/leer JSON.
      final original = _baseEntity(
        capabilityProfiles: [
          _providerCapability(),
          _advisorCapability(),
          _insurerCapability(),
        ],
      );
      final encoded = jsonEncode(original.toJson());
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      final restored = OrganizationEntity.fromJson(decoded);
      expect(restored.capabilityProfiles.length, 3);
      expect(restored, equals(original));
    });

    test('fromJson preserva detalles del spec discriminado por kind', () {
      final original = _baseEntity(
        capabilityProfiles: [_insurerCapability()],
      );
      final encoded = jsonEncode(original.toJson());
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      final restored = OrganizationEntity.fromJson(decoded);
      final cap = restored.capabilityProfiles.first;
      expect(cap.kind, ProfileKind.insurer);
      expect(cap.insurerSpec, isNotNull);
      expect(
        cap.insurerSpec!.regulatorLicenseRef?.value,
        'SFC-12345',
      );
      expect(cap.insurerSpec!.insuranceLines.length, 2);
    });
  });

  group('OrganizationEntity.capabilityProfiles — compat legacy', () {
    test('JSON sin la clave capabilityProfiles ⇒ default []', () {
      final json = <String, dynamic>{
        'id': 'org-legacy',
        'nombre': 'Legacy Org',
        'tipo': 'empresa',
        'countryId': 'CO',
      };
      final org = OrganizationEntity.fromJson(json);
      expect(org.capabilityProfiles, isEmpty);
      expect(org.id, 'org-legacy');
    });

    test('JSON con capabilityProfiles=[] explícito ⇒ []', () {
      final json = <String, dynamic>{
        'id': 'org-legacy',
        'nombre': 'Legacy Org',
        'tipo': 'empresa',
        'countryId': 'CO',
        'capabilityProfiles': <Map<String, dynamic>>[],
      };
      final org = OrganizationEntity.fromJson(json);
      expect(org.capabilityProfiles, isEmpty);
    });
  });

  group('OrganizationEntity.capabilityProfiles — JSON estricto', () {
    test('item malformado (kind desconocido) ⇒ ArgumentError', () {
      final json = <String, dynamic>{
        'id': 'o1',
        'nombre': 'X',
        'tipo': 'empresa',
        'countryId': 'CO',
        'capabilityProfiles': [
          {'kind': 'underwriter'}, // wireName no existe
        ],
      };
      expect(
        () => OrganizationEntity.fromJson(json),
        throwsArgumentError,
      );
    });

    test('item con kind=provider sin providerSpec ⇒ ArgumentError', () {
      final json = <String, dynamic>{
        'id': 'o1',
        'nombre': 'X',
        'tipo': 'empresa',
        'countryId': 'CO',
        'capabilityProfiles': [
          {'kind': 'provider'},
        ],
      };
      expect(
        () => OrganizationEntity.fromJson(json),
        throwsArgumentError,
      );
    });

    test('item con specs cruzadas (kind=advisor + providerSpec) ⇒ ArgumentError',
        () {
      final json = <String, dynamic>{
        'id': 'o1',
        'nombre': 'X',
        'tipo': 'empresa',
        'countryId': 'CO',
        'capabilityProfiles': [
          {
            'kind': 'advisor',
            'advisorSpec': {'market': 'vehiculo'},
            'providerSpec': {'providerType': 'servicios'},
          },
        ],
      };
      expect(
        () => OrganizationEntity.fromJson(json),
        throwsArgumentError,
      );
    });
  });

  group('OrganizationEntity — copyWith preserva capabilities', () {
    test('copyWith sin tocar capabilities ⇒ se preservan', () {
      final org = _baseEntity(
        capabilityProfiles: [_providerCapability()],
      );
      final updated = org.copyWith(nombre: 'Nuevo Nombre');
      expect(updated.nombre, 'Nuevo Nombre');
      expect(updated.capabilityProfiles, equals(org.capabilityProfiles));
    });

    test('copyWith para mutar capabilities ⇒ reemplaza la lista', () {
      final org = _baseEntity(
        capabilityProfiles: [_providerCapability()],
      );
      final updated = org.copyWith(
        capabilityProfiles: [_advisorCapability()],
      );
      expect(updated.capabilityProfiles.length, 1);
      expect(updated.capabilityProfiles.first.kind, ProfileKind.advisor);
    });
  });
}
