// ============================================================================
// lib/domain/repositories/core_common/asset_actor_link_repository.dart
// AssetActorLinkRepository — interfaz
// ============================================================================
// QUÉ HACE:
//   - Contrato de acceso a vínculos actor↔activo.
//   - Lectura: list + findById con tenancy del JWT.
//   - Escritura (Hito 1.x): create() solo emite vínculos
//     `source=user_declared`. Las otras fuentes (runt|contract|import)
//     viven en flujos dedicados que NO atraviesan este contrato.
//
// QUÉ NO HACE:
//   - No resuelve actores ni hidrata atributos.
//   - No mapea taxonomía: el backend resuelve `assetClass → AssetType.id`.
//   - No compone con libreta (LocalContact/LocalOrganization): eso lo hará
//     una capa de presentación/VM separada.
// ============================================================================

import '../../entities/core_common/asset_actor_link_entity.dart';
import '../../entities/core_common/value_objects/actor_ref_kind_value.dart';
import '../../entities/core_common/value_objects/asset_actor_role.dart';
import '../../entities/core_common/value_objects/asset_class.dart';
import '../../entities/core_common/value_objects/target_local_kind.dart';

/// Filtro del estado del vínculo en el list.
enum AssetActorLinkStatusQuery { active, ended, any }

class AssetActorLinkPage {
  final List<AssetActorLinkEntity> items;
  final String? nextCursor;
  const AssetActorLinkPage({required this.items, this.nextCursor});
}

abstract class AssetActorLinkRepository {
  /// Lista vínculos del workspace del JWT con filtros combinables y
  /// keyset pagination estable.
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
  });

  /// Detalle con tenancy. Lanza BadRequestException(code=ASSET_ACTOR_LINK_NOT_FOUND)
  /// si no existe o pertenece a otra org.
  Future<AssetActorLinkEntity> findById(String id);

  /// Declara un vínculo `source=user_declared` entre el workspace activo y
  /// un activo bajo un rol concreto.
  ///
  /// Taxonomía — XOR estricto: exactamente uno de [assetTypeId] o
  /// [assetClass] DEBE estar presente. Lanza [ArgumentError] si ambos
  /// están presentes o ambos ausentes (defensivo; el backend también
  /// rechaza con 400 INVALID_ASSET_TYPE_INPUT).
  ///
  /// Idempotente server-side: re-envíos con la misma clave lógica
  /// retornan la fila existente sin duplicar.
  Future<AssetActorLinkEntity> create({
    required String assetId,
    String? assetTypeId,
    AssetClass? assetClass,
    required AssetActorRole role,
    required ActorRefKindValue actorRefKind,
    String? platformActorId,
    TargetLocalKind? localKind,
    String? localId,
  });
}
