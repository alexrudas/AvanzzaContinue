// ============================================================================
// lib/presentation/bindings/splash_binding.dart
// SPLASH BINDING — Enterprise Ultra Pro Premium (Presentation / Bindings)
//
// QUÉ HACE:
// - Registra SessionContextController como singleton permanente (si no existe).
// - Registra WorkspaceController como singleton permanente (si no existe).
// - Registra SplashBootstrapController como singleton permanente (si no existe).
// - Registra ContextSwitchService como singleton permanente (si no existe).
// - Inyecta adaptadores concretos de infraestructura para Fase 1:
//   WorkspaceContextStateStoreImpl + LegacyActiveContextBridgeImpl.
//
// QUÉ NO HACE:
// - NO ejecuta bootstrap aquí (eso corresponde al Page/Controller).
// - NO navega ni decide rutas.
// - NO re-instancia dependencias ya registradas.
// - NO resuelve lógica de dominio.
// - NO crea WorkspaceContext directamente.
//
// PRINCIPIOS:
// - IDEMPOTENCIA: abrir app / re-entry / hot restart no debe duplicar singletons.
// - ORDEN DE REGISTRO: ContextSwitchService se registra después de
//   SessionContextController.
// - FASE 1 COMPAT: mantiene bridge hacia ActiveContext legacy sin contaminar
//   el binding con lógica de negocio.
// - LAZY SAFETY: registra solo lo necesario para splash/bootstrap.
//
// NOTAS ENTERPRISE:
// - ContextSwitchService permanece en SplashBinding durante Fase 1.
// - Si al finalizar la migración se convierte en dependencia global estable,
//   podrá moverse a AppBindings / InitialBinding.
// - TelemetryService se asume registrado globalmente. Si no existe, se inyecta null
//   al WorkspaceController para evitar crash innecesario en esta fase.
//
// DEPENDENCIAS:
// - DIContainer
// - SessionContextController
// - WorkspaceController
// - SplashBootstrapController
// - ContextSwitchService
// - WorkspaceContextStateStoreImpl
// - LegacyActiveContextBridgeImpl
// ============================================================================

import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../domain/services/workspace/context_switch_service.dart';
import '../../infrastructure/workspace/context_switch_adapters.dart';
import '../../services/telemetry/telemetry_service.dart';
import '../controllers/session_context_controller.dart';
import '../controllers/splash_bootstrap_controller.dart';
import '../controllers/workspace_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // -------------------------------------------------------------------------
    // DI CONTAINER (instancia única local al binding)
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
    if (!Get.isRegistered<SplashBootstrapController>()) {
      Get.put<SplashBootstrapController>(
        SplashBootstrapController(),
        permanent: true,
      );
    }

    // -------------------------------------------------------------------------
    // CONTEXT SWITCH SERVICE (permanent)
    // - Debe registrarse después de SessionContextController
    // - Usa puentes de infraestructura de Fase 1
    // -------------------------------------------------------------------------
    if (!Get.isRegistered<ContextSwitchService>()) {
      final session = Get.find<SessionContextController>();

      Get.put<ContextSwitchService>(
        ContextSwitchService(
          sessionContextController: session,
          stateStore: WorkspaceContextStateStoreImpl(),
          legacyBridge: LegacyActiveContextBridgeImpl(session),
        ),
        permanent: true,
      );
    }
  }
}
