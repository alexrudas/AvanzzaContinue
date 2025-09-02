import 'package:isar_community/isar.dart';

import '../../models/purchase/purchase_request_model.dart';
import '../../models/purchase/supplier_response_model.dart';

class PurchaseLocalDataSource {
  final Isar isar;
  PurchaseLocalDataSource(this.isar);

  Future<List<PurchaseRequestModel>> requestsByOrg(String orgId,
      {String? cityId, String? assetId}) async {
    final q = isar.purchaseRequestModels
        .filter()
        .orgIdEqualTo(orgId)
        .optional(cityId != null, (q) => q.ciudadEntregaEqualTo(cityId!))
        .optional(assetId != null, (q) => q.assetIdEqualTo(assetId!));
    return q.findAll();
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
