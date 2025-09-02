import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo_coord.freezed.dart';
part 'geo_coord.g.dart';

@freezed
  @JsonSerializable(explicitToJson: true)
abstract class GeoCoord with _$GeoCoord {
  const factory GeoCoord({
    required double lat,
    required double lng,
  }) = _GeoCoord;

  factory GeoCoord.fromJson(Map<String, dynamic> json) => _$GeoCoordFromJson(json);
}
