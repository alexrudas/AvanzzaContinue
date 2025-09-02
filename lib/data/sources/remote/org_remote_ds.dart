import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/org/organization_model.dart';

class OrgRemoteDataSource {
  final FirebaseFirestore db;
  OrgRemoteDataSource(this.db);

  Future<List<OrganizationModel>> orgsByUser(String uid,
      {String? countryId, String? cityId}) async {
    Query q = db.collection('organizations').where('ownerUid', isEqualTo: uid);
    if (countryId != null) q = q.where('countryId', isEqualTo: countryId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs.map((d) => OrganizationModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<OrganizationModel?> getOrg(String orgId) async {
    final d = await db.collection('organizations').doc(orgId).get();
    if (!d.exists) return null;
    return OrganizationModel.fromFirestore(d.id, d.data()!);
  }

  Future<void> upsertOrg(OrganizationModel model) async {
    await db
        .collection('organizations')
        .doc(model.id)
        .set(model.toJson(), SetOptions(merge: true));
  }

  Future<void> updateOrgLocation(String orgId,
      {required String countryId, String? regionId, String? cityId}) async {
    await db.collection('organizations').doc(orgId).set({
      'countryId': countryId,
      'regionId': regionId,
      'cityId': cityId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
