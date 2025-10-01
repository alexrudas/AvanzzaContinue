import 'package:get/get.dart';
import '../../../core/di/container.dart';
import '../../controllers/session_context_controller.dart';
import '../../navigation/bottom_nav_controller.dart';
import 'admin_home_binding.dart';
import 'admin_maintenance_binding.dart';
import 'admin_accounting_binding.dart';
import 'admin_purchase_binding.dart';
import 'admin_chat_binding.dart';

class AdminShellBinding extends Bindings {
  @override
  void dependencies() {
    // Navegación
    Get.put(BottomNavController(), permanent: true);

    // Session context
    if (!Get.isRegistered<SessionContextController>()) {
      final di = DIContainer();
      Get.put(SessionContextController(userRepository: di.userRepository), permanent: true);
    }

    // Secciones
    AdminHomeBinding().dependencies();
    AdminMaintenanceBinding().dependencies();
    AdminAccountingBinding().dependencies();
    AdminPurchaseBinding().dependencies();
    AdminChatBinding().dependencies();
  }
}
