// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_actor_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlatformActorEntity _$PlatformActorEntityFromJson(Map<String, dynamic> json) =>
    _PlatformActorEntity(
      id: json['id'] as String,
      actorKind: $enumDecode(_$ActorKindEnumMap, json['actorKind']),
      displayName: json['displayName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      legalName: json['legalName'] as String?,
      fullLegalName: json['fullLegalName'] as String?,
      avatarRef: json['avatarRef'] as String?,
      primaryVerifiedKeyId: json['primaryVerifiedKeyId'] as String?,
      linkedUserId: json['linkedUserId'] as String?,
    );

Map<String, dynamic> _$PlatformActorEntityToJson(
        _PlatformActorEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actorKind': _$ActorKindEnumMap[instance.actorKind]!,
      'displayName': instance.displayName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'legalName': instance.legalName,
      'fullLegalName': instance.fullLegalName,
      'avatarRef': instance.avatarRef,
      'primaryVerifiedKeyId': instance.primaryVerifiedKeyId,
      'linkedUserId': instance.linkedUserId,
    };

const _$ActorKindEnumMap = {
  ActorKind.organization: 'organization',
  ActorKind.person: 'person',
};
