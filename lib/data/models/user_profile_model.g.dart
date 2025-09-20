// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      uid: json['uid'] as String,
      phone: json['phone'] as String,
      username: json['username'] as String?,
      email: json['email'] as String?,
      countryId: json['countryId'] as String?,
      regionId: json['regionId'] as String?,
      cityId: json['cityId'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      orgIds: (json['orgIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      docType: json['docType'] as String?,
      docNumber: json['docNumber'] as String?,
      identityRaw: json['identityRaw'] as String?,
      termsVersion: json['termsVersion'] as String?,
      termsAcceptedAt:
          const DateTimeTimestampConverter().fromJson(json['termsAcceptedAt']),
      status: json['status'] as String? ?? 'active',
      createdAt: const DateTimeTimestampConverter().fromJson(json['createdAt']),
      updatedAt: const DateTimeTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'phone': instance.phone,
      'username': instance.username,
      'email': instance.email,
      'countryId': instance.countryId,
      'regionId': instance.regionId,
      'cityId': instance.cityId,
      'roles': instance.roles,
      'orgIds': instance.orgIds,
      'docType': instance.docType,
      'docNumber': instance.docNumber,
      'identityRaw': instance.identityRaw,
      'termsVersion': instance.termsVersion,
      'termsAcceptedAt':
          const DateTimeTimestampConverter().toJson(instance.termsAcceptedAt),
      'status': instance.status,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const DateTimeTimestampConverter().toJson(instance.updatedAt),
    };
