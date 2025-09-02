// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_response_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupplierResponseEntity _$SupplierResponseEntityFromJson(
        Map<String, dynamic> json) =>
    _SupplierResponseEntity(
      id: json['id'] as String,
      purchaseRequestId: json['purchaseRequestId'] as String,
      proveedorId: json['proveedorId'] as String,
      precio: (json['precio'] as num).toDouble(),
      disponibilidad: json['disponibilidad'] as String,
      currencyCode: json['currencyCode'] as String,
      catalogoUrl: json['catalogoUrl'] as String?,
      notas: json['notas'] as String?,
      leadTimeDays: (json['leadTimeDays'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SupplierResponseEntityToJson(
        _SupplierResponseEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'purchaseRequestId': instance.purchaseRequestId,
      'proveedorId': instance.proveedorId,
      'precio': instance.precio,
      'disponibilidad': instance.disponibilidad,
      'currencyCode': instance.currencyCode,
      'catalogoUrl': instance.catalogoUrl,
      'notas': instance.notas,
      'leadTimeDays': instance.leadTimeDays,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
