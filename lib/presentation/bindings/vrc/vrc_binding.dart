// ============================================================================
// lib/presentation/bindings/vrc/vrc_binding.dart
// VRC BINDING — Presentation Layer / GetX DI
//
// QUÉ HACE:
// - Registra las dependencias GetX del módulo VRC Individual en su scope.
// - Crea un Dio aislado via IntegrationsApiClient.create() con tag 'vrc'.
// - Registra VrcService y VrcController con fenix: true para sobrevivir
//   la navegación Consulta → Resultado.
//
// QUÉ NO HACE:
// - No reutiliza el Dio global de AppBindings (no tiene ApiKeyInterceptor).
// - No reutiliza el Dio del binding 'integrations' (scopes distintos).
// - No registra repositorios (VRC no tiene cache ni persistencia).
//
// PRINCIPIOS:
// - tag: 'vrc' evita colisión con tag 'integrations' del módulo homólogo.
// - fenix: true garantiza que VrcController sobrevive la navegación entre
//   VrcConsultPage y VrcResultPage sin perder el resultado.
// - Árbol de dependencias:
//     IntegrationsApiClient.create() [Dio, tag:'vrc']
//       └─ VrcService
//             └─ VrcController
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../data/remote/integrations_api_client.dart';
import '../../../data/vrc/vrc_service.dart';
import '../../controllers/vrc/vrc_controller.dart';

/// Binding GetX para el módulo VRC Individual.
///
/// Registrar en app_pages.dart para las rutas Routes.vrcConsult y Routes.vrcResult.
class VrcBinding extends Bindings {
  @override
  void dependencies() {
    // ── 1. Cliente HTTP aislado ────────────────────────────────────────────
    // Mismo factory que el módulo Integrations — incluye ApiKeyInterceptor,
    // LogInterceptor(debug) y baseUrl 'http://178.156.227.90/api'.
    // Tag 'vrc' evita colisión con tag 'integrations'.
    Get.lazyPut<Dio>(
      () => IntegrationsApiClient.create(),
      tag: 'vrc',
      fenix: true,
    );

    // ── 2. Servicio HTTP VRC ───────────────────────────────────────────────
    Get.lazyPut<VrcService>(
      () => VrcService(Get.find<Dio>(tag: 'vrc')),
      fenix: true,
    );

    // ── 3. Controller ──────────────────────────────────────────────────────
    // fenix: true → el controller persiste mientras el usuario navega entre
    // VrcConsultPage y VrcResultPage, conservando el último resultado.
    Get.lazyPut<VrcController>(
      () => VrcController(Get.find<VrcService>()),
      fenix: true,
    );
  }
}
