// ============================================================================
// lib/presentation/controllers/admin/network/network_operational_controller.dart
// NETWORK OPERATIONAL CONTROLLER v2 — ADR actor-canon §10 + §11
// ============================================================================
// QUÉ HACE:
//   - Carga los actores de la red operativa del workspace desde AssetActorLink
//     (fuente canónica §10.1) e hidrata sus nombres desde la libreta del
//     workspace (LocalContact / LocalOrganization).
//   - Expone `actors` (RxList<NetworkActorVm>), filtro por rol, búsqueda por
//     texto, estado de carga y error.
//
// QUÉ NO HACE:
//   - NO depende de PortfolioRepository (ADR §11: bypass eliminado en 5c).
//   - NO inventa VMs por rol: un solo NetworkActorVm cubre todos los casos.
//   - NO envuelve, adaptea ni mantiene fallback al bypass viejo.
//
// DEPS (§10.1):
//   - AssetActorLinkRepository
//   - LocalContactRepository
//   - LocalOrganizationRepository
//   - NetworkRelationshipRepository (para hidratar `relationshipState`)
//
// TENANCY:
//   orgId resuelto por el Binding desde SessionContextController. Inmutable
//   durante la vida del controller.
//
// See docs/adr/0001-actor-canon.md §10 (fuentes permitidas) + §11 (bypass).
// ============================================================================

import 'dart:async';

import 'package:get/get.dart';

import '../../../../domain/entities/core_common/asset_actor_link_entity.dart';
import '../../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../../domain/entities/core_common/local_organization_entity.dart';
import '../../../../domain/entities/core_common/value_objects/actor_ref_kind_value.dart';
import '../../../../domain/entities/core_common/value_objects/asset_actor_role.dart';
import '../../../../domain/entities/core_common/value_objects/relationship_state.dart';
import '../../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../../domain/repositories/core_common/asset_actor_link_repository.dart';
import '../../../../domain/repositories/core_common/local_contact_repository.dart';
import '../../../../domain/repositories/core_common/local_organization_repository.dart';
import '../../../../domain/repositories/core_common/network_relationship_repository.dart';
import '../../../view_models/network/network_actor_vm.dart';

class NetworkOperationalController extends GetxController {
  // ── Dependencias ──────────────────────────────────────────────────────────

  final AssetActorLinkRepository _links;
  final LocalContactRepository _contacts;
  final LocalOrganizationRepository _organizations;
  final NetworkRelationshipRepository _relationships;
  final String _orgId;

  NetworkOperationalController({
    required AssetActorLinkRepository assetActorLinks,
    required LocalContactRepository localContacts,
    required LocalOrganizationRepository localOrganizations,
    required NetworkRelationshipRepository networkRelationships,
    required String orgId,
  })  : _links = assetActorLinks,
        _contacts = localContacts,
        _organizations = localOrganizations,
        _relationships = networkRelationships,
        _orgId = orgId;

  // ── Estado reactivo ──────────────────────────────────────────────────────

  final actors = RxList<NetworkActorVm>([]);
  final isLoading = true.obs;
  final error = RxnString();
  final searchQuery = ''.obs;

