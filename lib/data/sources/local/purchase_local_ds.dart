import 'package:isar_community/isar.dart';

import '../../models/purchase/purchase_request_model.dart';
import '../../models/purchase/supplier_response_model.dart';

/// Cache local de Purchase Requests (header canónico).
/// Filtros por orgId (tenancy) y opcionalmente por assetId.
class PurchaseLocalDataSource {
  final Isar isar;
  PurchaseLocalDataSource(this.isar);

  Future<List<PurchaseRequestModel>> requestsByOrg(
    String orgId, {
    String? assetId,
  }) async {
    final q = isar.purchaseRequestModels
        .filter()
        .orgIdEqualTo(orgId)
        .optional(assetId != null, (q) => q.assetIdEqualTo(assetId!));
    return q.findAll();
  }

  /// Stream reactivo de solicitudes por org.
  Stream<List<PurchaseRequestModel>> watchRequestsByOrg(String orgId) {
    return isar.purchaseRequestModels
        .filter()
        .orgIdEqualTo(orgId)
        .watch(fireImmediately: true);
  }

  Future<void> upsertRequest(PurchaseRequestModel m) async =>
      isar.writeTxn(() async => isar.purchaseRequestModels.put(m));

  Future<List<SupplierResponseModel>> responsesByRequest(
      String requestId) async {
    return isar.supplierResponseModels
        .filter()
        .purchaseRequestIdEqualTo(requestId)
        .findAll();
  }

  Future<void> upsertSupplierResponse(SupplierResponseModel m) async =>
      isar.writeTxn(() async => isar.supplierResponseModels.put(m));
}
