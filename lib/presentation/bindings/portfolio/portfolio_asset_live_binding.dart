// ============================================================================
// lib/presentation/bindings/portfolio/portfolio_asset_live_binding.dart
// PORTFOLIO ASSET LIVE BINDING — Inyección de dependencias para la vista unificada
//
// QUÉ HACE:
// - Guard-registra VrcService y VrcBatchController para que la página pueda
//   consumirlos via Get.find().
// - Reutiliza el Dio tag:'integrations' registrado por el container global.
// - Si VrcBatchController ya está registrado (navegación desde
//   AssetRegistrationPage), lo reutiliza intacto, preservando el estado del
//   batch en vuelo (items, ownerData, polling activo).
//
// QUÉ NO HACE:
// - No registra RuntQueryController ni AssetRegistrationController.
// - No crea Dios propios ni monta interceptores.
// - No usa fenix en VrcBatchController — un controller con timer activo y batch
//   en vuelo no debe resucitar automáticamente. Si GetX lo destruye, que muera.
//
// PRINCIPIOS:
// - La página SOLO consume via Get.find() — este Binding es el único punto de DI.
// - Guard explícito isRegistered<T>() en cada dependencia para evitar colisiones
//   si AssetRegistrationBinding ya las registró previamente.
// - VrcBatchController: Get.put sin fenix — estado crítico (timer, polling,
//   batch en vuelo). Ciclo de vida ligado al stack de navegación, no a GetX.
//   El guard preserva la instancia del flujo normal; cold-open crea una nueva.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Portfolio Asset Live — Phase 3.
// MODIFICADO (2026-04): Migrado a reusar Dio tag:'integrations' global.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../data/vrc/vrc_service.dart';
import '../../controllers/vrc/vrc_batch_controller.dart';

class PortfolioAssetLiveBinding extends Bindings {
  @override
  void dependencies() {
    // Guard: VrcService — reutiliza si ya existe, si no lo crea usando el
    // Dio tag:'integrations' registrado por el container global.
    if (!Get.isRegistered<VrcService>()) {
      Get.lazyPut<VrcService>(
        () => VrcService(Get.find<Dio>(tag: 'integrations')),
      );
    }

    // Guard: VrcBatchController — si AssetRegistrationBinding lo registró, el
    // guard lo preserva intacto (batch en vuelo, polling activo, ownerData).
    // Cold-open: permanent: true coherente con AssetRegistrationBinding.
    // La limpieza la hace PortfolioAssetLivePage.dispose() via
    // Get.delete<VrcBatchController>(force: true).
    if (!Get.isRegistered<VrcBatchController>()) {
      Get.put<VrcBatchController>(
        VrcBatchController(Get.find<VrcService>()),
        permanent: true,
      );
    }
  }
}
