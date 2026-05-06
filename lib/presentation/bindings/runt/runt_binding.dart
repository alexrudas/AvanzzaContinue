// ============================================================================
// lib/presentation/bindings/runt/runt_binding.dart
// RUNT BINDING — registra dependencias GetX para consulta RUNT standalone.
//
// QUÉ HACE:
// - Registra RuntService / RuntRepository / RuntController en el scope.
// - Reutiliza el Dio tag:'integrations' registrado por el container global.
//
// QUÉ NO HACE:
// - No crea Dios propios, no monta interceptores, no arma baseUrl.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../data/runt/runt_repository.dart';
import '../../../data/runt/runt_service.dart';
import '../../controllers/runt/runt_controller.dart';

class RuntBinding extends Bindings {
  @override
  void dependencies() {
    // RuntService: reutiliza el Dio tag:'integrations' global.
    Get.lazyPut<RuntService>(
      () => RuntService(Get.find<Dio>(tag: 'integrations')),
    );

    // Repositorio RUNT.
    Get.lazyPut<RuntRepository>(
      () => RuntRepository(Get.find<RuntService>()),
    );

    // Controlador RUNT.
    Get.lazyPut<RuntController>(
      () => RuntController(Get.find<RuntRepository>()),
    );
  }
}
