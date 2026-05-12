// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_actor_link_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetActorLinkEntity _$AssetActorLinkEntityFromJson(
        Map<String, dynamic> json) =>
    _AssetActorLinkEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      assetId: json['assetId'] as String,
      role: $enumDecode(_$AssetActorRoleEnumMap, json['role']),
      actorRefKind:
          $enumDecode(_$ActorRefKindValueEnumMap, json['actorRefKind']),
      source: json['source'] as String,
      verificationStatus: json['verificationStatus'] as String,
      status: json['status'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      platformActorId: json['platformActorId'] as String?,
      localKind:
          $enumDecodeNullable(_$TargetLocalKindEnumMap, json['localKind']),
      localId: json['localId'] as String?,
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
    );

Map<String, dynamic> _$AssetActorLinkEntityToJson(
        _AssetActorLinkEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'assetId': instance.assetId,
      'role': _$AssetActorRoleEnumMap[instance.role]!,
      'actorRefKind': _$ActorRefKindValueEnumMap[instance.actorRefKind]!,
      'source': instance.source,
      'verificationStatus': instance.verificationStatus,
      'status': instance.status,
      'startedAt': instance.startedAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'platformActorId': instance.platformActorId,
      'localKind': _$TargetLocalKindEnumMap[instance.localKind],
      'localId': instance.localId,
      'endedAt': instance.endedAt?.toIso8601String(),
    };

const _$AssetActorRoleEnumMap = {
  AssetActorRole.owner: 'owner',
  AssetActorRole.tenant: 'tenant',
  AssetActorRole.operator: 'operator',
  AssetActorRole.driver: 'driver',
  AssetActorRole.technician: 'technician',
  AssetActorRole.workshop: 'workshop',
  AssetActorRole.legal: 'legal',
  AssetActorRole.manager: 'manager',
};

const _$ActorRefKindValueEnumMap = {
  ActorRefKindValue.platform: 'platform',
  ActorRefKindValue.local: 'local',
};

const _$TargetLocalKindEnumMap = {
  TargetLocalKind.organization: 'organization',
  TargetLocalKind.contact: 'contact',
};
