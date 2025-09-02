// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_process_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MaintenanceProcessEntity _$MaintenanceProcessEntityFromJson(
        Map<String, dynamic> json) =>
    _MaintenanceProcessEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      assetId: json['assetId'] as String,
      descripcion: json['descripcion'] as String,
      tecnicoId: json['tecnicoId'] as String,
      estado: json['estado'] as String? ?? 'en_proceso',
      startedAt: DateTime.parse(json['startedAt'] as String),
      purchaseRequestId: json['purchaseRequestId'] as String?,
      cityId: json['cityId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MaintenanceProcessEntityToJson(
        _MaintenanceProcessEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'assetId': instance.assetId,
      'descripcion': instance.descripcion,
      'tecnicoId': instance.tecnicoId,
      'estado': instance.estado,
      'startedAt': instance.startedAt.toIso8601String(),
      'purchaseRequestId': instance.purchaseRequestId,
      'cityId': instance.cityId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
