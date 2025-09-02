// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_vehiculo_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetVehiculoEntity _$AssetVehiculoEntityFromJson(Map<String, dynamic> json) =>
    _AssetVehiculoEntity(
      assetId: json['assetId'] as String,
      refCode: json['refCode'] as String,
      placa: json['placa'] as String,
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      anio: (json['anio'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssetVehiculoEntityToJson(
        _AssetVehiculoEntity instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'refCode': instance.refCode,
      'placa': instance.placa,
      'marca': instance.marca,
      'modelo': instance.modelo,
      'anio': instance.anio,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
