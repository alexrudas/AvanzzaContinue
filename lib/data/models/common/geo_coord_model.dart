import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/common/geo_coord.dart' as domain;

part 'geo_coord_model.g.dart';

@embedded
@JsonSerializable()
class GeoCoordModel {
  double? lat;
  double? lng;

  GeoCoordModel({this.lat, this.lng});

  factory GeoCoordModel.fromJson(Map<String, dynamic> json) =>
      _$GeoCoordModelFromJson(json);
  Map<String, dynamic> toJson() => _$GeoCoordModelToJson(this);

  factory GeoCoordModel.fromEntity(domain.GeoCoord e) =>
      GeoCoordModel(lat: e.lat, lng: e.lng);

  domain.GeoCoord toEntity() => domain.GeoCoord(
        lat: lat!,  // asegúrate de setearlos antes de usar
        lng: lng!,
      );
}
