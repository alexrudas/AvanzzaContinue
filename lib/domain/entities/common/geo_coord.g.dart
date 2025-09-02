// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_coord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeoCoord _$GeoCoordFromJson(Map<String, dynamic> json) => _GeoCoord(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$GeoCoordToJson(_GeoCoord instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
