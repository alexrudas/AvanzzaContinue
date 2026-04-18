// ============================================================================
// lib/domain/entities/core_common/platform_actor_entity.dart
// PLATFORM ACTOR ENTITY — Core Common v1 / Capa de Plataforma
// ============================================================================
// QUÉ HACE:
//   - Representa un actor registrado en Avanzza con identidad verificada.
//   - SSOT global del actor. Único por identidad real.
//   - Se relaciona opcionalmente con User (auth) cuando actorKind=person.
//
// QUÉ NO HACE:
//   - No modela identidad local ni pertenece a un workspace.
//   - No lleva notas, tags ni campos privados del workspace: esos viven en
//     LocalOrganization / LocalContact.
//   - No incluye extensiones específicas por tipo de actor (matrícula, NIT+RUT,
//     licencia): esas son extensiones futuras.
//
// PRINCIPIOS:
//   - Dominio puro + freezed + json_serializable.
//   - Dualidad explícita: organization vs person (ActorKind).
//   - linkedUserId opcional para el caso person (decisión D2).
//   - El workspace NO escribe sobre esta entidad: solo lee para adopción manual.
//   - Enums serializados vía @JsonValue (wire-stable), sin @JsonKey redundante.
//
// ENTERPRISE NOTES:
//   - primaryVerifiedKeyId apunta a la VerifiedKey marcada como primary (única).
//   - displayName es el nombre de plataforma (puede ser nombre legal o comercial).
//   - Cuando actorKind=organization, legalName aplica; fullLegalName no.
//   - Cuando actorKind=person, fullLegalName aplica; legalName no.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'value_objects/actor_kind.dart';

part 'platform_actor_entity.freezed.dart';
part 'platform_actor_entity.g.dart';

/// Actor registrado en la plataforma Avanzza.
/// SSOT global. Independiente de cualquier workspace.
@freezed
abstract class PlatformActorEntity with _$PlatformActorEntity {
  const factory PlatformActorEntity({
    required String id,

    /// Discriminador: organización o persona.
    required ActorKind actorKind,

    /// Nombre mostrado en plataforma.
    required String displayName,

    required DateTime createdAt,
    required DateTime updatedAt,

    /// Razón social cuando actorKind=organization. Null si person.
    String? legalName,

    /// Nombre legal completo cuando actorKind=person. Null si organization.
    String? fullLegalName,

    /// Referencia a avatar en almacenamiento (opcional).
    String? avatarRef,

    /// FK a la VerifiedKey marcada como primary. Debe existir tras la creación.
    String? primaryVerifiedKeyId,

    /// Vínculo opcional a User (identidad de auth) cuando actorKind=person.
    /// Null cuando actorKind=organization.
    String? linkedUserId,
  }) = _PlatformActorEntity;

  factory PlatformActorEntity.fromJson(Map<String, dynamic> json) =>
      _$PlatformActorEntityFromJson(json);
}
