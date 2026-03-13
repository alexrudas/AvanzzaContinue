// ============================================================================
// lib/presentation/bindings/integrations/integrations_binding.dart
//
// INTEGRATIONS BINDING
//
// Registra en GetX todas las dependencias del módulo Integrations
// en el scope de la página que lo use.
//
// Árbol de dependencias:
//
//   IntegrationsApiClient (Dio aislado)
//     └─ IntegrationsRemoteDatasource
//   IntegrationsLocalDatasource (recibe Isar de DIContainer)
//     └─ IntegrationsRepositoryImpl (remote + local)
//           └─ IntegrationsController
//
// Uso en app_pages.dart (NO modificar app_pages.dart existente):
//   GetPage(
//     name: '/integrations-test',
//     page: () => const IntegrationsTestPage(),
//     binding: IntegrationsBinding(),
//   )
//
// O navegar directamente sin ruta registrada:
//   Get.to(
//     () => const IntegrationsTestPage(),
//     binding: IntegrationsBinding(),
//   );
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../data/datasources/integrations_remote_datasource.dart';
import '../../../data/local/integrations_local_datasource.dart';
import '../../../data/remote/integrations_api_client.dart';
import '../../../data/repositories/integrations_repository_impl.dart';
import '../../../domain/repositories/integrations_repository.dart';
import '../../controllers/integrations/integrations_controller.dart';

/// Binding GetX para el módulo de integraciones (RUNT Persona + SIMIT).
///
/// Scope aislado: las dependencias solo viven mientras la página esté activa.
class IntegrationsBinding extends Bindings {
  @override
  void dependencies() {
    // ── 1. Cliente HTTP aislado para el módulo ─────────────────────────────
    // Instancia de Dio independiente del Dio global de AppBindings.
    // Tag 'integrations' evita colisión con el Dio global.
    Get.lazyPut<Dio>(
      () => IntegrationsApiClient.create(),
      tag: 'integrations',
      fenix: true,
    );

    // ── 2. Datasource remoto ───────────────────────────────────────────────
    Get.lazyPut<IntegrationsRemoteDatasource>(
      () => IntegrationsRemoteDatasource(
        Get.find<Dio>(tag: 'integrations'),
      ),
      fenix: true,
    );

    // ── 3. Datasource local (cache Isar) ───────────────────────────────────
    // Reutiliza la instancia de Isar del contenedor global del proyecto.
    Get.lazyPut<IntegrationsLocalDatasource>(
      () => IntegrationsLocalDatasource(DIContainer().isar),
      fenix: true,
    );

    // ── 4. Repositorio ─────────────────────────────────────────────────────
    Get.lazyPut<IntegrationsRepository>(
      () => IntegrationsRepositoryImpl(
        remote: Get.find<IntegrationsRemoteDatasource>(),
        local: Get.find<IntegrationsLocalDatasource>(),
      ),
      fenix: true,
    );

    // ── 5. Controller ──────────────────────────────────────────────────────
    Get.lazyPut<IntegrationsController>(
      () => IntegrationsController(
        Get.find<IntegrationsRepository>(),
      ),
      fenix: true,
    );
  }
}
