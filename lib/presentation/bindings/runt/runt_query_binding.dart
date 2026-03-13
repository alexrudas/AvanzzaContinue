// ============================================================================
// lib/presentation/bindings/runt/runt_query_binding.dart
//
// RUNT QUERY BINDING — Enterprise-grade Ultra Pro
//
// PROPÓSITO
// Registrar las dependencias GetX necesarias para el flujo asíncrono RUNT
// del wizard de registro de activos.
//
// ESTE BINDING CUBRE
// - Step 2 del wizard (formulario de consulta)
// - pantalla de progreso
// - pantalla de resultado
//
// PRINCIPIOS
// - Presentation NO depende directamente de services HTTP concretos.
// - El controller recibe:
//   1. una abstracción de integración: [RuntAsyncQueryGateway]
//   2. un contrato de dominio: [AssetRegistrationDraftRepository]
//
// CAPAS
// - Infraestructura:
//     RuntQueryService
// - Integración / application-facing adapter:
//     RuntAsyncQueryGatewayImpl
// - Presentación:
//     RuntQueryController
//
// NOTA
// Este binding usa GetX para registrar dependencias del scope del wizard.
// El repositorio de draft se obtiene desde DIContainer porque ya pertenece
// a la arquitectura global del proyecto.
//
// USO ESPERADO EN app_pages.dart
//
//   GetPage(
//     name: Routes.createPortfolioStep2,
//     page: () => const CreatePortfolioStep2Page(),
//     binding: RuntQueryBinding(),
//   )
//
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/config/api_endpoints.dart';
import '../../../core/di/container.dart';
import '../../../data/gateways/runt_async_query_gateway_impl.dart';
import '../../../data/remote/interceptors/api_key_interceptor.dart';
import '../../../data/runt/runt_query_service.dart';
import '../../../domain/repositories/asset_registration_draft_repository.dart';
import '../../controllers/runt/runt_query_controller.dart';

class RuntQueryBinding extends Bindings {
  @override
  void dependencies() {
    // ─────────────────────────────────────────────────────────────────────────
    // Infraestructura HTTP
    // ─────────────────────────────────────────────────────────────────────────
    //
    // Servicio concreto de consulta RUNT basada en jobs.
    // Vive dentro del scope de este binding porque es específico del wizard.
    Get.lazyPut<RuntQueryService>(
      () => RuntQueryService(
        // Instancia Dio aislada con X-API-Key — NO usa el Dio global para
        // evitar contaminar otras requests de la app con este header.
        Dio()..interceptors.add(ApiKeyInterceptor()),
        baseUrl: ApiEndpoints.runtBaseUrl,
      ),
    );

    // ─────────────────────────────────────────────────────────────────────────
    // Integración / abstracción consumida por presentation
    // ─────────────────────────────────────────────────────────────────────────
    //
    // El controller NO conoce el service HTTP concreto.
    // Solo conoce la abstracción RuntAsyncQueryGateway.
    Get.lazyPut<RuntAsyncQueryGateway>(
      () => RuntAsyncQueryGatewayImpl(
        Get.find<RuntQueryService>(),
      ),
    );

    // ─────────────────────────────────────────────────────────────────────────
    // Contrato de dominio
    // ─────────────────────────────────────────────────────────────────────────
    //
    // Se obtiene desde el contenedor global del proyecto.
    final AssetRegistrationDraftRepository draftRepository =
        DIContainer().assetRegistrationDraftRepository;

    // ─────────────────────────────────────────────────────────────────────────
    // Controller de presentación
    // ─────────────────────────────────────────────────────────────────────────
    Get.lazyPut<RuntQueryController>(
      () => RuntQueryController(
        Get.find<RuntAsyncQueryGateway>(),
        draftRepository,
      ),
    );
  }
}
