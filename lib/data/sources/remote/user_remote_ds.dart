import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user/active_context_model.dart';
import '../../models/user/membership_model.dart';
import '../../models/user/user_model.dart';

class UserRemoteDataSource {
  final FirebaseFirestore db;
  UserRemoteDataSource(this.db);

  Future<UserModel?> getUser(String uid) async {
    final d = await db.collection('users').doc(uid).get();
    if (!d.exists) return null;
    return UserModel.fromFirestore(d.id, d.data()!);
  }

  Future<void> upsertUser(UserModel model) async {
    await db
        .collection('users')
        .doc(model.uid)
        .set(model.toJson(), SetOptions(merge: true));
  }

  Future<void> updateActiveContext(String uid, ActiveContextModel ctx) async {
    await db.collection('users').doc(uid).set({
      'activeContext': ctx.toJson(),
      'updatedAt': FieldValue.serverTimestamp()
    }, SetOptions(merge: true));
  }

  Future<List<MembershipModel>> memberships(String uid) async {
    final snap = await db
        .collection('memberships')
        .where('userId', isEqualTo: uid)
        .get();
    return snap.docs
        .map((d) => MembershipModel.fromFirestore(d.id, d.data(), db: db))
        .toList();
  }
}
