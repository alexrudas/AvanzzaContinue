// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressEntity _$AddressEntityFromJson(Map<String, dynamic> json) =>
    _AddressEntity(
      countryId: json['countryId'] as String,
      regionId: json['regionId'] as String?,
      cityId: json['cityId'] as String?,
      line1: json['line1'] as String,
      line2: json['line2'] as String?,
      postalCode: json['postalCode'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AddressEntityToJson(_AddressEntity instance) =>
    <String, dynamic>{
      'countryId': instance.countryId,
      'regionId': instance.regionId,
      'cityId': instance.cityId,
      'line1': instance.line1,
      'line2': instance.line2,
      'postalCode': instance.postalCode,
      'lat': instance.lat,
      'lng': instance.lng,
    };
