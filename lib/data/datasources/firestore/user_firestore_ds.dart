import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_profile_model.dart';
import '../../models/role_permission_model.dart';

class UserFirestoreDS {
  final FirebaseFirestore db;
  UserFirestoreDS(this.db);

  CollectionReference<Map<String, dynamic>> get col => db.collection('usuarios');

  Future<UserProfileModel?> getProfile(String uid) async {
    final d = await col.doc(uid).get();
    if (!d.exists) return null;
    return UserProfileModel.fromFirestore(uid, d.data()!);
  }

  Future<void> createProfile(String uid, UserProfileModel model) async {
    await col.doc(uid).set(model.toJson(), SetOptions(merge: true));
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> partial) async {
    await col.doc(uid).set(partial, SetOptions(merge: true));
  }

  Future<List<RolePermissionModel>> getRolePermissions(List<String> roles) async {
    if (roles.isEmpty) return [];
    final snap = await db.collection('roles').where('roleId', whereIn: roles).get();
    return snap.docs.map((d) => RolePermissionModel.fromJson(d.data())).toList();
  }

  Future<void> logAuthEvent(String uid, Map<String, dynamic> event) async {
    await col.doc(uid).collection('events').add(event);
  }
}
