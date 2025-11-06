// lib/data/repositories/workspace_repository_impl.dart
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/workspace/workspace_lite_entity.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../models/workspace/workspace_lite_model.dart';
import '../models/workspace/workspace_state_model.dart';

/// Implementación del repositorio de workspaces
/// Persistencia primaria: Isar
/// Fallback: SharedPreferences
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final Isar isar;
  final Future<SharedPreferences> Function() prefsProvider;

  static const String _keyActiveWorkspace = 'workspace_active_id';
  static const String _keyMRUQueue = 'workspace_mru_queue';
  static const int _maxMRUSize = 5;

  WorkspaceRepositoryImpl({
    required this.isar,
    Future<SharedPreferences> Function()? prefsProvider,
  }) : prefsProvider = prefsProvider ?? SharedPreferences.getInstance;

  @override
  Future<List<WorkspaceLiteEntity>> listWorkspaces() async {
    try {
      final models = await isar.workspaceLiteModels
          .where()
          .sortByName()
          .findAll();

      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      debugPrint('[WorkspaceRepository] Error listing workspaces: $e');
      return [];
    }
  }

  @override
  Future<String?> getActiveWorkspaceId() async {
    try {
      // Intenta leer de Isar primero
      final state = await isar.workspaceStateModels.get(1);
      if (state?.activeWorkspaceId != null) {
        return state!.activeWorkspaceId;
      }

      // Fallback a SharedPreferences
      final prefs = await prefsProvider();
      return prefs.getString(_keyActiveWorkspace);
    } catch (e) {
      debugPrint('[WorkspaceRepository] Error getting active workspace: $e');
      return null;
    }
  }

  @override
  Future<void> setActiveWorkspace(String id) async {
    try {
      final now = DateTime.now().toUtc();

      // Actualizar Isar
      await isar.writeTxn(() async {
        var state = await isar.workspaceStateModels.get(1);
        state ??= WorkspaceStateModel();

        state.activeWorkspaceId = id;
        state.updatedAt = now;

        await isar.workspaceStateModels.put(state);

        // Actualizar lastUsed en el workspace
        final workspace = await isar.workspaceLiteModels
            .filter()
            .workspaceIdEqualTo(id)
            .findFirst();

        if (workspace != null) {
          workspace.lastUsed = now;
          await isar.workspaceLiteModels.put(workspace);
        }
      });

      // Actualizar MRU automáticamente
      await upsertMRU(id);

      // Fallback a SharedPreferences
      final prefs = await prefsProvider();
      await prefs.setString(_keyActiveWorkspace, id);
    } catch (e) {
      debugPrint('[WorkspaceRepository] Error setting active workspace: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteWorkspace(String id) async {
    try {
      await isar.writeTxn(() async {
        // Eliminar workspace
        final workspace = await isar.workspaceLiteModels
            .filter()
            .workspaceIdEqualTo(id)
            .findFirst();

        if (workspace != null) {
          await isar.workspaceLiteModels.delete(workspace.id);
        }

        // Limpiar de MRU
        var state = await isar.workspaceStateModels.get(1);
        if (state != null) {
          state.mruQueue.remove(id);
          state.updatedAt = DateTime.now().toUtc();
          await isar.workspaceStateModels.put(state);
        }
      });

      // Limpiar de SharedPreferences
      final prefs = await prefsProvider();
      final mruList = prefs.getStringList(_keyMRUQueue) ?? [];
      mruList.remove(id);
      await prefs.setStringList(_keyMRUQueue, mruList);
    } catch (e) {
      debugPrint('[WorkspaceRepository] Error deleting workspace: $e');
      rethrow;
    }
  }

  @override
  Future<void> upsertMRU(String id) async {
    try {
      await isar.writeTxn(() async {
        var state = await isar.workspaceStateModels.get(1);
        state ??= WorkspaceStateModel();

        // Remover si ya existe (para evitar duplicados)
        state.mruQueue.remove(id);

        // Agregar al inicio (más reciente)
        state.mruQueue.insert(0, id);

        // Limitar a máximo 5
        if (state.mruQueue.length > _maxMRUSize) {
          state.mruQueue = state.mruQueue.sublist(0, _maxMRUSize);
        }

        state.updatedAt = DateTime.now().toUtc();
        await isar.workspaceStateModels.put(state);
      });

      // Fallback a SharedPreferences
      final prefs = await prefsProvider();
      final mruList = prefs.getStringList(_keyMRUQueue) ?? [];
      mruList.remove(id);
      mruList.insert(0, id);

      if (mruList.length > _maxMRUSize) {
        mruList.removeRange(_maxMRUSize, mruList.length);
      }

      await prefs.setStringList(_keyMRUQueue, mruList);
    } catch (e) {
      debugPrint('[WorkspaceRepository] Error upserting MRU: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> getMRUQueue() async {
    try {
      // Intenta leer de Isar primero
      final state = await isar.workspaceStateModels.get(1);
      if (state != null && state.mruQueue.isNotEmpty) {
        return List<String>.from(state.mruQueue);
      }

      // Fallback a SharedPreferences
      final prefs = await prefsProvider();
      return prefs.getStringList(_keyMRUQueue) ?? [];
    } catch (e) {
      debugPrint('[WorkspaceRepository] Error getting MRU queue: $e');
      return [];
    }
  }

  @override
  Future<void> upsertWorkspace(WorkspaceLiteEntity workspace) async {
    try {
      final model = WorkspaceLiteModel.fromEntity(workspace);

      await isar.writeTxn(() async {
        // Buscar existente por workspaceId
        final existing = await isar.workspaceLiteModels
            .filter()
            .workspaceIdEqualTo(workspace.id)
            .findFirst();

        if (existing != null) {
          // Preservar el ID de Isar y actualizar campos
          model.id = existing.id;
        }

        await isar.workspaceLiteModels.put(model);
      });
    } catch (e) {
      debugPrint('[WorkspaceRepository] Error upserting workspace: $e');
      rethrow;
    }
  }

  @override
  Future<void> syncFromMemberships(List<String> roles) async {
    try {
      // Convertir roles a workspaces lite
      final workspaces = roles.map((role) {
        return WorkspaceLiteEntity(
          id: _normalizeRole(role),
          name: _normalizeRole(role),
          subtitle: _getSubtitleForRole(role),
          iconName: _getIconForRole(role),
        );
      }).toList();

      await isar.writeTxn(() async {
        // Limpiar workspaces existentes
        await isar.workspaceLiteModels.clear();

        // Insertar nuevos workspaces
        for (final workspace in workspaces) {
          await upsertWorkspace(workspace);
        }
      });
    } catch (e) {
      debugPrint('[WorkspaceRepository] Error syncing from memberships: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearState() async {
    try {
      await isar.writeTxn(() async {
        await isar.workspaceLiteModels.clear();
        await isar.workspaceStateModels.clear();
      });

      final prefs = await prefsProvider();
      await prefs.remove(_keyActiveWorkspace);
      await prefs.remove(_keyMRUQueue);
    } catch (e) {
      debugPrint('[WorkspaceRepository] Error clearing state: $e');
      rethrow;
    }
  }

  // ---- Helpers de normalización ----

  String _normalizeRole(String role) {
    final low = role.toLowerCase();
    if (low.contains('admin')) return 'Administrador';
    if (low.contains('propietario') || low.contains('owner')) {
      return 'Propietario';
    }
    if (low.contains('proveedor') || low.contains('provider')) {
      return 'Proveedor';
    }
    if (low.contains('arrendatario') || low.contains('tenant')) {
      return 'Arrendatario';
    }
    if (low.contains('aseguradora') || low.contains('insurance')) {
      return 'Aseguradora';
    }
    if (low.contains('abogado') || low.contains('lawyer')) return 'Abogado';
    if (low.contains('asesor')) return 'Asesor de seguros';
    return role.isEmpty ? role : role[0].toUpperCase() + role.substring(1);
  }

  String? _getSubtitleForRole(String role) {
    final normalized = _normalizeRole(role);
    switch (normalized) {
      case 'Administrador':
        return 'Gestiona activos, incidencias y compras';
      case 'Propietario':
        return 'Control de activos y documentos';
      case 'Proveedor':
        return 'Servicios y artículos';
      case 'Arrendatario':
        return 'Uso y reportes del activo';
      case 'Aseguradora':
        return 'Pólizas y renovaciones';
      case 'Abogado':
        return 'Casos y reclamaciones';
      case 'Asesor de seguros':
        return 'Ventas y asesoría';
      default:
        return null;
    }
  }

  String? _getIconForRole(String role) {
    final normalized = _normalizeRole(role);
    switch (normalized) {
      case 'Administrador':
        return 'dashboard_customize_outlined';
      case 'Propietario':
        return 'domain_outlined';
      case 'Proveedor':
        return 'handyman_outlined';
      case 'Arrendatario':
        return 'directions_car_filled_outlined';
      case 'Aseguradora':
        return 'policy_outlined';
      case 'Abogado':
        return 'balance_outlined';
      case 'Asesor de seguros':
        return 'support_agent_outlined';
      default:
        return 'apps_outlined';
    }
  }
}