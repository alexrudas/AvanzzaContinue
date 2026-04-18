// ============================================================================
// lib/presentation/bindings/asset/asset_registration_binding.dart
// ASSET REGISTRATION BINDING — Inyección de dependencias para el flujo de registro
//
// QUÉ HACE:
// - Registra via Get.lazyPut todas las dependencias necesarias para el flujo
//   de registro de un activo: infraestructura RUNT + AssetRegistrationController.
// - Registra el VRC Gate (Dio tag:'vrc', VrcService, VrcController) con
//   fenix:true para que persistan a lo largo de todo el flujo de registro.
// - VrcBatchController se registra con Get.put sin fenix — controller con
//   timer activo y estado de batch en vuelo no debe resucitar automáticamente.
// - Usa guard explícito isRegistered<T>() antes de cada lazyPut para evitar
//   colisiones con RuntQueryBinding si Progress/Result ya registraron estas
//   dependencias previamente.
//
// QUÉ NO HACE:
// - No crea portafolios ni accede a PortfolioRepository.
// - No usa fenix: true para deps RUNT (ver justificación A4 en el plan).
//
// PRINCIPIOS:
// - Guard explícito Get.isRegistered<T>() en cada dependencia compartida con
//   RuntQueryBinding (RuntQueryService, RuntAsyncQueryGateway, RuntQueryController).
// - Import explícito de la interfaz RuntAsyncQueryGateway para tipado correcto.
// - DIContainer es la fuente del AssetRegistrationDraftRepository.
// - Instancia Dio aislada con ApiKeyInterceptor para RUNT; IntegrationsApiClient
//   (tag:'vrc') para VRC — sin contaminar el Dio global.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 separación Portfolio / Asset Registration.
// MODIFICADO (2026-04): Fase 2 VRC Gate — agrega bloque VRC al final.
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
import '../../../data/remote/integrations_api_client.dart';
import '../../../data/remote/interceptors/api_key_interceptor.dart';
import '../../../data/runt/runt_query_service.dart';
import '../../../data/vrc/vrc_service.dart';
import '../../controllers/asset/asset_registration_controller.dart';
import '../../controllers/runt/runt_query_controller.dart';
import '../../controllers/vrc/vrc_batch_controller.dart';
import '../../controllers/vrc/vrc_controller.dart';

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

    // ─────────────────────────────────────────────────────────────────────────
    // VRC Gate — verificación de propietario en RuntQueryResultPage
    // ─────────────────────────────────────────────────────────────────────────
    //
    // fenix: true en los tres → el VrcController sobrevive la navegación entre
    // AssetRegistrationPage → RuntQueryProgressPage → RuntQueryResultPage
    // y puede ser recreado si GetX lo destruye al hacer pop de una ruta.
    //
    // Guard Get.isRegistered<Dio>(tag:'vrc') — si el usuario previamente
    // usó la consulta VRC standalone (VrcBinding), el Dio ya está registrado.
    if (!Get.isRegistered<Dio>(tag: 'vrc')) {
      Get.lazyPut<Dio>(
        () => IntegrationsApiClient.create(),
        tag: 'vrc',
        fenix: true,
      );
    }
    if (!Get.isRegistered<VrcService>()) {
      Get.lazyPut<VrcService>(
        () => VrcService(Get.find<Dio>(tag: 'vrc')),
        fenix: true,
      );
    }
    if (!Get.isRegistered<VrcController>()) {
      Get.lazyPut<VrcController>(
        () => VrcController(Get.find<VrcService>()),
        fenix: true,
      );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // VRC Batch Gate — consulta multi-placa
    // ─────────────────────────────────────────────────────────────────────────
    //
    // permanent: true — el controller NO se destruye cuando 'assetRegister'
    // sale del stack via Get.offNamed(portfolioAssetLive).
    // Sin esto: offNamed destruye la ruta → GetX elimina el controller →
    // PortfolioAssetLivePage.initState() llama Get.find() sobre una instancia
    // muerta → batch perdido, UI congelada.
    // La limpieza es responsabilidad explícita de PortfolioAssetLivePage.dispose()
    // que llama Get.delete<VrcBatchController>(force: true).
    if (!Get.isRegistered<VrcBatchController>()) {
      Get.put<VrcBatchController>(
        VrcBatchController(Get.find<VrcService>()),
        permanent: true,
      );
    }
  }
}