  /// Filtro activo por rol. Null = sin filtro (todos los roles).
  final roleFilter = Rxn<AssetActorRole>();

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadInitial();
  }

  // ── Getters computados ───────────────────────────────────────────────────

  /// Lista filtrada por [roleFilter] y [searchQuery] (case-insensitive sobre
  /// displayName).
  List<NetworkActorVm> get filteredActors {
    final role = roleFilter.value;
    final q = searchQuery.value.trim().toLowerCase();
    return actors.where((a) {
      if (role != null && a.role != role) return false;
      if (q.isNotEmpty && !a.displayName.toLowerCase().contains(q)) return false;
      return true;
    }).toList(growable: false);
  }

  /// Conjunto de roles presentes en la carga actual (para chips de filtro UI).
  Set<AssetActorRole> get rolesPresent =>
      actors.map((a) => a.role).toSet();

  // ── Acciones ────────────────────────────────────────────────────────────

  void setRoleFilter(AssetActorRole? role) {
    roleFilter.value = role;
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  /// Recarga manual (pull-to-refresh / botón). Deliberadamente llamada
  /// `reload` en vez de `refresh` para no colisionar con la firma `void
  /// refresh()` de `GetxController` (que hace notifyListeners).
  Future<void> reload() => _loadInitial();

  // ── Carga (interna) ──────────────────────────────────────────────────────

  Future<void> _loadInitial() async {
    if (_orgId.isEmpty) {
      isLoading.value = false;
      error.value = 'Organización no disponible en la sesión.';
      actors.clear();
      return;
    }
    isLoading.value = true;
    error.value = null;

    try {
      // 1) Página inicial de vínculos (solo active por default).
      final page = await _links.list();

      if (page.items.isEmpty) {
        actors.clear();
        isLoading.value = false;
        return;
      }

      // 2) Preload de libreta (un solo fetch por repo). Los ids locales
      //    se buscan en los mapas que armamos abajo. No hay N+1.
      final contacts = await _loadLocalContactsFor(page.items);
      final organizations = await _loadLocalOrganizationsFor(page.items);

      // 3) Resolver relationships (workspace↔platform) SOLO para los actores
      //    con referencia local — los platform puros no tienen estado local.
      //    Evitamos N+1 con una sola llamada list() filtrada por localKind
      //    cuando hay demanda (actualmente consultamos por cada par; el
      //    backend soporta filtro por (localKind, localId) pero no por
      //    colección). Mantenemos simple: una llamada por id único.
      final relationshipStates =
          await _resolveRelationshipStatesFor(page.items);

      // 4) Mapear a VMs.
      final mapped = page.items.map((link) {
        return NetworkActorVm.fromAssetActorLink(
          link,
          localContact: link.localKind == TargetLocalKind.contact
              ? contacts[link.localId]
              : null,
          localOrganization: link.localKind == TargetLocalKind.organization
              ? organizations[link.localId]
              : null,
          relationshipState: relationshipStates[_actorKey(link)],
        );
      }).toList(growable: false);

      actors.assignAll(mapped);
    } catch (e) {
      error.value = 'No se pudo cargar la red operativa.';
      actors.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ── Hidratación de libreta (composición interna, no fuente paralela) ─────

  Future<Map<String, LocalContactEntity>> _loadLocalContactsFor(
    List<AssetActorLinkEntity> links,
  ) async {
    final needed = links
        .where((l) => l.localKind == TargetLocalKind.contact && l.localId != null)
        .map((l) => l.localId!)
        .toSet();
    if (needed.isEmpty) return const {};

    final stream = _contacts.watchByWorkspace(_orgId);
    final all = await stream.first;
    return {
      for (final c in all)
        if (needed.contains(c.id)) c.id: c,
    };
  }

  Future<Map<String, LocalOrganizationEntity>>
      _loadLocalOrganizationsFor(List<AssetActorLinkEntity> links) async {
    final needed = links
        .where((l) =>
            l.localKind == TargetLocalKind.organization && l.localId != null)
        .map((l) => l.localId!)
        .toSet();
    if (needed.isEmpty) return const {};

    final stream = _organizations.watchByWorkspace(_orgId);
    final all = await stream.first;
    return {
      for (final o in all)
        if (needed.contains(o.id)) o.id: o,
    };
  }

  /// Para cada link con referencia local, consulta la relación operativa si
  /// existe. Llaves del mapa: mismo formato de `actorKey` del VM para facilitar
  /// el lookup en el map().
  Future<Map<String, RelationshipState>> _resolveRelationshipStatesFor(
    List<AssetActorLinkEntity> links,
  ) async {
    // De-dup por par (localKind, localId).
    final uniquePairs = <({TargetLocalKind kind, String id})>{};
    for (final l in links) {
      if (l.localKind != null && l.localId != null) {
        uniquePairs.add((kind: l.localKind!, id: l.localId!));
      }
    }
    if (uniquePairs.isEmpty) return const {};

    final out = <String, RelationshipState>{};
    for (final p in uniquePairs) {
      try {
        final page = await _relationships.list(
          localKind: p.kind,
          localId: p.id,
          limit: 1,
        );
        if (page.items.isNotEmpty) {
          final rel = page.items.first;
          // mapa usa la actorKey canónica del VM para lookup directo
          out['local:${p.kind.wireName}:${p.id}'] = rel.state;
        }
      } catch (_) {
        // Relationship no es crítica para el render: omitimos silenciosamente.
      }
    }
    return out;
  }

  String _actorKey(AssetActorLinkEntity link) {
    if (link.actorRefKind == ActorRefKindValue.platform &&
        link.platformActorId != null) {
      return 'platform:${link.platformActorId}';
    }
    if (link.localKind != null && link.localId != null) {
      return 'local:${link.localKind!.wireName}:${link.localId}';
    }
    return 'link:${link.id}';
  }
}
