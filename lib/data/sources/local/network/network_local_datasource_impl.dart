// ============================================================================
// lib/data/sources/local/network/network_local_datasource_impl.dart
// Impl Isar del DS local de "Mi Red" — sección network. Atomicidad estricta.
// ============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:avanzza/core/utils/text_normalization.dart';
import 'package:avanzza/data/models/network/network_actor_cache_model.dart';
import 'package:avanzza/data/models/network/network_actor_projection.dart';
import 'package:avanzza/data/models/network/network_cache_enums.dart';
import 'package:avanzza/data/models/network/network_section_meta_model.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:isar_community/isar.dart';

class NetworkLocalDataSourceImpl implements NetworkLocalDataSource {
  final Isar _isar;

  /// Hook test-only. Si está seteado, se invoca DENTRO de la writeTxn de
  /// `reconcileFromServer`, justo DESPUÉS de upsert de actores y ANTES de
  /// escribir meta o marcar missing. Si lanza, Isar revierte la txn entera
  /// (actores upserted desaparecen + meta no avanza). Permite testear
  /// atomicidad sin acceso a internals de Isar.
  ///
  /// MUST be null in production. No debe verse desde código no-test.
  @visibleForTesting
  Future<void> Function()? testFailureHookAfterActors;

  NetworkLocalDataSourceImpl(this._isar);

  // ────────────────────────────────────────────────────────────────────────
  // READS — no abren writeTxn
  // ────────────────────────────────────────────────────────────────────────

  @override
  Future<NetworkSectionSnapshot> getSection({
    required String workspaceId,
    bool includeMissing = true,
  }) async {
    final actorRows = includeMissing
        ? await _isar.networkActorCacheModels
            .filter()
            .workspaceIdEqualTo(workspaceId)
            .findAll()
        : await _isar.networkActorCacheModels
            .filter()
            .workspaceIdEqualTo(workspaceId)
            .missingInLastSyncEqualTo(false)
            .findAll();

    actorRows.sort((a, b) => a.actorRefRaw.compareTo(b.actorRefRaw));

    final actors = actorRows.map(_toProjection).toList(growable: false);
    final meta = await _readMeta(workspaceId);
    return NetworkSectionSnapshot(
      workspaceId: workspaceId,
      actors: actors,
      meta: meta,
    );
  }

