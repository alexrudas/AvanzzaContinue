// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verified_key_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerifiedKeyEntity _$VerifiedKeyEntityFromJson(Map<String, dynamic> json) =>
    _VerifiedKeyEntity(
      id: json['id'] as String,
      platformActorId: json['platformActorId'] as String,
      keyType: $enumDecode(_$VerifiedKeyTypeEnumMap, json['keyType']),
      keyValueNormalized: json['keyValueNormalized'] as String,
      verifiedAt: DateTime.parse(json['verifiedAt'] as String),
      verificationMethod:
          $enumDecode(_$VerificationMethodEnumMap, json['verificationMethod']),
      isPrimary: json['isPrimary'] as bool,
      revokedAt: json['revokedAt'] == null
          ? null
          : DateTime.parse(json['revokedAt'] as String),
      revokedReason: json['revokedReason'] as String?,
    );

Map<String, dynamic> _$VerifiedKeyEntityToJson(_VerifiedKeyEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'platformActorId': instance.platformActorId,
      'keyType': _$VerifiedKeyTypeEnumMap[instance.keyType]!,
      'keyValueNormalized': instance.keyValueNormalized,
      'verifiedAt': instance.verifiedAt.toIso8601String(),
      'verificationMethod':
          _$VerificationMethodEnumMap[instance.verificationMethod]!,
      'isPrimary': instance.isPrimary,
      'revokedAt': instance.revokedAt?.toIso8601String(),
      'revokedReason': instance.revokedReason,
    };

const _$VerifiedKeyTypeEnumMap = {
  VerifiedKeyType.phoneE164: 'phoneE164',
  VerifiedKeyType.email: 'email',
  VerifiedKeyType.docId: 'docId',
};

const _$VerificationMethodEnumMap = {
  VerificationMethod.otp: 'otp',
  VerificationMethod.magicLink: 'magicLink',
  VerificationMethod.docCheck: 'docCheck',
};
