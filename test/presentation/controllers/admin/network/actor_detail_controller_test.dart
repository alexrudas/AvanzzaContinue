// ============================================================================
// test/presentation/controllers/admin/network/actor_detail_controller_test.dart
// ActorDetailController — composición interna (ADR §10.3)
// ============================================================================
// Cubre:
//   - Seed platform → otros vínculos vía platformActorId, sin libreta local.
//   - Seed local contact → libreta hidratada + otros vínculos vía localKind+localId.
//   - Seed local organization → libreta de organización hidratada.
//   - Otros vínculos excluyen el seed (por assetActorLinkId).
//   - Relationship state: usa el valor fresco del repo.
//   - Relationship state: fallback a seed.relationshipState si el repo lanza.
//   - orgId vacío → error, sin fetch.
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
import 'package:avanzza/presentation/controllers/admin/network/actor_detail_controller.dart';
import 'package:avanzza/presentation/view_models/network/network_actor_vm.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime.utc(2026, 4, 15);

// ─── Fakes ──────────────────────────────────────────────────────────────────

class _FakeLinks implements AssetActorLinkRepository {
  /// Lista devuelta por cualquier list() — el controller filtra in-memory.
  List<AssetActorLinkEntity> items = const [];
  Map<String, Object?>? lastListArgs;
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
    lastListArgs = {
      'assetId': assetId,
      'role': role,
      'actorRefKind': actorRefKind,
      'platformActorId': platformActorId,
      'localKind': localKind,
      'localId': localId,
      'status': status,
      'cursor': cursor,
      'limit': limit,
    };
    if (willThrow != null) throw willThrow!;
    return AssetActorLinkPage(items: items, nextCursor: null);
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

/// Fake con semántica BehaviorSubject-like (ver controller_test de hito 5c).
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
  noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'LocalOrganizationRepository.${invocation.memberName}');
}

class _FakeRelationships implements NetworkRelationshipRepository {
  OperationalRelationshipEntity? relationship;
  Object? willThrow;

  @override
  Future<OperationalRelationshipPage> list({
    RelationshipState? state,
    TargetLocalKind? localKind,
    String? localId,
    String? cursor,
    int? limit,
  }) async {
    if (willThrow != null) throw willThrow!;
    return OperationalRelationshipPage(
      items: relationship != null ? [relationship!] : const [],
      nextCursor: null,
    );
  }

  @override
  Future<OperationalRelationshipEntity> findById(String id) =>
      throw UnimplementedError();
  @override
  Future<OperationalRelationshipEntity> suspend(
          String id, RelationshipSuspensionReason reason) =>
      throw UnimplementedError();
  @override
  Future<OperationalRelationshipEntity> reactivate(String id) =>
      throw UnimplementedError();
  @override
  Future<OperationalRelationshipEntity> close(String id,
          {RelationshipSuspensionReason? reason}) =>
      throw UnimplementedError();
}

// ─── Fixtures ──────────────────────────────────────────────────────────────

