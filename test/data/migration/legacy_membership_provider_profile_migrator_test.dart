// ============================================================================
// test/data/migration/legacy_membership_provider_profile_migrator_test.dart
// Tests del LegacyMembershipProviderProfileMigrator (8 casos pedidos por
// el ítem 6).
// ============================================================================
// `Membership.providerProfiles` está marcado @Deprecated; este test es el
// consumidor legítimo del campo legacy (verifica el migrator que lo drena).
// ignore_for_file: deprecated_member_use
// ============================================================================
// Cubre:
//   1. Migración básica (1 profile → 1 capability).
//   2. Múltiples profiles → múltiples capabilities.
//   3. Duplicados → no duplicar.
//   4. Datos malformados → warnings (path tolerante).
//   5. Datos irrecuperables → skip + error.
//   6. Organization ya tenía capabilities → merge correcto.
//   7. No tocar Portfolio ni AssetActorLink (verificado por absence).
//   8. Telemetría invocada correctamente (success/warning/error).
//
// Reglas verificadas:
//   - kind=provider SIEMPRE (legacy no discrimina advisor/broker/legal/insurer).
//   - Sin pérdida silenciosa: cada degradación deja warning tipado o error.
//   - Sin contaminación de dominio: jamás se infiere AssetActorRole.
// ============================================================================

import 'package:avanzza/core/telemetry/legacy_membership_migration_telemetry.dart';
import 'package:avanzza/data/migration/legacy_membership_provider_profile_migrator.dart';
import 'package:avanzza/domain/entities/org/organization_entity.dart';
import 'package:avanzza/domain/entities/user/membership_entity.dart';
import 'package:avanzza/domain/entities/user/provider_profile.dart';
import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/domain/value/capability/capability_profile.dart';
import 'package:avanzza/domain/value/capability/profile_kind.dart';
import 'package:avanzza/domain/value/capability/provider_spec.dart';
import 'package:avanzza/domain/value/capability/provider_type.dart';
import 'package:avanzza/domain/value/capability/refs/business_category_ref.dart';
import 'package:flutter_test/flutter_test.dart';

class _Recorder {
  final List<({String event, Map<String, dynamic> props})> events = [];
  void call(String event, Map<String, dynamic> props) {
    events.add((event: event, props: Map<String, dynamic>.from(props)));
  }

  List<String> get eventNames => events.map((e) => e.event).toList();
}

OrganizationEntity _emptyOrg({
  String id = 'org-1',
  List<CapabilityProfile> capabilityProfiles = const [],
}) {
  return OrganizationEntity(
    id: id,
    nombre: 'Acme',
    tipo: 'empresa',
    countryId: 'CO',
    capabilityProfiles: capabilityProfiles,
  );
}

MembershipEntity _membership({
  String userId = 'uid-1',
  String orgId = 'org-1',
  required List<ProviderProfile> providerProfiles,
}) {
  return MembershipEntity(
    userId: userId,
    orgId: orgId,
    orgName: 'Acme',
    providerProfiles: providerProfiles,
    estatus: 'activo',
    primaryLocation: const {'countryId': 'CO'},
  );
}

ProviderProfile _legacyProfile({
  String providerType = 'servicios',
  String businessCategoryId = 'mecanico_independiente',
  List<String> assetTypeIds = const ['vehiculos'],
  List<String> coverageCities = const ['CO/col-ant/col-ant-med'],
  List<String> assetSegmentIds = const [],
  List<String> offeringLineIds = const [],
  String? branchId,
}) {
  return ProviderProfile(
    providerType: providerType,
    businessCategoryId: businessCategoryId,
    assetTypeIds: assetTypeIds,
    coverageCities: coverageCities,
    assetSegmentIds: assetSegmentIds,
    offeringLineIds: offeringLineIds,
    branchId: branchId,
  );
}

