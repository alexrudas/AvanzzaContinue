// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegionEntity _$RegionEntityFromJson(Map<String, dynamic> json) =>
    _RegionEntity(
      id: json['id'] as String,
      countryId: json['countryId'] as String,
      name: json['name'] as String,
      code: json['code'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RegionEntityToJson(_RegionEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'countryId': instance.countryId,
      'name': instance.name,
      'code': instance.code,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
