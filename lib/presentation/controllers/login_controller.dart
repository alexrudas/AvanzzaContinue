import 'package:get/get.dart';

import '../../core/di/container.dart';
import 'session_context_controller.dart';
import '../../app/routes.dart';

class LoginController extends GetxController {
  late final SessionContextController session;

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    session = Get.put(SessionContextController(userRepository: di.userRepository), permanent: true);
  }

  Future<void> login(String uid) async {
    await session.init(uid);
    Get.offAllNamed(AppRoutes.orgSelect);
  }
}
