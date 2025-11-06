// lib/data/models/workspace/workspace_state_model.dart
import 'package:isar_community/isar.dart';

part 'workspace_state_model.g.dart';

/// Modelo de estado persistente del workspace con MRU queue
/// Singleton en Isar con id = 1
@Collection()
class WorkspaceStateModel {
  Id id = 1; // Singleton: siempre id = 1

  /// ID del workspace activo actualmente
  String? activeWorkspaceId;

  /// Most Recently Used queue (máximo 5 elementos)
  /// Ordenado de más reciente a menos reciente
  List<String> mruQueue = [];

  /// Timestamp de última actualización
  DateTime? updatedAt;

  // Para JSON (SharedPreferences fallback)
  Map<String, dynamic> toJson() {
    return {
      'activeWorkspaceId': activeWorkspaceId,
      'mruQueue': mruQueue,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static WorkspaceStateModel fromJson(Map<String, dynamic> json) {
    return WorkspaceStateModel()
      ..activeWorkspaceId = json['activeWorkspaceId'] as String?
      ..mruQueue = (json['mruQueue'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          []
      ..updatedAt = json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null;
  }
}