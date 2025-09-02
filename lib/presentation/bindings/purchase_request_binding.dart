import 'package:get/get.dart';

import '../controllers/purchase_request_controller.dart';

class PurchaseRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PurchaseRequestController());
  }
}
