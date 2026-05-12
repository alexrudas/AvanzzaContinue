// ============================================================================
// test/presentation/controllers/admin/network/network_operational_controller_test.dart
// NetworkOperationalController v2 — ADR actor-canon §10 + §11
// ============================================================================
// Cubre:
//   - Carga inicial exitosa desde AssetActorLinkRepository + libreta.
//   - Lista vacía → actors.clear(), isLoading=false.
//   - orgId vacío → error, no fetch.
//   - Error del repo → error state, actors.clear().
//   - Filtro por rol.
//   - Búsqueda por displayName.
//   - Relationship state se hidrata cuando hay local.
//   - reload() re-ejecuta la carga.
// ============================================================================

import 'dart:async';

import 'package:avanzza/domain/entities/core_common/asset_actor_link_entity.dart';
import 'package:avanzza/domain/entities/core_common/local_contact_entity.dart';
import 'package:avanzza/domain/entities/core_common/local_organization_entity.dart';
import 'package:avanzza/domain/entities/core_common/operational_relationship_entity.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/actor_ref_kind_value.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/asset_class.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_suspension_reason.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:avanzza/domain/repositories/core_common/asset_actor_link_repository.dart';
import 'package:avanzza/domain/repositories/core_common/local_contact_repository.dart';
import 'package:avanzza/domain/repositories/core_common/local_organization_repository.dart';
import 'package:avanzza/domain/repositories/core_common/network_relationship_repository.dart';
import 'package:avanzza/presentation/controllers/admin/network/network_operational_controller.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime.utc(2026, 4, 15);

// ─── Fakes ──────────────────────────────────────────────────────────────────

class _FakeLinks implements AssetActorLinkRepository {
  List<AssetActorLinkEntity> items = [];
  String? nextCursor;
  Object? willThrow;

  @override
  Future<AssetActorLinkPage> list({
    String? assetId,
    AssetActorRole? role,
    ActorRefKindValue? actorRefKind,
    String? platformActorId,
    TargetLocalKind? localKind,
    String? localId,
    AssetActorLinkStatusQuery? status,
    String? cursor,
    int? limit,
  }) async {
    final err = willThrow;
    if (err != null) throw err;
    return AssetActorLinkPage(items: items, nextCursor: nextCursor);
  }

  @override
  Future<AssetActorLinkEntity> findById(String id) =>
      throw UnimplementedError();

  @override
  Future<AssetActorLinkEntity> create({
    required String assetId,
    String? assetTypeId,
    AssetClass? assetClass,
    required AssetActorRole role,
    required ActorRefKindValue actorRefKind,
    String? platformActorId,
    TargetLocalKind? localKind,
    String? localId,
  }) =>
      throw UnimplementedError();
}

/// Fake con semántica BehaviorSubject-like: cada nuevo suscriptor recibe
/// inmediatamente el estado actual antes de los cambios subsiguientes.
/// Necesario porque el controller usa `stream.first` y un broadcast puro
/// pierde las emisiones previas a la suscripción.
class _FakeContacts implements LocalContactRepository {
  List<LocalContactEntity> _current = const [];
  final _ctrl = StreamController<List<LocalContactEntity>>.broadcast();

  void emit(List<LocalContactEntity> list) {
    _current = list;
    _ctrl.add(list);
  }

  @override
  Stream<List<LocalContactEntity>> watchByWorkspace(String workspaceId) async* {
    yield _current;
    yield* _ctrl.stream;
  }

  Future<void> dispose() => _ctrl.close();

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('LocalContactRepository.${invocation.memberName}');
}

class _FakeOrgs implements LocalOrganizationRepository {
  List<LocalOrganizationEntity> _current = const [];
  final _ctrl = StreamController<List<LocalOrganizationEntity>>.broadcast();

  void emit(List<LocalOrganizationEntity> list) {
    _current = list;
    _ctrl.add(list);
  }

  @override
  Stream<List<LocalOrganizationEntity>> watchByWorkspace(String workspaceId) async* {
    yield _current;
    yield* _ctrl.stream;
  }

  Future<void> dispose() => _ctrl.close();

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(
          'LocalOrganizationRepository.${invocation.memberName}');
}

class _FakeRelationships implements NetworkRelationshipRepository {
  final Map<String, OperationalRelationshipEntity> byLocalKey = {};

  @override
  Future<OperationalRelationshipPage> list({
    RelationshipState? state,
    TargetLocalKind? localKind,
    String? localId,
    String? cursor,
    int? limit,
  }) async {
    final key = (localKind != null && localId != null)
        ? '${localKind.wireName}|$localId'
        : null;
    final rel = key != null ? byLocalKey[key] : null;
    return OperationalRelationshipPage(
      items: rel != null ? [rel] : const [],
      nextCursor: null,
    );
  }

