// ============================================================================
// test/data/repositories/core_common/asset_actor_link_repository_impl_test.dart
// AssetActorLinkRepositoryImpl — delegación pura al ApiClient
// ============================================================================
// Valida:
//   - list: reenvía filtros al client, mapea el enum del dominio al del wire,
//     devuelve la página del dominio preservando nextCursor.
//   - findById: delega sin transformación.
// ============================================================================

import 'package:avanzza/data/repositories/core_common/asset_actor_link_repository_impl.dart';
import 'package:avanzza/data/sources/remote/core_common/asset_actor_link_api_client.dart';
import 'package:avanzza/domain/entities/core_common/asset_actor_link_entity.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/actor_ref_kind_value.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:avanzza/domain/repositories/core_common/asset_actor_link_repository.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Fake client ────────────────────────────────────────────────────────────

class _FakeClient implements AssetActorLinkApiClient {
  Map<String, Object?>? lastListArgs;
  AssetActorLinkListPage listResponse =
      const AssetActorLinkListPage(items: [], nextCursor: null);

  String? lastFindById;
  AssetActorLinkEntity? findByIdResponse;

  @override
  Future<AssetActorLinkListPage> list({
    String? assetId,
    AssetActorRole? role,
    ActorRefKindValue? actorRefKind,
    String? platformActorId,
    TargetLocalKind? localKind,
    String? localId,
    AssetActorLinkStatusFilter? status,
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
    return listResponse;
  }

  @override
  Future<AssetActorLinkEntity> findById(String id) async {
    lastFindById = id;
    return findByIdResponse!;
  }

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('AssetActorLinkApiClient.${invocation.memberName}');
}

AssetActorLinkEntity _link({String id = 'aal-1'}) {
  final now = DateTime.utc(2026, 4, 15);
  return AssetActorLinkEntity(
    id: id,
    orgId: 'org-1',
    assetId: 'asset-1',
    role: AssetActorRole.owner,
    actorRefKind: ActorRefKindValue.local,
    source: 'user_declared',
    verificationStatus: 'pending',
    status: 'active',
    startedAt: now,
    createdAt: now,
    updatedAt: now,
    localKind: TargetLocalKind.contact,
    localId: 'local-1',
  );
}

void main() {
  group('AssetActorLinkRepositoryImpl.list', () {
    test('mapea el enum de dominio al del wire (active)', () async {
      final c = _FakeClient()
        ..listResponse = AssetActorLinkListPage(items: [_link()], nextCursor: null);
      final repo = AssetActorLinkRepositoryImpl(client: c);

      await repo.list(
        assetId: 'asset-42',
        role: AssetActorRole.tenant,
        status: AssetActorLinkStatusQuery.active,
      );

      expect(c.lastListArgs!['assetId'], 'asset-42');
      expect(c.lastListArgs!['role'], AssetActorRole.tenant);
      expect(c.lastListArgs!['status'], AssetActorLinkStatusFilter.active);
    });

    test('status=ended y status=any mapean correctamente', () async {
      final c = _FakeClient();
      final repo = AssetActorLinkRepositoryImpl(client: c);

      await repo.list(status: AssetActorLinkStatusQuery.ended);
      expect(c.lastListArgs!['status'], AssetActorLinkStatusFilter.ended);

      await repo.list(status: AssetActorLinkStatusQuery.any);
      expect(c.lastListArgs!['status'], AssetActorLinkStatusFilter.any);
    });

    test('status null → null (default backend = active)', () async {
      final c = _FakeClient();
      final repo = AssetActorLinkRepositoryImpl(client: c);

      await repo.list();
      expect(c.lastListArgs!['status'], isNull);
    });

    test('preserva nextCursor del client', () async {
      final c = _FakeClient()
        ..listResponse =
            AssetActorLinkListPage(items: [_link()], nextCursor: 'OPAQUE');
      final repo = AssetActorLinkRepositoryImpl(client: c);

      final page = await repo.list();
      expect(page.nextCursor, 'OPAQUE');
      expect(page.items, hasLength(1));
    });
  });

  group('AssetActorLinkRepositoryImpl.findById', () {
    test('delega sin transformación', () async {
      final c = _FakeClient()..findByIdResponse = _link(id: 'aal-9');
      final repo = AssetActorLinkRepositoryImpl(client: c);

      final link = await repo.findById('aal-9');
      expect(link.id, 'aal-9');
      expect(c.lastFindById, 'aal-9');
    });
  });
}
