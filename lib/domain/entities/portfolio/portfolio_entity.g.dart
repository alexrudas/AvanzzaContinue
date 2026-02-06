// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PortfolioEntity _$PortfolioEntityFromJson(Map<String, dynamic> json) =>
    _PortfolioEntity(
      id: json['id'] as String,
      portfolioType: $enumDecode(_$PortfolioTypeEnumMap, json['portfolioType']),
      portfolioName: json['portfolioName'] as String,
      countryId: json['countryId'] as String,
      cityId: json['cityId'] as String,
      status: $enumDecodeNullable(_$PortfolioStatusEnumMap, json['status']) ??
          PortfolioStatus.draft,
      assetsCount: (json['assetsCount'] as num?)?.toInt() ?? 0,
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PortfolioEntityToJson(_PortfolioEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'portfolioType': _$PortfolioTypeEnumMap[instance.portfolioType]!,
      'portfolioName': instance.portfolioName,
      'countryId': instance.countryId,
      'cityId': instance.cityId,
      'status': _$PortfolioStatusEnumMap[instance.status]!,
      'assetsCount': instance.assetsCount,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PortfolioTypeEnumMap = {
  PortfolioType.vehiculos: 'VEHICULOS',
  PortfolioType.inmuebles: 'INMUEBLES',
  PortfolioType.operacionGeneral: 'OPERACION_GENERAL',
};

const _$PortfolioStatusEnumMap = {
  PortfolioStatus.draft: 'DRAFT',
  PortfolioStatus.active: 'ACTIVE',
};
