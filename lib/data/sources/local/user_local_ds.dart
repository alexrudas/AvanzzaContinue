import 'package:isar_community/isar.dart';

import '../../models/user/user_model.dart';
import '../../models/user/membership_model.dart';

class UserLocalDataSource {
  final Isar isar;
  UserLocalDataSource(this.isar);

  Future<UserModel?> getUser(String uid) async {
    return isar.userModels.filter().uidEqualTo(uid).findFirst();
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
