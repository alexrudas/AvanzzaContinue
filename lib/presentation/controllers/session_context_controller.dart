// lib\presentation\controllers\session_context_controller.dart

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../application/factories/product_access_context_factory.dart';
import '../../core/di/container.dart';
import '../../core/network/connectivity_service.dart';
import '../../core/utils/workspace_normalizer.dart';
import '../../domain/value/product_access_context.dart';
import '../../data/datasources/local/isar_session_ds.dart';
import '../../data/models/user_session_model.dart';
import '../../domain/entities/user/active_context.dart';
import '../../domain/entities/user/membership_entity.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../routes/app_pages.dart';
import '../../services/telemetry/telemetry_service.dart';
import 'workspace_controller.dart';

/// SessionContextController
/// - Loads and observes the current user and memberships
/// - Updates activeContext both locally (Isar) and remotely (Firestore)
/// - Uses UserRepository which implements offline-first policies
class SessionContextController extends GetxController {
  final UserRepository userRepository;
  final ConnectivityService? _connectivity;

  SessionContextController({
    required this.userRepository,
    ConnectivityService? connectivity,
  }) : _connectivity = connectivity;

  final Rxn<UserEntity> _user = Rxn<UserEntity>();
  UserEntity? get user => _user.value;

  final RxList<MembershipEntity> _memberships = <MembershipEntity>[].obs;
  List<MembershipEntity> get memberships => _memberships;

  // MERGE: version bump para invalidar Drawer cuando lista es mutada internamente
  final RxInt membershipsVersion = 0.obs;

  // Anti-race lock para eliminación de workspace
  bool _isRemovingWorkspace = false;

  /// Snapshot de acceso a producto para la sesión activa.
  /// null = sin sesión autenticada (deslogueado o userId aún no disponible).
  /// Reconstruido por [_rebuildAccessContext] ante cualquier cambio relevante.
  final Rx<ProductAccessContext?> accessContext = Rx<ProductAccessContext?>(null);

  // Exponer Rx para reactividad en otros controladores
  Rxn<UserEntity> get userRx => _user;
  RxList<MembershipEntity> get membershipsRx => _memberships;

  StreamSubscription<UserEntity?>? _userSub;
  StreamSubscription<List<MembershipEntity>>? _mbrSub;
  StreamSubscription<bool>? _connectivitySub;

  Future<void> init(String uid) async {
    debugPrint('[SessionContext] Inicializando con uid: $uid');

    _userSub?.cancel();
    _mbrSub?.cancel();

    // OFFLINE-FIRST: Cargar sesión desde cache local primero (respuesta inmediata)
    try {
      final isarSession =
          DIContainer().isar.isOpen ? IsarSessionDS(DIContainer().isar) : null;

      if (isarSession != null) {
        final cachedSession = await isarSession.getSession(uid);
        if (cachedSession != null) {
          debugPrint('[SessionContext] Sesión cargada desde cache local');
          // La sesión básica está cargada, los datos completos vendrán del stream
        }
      }
    } catch (e) {
      debugPrint('[SessionContext] Error al cargar sesión desde cache: $e');
    }

    // Iniciar streams para observar cambios en tiempo real
    _userSub = userRepository.watchUser(uid).listen((u) {
      _user.value = u;
      _rebuildAccessContext();
      // PERSISTIR: Guardar sesión actualizada en cache local
      _persistSession(uid);
    });

    _mbrSub = userRepository.watchMemberships(uid).listen((list) {
      _memberships.assignAll(list);
      membershipsVersion.value++; // fuerza re-render dependientes
      _rebuildAccessContext();
      // Sync workspaces to WorkspaceController
      _syncWorkspacesToController();
    });

    // Suscribir a cambios de conectividad para invalidar el snapshot.
    _connectivitySub = _connectivity?.online$.listen((_) {
      _rebuildAccessContext();
    });

    debugPrint('[SessionContext] Streams iniciados correctamente');
  }

