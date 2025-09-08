import 'package:get/get.dart';

import '../../app/routes.dart';
import '../../core/di/container.dart';
import 'session_context_controller.dart';

//TODO(06/09/2025): Hacer que la sesiones sean con firebaseAuth y firestore
//mostra orgs
class LoginController extends GetxController {
  late final SessionContextController session;

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    session = Get.put(
        SessionContextController(userRepository: di.userRepository),
        permanent: true);
  }

  Future<void> login(String uid) async {
    await session.init(uid);
    Get.offAllNamed(AppRoutes.orgSelect);
  }
}
