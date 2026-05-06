// ============================================================================
// lib/presentation/bindings/provider/provider_bootstrap_binding.dart
// PROVIDER BOOTSTRAP BINDING — wizard de auto-onboarding (MF1).
//
// `lazyPut` (no permanent): el controller se descarta al salir de la
// ruta. Si el wizard se reabre, se reinicia desde Step 0 — comportamiento
// deseado para un flujo one-shot.
// ============================================================================

import 'package:get/get.dart';

import '../../controllers/provider/bootstrap/provider_bootstrap_controller.dart';

class ProviderBootstrapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderBootstrapController>(
      () => ProviderBootstrapController(),
    );
  }
}
