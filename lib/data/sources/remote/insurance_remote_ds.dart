import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/paginated_result.dart';
import '../../models/insurance/insurance_policy_model.dart';
import '../../models/insurance/insurance_purchase_model.dart';

class InsuranceRemoteDataSource {
  final FirebaseFirestore db;
  InsuranceRemoteDataSource(this.db);

  Future<PaginatedResult<InsurancePolicyModel>> policiesByAsset(
    String assetId, {
    String? countryId,
    String? cityId,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > 100) {
      throw ArgumentError(
        'Limit $limit exceeds maximum of 100 for insurance policies.',
      );
    }

    Query<Map<String, dynamic>> q = db
        .collection('insurance_policies')
        .where('assetId', isEqualTo: assetId);

    if (countryId != null) {
      q = q.where('countryId', isEqualTo: countryId);
    }
    if (cityId != null) {
      q = q.where('cityId', isEqualTo: cityId);
    }

    q = q.orderBy('createdAt', descending: true).limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();

    return PaginatedResult(
      items: snap.docs
          .map((d) => InsurancePolicyModel.fromFirestore(d.id, d.data()))
          .toList(),
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  @Deprecated('Use policiesByAsset() with pagination instead')
  Future<List<InsurancePolicyModel>> policiesByAssetLegacy(
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

  Future<PaginatedResult<InsurancePurchaseModel>> purchasesByOrg(
    String orgId, {
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > 200) {
      throw ArgumentError(
        'Limit $limit exceeds maximum of 200. Use pagination with startAfter instead.',
      );
    }

    Query q = db
        .collection('insurance_purchases')
        .where('orgId', isEqualTo: orgId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();

    return PaginatedResult(
      items: snap.docs
          .map((d) => InsurancePurchaseModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
          .toList(),
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  @Deprecated('Use purchasesByOrg() with pagination instead')
  Future<List<InsurancePurchaseModel>> purchasesByOrgLegacy(String orgId) async {
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
