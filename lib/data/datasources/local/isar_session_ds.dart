import 'package:avanzza/data/models/user_profile_model.dart';
import 'package:avanzza/data/models/user_session_model.dart';
import 'package:isar_community/isar.dart';

import '../../models/cache/user_profile_cache_model.dart';

class IsarSessionDS {
  final Isar isar;
  IsarSessionDS(this.isar);

  Future<void> saveSession(UserSessionModel session) async {
    await isar.writeTxn(() async {
      await isar.userSessionModels.put(session);
    });
  }

  Future<UserSessionModel?> getSession(String uid) async {
    return isar.userSessionModels.filter().uidEqualTo(uid).findFirst();
  }

  Future<void> clearSession(String uid) async {
    final item = await getSession(uid);
    if (item != null) {
      await isar.writeTxn(() async {
        await isar.userSessionModels.delete(item.isarId!);
      });
    }
  }

  Future<void> saveProfileCache(UserProfileModel profile) async {
    final cache = UserProfileCacheModel.fromRemote(profile);
    await isar.writeTxn(() async {
      await isar.userProfileCacheModels.put(cache);
    });
  }

  Future<UserProfileModel?> getProfileCache(String uid) async {
    final cache =
        await isar.userProfileCacheModels.filter().uidEqualTo(uid).findFirst();
    return cache?.toRemote();
  }
}
