// ============================================================================
// lib/data/models/network/network_actor_cache_model.dart
// NetworkActorCacheModel — caché Isar local-first para sección "network" de Mi Red.
// ============================================================================
// QUÉ HACE:
//   Persiste UNA fila por (workspaceId, actorRefRaw) de la sección "network".
//   Permite render inmediato sin esperar Core API. Sobrevive a kills/cold starts.
//
// REGLAS:
//   - Composite unique: `compositeKey = "$workspaceId|network|$actorRefRaw"`.
//     Construir SIEMPRE vía `makeCompositeKey()`. Garantiza dedupe idempotente
//     en refresh (Isar reemplaza por unique:replace).
//   - `projectionJson` ES la fuente de verdad de los datos del actor. Las
//     columnas indexadas (`displayName`, `displayNameNormalized`, etc.) son
//     denormalizaciones para acelerar queries — se reescriben en cada upsert
//     desde el mismo Projection que generó el JSON.
//   - PROHIBIDO almacenar DetailDTOs en `projectionJson`. Ver invariante en
//     `network_actor_projection.dart`.
//   - V1: campos `clientGeneratedId`, `serverConfirmedAt`, `failedSyncReason`
//     se persisten pero nunca se escriben (siempre null en V1). Reservados
//     para optimistic write futuro sin migración.
//
// MULTI-WORKSPACE:
//   `workspaceId` indexado no-unique. Queries siempre filtran por workspace.
//   Cambio de workspace activo NO purga cache del workspace anterior.
//
// MISSING STRATEGY (V1):
//   En lugar de borrar filas ausentes en un refresh, se marcan con
//   `missingInLastSync=true` + `lastSeenAt`. UI las renderiza con badge
//   discreto. Purge real queda fuera de V1 (sección 3.C del plan).
// ============================================================================

import 'package:isar_community/isar.dart';

import 'network_cache_enums.dart';

part 'network_actor_cache_model.g.dart';

@Collection(inheritance: false)
class NetworkActorCacheModel {
  Id? isarId;

  /// Composite unique key `"$workspaceId|network|$actorRefRaw"`.
  /// Reemplaza idempotente en refresh (unique:replace).
  @Index(unique: true, replace: true)
  late String compositeKey;

  /// Partition key. Indexado para watchSection y queries de purge.
  @Index()
  late String workspaceId;

  /// Wire-stable raw del ref (espejo de `NetworkActorProjection.actorRefRaw`).
  /// Denormalizado para queries directas; canonical vive en `projectionJson`.
  late String actorRefRaw;

  /// Kind extraído del ref ("platform" | "local"). Nunca "user" en network.
  late String actorRefKind;

  /// Id sin prefijo.
  late String actorRefId;

  /// Indexado para resolver provider por id sin scan.
  @Index()
  String? providerProfileId;

  /// Nombre raw para render.
  late String displayName;

  /// Variante normalizada para búsqueda local con `normalizeForSearch`.
  /// Indexado `IndexType.value` para queries `startsWith` / `contains`.
  @Index(type: IndexType.value, caseSensitive: false)
  late String displayNameNormalized;

  /// Wire name de la categoría principal (filtro frecuente).
  @Index()
  late String primaryCategoryKey;

  /// Wire names de TODAS las categorías. Index multi-valor para filtro
  /// "actores que incluyen categoría X".
  @Index(type: IndexType.value)
  late List<String> categoriesAllKeys;

  /// Wire name de `NetworkRelationshipState`.
  late String relationshipState;

  /// Flag de restricción (suspended/closed).
  late bool isRestricted;

  /// Fuente de verdad de los datos del actor. JSON-only-primitives shape
  /// definido por `NetworkActorProjection.toJson()`.
  ///
  /// CAP: tamaño objetivo 150–250 bytes; hard-cap blando 2 KB; log warning
  /// si supera 4 KB en debug.
  late String projectionJson;

  /// `updatedAt` original del actor según backend (de la proyección).
  /// Permite LWW al reconciliar updates concurrentes.
  late DateTime updatedAt;

  /// Cuándo se trajo del backend (no confundir con `meta.lastSyncedAt`
  /// que es a nivel sección).
  late DateTime syncedAt;

  /// True cuando el último refresh exitoso completo NO incluyó este actor.
  /// V1: la fila NO se borra; UI la renderiza con badge discreto.
  /// Vuelve a false si un refresh posterior trae el actor de vuelta.
  @Index()
  late bool missingInLastSync;

  /// Última vez que el backend confirmó la existencia de este actor.
  /// Distinto de `syncedAt`: si en el siguiente refresh el actor desaparece,
  /// `lastSeenAt` queda fijo en el último avistamiento.
  DateTime? lastSeenAt;

  // ───────────── Reservados V2 (optimistic write, NO se escriben en V1) ─────────────

  /// UUID v4 generado client-side al crear actor offline. Null para actores
  /// nacidos del backend. Habilita reconciliación post-confirmación.
  String? clientGeneratedId;

  /// Cuándo el backend confirmó este actor (V2: para items que nacieron
  /// optimistas y luego se confirmaron). V1: siempre null.
  DateTime? serverConfirmedAt;

  /// Última razón de fallo de push (V2). V1: siempre null.
  String? failedSyncReason;

  /// V1: siempre `serverRefresh`.
  @Enumerated(EnumType.name)
  late NetworkCacheSource source;

  /// V1: siempre `confirmed`.
  @Enumerated(EnumType.name)
  late NetworkCacheSyncState syncState;

  // ───────────── Versionado de proyección ─────────────

  /// Versión de la PROYECCIÓN local (no del wire). Si se modifica el shape
  /// de `NetworkActorProjection` (añadir/quitar campos), bump este número
  /// y la fila se considera ZOMBIE → forzará refresh.
  late int projectionSchemaVersion;

  NetworkActorCacheModel();

  /// Sección lógica. Constante para esta colección; usar al construir
  /// compositeKey y para logging.
  static const String sectionKey = 'network';

  /// Composite key canónico. Usar SIEMPRE este helper.
  static String makeCompositeKey({
    required String workspaceId,
    required String actorRefRaw,
  }) =>
      '$workspaceId|$sectionKey|$actorRefRaw';
}
