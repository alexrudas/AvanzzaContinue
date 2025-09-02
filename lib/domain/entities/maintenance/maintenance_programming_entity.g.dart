// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_programming_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MaintenanceProgrammingEntity _$MaintenanceProgrammingEntityFromJson(
        Map<String, dynamic> json) =>
    _MaintenanceProgrammingEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      assetId: json['assetId'] as String,
      incidenciasIds: (json['incidenciasIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      programmingDates: (json['programmingDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const <DateTime>[],
      assignedToTechId: json['assignedToTechId'] as String?,
      notes: json['notes'] as String?,
      cityId: json['cityId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MaintenanceProgrammingEntityToJson(
        _MaintenanceProgrammingEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'assetId': instance.assetId,
      'incidenciasIds': instance.incidenciasIds,
      'programmingDates':
          instance.programmingDates.map((e) => e.toIso8601String()).toList(),
      'assignedToTechId': instance.assignedToTechId,
      'notes': instance.notes,
      'cityId': instance.cityId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
