// lib/presentation/controllers/workspace_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import '../../core/utils/workspace_normalizer.dart';
import '../../domain/entities/workspace/workspace_lite_entity.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../../services/telemetry/telemetry_service.dart';

/// Controlador de workspaces con seleccion automatica, MRU y Undo
/// DERIVADO: sincroniza desde SessionContextController (auth) o RegistrationController (guest)
class WorkspaceController extends GetxController {
  final WorkspaceRepository repository;
  final TelemetryService? telemetry;

  WorkspaceController({
    required this.repository,
    this.telemetry,
  });

  // Estado reactivo
  final RxList<WorkspaceLiteEntity> workspaces = <WorkspaceLiteEntity>[].obs;
  final RxString activeWorkspaceId = ''.obs;
  final RxList<String> mruQueue = <String>[].obs;
  final RxBool isLoading = false.obs;

  // Fuente actual: 'auth' | 'guest' | 'none'
  String _currentSource = 'none';

  // Snapshot para Undo (10 segundos de TTL)
  _UndoSnapshot? _undoSnapshot;
  Timer? _undoTimer;

  static const Duration _undoTimeout = Duration(seconds: 10);

  @override
  void onInit() {
    super.onInit();
    loadWorkspaces();
  }

  @override
  void onClose() {
    _undoTimer?.cancel();
    super.onClose();
  }

