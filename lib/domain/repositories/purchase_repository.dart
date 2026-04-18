import '../entities/purchase/create_purchase_request_input.dart';
import '../entities/purchase/purchase_request_entity.dart';
import '../entities/purchase/supplier_response_entity.dart';

/// Contrato del repositorio de compras.
///
/// CREATE PATH:
///   - `createRequest(input)` es el único camino canónico de creación, alineado
///     al contrato backend `POST /v1/purchase-requests` (title + type + category
///     + originType + assetId + notes + delivery + items[] + vendorContactIds[]).
///
/// READ PATH (sin cambios en esta tarea):
///   - watch/fetch/get siguen devolviendo `PurchaseRequestEntity` legacy para
///     mantener compatibilidad con widgets de admin list/detail. La migración
///     del read side queda fuera de alcance del create path.
abstract class PurchaseRepository {
  // Create
  Future<void> createRequest(CreatePurchaseRequestInput input);

  // Reads (entity canónica)
  Stream<List<PurchaseRequestEntity>> watchRequestsByOrg(String orgId,
      {String? assetId});
  Future<List<PurchaseRequestEntity>> fetchRequestsByOrg(String orgId,
      {String? assetId});
  Stream<PurchaseRequestEntity?> watchRequest(String id);
  Future<PurchaseRequestEntity?> getRequest(String id);

  // Supplier responses
  Stream<List<SupplierResponseEntity>> watchResponsesByRequest(
      String requestId);
  Future<List<SupplierResponseEntity>> fetchResponsesByRequest(
      String requestId);
  Future<void> upsertSupplierResponse(SupplierResponseEntity response);
}
