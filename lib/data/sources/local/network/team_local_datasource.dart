// ============================================================================
// lib/data/sources/local/network/team_local_datasource.dart
// Interfaz pública del datasource local de la sección "team" de Mi Red.
// ============================================================================
// CONTRATO IGUAL QUE NetworkLocalDataSource:
//   - 1 writeTxn por método. Atomicidad estricta.
//   - No borra registros (missingInLastSync en lugar de delete).
//   - Mismos blindajes anti-mass-delete.
//   - `ReconcileReport` reutilizado desde network_local_datasource.dart.
// ============================================================================

import 'package:avanzza/data/models/network/network_section_meta_model.dart';
import 'package:avanzza/data/models/network/team_actor_projection.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource.dart'
    show ReconcileReport;

/// Snapshot puntual de la sección "team" para un workspace.
///
/// Espejo semántico de `NetworkSectionSnapshot`: `workspaceId` explícito +
/// `contentSignature` para `Stream.distinct(...)`.
class TeamSectionSnapshot {
  final String workspaceId;
  final List<TeamActorProjection> actors;
  final NetworkSectionMetaModel? meta;

  TeamSectionSnapshot({
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
            '@${a.membershipId}'
            '@${a.teamRoleKeys.join(",")}')
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

abstract class TeamLocalDataSource {
  Future<TeamSectionSnapshot> getSection({
    required String workspaceId,
    bool includeMissing = true,
  });

  /// Stream reactivo del snapshot de la sección "team" para `workspaceId`.
  /// Mismos invariantes que `NetworkLocalDataSource.watchSection`: emisión
  /// inicial + re-emisiones por cambios en actores o meta. El consumidor
  /// envuelve con `.distinct(...contentSignature...)` para evitar storms.
  Stream<TeamSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  });

  Future<NetworkSectionMetaModel?> getSectionMeta({
    required String workspaceId,
  });

  Future<ReconcileReport> reconcileFromServer({
    required String workspaceId,
    required List<TeamActorProjection> incoming,
    required bool isFullSnapshot,
    required int schemaVersion,
    String? nextCursor,
    DateTime? serverTime,
    DateTime? now,
  });

  Future<void> markSyncFailed({
    required String workspaceId,
    required String errorCode,
    DateTime? now,
  });

  Future<List<TeamActorProjection>> searchByDisplayName({
    required String workspaceId,
    required String query,
    bool includeMissing = true,
  });
}
