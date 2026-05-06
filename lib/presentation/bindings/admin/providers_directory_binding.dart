// ============================================================================
// lib/presentation/bindings/admin/providers_directory_binding.dart
// PROVIDERS DIRECTORY BINDING — GetX binding de la página dedicada
// ============================================================================
// QUÉ HACE:
//   - Registra [ProvidersDirectoryController] con `LocalContactRepository`
//     resuelto desde DIContainer y `orgId` leído desde
//     `SessionContextController.user.activeContext.orgId`.
//   - Instancia con `kRoleLabelVendor` (primer rostro del arquetipo).
//
// QUÉ NO HACE:
//   - NO registra repos aquí: esos viven en DIContainer (patrón del proyecto).
//   - NO toca sesión: solo lee orgId una vez al construir el controller.
//   - NO abre puerta a otros roles hoy: si mañana se habilita Taller /
//     Técnico / Asesor, se crearán bindings paralelos parametrizando
//     `roleLabel` (el controller ya acepta el parámetro).
// ============================================================================

import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../controllers/admin/network/providers_directory_controller.dart';
import '../../controllers/session_context_controller.dart';

class ProvidersDirectoryBinding extends Bindings {
  @override
  void dependencies() {
    // SessionContextController ya está registrado por HomeBinding (fenix: true).
    final orgId =
        Get.find<SessionContextController>().user?.activeContext?.orgId ?? '';

    Get.lazyPut(
      () => ProvidersDirectoryController(
        localContacts: DIContainer().localContactRepository,
        orgId: orgId,
      ),
      fenix: true,
    );
  }
}
