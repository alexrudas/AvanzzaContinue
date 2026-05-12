// ============================================================================
// lib/presentation/bindings/purchase_request_detail_binding.dart
// PURCHASE REQUEST DETAIL BINDING — GetX binding de la pantalla de detalle
// ============================================================================
// QUÉ HACE:
//   - Registra lazy-put del PurchaseRequestDetailController al navegar a
//     Routes.purchaseDetail. El controller resuelve el requestId desde
//     Get.arguments en onInit.
//
// QUÉ NO HACE:
//   - No resuelve repos: el controller toma PurchaseRepository desde
//     DIContainer en onInit (sigue el patrón del proyecto).
// ============================================================================

import 'package:get/get.dart';

import '../controllers/purchase/purchase_request_detail_controller.dart';

class PurchaseRequestDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchaseRequestDetailController>(
      () => PurchaseRequestDetailController(),
    );
  }
}
