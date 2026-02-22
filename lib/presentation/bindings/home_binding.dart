import 'package:get/get.dart';
import '../../core/di/container.dart';
import '../controllers/session_context_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SessionContextController>()) {
      final di = DIContainer();
      Get.put(SessionContextController(userRepository: di.userRepository, connectivity: di.connectivityService), permanent: true);
    }
  }
}
