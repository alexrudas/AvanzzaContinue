// ============================================================================
// lib/data/models/network/network_actor_projection.dart
// ============================================================================
// INVARIANTE DE ARQUITECTURA — NO MODIFICAR SIN APROBACIÓN
// ============================================================================
// Esta clase es la ÚNICA fuente válida para el contenido de `projectionJson`
// en `NetworkActorCacheModel`. Es una proyección LIVIANA de Mi Red.
//
// PROHIBIDO añadir aquí:
//   - DetailDTOs completos (ProviderCanonicalResponseDto, etc.).
//   - Entidades de dominio completas (AssetEntity, OrganizationEntity).
//   - Arrays de objetos anidados (NetworkActionDto, ProviderCanonicalSpecialty).
//   - Map<String, dynamic>.
//
// Si necesitas más datos de un actor → navegar a una feature dedicada
// (ej. futuro `provider_detail_local_ds`). NO inflar Mi Red.
//
// Tamaño objetivo serializado: 150–300 bytes. Cap blando: 2 KB. Warning si >4 KB.
//
// `availableActions` NO se cachea. Se recalcula en runtime desde
// (Projection + AccessSnapshot.capabilities) vía `NetworkActionResolver`
// (futuro). Razón: las acciones dependen de capabilities actuales y se vuelven
// stale rápidamente; cachearlas degrada la corrección de los CTAs.
//
// `sectionKeys` SÍ se cachea (cambio V2): es señal wire del bucketizer
// (priority 3 fallback). Sin esto, actores externos sin LocalContact local
// caerían en data debt al leer cache offline. Lista corta de strings opacos,
// no DTOs anidados — cumple el invariante de liviandad.
// ============================================================================

import 'network_actor_summary_dto.dart';

/// Proyección liviana de un actor de Mi Red (sección "network").
///
/// Inmutable. Construir vía [NetworkActorProjection.fromSummaryDto] desde el
/// DTO wire o vía [NetworkActorProjection.fromJson] al rehidratar desde Isar.
class NetworkActorProjection {
  /// Wire-stable raw del `ref` (ej. "platform:uuid", "local:organization:id").
  final String actorRefRaw;

  /// Kind extraído del ref ("platform" | "local" | "user"). Para /v1/network
  /// nunca es "user" por contrato; preservado para forward-compat y consultas.
  final String actorRefKind;

  /// Id sin prefijo (parte después del último `:`).
  final String actorRefId;

  /// Id del ProviderProfile cuando aplica. Null en actores sin perfil.
  final String? providerProfileId;

  /// Nombre tal como vino del backend.
  final String displayName;

  /// Variante normalizada para búsqueda local (ver `normalizeForSearch`).
  final String displayNameNormalized;

  final String? avatarRef;

  /// Wire name de la categoría principal (ej. "workshop", "provider").
  final String primaryCategoryKey;

  /// Wire names de TODAS las categorías. Incluye `primaryCategoryKey`.
  /// Garantizado no vacío por contrato del DTO.
  final List<String> categoriesAllKeys;

  /// Wire name de `NetworkRelationshipState` ("vinculada" | "suspendida" |
  /// "cerrada").
  final String relationshipState;

  /// Cuando true, los canales de contacto vienen null por contrato del DTO.
  final bool isRestricted;

  /// Wire name de `NetworkRestrictionReason` cuando isRestricted=true.
  final String? restrictionReason;

  final String? primaryPhoneE164;
  final String? primaryEmail;
  final bool hasWhatsApp;

  /// Timestamp del último cambio observable del summary según backend.
  final DateTime updatedAt;

  /// Wire keys del backend para bucketing (NETWORK_API_SCHEMA_VERSION=2).
  /// Valores conocidos: `parts_and_supplies`, `services_and_workshops`,
  /// `commercial_advisors`, `legal`, `owners_and_tenants`. Lista posiblemente
  /// vacía si el backend no clasifica al actor.
  ///
  /// PRESERVADO en la proyección (no dropeado) porque la priority chain del
  /// bucketizer cae al wire `sectionKeys` cuando no hay `supplierType` local
  /// (actores externos sin LocalContact en este workspace). Sin este campo,
  /// el cache-first read mandaría a data debt cualquier actor cuya intención
  /// local no haya sido capturada por el formulario.
  final List<String> sectionKeys;

