// ============================================================================
// lib/data/repositories/core_common/network_relationship_repository_impl.dart
// Impl — delega en RelationshipApiClient.
// ============================================================================

import '../../../domain/entities/core_common/operational_relationship_entity.dart';
import '../../../domain/entities/core_common/value_objects/relationship_state.dart';
import '../../../domain/entities/core_common/value_objects/relationship_suspension_reason.dart';
import '../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../domain/repositories/core_common/network_relationship_repository.dart';
import '../../sources/remote/core_common/relationship_api_client.dart';

class NetworkRelationshipRepositoryImpl
    implements NetworkRelationshipRepository {
  final RelationshipApiClient client;

  NetworkRelationshipRepositoryImpl({required this.client});

  @override
  Future<OperationalRelationshipPage> list({
    RelationshipState? state,
    TargetLocalKind? localKind,
    String? localId,
    String? cursor,
    int? limit,
  }) async {
    final page = await client.list(
      state: state,
      localKind: localKind,
      localId: localId,
      cursor: cursor,
      limit: limit,
    );
    return OperationalRelationshipPage(
      items: page.items,
      nextCursor: page.nextCursor,
    );
  }

  @override
  Future<OperationalRelationshipEntity> findById(String id) =>
      client.findById(id);

  @override
  Future<OperationalRelationshipEntity> suspend(
    String id,
    RelationshipSuspensionReason reason,
  ) =>
      client.suspend(id, reason);

  @override
  Future<OperationalRelationshipEntity> reactivate(String id) =>
      client.reactivate(id);

  @override
  Future<OperationalRelationshipEntity> close(
    String id, {
    RelationshipSuspensionReason? reason,
  }) =>
      client.close(id, reason: reason);
}
