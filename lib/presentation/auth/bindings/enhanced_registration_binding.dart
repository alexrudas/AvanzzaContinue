import 'package:get/get.dart';

import '../controllers/enhanced_registration_controller.dart';
import '../controllers/registration_controller.dart';
import '../../controllers/session_context_controller.dart';

/// EnhancedRegistrationBinding
///
/// Inyecta las dependencias necesarias para el wizard de registro mejorado:
/// - EnhancedRegistrationController (lógica del wizard)
/// - RegistrationController (ya existe, reusado)
/// - SessionContextController (ya existe, reusado)
class EnhancedRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    // EnhancedRegistrationController como lazy (se instancia cuando se necesita)
    // Depende de RegistrationController y SessionContextController que ya deben existir
    Get.lazyPut<EnhancedRegistrationController>(
      () => EnhancedRegistrationController(
        registrationController: Get.find<RegistrationController>(),
        sessionController: Get.find<SessionContextController>(),
      ),
    );
  }
}