  const NetworkActorProjection({
    required this.actorRefRaw,
    required this.actorRefKind,
    required this.actorRefId,
    required this.providerProfileId,
    required this.displayName,
    required this.displayNameNormalized,
    required this.avatarRef,
    required this.primaryCategoryKey,
    required this.categoriesAllKeys,
    required this.relationshipState,
    required this.isRestricted,
    required this.restrictionReason,
    required this.primaryPhoneE164,
    required this.primaryEmail,
    required this.hasWhatsApp,
    required this.updatedAt,
    required this.sectionKeys,
  });

  /// Construye desde el DTO wire. Drop explícito de:
  ///   - `sectionKeys` (vacío en schemaVersion=2).
  ///   - `unresolved` (derivable de actorRefKind == "local").
  ///   - `isTeamMember` (la colección team es independiente).
  ///   - `availableActions[]` (se recalcula en runtime).
  factory NetworkActorProjection.fromSummaryDto(
    NetworkActorSummaryDto dto, {
    required String displayNameNormalized,
  }) {
    final categories = dto.categories
        .map((c) => c.wireName)
        .toList(growable: false);
    return NetworkActorProjection(
      actorRefRaw: dto.ref.raw,
      actorRefKind: dto.ref.kind.wireName,
      actorRefId: dto.ref.id,
      providerProfileId: dto.providerProfileId,
      displayName: dto.displayName ?? '',
      displayNameNormalized: displayNameNormalized,
      avatarRef: dto.avatarRef,
      primaryCategoryKey: dto.primaryCategory.wireName,
      categoriesAllKeys: categories,
      relationshipState: dto.relationshipState.wireName,
      isRestricted: dto.isRestricted,
      restrictionReason: dto.restrictionReason?.wireName,
      primaryPhoneE164: dto.primaryPhoneE164,
      primaryEmail: dto.primaryEmail,
      hasWhatsApp: dto.hasWhatsApp,
      updatedAt: dto.updatedAt,
      sectionKeys: List<String>.unmodifiable(dto.sectionKeys),
    );
  }

  /// Serialización JSON-only-primitives. Forma del payload que se guarda en
  /// `NetworkActorCacheModel.projectionJson`.
  Map<String, dynamic> toJson() => {
        'actorRefRaw': actorRefRaw,
        'actorRefKind': actorRefKind,
        'actorRefId': actorRefId,
        'providerProfileId': providerProfileId,
        'displayName': displayName,
        'displayNameNormalized': displayNameNormalized,
        'avatarRef': avatarRef,
        'primaryCategoryKey': primaryCategoryKey,
        'categoriesAllKeys': categoriesAllKeys,
        'relationshipState': relationshipState,
        'isRestricted': isRestricted,
        'restrictionReason': restrictionReason,
        'primaryPhoneE164': primaryPhoneE164,
        'primaryEmail': primaryEmail,
        'hasWhatsApp': hasWhatsApp,
        'updatedAt': updatedAt.toIso8601String(),
        'sectionKeys': sectionKeys,
      };

  factory NetworkActorProjection.fromJson(Map<String, dynamic> json) {
    final cats = (json['categoriesAllKeys'] as List<dynamic>?) ?? const [];
    final skeys = (json['sectionKeys'] as List<dynamic>?) ?? const [];
    return NetworkActorProjection(
      actorRefRaw: json['actorRefRaw'] as String,
      actorRefKind: json['actorRefKind'] as String,
      actorRefId: json['actorRefId'] as String,
      providerProfileId: json['providerProfileId'] as String?,
      displayName: json['displayName'] as String,
      displayNameNormalized: json['displayNameNormalized'] as String,
      avatarRef: json['avatarRef'] as String?,
      primaryCategoryKey: json['primaryCategoryKey'] as String,
      categoriesAllKeys:
          cats.map((e) => e as String).toList(growable: false),
      relationshipState: json['relationshipState'] as String,
      isRestricted: json['isRestricted'] as bool,
      restrictionReason: json['restrictionReason'] as String?,
      primaryPhoneE164: json['primaryPhoneE164'] as String?,
      primaryEmail: json['primaryEmail'] as String?,
      hasWhatsApp: json['hasWhatsApp'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sectionKeys: skeys.map((e) => e as String).toList(growable: false),
    );
  }
}
