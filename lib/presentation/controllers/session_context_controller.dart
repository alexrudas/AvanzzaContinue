import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/entities/user/active_context.dart';
import '../../domain/entities/user/membership_entity.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../services/telemetry/telemetry_service.dart';

/// SessionContextController
/// - Loads and observes the current user and memberships
/// - Updates activeContext both locally (Isar) and remotely (Firestore)
/// - Uses UserRepository which implements offline-first policies
class SessionContextController extends GetxController {
  final UserRepository userRepository;

  SessionContextController({required this.userRepository});

  final Rxn<UserEntity> _user = Rxn<UserEntity>();
  UserEntity? get user => _user.value;

  final RxList<MembershipEntity> _memberships = <MembershipEntity>[].obs;
  List<MembershipEntity> get memberships => _memberships;

  // MERGE: version bump para invalidar Drawer cuando lista es mutada internamente
  final RxInt membershipsVersion = 0.obs;

  // Exponer Rx para reactividad en otros controladores
  Rxn<UserEntity> get userRx => _user;
  RxList<MembershipEntity> get membershipsRx => _memberships;

  StreamSubscription<UserEntity?>? _userSub;
  StreamSubscription<List<MembershipEntity>>? _mbrSub;

  Future<void> init(String uid) async {
    _userSub?.cancel();
    _mbrSub?.cancel();

    _userSub = userRepository.watchUser(uid).listen((u) {
      _user.value = u;
    });

    _mbrSub = userRepository.watchMemberships(uid).listen((list) {
      _memberships.assignAll(list);
      membershipsVersion.value++; // fuerza re-render dependientes
    });
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
    final normalizedRole = _normalize(role);
    final normalizedRoles = m.roles.map(_normalize).toSet();

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
      if (_isProveedor(role) && providerType != null && providerType.isNotEmpty) {
        await userRepository.updateProviderProfile(u.uid, m.orgId, providerType);
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

  // Helper para normalizar nombres de roles (igual que en WorkspaceDrawer)
  String _normalize(String role) {
    final low = role.toLowerCase();
    if (low.contains('admin')) return 'Administrador';
    if (low.contains('propietario') || low.contains('owner'))
      return 'Propietario';
    if (low.contains('proveedor') || low.contains('provider'))
      return 'Proveedor';
    if (low.contains('arrendatario') || low.contains('tenant'))
      return 'Arrendatario';
    if (low.contains('aseguradora') || low.contains('insurance'))
      return 'Aseguradora';
    if (low.contains('abogado') || low.contains('lawyer')) return 'Abogado';
    if (low.contains('asesor')) return 'Asesor de seguros';
    return role.isEmpty ? role : role[0].toUpperCase() + role.substring(1);
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
  Future<void> removeWorkspaceFromActiveOrg({required String role}) async {
    final u = user;
    final ctx = user?.activeContext;
    if (u == null || ctx == null || ctx.orgId.isEmpty) return;

    final normalized = role.trim().toLowerCase();

    try {
      await userRepository.removeRoleFromMembership(
        uid: u.uid,
        orgId: ctx.orgId,
        role: normalized,
      );

      // Recargar memberships (o confiar en stream y solo bump)
      await reloadMembershipsFromRepo();

      // Si borramos el rol activo, escoger otro si existe
      final current = memberships.firstWhereOrNull((m) => m.orgId == ctx.orgId);
      final remaining = current?.roles ?? const <String>[];
      if (ctx.rol.toLowerCase() == normalized) {
        if (remaining.isNotEmpty) {
          final nextRole = remaining.first;
          await setActiveContext(ctx.copyWith(rol: nextRole,));
        } else {
          // Mantener orgId y limpiar rol; la UI puede forzar selección
          await setActiveContext(ctx.copyWith(rol: '', ));
        }
      }

      membershipsVersion.value++;
      try {
        Get.find<TelemetryService>().log('workspace_delete_success', {
          'orgId': ctx.orgId,
          'role': normalized,
        });
      } catch (_) {}
    } catch (e) {
      try {
        Get.find<TelemetryService>().log('workspace_delete_error', {
          'orgId': ctx.orgId,
          'role': normalized,
          'error': e.toString(),
        });
      } catch (_) {}
      rethrow;
    }
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _mbrSub?.cancel();
    super.onClose();
  }
}
