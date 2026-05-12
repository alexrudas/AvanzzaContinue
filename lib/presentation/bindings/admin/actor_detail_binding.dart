// ============================================================================
// lib/presentation/bindings/admin/actor_detail_binding.dart
// ACTOR DETAIL BINDING — GetX binding del detalle (ADR §10 + §11)
// ============================================================================
// QUÉ HACE:
//   - Registra [ActorDetailController] con las 4 fuentes canónicas de §10.1
//     (AssetActorLink, LocalContact, LocalOrganization, NetworkRelationship)
//     resueltas desde DIContainer.
//   - Resuelve el [NetworkActorVm] seed desde Get.arguments['actor'].
//   - Resuelve orgId desde SessionContextController.
//
// QUÉ NO HACE:
//   - NO importa PortfolioRepository (ADR §11).
//   - NO inyecta SessionContextController al controller: solo lee orgId.
//
// PATRÓN DE NAVEGACIÓN:
//   Get.toNamed(Routes.actorDetail, arguments: {'actor': vm})
//
// Si el argument falta o viene mal tipado, el controller NO se registra —
// `ActorDetailPage` maneja el estado guard con un scaffold de error.
// ============================================================================

import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../controllers/admin/network/actor_detail_controller.dart';
import '../../controllers/session_context_controller.dart';
import '../../pages/admin/network/actor_detail_page.dart';
import '../../view_models/network/network_actor_vm.dart';

class ActorDetailBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    final actor =
        args is Map<String, dynamic> ? args[ActorDetailPage.argKey] : null;

    if (actor is! NetworkActorVm) {
      // La página hará su propio guard. No registramos controller con un
      // seed inválido — lazyPut solo se dispara si Get.find lo invoca.
      return;
    }

    final orgId =
        Get.find<SessionContextController>().user?.activeContext?.orgId ?? '';

    final c = DIContainer();

    Get.lazyPut(
      () => ActorDetailController(
        assetActorLinks: c.assetActorLinkRepository,
        localContacts: c.localContactRepository,
        localOrganizations: c.localOrganizationRepository,
        networkRelationships: c.networkRelationshipRepository,
        seed: actor,
        orgId: orgId,
      ),
      // NO fenix: el controller depende del `seed` pasado por arguments.
      // Mantenerlo vivo entre navegaciones es incorrecto — cada actor abre
      // un controller fresco.
    );
  }
}
