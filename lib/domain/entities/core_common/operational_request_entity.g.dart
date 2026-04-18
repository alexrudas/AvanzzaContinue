// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operational_request_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OperationalRequestEntity _$OperationalRequestEntityFromJson(
        Map<String, dynamic> json) =>
    _OperationalRequestEntity(
      id: json['id'] as String,
      sourceWorkspaceId: json['sourceWorkspaceId'] as String,
      relationshipId: json['relationshipId'] as String,
      requestKind:
          $enumDecodeNullable(_$RequestKindEnumMap, json['requestKind']) ??
              RequestKind.generic,
      state: $enumDecode(_$RequestStateEnumMap, json['state']),
      title: json['title'] as String,
      createdBy: json['createdBy'] as String,
      originChannel:
          $enumDecode(_$RequestOriginChannelEnumMap, json['originChannel']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      stateUpdatedAt: DateTime.parse(json['stateUpdatedAt'] as String),
      summary: json['summary'] as String?,
      payloadJson: json['payloadJson'] as String?,
      notesSource: json['notesSource'] as String?,
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      closedAt: json['closedAt'] == null
          ? null
          : DateTime.parse(json['closedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$OperationalRequestEntityToJson(
        _OperationalRequestEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceWorkspaceId': instance.sourceWorkspaceId,
      'relationshipId': instance.relationshipId,
      'requestKind': _$RequestKindEnumMap[instance.requestKind]!,
      'state': _$RequestStateEnumMap[instance.state]!,
      'title': instance.title,
      'createdBy': instance.createdBy,
      'originChannel': _$RequestOriginChannelEnumMap[instance.originChannel]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'stateUpdatedAt': instance.stateUpdatedAt.toIso8601String(),
      'summary': instance.summary,
      'payloadJson': instance.payloadJson,
      'notesSource': instance.notesSource,
      'sentAt': instance.sentAt?.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'closedAt': instance.closedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

const _$RequestKindEnumMap = {
  RequestKind.generic: 'generic',
};

const _$RequestStateEnumMap = {
  RequestState.draft: 'draft',
  RequestState.sent: 'sent',
  RequestState.delivered: 'delivered',
  RequestState.seen: 'seen',
  RequestState.responded: 'responded',
  RequestState.accepted: 'accepted',
  RequestState.rejected: 'rejected',
  RequestState.expired: 'expired',
  RequestState.closed: 'closed',
};

const _$RequestOriginChannelEnumMap = {
  RequestOriginChannel.inApp: 'inApp',
  RequestOriginChannel.externalAssisted: 'externalAssisted',
};
