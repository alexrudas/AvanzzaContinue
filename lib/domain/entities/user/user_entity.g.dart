// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => _UserEntity(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      tipoDoc: json['tipoDoc'] as String?,
      numDoc: json['numDoc'] as String?,
      countryId: json['countryId'] as String?,
      preferredLanguage: json['preferredLanguage'] as String?,
      activeContext: json['activeContext'] == null
          ? null
          : ActiveContext.fromJson(
              json['activeContext'] as Map<String, dynamic>),
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => AddressEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserEntityToJson(_UserEntity instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'tipoDoc': instance.tipoDoc,
      'numDoc': instance.numDoc,
      'countryId': instance.countryId,
      'preferredLanguage': instance.preferredLanguage,
      'activeContext': instance.activeContext,
      'addresses': instance.addresses,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
