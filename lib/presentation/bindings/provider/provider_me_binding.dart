// ============================================================================
// lib/presentation/bindings/provider/provider_me_binding.dart
// PROVIDER ME BINDING — vista agregada self (MF1).
//
// `lazyPut` con `fenix: true`: si el controller se descarta y la ruta se
// re-visita (p. ej. el user vuelve tras un Get.offAllNamed), se
// reinstancia automáticamente.
// ============================================================================

import 'package:get/get.dart';

import '../../controllers/provider/me/provider_me_controller.dart';

class ProviderMeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderMeController>(
      () => ProviderMeController(),
      fenix: true,
    );
  }
}
