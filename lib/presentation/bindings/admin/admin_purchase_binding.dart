import 'package:get/get.dart';
import '../../controllers/admin/purchase/admin_purchase_controller.dart';

class AdminPurchaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminPurchaseController(), fenix: true);
  }
}
