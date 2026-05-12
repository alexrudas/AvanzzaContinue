// ============================================================================
// lib/presentation/bindings/network/mi_red_binding.dart
// MI RED BINDING — Wires MiRedController con repos del DIContainer
// ============================================================================
// QUÉ HACE:
//   - Registra `MiRedController` en GetX con `lazyPut`. Los repos vienen del
//     DIContainer (singleton ya inicializado en bootstrap).
//   - Patrón estándar del proyecto: Controllers en GetX, repos en DIContainer.
//
// QUÉ NO HACE:
//   - No registra los repos en GetX: ya viven en DIContainer y se acceden
//     directamente. Esto preserva la separación canónica de la app.
//   - No dispara loadInitial: lo hace MiRedPage en initState. El binding solo
//     prepara la dependencia para que `Get.find<MiRedController>()` funcione.
// ============================================================================

import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../controllers/network/v2/mi_red_controller.dart';
import '../../controllers/session_context_controller.dart';

class MiRedBinding extends Bindings {
  @override
  void dependencies() {
    final c = DIContainer();
    final session = Get.isRegistered<SessionContextController>()
        ? Get.find<SessionContextController>()
        : null;
    Get.lazyPut<MiRedController>(
      () => MiRedController(
        networkRepository: c.networkRepository,
        teamRepository: c.teamRepository,
        // SessionContextController es opcional al construir — si no está
        // registrado (cold start raro), la regla conservadora de bucketize
        // sigue siendo suficiente para ocultar el equipo solo-bootstrap.
        currentUserId: session?.user?.uid,
        // DS local de contactos: alimenta la priority chain del bucketizer
        // resolviendo `actor.ref` → SupplierType desde el cache local.
        // Crítico para que un "Proveedor de servicios" registrado caiga
        // en el bucket correcto aunque el wire `sectionKeys` venga mal.
        contactsLocalDataSource: c.localContactLocal,
        // Workspace activo: alimenta el lookup workspace-scoped del DS.
        // Si null/vacío, el mapa queda vacío y el bucketizer cae al wire.
        // `fenix: true` arriba garantiza reconstrucción al cambiar workspace.
        workspaceId: session?.user?.activeContext?.orgId,
      ),
      fenix: true,
    );
  }
}
