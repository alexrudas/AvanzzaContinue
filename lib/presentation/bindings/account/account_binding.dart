// ============================================================================
// lib/presentation/bindings/account/account_binding.dart
// Binding GetX para la ruta /account.
// Controllers son lazyPut (se instancian al primer Get.find). Los UCs se
// registran como lazyPut también para que se construyan a demanda y queden
// disponibles dentro del scope de la página.
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../domain/usecases/account/get_desktop_access_status_uc.dart';
import '../../../domain/usecases/account/link_desktop_access_uc.dart';
import '../../../domain/usecases/account/update_personal_data_uc.dart';
import '../../controllers/account/account_profile_controller.dart';
import '../../controllers/account/desktop_access_controller.dart';
import '../../controllers/session_context_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    // Use cases (lazy)
    Get.lazyPut<UpdatePersonalDataUC>(
      () => UpdatePersonalDataUC(Get.find<UserRepository>()),
    );
    Get.lazyPut<GetDesktopAccessStatusUC>(
      () => GetDesktopAccessStatusUC(
        Get.find<FirebaseAuth>(),
        Get.find<AuthRepository>(),
      ),
    );
    Get.lazyPut<LinkDesktopAccessUC>(
      () => LinkDesktopAccessUC(Get.find<AuthRepository>()),
    );

    // Controllers (lazy, scoped a la ruta)
    Get.lazyPut<AccountProfileController>(
      () => AccountProfileController(
        session: Get.find<SessionContextController>(),
        updatePersonal: Get.find<UpdatePersonalDataUC>(),
        getDesktopAccess: Get.find<GetDesktopAccessStatusUC>(),
      ),
    );
    Get.lazyPut<DesktopAccessController>(
      () => DesktopAccessController(
        linkUC: Get.find<LinkDesktopAccessUC>(),
        authRepo: Get.find<AuthRepository>(),
      ),
    );
  }
}
