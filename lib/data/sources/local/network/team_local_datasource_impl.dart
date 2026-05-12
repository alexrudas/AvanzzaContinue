// ============================================================================
// lib/data/sources/local/network/team_local_datasource_impl.dart
// Impl Isar del DS local de "Mi Red" — sección team. Atomicidad estricta.
// Espejo de NetworkLocalDataSourceImpl, sin categorías ni relationshipState.
// ============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:avanzza/core/utils/text_normalization.dart';
import 'package:avanzza/data/models/network/network_cache_enums.dart';
import 'package:avanzza/data/models/network/network_section_meta_model.dart';
import 'package:avanzza/data/models/network/team_actor_cache_model.dart';
import 'package:avanzza/data/models/network/team_actor_projection.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource.dart';
import 'package:avanzza/data/sources/local/network/team_local_datasource.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:isar_community/isar.dart';

class TeamLocalDataSourceImpl implements TeamLocalDataSource {
  final Isar _isar;

  @visibleForTesting
  Future<void> Function()? testFailureHookAfterActors;

  TeamLocalDataSourceImpl(this._isar);

  // ────────────────────────────────────────────────────────────────────────
  // READS
  // ────────────────────────────────────────────────────────────────────────

  @override
  Future<TeamSectionSnapshot> getSection({
    required String workspaceId,
    bool includeMissing = true,
  }) async {
    final actorRows = includeMissing
        ? await _isar.teamActorCacheModels
            .filter()
            .workspaceIdEqualTo(workspaceId)
            .findAll()
        : await _isar.teamActorCacheModels
            .filter()
            .workspaceIdEqualTo(workspaceId)
            .missingInLastSyncEqualTo(false)
            .findAll();

    actorRows.sort((a, b) => a.membershipId.compareTo(b.membershipId));

    final actors = actorRows.map(_toProjection).toList(growable: false);
    final meta = await _readMeta(workspaceId);
    return TeamSectionSnapshot(
      workspaceId: workspaceId,
      actors: actors,
      meta: meta,
    );
  }

