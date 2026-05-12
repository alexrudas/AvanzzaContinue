// ============================================================================
// lib/presentation/bindings/network/network_provider_detail_binding.dart
// NETWORK PROVIDER DETAIL BINDING — Wires controller con repo del DIContainer
// ============================================================================
// QUÉ HACE:
//   - Registra `NetworkProviderDetailController` con `Get.create` para que
//     cada navegación a un providerProfileId distinto instancie un controller
//     nuevo con su ID propio (mismo patrón que ProviderDetailBinding legacy).
//   - Lee `Get.arguments` DENTRO del closure de Get.create — leer fuera
//     congela el ID al primer bind.
//
// CONTRATO de navegación:
//   Get.toNamed(Routes.networkProviderDetail,
//       arguments: {'providerProfileId': '<id>'});
//
// QUÉ NO HACE:
//   - No registra el repository: vive en DIContainer (acceso directo).
//   - No toca LocalContactRepository. Esta page consume Core API canonical.
// ============================================================================

import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../controllers/network/v2/network_provider_detail_controller.dart';

class NetworkProviderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<NetworkProviderDetailController>(() {
      final args = Get.arguments;
      final providerProfileId =
          (args is Map && args['providerProfileId'] is String)
              ? args['providerProfileId'] as String
              : '';
      return NetworkProviderDetailController(
        repository: DIContainer().providerCanonicalRepository,
        providerProfileId: providerProfileId,
      );
    });
  }
}
