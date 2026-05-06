// ============================================================================
// lib/presentation/bindings/simit/simit_binding.dart
// SIMIT BINDING — registra dependencias GetX para consulta SIMIT standalone.
//
// QUÉ HACE:
// - Registra SimitService / SimitRepository / SimitController.
// - Reutiliza el Dio tag:'integrations' registrado por el container global.
//
// QUÉ NO HACE:
// - No crea Dios propios, no monta interceptores, no arma baseUrl.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../data/simit/simit_repository.dart';
import '../../../data/simit/simit_service.dart';
import '../../controllers/simit/simit_controller.dart';

class SimitBinding extends Bindings {
  @override
  void dependencies() {
    // SimitService: reutiliza el Dio tag:'integrations' global.
    Get.lazyPut<SimitService>(
      () => SimitService(Get.find<Dio>(tag: 'integrations')),
    );

    // Repositorio SIMIT.
    Get.lazyPut<SimitRepository>(
      () => SimitRepository(Get.find<SimitService>()),
    );

    // Controlador SIMIT.
    Get.lazyPut<SimitController>(
      () => SimitController(Get.find<SimitRepository>()),
    );
  }
}
