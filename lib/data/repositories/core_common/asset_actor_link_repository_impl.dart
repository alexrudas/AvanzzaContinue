// ============================================================================
// lib/data/repositories/core_common/asset_actor_link_repository_impl.dart
// Impl — delega en AssetActorLinkApiClient sin cache (read directo).
// ============================================================================
// QUÉ HACE:
//   - Traduce el enum del dominio (AssetActorLinkStatusQuery) al del wire
//     (AssetActorLinkStatusFilter).
//   - Mapea la página del client a la del dominio.
//
// QUÉ NO HACE:
//   - No hace caching. La fuente única de verdad es core-api; cachear invita
//     a inconsistencias sin policy explícita (ADR §2.8 análogo).
// ============================================================================

import '../../../domain/entities/core_common/asset_actor_link_entity.dart';
import '../../../domain/entities/core_common/value_objects/actor_ref_kind_value.dart';
import '../../../domain/entities/core_common/value_objects/asset_actor_role.dart';
import '../../../domain/entities/core_common/value_objects/asset_class.dart';
import '../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../domain/repositories/core_common/asset_actor_link_repository.dart';
import '../../sources/remote/core_common/asset_actor_link_api_client.dart';

class AssetActorLinkRepositoryImpl implements AssetActorLinkRepository {
  final AssetActorLinkApiClient client;

  AssetActorLinkRepositoryImpl({required this.client});

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
    final page = await client.list(
      assetId: assetId,
      role: role,
      actorRefKind: actorRefKind,
      platformActorId: platformActorId,
      localKind: localKind,
      localId: localId,
      status: _mapStatus(status),
      cursor: cursor,
      limit: limit,
    );
    return AssetActorLinkPage(items: page.items, nextCursor: page.nextCursor);
  }

  @override
  Future<AssetActorLinkEntity> findById(String id) => client.findById(id);

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
  }) {
    return client.create(
      assetId: assetId,
      assetTypeId: assetTypeId,
      assetClass: assetClass,
      role: role,
      actorRefKind: actorRefKind,
      platformActorId: platformActorId,
      localKind: localKind,
      localId: localId,
    );
  }

  AssetActorLinkStatusFilter? _mapStatus(AssetActorLinkStatusQuery? q) {
    switch (q) {
      case null:
        return null;
      case AssetActorLinkStatusQuery.active:
        return AssetActorLinkStatusFilter.active;
      case AssetActorLinkStatusQuery.ended:
        return AssetActorLinkStatusFilter.ended;
      case AssetActorLinkStatusQuery.any:
        return AssetActorLinkStatusFilter.any;
    }
  }
}