AssetActorLinkEntity _link({
  String id = 'aal-1',
  AssetActorRole role = AssetActorRole.owner,
  String assetId = 'asset-1',
  TargetLocalKind? localKind,
  String? localId,
  String? platformActorId,
  ActorRefKindValue actorRefKind = ActorRefKindValue.local,
}) {
  return AssetActorLinkEntity(
    id: id,
    orgId: 'org-1',
    assetId: assetId,
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

NetworkActorVm _localSeed({
  String assetActorLinkId = 'aal-seed',
  String localId = 'ct-1',
  TargetLocalKind localKind = TargetLocalKind.contact,
  AssetActorRole role = AssetActorRole.owner,
  RelationshipState? relationshipState,
}) {
  return NetworkActorVm(
    actorKey: 'local:${localKind.wireName}:$localId',
    actorRefKind: ActorRefKindValue.local,
    localKind: localKind,
    localId: localId,
    assetActorLinkId: assetActorLinkId,
    assetId: 'asset-seed',
    role: role,
    displayName: 'Ana',
    linkStatus: 'active',
    linkSource: 'user_declared',
    relationshipState: relationshipState,
  );
}

NetworkActorVm _platformSeed({
  String assetActorLinkId = 'aal-plat-seed',
  String platformActorId = 'pa-42',
}) {
  return NetworkActorVm(
    actorKey: 'platform:$platformActorId',
    actorRefKind: ActorRefKindValue.platform,
    platformActorId: platformActorId,
    assetActorLinkId: assetActorLinkId,
    assetId: 'asset-seed',
    role: AssetActorRole.technician,
    displayName: 'Actor · pa-42abc',
    linkStatus: 'active',
    linkSource: 'import',
  );
}

LocalContactEntity _contact({String id = 'ct-1', String name = 'Ana Pérez'}) =>
    LocalContactEntity(
      id: id,
      workspaceId: 'org-1',
      displayName: name,
      primaryPhoneE164: '+573001112233',
      primaryEmail: 'ana@example.com',
      docId: 'CC-111',
      createdAt: _now,
      updatedAt: _now,
    );

LocalOrganizationEntity _org(
        {String id = 'og-1', String name = 'Taller XYZ S.A.S.'}) =>
    LocalOrganizationEntity(
      id: id,
      workspaceId: 'org-1',
      displayName: name,
      legalName: 'Taller XYZ S.A.S.',
      taxId: '900123456',
      createdAt: _now,
      updatedAt: _now,
    );

OperationalRelationshipEntity _rel({
  RelationshipState state = RelationshipState.vinculada,
  String localId = 'ct-1',
}) =>
    OperationalRelationshipEntity(
      id: 'rel-$localId',
      sourceWorkspaceId: 'org-1',
      targetLocalKind: TargetLocalKind.contact,
      targetLocalId: localId,
      state: state,
      createdAt: _now,
      updatedAt: _now,
      stateUpdatedAt: _now,
      relationshipKind: RelationshipKind.generic,
      targetPlatformActorId: 'pa-resolved',
      linkedAt: _now,
    );

// ─── Builder ──────────────────────────────────────────────────────────────

ActorDetailController _make({
  required _FakeLinks links,
  required _FakeContacts contacts,
  required _FakeOrgs orgs,
  required _FakeRelationships rels,
  required NetworkActorVm seed,
  String orgId = 'org-1',
}) {
  return ActorDetailController(
    assetActorLinks: links,
    localContacts: contacts,
    localOrganizations: orgs,
    networkRelationships: rels,
    seed: seed,
    orgId: orgId,
  );
}

// ─── Tests ─────────────────────────────────────────────────────────────────

void main() {
  group('seed variante LOCAL contact', () {
    test('hidrata libreta y excluye el seed de otherLinks', () async {
      final links = _FakeLinks()
        ..items = [
          _link(
              id: 'aal-seed',
              localKind: TargetLocalKind.contact,
              localId: 'ct-1',
              assetId: 'asset-seed'),
          _link(
              id: 'aal-other',
              role: AssetActorRole.driver,
              localKind: TargetLocalKind.contact,
              localId: 'ct-1',
              assetId: 'asset-other'),
        ];
      final contacts = _FakeContacts()..emit([_contact(id: 'ct-1')]);
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships()..relationship = _rel();

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        rels: rels,
        seed: _localSeed(),
      );
      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ctl.isLoading.value, isFalse);
      expect(ctl.error.value, isNull);
      expect(ctl.localContact.value, isNotNull);
      expect(ctl.localContact.value!.primaryEmail, 'ana@example.com');
      expect(ctl.localOrganization.value, isNull);
      expect(ctl.otherLinks, hasLength(1));
      expect(ctl.otherLinks.single.id, 'aal-other');
      expect(ctl.otherLinks.single.role, AssetActorRole.driver);
      expect(ctl.relationshipState.value, RelationshipState.vinculada);

      // El list de AssetActorLinkRepository se invocó con filtro local.
      expect(links.lastListArgs!['localKind'], TargetLocalKind.contact);
      expect(links.lastListArgs!['localId'], 'ct-1');
      expect(links.lastListArgs!['platformActorId'], isNull);

      await contacts.dispose();
      await orgs.dispose();
    });

    test('contacto no presente en libreta → localContact = null, sigue mostrando vínculos',
        () async {
      final links = _FakeLinks()
        ..items = [_link(id: 'aal-seed', localKind: TargetLocalKind.contact, localId: 'ct-1')];
      final contacts = _FakeContacts()..emit(const []);
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships();

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        rels: rels,
        seed: _localSeed(),
      );
      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ctl.localContact.value, isNull);
      expect(ctl.error.value, isNull);

      await contacts.dispose();
      await orgs.dispose();
    });
  });

  group('seed variante LOCAL organization', () {
    test('hidrata libreta de organización', () async {
      final links = _FakeLinks()..items = [];
      final contacts = _FakeContacts();
      final orgs = _FakeOrgs()..emit([_org(id: 'og-9')]);
      final rels = _FakeRelationships();

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        rels: rels,
        seed: _localSeed(
          localKind: TargetLocalKind.organization,
          localId: 'og-9',
          role: AssetActorRole.workshop,
        ),
      );
      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ctl.localOrganization.value, isNotNull);
      expect(ctl.localOrganization.value!.legalName, 'Taller XYZ S.A.S.');
      expect(ctl.localContact.value, isNull);

      await contacts.dispose();
      await orgs.dispose();
    });
  });

  group('seed variante PLATFORM', () {
    test('no toca libreta; usa platformActorId para otherLinks', () async {
      final links = _FakeLinks()
        ..items = [
          _link(
            id: 'aal-plat-seed',
            actorRefKind: ActorRefKindValue.platform,
            platformActorId: 'pa-42',
          ),
          _link(
            id: 'aal-plat-other',
            actorRefKind: ActorRefKindValue.platform,
            platformActorId: 'pa-42',
            assetId: 'asset-other',
            role: AssetActorRole.legal,
          ),
        ];
      final contacts = _FakeContacts();
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships();

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        rels: rels,
        seed: _platformSeed(),
      );
      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ctl.localContact.value, isNull);
      expect(ctl.localOrganization.value, isNull);
      expect(ctl.otherLinks, hasLength(1));
      expect(ctl.otherLinks.single.id, 'aal-plat-other');

      expect(links.lastListArgs!['platformActorId'], 'pa-42');
      expect(links.lastListArgs!['localKind'], isNull);

      await contacts.dispose();
      await orgs.dispose();
    });

    test('platform pura → relationship del seed se propaga (no hay lookup por local)',
        () async {
      final links = _FakeLinks()..items = [];
      final contacts = _FakeContacts();
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships();

      const seed = NetworkActorVm(
        actorKey: 'platform:pa-1',
        actorRefKind: ActorRefKindValue.platform,
        platformActorId: 'pa-1',
        assetActorLinkId: 'aal-p',
        assetId: 'asset-p',
        role: AssetActorRole.technician,
        displayName: 'T',
        linkStatus: 'active',
        linkSource: 'import',
        relationshipState: RelationshipState.vinculada,
      );

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        rels: rels,
        seed: seed,
      );
      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ctl.relationshipState.value, RelationshipState.vinculada);

      await contacts.dispose();
      await orgs.dispose();
    });
  });

  group('relationshipState', () {
    test('usa el valor fresco del repo cuando existe', () async {
      final links = _FakeLinks()..items = [];
      final contacts = _FakeContacts()..emit([_contact()]);
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships()
        ..relationship = _rel(state: RelationshipState.suspendida);

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        rels: rels,
        seed: _localSeed(relationshipState: RelationshipState.vinculada),
      );
      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // El valor del repo gana sobre el del seed (fresco).
      expect(ctl.relationshipState.value, RelationshipState.suspendida);

      await contacts.dispose();
      await orgs.dispose();
    });

    test('si el repo lanza, fallback al valor del seed (no bloquea render)',
        () async {
      final links = _FakeLinks()..items = [];
      final contacts = _FakeContacts()..emit([_contact()]);
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships()..willThrow = Exception('boom');

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        rels: rels,
        seed: _localSeed(relationshipState: RelationshipState.vinculada),
      );
      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ctl.error.value, isNull);
      expect(ctl.relationshipState.value, RelationshipState.vinculada);

      await contacts.dispose();
      await orgs.dispose();
    });
  });

  group('errores y estados', () {
    test('orgId vacío → error + sin fetch', () async {
      final links = _FakeLinks();
      final contacts = _FakeContacts();
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships();

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        rels: rels,
        seed: _localSeed(),
        orgId: '',
      );
      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(ctl.error.value, contains('Organización'));
      expect(ctl.isLoading.value, isFalse);
      expect(links.lastListArgs, isNull);

      await contacts.dispose();
      await orgs.dispose();
    });

    test('AssetActorLinkRepository lanza → error state', () async {
      final links = _FakeLinks()..willThrow = Exception('boom');
      final contacts = _FakeContacts()..emit([_contact()]);
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships();

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        rels: rels,
        seed: _localSeed(),
      );
      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ctl.error.value, isNotNull);

      await contacts.dispose();
      await orgs.dispose();
    });
  });

  group('reload()', () {
    test('re-ejecuta la carga con la data nueva', () async {
      final links = _FakeLinks()
        ..items = [
          _link(id: 'aal-seed', localKind: TargetLocalKind.contact, localId: 'ct-1'),
        ];
      final contacts = _FakeContacts()..emit([_contact()]);
      final orgs = _FakeOrgs();
      final rels = _FakeRelationships();

      final ctl = _make(
        links: links,
        contacts: contacts,
        orgs: orgs,
        rels: rels,
        seed: _localSeed(),
      );
      ctl.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(ctl.otherLinks, isEmpty);

      // Aparece un segundo vínculo.
      links.items = [
        _link(id: 'aal-seed', localKind: TargetLocalKind.contact, localId: 'ct-1'),
        _link(
          id: 'aal-new',
          role: AssetActorRole.workshop,
          localKind: TargetLocalKind.contact,
          localId: 'ct-1',
          assetId: 'asset-new',
        ),
      ];
      await ctl.reload();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(ctl.otherLinks, hasLength(1));
      expect(ctl.otherLinks.single.id, 'aal-new');

      await contacts.dispose();
      await orgs.dispose();
    });
  });
}
