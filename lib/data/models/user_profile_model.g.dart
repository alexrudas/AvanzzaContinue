// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      uid: json['uid'] as String,
      phone: json['phone'] as String,
      countryId: json['countryId'] as String?,
      cityId: json['cityId'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      orgIds: (json['orgIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      status: json['status'] as String? ?? 'active',
      createdAt: const DateTimeTimestampConverter().fromJson(json['createdAt']),
      updatedAt: const DateTimeTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'phone': instance.phone,
      'countryId': instance.countryId,
      'cityId': instance.cityId,
      'roles': instance.roles,
      'orgIds': instance.orgIds,
      'status': instance.status,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const DateTimeTimestampConverter().toJson(instance.updatedAt),
    };
