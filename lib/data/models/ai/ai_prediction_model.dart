import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/ai/ai_prediction_entity.dart' as domain;

part 'ai_prediction_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class AIPredictionModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String orgId;
  @Index()
  final String tipo;
  @Index()
  final String targetId;
  final double score;
  final String explicacion;
  final List<String> recomendaciones;
  @Index()
  final DateTime createdAt;
  final DateTime? updatedAt;

  AIPredictionModel({
    this.isarId,
    required this.id,
    required this.orgId,
    required this.tipo,
    required this.targetId,
    required this.score,
    required this.explicacion,
    this.recomendaciones = const [],
    required this.createdAt,
    this.updatedAt,
  });

  factory AIPredictionModel.fromJson(Map<String, dynamic> json) =>
      _$AIPredictionModelFromJson(json);
  Map<String, dynamic> toJson() => _$AIPredictionModelToJson(this);
  factory AIPredictionModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      AIPredictionModel.fromJson({...json, 'id': docId});

  factory AIPredictionModel.fromEntity(domain.AIPredictionEntity e) =>
      AIPredictionModel(
        id: e.id,
        orgId: e.orgId,
        tipo: e.tipo,
        targetId: e.targetId,
        score: e.score,
        explicacion: e.explicacion,
        recomendaciones: e.recomendaciones,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.AIPredictionEntity toEntity() => domain.AIPredictionEntity(
        id: id,
        orgId: orgId,
        tipo: tipo,
        targetId: targetId,
        score: score,
        explicacion: explicacion,
        recomendaciones: recomendaciones,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
