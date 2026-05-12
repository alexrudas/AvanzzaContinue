// ============================================================================
// lib/presentation/controllers/admin/network/actor_detail_controller.dart
// ACTOR DETAIL CONTROLLER — ficha enriquecida del actor (ADR §10 + §11 + §15)
// ============================================================================
// QUÉ HACE:
//   - Recibe un [NetworkActorVm] seed (el actor seleccionado en la lista).
//   - Dispara queries secundarias componiendo SOLO las 4 fuentes canónicas
//     de §10.1: AssetActorLink, NetworkRelationship, LocalContact,
//     LocalOrganization.
//   - Expone estado reactivo listo para render en `ActorDetailPage`:
//       * libreta completa (LocalContact o LocalOrganization si aplica).
//       * otros vínculos del mismo actor en el workspace (sin el seed).
//       * relationshipState fresco.
//
// QUÉ NO HACE:
//   - NO importa PortfolioRepository (ADR §11 — guardrail activo bloquea).
//   - NO crea entidades derivadas ni un "perfil de actor" paralelo: este
//     controller es composición interna del módulo §10.3.
//   - NO hace mutaciones (suspend/reactivate/close quedan para hito futuro).
//
// DISCIPLINA ANTI-CRECIMIENTO (ADR §15):
//   Este controller es una CAPA DE COMPOSICIÓN, no un "mini-backend dentro del
//   controller". Si alguien considera añadir:
//     - mutaciones (suspend/reactivate/close, terminar vínculos, …)
//     - reglas de negocio (scoring, matching, permisos por rol)
//     - una quinta dependencia más allá de §10.1
//     - cache / persistencia local del detalle
//     - transformaciones complejas (agrupación, ordenamiento, enriquecimiento)
//   → DETENER. Leer §15.2 y §15.3 del ADR para decidir el refactor correcto
//   (controller dedicado · use case en capa application · domain service).
//
// COMPOSICIÓN INTERNA (lo único permitido crecer aquí son queries de lectura):
//   - `_loadOtherLinksForActor`: AssetActorLinkRepository.list(platformActorId|
//     localKind+localId), excluyendo el assetActorLinkId del seed.
//   - `_loadLocalProfile`: watch de la libreta → .first, filtra por id.
//   - `_loadRelationshipState`: NetworkRelationshipRepository.list(localKind,
//     localId, limit:1).
//
// See docs/adr/0001-actor-canon.md §10 (fuentes canónicas), §13 (alcance
// honesto: lectura/composición, NO cierre transversal multi-workspace),
// §14 (regresiones funcionales), §15 (disciplina anti-crecimiento).
// ============================================================================

import 'package:get/get.dart';

import '../../../../domain/entities/core_common/asset_actor_link_entity.dart';
import '../../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../../domain/entities/core_common/local_organization_entity.dart';
import '../../../../domain/entities/core_common/value_objects/actor_ref_kind_value.dart';
import '../../../../domain/entities/core_common/value_objects/relationship_state.dart';
import '../../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../../domain/repositories/core_common/asset_actor_link_repository.dart';
import '../../../../domain/repositories/core_common/local_contact_repository.dart';
import '../../../../domain/repositories/core_common/local_organization_repository.dart';
import '../../../../domain/repositories/core_common/network_relationship_repository.dart';
import '../../../view_models/network/network_actor_vm.dart';

class ActorDetailController extends GetxController {
  // ── Dependencias (§10.1) ──────────────────────────────────────────────────

  final AssetActorLinkRepository _links;
  final LocalContactRepository _contacts;
  final LocalOrganizationRepository _organizations;
  final NetworkRelationshipRepository _relationships;

  // ── Input ────────────────────────────────────────────────────────────────

  /// Actor seleccionado en la lista (VM del hito 5c).
  final NetworkActorVm seed;

  final String _orgId;

