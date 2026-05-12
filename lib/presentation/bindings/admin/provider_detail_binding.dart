// ============================================================================
// lib/presentation/bindings/admin/provider_detail_binding.dart
// PROVIDER DETAIL BINDING — GetX binding de la página de detalle
// ============================================================================
// QUÉ HACE:
//   - Registra [ProviderDetailController] resolviendo el `providerId` desde
//     `Get.arguments` (contrato: {'providerId': '<id>'}).
//   - Usa `Get.create` para que cada navegación a una ficha distinta instancie
//     un controller nuevo con el id correcto.
//
// POR QUÉ SE LEE `Get.arguments` DENTRO DEL CLOSURE:
//   `Get.create<T>(builder)` registra un builder y cada `Get.find<T>()`
//   lo evalúa. Si leyéramos `Get.arguments` en el cuerpo del método
//   `dependencies()` y lo capturáramos en el closure, el id quedaría
//   CONGELADO al primer bind. Consecuencia práctica observada: todas las
//   tarjetas del directorio abrían siempre el mismo detalle. Al leer los
//   argumentos dentro del closure, el controller que produce cada `Get.find`
//   lee siempre los argumentos de la ruta vigente.
//
// QUÉ NO HACE:
//   - NO reserva estado global: cada detalle es instancia propia y se
//     libera al hacer pop.
// ============================================================================

import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../controllers/admin/network/provider_detail_controller.dart';

class ProviderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<ProviderDetailController>(() {
      final args = Get.arguments;
      final providerId = (args is Map && args['providerId'] is String)
          ? args['providerId'] as String
          : '';
      return ProviderDetailController(
        contacts: DIContainer().localContactRepository,
        providerId: providerId,
      );
    });
  }
}
