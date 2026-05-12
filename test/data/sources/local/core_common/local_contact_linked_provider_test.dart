// ============================================================================
// test/data/sources/local/core_common/local_contact_linked_provider_test.dart
// LINKED PROVIDER PROFILE — round-trip + lookup (etapa 1 fix bucketizer Mi Red)
// ============================================================================
// Cubre los 2 tests de persistencia exigidos:
//   10. LocalContactModel round-trip preserva linkedProviderProfileId.
//   11. findByLinkedProviderProfileId retorna el contacto correcto.
//
// Critico: olvidar `linkedProviderProfileId` en `_copyForWrite` o en los
// mappers Entity↔Model causa que el bucketizer NO pueda resolver actores
// `platform:<id>` ↔ contact local, retrocediendo al bug original.
// ============================================================================

import 'package:avanzza/data/models/core_common/local_contact_model.dart';
import 'package:avanzza/data/sources/local/core_common/local_contact_local_ds.dart';
import 'package:avanzza/domain/entities/core_common/local_contact_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

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

  group('LocalContactModel — round-trip de linkedProviderProfileId', () {
    test('10a. upsert preserva linkedProviderProfileId tras lectura', () async {
      final now = DateTime.utc(2026, 5, 11, 10);
      final entrante = LocalContactModel(
        id: 'contact-1',
        workspaceId: 'ws-1',
        displayName: 'Peña Motors',
        createdAt: now,
        updatedAt: now,
        supplierTypeWire: 'services',
        linkedProviderProfileId: 'prov-profile-abc-123',
      );

      await ds.upsert(entrante);
      final leido = await ds.getById('contact-1');

      expect(leido, isNotNull);
      expect(leido!.linkedProviderProfileId, 'prov-profile-abc-123',
          reason:
              'linkedProviderProfileId debe sobrevivir el round-trip Isar');
      // Sanity: otros campos siguen ahí.
      expect(leido.supplierTypeWire, 'services');
      expect(leido.displayName, 'Peña Motors');
    });

    test(
        '10b. soft-delete preserva linkedProviderProfileId (no se borra al '
        'archivar)', () async {
      final now = DateTime.utc(2026, 5, 11, 10);
      await ds.upsert(LocalContactModel(
        id: 'contact-2',
        workspaceId: 'ws-1',
        displayName: 'Niño Repuestos',
        createdAt: now,
        updatedAt: now,
        supplierTypeWire: 'products',
        linkedProviderProfileId: 'prov-zzz',
      ));

      await ds.softDeleteById('contact-2', DateTime.utc(2026, 5, 12));
      final leido = await ds.getById('contact-2');
      expect(leido, isNotNull);
      expect(leido!.isDeleted, isTrue);
      expect(leido.linkedProviderProfileId, 'prov-zzz',
          reason: 'soft-delete no debe borrar el link al provider profile');
    });

    test('10c. Entity → Model → Entity preserva linkedProviderProfileId',
        () async {
      final now = DateTime.utc(2026, 5, 11, 10);
      const linkId = 'prov-xyz-777';
      final entityIn = LocalContactEntity(
        id: 'contact-3',
        workspaceId: 'ws-1',
        displayName: 'Auto Korea',
        createdAt: now,
        updatedAt: now,
        linkedProviderProfileId: linkId,
      );

      final model = LocalContactModel.fromEntity(entityIn);
      expect(model.linkedProviderProfileId, linkId);

      await ds.upsert(model);
      final leido = await ds.getById('contact-3');
      final entityOut = leido!.toEntity();
      expect(entityOut.linkedProviderProfileId, linkId,
          reason:
              'el round-trip Entity → Model → Isar → Model → Entity debe '
              'preservar el link');
    });

    test(
        '10d. update sobre contacto previo sin link asigna linkedProviderProfileId',
        () async {
      final now = DateTime.utc(2026, 5, 11, 10);
      // Primer upsert: sin link (registro previo a provision).
      await ds.upsert(LocalContactModel(
        id: 'contact-4',
        workspaceId: 'ws-1',
        displayName: 'Service Provider',
        createdAt: now,
        updatedAt: now,
        supplierTypeWire: 'services',
      ));
      final inicial = await ds.getById('contact-4');
      expect(inicial!.linkedProviderProfileId, isNull);

      // Segundo upsert: tras provision exitoso, el link aparece.
      await ds.upsert(LocalContactModel(
        id: 'contact-4',
        workspaceId: 'ws-1',
        displayName: 'Service Provider',
        createdAt: now,
        updatedAt: DateTime.utc(2026, 5, 12),
        supplierTypeWire: 'services',
        linkedProviderProfileId: 'prov-just-provisioned',
      ));
      final tras = await ds.getById('contact-4');
      expect(tras!.linkedProviderProfileId, 'prov-just-provisioned');
    });
  });

  group('findByLinkedProviderProfileId — lookup', () {
    test('11a. devuelve el contacto correcto cuando existe', () async {
      final now = DateTime.utc(2026, 5, 11);
      await ds.upsert(LocalContactModel(
        id: 'contact-A',
        workspaceId: 'ws-1',
        displayName: 'A',
        createdAt: now,
        updatedAt: now,
        linkedProviderProfileId: 'prov-A',
      ));
      await ds.upsert(LocalContactModel(
        id: 'contact-B',
        workspaceId: 'ws-1',
        displayName: 'B',
        createdAt: now,
        updatedAt: now,
        linkedProviderProfileId: 'prov-B',
      ));

      final found = await ds.findByLinkedProviderProfileId('ws-1', 'prov-B');
      expect(found, isNotNull);
      expect(found!.id, 'contact-B');
      expect(found.linkedProviderProfileId, 'prov-B');
    });

    test('11b. devuelve null cuando no hay match', () async {
      final now = DateTime.utc(2026, 5, 11);
      await ds.upsert(LocalContactModel(
        id: 'contact-X',
        workspaceId: 'ws-1',
        displayName: 'X',
        createdAt: now,
        updatedAt: now,
        linkedProviderProfileId: 'prov-X',
      ));

      final found =
          await ds.findByLinkedProviderProfileId('ws-1', 'prov-NO-EXISTE');
      expect(found, isNull);
    });

    test('11c. aislamiento por workspace — no cruza datos entre orgs',
        () async {
      final now = DateTime.utc(2026, 5, 11);
      await ds.upsert(LocalContactModel(
        id: 'contact-en-ws1',
        workspaceId: 'ws-1',
        displayName: 'X',
        createdAt: now,
        updatedAt: now,
        linkedProviderProfileId: 'prov-shared',
      ));
      // El backend puede asignar el mismo providerProfileId teóricamente
      // a otro contact en otro workspace (escenario edge). El lookup
      // debe respetar workspace boundary.
      await ds.upsert(LocalContactModel(
        id: 'contact-en-ws2',
        workspaceId: 'ws-2',
        displayName: 'X-bis',
        createdAt: now,
        updatedAt: now,
        linkedProviderProfileId: 'prov-shared',
      ));

      final inWs1 =
          await ds.findByLinkedProviderProfileId('ws-1', 'prov-shared');
      final inWs2 =
          await ds.findByLinkedProviderProfileId('ws-2', 'prov-shared');

      expect(inWs1!.id, 'contact-en-ws1');
      expect(inWs2!.id, 'contact-en-ws2');
    });

    test('11d. ignora soft-deleted', () async {
      final now = DateTime.utc(2026, 5, 11);
      await ds.upsert(LocalContactModel(
        id: 'contact-borrado',
        workspaceId: 'ws-1',
        displayName: 'Borrado',
        createdAt: now,
        updatedAt: now,
        linkedProviderProfileId: 'prov-deleted',
      ));
      await ds.softDeleteById('contact-borrado', DateTime.utc(2026, 5, 12));

      final found =
          await ds.findByLinkedProviderProfileId('ws-1', 'prov-deleted');
      expect(found, isNull,
          reason: 'contactos soft-deleted no deben aparecer en lookup operativo');
    });
  });
}
