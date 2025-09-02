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
      estatus: json['estatus'] as String,
      primaryLocation: Map<String, String>.from(json['primaryLocation'] as Map),
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
      'estatus': instance.estatus,
      'primaryLocation': instance.primaryLocation,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
