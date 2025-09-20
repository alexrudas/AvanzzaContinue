import 'package:avanzza/domain/entities/user_profile_entity.dart' as domain;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/datetime_timestamp_converter.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

//TODO(10/09/2025): Comprobar que corra y comprobar que funcione el login

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String uid,
    required String phone,
    String? username,
    String? email,
    String? countryId,
    String? regionId,
    String? cityId,
    @Default(<String>[]) List<String> roles,
    @Default(<String>[]) List<String> orgIds,
    String? docType,
    String? docNumber,
    String? identityRaw,
    String? termsVersion,
    @DateTimeTimestampConverter() DateTime? termsAcceptedAt,
    @Default('active') String status,
    @DateTimeTimestampConverter() DateTime? createdAt,
    @DateTimeTimestampConverter() DateTime? updatedAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  factory UserProfileModel.fromFirestore(
      String uid, Map<String, dynamic> json) {
    return UserProfileModel.fromJson({...json, 'uid': uid});
  }
}

extension UserProfileModelX on UserProfileModel {
  domain.UserProfileEntity toEntity() => domain.UserProfileEntity(
        uid: uid,
        phone: phone,
        username: username,
        email: email,
        countryId: countryId,
        regionId: regionId,
        cityId: cityId,
        roles: roles,
        orgIds: orgIds,
        docType: docType,
        docNumber: docNumber,
        identityRaw: identityRaw,
        termsVersion: termsVersion,
        termsAcceptedAt: termsAcceptedAt,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// @Collection()
// class UserProfileCacheModel {
//   Id? isarId;
//   @Index(unique: true, replace: true)
//   late String uid;
//   late String phone;
//   String? countryId;
//   String? cityId;
//   List<String> roles = const [];
//   List<String> orgIds = const [];
//   String status = 'active';
//   DateTime? createdAt;
//   DateTime? updatedAt;

//   UserProfileCacheModel();

//   factory UserProfileCacheModel.fromModel(UserProfileModel m) {
//     final c = UserProfileCacheModel();
//     c.uid = m.uid;
//     c.phone = m.phone;
//     c.countryId = m.countryId;
//     c.cityId = m.cityId;
//     c.roles = m.roles;
//     c.orgIds = m.orgIds;
//     c.status = m.status;
//     c.createdAt = m.createdAt;
//     c.updatedAt = m.updatedAt;
//     return c;
//   }

//   UserProfileModel toModel() => UserProfileModel(
//         uid: uid,
//         phone: phone,
//         countryId: countryId,
//         cityId: cityId,
//         roles: roles,
//         orgIds: orgIds,
//         status: status,
//         createdAt: createdAt,
//         updatedAt: updatedAt,
//       );

//   domain.UserProfileEntity toEntity() => domain.UserProfileEntity(
//         uid: uid,
//         phone: phone,
//         countryId: countryId,
//         cityId: cityId,
//         roles: roles,
//         orgIds: orgIds,
//         status: status,
//         createdAt: createdAt,
//         updatedAt: updatedAt,
//       );
// }
