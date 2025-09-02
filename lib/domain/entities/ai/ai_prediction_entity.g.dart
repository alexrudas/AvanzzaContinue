// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_prediction_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AIPredictionEntity _$AIPredictionEntityFromJson(Map<String, dynamic> json) =>
    _AIPredictionEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      tipo: json['tipo'] as String,
      targetId: json['targetId'] as String,
      score: (json['score'] as num).toDouble(),
      explicacion: json['explicacion'] as String,
      recomendaciones: (json['recomendaciones'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AIPredictionEntityToJson(_AIPredictionEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'tipo': instance.tipo,
      'targetId': instance.targetId,
      'score': instance.score,
      'explicacion': instance.explicacion,
      'recomendaciones': instance.recomendaciones,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
