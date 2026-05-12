// ============================================================================
// test/presentation/controllers/network/v2/mi_red_controller_supplier_map_test.dart
// CONTROLLER WIRING — Etapa 4 fix Mi Red bucketizer
// ============================================================================
// Cubre los 3 tests obligatorios:
//   12. supplierByRef incluye `local:contact:{id}`.
//   13. supplierByRef incluye `platform:{linkedProviderProfileId}`.
//   14. cambio de workspace reconstruye mapa sin contaminar datos.
//
// Usa Isar in-memory real para el DS local de contacts y fakes de los
// repositorios HTTP (devuelven envelopes vacíos) — el objetivo es validar
// que el controller cruza correctamente actor.ref → SupplierType desde el
// cache local, no la red.
// ============================================================================

import 'package:avanzza/data/models/core_common/local_contact_model.dart';
import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_category.dart';
import 'package:avanzza/data/models/network/network_envelope.dart';
import 'package:avanzza/data/models/network/team_member_summary_dto.dart';
import 'package:avanzza/data/repositories/network/refresh_network_outcome.dart';
import 'package:avanzza/data/sources/local/core_common/local_contact_local_ds.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource.dart';
import 'package:avanzza/data/sources/local/network/team_local_datasource.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/supplier_type.dart';
import 'package:avanzza/domain/repositories/network/network_repository.dart';
import 'package:avanzza/domain/repositories/network/team_repository.dart';
import 'package:avanzza/presentation/controllers/network/v2/mi_red_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../../../../helpers/isar_test_db_local_contact.dart';

class _EmptyNetworkRepo implements NetworkRepository {
  @override
  Future<NetworkPageEnvelope<NetworkActorSummaryDto>> fetchPage({
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    String? cursor,
    int? limit,
  }) async {
    return NetworkPageEnvelope<NetworkActorSummaryDto>(
      schemaVersion: 2,
      items: const [],
      nextCursor: null,
      serverTime: DateTime.utc(2026, 5, 11, 10),
    );
  }

  @override
  Future<NetworkCategoriesSummaryEnvelope> fetchSummary() {
    throw UnimplementedError();
  }

  // Cache-first API (Fase 4 Paso 3) — no usada en este suite que solo
  // verifica el supplierByRef map. Stubs vacíos.
  @override
  Stream<NetworkSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) =>
      const Stream.empty();

  @override
  Future<RefreshNetworkOutcome> refreshSection({
    required String workspaceId,
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    int? limit,
  }) async =>
      RefreshNetworkOutcome.success;
}

class _EmptyTeamRepo implements TeamRepository {
  @override
  Future<NetworkPageEnvelope<TeamMemberSummaryDto>> fetchPage({
    String? cursor,
    int? limit,
  }) async {
    return NetworkPageEnvelope<TeamMemberSummaryDto>(
      schemaVersion: 1,
      items: const [],
      nextCursor: null,
      serverTime: DateTime.utc(2026, 5, 11, 10),
    );
  }

  @override
  Future<TeamSummaryEnvelope> fetchSummary() {
    throw UnimplementedError();
  }

  @override
  Stream<TeamSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) =>
      const Stream.empty();

  @override
  Future<RefreshNetworkOutcome> refreshSection({
    required String workspaceId,
    int? limit,
  }) async =>
      RefreshNetworkOutcome.success;
}

LocalContactModel _contact({
  required String id,
  required String workspaceId,
  String displayName = 'Contact',
  SupplierType? supplier,
  String? linkedProviderProfileId,
}) {
  final now = DateTime.utc(2026, 5, 11, 10);
  return LocalContactModel(
    id: id,
    workspaceId: workspaceId,
    displayName: displayName,
    createdAt: now,
    updatedAt: now,
    supplierTypeWire: supplier?.wireName,
    linkedProviderProfileId: linkedProviderProfileId,
  );
}

