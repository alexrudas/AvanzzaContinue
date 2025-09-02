import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_prediction_entity.freezed.dart';
part 'ai_prediction_entity.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
abstract class AIPredictionEntity with _$AIPredictionEntity {
  const factory AIPredictionEntity({
    required String id,
    required String orgId,
    required String tipo, // fallas | compras | riesgos | contabilidad
    required String targetId, // assetId, purchaseId, etc
    required double score,
    required String explicacion,
    @Default(<String>[]) List<String> recomendaciones,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AIPredictionEntity;

  factory AIPredictionEntity.fromJson(Map<String, dynamic> json) =>
      _$AIPredictionEntityFromJson(json);
}
