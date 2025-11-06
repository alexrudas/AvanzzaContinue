// lib/domain/repositories/workspace_repository.dart
import '../entities/workspace/workspace_lite_entity.dart';

/// Repositorio de workspace con persistencia en Isar y fallback en SharedPreferences
/// Maneja estado activo, MRU queue y operaciones de eliminación
abstract class WorkspaceRepository {
  /// Lista todos los workspaces disponibles ordenados alfabéticamente
  Future<List<WorkspaceLiteEntity>> listWorkspaces();

  /// Obtiene el workspace actualmente activo
  Future<String?> getActiveWorkspaceId();

  /// Establece un workspace como activo y actualiza MRU
  Future<void> setActiveWorkspace(String id);

  /// Elimina un workspace (marca como borrado o elimina físicamente)
  Future<void> deleteWorkspace(String id);

  /// Inserta o actualiza un workspace en la cola MRU (Most Recently Used)
  /// Pushfront sin duplicados, límite 5
  Future<void> upsertMRU(String id);

  /// Obtiene la cola MRU actual
  Future<List<String>> getMRUQueue();

  /// Crea o actualiza un workspace
  Future<void> upsertWorkspace(WorkspaceLiteEntity workspace);

  /// Sincroniza workspaces desde el SessionContextController
  /// Convierte roles/memberships a WorkspaceLite
  Future<void> syncFromMemberships(List<String> roles);

  /// Limpia completamente el estado (útil para logout)
  Future<void> clearState();
}
