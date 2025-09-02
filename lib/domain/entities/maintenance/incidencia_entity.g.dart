// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incidencia_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IncidenciaEntity _$IncidenciaEntityFromJson(Map<String, dynamic> json) =>
    _IncidenciaEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      assetId: json['assetId'] as String,
      descripcion: json['descripcion'] as String,
      fotosUrls: (json['fotosUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      prioridad: json['prioridad'] as String?,
      estado: json['estado'] as String,
      reportedBy: json['reportedBy'] as String,
      cityId: json['cityId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$IncidenciaEntityToJson(_IncidenciaEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'assetId': instance.assetId,
      'descripcion': instance.descripcion,
      'fotosUrls': instance.fotosUrls,
      'prioridad': instance.prioridad,
      'estado': instance.estado,
      'reportedBy': instance.reportedBy,
      'cityId': instance.cityId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
