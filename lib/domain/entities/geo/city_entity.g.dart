// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CityEntity _$CityEntityFromJson(Map<String, dynamic> json) => _CityEntity(
      id: json['id'] as String,
      countryId: json['countryId'] as String,
      regionId: json['regionId'] as String,
      name: json['name'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      timezoneOverride: json['timezoneOverride'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CityEntityToJson(_CityEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'countryId': instance.countryId,
      'regionId': instance.regionId,
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
      'timezoneOverride': instance.timezoneOverride,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
