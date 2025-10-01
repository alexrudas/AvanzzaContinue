import 'package:get/get.dart';
import '../../controllers/admin/maintenance/admin_maintenance_controller.dart';

class AdminMaintenanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminMaintenanceController(), fenix: true);
  }
}
