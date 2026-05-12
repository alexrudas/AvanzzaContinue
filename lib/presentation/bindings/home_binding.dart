// ============================================================================
// lib/presentation/bindings/home_binding.dart
// HOME BINDING — Enterprise Ultra Pro (Presentation / Bindings)
//
// QUÉ HACE:
// - Registra SessionContextController (permanent) si no está ya en el DI.
// - Registra WorkspaceController (permanent) si no está ya en el DI.
// - Registra SplashBootstrapController (permanent) si no está ya en el DI.
//
// NOTAS:
// - Routes.home es usado por SessionContextController.removeWorkspaceFromActiveOrg
//   para re-routing post-workspace-delete. HomeBinding garantiza que el
//   SplashBootstrapController esté disponible en ese re-routing.
// - Todos los controllers son permanent: idempotente ante múltiples entradas.
// ============================================================================

import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../core/session/session_active_org_id_provider.dart';
import '../../domain/services/session/active_org_id_provider.dart';
import '../controllers/session_context_controller.dart';
import '../controllers/splash_bootstrap_controller.dart';
import '../controllers/workspace_controller.dart';
import '../../services/telemetry/telemetry_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SessionContextController>()) {
      final di = DIContainer();
      Get.put(
        SessionContextController(
          userRepository: di.userRepository,
          connectivity: di.connectivityService,
        ),
        permanent: true,
      );
    }

    // ActiveOrgIdProvider: mismo registro que SplashBinding para paridad.
    // Routes.home entra aquí en re-routing post-logout/post-delete-workspace,
    // garantizando que AccessInterceptor/Gateway siempre puedan resolver orgId
    // aunque el splash no se haya vuelto a visitar en esa navegación.
    if (!Get.isRegistered<ActiveOrgIdProvider>()) {
      Get.put<ActiveOrgIdProvider>(
        SessionActiveOrgIdProvider(Get.find<SessionContextController>()),
        permanent: true,
      );
    }

    if (!Get.isRegistered<WorkspaceController>()) {
      final di = DIContainer();
      Get.put(
        WorkspaceController(
          repository: di.workspaceRepository,
          telemetry: Get.isRegistered<TelemetryService>()
              ? Get.find<TelemetryService>()
              : null,
        ),
        permanent: true,
      );
    }

    if (!Get.isRegistered<SplashBootstrapController>()) {
      Get.put(SplashBootstrapController(), permanent: true);
    }
  }
}
