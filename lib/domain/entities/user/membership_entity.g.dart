// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MembershipEntity _$MembershipEntityFromJson(Map<String, dynamic> json) =>
    _MembershipEntity(
      userId: json['userId'] as String,
      orgId: json['orgId'] as String,
      orgName: json['orgName'] as String,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      providerProfiles: (json['providerProfiles'] as List<dynamic>?)
              ?.map((e) => ProviderProfile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ProviderProfile>[],
      estatus: json['estatus'] as String,
      primaryLocation: Map<String, String>.from(json['primaryLocation'] as Map),
      scope: json['scope'] == null
          ? const MembershipScope()
          : MembershipScope.fromJson(json['scope'] as Map<String, dynamic>),
      isOwner: json['isOwner'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MembershipEntityToJson(_MembershipEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'orgId': instance.orgId,
      'orgName': instance.orgName,
      'roles': instance.roles,
      'providerProfiles': instance.providerProfiles,
      'estatus': instance.estatus,
      'primaryLocation': instance.primaryLocation,
      'scope': instance.scope,
      'isOwner': instance.isOwner,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
