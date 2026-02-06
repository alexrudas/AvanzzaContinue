import 'package:freezed_annotation/freezed_annotation.dart';

part 'region_entity.freezed.dart';
part 'region_entity.g.dart';

@freezed
abstract class RegionEntity with _$RegionEntity {
  const factory RegionEntity({
    required String id,
    required String countryId,
    required String name,
    String? code,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RegionEntity;

  factory RegionEntity.fromJson(Map<String, dynamic> json) =>
      _$RegionEntityFromJson(json);
}
