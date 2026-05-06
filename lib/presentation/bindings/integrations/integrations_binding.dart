// ============================================================================
// lib/presentation/bindings/integrations/integrations_binding.dart
// INTEGRATIONS BINDING — Registra el stack del módulo Integrations en GetX.
//
// QUÉ HACE:
// - Registra IntegrationsRemoteDatasource / LocalDatasource / Repository /
//   Controller en el scope de la página que lo use.
// - Reutiliza el Dio tag:'integrations' registrado por el container global.
//
// QUÉ NO HACE:
// - No crea Dios propios, no monta interceptores, no arma baseUrl.
//
// ÁRBOL DE DEPENDENCIAS:
//   Get.find<Dio>(tag: 'integrations')       ← registrado por container global
//     └─ IntegrationsRemoteDatasource
//   IntegrationsLocalDatasource (Isar)
//     └─ IntegrationsRepositoryImpl (remote + local)
//           └─ IntegrationsController
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../data/datasources/integrations_remote_datasource.dart';
import '../../../data/local/integrations_local_datasource.dart';
import '../../../data/repositories/integrations_repository_impl.dart';
import '../../../domain/repositories/integrations_repository.dart';
import '../../controllers/integrations/integrations_controller.dart';

/// Binding GetX para el módulo de integraciones (RUNT Persona + SIMIT).
class IntegrationsBinding extends Bindings {
  @override
  void dependencies() {
    // ── 1. Datasource remoto ─────────────────────────────────────────────────
    Get.lazyPut<IntegrationsRemoteDatasource>(
      () => IntegrationsRemoteDatasource(
        Get.find<Dio>(tag: 'integrations'),
      ),
      fenix: true,
    );

    // ── 2. Datasource local (cache Isar) ─────────────────────────────────────
    Get.lazyPut<IntegrationsLocalDatasource>(
      () => IntegrationsLocalDatasource(DIContainer().isar),
      fenix: true,
    );

    // ── 3. Repositorio ───────────────────────────────────────────────────────
    Get.lazyPut<IntegrationsRepository>(
      () => IntegrationsRepositoryImpl(
        remote: Get.find<IntegrationsRemoteDatasource>(),
        local: Get.find<IntegrationsLocalDatasource>(),
      ),
      fenix: true,
    );

    // ── 4. Controller ────────────────────────────────────────────────────────
    Get.lazyPut<IntegrationsController>(
      () => IntegrationsController(
        Get.find<IntegrationsRepository>(),
      ),
      fenix: true,
    );
  }
}
