// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_maquinaria_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetMaquinariaEntity _$AssetMaquinariaEntityFromJson(
        Map<String, dynamic> json) =>
    _AssetMaquinariaEntity(
      assetId: json['assetId'] as String,
      serie: json['serie'] as String,
      marca: json['marca'] as String,
      capacidad: json['capacidad'] as String,
      categoria: json['categoria'] as String,
      certificadoOperacion: json['certificadoOperacion'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssetMaquinariaEntityToJson(
        _AssetMaquinariaEntity instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'serie': instance.serie,
      'marca': instance.marca,
      'capacidad': instance.capacidad,
      'categoria': instance.categoria,
      'certificadoOperacion': instance.certificadoOperacion,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
