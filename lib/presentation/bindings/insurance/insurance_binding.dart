// ============================================================================
// lib/presentation/bindings/insurance/insurance_binding.dart
// INSURANCE BINDING — Infraestructura compartida del flujo de cotización SRCE.
//
// QUÉ HACE:
// - Registra una sola vez la infraestructura HTTP compartida del flujo:
//     Dio(tag:'core') → InsuranceLeadRemoteDs → InsuranceLeadRepository.
// - Usa Get.isRegistered() defensivo en cada paso: si el binding se activa
//   desde dos páginas del mismo flujo, no duplica registros.
//
// QUÉ NO HACE:
// - No registra controllers de página — cada página tiene su propio binding.
// - No reutiliza IntegrationsApiClient ni tag 'integrations'.
//
// ÁRBOL DE DEPENDENCIAS (infraestructura):
//   CoreApiClient (Dio, tag:'core')
//     └─ InsuranceLeadRemoteDs
//          └─ InsuranceLeadRepository (impl: InsuranceLeadRepositoryImpl)
//
// USO:
//   RcQuoteRequestBinding extends InsuranceBinding → agrega su controller.
//   RcQuoteStatusBinding  extends InsuranceBinding → agrega su controller.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 monetización SRCE.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../data/remote/core_api_client.dart';
import '../../../data/repositories/insurance_lead_repository_impl.dart';
import '../../../data/sources/remote/insurance_lead_remote_ds.dart';
import '../../../domain/repositories/insurance_lead_repository.dart';

class InsuranceBinding extends Bindings {
  @override
  void dependencies() {
    // ── 1. Dio Core API ────────────────────────────────────────────────────
    if (!Get.isRegistered<Dio>(tag: 'core')) {
      Get.lazyPut<Dio>(
        () => CoreApiClient.create(),
        tag: 'core',
        fenix: true,
      );
    }

    // ── 2. Datasource ──────────────────────────────────────────────────────
    if (!Get.isRegistered<InsuranceLeadRemoteDs>()) {
      Get.lazyPut<InsuranceLeadRemoteDs>(
        () => InsuranceLeadRemoteDs(Get.find<Dio>(tag: 'core')),
        fenix: true,
      );
    }

    // ── 3. Repository ──────────────────────────────────────────────────────
    if (!Get.isRegistered<InsuranceLeadRepository>()) {
      Get.lazyPut<InsuranceLeadRepository>(
        () => InsuranceLeadRepositoryImpl(Get.find<InsuranceLeadRemoteDs>()),
        fenix: true,
      );
    }
  }
}