  @override
  Future<OperationalRelationshipEntity> findById(String id) =>
      throw UnimplementedError();

  @override
  Future<OperationalRelationshipEntity> suspend(
    String id,
    RelationshipSuspensionReason reason,
  ) =>
      throw UnimplementedError();

  @override
  Future<OperationalRelationshipEntity> reactivate(String id) =>
      throw UnimplementedError();

  @override
  Future<OperationalRelationshipEntity> close(
    String id, {
    RelationshipSuspensionReason? reason,
  }) =>
      throw UnimplementedError();
}

// ─── Fixtures ──────────────────────────────────────────────────────────────

AssetActorLinkEntity _link({
  String id = 'aal-1',
  AssetActorRole role = AssetActorRole.owner,
  TargetLocalKind? localKind = TargetLocalKind.contact,
  String? localId = 'ct-1',
  String? platformActorId,
  ActorRefKindValue actorRefKind = ActorRefKindValue.local,
}) {
  return AssetActorLinkEntity(
    id: id,
    orgId: 'org-1',
    assetId: 'asset-1',
    role: role,
    actorRefKind: actorRefKind,
    source: 'user_declared',
    verificationStatus: 'pending',
    status: 'active',
    startedAt: _now,
    createdAt: _now,
    updatedAt: _now,
    localKind: localKind,
    localId: localId,
    platformActorId: platformActorId,
  );
}

LocalContactEntity _contact({required String id, required String name}) =>
    LocalContactEntity(
      id: id,
      workspaceId: 'org-1',
      displayName: name,
      createdAt: _now,
      updatedAt: _now,
    );

OperationalRelationshipEntity _rel({
  required String localId,
  RelationshipState state = RelationshipState.vinculada,
}) {
  return OperationalRelationshipEntity(
    id: 'rel-$localId',
    sourceWorkspaceId: 'org-1',
    targetLocalKind: TargetLocalKind.contact,
    targetLocalId: localId,
    state: state,
    createdAt: _now,
    updatedAt: _now,
    stateUpdatedAt: _now,
    relationshipKind: RelationshipKind.generic,
    targetPlatformActorId: 'pa-linked',
    linkedAt: _now,
  );
}

// ─── Builder del controller ────────────────────────────────────────────────

NetworkOperationalController _make({
  required _FakeLinks links,
  required _FakeContacts contacts,
  required _FakeOrgs orgs,
  required _FakeRelationships relationships,
  String orgId = 'org-1',
}) {
  return NetworkOperationalController(
    assetActorLinks: links,
    localContacts: contacts,
    localOrganizations: orgs,
    networkRelationships: relationships,
    orgId: orgId,
  );
}

// ─── Tests ─────────────────────────────────────────────────────────────────

