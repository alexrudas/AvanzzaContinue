// ============================================================================
// lib/presentation/bindings/vrc/vrc_binding.dart
// VRC BINDING — Presentation Layer / GetX DI
//
// QUÉ HACE:
// - Registra VrcService + VrcController en el scope de las pantallas VRC.
// - Reutiliza el Dio tag:'integrations' registrado por el container global.
//
// QUÉ NO HACE:
// - No crea Dios propios, no monta interceptores, no duplica infra.
// - No registra repositorios (VRC no tiene cache ni persistencia).
//
// PRINCIPIOS:
// - fenix: true → VrcController sobrevive la navegación entre
//   VrcConsultPage y VrcResultPage sin perder el resultado.
// - Árbol de dependencias:
//     Get.find<Dio>(tag: 'integrations')  ← registrado por container global
//       └─ VrcService
//             └─ VrcController
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../data/vrc/vrc_service.dart';
import '../../controllers/vrc/vrc_controller.dart';

class VrcBinding extends Bindings {
  @override
  void dependencies() {
    // ── Servicio HTTP VRC ────────────────────────────────────────────────────
    Get.lazyPut<VrcService>(
      () => VrcService(Get.find<Dio>(tag: 'integrations')),
      fenix: true,
    );

    // ── Controller ───────────────────────────────────────────────────────────
    // fenix: true → el controller persiste mientras el usuario navega entre
    // VrcConsultPage y VrcResultPage, conservando el último resultado.
    Get.lazyPut<VrcController>(
      () => VrcController(Get.find<VrcService>()),
      fenix: true,
    );
  }
}
