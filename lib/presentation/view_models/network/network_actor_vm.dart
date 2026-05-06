// ============================================================================
// lib/presentation/view_models/network/network_actor_vm.dart
// NETWORK ACTOR VM — ViewModel genérico para Mi Red Operativa v2
// ============================================================================
// QUÉ HACE:
//   - Proyección in-memory de un vínculo actor↔activo listo para UI.
//   - Un solo shape para TODOS los roles (owner/tenant/driver/technician/
//     workshop/legal/operator). La UI agrupa/filtra por `role`; no hay
//     clases especializadas por rol.
//   - Se construye desde un AssetActorLinkEntity + libreta local opcional
//     (LocalContact / LocalOrganization) para hidratar el nombre visible.
//
// QUÉ NO HACE:
//   - NO deriva de PortfolioEntity (ADR actor-canon §11 — hito 5c mata el
//     bypass). No hay chips de riesgo SIMIT ni licencia: esa información
//     vivía en el flujo portfolio; si se necesita devolver, entra por un
//     flujo server-side de trust/verification, NO por este VM.
//   - NO decide UI ni lógica de render.
//   - NO mutla estado.
//
// PRINCIPIOS:
//   - Genérico primero. Especialización solo cuando haya divergencia real.
//   - `actorKey` deduplica actores en listas: para platform es el
//     platformActorId, para local es "<localKind>:<localId>".
//   - Si no hay displayName hidratado desde libreta, el VM muestra un
//     fallback honesto con la identidad mínima (no inventa).
//
// See docs/adr/0001-actor-canon.md §10 (fuentes canónicas) + §11 (bypass).
// ============================================================================

import '../../../domain/entities/core_common/asset_actor_link_entity.dart';
import '../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../domain/entities/core_common/local_organization_entity.dart';
import '../../../domain/entities/core_common/value_objects/actor_ref_kind_value.dart';
import '../../../domain/entities/core_common/value_objects/asset_actor_role.dart';
import '../../../domain/entities/core_common/value_objects/relationship_state.dart';
import '../../../domain/entities/core_common/value_objects/target_local_kind.dart';

/// ViewModel genérico de un actor de la red operativa.
///
/// Instanciar solo vía [NetworkActorVm.fromAssetActorLink] — el constructor
/// directo existe para tests y para reconstrucción en operaciones no
/// derivadas (ej. edición optimista).
class NetworkActorVm {
  // ── Identidad (clave para dedup + keys Flutter) ────────────────────────────

  /// Clave estable para UI keys y dedup.
  /// - `platform:<uuid>` si actor tiene PlatformActorId asociado.
  /// - `local:<kind>:<uuid>` si solo vive en libreta.
  final String actorKey;

  /// Shape del ActorRef persistido (platform vs local).
  final ActorRefKindValue actorRefKind;

  /// Set si actorRefKind=platform o fila enriquecida.
  final String? platformActorId;

  /// Set si actorRefKind=local.
  final TargetLocalKind? localKind;
  final String? localId;

  // ── Vínculo con el activo ─────────────────────────────────────────────────

  /// ID del vínculo AssetActorLink.
  final String assetActorLinkId;

  /// Activo al que este actor está vinculado.
  final String assetId;

  /// Rol operativo (owner/tenant/driver/etc). Enum fuerte.
  final AssetActorRole role;

  // ── Presentación ──────────────────────────────────────────────────────────

  /// Nombre visible.
  ///   - Local: `LocalContact.displayName` / `LocalOrganization.displayName`
  ///     si se hidrató desde libreta.
  ///   - Platform: vacío en 5c (no hay lectura directa de PlatformActor aún).
  ///   - Fallback: texto neutral con identidad mínima ("Actor · <id-corto>").
  final String displayName;

  // ── Estado operativo ─────────────────────────────────────────────────────

  /// Estado del vínculo en sí (active/ended).
  final String linkStatus;

  /// Fuente del vínculo (user_declared/runt/contract/import).
  final String linkSource;

  /// Estado de la relación operativa (workspace↔PlatformActor) si existe.
  /// Null si el actor es puramente local sin match confirmado.
  final RelationshipState? relationshipState;

  const NetworkActorVm({
    required this.actorKey,
    required this.actorRefKind,
    this.platformActorId,
    this.localKind,
    this.localId,
    required this.assetActorLinkId,
    required this.assetId,
    required this.role,
    required this.displayName,
    required this.linkStatus,
    required this.linkSource,
    this.relationshipState,
  });

  /// Mapper canónico. Recibe el vínculo + (opcional) libreta cliente + (opcional)
  /// estado de relationship. Hidrata displayName desde la fuente correcta.
  factory NetworkActorVm.fromAssetActorLink(
    AssetActorLinkEntity link, {
    LocalContactEntity? localContact,
    LocalOrganizationEntity? localOrganization,
    RelationshipState? relationshipState,
  }) {
    final key = _actorKeyFor(link);
    final name = _displayNameFor(
      link,
      localContact: localContact,
      localOrganization: localOrganization,
    );

    return NetworkActorVm(
      actorKey: key,
      actorRefKind: link.actorRefKind,
      platformActorId: link.platformActorId,
      localKind: link.localKind,
      localId: link.localId,
      assetActorLinkId: link.id,
      assetId: link.assetId,
      role: link.role,
      displayName: name,
      linkStatus: link.status,
      linkSource: link.source,
      relationshipState: relationshipState,
    );
  }

  // ── Helpers estáticos (puros) ─────────────────────────────────────────────

  static String _actorKeyFor(AssetActorLinkEntity link) {
    if (link.actorRefKind == ActorRefKindValue.platform &&
        link.platformActorId != null) {
      return 'platform:${link.platformActorId}';
    }
    if (link.localKind != null && link.localId != null) {
      return 'local:${link.localKind!.wireName}:${link.localId}';
    }
    // Fallback conservador: por id del link. No debería ocurrir (CHECK SQL del
    // backend lo impide), pero sale honesto aquí sin romper la app.
    return 'link:${link.id}';
  }

  static String _displayNameFor(
    AssetActorLinkEntity link, {
    LocalContactEntity? localContact,
    LocalOrganizationEntity? localOrganization,
  }) {
    // Local — hidratar desde libreta cuando se pasó.
    if (link.actorRefKind == ActorRefKindValue.local) {
      if (link.localKind == TargetLocalKind.contact &&
          localContact != null) {
        final n = localContact.displayName.trim();
        if (n.isNotEmpty) return n;
      }
      if (link.localKind == TargetLocalKind.organization &&
          localOrganization != null) {
        final n = localOrganization.displayName.trim();
        if (n.isNotEmpty) return n;
      }
      // Sin libreta: fallback neutro.
      return _minimalFallback(link);
    }

    // Platform: hoy no hay lectura directa de PlatformActor en el cliente.
    // Mostrar fallback honesto; cuando exista el endpoint /platform-actors/:id,
    // se hidrata aquí sin tocar nada más.
    return _minimalFallback(link);
  }

  static String _minimalFallback(AssetActorLinkEntity link) {
    final id =
        link.platformActorId ?? link.localId ?? link.id;
    final short = id.length > 8 ? id.substring(0, 8) : id;
    return 'Actor · $short';
  }
}
