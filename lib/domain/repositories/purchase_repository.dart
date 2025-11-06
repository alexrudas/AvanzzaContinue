import '../entities/purchase/purchase_request_entity.dart';
import '../entities/purchase/supplier_response_entity.dart';

abstract class PurchaseRepository {
  // Requests
  Stream<List<PurchaseRequestEntity>> watchRequestsByOrg(String orgId,
      {String? cityId, String? assetId});
  Future<List<PurchaseRequestEntity>> fetchRequestsByOrg(String orgId,
      {String? cityId, String? assetId});
  Stream<PurchaseRequestEntity?> watchRequest(String id);
  Future<PurchaseRequestEntity?> getRequest(String id);
  Future<void> upsertRequest(PurchaseRequestEntity request);

  // Supplier responses
  Stream<List<SupplierResponseEntity>> watchResponsesByRequest(
      String requestId);
  Future<List<SupplierResponseEntity>> fetchResponsesByRequest(
      String requestId);
  Future<void> upsertSupplierResponse(SupplierResponseEntity response);
}
