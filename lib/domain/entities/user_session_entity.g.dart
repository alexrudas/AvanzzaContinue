// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSessionEntity _$UserSessionEntityFromJson(Map<String, dynamic> json) =>
    _UserSessionEntity(
      uid: json['uid'] as String,
      idToken: json['idToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      deviceId: json['deviceId'] as String?,
      lastLoginAt:
          const DateTimeTimestampConverter().fromJson(json['lastLoginAt']),
      activeContext: json['activeContext'] as Map<String, dynamic>?,
      featureFlags: json['featureFlags'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserSessionEntityToJson(_UserSessionEntity instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'idToken': instance.idToken,
      'refreshToken': instance.refreshToken,
      'deviceId': instance.deviceId,
      'lastLoginAt':
          const DateTimeTimestampConverter().toJson(instance.lastLoginAt),
      'activeContext': instance.activeContext,
      'featureFlags': instance.featureFlags,
    };