  /// Carga workspaces desde el repositorio
  Future<void> loadWorkspaces() async {
    try {
      isLoading.value = true;

      final workspaceList = await repository.listWorkspaces();
      workspaces.assignAll(workspaceList);

      final activeId = await repository.getActiveWorkspaceId();
      activeWorkspaceId.value = activeId ?? '';

      final mru = await repository.getMRUQueue();
      mruQueue.assignAll(mru);

      // Si no hay active pero hay workspaces, seleccionar el primero
      if (activeWorkspaceId.value.isEmpty && workspaces.isNotEmpty) {
        await setActiveWorkspace(workspaces.first.id);
      }
    } catch (e) {
      debugPrint('[WorkspaceController] Error loading workspaces: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Establece un workspace como activo
  /// Si source es 'guest', NO persiste en repository
  Future<void> setActiveWorkspace(String id, {String source = 'auth'}) async {
    try {
      // Solo persistir si la fuente es 'auth'
      if (source == 'auth') {
        await repository.setActiveWorkspace(id);
        final mru = await repository.getMRUQueue();
        mruQueue.assignAll(mru);
      }

      activeWorkspaceId.value = id;

      _logTelemetry('workspace_switched_manual', {
        'workspaceId': id,
        'ctx': source,
      });
    } catch (e) {
      debugPrint('[WorkspaceController] Error setting active workspace: $e');
      rethrow;
    }
  }

  /// Elimina un workspace con seleccion automatica del siguiente
  Future<void> onDeleteWorkspace(String deletedId) async {
    if (workspaces.length == 1) {
      Get.snackbar(
        'No se puede eliminar',
        'Debes tener al menos un workspace activo',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    final wasActive = deletedId == activeWorkspaceId.value;

    // Guardar snapshot para Undo
    _createUndoSnapshot(deletedId);

    try {
      final startTime = DateTime.now();

      // Ejecutar eliminacion
      await repository.deleteWorkspace(deletedId);

      // Recargar lista
      await loadWorkspaces();

      final latency = DateTime.now().difference(startTime).inMilliseconds;

      // Si era el activo, seleccionar siguiente automóticamente
      String? newActiveId;
      String? selectionRule;

      if (wasActive) {
        final result = await selectNextActive(deletedId, source: _currentSource);
        newActiveId = result['newActiveId'] as String?;
        selectionRule = result['rule'] as String?;

        _logTelemetry('workspace_switched_auto', {
          'from': deletedId,
          'to': newActiveId,
          'cause': 'deleted_active',
          'rule': selectionRule,
          'ctx': _currentSource,
        });

        Get.snackbar(
          'Workspace eliminado',
          'Ahora trabajando en \'${_getWorkspaceName(newActiveId ?? '')}\'',
          snackPosition: SnackPosition.BOTTOM,
          duration: _undoTimeout,
          mainButton: TextButton(
            onPressed: undoDelete,
            child: const Text('Deshacer'),
          ),
        );
      } else {
        Get.snackbar(
          'Workspace eliminado',
          'El workspace ha sido eliminado correctamente',
          snackPosition: SnackPosition.BOTTOM,
          duration: _undoTimeout,
          mainButton: TextButton(
            onPressed: undoDelete,
            child: const Text('Deshacer'),
          ),
        );
      }

      _logTelemetry('workspace_deleted', {
        'deletedId': deletedId,
        'wasActive': wasActive,
        'newActiveId': newActiveId,
        'rule': selectionRule,
        'latency_ms': latency,
        'ctx': _currentSource,
      });
    } catch (e) {
      debugPrint('[WorkspaceController] Error deleting workspace: $e');
      Get.snackbar(
        'Error',
        'No se pudo eliminar el workspace: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      _clearUndoSnapshot();
      rethrow;
    }
  }

  /// Selecciona automóticamente el siguiente workspace activo
  /// Reglas: MRU  Vecino  Alfabático
  Future<Map<String, dynamic>> selectNextActive(
    String deletedId, {
    String source = 'auth',
  }) async {
    String? newActiveId;
    String? rule;

    // Regla 1: Buscar en MRU queue (excluyendo el eliminado)
    final validMRU = mruQueue
        .where((id) =>
            id != deletedId && workspaces.any((w) => w.id == id))
        .toList();

    if (validMRU.isNotEmpty) {
      newActiveId = validMRU.first;
      rule = 'mru';
    }

    // Regla 2: Buscar vecino inmediato (índice previo)
    if (newActiveId == null) {
      final deletedIndex = workspaces.indexWhere((w) => w.id == deletedId);
      if (deletedIndex > 0) {
        // Tomar el anterior
        newActiveId = workspaces[deletedIndex - 1].id;
        rule = 'neighbor_prev';
      } else if (deletedIndex == 0 && workspaces.length > 1) {
        // Era el primero, tomar el siguiente
        newActiveId = workspaces[1].id;
        rule = 'neighbor_next';
      }
    }

    // Regla 3: Orden alfabático (primero disponible)
    if (newActiveId == null && workspaces.isNotEmpty) {
      final sortedWorkspaces = List<WorkspaceLiteEntity>.from(workspaces)
        ..sort((a, b) => a.name.compareTo(b.name));

      final firstAvailable =
          sortedWorkspaces.firstWhereOrNull((w) => w.id != deletedId);

      if (firstAvailable != null) {
        newActiveId = firstAvailable.id;
        rule = 'alpha';
      }
    }

    // Establecer como activo
    if (newActiveId != null && newActiveId.isNotEmpty) {
      await setActiveWorkspace(newActiveId, source: source);

      debugPrint(
          '[WorkspaceController] Selected next active: $newActiveId (rule: $rule, ctx: $source)');

      return {
        'newActiveId': newActiveId,
        'rule': rule,
      };
    }

    return {
      'newActiveId': null,
      'rule': null,
    };
  }

  /// Crea un snapshot del estado para Undo
  void _createUndoSnapshot(String deletedId) {
    _undoTimer?.cancel();

    final deletedWorkspace =
        workspaces.firstWhereOrNull((w) => w.id == deletedId);

    if (deletedWorkspace != null) {
      _undoSnapshot = _UndoSnapshot(
        deletedWorkspace: deletedWorkspace,
        activeBefore: activeWorkspaceId.value,
        workspacesBefore: List<WorkspaceLiteEntity>.from(workspaces),
        mruBefore: List<String>.from(mruQueue),
      );

      // Timer para limpiar snapshot después de timeout
      _undoTimer = Timer(_undoTimeout, _clearUndoSnapshot);
    }
  }

  /// Deshace la última eliminación
  Future<void> undoDelete() async {
    if (_undoSnapshot == null) {
      Get.snackbar(
        'No se puede deshacer',
        'El tiempo para deshacer ha expirado',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final snapshot = _undoSnapshot!;

      // Restaurar workspace eliminado
      await repository.upsertWorkspace(snapshot.deletedWorkspace);

      // Restaurar active workspace
      await repository.setActiveWorkspace(snapshot.activeBefore);

      // Restaurar MRU queue
      for (final id in snapshot.mruBefore.reversed) {
        await repository.upsertMRU(id);
      }

      // Recargar estado
      await loadWorkspaces();

      Get.snackbar(
        'Restaurado',
        'El workspace \'${snapshot.deletedWorkspace.name}\' ha sido restaurado',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      _logTelemetry('workspace_delete_undone', {
        'workspaceId': snapshot.deletedWorkspace.id,
        'ctx': _currentSource,
      });
    } catch (e) {
      debugPrint('[WorkspaceController] Error undoing delete: $e');
      Get.snackbar(
        'Error',
        'No se pudo deshacer la eliminación: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _clearUndoSnapshot();
    }
  }

  /// Limpia el snapshot de Undo
  void _clearUndoSnapshot() {
    _undoTimer?.cancel();
    _undoSnapshot = null;
  }

  /// Sincroniza workspaces desde memberships del SessionController (auth)
  Future<void> syncFromMemberships(List<String> roles) async {
    try {
      _currentSource = 'auth';

      final normalized = WorkspaceNormalizer.normalizeList(roles);
      await repository.syncFromMemberships(normalized);
      await loadWorkspaces();

      _logTelemetry('workspace_synced', {
        'ctx': 'auth',
        'count': normalized.length,
      });
    } catch (e) {
      debugPrint('[WorkspaceController] Error syncing from memberships: $e');
      rethrow;
    }
  }

  /// Sincroniza workspaces desde RegistrationController.progress (guest)
  /// NO persiste en repository, solo actualiza estado in-memory
  Future<void> syncFromRegistrationProgress(
    List<String> roles,
    String? activeRole,
  ) async {
    try {
      _currentSource = 'guest';

      final normalized = WorkspaceNormalizer.normalizeList(roles);

      // Crear entidades lite in-memory (sin persistencia)
      final liteWorkspaces = normalized.map((role) {
        return WorkspaceLiteEntity(
          id: role,
          name: role,
          subtitle: 'Modo exploración',
          iconName: null,
          lastUsed: null,
        );
      }).toList();

      workspaces.assignAll(liteWorkspaces);
      activeWorkspaceId.value = activeRole != null
          ? WorkspaceNormalizer.normalize(activeRole)
          : '';

      _logTelemetry('workspace_synced', {
        'ctx': 'guest',
        'count': normalized.length,
      });
    } catch (e) {
      debugPrint('[WorkspaceController] Error syncing from registration: $e');
      rethrow;
    }
  }

  /// Obtiene el nombre de un workspace por su ID
  String _getWorkspaceName(String id) {
    final workspace = workspaces.firstWhereOrNull((w) => w.id == id);
    return workspace?.name ?? id;
  }

  /// Log de telemetría
  void _logTelemetry(String event, Map<String, dynamic> extras) {
    try {
      telemetry?.log(event, extras);
    } catch (e) {
      debugPrint('[WorkspaceController] Telemetry error: $e');
    }
  }

  /// Obtiene la lista ordenada para UI (alfabática con estabilidad por ID)
  List<WorkspaceLiteEntity> get orderedWorkspaces {
    final sorted = List<WorkspaceLiteEntity>.from(workspaces);
    sorted.sort((a, b) {
      final nameCompare = a.name.compareTo(b.name);
      if (nameCompare != 0) return nameCompare;
      return a.id.compareTo(b.id); // Estabilidad por ID
    });
    return sorted;
  }

  /// Verifica si puede eliminar (debe haber al menos 2 workspaces)
  bool get canDelete => workspaces.length > 1;
}

/// Snapshot para operación de Undo
class _UndoSnapshot {
  final WorkspaceLiteEntity deletedWorkspace;
  final String activeBefore;
  final List<WorkspaceLiteEntity> workspacesBefore;
  final List<String> mruBefore;

  _UndoSnapshot({
    required this.deletedWorkspace,
    required this.activeBefore,
    required this.workspacesBefore,
    required this.mruBefore,
  });
}