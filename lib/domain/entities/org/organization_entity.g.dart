// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrganizationEntity _$OrganizationEntityFromJson(Map<String, dynamic> json) =>
    _OrganizationEntity(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      tipo: json['tipo'] as String,
      countryId: json['countryId'] as String,
      regionId: json['regionId'] as String?,
      cityId: json['cityId'] as String?,
      ownerUid: json['ownerUid'] as String?,
      logoUrl: json['logoUrl'] as String?,
      nitOrTaxId: json['nitOrTaxId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$OrganizationEntityToJson(_OrganizationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'tipo': instance.tipo,
      'countryId': instance.countryId,
      'regionId': instance.regionId,
      'cityId': instance.cityId,
      'ownerUid': instance.ownerUid,
      'logoUrl': instance.logoUrl,
      'nitOrTaxId': instance.nitOrTaxId,
      'metadata': instance.metadata,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
