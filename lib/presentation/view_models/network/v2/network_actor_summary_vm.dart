// ============================================================================
// lib/presentation/view_models/network/v2/network_actor_summary_vm.dart
// NETWORK ACTOR SUMMARY VM — Adaptador UI de NetworkActorSummaryDto
// ============================================================================
// QUÉ HACE:
//   - Adapta NetworkActorSummaryDto a un modelo que la UI consume sin tocar
//     campos serializados ni catálogos cerrados.
//   - Expone:
//       · `actions`: lista de NetworkActionVM (orden preservado).
//       · `groupCategory`: NetworkCategory que decide el agrupamiento UI
//         (alias de primaryCategory por claridad semántica en presentation).
//       · `restrictionReason`: enum no-null cuando isRestricted=true.
//       · helpers booleanos para UI (isPlatform, isLocal, hasContactChannel,
//         requiresInvitationCta).
//
// QUÉ NO HACE:
//   - NO contiene labels en español: la UI resuelve copy via NetworkLabels.
//   - NO ordena ni filtra: orden y agrupamiento se hacen al ensamblar
//     secciones a nivel controller/widget.
//   - NO oculta campos por restricción: el DTO ya garantiza phone/email=null
//     cuando isRestricted=true; aquí solo se reexpone tal cual.
// ============================================================================

import '../../../../data/models/network/network_actor_projection.dart';
import '../../../../data/models/network/network_actor_ref.dart';
import '../../../../data/models/network/network_actor_summary_dto.dart';
import '../../../../data/models/network/network_category.dart';
import '../../../../domain/entities/core_common/value_objects/supplier_type.dart';
import 'network_action_vm.dart';

class NetworkActorSummaryVM {
  /// Referencia parseada (kind ∈ {platform, local}).
  final NetworkActorRef ref;

  final String? displayName;
  final String? avatarRef;

  /// True cuando es una referencia local sin PlatformActor canónico.
  /// Habilita CTAs como "Invitar a la plataforma".
  final bool unresolved;

  /// Categorías a las que pertenece. Garantizado no vacío.
  final List<NetworkCategory> categories;

  /// Categoría que decide el grupo UI. Alias semántico de primaryCategory.
  final NetworkCategory groupCategory;

  final bool isTeamMember;
  final bool isRestricted;

  /// No-null cuando isRestricted=true.
  final NetworkRestrictionReason? restrictionReason;

  final String? primaryPhoneE164;
  final String? primaryEmail;
  final bool hasWhatsApp;

  final NetworkRelationshipState relationshipState;
  final String? providerProfileId;

  /// Acciones calculadas por backend, en el orden recibido.
  final List<NetworkActionVM> actions;

  /// Wire keys raw de secciones del backend (NETWORK_API_SCHEMA_VERSION=2).
  /// Strings opacos: `parts_and_supplies`, `services_and_workshops`, etc.
  /// El mapeo a buckets V1 vive en mi_red_buckets.dart para evitar import
  /// circular y mantener una sola fuente de verdad sobre wire → bucket.
  final List<String> sectionKeys;

  final DateTime updatedAt;

  /// Intención de tipo (productos / servicios / mixto) capturada localmente
  /// al registrar el actor. ESTA ES LA FUENTE DE VERDAD para clasificar
  /// buckets cuando está presente — gana sobre `sectionKeys` del wire.
  ///
  /// Null cuando no hay información local (actor traído por backend que
  /// nunca pasó por el formulario local). En ese caso el bucketizer cae
  /// al fallback de `sectionKeys`.
  ///
  /// Lo construye `MiRedController` resolviendo `actor.ref` contra el
  /// cache local de `LocalContact` (vía `linkedProviderProfileId` o id de
  /// `local:contact:*`). Default `null` preserva backward-compat con todo
  /// caller existente que use `fromDto()` directo.
  final SupplierType? supplierType;