  ActorDetailController({
    required AssetActorLinkRepository assetActorLinks,
    required LocalContactRepository localContacts,
    required LocalOrganizationRepository localOrganizations,
    required NetworkRelationshipRepository networkRelationships,
    required this.seed,
    required String orgId,
  })  : _links = assetActorLinks,
        _contacts = localContacts,
        _organizations = localOrganizations,
        _relationships = networkRelationships,
        _orgId = orgId;

  // ── Estado reactivo ──────────────────────────────────────────────────────

  final isLoading = true.obs;
  final error = RxnString();

  /// Libreta del workspace si el seed tiene referencia local a contact.
  /// Null si no aplica (variante platform o contacto archivado).
  final localContact = Rxn<LocalContactEntity>();

  /// Libreta si el seed tiene referencia local a organization.
  final localOrganization = Rxn<LocalOrganizationEntity>();

  /// Estado de la relationship (workspace↔PlatformActor) resuelto en server.
  /// Null si no hay match confirmado (flujo pre-match normal).
  final relationshipState = Rxn<RelationshipState>();

  /// Otros vínculos del mismo actor en el workspace, excluyendo el seed.
  /// Ej: si el actor es owner del vehículo A y driver del vehículo B, al
  /// entrar por el link de A, este RxList contiene el link de B.
  final otherLinks = RxList<AssetActorLinkEntity>([]);

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> reload() => _load();

  // ── Carga ────────────────────────────────────────────────────────────────

  Future<void> _load() async {
    if (_orgId.isEmpty) {
      isLoading.value = false;
      error.value = 'Organización no disponible en la sesión.';
      return;
    }
    isLoading.value = true;
    error.value = null;

    try {
      await Future.wait<void>([
        _loadLocalProfile(),
        _loadOtherLinksForActor(),
        _loadRelationshipState(),
      ]);
    } catch (e) {
      error.value = 'No se pudo cargar la ficha del actor.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Hidrata LocalContact o LocalOrganization según la variante del seed.
  Future<void> _loadLocalProfile() async {
    if (seed.actorRefKind != ActorRefKindValue.local) return;
    if (seed.localKind == null || seed.localId == null) return;

    if (seed.localKind == TargetLocalKind.contact) {
      final all = await _contacts.watchByWorkspace(_orgId).first;
      final found = all.firstWhereOrNull((c) => c.id == seed.localId);
      localContact.value = found;
    } else if (seed.localKind == TargetLocalKind.organization) {
      final all = await _organizations.watchByWorkspace(_orgId).first;
      final found = all.firstWhereOrNull((o) => o.id == seed.localId);
      localOrganization.value = found;
    }
  }

  /// Trae todos los vínculos del mismo actor en el workspace y filtra el seed.
  Future<void> _loadOtherLinksForActor() async {
    AssetActorLinkPage page;
    if (seed.actorRefKind == ActorRefKindValue.platform &&
        seed.platformActorId != null) {
      page = await _links.list(
        platformActorId: seed.platformActorId,
      );
    } else if (seed.localKind != null && seed.localId != null) {
      page = await _links.list(
        localKind: seed.localKind,
        localId: seed.localId,
      );
    } else {
      otherLinks.assignAll(const []);
      return;
    }

    final filtered = page.items
        .where((l) => l.id != seed.assetActorLinkId)
        .toList(growable: false);
    otherLinks.assignAll(filtered);
  }

  /// Consulta el estado de la relationship (si existe). No crítica: si falla,
  /// el detalle sigue funcionando sin ese bloque.
  Future<void> _loadRelationshipState() async {
    if (seed.localKind == null || seed.localId == null) {
      // Variante platform pura: no hay relationship indexada por local*.
      relationshipState.value = seed.relationshipState;
      return;
    }
    try {
      final page = await _relationships.list(
        localKind: seed.localKind,
        localId: seed.localId,
        limit: 1,
      );
      if (page.items.isNotEmpty) {
        relationshipState.value = page.items.first.state;
      } else {
        relationshipState.value = null;
      }
    } catch (_) {
      // Propagar el seed como fallback silencioso — ver ADR §8.2 (filosofía
      // análoga: la relationship es informativa; no bloquea render).
      relationshipState.value = seed.relationshipState;
    }
  }
}
