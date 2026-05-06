// ============================================================================
// test/data/repositories/core_common/network_relationship_repository_impl_test.dart
// NetworkRelationshipRepositoryImpl — delegación pura al ApiClient
// ============================================================================

import 'package:avanzza/data/repositories/core_common/network_relationship_repository_impl.dart';
import 'package:avanzza/data/sources/remote/core_common/relationship_api_client.dart';
import 'package:avanzza/domain/entities/core_common/operational_relationship_entity.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_suspension_reason.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeClient implements RelationshipApiClient {
  Map<String, Object?>? lastListArgs;
  RelationshipListPage listResponse =
      const RelationshipListPage(items: [], nextCursor: null);

  String? lastFindById;
  OperationalRelationshipEntity? findByIdResponse;

  String? lastSuspendId;
  RelationshipSuspensionReason? lastSuspendReason;
  OperationalRelationshipEntity? suspendResponse;

  String? lastReactivateId;
  OperationalRelationshipEntity? reactivateResponse;

  String? lastCloseId;
  RelationshipSuspensionReason? lastCloseReason;
  OperationalRelationshipEntity? closeResponse;

  @override
  Future<RelationshipListPage> list({
    RelationshipState? state,
    TargetLocalKind? localKind,
    String? localId,
    String? cursor,
    int? limit,
  }) async {
    lastListArgs = {
      'state': state,
      'localKind': localKind,
      'localId': localId,
      'cursor': cursor,
      'limit': limit,
    };
    return listResponse;
  }

  @override
  Future<OperationalRelationshipEntity> findById(String id) async {
    lastFindById = id;
    return findByIdResponse!;
  }

  @override
  Future<OperationalRelationshipEntity> suspend(
    String id,
    RelationshipSuspensionReason reason,
  ) async {
    lastSuspendId = id;
    lastSuspendReason = reason;
    return suspendResponse!;
  }

  @override
  Future<OperationalRelationshipEntity> reactivate(String id) async {
    lastReactivateId = id;
    return reactivateResponse!;
  }

  @override
  Future<OperationalRelationshipEntity> close(
    String id, {
    RelationshipSuspensionReason? reason,
  }) async {
    lastCloseId = id;
    lastCloseReason = reason;
    return closeResponse!;
  }

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('RelationshipApiClient.${invocation.memberName}');
}

OperationalRelationshipEntity _rel({
  String id = 'rel-1',
  RelationshipState state = RelationshipState.vinculada,
}) {
  final now = DateTime.utc(2026, 4, 15);
  return OperationalRelationshipEntity(
    id: id,
    sourceWorkspaceId: 'ws-1',
    targetLocalKind: TargetLocalKind.contact,
    targetLocalId: 'local-1',
    state: state,
    createdAt: now,
    updatedAt: now,
    stateUpdatedAt: now,
    relationshipKind: RelationshipKind.generic,
    targetPlatformActorId: 'pa-1',
    linkedAt: now,
  );
}

void main() {
  test('list: reenvía filtros al client y mapea la página', () async {
    final c = _FakeClient()
      ..listResponse = RelationshipListPage(
        items: [_rel(id: 'rel-a')],
        nextCursor: 'CURSOR',
      );
    final repo = NetworkRelationshipRepositoryImpl(client: c);

    final page = await repo.list(
      state: RelationshipState.vinculada,
      localKind: TargetLocalKind.contact,
      localId: 'local-xyz',
      cursor: 'PREV',
      limit: 25,
    );

    expect(c.lastListArgs!['state'], RelationshipState.vinculada);
    expect(c.lastListArgs!['localKind'], TargetLocalKind.contact);
    expect(c.lastListArgs!['localId'], 'local-xyz');
    expect(c.lastListArgs!['cursor'], 'PREV');
    expect(c.lastListArgs!['limit'], 25);
    expect(page.items, hasLength(1));
    expect(page.nextCursor, 'CURSOR');
  });

  test('findById: delega sin transformación', () async {
    final c = _FakeClient()..findByIdResponse = _rel(id: 'rel-x');
    final repo = NetworkRelationshipRepositoryImpl(client: c);

    final r = await repo.findById('rel-x');
    expect(r.id, 'rel-x');
    expect(c.lastFindById, 'rel-x');
  });

  test('suspend: reenvía id + reason', () async {
    final c = _FakeClient()
      ..suspendResponse = _rel(state: RelationshipState.suspendida);
    final repo = NetworkRelationshipRepositoryImpl(client: c);

    final r = await repo.suspend(
      'rel-x',
      RelationshipSuspensionReason.userRequested,
    );
    expect(c.lastSuspendId, 'rel-x');
    expect(c.lastSuspendReason, RelationshipSuspensionReason.userRequested);
    expect(r.state, RelationshipState.suspendida);
  });

  test('reactivate: reenvía id, sin body', () async {
    final c = _FakeClient()..reactivateResponse = _rel();
    final repo = NetworkRelationshipRepositoryImpl(client: c);

    await repo.reactivate('rel-x');
    expect(c.lastReactivateId, 'rel-x');
  });

  test('close: reason opcional se propaga como null', () async {
    final c = _FakeClient()
      ..closeResponse = _rel(state: RelationshipState.cerrada);
    final repo = NetworkRelationshipRepositoryImpl(client: c);

    await repo.close('rel-x');
    expect(c.lastCloseId, 'rel-x');
    expect(c.lastCloseReason, isNull);
  });

  test('close: reason explícito se propaga', () async {
    final c = _FakeClient()
      ..closeResponse = _rel(state: RelationshipState.cerrada);
    final repo = NetworkRelationshipRepositoryImpl(client: c);

    await repo.close(
      'rel-x',
      reason: RelationshipSuspensionReason.systemPolicy,
    );
    expect(c.lastCloseReason, RelationshipSuspensionReason.systemPolicy);
  });
}
