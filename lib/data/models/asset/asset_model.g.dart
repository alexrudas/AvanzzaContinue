// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetModel _$AssetModelFromJson(Map<String, dynamic> json) => AssetModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      assetType: json['assetType'] as String,
      countryId: json['countryId'] as String,
      regionId: json['regionId'] as String?,
      cityId: json['cityId'] as String?,
      ownerType: json['ownerType'] as String,
      ownerId: json['ownerId'] as String,
      estado: json['estado'] as String,
      etiquetas: (json['etiquetas'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      fotosUrls: (json['fotosUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      orgRefPath: json['orgRefPath'] as String?,
      ownerRefPath: json['ownerRefPath'] as String?,
      countryRefPath: json['countryRefPath'] as String?,
      regionRefPath: json['regionRefPath'] as String?,
      cityRefPath: json['cityRefPath'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssetModelToJson(AssetModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'orgId': instance.orgId,
      'assetType': instance.assetType,
      'countryId': instance.countryId,
      'regionId': instance.regionId,
      'cityId': instance.cityId,
      'ownerType': instance.ownerType,
      'ownerId': instance.ownerId,
      'estado': instance.estado,
      'etiquetas': instance.etiquetas,
      'fotosUrls': instance.fotosUrls,
      'orgRefPath': instance.orgRefPath,
      'ownerRefPath': instance.ownerRefPath,
      'countryRefPath': instance.countryRefPath,
      'regionRefPath': instance.regionRefPath,
      'cityRefPath': instance.cityRefPath,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
