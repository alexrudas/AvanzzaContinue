import 'dart:async';


import 'package:avanzza/data/models/user/active_context_model.dart';
import 'package:avanzza/data/models/user/membership_model.dart';
import 'package:avanzza/data/models/user/user_model.dart';
import 'package:avanzza/data/sources/local/user_local_ds.dart';
import 'package:avanzza/data/sources/remote/user_remote_ds.dart';

import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/entities/user/membership_entity.dart';
import '../../../domain/entities/user/active_context.dart';
import '../../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource local;
  final UserRemoteDataSource remote;
  UserRepositoryImpl({required this.local, required this.remote});

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
    final m = UserModel.fromEntity(user.copyWith(updatedAt: user.updatedAt ?? now));
    await local.upsertUser(m);
    await remote.upsertUser(m);
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
    await remote.updateActiveContext(uid, ctxModel);
  }

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
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<MembershipEntity>> fetchMemberships(String uid) async {
    final locals = await local.memberships(uid);
    unawaited(() async {
      final remotes = await remote.memberships(uid);
      await _syncMemberships(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncMemberships(List<MembershipModel> locals, List<MembershipModel> remotes) async {
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
}
