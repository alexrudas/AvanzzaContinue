import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/config/integrations_api_config.dart';
import '../../../data/remote/interceptors/api_key_interceptor.dart';
import '../../../data/runt/runt_repository.dart';
import '../../../data/runt/runt_service.dart';
import '../../controllers/runt/runt_controller.dart';

/// Binding para las pantallas de consulta RUNT.
///
/// Este binding registra únicamente las dependencias específicas del módulo RUNT:
/// - RuntService (capa de servicio HTTP)
/// - RuntRepository (capa de repositorio)
/// - RuntController (controlador GetX)
///
/// NOTA: Usa un Dio aislado con ApiKeyInterceptor y baseUrl correcto
/// (incluye /api). NO reutiliza el Dio global de AppBindings porque ese
/// Dio no incluye autenticación por API key.
class RuntBinding extends Bindings {
  @override
  void dependencies() {
    // Servicio RUNT (lazy singleton)
    // Dio aislado: incluye X-API-Key y apunta a la URL correcta con /api.
    Get.lazyPut<RuntService>(
      () => RuntService(
        Dio(
          BaseOptions(
            connectTimeout: IntegrationsApiConfig.connectTimeout,
            receiveTimeout: IntegrationsApiConfig.receiveTimeout,
            sendTimeout: IntegrationsApiConfig.sendTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        )..interceptors.add(ApiKeyInterceptor()),
        baseUrl: IntegrationsApiConfig.baseUrl,
      ),
    );

    // Repositorio RUNT (lazy singleton)
    Get.lazyPut<RuntRepository>(
      () => RuntRepository(Get.find<RuntService>()),
    );

    // Controlador RUNT (lazy singleton)
    Get.lazyPut<RuntController>(
      () => RuntController(Get.find<RuntRepository>()),
    );
  }
}