  @override
  Stream<NetworkSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) {
    late StreamController<NetworkSectionSnapshot> controller;
    StreamSubscription<void>? actorSub;
    StreamSubscription<void>? metaSub;

    final metaCompositeKey = NetworkSectionMetaModel.makeCompositeKey(
      workspaceId: workspaceId,
      sectionKey: NetworkActorCacheModel.sectionKey,
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

    controller = StreamController<NetworkSectionSnapshot>(
      onListen: () {
        // Emisión inicial.
        emitCurrent();
        // Re-emite cuando cambian actores del workspace.
        actorSub = _isar.networkActorCacheModels
            .filter()
            .workspaceIdEqualTo(workspaceId)
            .watchLazy(fireImmediately: false)
            .listen((_) => emitCurrent());
        // Re-emite cuando cambia la meta de la sección.
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
      sectionKey: NetworkActorCacheModel.sectionKey,
    );
    return _isar.networkSectionMetaModels
        .filter()
        .compositeKeyEqualTo(compositeKey)
        .findFirst();
  }

  // ────────────────────────────────────────────────────────────────────────
  // SEARCH
  // ────────────────────────────────────────────────────────────────────────

  @override
  Future<List<NetworkActorProjection>> searchByDisplayName({
    required String workspaceId,
    required String query,
    bool includeMissing = true,
  }) async {
    final qNorm = normalizeForSearch(query);
    if (qNorm.isEmpty) return const [];

    final base = _isar.networkActorCacheModels
        .filter()
        .workspaceIdEqualTo(workspaceId);

    final filtered = includeMissing
        ? base
            .displayNameNormalizedContains(qNorm, caseSensitive: false)
            .findAll()
        : base
            .missingInLastSyncEqualTo(false)
            .displayNameNormalizedContains(qNorm, caseSensitive: false)
            .findAll();

    final rows = await filtered;
    rows.sort((a, b) =>
        a.displayNameNormalized.compareTo(b.displayNameNormalized));
    return rows.map(_toProjection).toList(growable: false);
  }

  // ────────────────────────────────────────────────────────────────────────
  // WRITES — exactamente 1 writeTxn por método
  // ────────────────────────────────────────────────────────────────────────

  @override
  Future<ReconcileReport> reconcileFromServer({
    required String workspaceId,
    required List<NetworkActorProjection> incoming,
    required bool isFullSnapshot,
    required int schemaVersion,
    String? nextCursor,
    DateTime? serverTime,
    DateTime? now,
  }) async {
    final stamp = (now ?? DateTime.now()).toUtc();

    // ── Lecturas previas FUERA de writeTxn (Isar permite reads en paralelo).
    final existing = await _isar.networkActorCacheModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .sourceEqualTo(NetworkCacheSource.serverRefresh)
        .findAll();

    final incomingKeys = incoming
        .map((p) => NetworkActorCacheModel.makeCompositeKey(
              workspaceId: workspaceId,
              actorRefRaw: p.actorRefRaw,
            ))
        .toSet();

    // Candidatos a marcar missing: filas previas (no missing) ausentes en el incoming.
    final candidatesToMark = existing
        .where((row) =>
            !row.missingInLastSync && !incomingKeys.contains(row.compositeKey))
        .toList();

    // BLINDAJES — orden de precedencia.
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

    // ── Construir snapshot del meta ANTES de la txn para tenerlo listo.
    final existingMeta = await _readMeta(workspaceId);

    // ── ÚNICA writeTxn por método.
    int upserted = 0;
    int markedMissing = 0;
    await _isar.writeTxn(() async {
      // 1) Upsert idempotente de incoming.
      if (incoming.isNotEmpty) {
        final models = incoming
            .map((p) => _toCacheModel(
                  projection: p,
                  workspaceId: workspaceId,
                  now: stamp,
                ))
            .toList(growable: false);
        await _isar.networkActorCacheModels.putAll(models);
        upserted = models.length;
      }

      // 1.5) HOOK TEST-ONLY — simula falla post-upsert para test de atomicidad.
      if (testFailureHookAfterActors != null) {
        await testFailureHookAfterActors!();
      }

      // 2) Marcar missing solo si blindaje pasa.
      if (!blindajeActivated && candidatesToMark.isNotEmpty) {
        final updated = candidatesToMark
            .map((row) => row..missingInLastSync = true)
            .toList(growable: false);
        // NO se toca lastSeenAt — queda fijo en el último avistamiento real.
        await _isar.networkActorCacheModels.putAll(updated);
        markedMissing = updated.length;
      }

      // 3) Re-contar missing tras esta txn (incluye los previos que seguían marcados).
      final missingCount = await _isar.networkActorCacheModels
          .filter()
          .workspaceIdEqualTo(workspaceId)
          .missingInLastSyncEqualTo(true)
          .count();

      // 4) Meta confirmada.
      final meta = existingMeta ?? NetworkSectionMetaModel()
        ..compositeKey = NetworkSectionMetaModel.makeCompositeKey(
          workspaceId: workspaceId,
          sectionKey: NetworkActorCacheModel.sectionKey,
        )
        ..workspaceId = workspaceId
        ..sectionKey = NetworkActorCacheModel.sectionKey;
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
          sectionKey: NetworkActorCacheModel.sectionKey,
        )
        ..workspaceId = workspaceId
        ..sectionKey = NetworkActorCacheModel.sectionKey
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
  // MAPPERS — privados
  // ────────────────────────────────────────────────────────────────────────

  NetworkActorCacheModel _toCacheModel({
    required NetworkActorProjection projection,
    required String workspaceId,
    required DateTime now,
  }) {
    return NetworkActorCacheModel()
      ..compositeKey = NetworkActorCacheModel.makeCompositeKey(
        workspaceId: workspaceId,
        actorRefRaw: projection.actorRefRaw,
      )
      ..workspaceId = workspaceId
      ..actorRefRaw = projection.actorRefRaw
      ..actorRefKind = projection.actorRefKind
      ..actorRefId = projection.actorRefId
      ..providerProfileId = projection.providerProfileId
      ..displayName = projection.displayName
      ..displayNameNormalized = projection.displayNameNormalized
      ..primaryCategoryKey = projection.primaryCategoryKey
      ..categoriesAllKeys = projection.categoriesAllKeys
      ..relationshipState = projection.relationshipState
      ..isRestricted = projection.isRestricted
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

  NetworkActorProjection _toProjection(NetworkActorCacheModel m) {
    return NetworkActorProjection.fromJson(
      jsonDecode(m.projectionJson) as Map<String, dynamic>,
    );
  }
}
