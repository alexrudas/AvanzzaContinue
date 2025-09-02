// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_policy_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InsurancePolicyEntity _$InsurancePolicyEntityFromJson(
        Map<String, dynamic> json) =>
    _InsurancePolicyEntity(
      id: json['id'] as String,
      assetId: json['assetId'] as String,
      tipo: json['tipo'] as String,
      aseguradora: json['aseguradora'] as String,
      tarifaBase: (json['tarifaBase'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
      countryId: json['countryId'] as String,
      cityId: json['cityId'] as String?,
      fechaInicio: DateTime.parse(json['fechaInicio'] as String),
      fechaFin: DateTime.parse(json['fechaFin'] as String),
      estado: json['estado'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InsurancePolicyEntityToJson(
        _InsurancePolicyEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assetId': instance.assetId,
      'tipo': instance.tipo,
      'aseguradora': instance.aseguradora,
      'tarifaBase': instance.tarifaBase,
      'currencyCode': instance.currencyCode,
      'countryId': instance.countryId,
      'cityId': instance.cityId,
      'fechaInicio': instance.fechaInicio.toIso8601String(),
      'fechaFin': instance.fechaFin.toIso8601String(),
      'estado': instance.estado,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