  /// Persistir sesión actual en Isar para acceso offline
  Future<void> _persistSession(String uid) async {
    try {
      if (!DIContainer().isar.isOpen) return;

      final isarSession = IsarSessionDS(DIContainer().isar);
      final session = UserSessionModel()
        ..uid = uid
        ..lastLoginAt = DateTime.now().toUtc();

      await isarSession.saveSession(session);
      debugPrint('[SessionContext] Sesión persistida en cache local');
    } catch (e) {
      debugPrint('[SessionContext] Error al persistir sesión: $e');
    }
  }

  /// Syncs current memberships/roles to WorkspaceController
  Future<void> _syncWorkspacesToController() async {
    if (!Get.isRegistered<WorkspaceController>()) return;

    try {
      final workspaceController = Get.find<WorkspaceController>();

      // Extract all active roles from memberships (estatus normalizado)
      final roles = _memberships
          .where((m) => m.estatus.trim().toLowerCase() == 'activo')
          .expand((m) => m.roles)
          .toList();

      // Sync to WorkspaceController (uses WorkspaceNormalizer internally)
      await workspaceController.syncFromMemberships(roles);

      // Update active workspace if exists
      final activeRole = user?.activeContext?.rol;
      if (activeRole != null && activeRole.isNotEmpty) {
        await workspaceController.setActiveWorkspace(
          activeRole,
          source: 'auth',
        );
      }
    } catch (e) {
      debugPrint('[SessionContext] Error syncing workspaces: $e');
    }
  }

  Future<void> setActiveContext(ActiveContext ctx) async {
    final uid = user?.uid;
    if (uid == null) return;
    // Repository will persist to Isar and mirror to Firestore (write-through)
    await userRepository.updateActiveContext(uid, ctx);
    // Local observable update (optimistic)
    final current = user;
    if (current != null) {
      _user.value = current.copyWith(
          activeContext: ctx, updatedAt: DateTime.now().toUtc());
      _user.refresh(); // fuerza notificación
    }
  }

  // MERGE: fix append workspace - recargar memberships desde repo
  Future<void> reloadMembershipsFromRepo() async {
    final uid = user?.uid;
    if (uid == null) return;
    try {
      final all = await userRepository.fetchMemberships(uid);
      _memberships.assignAll(all);
      membershipsVersion.value++; // fuerza re-render dependientes
      _memberships.refresh(); // Force GetX reactive update
    } catch (e) {
      debugPrint('[SessionContext] Error reloading memberships: $e');
    }
  }

