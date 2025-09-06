import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_entity.freezed.dart';
part 'organization_entity.g.dart';

@freezed
abstract class OrganizationEntity with _$OrganizationEntity {
  const factory OrganizationEntity({
    required String id,
    required String nombre,
    required String tipo, // empresa | personal
    required String countryId,
    String? regionId,
    String? cityId,
    String? ownerUid,
    String? logoUrl,
    Map<String, dynamic>? metadata,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _OrganizationEntity;

  factory OrganizationEntity.fromJson(Map<String, dynamic> json) =>
      _$OrganizationEntityFromJson(json);
}
