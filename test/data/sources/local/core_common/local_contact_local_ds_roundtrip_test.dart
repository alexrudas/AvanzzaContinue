// ============================================================================
// test/data/sources/local/core_common/local_contact_local_ds_roundtrip_test.dart
// LOCAL CONTACT LOCAL DS — Test de regresión persistencia v2
// ============================================================================
// QUÉ HACE:
//   - Blinda la invariante "lo que entra al `upsert` sale intacto del
//     `getById`" para TODOS los campos del `LocalContactModel`, incluidos
//     los de perfil estructurado v2 (supplierType, categorías, geo,
//     addressLine, alt phone, website, coverage, coverageAllCountry).
//   - Cubre el bug reportado por el usuario: "llené todos los campos del
//     formulario y muchos no se visualizan después de guardar; al editar
//     aparecen sin datos". La raíz fue que `upsert` reconstruía el modelo
//     manualmente y omitía los campos v2. Este test falla sin la fix y
//     pasa con ella.
//
// POR QUÉ ESTE TEST ES NECESARIO:
//   - Dart no obliga a pasar todos los campos en un constructor con
//     parámetros nombrados con defaults; si alguien agrega un campo nuevo
//     al modelo sin incluirlo en `_copyForWrite`, se pierde silenciosamente.
//   - Este test lee + escribe la matriz completa de campos. Añadir un
//     campo al modelo debe obligar a actualizar este test, cerrando la
//     puerta a que el bug vuelva.
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import 'package:avanzza/data/models/core_common/local_contact_model.dart';
import 'package:avanzza/data/models/core_common/provider_branch_embedded.dart';
import 'package:avanzza/data/sources/local/core_common/local_contact_local_ds.dart';

import '../../../../helpers/isar_test_db_local_contact.dart';

