// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_request_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseRequestItemEntity _$PurchaseRequestItemEntityFromJson(
        Map<String, dynamic> json) =>
    _PurchaseRequestItemEntity(
      id: json['id'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as num,
      unit: json['unit'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$PurchaseRequestItemEntityToJson(
        _PurchaseRequestItemEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'notes': instance.notes,
    };

_PurchaseRequestDeliveryEntity _$PurchaseRequestDeliveryEntityFromJson(
        Map<String, dynamic> json) =>
    _PurchaseRequestDeliveryEntity(
      department: json['department'] as String?,
      city: json['city'] as String,
      address: json['address'] as String,
      info: json['info'] as String?,
    );

Map<String, dynamic> _$PurchaseRequestDeliveryEntityToJson(
        _PurchaseRequestDeliveryEntity instance) =>
    <String, dynamic>{
      'department': instance.department,
      'city': instance.city,
      'address': instance.address,
      'info': instance.info,
    };

_PurchaseRequestEntity _$PurchaseRequestEntityFromJson(
        Map<String, dynamic> json) =>
    _PurchaseRequestEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$PurchaseRequestTypeInputEnumMap, json['type']),
      category: json['category'] as String?,
      originType:
          $enumDecode(_$PurchaseRequestOriginInputEnumMap, json['originType']),
      assetId: json['assetId'] as String?,
      notes: json['notes'] as String?,
      delivery: json['delivery'] == null
          ? null
          : PurchaseRequestDeliveryEntity.fromJson(
              json['delivery'] as Map<String, dynamic>),
      itemsCount: (json['itemsCount'] as num?)?.toInt() ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) =>
                  PurchaseRequestItemEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PurchaseRequestItemEntity>[],
      vendorContactIds: (json['vendorContactIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      status: json['status'] as String,
      respuestasCount: (json['respuestasCount'] as num?)?.toInt() ?? 0,
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
      'title': instance.title,
      'type': _$PurchaseRequestTypeInputEnumMap[instance.type]!,
      'category': instance.category,
      'originType': _$PurchaseRequestOriginInputEnumMap[instance.originType]!,
      'assetId': instance.assetId,
      'notes': instance.notes,
      'delivery': instance.delivery,
      'itemsCount': instance.itemsCount,
      'items': instance.items,
      'vendorContactIds': instance.vendorContactIds,
      'status': instance.status,
      'respuestasCount': instance.respuestasCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PurchaseRequestTypeInputEnumMap = {
  PurchaseRequestTypeInput.product: 'product',
  PurchaseRequestTypeInput.service: 'service',
};

const _$PurchaseRequestOriginInputEnumMap = {
  PurchaseRequestOriginInput.asset: 'asset',
  PurchaseRequestOriginInput.inventory: 'inventory',
  PurchaseRequestOriginInput.general: 'general',
};
