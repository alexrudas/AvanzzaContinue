import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/geo/city_entity.dart' as domain;

part 'city_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class CityModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String countryId;
  @Index()
  final String regionId;
  final String name;
  final double? lat;
  final double? lng;
  final String? timezoneOverride;
  @Index()
  final bool isActive;
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  CityModel({
    this.isarId,
    required this.id,
    required this.countryId,
    required this.regionId,
    required this.name,
    this.lat,
    this.lng,
    this.timezoneOverride,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
  Map<String, dynamic> toJson() => _$CityModelToJson(this);
  factory CityModel.fromFirestore(String docId, Map<String, dynamic> json) =>
      CityModel.fromJson({...json, 'id': docId});

  factory CityModel.fromEntity(domain.CityEntity e) => CityModel(
        id: e.id,
        countryId: e.countryId,
        regionId: e.regionId,
        name: e.name,
        lat: e.lat,
        lng: e.lng,
        timezoneOverride: e.timezoneOverride,
        isActive: e.isActive,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.CityEntity toEntity() => domain.CityEntity(
        id: id,
        countryId: countryId,
        regionId: regionId,
        name: name,
        lat: lat,
        lng: lng,
        timezoneOverride: timezoneOverride,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
