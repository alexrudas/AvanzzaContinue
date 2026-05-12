// ============================================================================
// lib/data/sources/local/network/network_local_datasource.dart
// Interfaz pública del datasource local de la sección "network" de Mi Red.
// ============================================================================
// CONTRATO:
//   - Cada método público es la UNIDAD ATÓMICA de persistencia. Lo que toca
//     (actores + meta + timestamps) entra en UNA SOLA `writeTxn`. Si una sola
//     escritura falla, Isar revierte todo automáticamente (atomicidad
//     garantizada por el motor).
//   - Llamadas que no escriben (gets, search) NUNCA abren `writeTxn`.
//
// LO QUE NO HACE EN V1:
//   - No borra registros. `reconcileFromServer` marca `missingInLastSync=true`
//     en lugar de eliminar (purge real queda para hito posterior).
//   - No ejecuta optimistic writes ni push remoto.
//   - No expone watchSection todavía (se añade en Fase 4 cuando el repo lo
//     necesite). En V1 el repo lee con `getSection` bajo demanda.
// ============================================================================

import 'package:avanzza/data/models/network/network_actor_projection.dart';
import 'package:avanzza/data/models/network/network_section_meta_model.dart';

/// Snapshot puntual de la sección "network" para un workspace.
///
/// `workspaceId` siempre presente — todo consumidor puede verificar
/// pertenencia antes de aplicar el snapshot al UI state.
///
/// `contentSignature` es una firma compacta usada por `Stream.distinct(...)`
/// para evitar rebuild storms. Cambia si y solo si cambia algo relevante para
/// la UI: lista de actores (por ref + updatedAt + displayName) o estado de
/// meta (lastSyncedAt, lastSyncAttemptAt, syncStatus, missingItemCount,
/// itemCountLastSync, projectionSchemaVersion, consecutiveFailures,
/// lastErrorCode).
class NetworkSectionSnapshot {
  final String workspaceId;
  final List<NetworkActorProjection> actors;
  final NetworkSectionMetaModel? meta;

  NetworkSectionSnapshot({
    required this.workspaceId,
    required this.actors,
    required this.meta,
  });

  late final String contentSignature = _computeSignature();

  String _computeSignature() {
    final actorPart = actors
        .map((a) =>
            '${a.actorRefRaw}@${a.updatedAt.millisecondsSinceEpoch}'
            '@${a.displayName.hashCode}'
            '@${a.displayNameNormalized.hashCode}'
            '@${a.providerProfileId ?? ""}'
            '@${a.isRestricted}'
            '@${a.relationshipState}'
            '@${a.primaryCategoryKey}'
            '@${a.categoriesAllKeys.join(",")}')
        .join('|');
    final metaPart = meta == null
        ? '_'
        : [
            meta!.lastSyncedAt?.millisecondsSinceEpoch ?? 0,
            meta!.lastSyncAttemptAt?.millisecondsSinceEpoch ?? 0,
            meta!.syncStatus.name,
            meta!.missingItemCount,
            meta!.itemCountLastSync,
            meta!.projectionSchemaVersion,
            meta!.consecutiveFailures,
            meta!.lastErrorCode ?? '',
          ].join('~');
    return '$workspaceId#$actorPart#$metaPart';
  }

  bool get isEmpty => actors.isEmpty;
}

/// Reporte estructurado del resultado de `reconcileFromServer`. Útil para
/// telemetría y para que el repo decida banners UX.
class ReconcileReport {
  /// # de actores upserted (insertados o reemplazados).
  final int upserted;

  /// # de actores marcados como `missingInLastSync=true` en este reconcile.
  final int markedMissing;

  /// # de actores que se HABRÍAN marcado missing si el blindaje no se hubiera
  /// activado. 0 cuando el blindaje no se activó.
  final int wouldHaveBeenMissing;

  /// True si el blindaje bloqueó el marcado de missing.
  final bool blindajeActivated;

  /// Razón del blindaje cuando se activó:
  ///   - "incoming_empty"     → la respuesta no trajo items.
  ///   - "not_full_snapshot"  → la respuesta es paginada (cursor != null).
  ///   - "delta_over_50"      → más del 50% del set previo desaparecería.
  ///   - null                 → blindaje no se activó.
  final String? blindajeReason;