void main() {
  late Isar isar;
  late LocalContactLocalDataSource ds;

  setUp(() async {
    isar = await openTestIsarForLocalContact();
    ds = LocalContactLocalDataSource(isar);
  });

  tearDown(() async {
    await closeTestIsar(isar);
  });

  group('LocalContactLocalDataSource.upsert — round-trip completo', () {
    test(
        'persiste y recupera TODOS los campos incluidos los v2 (regresión '
        'del bug "upsert descartaba supplierType/categorías/geo/cobertura")',
        () async {
      final now = DateTime.utc(2026, 4, 21, 12);
      final entrante = LocalContactModel(
        id: 'prov-1',
        workspaceId: 'ws-1',
        displayName: 'Lubricantes del Caribe',
        createdAt: now,
        updatedAt: now,
        organizationId: 'org-42',
        roleLabel: 'proveedor',
        primaryPhoneE164: '+573001112233',
        primaryEmail: 'ventas@lubricantes.co',
        docId: '900123456',
        notesPrivate: 'Mejor trato los lunes',
        tagsPrivate: const ['preferido'],
        snapshotSourcePlatformActorId: 'pa-7',
        snapshotAdoptedAt: now,
        isDeleted: false,
        deletedAt: null,
        // v2 — estos eran los campos que el bug descartaba:
        supplierTypeWire: 'mixed',
        categories: const ['Repuestos', 'Lubricantes', 'Mantenimiento'],
        countryId: 'col',
        regionId: 'col-atl',
        cityId: 'col-atl-bar',
        addressLine: 'Cra 45 #23-15, local 3',
        secondaryPhoneE164: '+573004445566',
        website: 'lubricantes.co',
        coverageCityIds: const ['col-atl-bar', 'col-atl-soledad'],
        coverageAllCountry: false,
      );

      await ds.upsert(entrante);
      final leido = await ds.getById('prov-1');

      expect(leido, isNotNull);
      expect(leido!.id, 'prov-1');
      expect(leido.workspaceId, 'ws-1');
      expect(leido.displayName, 'Lubricantes del Caribe');
      expect(leido.organizationId, 'org-42');
      expect(leido.roleLabel, 'proveedor');
      expect(leido.primaryPhoneE164, '+573001112233');
      expect(leido.primaryEmail, 'ventas@lubricantes.co');
      expect(leido.docId, '900123456');
      expect(leido.notesPrivate, 'Mejor trato los lunes');
      expect(leido.tagsPrivate, ['preferido']);
      expect(leido.snapshotSourcePlatformActorId, 'pa-7');
      // Isar community devuelve DateTime en zona local aunque el stored sea UTC
      // — comparamos por instante real usando isSameMomentAs.
      expect(leido.snapshotAdoptedAt!.isAtSameMomentAs(now), isTrue);
      expect(leido.isDeleted, isFalse);
      expect(leido.deletedAt, isNull);

      // ── v2 — LOS QUE EL BUG PERDÍA ─────────────────────────────────────
      expect(leido.supplierTypeWire, 'mixed',
          reason: 'supplierTypeWire debe sobrevivir el round-trip');
      expect(leido.categories,
          ['Repuestos', 'Lubricantes', 'Mantenimiento'],
          reason: 'categories debe sobrevivir el round-trip');
      expect(leido.countryId, 'col');
      expect(leido.regionId, 'col-atl');
      expect(leido.cityId, 'col-atl-bar');
      expect(leido.addressLine, 'Cra 45 #23-15, local 3');
      expect(leido.secondaryPhoneE164, '+573004445566');
      expect(leido.website, 'lubricantes.co');
      expect(leido.coverageCityIds, ['col-atl-bar', 'col-atl-soledad']);
      expect(leido.coverageAllCountry, isFalse);
    });

    test(
        'update de un registro existente preserva createdAt del original y '
        'sobrescribe el resto (incluyendo campos v2)', () async {
      final t0 = DateTime.utc(2026, 4, 1);
      final t1 = DateTime.utc(2026, 4, 21);

      await ds.upsert(LocalContactModel(
        id: 'prov-2',
        workspaceId: 'ws-1',
        displayName: 'Proveedor v1',
        createdAt: t0,
        updatedAt: t0,
        supplierTypeWire: 'products',
        categories: const ['Repuestos'],
        countryId: 'col',
        coverageAllCountry: false,
      ));

      // Update: cambia el tipo a "services", cambia categorías, activa
      // cobertura nacional, añade geo, etc.
      await ds.upsert(LocalContactModel(
        id: 'prov-2',
        workspaceId: 'ws-1',
        displayName: 'Proveedor v2',
        createdAt: t1, // debe IGNORARSE: el DS preserva createdAt original.
        updatedAt: t1,
        supplierTypeWire: 'services',
        categories: const ['Mantenimiento', 'Reparaciones'],
        countryId: 'col',
        regionId: 'col-cun',
        cityId: 'col-cun-bog',
        addressLine: 'Cl 100 #15-20',
        secondaryPhoneE164: '+573007778899',
        website: 'proveedor-v2.com',
        coverageCityIds: const <String>[],
        coverageAllCountry: true,
      ));

      final leido = await ds.getById('prov-2');
      expect(leido, isNotNull);
      expect(leido!.displayName, 'Proveedor v2');
      expect(leido.createdAt.isAtSameMomentAs(t0), isTrue,
          reason: 'createdAt debe ser inmutable tras el primer upsert');
      expect(leido.updatedAt.isAtSameMomentAs(t1), isTrue);
      expect(leido.supplierTypeWire, 'services');
      expect(leido.categories, ['Mantenimiento', 'Reparaciones']);
      expect(leido.countryId, 'col');
      expect(leido.regionId, 'col-cun');
      expect(leido.cityId, 'col-cun-bog');
      expect(leido.addressLine, 'Cl 100 #15-20');
      expect(leido.secondaryPhoneE164, '+573007778899');
      expect(leido.website, 'proveedor-v2.com');
      expect(leido.coverageCityIds, isEmpty);
      expect(leido.coverageAllCountry, isTrue);
    });

    test(
        'softDeleteById preserva TODOS los campos v2 y solo marca isDeleted '
        '+ deletedAt + updatedAt', () async {
      final t0 = DateTime.utc(2026, 4, 1);
      final tDelete = DateTime.utc(2026, 4, 21);

      await ds.upsert(LocalContactModel(
        id: 'prov-3',
        workspaceId: 'ws-1',
        displayName: 'Proveedor que se borra',
        createdAt: t0,
        updatedAt: t0,
        supplierTypeWire: 'products',
        categories: const ['Repuestos', 'Lubricantes'],
        countryId: 'col',
        regionId: 'col-val',
        cityId: 'col-val-cali',
        addressLine: 'Av 6N #25-10',
        secondaryPhoneE164: '+573001234567',
        website: 'borrado.com',
        coverageCityIds: const ['col-val-cali'],
        coverageAllCountry: false,
      ));

      await ds.softDeleteById('prov-3', tDelete);

      final leido = await ds.getById('prov-3');
      expect(leido, isNotNull);
      expect(leido!.isDeleted, isTrue);
      expect(leido.deletedAt!.isAtSameMomentAs(tDelete), isTrue);
      expect(leido.updatedAt.isAtSameMomentAs(tDelete), isTrue);
      // TODOS los campos de perfil deben sobrevivir el soft-delete
      // (el usuario puede hacer "Deshacer" y recuperar el perfil intacto).
      expect(leido.supplierTypeWire, 'products');
      expect(leido.categories, ['Repuestos', 'Lubricantes']);
      expect(leido.countryId, 'col');
      expect(leido.regionId, 'col-val');
      expect(leido.cityId, 'col-val-cali');
      expect(leido.addressLine, 'Av 6N #25-10');
      expect(leido.secondaryPhoneE164, '+573001234567');
      expect(leido.website, 'borrado.com');
      expect(leido.coverageCityIds, ['col-val-cali']);
      expect(leido.coverageAllCountry, isFalse);
    });

    test(
        'persiste y recupera lista de sedes adicionales (embedded) — '
        'regresión: al agregar campos nuevos, _copyForWrite del DS DEBE '
        'incluirlos o se pierden al hacer upsert', () async {
      final now = DateTime.utc(2026, 4, 22, 10);
      final branches = [
        ProviderBranchEmbedded(
          id: 'br-1',
          label: 'Sede Norte',
          countryId: 'col',
          regionId: 'col-ant',
          cityId: 'col-ant-med',
          addressLine: 'Cl 10 Sur #50-100',
          phoneE164: '+573009990001',
          contactName: 'Ana — jefe de bodega',
          notes: 'Atención 7am-5pm',
        ),
        ProviderBranchEmbedded(
          id: 'br-2',
          label: 'Punto Chapinero',
          countryId: 'col',
          regionId: 'col-cun',
          cityId: 'col-cun-bog',
          addressLine: 'Cra 13 #55-30',
          phoneE164: '+573001112222',
        ),
      ];

      await ds.upsert(LocalContactModel(
        id: 'prov-branches',
        workspaceId: 'ws-1',
        displayName: 'Proveedor con múltiples sedes',
        createdAt: now,
        updatedAt: now,
        supplierTypeWire: 'mixed',
        categories: const ['Repuestos', 'Mantenimiento'],
        countryId: 'col',
        regionId: 'col-atl',
        cityId: 'col-atl-bar',
        additionalBranches: branches,
      ));

      final leido = await ds.getById('prov-branches');
      expect(leido, isNotNull);
      expect(leido!.additionalBranches.length, 2);

      final b1 = leido.additionalBranches.firstWhere((b) => b.id == 'br-1');
      expect(b1.label, 'Sede Norte');
      expect(b1.cityId, 'col-ant-med');
      expect(b1.addressLine, 'Cl 10 Sur #50-100');
      expect(b1.phoneE164, '+573009990001');
      expect(b1.contactName, 'Ana — jefe de bodega');
      expect(b1.notes, 'Atención 7am-5pm');

      final b2 = leido.additionalBranches.firstWhere((b) => b.id == 'br-2');
      expect(b2.label, 'Punto Chapinero');
      expect(b2.cityId, 'col-cun-bog');
      expect(b2.phoneE164, '+573001112222');
      expect(b2.contactName, isNull);

      // Update: el proveedor pierde una sede y añade otra nueva.
      await ds.upsert(LocalContactModel(
        id: 'prov-branches',
        workspaceId: 'ws-1',
        displayName: 'Proveedor con múltiples sedes',
        createdAt: now,
        updatedAt: now,
        supplierTypeWire: 'mixed',
        categories: const ['Repuestos', 'Mantenimiento'],
        countryId: 'col',
        regionId: 'col-atl',
        cityId: 'col-atl-bar',
        additionalBranches: [
          ProviderBranchEmbedded(
            id: 'br-1',
            label: 'Sede Norte (renombrada)',
            countryId: 'col',
            regionId: 'col-ant',
            cityId: 'col-ant-med',
            phoneE164: '+573009990001',
          ),
          ProviderBranchEmbedded(
            id: 'br-3',
            label: 'Nueva sede Cali',
            countryId: 'col',
            regionId: 'col-val',
            cityId: 'col-val-cali',
          ),
        ],
      ));

      final despues = await ds.getById('prov-branches');
      expect(despues!.additionalBranches.length, 2);
      expect(
          despues.additionalBranches.map((b) => b.id).toSet(), {'br-1', 'br-3'});
      final b1b = despues.additionalBranches.firstWhere((b) => b.id == 'br-1');
      expect(b1b.label, 'Sede Norte (renombrada)');
    });
  });
}
