// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActorRefPlatform _$ActorRefPlatformFromJson(Map<String, dynamic> json) =>
    ActorRefPlatform(
      platformActorId: json['platformActorId'] as String,
      $type: json['kind'] as String?,
    );

Map<String, dynamic> _$ActorRefPlatformToJson(ActorRefPlatform instance) =>
    <String, dynamic>{
      'platformActorId': instance.platformActorId,
      'kind': instance.$type,
    };

ActorRefLocal _$ActorRefLocalFromJson(Map<String, dynamic> json) =>
    ActorRefLocal(
      localKind: $enumDecode(_$LocalKindEnumMap, json['localKind']),
      localId: json['localId'] as String,
      $type: json['kind'] as String?,
    );

Map<String, dynamic> _$ActorRefLocalToJson(ActorRefLocal instance) =>
    <String, dynamic>{
      'localKind': _$LocalKindEnumMap[instance.localKind]!,
      'localId': instance.localId,
      'kind': instance.$type,
    };

const _$LocalKindEnumMap = {
  LocalKind.contact: 'contact',
  LocalKind.organization: 'organization',
};
