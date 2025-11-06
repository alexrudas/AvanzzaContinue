// lib/data/models/workspace/workspace_lite_model.dart
import 'package:isar_community/isar.dart';
import '../../../domain/entities/workspace/workspace_lite_entity.dart';

part 'workspace_lite_model.g.dart';

/// Modelo Isar para WorkspaceLite con soporte de persistencia local
@Collection()
class WorkspaceLiteModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String workspaceId; // El ID real del workspace (e.g., "Administrador")

  late String name;
  String? subtitle;
  String? iconName;
  DateTime? lastUsed;

  // Mapper a entidad
  WorkspaceLiteEntity toEntity() {
    return WorkspaceLiteEntity(
      id: workspaceId,
      name: name,
      subtitle: subtitle,
      iconName: iconName,
      lastUsed: lastUsed,
    );
  }

  // Factory desde entidad
  static WorkspaceLiteModel fromEntity(WorkspaceLiteEntity entity) {
    return WorkspaceLiteModel()
      ..workspaceId = entity.id
      ..name = entity.name
      ..subtitle = entity.subtitle
      ..iconName = entity.iconName
      ..lastUsed = entity.lastUsed;
  }

  // Para serializar a JSON (SharedPreferences fallback)
  Map<String, dynamic> toJson() {
    return {
      'id': workspaceId,
      'name': name,
      'subtitle': subtitle,
      'iconName': iconName,
      'lastUsed': lastUsed?.toIso8601String(),
    };
  }

  // Desde JSON (SharedPreferences fallback)
  static WorkspaceLiteModel fromJson(Map<String, dynamic> json) {
    return WorkspaceLiteModel()
      ..workspaceId = json['id'] as String
      ..name = json['name'] as String
      ..subtitle = json['subtitle'] as String?
      ..iconName = json['iconName'] as String?
      ..lastUsed = json['lastUsed'] != null
          ? DateTime.parse(json['lastUsed'] as String)
          : null;
  }
}