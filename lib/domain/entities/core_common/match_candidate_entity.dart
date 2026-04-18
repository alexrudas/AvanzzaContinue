// ============================================================================
// lib/domain/entities/core_common/match_candidate_entity.dart
// MATCH CANDIDATE ENTITY — Core Common v1 / Matcher
// ============================================================================
// QUÉ HACE:
//   - Representa un vínculo interno detectado por el matcher entre un registro
//     local y un PlatformActor, con nivel de confianza.
//   - Lleva el hook de colisiones (D8): marcas de conflicto sin resolución
//     automática destructiva.
//
// QUÉ NO HACE:
//   - No promueve estados de Relación por sí mismo: el caso de uso decide
//     (resolve_match_candidate) tras evaluar trustLevel + colisiones.
//   - No expone identidades: la exposición al workspace se materializa por
//     la transición de state a 'exposedToWorkspace', no por el mero match.
//
// PRINCIPIOS:
//   - Dominio puro + freezed + json_serializable.
//   - Regla D8: colisiones no críticas NO suspenden ni bloquean operación,
//     pero quedan marcadas para resolución explícita.
//   - Solo trustLevel = alto promueve a exposedToWorkspace.
//   - Enums serializados vía @JsonValue (wire-stable); List<CollisionKind>
//     automática por json_serializable al tener @JsonValue en cada variante.
//
// ENTERPRISE NOTES:
//   - sourceWorkspaceId se incluye en la entidad para facilitar filtrado
//     eficiente desde el cliente; es derivable del localId pero costoso en
//     tiempo de consulta sin join.
//   - collisionKinds es lista: un mismo candidato puede acumular más de un
//     tipo de colisión detectado.
//   - isCriticalConflict es el disparo de suspensión automática (ver
//     RelationshipSuspensionReason.platformKeyReassignedCritical).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'value_objects/collision_kind.dart';
import 'value_objects/match_candidate_state.dart';
import 'value_objects/match_trust_level.dart';
import 'value_objects/target_local_kind.dart';
import 'value_objects/verified_key_type.dart';

part 'match_candidate_entity.freezed.dart';
part 'match_candidate_entity.g.dart';

/// Candidato de match entre un registro local y un PlatformActor.
/// Mayoría de instancias viven solo en backend; el cliente observa solo
/// las que transicionaron a 'exposedToWorkspace' para su propio workspace.
@freezed
abstract class MatchCandidateEntity with _$MatchCandidateEntity {
  const factory MatchCandidateEntity({
    required String id,

    /// Workspace dueño del registro local involucrado.
    /// Derivable pero incluido para filtrado eficiente en cliente.
    required String sourceWorkspaceId,

    /// Tipo del registro local implicado.
    required TargetLocalKind localKind,

    /// FK polimórfica al registro local (LocalOrganization.id o LocalContact.id).
    required String localId,

    /// FK al PlatformActor candidato.
    required String platformActorId,

    /// Tipo de llave que generó el match.
    required VerifiedKeyType matchedKeyType,

    /// Valor de la llave que generó el match (normalizado).
    required String matchedKeyValue,

    /// Nivel de confianza asignado por el matcher.
    required MatchTrustLevel trustLevel,

    /// Estado del candidato (detección interna → exposición → resolución).
    required MatchCandidateState state,

    required DateTime detectedAt,
    required DateTime updatedAt,

    DateTime? exposedAt,
    DateTime? dismissedAt,
    DateTime? confirmedAt,

    /// Si el candidato se promovió a una Relación Operativa.
    String? resultingRelationshipId,

    /// Hook D8: colisiones detectadas sobre este candidato. Vacío en el caso feliz.
    @Default(<CollisionKind>[]) List<CollisionKind> collisionKinds,

    /// Hook D8: true cuando existe alguna colisión marcada (aunque no sea crítica).
    /// Permite filtrar candidatos con conflicto sin recorrer la lista.
    @Default(false) bool isConflictMarked,

    /// Hook D8: true cuando la colisión afecta routing/identidad activa.
    /// Disparador de la suspensión automática (ver
    /// RelationshipSuspensionReason.platformKeyReassignedCritical).
    @Default(false) bool isCriticalConflict,
  }) = _MatchCandidateEntity;

  factory MatchCandidateEntity.fromJson(Map<String, dynamic> json) =>
      _$MatchCandidateEntityFromJson(json);
}
