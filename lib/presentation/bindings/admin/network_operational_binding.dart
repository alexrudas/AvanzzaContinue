// ============================================================================
// lib/presentation/bindings/admin/network_operational_binding.dart
// NETWORK OPERATIONAL BINDING v2 — ADR actor-canon §10 + §11
// ============================================================================
// QUÉ HACE:
//   - Registra [NetworkOperationalController] con las 4 fuentes canónicas de
//     §10.1 (AssetActorLink, NetworkRelationship, LocalContact, LocalOrganization)
//     resueltas desde DIContainer.
//   - Resuelve orgId desde SessionContextController.
//
// QUÉ NO HACE:
//   - NO resuelve PortfolioRepository (ADR §11 — bypass retirado en 5c).
//   - NO inyecta SessionContextController al controller: solo lee orgId aquí.
//
// See docs/adr/0001-actor-canon.md §10 + §11.
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

    final c = DIContainer();

    Get.lazyPut(
      () => NetworkOperationalController(
        assetActorLinks: c.assetActorLinkRepository,
        localContacts: c.localContactRepository,
        localOrganizations: c.localOrganizationRepository,
        networkRelationships: c.networkRelationshipRepository,
        orgId: orgId,
      ),
      fenix: true,
    );
  }
}
