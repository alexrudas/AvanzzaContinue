import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_advisor_entity.freezed.dart';
part 'ai_advisor_entity.g.dart';

@freezed
@JsonSerializable(explicitToJson: true) // <= aquí, sobre la clase
abstract class AIAdvisorEntity with _$AIAdvisorEntity {
  const factory AIAdvisorEntity({
    required String id,
    required String orgId,
    required String userId,
    required String modulo, // activos | mantenimiento | compras | contabilidad | seguros | chat
    required String inputText,
    Map<String, dynamic>? structuredContext,
    String? outputText,
    @Default(<String>[]) List<String> suggestions,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AIAdvisorEntity;

  factory AIAdvisorEntity.fromJson(Map<String, dynamic> json) =>
      _$AIAdvisorEntityFromJson(json);
}
