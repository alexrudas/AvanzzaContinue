import 'package:get/get.dart';
import '../../controllers/admin/home/admin_home_controller.dart';

class AdminHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminHomeController(), fenix: true);
  }
}
