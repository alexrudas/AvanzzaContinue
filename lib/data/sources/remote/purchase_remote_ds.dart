import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/purchase/purchase_request_model.dart';
import '../../models/purchase/supplier_response_model.dart';

class PurchaseRemoteDataSource {
  final FirebaseFirestore db;
  PurchaseRemoteDataSource(this.db);

  // Requests
  Future<List<PurchaseRequestModel>> requestsByOrg(String orgId, {String? cityId, String? assetId}) async {
    Query q = db.collection('purchase_requests').where('orgId', isEqualTo: orgId);
    if (cityId != null) q = q.where('ciudadEntrega', isEqualTo: cityId);
    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    final snap = await q.get();
    return snap.docs.map((d) => PurchaseRequestModel.fromFirestore(d.id, d.data() as Map<String,dynamic>)).toList();
  }

  Future<PurchaseRequestModel?> getRequest(String id) async {
    final d = await db.collection('purchase_requests').doc(id).get();
    if (!d.exists) return null;
    return PurchaseRequestModel.fromFirestore(d.id, d.data()!);
  }

  Future<void> upsertRequest(PurchaseRequestModel m) async {
    await db.collection('purchase_requests').doc(m.id).set(m.toJson(), SetOptions(merge: true));
  }

  // Supplier Responses
  Future<List<SupplierResponseModel>> responsesByRequest(String requestId) async {
    final snap = await db.collection('supplier_responses').where('purchaseRequestId', isEqualTo: requestId).get();
    return snap.docs.map((d) => SupplierResponseModel.fromFirestore(d.id, d.data())).toList();
  }

  Future<void> upsertSupplierResponse(SupplierResponseModel m) async {
    await db.collection('supplier_responses').doc(m.id).set(m.toJson(), SetOptions(merge: true));
  }
}
