import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/paginated_result.dart';
import '../../models/purchase/purchase_request_model.dart';
import '../../models/purchase/supplier_response_model.dart';

class PurchaseRemoteDataSource {
  final FirebaseFirestore db;
  PurchaseRemoteDataSource(this.db);

  // Requests
  Future<PaginatedResult<PurchaseRequestModel>> requestsByOrg(
    String orgId, {
    String? cityId,
    String? assetId,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > 200) {
      throw ArgumentError(
        'Limit $limit exceeds maximum of 200. Use pagination with startAfter instead.',
      );
    }

    Query q = db
        .collection('purchase_requests')
        .where('orgId', isEqualTo: orgId);

    if (cityId != null) q = q.where('ciudadEntrega', isEqualTo: cityId);
    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);

    q = q.orderBy('createdAt', descending: true).limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();

    return PaginatedResult(
      items: snap.docs
          .map((d) => PurchaseRequestModel.fromFirestore(
              d.id, d.data() as Map<String, dynamic>))
          .toList(),
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  @Deprecated('Use requestsByOrg() with pagination instead')
  Future<List<PurchaseRequestModel>> requestsByOrgLegacy(
    String orgId, {
    String? cityId,
    String? assetId,
  }) async {
    Query q = db.collection('purchase_requests').where('orgId', isEqualTo: orgId);
    if (cityId != null) q = q.where('ciudadEntrega', isEqualTo: cityId);
    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    final snap = await q.get();
    return snap.docs
        .map((d) => PurchaseRequestModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>))
        .toList();
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
  Future<PaginatedResult<SupplierResponseModel>> responsesByRequest(
    String requestId, {
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > 100) {
      throw ArgumentError(
        'Limit $limit exceeds maximum of 100 for supplier responses.',
      );
    }

    Query q = db
        .collection('supplier_responses')
        .where('purchaseRequestId', isEqualTo: requestId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();

    return PaginatedResult(
      items: snap.docs
          .map((d) => SupplierResponseModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
          .toList(),
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  @Deprecated('Use responsesByRequest() with pagination instead')
  Future<List<SupplierResponseModel>> responsesByRequestLegacy(
      String requestId) async {
    final snap = await db
        .collection('supplier_responses')
        .where('purchaseRequestId', isEqualTo: requestId)
        .get();
    return snap.docs
        .map((d) => SupplierResponseModel.fromFirestore(d.id, d.data()))
        .toList();
  }

  Future<void> upsertSupplierResponse(SupplierResponseModel m) async {
    await db.collection('supplier_responses').doc(m.id).set(m.toJson(), SetOptions(merge: true));
  }
}
