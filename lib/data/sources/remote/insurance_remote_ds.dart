import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/insurance/insurance_policy_model.dart';
import '../../models/insurance/insurance_purchase_model.dart';

class InsuranceRemoteDataSource {
  final FirebaseFirestore db;
  InsuranceRemoteDataSource(this.db);

  Future<List<InsurancePolicyModel>> policiesByAsset(
    String assetId, {
    String? countryId,
    String? cityId,
  }) async {
    Query<Map<String, dynamic>> q =
        db.collection('insurance_policies').where('assetId', isEqualTo: assetId);

    if (countryId != null) {
      q = q.where('countryId', isEqualTo: countryId);
    }
    if (cityId != null) {
      q = q.where('cityId', isEqualTo: cityId);
    }

    final snap = await q.get();
    return snap.docs
        .map((d) => InsurancePolicyModel.fromFirestore(d.id, d.data()))
        .toList();
  }

  Future<InsurancePolicyModel?> getPolicy(String id) async {
    final d = await db.collection('insurance_policies').doc(id).get();
    if (!d.exists) return null;
    return InsurancePolicyModel.fromFirestore(d.id, d.data()!);
  }

  Future<void> upsertPolicy(InsurancePolicyModel m) async {
    await db
        .collection('insurance_policies')
        .doc(m.id)
        .set(m.toJson(), SetOptions(merge: true));
  }

  Future<InsurancePurchaseModel?> getPurchase(String id) async {
    final d = await db.collection('insurance_purchases').doc(id).get();
    if (!d.exists) return null;
    return InsurancePurchaseModel.fromFirestore(d.id, d.data()!);
  }

  Future<List<InsurancePurchaseModel>> purchasesByOrg(String orgId) async {
    final snap = await db
        .collection('insurance_purchases')
        .where('orgId', isEqualTo: orgId)
        .get();
    return snap.docs
        .map((d) => InsurancePurchaseModel.fromFirestore(d.id, d.data()))
        .toList();
  }

  Future<void> upsertPurchase(InsurancePurchaseModel m) async {
    await db
        .collection('insurance_purchases')
        .doc(m.id)
        .set(m.toJson(), SetOptions(merge: true));
  }
}
