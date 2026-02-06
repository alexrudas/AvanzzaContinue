import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_advisor_entity.freezed.dart';
part 'ai_advisor_entity.g.dart';

@freezed
abstract class AIAdvisorEntity with _$AIAdvisorEntity {
  const factory AIAdvisorEntity({
    @Default('') String id, // se completa con doc.id fuera del JSON
    required String orgId,
    required String userId,
    required String modulo,
    required String inputText,
    Map<String, dynamic>? structuredContext,
    String? outputText,
    @Default(<String>[]) List<String> suggestions,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AIAdvisorEntity;

  // anota el GETTER para excluir de JSON
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get id;

  factory AIAdvisorEntity.fromJson(Map<String, dynamic> json) =>
      _$AIAdvisorEntityFromJson(json);
}
