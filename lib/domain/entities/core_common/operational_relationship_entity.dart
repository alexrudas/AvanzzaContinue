// ============================================================================
// lib/domain/entities/core_common/operational_relationship_entity.dart
// OPERATIONAL RELATIONSHIP ENTITY — Core Common v1 / Unidad Base
// ============================================================================
// QUÉ HACE:
//   - Modela la Relación Operativa: vínculo dirigido desde un workspace hacia
//     un target local (LocalOrganization o LocalContact), con estado tipado.
//   - Es la UNIDAD BASE del producto (no el Actor).
//
// QUÉ NO HACE:
//   - No embebe el target: se referencia por (targetLocalKind, targetLocalId).
//   - No ejecuta transiciones de estado: eso es RelationshipStateMachine (F2.a).
//   - No coordina Requests ni Deliveries: los referencia por FK desde el otro lado.
//   - No depende del estado de ninguna OperationalRequest: motores independientes.
//
// PRINCIPIOS:
//   - Dominio puro + freezed + json_serializable.
//   - targetPlatformActorId y matchTrustLevel son opcionales:
//       · Presentes solo cuando hay match confirmado (estados ≥ detectable).
//       · activadaUnilateral NO los exige (degradable externo admitido).
//   - relationshipKind es placeholder 'generic' en v1.
//   - suspensionReason solo se poblará cuando state = suspendida.
//   - Enums serializados vía @JsonValue (wire-stable).
//
// ENTERPRISE NOTES:
//   - sourceWorkspaceId ≡ orgId del tenant emisor de la relación.
//   - lastInvitationId es placeholder; la entidad de invitación llegará en v1.1.
//   - stateUpdatedAt debe actualizarse en cada transición del motor F2.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'value_objects/match_trust_level.dart';
import 'value_objects/relationship_kind.dart';
import 'value_objects/relationship_state.dart';
import 'value_objects/relationship_suspension_reason.dart';
import 'value_objects/target_local_kind.dart';

part 'operational_relationship_entity.freezed.dart';
part 'operational_relationship_entity.g.dart';

/// Relación Operativa dirigida desde un workspace hacia un target local.
/// Ciclo de vida gobernado por RelationshipStateMachine (F2.a).
@freezed
abstract class OperationalRelationshipEntity
    with _$OperationalRelationshipEntity {
  const factory OperationalRelationshipEntity({
    required String id,

    /// Workspace dueño de la relación. ≡ orgId del tenant SaaS.
    required String sourceWorkspaceId,

    /// Discriminador del target local.
    required TargetLocalKind targetLocalKind,

    /// FK polimórfica al registro local (LocalOrganization.id o LocalContact.id
    /// según targetLocalKind).
    required String targetLocalId,

    /// Estado actual de la Relación. Gobierno por F2.a.
    required RelationshipState state,

    required DateTime createdAt,
    required DateTime updatedAt,

    /// Timestamp de la última transición de estado.
    required DateTime stateUpdatedAt,

    /// Tipología semántica. En v1 siempre 'generic'.
    @Default(RelationshipKind.generic) RelationshipKind relationshipKind,

    /// FK al PlatformActor confirmado. Null hasta que haya match alto + exposición.
    String? targetPlatformActorId,

    /// Nivel de confianza del match que ancló al PlatformActor. En v1 solo 'alto'
    /// debería aparecer aquí (otros niveles no promueven a detectable).
    MatchTrustLevel? matchTrustLevel,

    /// Razón codificada de suspensión. Poblada solo cuando state = suspendida.
    RelationshipSuspensionReason? suspensionReason,

    /// Timestamps de transiciones clave (trazabilidad).
    DateTime? activatedUnilaterallyAt,
    DateTime? linkedAt,
    DateTime? suspendedAt,
    DateTime? closedAt,

    /// Placeholder a la futura entidad de invitación (v1.1).
    String? lastInvitationId,
  }) = _OperationalRelationshipEntity;

  factory OperationalRelationshipEntity.fromJson(Map<String, dynamic> json) =>
      _$OperationalRelationshipEntityFromJson(json);
}
