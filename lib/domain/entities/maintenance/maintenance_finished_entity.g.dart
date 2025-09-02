// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_finished_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MaintenanceFinishedEntity _$MaintenanceFinishedEntityFromJson(
        Map<String, dynamic> json) =>
    _MaintenanceFinishedEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      assetId: json['assetId'] as String,
      descripcion: json['descripcion'] as String,
      fechaFin: DateTime.parse(json['fechaFin'] as String),
      costoTotal: (json['costoTotal'] as num).toDouble(),
      itemsUsados: (json['itemsUsados'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      comprobantesUrls: (json['comprobantesUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      cityId: json['cityId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MaintenanceFinishedEntityToJson(
        _MaintenanceFinishedEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'assetId': instance.assetId,
      'descripcion': instance.descripcion,
      'fechaFin': instance.fechaFin.toIso8601String(),
      'costoTotal': instance.costoTotal,
      'itemsUsados': instance.itemsUsados,
      'comprobantesUrls': instance.comprobantesUrls,
      'cityId': instance.cityId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
