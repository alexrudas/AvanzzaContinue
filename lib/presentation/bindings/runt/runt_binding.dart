import 'package:get/get.dart';

import '../../../core/config/api_endpoints.dart';
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
/// IMPORTANTE: Este binding NO registra Dio. El cliente HTTP global
/// ya está registrado en AppBindings y se reutiliza mediante Get.find<Dio>().
class RuntBinding extends Bindings {
  @override
  void dependencies() {
    // Servicio RUNT (lazy singleton)
    // Usa el Dio global registrado en AppBindings
    // y obtiene el baseUrl desde ApiEndpoints
    Get.lazyPut<RuntService>(
      () => RuntService(
        Get.find(), // Reutiliza el Dio global de AppBindings
        baseUrl: ApiEndpoints.runtBaseUrl,
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
