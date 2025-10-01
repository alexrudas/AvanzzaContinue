import 'package:freezed_annotation/freezed_annotation.dart';

import 'provider_profile.dart';

part 'membership_entity.freezed.dart';
part 'membership_entity.g.dart';

@freezed
abstract class MembershipEntity with _$MembershipEntity {
  const factory MembershipEntity({
    required String userId,
    required String orgId,
    required String orgName,
    @Default(<String>[]) List<String> roles,
    @Default(<ProviderProfile>[]) List<ProviderProfile> providerProfiles,
    required String estatus, // activo | inactivo | invited | suspended | left
    required Map<String, String>
        primaryLocation, // { countryId, regionId?, cityId? }
    bool? isOwner,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MembershipEntity;

  factory MembershipEntity.fromJson(Map<String, dynamic> json) =>
      _$MembershipEntityFromJson(json);
}
