// ============================================================================
// lib/presentation/bindings/admin/network_operational_binding.dart
// NETWORK OPERATIONAL BINDING — GetX Binding
//
// QUÉ HACE:
// - Registra [NetworkOperationalController] con las dependencias resueltas
//   en el momento de navegación a la pantalla.
// - Resuelve orgId desde [SessionContextController] (ya registrado por
//   HomeBinding) y lo pasa al controller como String.
// - Obtiene [PortfolioRepository] desde [DIContainer] — patrón de governance.
//
// QUÉ NO HACE:
// - No inyecta SessionContextController en el controller — solo lee el orgId.
// - No duplica suscripciones — el controller gestiona su propio stream.
//
// PRINCIPIOS:
// - Opción A: orgId fijo en el momento de navegación. El usuario no cambia
//   de organización mid-session sin regresar a Home.
// - PortfolioRepository desde DIContainer(), SessionContextController
//   desde Get.find() — conforme a la gobernanza del proyecto.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Sprint 1 módulo "Mi red operativa" — Propietarios.
// ============================================================================

import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../controllers/admin/network/network_operational_controller.dart';
import '../../controllers/session_context_controller.dart';

class NetworkOperationalBinding extends Bindings {
  @override
  void dependencies() {
    // orgId resuelto aquí — el controller lo recibe como String inmutable.
    // SessionContextController ya está registrado por HomeBinding (fenix: true).
    final orgId =
        Get.find<SessionContextController>().user?.activeContext?.orgId ?? '';

    Get.lazyPut(
      () => NetworkOperationalController(
        DIContainer().portfolioRepository,
        orgId,
      ),
      fenix: true,
    );
  }
}
