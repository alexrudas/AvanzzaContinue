// ============================================================================
// lib/domain/entities/core_common/asset_actor_link_entity.dart
// AssetActorLinkEntity — vínculo estable actor↔activo (ADR actor-canon §2.9)
// ============================================================================
// QUÉ HACE:
//   - Espejo del modelo Prisma AssetActorLink en backend core-api.
//   - Modelo ENRIQUECIBLE (ADR §2.7.B): nace con localKind+localId y puede
//     ganar platformActorId tras match; ambos pueden coexistir.
//   - Se consume vía GET /v1/core-common/asset-actor-links (hito 5a).
//
// QUÉ NO HACE:
//   - No persiste atributos del actor (nombre, teléfono, documento):
//     projected reference, no identidad (ADR §2.6).
//   - No se crea ni edita desde Flutter directamente: otros flujos (RUNT,
//     contratos) lo evolucionan server-side.
//
// PRINCIPIOS:
//   - Dominio puro + freezed + json_serializable.
//   - `actorRefKind` es el discriminator persistido como columna.
//   - `platformActorId` y `(localKind, localId)` pueden estar ambos presentes
//     solo cuando la fila nació local y luego fue enriquecida.
//
// See docs/adr/0001-actor-canon.md §2.9 + §2.7.B.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'value_objects/actor_ref_kind_value.dart';
import 'value_objects/asset_actor_role.dart';
import 'value_objects/target_local_kind.dart';

part 'asset_actor_link_entity.freezed.dart';
part 'asset_actor_link_entity.g.dart';

/// Vínculo operativo estable entre un actor y un activo, con rol enum fuerte.
@freezed
abstract class AssetActorLinkEntity with _$AssetActorLinkEntity {
  const factory AssetActorLinkEntity({
    required String id,

    /// Tenancy. orgId del workspace dueño del vínculo.
    required String orgId,

    /// ID del activo. String sin FK mientras no exista modelo Asset en core-api.
    required String assetId,

    /// Rol operativo (enum fuerte del ADR).
    required AssetActorRole role,

    /// Discriminator del ActorRef persistido.
    required ActorRefKindValue actorRefKind,

    /// Fuente del vínculo declarada: user_declared | runt | contract | import.
    required String source,

    /// Estado de verificación del vínculo: verified | pending | unresolved | rejected.
    required String verificationStatus,

    /// Ciclo de vida del vínculo en sí: active | ended.
    required String status,

    required DateTime startedAt,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// FK opcional a PlatformActor (variante platform o enriquecimiento).
    String? platformActorId,

    /// Tipo de registro local del workspace (variante local).
    TargetLocalKind? localKind,

    /// ID del registro local (LocalContact.id / LocalOrganization.id).
    String? localId,

    /// Timestamp de fin del vínculo cuando status='ended'.
    DateTime? endedAt,
  }) = _AssetActorLinkEntity;

  factory AssetActorLinkEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetActorLinkEntityFromJson(json);
}
