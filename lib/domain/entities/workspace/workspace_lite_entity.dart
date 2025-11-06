import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_lite_entity.freezed.dart';
part 'workspace_lite_entity.g.dart';

/// Entidad ligera de workspace para operaciones de selección y MRU
/// Incluye lastUsed para ordenamiento MRU preciso
@freezed
abstract class WorkspaceLiteEntity with _$WorkspaceLiteEntity {
  const factory WorkspaceLiteEntity({
    required String id,
    required String name,
    String? subtitle,
    String? iconName,
    DateTime? lastUsed,
  }) = _WorkspaceLiteEntity;

  factory WorkspaceLiteEntity.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceLiteEntityFromJson(json);
}
