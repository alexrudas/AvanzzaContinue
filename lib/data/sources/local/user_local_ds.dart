import 'package:isar_community/isar.dart';

import '../../models/user/user_model.dart';
import '../../models/user/membership_model.dart';

class UserLocalDataSource {
  final Isar isar;
  UserLocalDataSource(this.isar);

  Future<UserModel?> getUser(String uid) async {
    return isar.userModels.filter().uidEqualTo(uid).findFirst();
  }

  /// Watcher reactivo real sobre Isar. Reacciona a CADA commit que afecte
  /// el `UserModel` con [uid] (incluyendo upserts disparados por
  /// `upsertUser` / `updateActiveContext`). Emite el modelo actual o null
  /// si no existe.
  ///
  /// El stream cierra cuando se cancela la suscripción o cuando se cierra
  /// la instancia Isar. No hace polling, no fetches manuales — Isar
  /// dispara la emisión cuando termina la write txn correspondiente.
  Stream<UserModel?> watchUser(String uid) {
    return isar.userModels
        .filter()
        .uidEqualTo(uid)
        .watch(fireImmediately: true)
        .map((rows) => rows.isEmpty ? null : rows.first);
  }

  Future<void> upsertUser(UserModel m) async {
    await isar.writeTxn(() async => isar.userModels.put(m));
  }

  Future<List<MembershipModel>> memberships(String uid) async {
    return isar.membershipModels.filter().userIdEqualTo(uid).findAll();
  }

  Future<void> upsertMembership(MembershipModel m) async {
    await isar.writeTxn(() async => isar.membershipModels.put(m));
  }
}
