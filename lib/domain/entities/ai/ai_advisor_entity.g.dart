// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_advisor_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AIAdvisorEntity _$AIAdvisorEntityFromJson(Map<String, dynamic> json) =>
    _AIAdvisorEntity(
      id: json['id'] as String? ?? '',
      orgId: json['orgId'] as String,
      userId: json['userId'] as String,
      modulo: json['modulo'] as String,
      inputText: json['inputText'] as String,
      structuredContext: json['structuredContext'] as Map<String, dynamic>?,
      outputText: json['outputText'] as String?,
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AIAdvisorEntityToJson(_AIAdvisorEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'userId': instance.userId,
      'modulo': instance.modulo,
      'inputText': instance.inputText,
      'structuredContext': instance.structuredContext,
      'outputText': instance.outputText,
      'suggestions': instance.suggestions,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
