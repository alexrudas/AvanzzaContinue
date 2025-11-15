import 'package:avanzza/domain/entities/role_permission_entity.dart';
import 'package:avanzza/domain/entities/user_profile_entity.dart';

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
  Future<void> upsertMembership(MembershipEntity membership);

  Future<UserProfileEntity> getOrBootstrapProfile(
      {required String uid, required String phone});
  Future<void> updateUserProfile(UserProfileEntity profile);
  Future<void> cacheProfile(UserProfileEntity profile);
  Future<List<RolePermissionEntity>> loadRolePermissions(List<String> roles);
  Future<void> setActiveContext(String uid, Map<String, dynamic> activeContext);

  // Workspace management
  Future<void> updateMembershipRoles(
      String uid, String orgId, List<String> roles);
  Future<void> updateProviderProfile(
      String uid, String orgId, String providerType);
  Future<void> removeRoleFromMembership(
      {required String uid, required String orgId, required String role});
}