  /// Añade un nuevo workspace (rol) a la organización activa del usuario
  /// y actualiza el contexto activo para usar ese rol
  /// MERGE: fix append workspace - con refresh reactivo y telemetría
  Future<void> appendWorkspaceToActiveOrg({
    required String role,
    String? providerType,
  }) async {
    final u = user;
    if (u == null) return;

    // Buscar membership elegible:
    // 1. Membership de la organización activa
    // 2. Si no existe, tomar el primer membership con roles
    // 3. Si no existe, tomar el primer membership
    final m = _memberships.firstWhereOrNull(
          (x) => x.orgId == u.activeContext?.orgId,
        ) ??
        _memberships.firstWhereOrNull((x) => x.roles.isNotEmpty) ??
        _memberships.firstOrNull;

    if (m == null) return;

    // Normalizar el rol para evitar duplicados
    final normalizedRole = WorkspaceNormalizer.normalize(role);
    final normalizedRoles = m.roles.map(WorkspaceNormalizer.normalize).toSet();

    // MERGE: roles antes de la operación (para telemetría)
    final rolesBefore = List<String>.from(m.roles);

    // MERGE: Solo agregar si no existe ya (guardar ROL CANÓNICO)
    final isNoop = normalizedRoles.contains(normalizedRole);
    final mergedRoles = isNoop ? m.roles : [...m.roles, normalizedRole];

    // MERGE: si es no-op, loguear y salir
    if (isNoop) {
      _logTelemetry('profile_add_workspace_noop', {
        'uid': u.uid,
        'orgId': m.orgId,
        'role_attempted': role,
        'roles_existing': rolesBefore.join(','),
      });
      return;
    }

    try {
      // MERGE: actualizar con roles fusionados (repo normaliza internamente también)
      await userRepository.updateMembershipRoles(u.uid, m.orgId, mergedRoles);

      // Si es proveedor, actualizar perfil con arrayUnion
      if (_isProveedor(role) &&
          providerType != null &&
          providerType.isNotEmpty) {
        await userRepository.updateProviderProfile(
            u.uid, m.orgId, providerType);
      }

      // MERGE: recargar memberships para reflejar cambios
      await reloadMembershipsFromRepo();

      // Crear contexto activo con el nuevo rol
      final newContext = ActiveContext(
        orgId: m.orgId,
        orgName: m.orgName,
        rol: normalizedRole,
        providerType: _isProveedor(role) ? providerType : null,
      );

      // Actualizar contexto activo
      await setActiveContext(newContext);

      // MERGE: telemetría de éxito
      _logTelemetry('profile_add_workspace_success', {
        'uid': u.uid,
        'orgId': m.orgId,
        'role_added': normalizedRole,
        'roles_before': rolesBefore.join(','),
        'roles_after': mergedRoles.join(','),
      });
    } catch (e) {
      // MERGE: telemetría de error
      _logTelemetry('profile_add_workspace_error', {
        'uid': u.uid,
        'orgId': m.orgId,
        'role_attempted': role,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  // MERGE: fix append workspace - helper para detectar roles de proveedor
  bool _isProveedor(String role) {
    return role.toLowerCase().contains('proveedor') ||
        role.toLowerCase().contains('provider');
  }

  // MERGE: fix append workspace - helper para telemetría
  void _logTelemetry(String event, Map<String, dynamic> extras) {
    try {
      if (Get.isRegistered<TelemetryService>()) {
        Get.find<TelemetryService>().log(event, extras);
      }
    } catch (e) {
      debugPrint('[SessionContext] Telemetry error: $e');
    }
  }

  // Elimina un workspace (rol) de la organización activa
  // - Firestore: arrayRemove
  // - Cache: recarga memberships
  // - Contexto: si el rol eliminado era el activo, ajustar al siguiente disponible o limpiar
  // - WorkspaceController: sincroniza cambios con source:'auth'
  Future<void> removeWorkspaceFromActiveOrg({required String role}) async {
    // Anti-race: si ya hay una eliminación en curso, salir
    if (_isRemovingWorkspace) {
      debugPrint('[SessionContext] Remove already in progress, skipping');
      return;
    }

    final u = user;
    final ctx = user?.activeContext;
    if (u == null || ctx == null || ctx.orgId.isEmpty) return;

    final normalized = WorkspaceNormalizer.normalize(role);
    final wasActive = WorkspaceNormalizer.areEqual(ctx.rol, role);

    _isRemovingWorkspace = true;

    try {
      final startTime = DateTime.now();

      await userRepository.removeRoleFromMembership(
        uid: u.uid,
        orgId: ctx.orgId,
        role: normalized,
      );

      // Recargar memberships (o confiar en stream y solo bump)
      await reloadMembershipsFromRepo();

      final latency = DateTime.now().difference(startTime).inMilliseconds;

      // Si borramos el rol activo, seleccionar siguiente con política determinística
      String? newActiveRole;
      String? selectionRule;

      if (wasActive) {
        final currentMembership = memberships.firstWhereOrNull(
          (m) => m.orgId == ctx.orgId,
        );

        if (currentMembership != null) {
          // Política: alfabético de la misma org → alfabético de otras orgs → vacío
          final sameOrgRoles = currentMembership.roles
              .where((r) => !WorkspaceNormalizer.areEqual(r, role))
              .toList();

          if (sameOrgRoles.isNotEmpty) {
            newActiveRole = WorkspaceNormalizer.findNextAlphabetic(
              sameOrgRoles,
            );
            selectionRule = 'same_org_alpha';
          } else {
            // Buscar en otras orgs
            final otherOrgRoles = memberships
                .where((m) => m.orgId != ctx.orgId && m.estatus.trim().toLowerCase() == 'activo')
                .expand((m) => m.roles)
                .toList();

            if (otherOrgRoles.isNotEmpty) {
              newActiveRole = WorkspaceNormalizer.findNextAlphabetic(
                otherOrgRoles,
              );
              selectionRule = 'other_org_alpha';
            }
          }
        }

        // Actualizar contexto
        if (newActiveRole != null && newActiveRole.isNotEmpty) {
          // Encontrar la org del nuevo rol
          final newOrgMembership = memberships.firstWhereOrNull(
            (m) => m.roles
                .any((r) => WorkspaceNormalizer.areEqual(r, newActiveRole!)),
          );

          if (newOrgMembership != null) {
            await setActiveContext(ActiveContext(
              orgId: newOrgMembership.orgId,
              orgName: newOrgMembership.orgName,
              rol: newActiveRole,
              providerType: ctx.providerType,
            ));

            // Forzar navegación al nuevo workspace (cierra vista del eliminado)
            // HomeRouter redirigirá automáticamente al workspace correcto
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (Get.currentRoute != Routes.home) {
                Get.offAllNamed(Routes.home);
              }
            });
          }
        } else {
          // No hay roles, limpiar
          await setActiveContext(ctx.copyWith(rol: ''));
          selectionRule = 'empty';

          // Navegar a pantalla segura (sin workspaces)
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(Routes.home);
          });
        }

        _logTelemetry('workspace_switched_auto', {
          'from': normalized,
          'to': newActiveRole ?? '',
          'cause': 'deleted_active',
          'rule': selectionRule ?? 'none',
          'ctx': 'auth',
        });
      }

      membershipsVersion.value++;

      // Sincronizar con WorkspaceController
      await _syncWorkspacesToController();

      _logTelemetry('workspace_delete_success', {
        'orgId': ctx.orgId,
        'role': normalized,
        'wasActive': wasActive,
        'newActiveRole': newActiveRole,
        'rule': selectionRule,
        'latency_ms': latency,
        'ctx': 'auth',
      });
    } catch (e) {
      _logTelemetry('workspace_delete_error', {
        'orgId': ctx.orgId,
        'role': normalized,
        'error': e.toString(),
        'ctx': 'auth',
      });
      rethrow;
    } finally {
      _isRemovingWorkspace = false;
    }
  }

