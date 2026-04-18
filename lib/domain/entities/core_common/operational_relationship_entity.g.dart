// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operational_relationship_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OperationalRelationshipEntity _$OperationalRelationshipEntityFromJson(
        Map<String, dynamic> json) =>
    _OperationalRelationshipEntity(
      id: json['id'] as String,
      sourceWorkspaceId: json['sourceWorkspaceId'] as String,
      targetLocalKind:
          $enumDecode(_$TargetLocalKindEnumMap, json['targetLocalKind']),
      targetLocalId: json['targetLocalId'] as String,
      state: $enumDecode(_$RelationshipStateEnumMap, json['state']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      stateUpdatedAt: DateTime.parse(json['stateUpdatedAt'] as String),
      relationshipKind: $enumDecodeNullable(
              _$RelationshipKindEnumMap, json['relationshipKind']) ??
          RelationshipKind.generic,
      targetPlatformActorId: json['targetPlatformActorId'] as String?,
      matchTrustLevel: $enumDecodeNullable(
          _$MatchTrustLevelEnumMap, json['matchTrustLevel']),
      suspensionReason: $enumDecodeNullable(
          _$RelationshipSuspensionReasonEnumMap, json['suspensionReason']),
      activatedUnilaterallyAt: json['activatedUnilaterallyAt'] == null
          ? null
          : DateTime.parse(json['activatedUnilaterallyAt'] as String),
      linkedAt: json['linkedAt'] == null
          ? null
          : DateTime.parse(json['linkedAt'] as String),
      suspendedAt: json['suspendedAt'] == null
          ? null
          : DateTime.parse(json['suspendedAt'] as String),
      closedAt: json['closedAt'] == null
          ? null
          : DateTime.parse(json['closedAt'] as String),
      lastInvitationId: json['lastInvitationId'] as String?,
    );

Map<String, dynamic> _$OperationalRelationshipEntityToJson(
        _OperationalRelationshipEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceWorkspaceId': instance.sourceWorkspaceId,
      'targetLocalKind': _$TargetLocalKindEnumMap[instance.targetLocalKind]!,
      'targetLocalId': instance.targetLocalId,
      'state': _$RelationshipStateEnumMap[instance.state]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'stateUpdatedAt': instance.stateUpdatedAt.toIso8601String(),
      'relationshipKind': _$RelationshipKindEnumMap[instance.relationshipKind]!,
      'targetPlatformActorId': instance.targetPlatformActorId,
      'matchTrustLevel': _$MatchTrustLevelEnumMap[instance.matchTrustLevel],
      'suspensionReason':
          _$RelationshipSuspensionReasonEnumMap[instance.suspensionReason],
      'activatedUnilaterallyAt':
          instance.activatedUnilaterallyAt?.toIso8601String(),
      'linkedAt': instance.linkedAt?.toIso8601String(),
      'suspendedAt': instance.suspendedAt?.toIso8601String(),
      'closedAt': instance.closedAt?.toIso8601String(),
      'lastInvitationId': instance.lastInvitationId,
    };

const _$TargetLocalKindEnumMap = {
  TargetLocalKind.organization: 'organization',
  TargetLocalKind.contact: 'contact',
};

const _$RelationshipStateEnumMap = {
  RelationshipState.referenciada: 'referenciada',
  RelationshipState.detectable: 'detectable',
  RelationshipState.activadaUnilateral: 'activadaUnilateral',
  RelationshipState.vinculada: 'vinculada',
  RelationshipState.suspendida: 'suspendida',
  RelationshipState.cerrada: 'cerrada',
};

const _$RelationshipKindEnumMap = {
  RelationshipKind.generic: 'generic',
};

const _$MatchTrustLevelEnumMap = {
  MatchTrustLevel.alto: 'alto',
  MatchTrustLevel.medio: 'medio',
  MatchTrustLevel.bajo: 'bajo',
};

const _$RelationshipSuspensionReasonEnumMap = {
  RelationshipSuspensionReason.platformActorRemoved: 'platformActorRemoved',
  RelationshipSuspensionReason.platformKeyReassignedCritical:
      'platformKeyReassignedCritical',
  RelationshipSuspensionReason.userRequested: 'userRequested',
  RelationshipSuspensionReason.systemPolicy: 'systemPolicy',
  RelationshipSuspensionReason.unknown: 'unknown',
};
