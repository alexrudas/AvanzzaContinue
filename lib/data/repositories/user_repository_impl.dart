import 'dart:async';

import 'package:avanzza/core/di/container.dart';
import 'package:avanzza/data/datasources/local/isar_session_ds.dart';
import 'package:avanzza/data/models/role_permission_model.dart';
import 'package:avanzza/data/models/user/active_context_model.dart';
import 'package:avanzza/data/models/user/membership_model.dart';
import 'package:avanzza/data/models/user/user_model.dart';
import 'package:avanzza/data/models/user_profile_model.dart';
import 'package:avanzza/data/sources/local/user_local_ds.dart';
import 'package:avanzza/data/sources/remote/user_remote_ds.dart';
import 'package:avanzza/domain/entities/role_permission_entity.dart';
import 'package:avanzza/domain/entities/user_profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../domain/entities/user/active_context.dart';
import '../../../domain/entities/user/membership_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/repositories/user_repository.dart';
import '../datasources/firestore/user_firestore_ds.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource local;
  final UserRemoteDataSource remote;
  UserRepositoryImpl({required this.local, required this.remote});

  // MERGE: fix append workspace - normalización canónica de roles
  String _normalizeRole(String role) {
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

  @override
  Stream<UserEntity?> watchUser(String uid) async* {
    final controller = StreamController<UserEntity?>();
    Future(() async {
      final l = await local.getUser(uid);
      controller.add(l?.toEntity());
      final r = await remote.getUser(uid);
      if (r != null) {
        await local.upsertUser(r);
        final updated = await local.getUser(uid);
        controller.add(updated?.toEntity());
      }
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<UserEntity?> getUser(String uid) async {
    final l = await local.getUser(uid);
    unawaited(() async {
      final r = await remote.getUser(uid);
      if (r != null) await local.upsertUser(r);
    }());
    return l?.toEntity();
  }

  @override
  Future<void> upsertUser(UserEntity user) async {
    final now = DateTime.now().toUtc();
    final m =
        UserModel.fromEntity(user.copyWith(updatedAt: user.updatedAt ?? now));
    await local.upsertUser(m);
    try {
      await remote.upsertUser(m);
    } catch (_) {
      DIContainer().syncService.enqueue(() => remote.upsertUser(m));
    }
  }

  @override
  Future<void> updateActiveContext(String uid, ActiveContext context) async {
    final ctxModel = ActiveContextModel.fromEntity(context);
    // local optimistic
    final current = await local.getUser(uid);
    if (current != null) {
      final updated = UserModel(
        isarId: current.isarId,
        uid: current.uid,
        name: current.name,
        email: current.email,
        phone: current.phone,
        tipoDoc: current.tipoDoc,
        numDoc: current.numDoc,
        countryId: current.countryId,
        preferredLanguage: current.preferredLanguage,
        activeContext: ctxModel,
        addresses: current.addresses,
        createdAt: current.createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
      await local.upsertUser(updated);
    }
    try {
      await remote.updateActiveContext(uid, ctxModel);
    } catch (_) {
      DIContainer()
          .syncService
          .enqueue(() => remote.updateActiveContext(uid, ctxModel));
    }
  }

  // MERGE: fix append workspace - watchMemberships sin cerrar stream
  @override
  Stream<List<MembershipEntity>> watchMemberships(String uid) async* {
    final controller = StreamController<List<MembershipEntity>>();
    Future(() async {
      final locals = await local.memberships(uid);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes = await remote.memberships(uid);
      await _syncMemberships(locals, remotes);
      final updated = await local.memberships(uid);
      controller.add(updated.map((e) => e.toEntity()).toList());
      // MERGE: NO cerrar stream para permitir nuevas emisiones
      // await controller.close(); <- ELIMINADO
    });
    yield* controller.stream;
  }

  // MERGE: fix append workspace - fetchMemberships sincronizado post-merge
  @override
  Future<List<MembershipEntity>> fetchMemberships(String uid) async {
    final locals = await local.memberships(uid);
    final remotes = await remote.memberships(uid);
    await _syncMemberships(locals, remotes);
    final updated = await local.memberships(uid);
    return updated.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncMemberships(
      List<MembershipModel> locals, List<MembershipModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertMembership(r);
      }
    }
  }

  @override
  Future<UserProfileEntity> getOrBootstrapProfile(
      {required String uid, required String phone}) async {
    final userFirestore = Get.find<UserFirestoreDS>();
    final isarSession = Get.find<IsarSessionDS>();

    // 1. ✅ Revisar cache local PRIMERO (offline-first)
    final cached = await isarSession.getProfileCache(uid);
    if (cached != null) {
      // Background sync para actualizar si hay cambios remotos
      unawaited(() async {
        try {
          final remote = await userFirestore.getProfile(uid);
          if (remote != null) {
            // Verificar si remote es más reciente
            final remoteTime =
                remote.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final cachedTime =
                cached.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            if (remoteTime.isAfter(cachedTime)) {
              await isarSession.saveProfileCache(remote);
            }
          }
        } catch (_) {
          // Silently fail - offline mode
        }
      }());
      return cached.toEntity();
    }

    // 2. Si no existe en cache, buscar en remote (bootstrap o primera vez)
    try {
      final existing = await userFirestore.getProfile(uid);
      if (existing != null) {
        await isarSession.saveProfileCache(existing);
        return existing.toEntity();
      }
    } catch (_) {
      // Si falla remote y no hay cache, crear perfil básico local
      // para permitir que la app funcione offline desde el inicio
    }

    // 3. Bootstrap: crear nuevo perfil
    final model = UserProfileModel(
      uid: uid,
      phone: phone,
      username: null,
      email: null,
      countryId: null,
      regionId: null,
      cityId: null,
      roles: const [],
      orgIds: const [],
      docType: null,
      docNumber: null,
      identityRaw: null,
      termsVersion: null,
      termsAcceptedAt: null,
      status: 'active',
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    // 4. ✅ Guardar local primero
    await isarSession.saveProfileCache(model);

    // 5. ✅ Intentar crear en remote
    try {
      await userFirestore.createProfile(uid, model);
      await userFirestore.updateProfile(uid, {
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // 6. ✅ Encolar si falla
      DIContainer().syncService.enqueue(() async {
        await userFirestore.createProfile(uid, model);
        await userFirestore.updateProfile(uid, {
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    }

    return model.toEntity();
  }

  @override
  Future<void> updateUserProfile(UserProfileEntity profile) async {
    final userFirestore = Get.find<UserFirestoreDS>();
    final isarSession = Get.find<IsarSessionDS>();
    final m = UserProfileModel.fromJson(profile.toJson());

    // 1. ✅ Actualizar local primero (optimistic update)
    await isarSession.saveProfileCache(m);

    // 2. ✅ Intentar actualizar remote
    try {
      await userFirestore.updateProfile(profile.uid, m.toJson());
    } catch (_) {
      // 3. ✅ Encolar en OfflineSyncService si falla
      DIContainer().syncService.enqueue(
            () => userFirestore.updateProfile(profile.uid, m.toJson()),
          );
    }
  }

  @override
  Future<void> cacheProfile(UserProfileEntity profile) async {
    final isarSession = Get.find<IsarSessionDS>();
    final m = UserProfileModel.fromJson(profile.toJson());
    await isarSession.saveProfileCache(m);
  }

  @override
  Future<List<RolePermissionEntity>> loadRolePermissions(
      List<String> roles) async {
    final userFirestore = Get.find<UserFirestoreDS>();
    final list = await userFirestore.getRolePermissions(roles);
    return list.map((RolePermissionModel e) => e.toEntity()).toList();
  }

  @override
  Future<void> setActiveContext(
      String uid, Map<String, dynamic> activeContext) async {
    final userFirestore = Get.find<UserFirestoreDS>();
    final isarSession = Get.find<IsarSessionDS>();

    // 1. ✅ Actualizar local PRIMERO (optimistic update)
    final cached = await isarSession.getProfileCache(uid);
    if (cached != null) {
      final updated = cached.copyWith(updatedAt: DateTime.now().toUtc());
      await isarSession.saveProfileCache(updated);
    }

    // 2. ✅ Intentar actualizar remote
    try {
      await userFirestore.updateProfile(uid, {
        'lastContext': activeContext,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // 3. ✅ Encolar en OfflineSyncService si falla
      DIContainer().syncService.enqueue(() => userFirestore.updateProfile(uid, {
            'lastContext': activeContext,
            'updatedAt': FieldValue.serverTimestamp(),
          }));
    }
  }

  // MERGE: fix append workspace - updateMembershipRoles con roles canónicos y merge parcial
  @override
  Future<void> updateMembershipRoles(
      String uid, String orgId, List<String> roles) async {
    final localMemberships = await local.memberships(uid);
    final membership =
        localMemberships.firstWhereOrNull((m) => m.orgId == orgId);
    if (membership == null) return;

    // MERGE: normalizar y deduplicar roles a forma canónica
    final canonical = roles.map(_normalizeRole).toSet().toList()..sort();

    // MERGE: actualizar local con roles canónicos (recrear modelo)
    final updated = MembershipModel(
      isarId: membership.isarId,
      id: membership.id,
      userId: membership.userId,
      orgId: membership.orgId,
      orgName: membership.orgName,
      roles: canonical,
      estatus: membership.estatus,
      primaryLocationJson: membership.primaryLocationJson,
      orgRef: membership.orgRef,
      orgRefPath: membership.orgRefPath,
      createdAt: membership.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
    await local.upsertMembership(updated);

    // MERGE: actualizar remoto con MERGE parcial (no replace completo)
    try {
      await remote.db.collection('memberships').doc(membership.id).set({
        'roles': canonical,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // MERGE parcial, preserva otros campos
    } catch (_) {
      DIContainer().syncService.enqueue(() async {
        await remote.db.collection('memberships').doc(membership.id).set({
          'roles': canonical,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });
    }
  }

  // MERGE: fix append workspace - updateProviderProfile con arrayUnion aditivo
  @override
  Future<void> updateProviderProfile(
      String uid, String orgId, String providerType) async {
    final localMemberships = await local.memberships(uid);
    final membership =
        localMemberships.firstWhereOrNull((m) => m.orgId == orgId);
    if (membership == null) return;

    // MERGE: usar arrayUnion para añadir sin reemplazar histórico
    try {
      await remote.db.collection('memberships').doc(membership.id).set({
        'providerProfiles': FieldValue.arrayUnion([
          {
            'providerType': providerType,
            'updatedAt': FieldValue.serverTimestamp(),
          }
        ]),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // MERGE aditivo
    } catch (_) {
      DIContainer().syncService.enqueue(() async {
        await remote.db.collection('memberships').doc(membership.id).set({
          'providerProfiles': FieldValue.arrayUnion([
            {
              'providerType': providerType,
              'updatedAt': FieldValue.serverTimestamp(),
            }
          ]),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });
    }
  }

  // NEW: remove role from membership using arrayRemove + merge, and update local cache
  @override
  Future<void> removeRoleFromMembership(
      {required String uid,
      required String orgId,
      required String role}) async {
    // Buscar membership local para obtener id del documento en 'memberships'
    final localMemberships = await local.memberships(uid);
    final membership =
        localMemberships.firstWhereOrNull((m) => m.orgId == orgId);
    if (membership == null) return;

    final canonical = _normalizeRole(role);

    // Remoto: arrayRemove sobre el doc de memberships/{membership.id}
    try {
      await remote.db.collection('memberships').doc(membership.id).set({
        'roles': FieldValue.arrayRemove([canonical]),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      // Encolar si falla la escritura remota
      DIContainer().syncService.enqueue(() async {
        await remote.db.collection('memberships').doc(membership.id).set({
          'roles': FieldValue.arrayRemove([canonical]),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });
    }

    // Local: remover el rol y persistir en cache local
    final currentRoles = List<String>.from(membership.roles ?? const []);
    currentRoles
        .removeWhere((r) => r.trim().toLowerCase() == canonical.toLowerCase());
    final updated = MembershipModel(
      isarId: membership.isarId,
      id: membership.id,
      userId: membership.userId,
      orgId: membership.orgId,
      orgName: membership.orgName,
      roles: currentRoles,
      estatus: membership.estatus,
      primaryLocationJson: membership.primaryLocationJson,
      orgRef: membership.orgRef,
      orgRefPath: membership.orgRefPath,
      createdAt: membership.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
    await local.upsertMembership(updated);
  }
}
