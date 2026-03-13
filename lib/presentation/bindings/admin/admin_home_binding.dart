import 'package:get/get.dart';

import '../../controllers/activation/activation_gate_controller.dart';
import '../../controllers/admin/home/admin_home_controller.dart';

class AdminHomeBinding extends Bindings {
  @override
  void dependencies() {
    // AdminHomeController debe registrarse primero —
    // ActivationGateController lo resuelve vía Get.find() en su onInit.
    Get.lazyPut(() => AdminHomeController(), fenix: true);
    Get.lazyPut(() => ActivationGateController(), fenix: true);
  }
}