  /// Reconstruye [accessContext] con el estado actual de sesión y conectividad.
  ///
  /// Reglas:
  /// - Si [user?.uid] es null → [accessContext] = null (sin sesión).
  /// - membershipScope: del membership activo (por orgId). Fallback: [MembershipScope()].
  /// - organizationContract: no cargado en este controller → fallback via factory.
  /// - isOnline: del [_connectivity] real. Fallback: false (offline-safe).
  void _rebuildAccessContext() {
    final uid = user?.uid;

    if (uid == null || uid.isEmpty) {
      accessContext.value = null;
      return;
    }

    final orgId = user?.activeContext?.orgId ?? '';

    final roles = _memberships
        .where((m) => m.estatus.trim().toLowerCase() == 'activo')
        .expand((m) => m.roles)
        .toSet();

    final activeMembership = _memberships.firstWhereOrNull(
      (m) => m.orgId == orgId,
    );

    accessContext.value = ProductAccessContextFactory.build(
      userId: uid,
      orgId: orgId,
      roles: roles,
      scope: activeMembership?.scope,
      contract: null, // No org contract in this controller — factory uses defaultRestricted()
      isOnline: _connectivity?.isOnline ?? false,
    );
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _mbrSub?.cancel();
    _connectivitySub?.cancel();
    super.onClose();
  }
}
