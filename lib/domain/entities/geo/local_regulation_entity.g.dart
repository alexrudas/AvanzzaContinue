// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_regulation_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PicoYPlacaRule _$PicoYPlacaRuleFromJson(Map<String, dynamic> json) =>
    _PicoYPlacaRule(
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      digitsRestricted: (json['digitsRestricted'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$PicoYPlacaRuleToJson(_PicoYPlacaRule instance) =>
    <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'digitsRestricted': instance.digitsRestricted,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'notes': instance.notes,
    };

_LocalRegulationEntity _$LocalRegulationEntityFromJson(
        Map<String, dynamic> json) =>
    _LocalRegulationEntity(
      id: json['id'] as String,
      countryId: json['countryId'] as String,
      cityId: json['cityId'] as String,
      picoYPlacaRules: (json['picoYPlacaRules'] as List<dynamic>?)
              ?.map((e) => PicoYPlacaRule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PicoYPlacaRule>[],
      circulationExceptions: (json['circulationExceptions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      maintenanceBlackoutDates:
          (json['maintenanceBlackoutDates'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const <String>[],
      updatedBy: json['updatedBy'] as String,
      sourceUrl: json['sourceUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LocalRegulationEntityToJson(
        _LocalRegulationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'countryId': instance.countryId,
      'cityId': instance.cityId,
      'picoYPlacaRules':
          instance.picoYPlacaRules.map((e) => e.toJson()).toList(),
      'circulationExceptions': instance.circulationExceptions,
      'maintenanceBlackoutDates': instance.maintenanceBlackoutDates,
      'updatedBy': instance.updatedBy,
      'sourceUrl': instance.sourceUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
