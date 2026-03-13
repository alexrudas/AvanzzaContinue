// ============================================================================
// lib/presentation/bindings/splash_binding.dart
// SPLASH BINDING — Enterprise Ultra Pro (Presentation / Bindings)
//
// QUÉ HACE:
// - Registra SessionContextController como singleton permanente (si no existe).
// - Registra WorkspaceController como singleton permanente (si no existe).
// - Registra SplashBootstrapController como singleton permanente (si no existe).
//
// QUÉ NO HACE:
// - No ejecuta bootstrap aquí (eso corresponde al Page/Controller).
// - No usa Future.delayed ni temporizadores.
// - No re-instancia dependencias si ya están registradas.
//
// NOTAS ENTERPRISE:
// - Este binding debe ser idempotente: abrir la app / hot-restart / re-entry
//   no debe duplicar controladores.
// - DIContainer se instancia una sola vez para evitar overhead y mantener
//   consistencia de singletons internos.
//
// DEPENDENCIAS:
// - SessionContextController requiere: userRepository, connectivityService
// - WorkspaceController requiere: workspaceRepository, telemetry (ya registrado)
// - SplashBootstrapController: constructor default sin parámetros (según proyecto)
// ============================================================================

import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../services/telemetry/telemetry_service.dart';
import '../controllers/session_context_controller.dart';
import '../controllers/splash_bootstrap_controller.dart';
import '../controllers/workspace_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // -------------------------------------------------------------------------
    // DI CONTAINER (single instance dentro del binding)
    // -------------------------------------------------------------------------
    final di = DIContainer();

    // -------------------------------------------------------------------------
    // SESSION CONTEXT CONTROLLER (permanent)
    // -------------------------------------------------------------------------
    if (!Get.isRegistered<SessionContextController>()) {
      Get.put<SessionContextController>(
        SessionContextController(
          userRepository: di.userRepository,
          connectivity: di.connectivityService,
        ),
        permanent: true,
      );
    }

    // -------------------------------------------------------------------------
    // WORKSPACE CONTROLLER (permanent)
    // -------------------------------------------------------------------------
    // Nota: WorkspaceController depende de "telemetry". Si telemetry no está
    // registrado aún, Get.find() lanzará. En arquitectura GetX, telemetry suele
    // estar en AppBindings (permanent). Si no lo está, este binding te revela
    // el bug de wiring inmediatamente (como debe ser en Enterprise).
    if (!Get.isRegistered<WorkspaceController>()) {
      Get.put<WorkspaceController>(
        WorkspaceController(
          repository: di.workspaceRepository,
          telemetry: Get.isRegistered<TelemetryService>()
              ? Get.find<TelemetryService>()
              : null,
        ),
        permanent: true,
      );
    }

    // -------------------------------------------------------------------------
    // SPLASH BOOTSTRAP CONTROLLER (permanent)
    // -------------------------------------------------------------------------
    // En tu proyecto actual, SplashBootstrapController NO acepta parámetros
    // (si se cambian luego, se actualiza aquí).
    if (!Get.isRegistered<SplashBootstrapController>()) {
      Get.put<SplashBootstrapController>(
        SplashBootstrapController(),
        permanent: true,
      );
    }
  }
}
