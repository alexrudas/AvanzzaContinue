// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_purchase_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InsurancePurchaseEntity _$InsurancePurchaseEntityFromJson(
        Map<String, dynamic> json) =>
    _InsurancePurchaseEntity(
      id: json['id'] as String,
      assetId: json['assetId'] as String,
      compradorId: json['compradorId'] as String,
      orgId: json['orgId'] as String,
      contactEmail: json['contactEmail'] as String,
      address: AddressEntity.fromJson(json['address'] as Map<String, dynamic>),
      currencyCode: json['currencyCode'] as String,
      estadoCompra: json['estadoCompra'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InsurancePurchaseEntityToJson(
        _InsurancePurchaseEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assetId': instance.assetId,
      'compradorId': instance.compradorId,
      'orgId': instance.orgId,
      'contactEmail': instance.contactEmail,
      'address': instance.address,
      'currencyCode': instance.currencyCode,
      'estadoCompra': instance.estadoCompra,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
