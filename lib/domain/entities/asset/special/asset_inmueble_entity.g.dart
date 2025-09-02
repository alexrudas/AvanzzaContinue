// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_inmueble_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetInmuebleEntity _$AssetInmuebleEntityFromJson(Map<String, dynamic> json) =>
    _AssetInmuebleEntity(
      assetId: json['assetId'] as String,
      matriculaInmobiliaria: json['matriculaInmobiliaria'] as String,
      estrato: (json['estrato'] as num?)?.toInt(),
      metrosCuadrados: (json['metrosCuadrados'] as num?)?.toDouble(),
      uso: json['uso'] as String,
      valorCatastral: (json['valorCatastral'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssetInmuebleEntityToJson(
        _AssetInmuebleEntity instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'matriculaInmobiliaria': instance.matriculaInmobiliaria,
      'estrato': instance.estrato,
      'metrosCuadrados': instance.metrosCuadrados,
      'uso': instance.uso,
      'valorCatastral': instance.valorCatastral,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
