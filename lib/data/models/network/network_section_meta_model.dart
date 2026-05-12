// ============================================================================
// lib/data/models/network/network_section_meta_model.dart
// NetworkSectionMetaModel — metadata por (workspaceId, sectionKey) de Mi Red.
// ============================================================================
// QUÉ HACE:
//   UNA fila por par (workspaceId, sectionKey ∈ {"network","team"}). Captura el
//   estado de freshness y el resultado del último intento de sincronización.
//
//   No persiste contenido de actores — eso vive en NetworkActorCacheModel /
//   TeamActorCacheModel. Esta tabla responde:
//     · ¿Cuándo fue el último sync exitoso? (lastSyncedAt → freshness class)
//     · ¿Cuándo fue el último intento (éxito o fallo)? (lastSyncAttemptAt)
//     · ¿El último intento falló? (syncStatus + lastErrorCode)
//     · ¿La página inicial está completa o hay más? (nextCursor, hasReachedEnd)
//     · ¿Hubo un shrink sospechoso? (suspiciousShrinkFlag)
//     · ¿Cuántos actores están missing del último sync? (missingItemCount)
//
// REGLAS:
//   - Composite unique: `compositeKey = "$workspaceId|$sectionKey"`. Construir
//     SIEMPRE vía `makeCompositeKey()`.
//   - Esta fila se escribe en la MISMA writeTxn que los upserts de actores
//     en `reconcileFromServer` (atomicidad obligatoria).
//   - `projectionSchemaVersion` permite invalidar selectivamente: si el cliente
//     bumpea la proyección, las filas con versión menor se consideran ZOMBIE
//     forzando refresh.
// ============================================================================

import 'package:isar_community/isar.dart';

import 'network_cache_enums.dart';

part 'network_section_meta_model.g.dart';

@Collection(inheritance: false)
class NetworkSectionMetaModel {
  Id? isarId;

  /// Composite unique key `"$workspaceId|$sectionKey"`.
  @Index(unique: true, replace: true)
  late String compositeKey;

  @Index()
  late String workspaceId;

  /// "network" | "team".
  late String sectionKey;

  /// Versión del schema wire del endpoint (2 para /v1/network, 1 para /v1/team
  /// según contratos actuales). Se actualiza en cada reconcile exitoso.
  late int schemaVersion;

  /// Versión del shape local (`NetworkActorProjection`). Si la versión local
  /// es mayor que la persistida → la fila es zombie por schema, forzar refresh.
  late int projectionSchemaVersion;

  /// Cursor de paginación de la próxima página. Null cuando se llegó al final.
  String? nextCursor;

  /// True cuando el último refresh trajo la página final (nextCursor=null
  /// y la respuesta fue 2xx completa).
  late bool hasReachedEnd;

  /// `serverTime` del envelope de la última respuesta exitosa.
  DateTime? serverTime;

  /// UTC de la última sincronización EXITOSA. Reloj canónico de freshness:
  ///   age = now - lastSyncedAt
  ///   FRESH      ≤ 5 min
  ///   STALE      5 min – 3 d
  ///   VERY_STALE 3 d – 30 d
  ///   HARD_ZOMBIE > 30 d
  /// Null hasta el primer refresh exitoso.
  DateTime? lastSyncedAt;

  /// UTC del último intento (éxito o fallo). Usado para cooldown del refresh.
  DateTime? lastSyncAttemptAt;

  /// Estado del ÚLTIMO intento. Independiente de la freshness por edad.
  @Enumerated(EnumType.name)
  late NetworkSectionSyncStatus syncStatus;

  /// Código compacto de la última falla ("timeout" | "5xx" | "forbidden" |
  /// "authExpired" | "unknown"). Null cuando `syncStatus=confirmed`.
  String? lastErrorCode;

  /// Contador para backoff exponencial. Reset a 0 en cada éxito.
  late int consecutiveFailures;

  /// Tamaño del set de actores tras el último reconcile exitoso. Útil para
  /// telemetría y para detectar shrinks anómalos.
  late int itemCountLastSync;

  /// Conteo de filas con `missingInLastSync=true`. Mantenido en el mismo
  /// writeTxn del reconcile para evitar scan-all en cada render.
  late int missingItemCount;

  /// True si el último reconcile detectó que más del 50% de los actores
  /// previos habrían sido marcados missing (delta sospechoso). En ese caso
  /// el blindaje se activa: NO se marca a nadie missing. Este flag queda
  /// para auditoría y banner UX opcional.
  late bool suspiciousShrinkFlag;

  NetworkSectionMetaModel();

  /// Constante usada para inicializar `projectionSchemaVersion` y validar
  /// freshness por schema. Bump cuando se modifique el shape de las
  /// proyecciones.
  static const int kCurrentProjectionSchemaVersion = 1;

  static String makeCompositeKey({
    required String workspaceId,
    required String sectionKey,
  }) =>
      '$workspaceId|$sectionKey';
}
