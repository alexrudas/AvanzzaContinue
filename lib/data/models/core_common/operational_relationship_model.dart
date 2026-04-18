// ============================================================================
// lib/data/models/core_common/operational_relationship_model.dart
// OPERATIONAL RELATIONSHIP MODEL — Data Layer / Isar + JSON
// ============================================================================
// QUÉ HACE:
//   - Persiste OperationalRelationshipEntity en Isar.
//   - Guarda los enums como String wire-stable (wireName/fromWire).
//
// QUÉ NO HACE:
//   - No ejecuta transiciones: el motor F2.a es quien decide y luego persiste.
//   - No embebe target ni requests.
//
// PRINCIPIOS:
//   - Wire-stable en strings de enum.
//   - Índices para queries frecuentes: por workspace, por target, por actor.
//
// ENTERPRISE NOTES:
//   - targetLocalKindWire y stateWire almacenan el wireName del enum respectivo.
//   - Los mappers convierten usando fromWire/wireName.
// ============================================================================

// NOTA: import de isar_community sin alias. El codegen (isar_community_generator)
// emite en el .g.dart referencias a 'Isar', 'Id', 'FilterCondition',
// 'IsarCollection', etc. sin prefijo, por lo que el `part of` solo compila si
// estos símbolos están disponibles top-level en el archivo padre.
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/core_common/operational_relationship_entity.dart';
import '../../../domain/entities/core_common/value_objects/match_trust_level.dart';
import '../../../domain/entities/core_common/value_objects/relationship_kind.dart';
import '../../../domain/entities/core_common/value_objects/relationship_state.dart';
import '../../../domain/entities/core_common/value_objects/relationship_suspension_reason.dart';
import '../../../domain/entities/core_common/value_objects/target_local_kind.dart';

part 'operational_relationship_model.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class OperationalRelationshipModel {
  Id? isarId;

  /// Unique sin replace: las colisiones de id deben resolverse explícitamente
  /// (no sobrescritura silenciosa).
  @Index(unique: true)
  final String id;

  /// Partition key del workspace emisor.
  /// Compuestos: target (kind+id), platformActor, state para queries frecuentes.
  @Index(composite: [
    CompositeIndex('targetLocalKindWire'),
    CompositeIndex('targetLocalId'),
  ])
  @Index(composite: [
    CompositeIndex('targetPlatformActorId'),
  ], name: 'sourceWorkspaceId_targetPlatformActorId')
  @Index(composite: [
    CompositeIndex('stateWire'),
  ], name: 'sourceWorkspaceId_stateWire')
  final String sourceWorkspaceId;

  /// Wire name del TargetLocalKind (organization | contact).
  final String targetLocalKindWire;

  final String targetLocalId;

  /// Wire name del RelationshipState.
  final String stateWire;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime stateUpdatedAt;

  /// Wire name del RelationshipKind (v1: 'generic').
  final String relationshipKindWire;

  final String? targetPlatformActorId;

  /// Wire name opcional de MatchTrustLevel (solo cuando hay match).
  final String? matchTrustLevelWire;

  /// Wire name opcional de RelationshipSuspensionReason (solo si state=suspendida).
  final String? suspensionReasonWire;

  final DateTime? activatedUnilaterallyAt;
  final DateTime? linkedAt;
  final DateTime? suspendedAt;
  final DateTime? closedAt;

  final String? lastInvitationId;

  OperationalRelationshipModel({
    this.isarId,
    required this.id,
    required this.sourceWorkspaceId,
    required this.targetLocalKindWire,
    required this.targetLocalId,
    required this.stateWire,
    required this.createdAt,
    required this.updatedAt,
    required this.stateUpdatedAt,
    this.relationshipKindWire = 'generic',
    this.targetPlatformActorId,
    this.matchTrustLevelWire,
    this.suspensionReasonWire,
    this.activatedUnilaterallyAt,
    this.linkedAt,
    this.suspendedAt,
    this.closedAt,
    this.lastInvitationId,
  });

  OperationalRelationshipEntity toEntity() => OperationalRelationshipEntity(
        id: id,
        sourceWorkspaceId: sourceWorkspaceId,
        targetLocalKind: TargetLocalKindX.fromWire(targetLocalKindWire),
        targetLocalId: targetLocalId,
        state: RelationshipStateX.fromWire(stateWire),
        createdAt: createdAt,
        updatedAt: updatedAt,
        stateUpdatedAt: stateUpdatedAt,
        relationshipKind: RelationshipKindX.fromWire(relationshipKindWire),
        targetPlatformActorId: targetPlatformActorId,
        matchTrustLevel: matchTrustLevelWire == null
            ? null
            : MatchTrustLevelX.fromWire(matchTrustLevelWire!),
        suspensionReason: suspensionReasonWire == null
            ? null
            : RelationshipSuspensionReasonX.fromWire(suspensionReasonWire!),
        activatedUnilaterallyAt: activatedUnilaterallyAt,
        linkedAt: linkedAt,
        suspendedAt: suspendedAt,
        closedAt: closedAt,
        lastInvitationId: lastInvitationId,
      );

  factory OperationalRelationshipModel.fromEntity(
          OperationalRelationshipEntity e) =>
      OperationalRelationshipModel(
        id: e.id,
        sourceWorkspaceId: e.sourceWorkspaceId,
        targetLocalKindWire: e.targetLocalKind.wireName,
        targetLocalId: e.targetLocalId,
        stateWire: e.state.wireName,
        createdAt: e.createdAt.toUtc(),
        updatedAt: e.updatedAt.toUtc(),
        stateUpdatedAt: e.stateUpdatedAt.toUtc(),
        relationshipKindWire: e.relationshipKind.wireName,
        targetPlatformActorId: e.targetPlatformActorId,
        matchTrustLevelWire: e.matchTrustLevel?.wireName,
        suspensionReasonWire: e.suspensionReason?.wireName,
        activatedUnilaterallyAt: e.activatedUnilaterallyAt?.toUtc(),
        linkedAt: e.linkedAt?.toUtc(),
        suspendedAt: e.suspendedAt?.toUtc(),
        closedAt: e.closedAt?.toUtc(),
        lastInvitationId: e.lastInvitationId,
      );

  factory OperationalRelationshipModel.fromJson(Map<String, dynamic> json) =>
      _$OperationalRelationshipModelFromJson(json);

  Map<String, dynamic> toJson() => _$OperationalRelationshipModelToJson(this);
}
