// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetEntity _$AssetEntityFromJson(Map<String, dynamic> json) => _AssetEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      portfolioId: json['portfolioId'] as String?,
      assetType: json['assetType'] as String,
      assetSegmentId: json['assetSegmentId'] as String?,
      countryId: json['countryId'] as String,
      regionId: json['regionId'] as String?,
      cityId: json['cityId'] as String?,
      ownerType: json['ownerType'] as String,
      ownerId: json['ownerId'] as String,
      estado: json['estado'] as String,
      etiquetas: (json['etiquetas'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      fotosUrls: (json['fotosUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      access: (json['access'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const <Map<String, dynamic>>[],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssetEntityToJson(_AssetEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'portfolioId': instance.portfolioId,
      'assetType': instance.assetType,
      'assetSegmentId': instance.assetSegmentId,
      'countryId': instance.countryId,
      'regionId': instance.regionId,
      'cityId': instance.cityId,
      'ownerType': instance.ownerType,
      'ownerId': instance.ownerId,
      'estado': instance.estado,
      'etiquetas': instance.etiquetas,
      'fotosUrls': instance.fotosUrls,
      'access': instance.access,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
