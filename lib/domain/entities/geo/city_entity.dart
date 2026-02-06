import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_entity.freezed.dart';
part 'city_entity.g.dart';

@freezed
abstract class CityEntity with _$CityEntity {
  const factory CityEntity({
    required String id,
    required String countryId,
    required String regionId,
    required String name,
    double? lat,
    double? lng,
    String? timezoneOverride,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CityEntity;

  factory CityEntity.fromJson(Map<String, dynamic> json) =>
      _$CityEntityFromJson(json);
}
