import 'package:get/get.dart';

import '../../../core/config/api_endpoints.dart';
import '../../../data/simit/simit_repository.dart';
import '../../../data/simit/simit_service.dart';
import '../../controllers/simit/simit_controller.dart';

/// Binding para las pantallas de consulta SIMIT.
///
/// Este binding registra únicamente las dependencias específicas del módulo SIMIT:
/// - SimitService (capa de servicio HTTP)
/// - SimitRepository (capa de repositorio)
/// - SimitController (controlador GetX)
///
/// IMPORTANTE: Este binding NO registra Dio. El cliente HTTP global
/// ya está registrado en AppBindings y se reutiliza mediante Get.find<Dio>().
class SimitBinding extends Bindings {
  @override
  void dependencies() {
    // Servicio SIMIT (lazy singleton)
    // Usa el Dio global registrado en AppBindings
    // y obtiene el baseUrl desde ApiEndpoints
    Get.lazyPut<SimitService>(
      () => SimitService(
        Get.find(), // Reutiliza el Dio global de AppBindings
        baseUrl: ApiEndpoints.simitBaseUrl,
      ),
    );

    // Repositorio SIMIT (lazy singleton)
    Get.lazyPut<SimitRepository>(
      () => SimitRepository(Get.find<SimitService>()),
    );

    // Controlador SIMIT (lazy singleton)
    Get.lazyPut<SimitController>(
      () => SimitController(Get.find<SimitRepository>()),
    );
  }
}