/// Cede el event loop N veces para que microtasks + native events de Isar
/// se procesen. Determinista: número fijo de ticks, no depende de wallclock.
///
/// Usar SOLO como degradación cuando no hay condición observable (caso de
/// "esperamos que NADA pase" tras un no-op). Para asserts de estado nuevo
/// preferir `_waitFor(condition)` que termina antes Y falla con mensaje
/// claro si nunca se cumple.
Future<void> _pumpEventQueue([int times = 20]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

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

  // ──────────────────────────────────────────────────────────────────────────
  // 12. supplierByRef incluye local:contact:{id}
  // ──────────────────────────────────────────────────────────────────────────
  test(
      '12. tras loadInitial, supplierByRef contiene `local:contact:{id}` '
      'con el SupplierType del contact', () async {
    await ds.upsert(_contact(
      id: 'contact-A',
      workspaceId: 'ws-1',
      supplier: SupplierType.services,
    ));
    await ds.upsert(_contact(
      id: 'contact-B',
      workspaceId: 'ws-1',
      supplier: SupplierType.products,
    ));

    final controller = MiRedController(
      networkRepository: _EmptyNetworkRepo(),
      teamRepository: _EmptyTeamRepo(),
      contactsLocalDataSource: ds,
      workspaceId: 'ws-1',
      debounceDuration: Duration.zero,
    );
    await controller.loadInitial();
    await _pumpEventQueue();

    final map = controller.supplierByRefRx.value;
    expect(map['local:contact:contact-A'], SupplierType.services);
    expect(map['local:contact:contact-B'], SupplierType.products);
  });

  test(
      '12b. contact con supplierType=null NO aparece en el mapa '
      '(no clave huérfana)', () async {
    await ds.upsert(_contact(
      id: 'contact-sin-tipo',
      workspaceId: 'ws-1',
      supplier: null,
    ));

    final controller = MiRedController(
      networkRepository: _EmptyNetworkRepo(),
      teamRepository: _EmptyTeamRepo(),
      contactsLocalDataSource: ds,
      workspaceId: 'ws-1',
      debounceDuration: Duration.zero,
    );
    await controller.loadInitial();
    await _pumpEventQueue();

    expect(controller.supplierByRefRx.value['local:contact:contact-sin-tipo'],
        isNull);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 13. supplierByRef incluye platform:{linkedProviderProfileId}
  // ──────────────────────────────────────────────────────────────────────────
  test(
      '13. contact con linkedProviderProfileId emite AMBAS claves: '
      'local:contact:{id} y platform:{linkedProviderProfileId}', () async {
    await ds.upsert(_contact(
      id: 'contact-with-link',
      workspaceId: 'ws-1',
      supplier: SupplierType.services,
      linkedProviderProfileId: 'prov-canonical-123',
    ));

    final controller = MiRedController(
      networkRepository: _EmptyNetworkRepo(),
      teamRepository: _EmptyTeamRepo(),
      contactsLocalDataSource: ds,
      workspaceId: 'ws-1',
      debounceDuration: Duration.zero,
    );
    await controller.loadInitial();
    await _pumpEventQueue();

    final map = controller.supplierByRefRx.value;
    expect(map['local:contact:contact-with-link'], SupplierType.services);
    expect(map['platform:prov-canonical-123'], SupplierType.services,
        reason: 'cruce platform: → local supplierType es la clave del fix');
    expect(map.length, 2);
  });

  test('13b. contact SIN linkedProviderProfileId NO emite clave platform:',
      () async {
    await ds.upsert(_contact(
      id: 'contact-no-link',
      workspaceId: 'ws-1',
      supplier: SupplierType.products,
      linkedProviderProfileId: null,
    ));

    final controller = MiRedController(
      networkRepository: _EmptyNetworkRepo(),
      teamRepository: _EmptyTeamRepo(),
      contactsLocalDataSource: ds,
      workspaceId: 'ws-1',
      debounceDuration: Duration.zero,
    );
    await controller.loadInitial();
    await _pumpEventQueue();

    final map = controller.supplierByRefRx.value;
    expect(map['local:contact:contact-no-link'], SupplierType.products);
    expect(map.entries.where((e) => e.key.startsWith('platform:')), isEmpty);
  });

  test(
      '13c. linkedProviderProfileId vacío (string "") NO emite clave platform:',
      () async {
    await ds.upsert(_contact(
      id: 'contact-empty-link',
      workspaceId: 'ws-1',
      supplier: SupplierType.products,
      linkedProviderProfileId: '',
    ));

    final controller = MiRedController(
      networkRepository: _EmptyNetworkRepo(),
      teamRepository: _EmptyTeamRepo(),
      contactsLocalDataSource: ds,
      workspaceId: 'ws-1',
      debounceDuration: Duration.zero,
    );
    await controller.loadInitial();
    await _pumpEventQueue();

    final platformKeys = controller.supplierByRefRx.value.entries
        .where((e) => e.key.startsWith('platform:'));
    expect(platformKeys, isEmpty);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 14. cambio de workspace reconstruye mapa sin contaminar
  // ──────────────────────────────────────────────────────────────────────────
  test(
      '14. controller A para ws-1 ve solo contactos de ws-1; '
      'controller B para ws-2 ve solo contactos de ws-2 (sin cruce)',
      () async {
    await ds.upsert(_contact(
      id: 'contact-en-ws1',
      workspaceId: 'ws-1',
      supplier: SupplierType.services,
      linkedProviderProfileId: 'prov-ws1',
    ));
    await ds.upsert(_contact(
      id: 'contact-en-ws2',
      workspaceId: 'ws-2',
      supplier: SupplierType.products,
      linkedProviderProfileId: 'prov-ws2',
    ));

    final ctrlA = MiRedController(
      networkRepository: _EmptyNetworkRepo(),
      teamRepository: _EmptyTeamRepo(),
      contactsLocalDataSource: ds,
      workspaceId: 'ws-1',
      debounceDuration: Duration.zero,
    );
    await ctrlA.loadInitial();
    await _pumpEventQueue();
    final mapA = ctrlA.supplierByRefRx.value;
    expect(mapA['local:contact:contact-en-ws1'], SupplierType.services);
    expect(mapA['platform:prov-ws1'], SupplierType.services);
    expect(mapA['local:contact:contact-en-ws2'], isNull,
        reason: 'ws-1 NO debe ver contactos de ws-2');
    expect(mapA['platform:prov-ws2'], isNull,
        reason: 'ws-1 NO debe ver platform refs de ws-2');

    final ctrlB = MiRedController(
      networkRepository: _EmptyNetworkRepo(),
      teamRepository: _EmptyTeamRepo(),
      contactsLocalDataSource: ds,
      workspaceId: 'ws-2',
      debounceDuration: Duration.zero,
    );
    await ctrlB.loadInitial();
    await _pumpEventQueue();
    final mapB = ctrlB.supplierByRefRx.value;
    expect(mapB['local:contact:contact-en-ws2'], SupplierType.products);
    expect(mapB['platform:prov-ws2'], SupplierType.products);
    expect(mapB['local:contact:contact-en-ws1'], isNull);
    expect(mapB['platform:prov-ws1'], isNull);
  });

  test(
      '14b. reload del mismo controller tras agregar nuevo contact '
      'incluye el nuevo en el mapa', () async {
    await ds.upsert(_contact(
      id: 'contact-inicial',
      workspaceId: 'ws-1',
      supplier: SupplierType.services,
    ));

    final controller = MiRedController(
      networkRepository: _EmptyNetworkRepo(),
      teamRepository: _EmptyTeamRepo(),
      contactsLocalDataSource: ds,
      workspaceId: 'ws-1',
      debounceDuration: Duration.zero,
    );
    await controller.loadInitial();
    // Esperar polling determinista — no sleep.
    while (controller.supplierByRefRx.value.isEmpty) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(controller.supplierByRefRx.value.length, 1);

    // Agregamos un nuevo contact y reloadeamos.
    await ds.upsert(_contact(
      id: 'contact-nuevo',
      workspaceId: 'ws-1',
      supplier: SupplierType.products,
    ));
    await controller.loadInitial();
    // Polling determinista sobre la condición lógica esperada.
    final sw = Stopwatch()..start();
    while (controller.supplierByRefRx.value.length < 2 &&
        sw.elapsed < const Duration(seconds: 2)) {
      await Future<void>.delayed(const Duration(milliseconds: 1));
    }

    expect(controller.supplierByRefRx.value.length, 2);
    expect(controller.supplierByRefRx.value['local:contact:contact-nuevo'],
        SupplierType.products);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Degradación segura
  // ──────────────────────────────────────────────────────────────────────────
  test('sin DS local inyectado → mapa queda vacío (degradación segura)',
      () async {
    final controller = MiRedController(
      networkRepository: _EmptyNetworkRepo(),
      teamRepository: _EmptyTeamRepo(),
      // contactsLocalDataSource omitido a propósito.
      workspaceId: 'ws-1',
      debounceDuration: Duration.zero,
    );
    await controller.loadInitial();
    await _pumpEventQueue();
    expect(controller.supplierByRefRx.value, isEmpty);
  });

  test('workspaceId null → mapa queda vacío (no se mezclan workspaces)',
      () async {
    await ds.upsert(_contact(
      id: 'contact-X',
      workspaceId: 'ws-1',
      supplier: SupplierType.services,
    ));

    final controller = MiRedController(
      networkRepository: _EmptyNetworkRepo(),
      teamRepository: _EmptyTeamRepo(),
      contactsLocalDataSource: ds,
      workspaceId: null, // explícitamente null
      debounceDuration: Duration.zero,
    );
    await controller.loadInitial();
    await _pumpEventQueue();
    expect(controller.supplierByRefRx.value, isEmpty);
  });

  test('contacts soft-deleted NO aparecen en el mapa', () async {
    await ds.upsert(_contact(
      id: 'contact-borrado',
      workspaceId: 'ws-1',
      supplier: SupplierType.services,
    ));
    await ds.softDeleteById('contact-borrado', DateTime.utc(2026, 5, 12));

    final controller = MiRedController(
      networkRepository: _EmptyNetworkRepo(),
      teamRepository: _EmptyTeamRepo(),
      contactsLocalDataSource: ds,
      workspaceId: 'ws-1',
      debounceDuration: Duration.zero,
    );
    await controller.loadInitial();
    await _pumpEventQueue();

    expect(controller.supplierByRefRx.value, isEmpty);
  });
}