  /// True si el delta de actores presumiblemente "desaparecidos" supera el
  /// 50% del set previo. Útil para auditoría aunque no detenga la reconcile.
  final bool suspiciousShrink;

  const ReconcileReport({
    required this.upserted,
    required this.markedMissing,
    required this.wouldHaveBeenMissing,
    required this.blindajeActivated,
    required this.blindajeReason,
    required this.suspiciousShrink,
  });
}

abstract class NetworkLocalDataSource {
  /// Lee el snapshot actual de la sección "network" para `workspaceId`.
  ///
  /// [includeMissing] = `true` (default) incluye también los actores marcados
  /// como `missingInLastSync`. La UI V1 los renderiza con badge; la UI V2
  /// podrá ocultarlos pasando `false`.
  Future<NetworkSectionSnapshot> getSection({
    required String workspaceId,
    bool includeMissing = true,
  });

  /// Stream reactivo del snapshot de la sección "network" para `workspaceId`.
  ///
  /// Emite UN snapshot inmediato al suscribirse (estado actual desde Isar),
  /// y re-emite cada vez que cambia cualquiera de:
  ///   - filas de actores filtradas por `workspaceId`
  ///   - fila de meta para `(workspaceId, "network")`
  ///
  /// El consumidor DEBE envolver este stream con `.distinct((a,b) =>
  /// a.contentSignature == b.contentSignature)` para evitar rebuild storms.
  /// El DS no hace distinct internamente para preservar visibilidad de eventos
  /// "silentes" (ej. tests de re-emisión por markSyncFailed).
  ///
  /// Aislamiento por workspace: escrituras en otros workspaces NO generan
  /// emisiones para este stream — verificado por test.
  Stream<NetworkSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  });

  /// Lee solo la metadata de sección (sin cargar actores).
  Future<NetworkSectionMetaModel?> getSectionMeta({
    required String workspaceId,
  });

  /// Reconcilia atómicamente el resultado de un refresh remoto exitoso.
  ///
  /// EN UN SOLO `writeTxn`:
  ///   1. Upsert idempotente de cada `projection` (unique:replace por
  ///      compositeKey). Cada upsert resetea `missingInLastSync=false` y
  ///      `lastSeenAt=now` — actores re-aparecidos se restauran solos.
  ///   2. Marca `missingInLastSync=true` en filas previas de este workspace
  ///      que NO están en `incoming` — SI Y SOLO SI el blindaje pasa.
  ///   3. Actualiza la fila de meta con `lastSyncedAt=now`,
  ///      `syncStatus=confirmed`, `nextCursor`, `serverTime`,
  ///      `itemCountLastSync`, `missingItemCount`, `consecutiveFailures=0`.
  ///
  /// BLINDAJES (si alguno se activa → solo upsert, NO marca missing):
  ///   - `incoming.isEmpty`              → reason="incoming_empty"
  ///   - `!isFullSnapshot`               → reason="not_full_snapshot"
  ///   - delta > 50% del set previo      → reason="delta_over_50"
  ///
  /// ROLLBACK: si cualquier write falla dentro del `writeTxn`, Isar revierte
  /// todo. Meta NUNCA avanza si los actores no se persisten.
  ///
  /// Devuelve `ReconcileReport` con telemetría del intento.
  Future<ReconcileReport> reconcileFromServer({
    required String workspaceId,
    required List<NetworkActorProjection> incoming,
    required bool isFullSnapshot,
    required int schemaVersion,
    String? nextCursor,
    DateTime? serverTime,
    DateTime? now,
  });

  /// Registra un intento de sync fallido. NO toca actores. Atómico (1 writeTxn).
  Future<void> markSyncFailed({
    required String workspaceId,
    required String errorCode,
    DateTime? now,
  });

  /// Búsqueda local por nombre normalizado.
  ///
  /// `query` es texto crudo (sin normalizar). La DS aplica `normalizeForSearch`
  /// internamente y matchea por substring contra `displayNameNormalized`.
  ///
  /// Devuelve lista vacía si `query` queda vacía tras normalización.
  Future<List<NetworkActorProjection>> searchByDisplayName({
    required String workspaceId,
    required String query,
    bool includeMissing = true,
  });
}