  /// Identidad visual ESTABLE para el widget `key` en listas/grids.
  /// Sobrevive la transición synth → real para el MISMO actor operacional.
  ///
  /// Reglas:
  ///   - Synth (`buildSynthActorVM`): `'contact:<localContact.id>'`.
  ///   - Real enriquecido por merger (ha matcheado LocalContact por link):
  ///     `'contact:<localContact.id>'` — IDÉNTICO al synth previo → Flutter
  ///     conserva el mismo Element/State y NO destruye el tile.
  ///   - Real sin match local: fallback `'ref:<ref.raw>'`.
  ///   - VMs construidos vía `fromDto`/`fromProjection` directos: fallback
  ///     `'ref:<ref.raw>'`.
  ///
  /// Por qué no usar `ref.raw` directamente: durante el dedupe synth → real,
  /// el ref cambia de `local:contact:X` a `platform:Y`. Si el `key` deriva
  /// de ref, Flutter destruye el tile y crea otro → micro-flicker + pérdida
  /// de estado visual (ripples, gestures, animaciones en curso). El
  /// `visualStableKey` ancla la identidad UI al LocalContact estable.
  final String visualStableKey;

  /// Constructor principal. `visualStableKey` opcional: si no se pasa, se
  /// deriva como `'ref:<ref.raw>'` (fallback). Synth y merger lo overriden
  /// con `'contact:<localContactId>'` para que la transición synth → real
  /// preserve la identidad UI.
  NetworkActorSummaryVM({
    required this.ref,
    required this.displayName,
    required this.avatarRef,
    required this.unresolved,
    required this.categories,
    required this.groupCategory,
    required this.isTeamMember,
    required this.isRestricted,
    required this.restrictionReason,
    required this.primaryPhoneE164,
    required this.primaryEmail,
    required this.hasWhatsApp,
    required this.relationshipState,
    required this.providerProfileId,
    required this.actions,
    required this.sectionKeys,
    required this.updatedAt,
    this.supplierType,
    String? visualStableKey,
  }) : visualStableKey = visualStableKey ?? 'ref:${ref.raw}';

  factory NetworkActorSummaryVM.fromDto(NetworkActorSummaryDto dto) =>
      NetworkActorSummaryVM(
        ref: dto.ref,
        displayName: dto.displayName,
        avatarRef: dto.avatarRef,
        unresolved: dto.unresolved,
        categories: dto.categories,
        groupCategory: dto.primaryCategory,
        isTeamMember: dto.isTeamMember,
        isRestricted: dto.isRestricted,
        restrictionReason: dto.restrictionReason,
        primaryPhoneE164: dto.primaryPhoneE164,
        primaryEmail: dto.primaryEmail,
        hasWhatsApp: dto.hasWhatsApp,
        relationshipState: dto.relationshipState,
        providerProfileId: dto.providerProfileId,
        actions: dto.availableActions
            .map(NetworkActionVM.fromDto)
            .toList(growable: false),
        sectionKeys: dto.sectionKeys,
        updatedAt: dto.updatedAt,
        // supplierType queda null aquí — se enriquece después vía
        // `withSupplierType(...)` en el controller.
      );

  /// Construye un VM desde una `NetworkActorProjection` rehidratada del
  /// cache local Isar. Fields que el projection NO preserva intencionalmente
  /// (availableActions, isTeamMember) se rellenan con defaults seguros:
  ///   - actions: empty list (V1 no recalcula offline; UI degrada).
  ///   - isTeamMember: false (network section nunca tiene team members).
  ///
  /// `supplierType` queda null aquí; el controller lo enriquece después
  /// vía merger cuando hay LocalContact match.
  factory NetworkActorSummaryVM.fromProjection(NetworkActorProjection p) {
    final categories = p.categoriesAllKeys
        .map(NetworkCategory.fromWire)
        .toList(growable: false);
    return NetworkActorSummaryVM(
      ref: NetworkActorRef.parse(p.actorRefRaw),
      displayName: p.displayName.isEmpty ? null : p.displayName,
      avatarRef: p.avatarRef,
      // Heurística defensiva: un actor local sin providerProfileId todavía
      // no se considera resuelto a platform.
      unresolved: p.actorRefKind == 'local' && p.providerProfileId == null,
      categories: categories,
      groupCategory: NetworkCategory.fromWire(p.primaryCategoryKey),
      isTeamMember: false,
      isRestricted: p.isRestricted,
      restrictionReason: NetworkRestrictionReason.tryFromWire(p.restrictionReason),
      primaryPhoneE164: p.primaryPhoneE164,
      primaryEmail: p.primaryEmail,
      hasWhatsApp: p.hasWhatsApp,
      relationshipState: NetworkRelationshipState.fromWire(p.relationshipState),
      providerProfileId: p.providerProfileId,
      // Projection drops availableActions a propósito — V1 cae a empty list.
      // V2: NetworkActionResolver recalculará desde (projection + capabilities).
      actions: const <NetworkActionVM>[],
      sectionKeys: List<String>.unmodifiable(p.sectionKeys),
      updatedAt: p.updatedAt,
      // supplierType lo añade el merger tras cruzar con LocalContact.
    );
  }

