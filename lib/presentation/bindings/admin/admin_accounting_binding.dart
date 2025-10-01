import 'package:get/get.dart';
import '../../controllers/admin/accounting/admin_accounting_controller.dart';

class AdminAccountingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminAccountingController(), fenix: true);
  }
}
