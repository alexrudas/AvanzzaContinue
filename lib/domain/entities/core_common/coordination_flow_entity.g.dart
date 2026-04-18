// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordination_flow_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoordinationFlowEntity _$CoordinationFlowEntityFromJson(
        Map<String, dynamic> json) =>
    _CoordinationFlowEntity(
      id: json['id'] as String,
      sourceWorkspaceId: json['sourceWorkspaceId'] as String,
      relationshipId: json['relationshipId'] as String,
      startedBy: json['startedBy'] as String,
      flowKind: $enumDecodeNullable(
              _$CoordinationFlowKindEnumMap, json['flowKind']) ??
          CoordinationFlowKind.generic,
      status: $enumDecode(_$CoordinationFlowStatusEnumMap, json['status']),
      statusUpdatedAt: DateTime.parse(json['statusUpdatedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      cancelledAt: json['cancelledAt'] == null
          ? null
          : DateTime.parse(json['cancelledAt'] as String),
    );

Map<String, dynamic> _$CoordinationFlowEntityToJson(
        _CoordinationFlowEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceWorkspaceId': instance.sourceWorkspaceId,
      'relationshipId': instance.relationshipId,
      'startedBy': instance.startedBy,
      'flowKind': _$CoordinationFlowKindEnumMap[instance.flowKind]!,
      'status': _$CoordinationFlowStatusEnumMap[instance.status]!,
      'statusUpdatedAt': instance.statusUpdatedAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
    };

const _$CoordinationFlowKindEnumMap = {
  CoordinationFlowKind.generic: 'generic',
};

const _$CoordinationFlowStatusEnumMap = {
  CoordinationFlowStatus.draft: 'draft',
  CoordinationFlowStatus.active: 'active',
  CoordinationFlowStatus.completed: 'completed',
  CoordinationFlowStatus.cancelled: 'cancelled',
};
