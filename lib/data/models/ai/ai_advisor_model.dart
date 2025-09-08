import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/ai/ai_advisor_entity.dart' as domain;

part 'ai_advisor_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class AIAdvisorModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String orgId;
  @Index()
  final String userId;
  @Index()
  final String modulo;
  final String inputText;
  @ignore
  final Map<String, dynamic>? structuredContext;
  final String? outputText;
  final List<String> suggestions;
  @Index()
  @DateTimeTimestampConverter()
  final DateTime createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  AIAdvisorModel({
    this.isarId,
    required this.id,
    required this.orgId,
    required this.userId,
    required this.modulo,
    required this.inputText,
    this.structuredContext,
    this.outputText,
    this.suggestions = const [],
    required this.createdAt,
    this.updatedAt,
  });

  factory AIAdvisorModel.fromJson(Map<String, dynamic> json) =>
      _$AIAdvisorModelFromJson(json);
  Map<String, dynamic> toJson() => _$AIAdvisorModelToJson(this);
  factory AIAdvisorModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      AIAdvisorModel.fromJson({...json, 'id': docId});

  factory AIAdvisorModel.fromEntity(domain.AIAdvisorEntity e) => AIAdvisorModel(
        id: e.id,
        orgId: e.orgId,
        userId: e.userId,
        modulo: e.modulo,
        inputText: e.inputText,
        structuredContext: e.structuredContext,
        outputText: e.outputText,
        suggestions: e.suggestions,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.AIAdvisorEntity toEntity() => domain.AIAdvisorEntity(
        id: id,
        orgId: orgId,
        userId: userId,
        modulo: modulo,
        inputText: inputText,
        structuredContext: structuredContext,
        outputText: outputText,
        suggestions: suggestions,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