  /// Copia inmutable con `supplierType` resuelto. Usado por el controller
  /// tras cruzar el ref contra el cache de `LocalContact`. Llamadores que
  /// no tengan información local pueden omitir (default null).
  NetworkActorSummaryVM withSupplierType(SupplierType? supplier) {
    if (supplierType == supplier) return this;
    return NetworkActorSummaryVM(
      ref: ref,
      displayName: displayName,
      avatarRef: avatarRef,
      unresolved: unresolved,
      categories: categories,
      groupCategory: groupCategory,
      isTeamMember: isTeamMember,
      isRestricted: isRestricted,
      restrictionReason: restrictionReason,
      primaryPhoneE164: primaryPhoneE164,
      primaryEmail: primaryEmail,
      hasWhatsApp: hasWhatsApp,
      relationshipState: relationshipState,
      providerProfileId: providerProfileId,
      actions: actions,
      sectionKeys: sectionKeys,
      updatedAt: updatedAt,
      supplierType: supplier,
      visualStableKey: visualStableKey,
    );
  }

  /// Copia inmutable con `visualStableKey` resuelto desde un LocalContact
  /// linkado. Usado por el merger cuando un actor real (ref=platform:Y)
  /// matchea con LocalContact.id=X via linkedProviderProfileId, para que
  /// el tile en la UI no se destruya durante synth → real transition.
  NetworkActorSummaryVM withVisualStableKey(String stableKey) {
    if (visualStableKey == stableKey) return this;
    return NetworkActorSummaryVM(
      ref: ref,
      displayName: displayName,
      avatarRef: avatarRef,
      unresolved: unresolved,
      categories: categories,
      groupCategory: groupCategory,
      isTeamMember: isTeamMember,
      isRestricted: isRestricted,
      restrictionReason: restrictionReason,
      primaryPhoneE164: primaryPhoneE164,
      primaryEmail: primaryEmail,
      hasWhatsApp: hasWhatsApp,
      relationshipState: relationshipState,
      providerProfileId: providerProfileId,
      actions: actions,
      sectionKeys: sectionKeys,
      updatedAt: updatedAt,
      supplierType: supplierType,
      visualStableKey: stableKey,
    );
  }

  // ── Helpers UI ────────────────────────────────────────────────────────

  bool get isPlatform => ref.isPlatform;
  bool get isLocal => ref.isLocal;

  /// Aliado = actor con workspace propio resuelto en Avanzza (platform ref
  /// y NO unresolved). Cualquier otro estado se considera contacto local.
  bool get isAliado => ref.isPlatform && !unresolved;

  /// Inverso de [isAliado]: actores locales o platform-unresolved.
  bool get isContacto => !isAliado;

  /// True si tiene al menos un canal de contacto disponible.
  /// Falso si está restringido (phone/email vienen null por contrato) o si
  /// no se registró canal.
  bool get hasContactChannel =>
      primaryPhoneE164 != null || primaryEmail != null;

  /// True cuando la UI debería ofrecer "Invitar a la plataforma".
  /// Aplica solo a refs locales no resueltas.
  bool get requiresInvitationCta => isLocal && unresolved;
}
