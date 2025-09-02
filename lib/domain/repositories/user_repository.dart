import '../entities/user/user_entity.dart';
import '../entities/user/membership_entity.dart';
import '../entities/user/active_context.dart';

abstract class UserRepository {
  // Users
  Stream<UserEntity?> watchUser(String uid);
  Future<UserEntity?> getUser(String uid);
  Future<void> upsertUser(UserEntity user);

  // Active context
  Future<void> updateActiveContext(String uid, ActiveContext context);

  // Memberships
  Stream<List<MembershipEntity>> watchMemberships(String uid);
  Future<List<MembershipEntity>> fetchMemberships(String uid);
}
