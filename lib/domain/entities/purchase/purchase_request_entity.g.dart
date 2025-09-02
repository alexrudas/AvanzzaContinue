// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_request_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseRequestEntity _$PurchaseRequestEntityFromJson(
        Map<String, dynamic> json) =>
    _PurchaseRequestEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      assetId: json['assetId'] as String?,
      tipoRepuesto: json['tipoRepuesto'] as String,
      specs: json['specs'] as String?,
      cantidad: (json['cantidad'] as num).toInt(),
      ciudadEntrega: json['ciudadEntrega'] as String,
      proveedorIdsInvitados: (json['proveedorIdsInvitados'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      estado: json['estado'] as String,
      respuestasCount: (json['respuestasCount'] as num?)?.toInt() ?? 0,
      currencyCode: json['currencyCode'] as String,
      expectedDate: json['expectedDate'] == null
          ? null
          : DateTime.parse(json['expectedDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PurchaseRequestEntityToJson(
        _PurchaseRequestEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'assetId': instance.assetId,
      'tipoRepuesto': instance.tipoRepuesto,
      'specs': instance.specs,
      'cantidad': instance.cantidad,
      'ciudadEntrega': instance.ciudadEntrega,
      'proveedorIdsInvitados': instance.proveedorIdsInvitados,
      'estado': instance.estado,
      'respuestasCount': instance.respuestasCount,
      'currencyCode': instance.currencyCode,
      'expectedDate': instance.expectedDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
