// ============================================================================
// lib/presentation/bindings/asset/asset_registration_binding.dart
// ASSET REGISTRATION BINDING — Inyección de dependencias para el flujo de registro
//
// QUÉ HACE:
// - Registra via Get.lazyPut todas las dependencias necesarias para el flujo
//   de registro de un activo: infraestructura RUNT + AssetRegistrationController.
// - Usa guard explícito isRegistered<T>() antes de cada lazyPut para evitar
//   colisiones con RuntQueryBinding si Progress/Result ya registraron estas
//   dependencias previamente.
//
// QUÉ NO HACE:
// - No crea portafolios ni accede a PortfolioRepository.
// - No usa fenix: true (ver justificación A4 en el plan arquitectónico).
//
// PRINCIPIOS:
// - Guard explícito Get.isRegistered<T>() en cada dependencia compartida con
//   RuntQueryBinding (RuntQueryService, RuntAsyncQueryGateway, RuntQueryController).
// - Import explícito de la interfaz RuntAsyncQueryGateway para tipado correcto.
// - DIContainer es la fuente del AssetRegistrationDraftRepository.
// - Instancia Dio aislada con ApiKeyInterceptor para no contaminar el Dio global.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 separación Portfolio / Asset Registration.
// Cubre la ruta Routes.assetRegister en app_pages.dart.
// Las rutas Routes.runtQueryProgress y Routes.runtQueryResult siguen usando
// RuntQueryBinding, que comparte las mismas dependencias con guard de registro.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../application/runt/runt_async_query_gateway.dart';
import '../../../core/config/api_endpoints.dart';
import '../../../core/di/container.dart';
import '../../../data/gateways/runt_async_query_gateway_impl.dart';
import '../../../data/remote/interceptors/api_key_interceptor.dart';
import '../../../data/runt/runt_query_service.dart';
import '../../controllers/asset/asset_registration_controller.dart';
import '../../controllers/runt/runt_query_controller.dart';

class AssetRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    // ─────────────────────────────────────────────────────────────────────────
    // Infraestructura HTTP
    // ─────────────────────────────────────────────────────────────────────────
    //
    // Guard explícito: si RuntQueryBinding ya registró RuntQueryService
    // (por ejemplo al volver de Progress/Result), no creamos otra instancia.
    if (!Get.isRegistered<RuntQueryService>()) {
      Get.lazyPut<RuntQueryService>(
        () => RuntQueryService(
          // Instancia Dio aislada con X-API-Key — NO usa el Dio global.
          Dio()..interceptors.add(ApiKeyInterceptor()),
          baseUrl: ApiEndpoints.runtBaseUrl,
        ),
      );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Abstracción de gateway
    // ─────────────────────────────────────────────────────────────────────────
    //
    // Se registra contra la interfaz RuntAsyncQueryGateway (no la impl)
    // para mantener el desacoplamiento entre presentación y data layer.
    if (!Get.isRegistered<RuntAsyncQueryGateway>()) {
      Get.lazyPut<RuntAsyncQueryGateway>(
        () => RuntAsyncQueryGatewayImpl(
          Get.find<RuntQueryService>(),
        ),
      );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // RuntQueryController
    // ─────────────────────────────────────────────────────────────────────────
    //
    // Se crea aquí para que esté disponible cuando AssetRegistrationPage llame
    // loadDraft() en _bootstrapDraftState(). Progress y Result usan la misma
    // instancia gracias al guard de registro.
    if (!Get.isRegistered<RuntQueryController>()) {
      Get.lazyPut<RuntQueryController>(
        () => RuntQueryController(
          Get.find<RuntAsyncQueryGateway>(),
          DIContainer().assetRegistrationDraftRepository,
        ),
      );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // AssetRegistrationController
    // ─────────────────────────────────────────────────────────────────────────
    //
    // Sin fenix: true — AssetRegistrationPage permanece en el stack durante
    // todo el flujo (Progress y Result son push/replace encima), por lo que
    // este controller nunca es destruido prematuramente.
    if (!Get.isRegistered<AssetRegistrationController>()) {
      Get.lazyPut<AssetRegistrationController>(
        () => AssetRegistrationController(),
      );
    }
  }
}