  @override
  Stream<TeamSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) {
    late StreamController<TeamSectionSnapshot> controller;
    StreamSubscription<void>? actorSub;
    StreamSubscription<void>? metaSub;

    final metaCompositeKey = NetworkSectionMetaModel.makeCompositeKey(
      workspaceId: workspaceId,
      sectionKey: TeamActorCacheModel.sectionKey,
    );

    Future<void> emitCurrent() async {
      if (controller.isClosed) return;
      try {
        final snap = await getSection(
          workspaceId: workspaceId,
          includeMissing: includeMissing,
        );
        if (!controller.isClosed) controller.add(snap);
      } catch (e, st) {
        if (!controller.isClosed) controller.addError(e, st);
      }
    }

    controller = StreamController<TeamSectionSnapshot>(
      onListen: () {
        emitCurrent();
        actorSub = _isar.teamActorCacheModels
            .filter()
            .workspaceIdEqualTo(workspaceId)
            .watchLazy(fireImmediately: false)
            .listen((_) => emitCurrent());
        metaSub = _isar.networkSectionMetaModels
            .filter()
            .compositeKeyEqualTo(metaCompositeKey)
            .watchLazy(fireImmediately: false)
            .listen((_) => emitCurrent());
      },
      onCancel: () async {
        await actorSub?.cancel();
        await metaSub?.cancel();
        actorSub = null;
        metaSub = null;
      },
    );

    return controller.stream;
  }

  @override
  Future<NetworkSectionMetaModel?> getSectionMeta({
    required String workspaceId,
  }) =>
      _readMeta(workspaceId);

  Future<NetworkSectionMetaModel?> _readMeta(String workspaceId) async {
    final compositeKey = NetworkSectionMetaModel.makeCompositeKey(
      workspaceId: workspaceId,
      sectionKey: TeamActorCacheModel.sectionKey,
    );
    return _isar.networkSectionMetaModels
        .filter()
        .compositeKeyEqualTo(compositeKey)
        .findFirst();
  }

  @override
  Future<List<TeamActorProjection>> searchByDisplayName({
    required String workspaceId,
    required String query,
    bool includeMissing = true,
  }) async {
    final qNorm = normalizeForSearch(query);
    if (qNorm.isEmpty) return const [];

    final base = _isar.teamActorCacheModels
        .filter()
        .workspaceIdEqualTo(workspaceId);

    final rows = await (includeMissing
        ? base
            .displayNameNormalizedContains(qNorm, caseSensitive: false)
            .findAll()
        : base
            .missingInLastSyncEqualTo(false)
            .displayNameNormalizedContains(qNorm, caseSensitive: false)
            .findAll());

    rows.sort((a, b) =>
        a.displayNameNormalized.compareTo(b.displayNameNormalized));
    return rows.map(_toProjection).toList(growable: false);
  }

  // ────────────────────────────────────────────────────────────────────────
  // WRITES
  // ────────────────────────────────────────────────────────────────────────

  @override
  Future<ReconcileReport> reconcileFromServer({
    required String workspaceId,
    required List<TeamActorProjection> incoming,
    required bool isFullSnapshot,
    required int schemaVersion,
    String? nextCursor,
    DateTime? serverTime,
    DateTime? now,
  }) async {
    final stamp = (now ?? DateTime.now()).toUtc();

    final existing = await _isar.teamActorCacheModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .sourceEqualTo(NetworkCacheSource.serverRefresh)
        .findAll();

    final incomingKeys = incoming
        .map((p) => TeamActorCacheModel.makeCompositeKey(
              workspaceId: workspaceId,
              membershipId: p.membershipId,
            ))
        .toSet();

    final candidatesToMark = existing
        .where((row) =>
            !row.missingInLastSync && !incomingKeys.contains(row.compositeKey))
        .toList();

    String? blindajeReason;
    if (incoming.isEmpty) {
      blindajeReason = 'incoming_empty';
    } else if (!isFullSnapshot) {
      blindajeReason = 'not_full_snapshot';
    } else if (existing.isNotEmpty &&
        candidatesToMark.length / existing.length > 0.5) {
      blindajeReason = 'delta_over_50';
    }
    final blindajeActivated = blindajeReason != null;
    final suspiciousShrink = existing.isNotEmpty &&
        candidatesToMark.length / existing.length > 0.5;

    final existingMeta = await _readMeta(workspaceId);

    int upserted = 0;
    int markedMissing = 0;
    await _isar.writeTxn(() async {
      if (incoming.isNotEmpty) {
        final models = incoming
            .map((p) => _toCacheModel(
                  projection: p,
                  workspaceId: workspaceId,
                  now: stamp,
                ))
            .toList(growable: false);
        await _isar.teamActorCacheModels.putAll(models);
        upserted = models.length;
      }

      if (testFailureHookAfterActors != null) {
        await testFailureHookAfterActors!();
      }

      if (!blindajeActivated && candidatesToMark.isNotEmpty) {
        final updated = candidatesToMark
            .map((row) => row..missingInLastSync = true)
            .toList(growable: false);
        await _isar.teamActorCacheModels.putAll(updated);
        markedMissing = updated.length;
      }

      final missingCount = await _isar.teamActorCacheModels
          .filter()
          .workspaceIdEqualTo(workspaceId)
          .missingInLastSyncEqualTo(true)
          .count();

      final meta = existingMeta ?? NetworkSectionMetaModel()
        ..compositeKey = NetworkSectionMetaModel.makeCompositeKey(
          workspaceId: workspaceId,
          sectionKey: TeamActorCacheModel.sectionKey,
        )
        ..workspaceId = workspaceId
        ..sectionKey = TeamActorCacheModel.sectionKey;
      meta
        ..schemaVersion = schemaVersion
        ..projectionSchemaVersion =
            NetworkSectionMetaModel.kCurrentProjectionSchemaVersion
        ..nextCursor = nextCursor
        ..hasReachedEnd = nextCursor == null
        ..serverTime = serverTime
        ..lastSyncedAt = stamp
        ..lastSyncAttemptAt = stamp
        ..syncStatus = NetworkSectionSyncStatus.confirmed
        ..lastErrorCode = null
        ..consecutiveFailures = 0
        ..itemCountLastSync = incoming.length
        ..missingItemCount = missingCount
        ..suspiciousShrinkFlag = suspiciousShrink;
      await _isar.networkSectionMetaModels.put(meta);
    });

    return ReconcileReport(
      upserted: upserted,
      markedMissing: markedMissing,
      wouldHaveBeenMissing:
          blindajeActivated ? candidatesToMark.length : markedMissing,
      blindajeActivated: blindajeActivated,
      blindajeReason: blindajeReason,
      suspiciousShrink: suspiciousShrink,
    );
  }

  @override
  Future<void> markSyncFailed({
    required String workspaceId,
    required String errorCode,
    DateTime? now,
  }) async {
    final stamp = (now ?? DateTime.now()).toUtc();
    final existing = await _readMeta(workspaceId);

    await _isar.writeTxn(() async {
      final meta = existing ?? NetworkSectionMetaModel()
        ..compositeKey = NetworkSectionMetaModel.makeCompositeKey(
          workspaceId: workspaceId,
          sectionKey: TeamActorCacheModel.sectionKey,
        )
        ..workspaceId = workspaceId
        ..sectionKey = TeamActorCacheModel.sectionKey
        ..schemaVersion = existing?.schemaVersion ?? 0
        ..projectionSchemaVersion = existing?.projectionSchemaVersion ??
            NetworkSectionMetaModel.kCurrentProjectionSchemaVersion
        ..nextCursor = existing?.nextCursor
        ..hasReachedEnd = existing?.hasReachedEnd ?? false
        ..serverTime = existing?.serverTime
        ..lastSyncedAt = existing?.lastSyncedAt
        ..itemCountLastSync = existing?.itemCountLastSync ?? 0
        ..missingItemCount = existing?.missingItemCount ?? 0
        ..suspiciousShrinkFlag = existing?.suspiciousShrinkFlag ?? false
        ..consecutiveFailures = existing?.consecutiveFailures ?? 0;

      meta
        ..lastSyncAttemptAt = stamp
        ..syncStatus = NetworkSectionSyncStatus.syncFailed
        ..lastErrorCode = errorCode
        ..consecutiveFailures = (existing?.consecutiveFailures ?? 0) + 1;
      await _isar.networkSectionMetaModels.put(meta);
    });
  }

  // ────────────────────────────────────────────────────────────────────────
  // MAPPERS
  // ────────────────────────────────────────────────────────────────────────

  TeamActorCacheModel _toCacheModel({
    required TeamActorProjection projection,
    required String workspaceId,
    required DateTime now,
  }) {
    return TeamActorCacheModel()
      ..compositeKey = TeamActorCacheModel.makeCompositeKey(
        workspaceId: workspaceId,
        membershipId: projection.membershipId,
      )
      ..workspaceId = workspaceId
      ..actorRefRaw = projection.actorRefRaw
      ..userId = projection.userId
      ..membershipId = projection.membershipId
      ..displayName = projection.displayName
      ..displayNameNormalized = projection.displayNameNormalized
      ..projectionJson = jsonEncode(projection.toJson())
      ..updatedAt = projection.updatedAt
      ..syncedAt = now
      ..missingInLastSync = false
      ..lastSeenAt = now
      ..source = NetworkCacheSource.serverRefresh
      ..syncState = NetworkCacheSyncState.confirmed
      ..projectionSchemaVersion =
          NetworkSectionMetaModel.kCurrentProjectionSchemaVersion;
  }

  TeamActorProjection _toProjection(TeamActorCacheModel m) {
    return TeamActorProjection.fromJson(
      jsonDecode(m.projectionJson) as Map<String, dynamic>,
    );
  }
}