void main() {
  group('carga inicial', () {
    test('mapea links → NetworkActorVm hidratados con libreta', () async {
      final links = _FakeLinks()
        ..items = [
          _link(id: 'aal-1', localId: 'ct-1', role: AssetActorRole.owner),
          _link(id: 'aal-2', localId: 'ct-2', role: AssetActorRole.driver),
        ];
      final contacts = _FakeContacts();
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships();

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        relationships: rels,
      );

      // Emitir libreta ANTES de esperar la carga (el controller pide .first).
      contacts.emit([
        _contact(id: 'ct-1', name: 'Ana Pérez'),
        _contact(id: 'ct-2', name: 'Carlos Díaz'),
      ]);
      orgs.emit(const []);

      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ctl.isLoading.value, isFalse);
      expect(ctl.error.value, isNull);
      expect(ctl.actors, hasLength(2));
      expect(ctl.actors.map((a) => a.displayName),
          containsAll(['Ana Pérez', 'Carlos Díaz']));
      expect(ctl.rolesPresent,
          containsAll([AssetActorRole.owner, AssetActorRole.driver]));

      await contacts.dispose();
      await orgs.dispose();
    });

    test('lista vacía del backend → actors vacío, sin error', () async {
      final links = _FakeLinks()..items = [];
      final ctl = _make(
        links: links,
        contacts: _FakeContacts(),
        orgs: _FakeOrgs(),
        relationships: _FakeRelationships(),
      );

      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ctl.actors, isEmpty);
      expect(ctl.error.value, isNull);
      expect(ctl.isLoading.value, isFalse);
    });

    test('orgId vacío → error + sin fetch', () async {
      final links = _FakeLinks();
      final ctl = _make(
        links: links,
        contacts: _FakeContacts(),
        orgs: _FakeOrgs(),
        relationships: _FakeRelationships(),
        orgId: '',
      );

      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(ctl.actors, isEmpty);
      expect(ctl.error.value, contains('Organización'));
      expect(ctl.isLoading.value, isFalse);
    });

    test('repo lanza → error state', () async {
      final links = _FakeLinks()..willThrow = Exception('boom');
      final ctl = _make(
        links: links,
        contacts: _FakeContacts(),
        orgs: _FakeOrgs(),
        relationships: _FakeRelationships(),
      );

      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(ctl.error.value, isNotNull);
      expect(ctl.actors, isEmpty);
    });
  });

  group('filtro por rol y búsqueda', () {
    late _FakeLinks links;
    late _FakeContacts contacts;
    late _FakeOrgs orgs;
    late _FakeRelationships rels;
    late NetworkOperationalController ctl;

    setUp(() async {
      links = _FakeLinks()
        ..items = [
          _link(id: 'aal-o', localId: 'ct-o', role: AssetActorRole.owner),
          _link(id: 'aal-d', localId: 'ct-d', role: AssetActorRole.driver),
          _link(id: 'aal-w', localId: 'ct-w', role: AssetActorRole.workshop),
        ];
      contacts = _FakeContacts();
      orgs = _FakeOrgs();
      rels = _FakeRelationships();

      ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        relationships: rels,
      );

      contacts.emit([
        _contact(id: 'ct-o', name: 'Ana Propietaria'),
        _contact(id: 'ct-d', name: 'Diana Conductora'),
        _contact(id: 'ct-w', name: 'Taller Central'),
      ]);
      orgs.emit(const []);

      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });

    tearDown(() async {
      await contacts.dispose();
      await orgs.dispose();
    });

    test('setRoleFilter(driver) deja solo los driver', () {
      ctl.setRoleFilter(AssetActorRole.driver);
      expect(ctl.filteredActors, hasLength(1));
      expect(ctl.filteredActors.first.role, AssetActorRole.driver);
    });

    test('setRoleFilter(null) = todos', () {
      ctl.setRoleFilter(AssetActorRole.driver);
      ctl.setRoleFilter(null);
      expect(ctl.filteredActors, hasLength(3));
    });

    test('setSearchQuery filtra por displayName case-insensitive', () {
      ctl.setSearchQuery('taller');
      expect(ctl.filteredActors, hasLength(1));
      expect(ctl.filteredActors.first.displayName, 'Taller Central');
    });

    test('filtros se COMBINAN (rol AND búsqueda)', () {
      ctl.setRoleFilter(AssetActorRole.owner);
      ctl.setSearchQuery('Diana');
      // Diana es driver; el owner se llama Ana — intersección vacía.
      expect(ctl.filteredActors, isEmpty);
    });
  });

  group('relationship state', () {
    test('se hidrata cuando el relationship repo lo tiene', () async {
      final links = _FakeLinks()
        ..items = [_link(id: 'aal-1', localId: 'ct-1')];
      final contacts = _FakeContacts();
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships()
        ..byLocalKey['contact|ct-1'] =
            _rel(localId: 'ct-1', state: RelationshipState.suspendida);

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        relationships: rels,
      );

      contacts.emit([_contact(id: 'ct-1', name: 'Ana')]);
      orgs.emit(const []);

      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ctl.actors.single.relationshipState,
          RelationshipState.suspendida);

      await contacts.dispose();
      await orgs.dispose();
    });

    test('sin relationship en backend → null en el VM', () async {
      final links = _FakeLinks()
        ..items = [_link(id: 'aal-2', localId: 'ct-2')];
      final contacts = _FakeContacts();
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships(); // vacío

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        relationships: rels,
      );

      contacts.emit([_contact(id: 'ct-2', name: 'Bruno')]);
      orgs.emit(const []);

      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ctl.actors.single.relationshipState, isNull);

      await contacts.dispose();
      await orgs.dispose();
    });
  });

  group('reload()', () {
    test('refresca actors con la data nueva', () async {
      final links = _FakeLinks()
        ..items = [_link(id: 'aal-1', localId: 'ct-1')];
      final contacts = _FakeContacts();
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships();

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        relationships: rels,
      );

      contacts.emit([_contact(id: 'ct-1', name: 'Primero')]);
      orgs.emit(const []);

      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(ctl.actors, hasLength(1));

      // Cambia la data y llamamos reload.
      links.items = [
        _link(id: 'aal-1', localId: 'ct-1'),
        _link(id: 'aal-2', localId: 'ct-2', role: AssetActorRole.tenant),
      ];
      contacts.emit([
        _contact(id: 'ct-1', name: 'Primero'),
        _contact(id: 'ct-2', name: 'Segundo'),
      ]);
      await ctl.reload();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(ctl.actors, hasLength(2));

      await contacts.dispose();
      await orgs.dispose();
    });
  });
}