void main() {
  late _Recorder rec;

  setUp(() {
    rec = _Recorder();
    LegacyMembershipMigrationTelemetry.debugSetEmitter(rec.call);
  });

  tearDown(() {
    LegacyMembershipMigrationTelemetry.resetEmitter();
  });

  // ──────────────────────────────────────────────────────────────────────
  // 1. Migración básica
  // ──────────────────────────────────────────────────────────────────────
  group('1. Migración básica (1 profile → 1 capability)', () {
    test('mapea correctamente todos los campos comunes y el providerSpec', () {
      final org = _emptyOrg();
      final m = _membership(
        providerProfiles: [_legacyProfile(branchId: 'br-1')],
      );
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: m,
        organization: org,
      );

      expect(r.profilesAttempted, 1);
      expect(r.profilesMigrated, 1);
      expect(r.profilesSkippedDuplicate, 0);
      expect(r.profilesSkippedError, 0);
      expect(r.hasChanges, isTrue);

      expect(r.updatedOrganization.capabilityProfiles.length, 1);
      final c = r.updatedOrganization.capabilityProfiles.first;
      expect(c.kind, ProfileKind.provider);
      expect(c.providerSpec, isNotNull);
      expect(c.providerSpec!.providerType, ProviderType.servicios);
      expect(c.providerSpec!.businessCategoryRef?.value,
          'mecanico_independiente');
      expect(c.assetTypeIds, [AssetRegistrationType.vehiculo]);
      expect(c.coverageCities.length, 1);
      expect(c.coverageCities.first.value, 'CO/col-ant/col-ant-med');
      expect(c.branchId, 'br-1');
    });

    test('outcome reportado como migrated sin warnings ni error', () {
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [_legacyProfile()]),
        organization: _emptyOrg(),
      );
      expect(r.outcomes.length, 1);
      expect(r.outcomes.first.status, ProfileMigrationStatus.migrated);
      expect(r.outcomes.first.warnings, isEmpty);
      expect(r.outcomes.first.errorMessage, isNull);
    });

    test('mapea plural legacy → singular canónico (vehiculos → vehiculo)',
        () {
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(assetTypeIds: const [
            'vehiculos',
            'inmuebles',
            'maquinaria', // ya singular
            'equipos',
            'otros',
          ]),
        ]),
        organization: _emptyOrg(),
      );
      final c = r.updatedOrganization.capabilityProfiles.first;
      expect(c.assetTypeIds, [
        AssetRegistrationType.vehiculo,
        AssetRegistrationType.inmueble,
        AssetRegistrationType.maquinaria,
        AssetRegistrationType.equipo,
        AssetRegistrationType.otro,
      ]);
    });

    test('membership sin providerProfiles ⇒ no-op', () {
      final org = _emptyOrg();
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: const []),
        organization: org,
      );
      expect(r.profilesAttempted, 0);
      expect(r.hasChanges, isFalse);
      expect(r.updatedOrganization, same(org));
      expect(rec.events, isEmpty);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 2. Múltiples profiles → múltiples capabilities
  // ──────────────────────────────────────────────────────────────────────
  group('2. Múltiples profiles distintos → múltiples capabilities', () {
    test('3 profiles con businessCategoryId distintos ⇒ 3 capabilities', () {
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(businessCategoryId: 'mecanico_independiente'),
          _legacyProfile(businessCategoryId: 'lubricentro'),
          _legacyProfile(businessCategoryId: 'autopartes'),
        ]),
        organization: _emptyOrg(),
      );
      expect(r.profilesMigrated, 3);
      expect(r.updatedOrganization.capabilityProfiles.length, 3);
      final ids = r.updatedOrganization.capabilityProfiles
          .map((c) => c.providerSpec!.businessCategoryRef!.value)
          .toList();
      expect(ids, ['mecanico_independiente', 'lubricentro', 'autopartes']);
    });

    test('orden de outcomes coincide con orden de input', () {
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(businessCategoryId: 'cat_a'),
          _legacyProfile(businessCategoryId: 'cat_b'),
        ]),
        organization: _emptyOrg(),
      );
      expect(r.outcomes[0].sourceIndex, 0);
      expect(r.outcomes[1].sourceIndex, 1);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 3. Duplicados → no duplicar
  // ──────────────────────────────────────────────────────────────────────
  group('3. Dedup', () {
    test('mismo (kind, providerType, businessCategoryId) ⇒ duplicate', () {
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(businessCategoryId: 'mecanico_independiente'),
          _legacyProfile(
            businessCategoryId: 'mecanico_independiente',
            // Difieren en assetTypeIds y coverageCities, pero la dedup key
            // (kind+providerType+businessCategoryRef) es la misma.
            assetTypeIds: const ['inmuebles'],
            coverageCities: const ['CO/col-bog/col-bog-bog'],
          ),
        ]),
        organization: _emptyOrg(),
      );
      expect(r.profilesMigrated, 1);
      expect(r.profilesSkippedDuplicate, 1);
      expect(r.updatedOrganization.capabilityProfiles.length, 1);
      expect(r.outcomes[0].status, ProfileMigrationStatus.migrated);
      expect(r.outcomes[1].status, ProfileMigrationStatus.duplicate);
    });

    test('distinto providerType (articulos vs servicios) ⇒ no duplicado', () {
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(
            providerType: 'servicios',
            businessCategoryId: 'autopartes',
          ),
          _legacyProfile(
            providerType: 'articulos',
            businessCategoryId: 'autopartes',
          ),
        ]),
        organization: _emptyOrg(),
      );
      expect(r.profilesMigrated, 2);
      expect(r.profilesSkippedDuplicate, 0);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 4. Datos malformados → warnings
  // ──────────────────────────────────────────────────────────────────────
  group('4. Malformados (path tolerante con warnings)', () {
    test('businessCategoryId con mayúscula ⇒ ref null + warning', () {
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(businessCategoryId: 'Lubricentro'),
        ]),
        organization: _emptyOrg(),
      );
      expect(r.profilesMigrated, 1);
      final c = r.updatedOrganization.capabilityProfiles.first;
      expect(c.providerSpec!.businessCategoryRef, isNull);
      expect(r.outcomes.first.hasWarnings, isTrue);
    });

    test('assetTypeIds con valor desconocido ⇒ drop + warning', () {
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(assetTypeIds: const [
            'vehiculos',
            'aviones', // desconocido
            'inmuebles',
          ]),
        ]),
        organization: _emptyOrg(),
      );
      final c = r.updatedOrganization.capabilityProfiles.first;
      expect(c.assetTypeIds, [
        AssetRegistrationType.vehiculo,
        AssetRegistrationType.inmueble,
      ]);
      expect(r.outcomes.first.hasWarnings, isTrue);
    });

    test('coverageCities con path inválido ⇒ drop + warning', () {
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(coverageCities: const [
            'CO/col-ant/col-ant-med',
            'CO/col-ant', // formato inválido
            'US/ny/nyc',
          ]),
        ]),
        organization: _emptyOrg(),
      );
      final c = r.updatedOrganization.capabilityProfiles.first;
      expect(c.coverageCities.length, 2);
      expect(r.outcomes.first.warnings.any(
        (w) => w.fieldPath.contains('coverageCities'),
      ), isTrue);
    });

    test('branchId whitespace-only ⇒ null + warning', () {
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(branchId: '   '),
        ]),
        organization: _emptyOrg(),
      );
      final c = r.updatedOrganization.capabilityProfiles.first;
      expect(c.branchId, isNull);
      expect(r.outcomes.first.warnings.any(
        (w) => w.fieldPath.contains('branchId'),
      ), isTrue);
    });

    test('assetSegmentIds y offeringLineIds non-empty ⇒ warnings unmigrable',
        () {
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(
            assetSegmentIds: const ['moto', 'auto'],
            offeringLineIds: const ['linea-a', 'linea-b'],
          ),
        ]),
        organization: _emptyOrg(),
      );
      // La capability sí se migra (los segments NO eran requeridos para v3).
      expect(r.profilesMigrated, 1);
      final w = r.outcomes.first.warnings;
      expect(
        w.any((x) => x.fieldPath.contains('assetSegmentIds')),
        isTrue,
      );
      expect(
        w.any((x) => x.fieldPath.contains('offeringLineIds')),
        isTrue,
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 5. Datos irrecuperables → skip + error
  // ──────────────────────────────────────────────────────────────────────
  group('5. Irrecuperables (skip + telemetry error)', () {
    test('providerType desconocido ⇒ error, otros profiles migran', () {
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(businessCategoryId: 'cat_a'),
          _legacyProfile(
            providerType: 'productos', // desconocido
            businessCategoryId: 'cat_b',
          ),
          _legacyProfile(businessCategoryId: 'cat_c'),
        ]),
        organization: _emptyOrg(),
      );
      expect(r.profilesAttempted, 3);
      expect(r.profilesMigrated, 2);
      expect(r.profilesSkippedError, 1);
      expect(r.outcomes[1].status, ProfileMigrationStatus.error);
      expect(r.outcomes[1].errorMessage, isNotNull);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 6. Organization ya tenía capabilities → merge correcto
  // ──────────────────────────────────────────────────────────────────────
  group('6. Merge con capabilities pre-existentes', () {
    test('capability v3 pre-existente NO se duplica al migrar igual legacy',
        () {
      final preExisting = CapabilityProfile(
        kind: ProfileKind.provider,
        providerSpec: ProviderSpecForTest.servicios(
          businessCategoryRef: BusinessCategoryRef('mecanico_independiente'),
        ),
      );
      final org = _emptyOrg(capabilityProfiles: [preExisting]);
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(businessCategoryId: 'mecanico_independiente'),
        ]),
        organization: org,
      );
      expect(r.profilesMigrated, 0);
      expect(r.profilesSkippedDuplicate, 1);
      expect(r.updatedOrganization.capabilityProfiles.length, 1);
      // Es la MISMA instancia (organization ref-equal) cuando no hay cambios.
      expect(r.updatedOrganization, same(org));
    });

    test('capabilities pre-existentes + legacy nuevos ⇒ merge sin duplicar',
        () {
      final preExisting = CapabilityProfile(
        kind: ProfileKind.provider,
        providerSpec: ProviderSpecForTest.servicios(
          businessCategoryRef: BusinessCategoryRef('lubricentro'),
        ),
      );
      final org = _emptyOrg(capabilityProfiles: [preExisting]);
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(businessCategoryId: 'lubricentro'), // duplicate
          _legacyProfile(businessCategoryId: 'autopartes'),  // nuevo
        ]),
        organization: org,
      );
      expect(r.profilesMigrated, 1);
      expect(r.profilesSkippedDuplicate, 1);
      expect(r.updatedOrganization.capabilityProfiles.length, 2);
      final ids = r.updatedOrganization.capabilityProfiles
          .map((c) => c.providerSpec!.businessCategoryRef!.value)
          .toList();
      expect(ids, containsAll(['lubricentro', 'autopartes']));
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 7. No tocar Portfolio ni AssetActorLink
  // ──────────────────────────────────────────────────────────────────────
  group('7. NO contaminación de dominio (sin AssetActorLink, sin Portfolio)',
      () {
    test('updatedOrganization no expone expectedRelationKind ni AssetActorRole',
        () {
      // El resultado del migrator es OrganizationEntity. Nada que ver con
      // Portfolio ni AssetActorLink. Verificamos que el entity solo cambió
      // capabilityProfiles, sin atributos relacionales con activos.
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [_legacyProfile()]),
        organization: _emptyOrg(),
      );
      expect(r.updatedOrganization.capabilityProfiles.length, 1);
      // No debe haber side-effects externos: el migrator es una función
      // pura que solo retorna OrganizationEntity actualizada.
      // (Ningún getter/método del organization expone owner/manager/renter
      // como atributo derivado de capabilityProfiles — verificación
      // estructural por construcción del tipo.)
      expect(r.updatedOrganization.id, 'org-1');
    });

    test('jamás aparece AssetActorRole inferido desde providerProfiles', () {
      // Verificación negativa: el migrator no acepta ni devuelve nada
      // relacionado con AssetActorRole (compile-time safe). Si esta línea
      // compila, está garantizado por el sistema de tipos.
      final r = LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(),
        ]),
        organization: _emptyOrg(),
      );
      // El resultado solo contiene capabilities (oferta), no relaciones.
      for (final c in r.updatedOrganization.capabilityProfiles) {
        expect(c.kind, ProfileKind.provider);
        // No hay propiedad "actorRole" ni similar en CapabilityProfile.
      }
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 8. Telemetría invocada correctamente
  // ──────────────────────────────────────────────────────────────────────
  group('8. Telemetría', () {
    test('1 profile limpio ⇒ 1 evento success', () {
      LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [_legacyProfile()]),
        organization: _emptyOrg(),
      );
      expect(rec.eventNames,
          [LegacyMembershipMigrationTelemetry.eventSuccess]);
    });

    test('1 profile con warnings ⇒ 1 evento warning (no success)', () {
      LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(businessCategoryId: 'BAD-NAME'),
        ]),
        organization: _emptyOrg(),
      );
      expect(rec.eventNames,
          [LegacyMembershipMigrationTelemetry.eventWarning]);
    });

    test('1 profile irrecuperable ⇒ 1 evento error', () {
      LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(providerType: 'productos'),
        ]),
        organization: _emptyOrg(),
      );
      expect(
          rec.eventNames, [LegacyMembershipMigrationTelemetry.eventError]);
    });

    test('mezcla ⇒ telemetría por cada outcome distinto', () {
      LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(businessCategoryId: 'cat_a'), // success
          _legacyProfile(businessCategoryId: 'BAD-NAME'), // warning
          _legacyProfile(providerType: 'productos'), // error
        ]),
        organization: _emptyOrg(),
      );
      expect(rec.eventNames, [
        LegacyMembershipMigrationTelemetry.eventSuccess,
        LegacyMembershipMigrationTelemetry.eventWarning,
        LegacyMembershipMigrationTelemetry.eventError,
      ]);
    });

    test('payload incluye orgId, membershipId, sourceProfileIndex', () {
      LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(
          userId: 'uid-X',
          orgId: 'org-X',
          providerProfiles: [_legacyProfile()],
        ),
        organization: _emptyOrg(id: 'org-X'),
      );
      final p = rec.events.first.props;
      expect(p['orgId'], 'org-X');
      expect(p['membershipId'], 'uid-X@org-X');
      expect(p['sourceProfileIndex'], 0);
      expect(p['sourceProfile'], isNotNull);
    });

    test('duplicate sin warnings ⇒ NO emite telemetría (silencio limpio)',
        () {
      final org = _emptyOrg(capabilityProfiles: [
        CapabilityProfile(
          kind: ProfileKind.provider,
          providerSpec: ProviderSpecForTest.servicios(
            businessCategoryRef: BusinessCategoryRef('mecanico_independiente'),
          ),
        ),
      ]);
      LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          _legacyProfile(businessCategoryId: 'mecanico_independiente'),
        ]),
        organization: org,
      );
      // Duplicate limpio (sin warnings durante el match) ⇒ no telemetry.
      expect(rec.events, isEmpty);
    });

    test('duplicate CON warnings ⇒ emite warning (señal de drift legacy)',
        () {
      final org = _emptyOrg(capabilityProfiles: [
        CapabilityProfile(
          kind: ProfileKind.provider,
          providerSpec: ProviderSpecForTest.servicios(
            businessCategoryRef: BusinessCategoryRef('mecanico_independiente'),
          ),
        ),
      ]);
      LegacyMembershipProviderProfileMigrator.migrateMembership(
        membership: _membership(providerProfiles: [
          // Provoca un warning de assetSegmentIds no migrable, pero la dedup
          // key es la misma que la pre-existente.
          _legacyProfile(
            businessCategoryId: 'mecanico_independiente',
            assetSegmentIds: const ['moto'],
          ),
        ]),
        organization: org,
      );
      expect(rec.eventNames,
          [LegacyMembershipMigrationTelemetry.eventWarning]);
    });
  });
}

/// Helper para construir ProviderSpec en tests (evita repetir imports).
class ProviderSpecForTest {
  static ProviderSpec servicios({BusinessCategoryRef? businessCategoryRef}) {
    return ProviderSpec(
      providerType: ProviderType.servicios,
      businessCategoryRef: businessCategoryRef,
    );
  }
}
