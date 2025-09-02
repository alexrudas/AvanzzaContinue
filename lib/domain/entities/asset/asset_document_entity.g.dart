// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_document_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetDocumentEntity _$AssetDocumentEntityFromJson(Map<String, dynamic> json) =>
    _AssetDocumentEntity(
      id: json['id'] as String,
      assetId: json['assetId'] as String,
      tipoDoc: json['tipoDoc'] as String,
      countryId: json['countryId'] as String,
      cityId: json['cityId'] as String?,
      fechaEmision: json['fechaEmision'] == null
          ? null
          : DateTime.parse(json['fechaEmision'] as String),
      fechaVencimiento: json['fechaVencimiento'] == null
          ? null
          : DateTime.parse(json['fechaVencimiento'] as String),
      estado: json['estado'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssetDocumentEntityToJson(
        _AssetDocumentEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assetId': instance.assetId,
      'tipoDoc': instance.tipoDoc,
      'countryId': instance.countryId,
      'cityId': instance.cityId,
      'fechaEmision': instance.fechaEmision?.toIso8601String(),
      'fechaVencimiento': instance.fechaVencimiento?.toIso8601String(),
      'estado': instance.estado,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
