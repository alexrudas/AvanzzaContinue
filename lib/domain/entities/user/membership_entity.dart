import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership_entity.freezed.dart';
part 'membership_entity.g.dart';

@freezed
  @JsonSerializable(explicitToJson: true)
abstract class MembershipEntity with _$MembershipEntity {
  const factory MembershipEntity({
    required String userId,
    required String orgId,
    required String orgName,
    @Default(<String>[]) List<String> roles,
    required String estatus, // activo | inactivo
    required Map<String, String> primaryLocation, // { countryId, regionId?, cityId? }
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MembershipEntity;

  factory MembershipEntity.fromJson(Map<String, dynamic> json) => _$MembershipEntityFromJson(json);
}
