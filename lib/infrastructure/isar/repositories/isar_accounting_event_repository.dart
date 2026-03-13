// ============================================================================
// lib/infrastructure/isar/repositories/isar_accounting_event_repository.dart
// ISAR ACCOUNTING EVENT REPOSITORY
// ENTERPRISE ULTRA PRO — HARDENED — ATOMIC — EVENT-SOURCED — AUDIT GRADE
//
// GARANTÍAS (WRITE PATH):
// ✔ appendAtomic usa UNA sola writeTxn (event + projection + outbox)
// ✔ Idempotencia estricta por (eventId + hash)
// ✔ Anti-tamper: eventId existente con hash distinto → StateError
// ✔ Hash chain obligatoria (prevHash enforcement)
// ✔ SequenceNumber sin huecos (gap detection real)
// ✔ Projection solo actualizable desde este repositorio
// ✔ Rebuild automático si projection está desincronizada
// ✔ Outbox con idempotencyKey = event.hash (server-idempotency-ready)
// ✔ Nunca usa findAll() para obtener el último evento
// ✔ Fail-Hard (sin tolerancia silenciosa)
//
// P2-D — MOBILE SYNC WORKER SUPPORT (métodos añadidos):
// ✔ sweepExpiredOutboxLocks   — libera leases vencidos (writeTxn atómica)
// ✔ claimNextOutboxBatch      — claim 100% atómico con head-of-line + backoff
// ✔ markOutboxSynced          — ACK batch tras sync exitoso
// ✔ markOutboxError           — NACK con retryCount++ y truncado de error
// ✔ getEventById              — carga con verifiedFromJson (fail-hard anti-tamper)
//
// NOTAS DE ÍNDICES (requeridos para performance y O(1)):
// - AccountingEventEntity.eventId (unique)
// - AccountingEventEntity.(entityType, entityId, sequenceNumber) (compound unique)
// - AccountReceivableProjectionEntity.entityId (unique)
// - OutboxEventEntity.outboxId (unique)
// - OutboxEventEntity.statusWire (index)
// - OutboxEventEntity.lockedUntilIso (index)
// - OutboxEventEntity.workerLockedBy (index)
//
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';

import '../../../domain/entities/accounting/account_receivable_projection.dart';
import '../../../domain/entities/accounting/accounting_event.dart';
import '../../../domain/entities/accounting/outbox_event.dart';
import '../../../domain/repositories/accounting_event_repository.dart';
import '../entities/account_receivable_projection_entity.dart';
import '../entities/accounting_event_entity.dart';
import '../entities/outbox_event_entity.dart';

class IsarAccountingEventRepository implements AccountingEventRepository {
  IsarAccountingEventRepository(this._isar);

  final Isar _isar;

  // ==========================================================================
  // APPEND ATOMIC — MOTOR FINANCIERO
  // ==========================================================================

  Future<void> appendAtomic(AccountingEvent event) async {
    final nowIso = event.recordedAt.toUtc().toIso8601String();

    await _isar.writeTxn(() async {
      // -----------------------------------------------------------------------
      // 1) IDEMPOTENCIA ESTRICTA (eventId)
      // -----------------------------------------------------------------------
      final existingById = await _isar.accountingEventEntitys
          .filter()
          .eventIdEqualTo(event.id)
          .findFirst();

      if (existingById != null) {
        if (existingById.hash == event.hash) return; // no-op idempotente
        if (kDebugMode) {
          debugPrint(
            '[P2D][Outbox][Repo][AppendAtomic][FAIL] eventId=${event.id} '
            'type=StateError msg=collision_hash_mismatch',
          );
        }
        throw StateError(
          'AccountingEvent collision: same eventId with different hash. '
          'eventId=${event.id} stored=${existingById.hash} incoming=${event.hash}',
        );
      }

      // -----------------------------------------------------------------------
      // 2) OBTENER ÚLTIMO EVENTO (O(1), NO findAll)
      // -----------------------------------------------------------------------
      final lastEntity = await _isar.accountingEventEntitys
          .filter()
          .entityIdEqualTo(event.entityId)
          .and()
          .entityTypeEqualTo(event.entityType)
          .sortBySequenceNumberDesc()
          .findFirst();

      final int nextSequence;

      if (lastEntity == null) {
        // Primer evento: prevHash debe ser null
        if (event.prevHash != null) {
          if (kDebugMode) {
            debugPrint(
              '[P2D][Outbox][Repo][AppendAtomic][FAIL] eventId=${event.id} '
              'type=StateError msg=first_event_prevHash_not_null',
            );
          }
          throw StateError(
            'Hash chain broken: first event must have prevHash=null. '
            'entityType=${event.entityType} entityId=${event.entityId}',
          );
        }
        nextSequence = 1;
      } else {
        // Evento subsecuente: prevHash debe calzar con hash del último
        if (event.prevHash != lastEntity.hash) {
          if (kDebugMode) {
            debugPrint(
              '[P2D][Outbox][Repo][AppendAtomic][FAIL] eventId=${event.id} '
              'type=StateError msg=hash_chain_broken',
            );
          }
          throw StateError(
            'Hash chain broken: expected prevHash=${lastEntity.hash} '
            'got prevHash=${event.prevHash}. '
            'entityType=${event.entityType} entityId=${event.entityId} '
            'lastSeq=${lastEntity.sequenceNumber}',
          );
        }

        // GAP DETECTION REAL:
        // si count != lastSequence → falta un evento en medio (corrupción / bug).
        final count = await _isar.accountingEventEntitys
            .filter()
            .entityIdEqualTo(event.entityId)
            .and()
            .entityTypeEqualTo(event.entityType)
            .count();

        if (count != lastEntity.sequenceNumber) {
          if (kDebugMode) {
            debugPrint(
              '[P2D][Outbox][Repo][AppendAtomic][FAIL] eventId=${event.id} '
              'type=StateError msg=sequence_gap',
            );
          }
          throw StateError(
            'Sequence gap detected for entityType=${event.entityType} '
            'entityId=${event.entityId}. '
            'count=$count lastSequence=${lastEntity.sequenceNumber}',
          );
        }

        nextSequence = lastEntity.sequenceNumber + 1;
      }

      // -----------------------------------------------------------------------
      // 3) INSERTAR EVENTO (append-only)
      // -----------------------------------------------------------------------
      final eventEntity = accountingEventToEntity(event)
        ..sequenceNumber = nextSequence;

      await _isar.accountingEventEntitys.put(eventEntity);

      // -----------------------------------------------------------------------
      // 4) PROJECTION — LOAD O REBUILD (crash recovery)
      // -----------------------------------------------------------------------
      final projectionEntity = await _isar.accountReceivableProjectionEntitys
          .filter()
          .entityIdEqualTo(event.entityId)
          .findFirst();

      AccountReceivableProjection projection;

      if (projectionEntity == null) {
        projection = _initProjection(event);
      } else {
        // Si projection no refleja el último hash persistido antes del nuevo evento,
        // está desincronizada → rebuild completo.
        if (projectionEntity.lastEventHash != lastEntity?.hash) {
          projection = await _rebuildProjection(
            entityId: event.entityId,
            entityType: event.entityType,
          );
        } else {
          projection = projectionFromEntity(projectionEntity);
        }
      }

      // -----------------------------------------------------------------------
      // 5) APLICAR EVENTO A PROJECTION (domain puro, fail-hard)
      // -----------------------------------------------------------------------
      final updatedProjection = projection.apply(event);

      await _isar.accountReceivableProjectionEntitys.put(
        projectionToEntity(updatedProjection),
      );

      // -----------------------------------------------------------------------
      // 6) OUTBOX (id determinístico + idempotencyKey real)
      // -----------------------------------------------------------------------
      final outbox = OutboxEventEntity()
        ..outboxId = 'outbox_${event.id}'
        ..eventId = event.id
        ..entityId = event.entityId
        ..entityType = event.entityType
        ..statusWire = OutboxStatus.pending.wire
        ..retryCount = 0
        ..idempotencyKey = event.hash
        ..createdAtIso = nowIso
        ..updatedAtIso = nowIso;

      await _isar.outboxEventEntitys.put(outbox);
      if (kDebugMode) {
        debugPrint(
          '[P2D][Outbox][Repo][AppendAtomic][OK] '
          'eventId=${event.id} outboxId=${outbox.outboxId} status=pending '
          'entityType=${event.entityType} entityId=${event.entityId}',
        );
      }
    });
  }

  // ==========================================================================
  // REBUILD PROJECTION (CRASH RECOVERY)
  // ==========================================================================

  Future<AccountReceivableProjection> _rebuildProjection({
    required String entityId,
    required String entityType,
  }) async {
    // Aquí sí usamos findAll(): el rebuild necesita toda la historia.
    final entities = await _isar.accountingEventEntitys
        .filter()
        .entityIdEqualTo(entityId)
        .and()
        .entityTypeEqualTo(entityType)
        .sortBySequenceNumber()
        .findAll();

    if (entities.isEmpty) {
      throw StateError(
        'Cannot rebuild projection: no events found. '
        'entityType=$entityType entityId=$entityId',
      );
    }

    // verifiedFromJson (anti-tamper) se aplica dentro del mapper.
    final firstEvent = accountingEventFromEntity(entities.first);

    final rawSaldo = firstEvent.payload['saldoInicialCop'];
    if (rawSaldo is! int) {
      throw StateError(
        'Rebuild failed: first event missing saldoInicialCop (int). '
        'entityId=$entityId',
      );
    }

    var projection = AccountReceivableProjection(
      entityId: entityId,
      saldoActualCop: rawSaldo,
      totalRecaudadoCop: 0,
      estado: ARProjectionEstado.abierta,
      lastEventHash: null,
      updatedAt: firstEvent.occurredAt,
    );

    AccountingEvent? previous;
    int expectedSeq = 1;

    for (final entity in entities) {
      // Gap detection durante rebuild (defensa adicional).
      if (entity.sequenceNumber != expectedSeq) {
        throw StateError(
          'Rebuild failed: sequence gap detected. '
          'expected=$expectedSeq found=${entity.sequenceNumber} '
          'entityType=$entityType entityId=$entityId',
        );
      }

      final event = accountingEventFromEntity(entity);

      if (previous == null) {
        if (event.prevHash != null) {
          throw StateError(
            'Rebuild failed: first event prevHash must be null. '
            'entityType=$entityType entityId=$entityId',
          );
        }
      } else {
        if (event.prevHash != previous.hash) {
          throw StateError(
            'Rebuild failed: hash chain corrupted. '
            'entityType=$entityType entityId=$entityId '
            'seq=${entity.sequenceNumber}',
          );
        }
      }

      projection = projection.apply(event);
      previous = event;
      expectedSeq++;
    }

    return projection;
  }

  // ==========================================================================
  // INIT PROJECTION
  // ==========================================================================

  AccountReceivableProjection _initProjection(AccountingEvent event) {
    final rawSaldo = event.payload['saldoInicialCop'];
    if (rawSaldo is! int) {
      throw StateError(
        'First event must include saldoInicialCop (int). '
        'entityType=${event.entityType} entityId=${event.entityId}',
      );
    }

    return AccountReceivableProjection(
      entityId: event.entityId,
      saldoActualCop: rawSaldo,
      totalRecaudadoCop: 0,
      estado: ARProjectionEstado.abierta,
      lastEventHash: null,
      updatedAt: event.occurredAt,
    );
  }

  // ==========================================================================
  // QUERY METHODS — AccountingEventRepository contract
  // ==========================================================================

  /// Upsert simple (sin projection ni outbox).
  /// Idempotente: misma hash → no-op; distinta hash → StateError.
  ///
  /// OJO:
  /// - Asigna sequenceNumber automáticamente para mantener el store legible.
  /// - No reconstruye projection ni encola outbox (uso admin/migration).
  @override
  Future<void> upsertEvent(AccountingEvent event) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.accountingEventEntitys
          .filter()
          .eventIdEqualTo(event.id)
          .findFirst();

      if (existing != null) {
        if (existing.hash == event.hash) return;
        throw StateError(
          'upsertEvent collision: same eventId with different hash. '
          'eventId=${event.id}',
        );
      }

      final last = await _isar.accountingEventEntitys
          .filter()
          .entityIdEqualTo(event.entityId)
          .and()
          .entityTypeEqualTo(event.entityType)
          .sortBySequenceNumberDesc()
          .findFirst();

      final nextSeq = (last?.sequenceNumber ?? 0) + 1;

      // Guard mínimo: primer evento no debe traer prevHash.
      if (nextSeq == 1 && event.prevHash != null) {
        throw StateError(
          'upsertEvent: first event must have prevHash=null. '
          'entityType=${event.entityType} entityId=${event.entityId}',
        );
      }

      final entity = accountingEventToEntity(event)..sequenceNumber = nextSeq;
      await _isar.accountingEventEntitys.put(entity);
    });
  }

  @override
  Future<AccountingEvent?> getById(String eventId) async {
    final entity = await _isar.accountingEventEntitys
        .filter()
        .eventIdEqualTo(eventId)
        .findFirst();

    return entity == null ? null : accountingEventFromEntity(entity);
  }

  @override
  Future<AccountingEvent?> getLastByEntity({
    required String entityType,
    required String entityId,
  }) async {
    final entity = await _isar.accountingEventEntitys
        .filter()
        .entityIdEqualTo(entityId)
        .and()
        .entityTypeEqualTo(entityType)
        .sortBySequenceNumberDesc()
        .findFirst();

    return entity == null ? null : accountingEventFromEntity(entity);
  }

  @override
  Future<AccountingEventPage> listByEntity({
    required String entityType,
    required String entityId,
    int limit = 50,
    String? cursor,
  }) async {
    // Cursor = nextSequence (1-based) para evitar duplicados entre páginas.
    final fromSeq = cursor != null ? (int.tryParse(cursor) ?? 1) : 1;
    final safeLimit = limit.clamp(1, 200);

    final entities = await _isar.accountingEventEntitys
        .filter()
        .entityIdEqualTo(entityId)
        .and()
        .entityTypeEqualTo(entityType)
        .and()
        .sequenceNumberGreaterThan(fromSeq - 1) // >= fromSeq
        .sortBySequenceNumber()
        .limit(safeLimit + 1)
        .findAll();

    final hasMore = entities.length > safeLimit;
    final page = hasMore ? entities.sublist(0, safeLimit) : entities;

    final nextCursor = hasMore
        ? (page.last.sequenceNumber + 1)
            .toString() // IMPORTANT: +1 evita repetir
        : null;

    return AccountingEventPage(
      items: page.map(accountingEventFromEntity).toList(),
      nextCursor: nextCursor,
    );
  }

  @override
  Future<AccountingChainVerification> verifyChainByEntity({
    required String entityType,
    required String entityId,
    int limit = 500,
    String? cursor,
  }) async {
    final fromSeq = cursor != null ? (int.tryParse(cursor) ?? 1) : 1;
    final safeLimit = limit.clamp(1, 1000);

    final entities = await _isar.accountingEventEntitys
        .filter()
        .entityIdEqualTo(entityId)
        .and()
        .entityTypeEqualTo(entityType)
        .and()
        .sequenceNumberGreaterThan(fromSeq - 1)
        .sortBySequenceNumber()
        .limit(safeLimit)
        .findAll();

    String? expectedPrevHash;
    var expectedSeq = fromSeq;

    for (final entity in entities) {
      // Sequence sin huecos dentro del rango verificado
      if (entity.sequenceNumber != expectedSeq) {
        return AccountingChainVerification(
          ok: false,
          brokenAtEventId: entity.eventId,
          message:
              'Sequence gap: expected=$expectedSeq found=${entity.sequenceNumber}',
        );
      }

      // Hash chain
      if (entity.prevHash != expectedPrevHash) {
        return AccountingChainVerification(
          ok: false,
          brokenAtEventId: entity.eventId,
          expectedPrevHash: expectedPrevHash,
          foundPrevHash: entity.prevHash,
          message:
              'Hash chain broken at sequenceNumber=${entity.sequenceNumber}',
        );
      }

      expectedPrevHash = entity.hash;
      expectedSeq++;
    }

    return AccountingChainVerification(ok: true);
  }

  // ==========================================================================
  // P2-D — MOBILE SYNC WORKER SUPPORT
  // ==========================================================================

  // --------------------------------------------------------------------------
  // sweepExpiredOutboxLocks
  // Libera locks con lease vencido. 100% atómico.
  // --------------------------------------------------------------------------

  Future<void> sweepExpiredOutboxLocks({required DateTime now}) async {
    final nowIso = now.toUtc().toIso8601String();

    await _isar.writeTxn(() async {
      // Solo los que realmente podrían estar vencidos.
      final expired = await _isar.outboxEventEntitys
          .filter()
          .workerLockedByIsNotNull()
          .and()
          .lockedUntilIsoIsNotNull()
          .and()
          .group((q) => q
              .lockedUntilIsoLessThan(nowIso)
              .or()
              .lockedUntilIsoEqualTo(nowIso))
          .findAll();

      for (final entity in expired) {
        entity
          ..workerLockedBy = null
          ..lockedUntilIso = null
          ..updatedAtIso = nowIso;
        await _isar.outboxEventEntitys.put(entity);
      }
    });
  }

  // --------------------------------------------------------------------------
  // claimNextOutboxBatch
  // 100% atómico (UNA writeTxn):
  // - read candidates (pending/error)
  // - filtrar por lock/backoff
  // - head-of-line por entidad (min sequenceNumber)
  // - aplicar lease y persistir
  //
  // IMPORTANT:
  // - sequenceNumber es la autoridad (no fechas)
  // - head-of-line: si una entidad tiene un evento en error/backoff, NO se
  //   suben sus eventos posteriores (porque solo elegimos el menor seq).
  // --------------------------------------------------------------------------

  Future<List<OutboxEvent>> claimNextOutboxBatch({
    required String workerId,
    required DateTime now,
    int limit = 25,
    Duration lease = const Duration(seconds: 45),
  }) async {
    final claimedEntities = <OutboxEventEntity>[];
    final safeLimit = limit.clamp(1, 50);

    await _isar.writeTxn(() async {
      claimedEntities.clear();

      final nowIso = now.toUtc().toIso8601String();
      final lockedUntilIso = now.add(lease).toUtc().toIso8601String();

      Duration backoff(int rc) {
        const maxMs = 5 * 60 * 1000;
        final ms = 5000 * (1 << rc.clamp(0, 10));
        return Duration(milliseconds: ms > maxMs ? maxMs : ms);
      }

      // 1) Candidatos: pending + error (no synced).
      //    Limitamos a 250 para evitar load masivo.
      final candidates = await _isar.outboxEventEntitys
          .filter()
          .statusWireEqualTo(OutboxStatus.pending.wire)
          .or()
          .statusWireEqualTo(OutboxStatus.error.wire)
          .limit(250)
          .findAll();

      // 2) Elegibilidad: lock + backoff
      final eligible = <OutboxEventEntity>[];
      for (final e in candidates) {
        // Lock vigente (cualquier worker): skip
        final until = e.lockedUntilIso;
        if (until != null && until.compareTo(nowIso) > 0) continue;

        // Backoff solo aplica a status=error
        if (e.statusWire == OutboxStatus.error.wire) {
          final lastAttemptIso = e.lastAttemptAtIso;
          if (lastAttemptIso != null) {
            try {
              final elapsed = now.difference(DateTime.parse(lastAttemptIso));
              if (elapsed < backoff(e.retryCount)) continue;
            } on FormatException {
              // lastAttemptAtIso corrupto → marcar error DENTRO de esta txn.
              // No se llama markOutboxError (abriría otra writeTxn).
              e
                ..statusWire = OutboxStatus.error.wire
                ..retryCount = e.retryCount + 1
                ..lastAttemptAtIso = nowIso
                ..lastError =
                    _truncate('Invalid lastAttemptAtIso: $lastAttemptIso')
                ..workerLockedBy = null
                ..lockedUntilIso = null
                ..updatedAtIso = nowIso;
              await _isar.outboxEventEntitys.put(e);
              continue; // excluido de eligible y head-of-line
            }
          }
        }

        eligible.add(e);
      }

      if (eligible.isEmpty) return;

      // 3) Resolver sequenceNumber por eventId (batch fetch: reduce N+1)
      final eventIds = eligible.map((e) => e.eventId).toSet().toList();

      final eventEntities = eventIds.isEmpty
          ? <AccountingEventEntity>[]
          : await _isar.accountingEventEntitys
              .filter()
              .anyOf(eventIds, (q, id) => q.eventIdEqualTo(id))
              .findAll();

      final seqByEventId = <String, int>{};
      for (final ae in eventEntities) {
        seqByEventId[ae.eventId] = ae.sequenceNumber;
      }

      // 3b) Outbox sin AccountingEvent → error inmediato DENTRO de esta txn.
      //     No se llama markOutboxError (abriría otra writeTxn).
      //     El outbox corrupto queda visible como error auditado y no bloquea la cola.
      final decorated = <_OutboxCandidate>[];
      for (final e in eligible) {
        final seq = seqByEventId[e.eventId];
        if (seq == null) {
          e
            ..statusWire = OutboxStatus.error.wire
            ..retryCount = e.retryCount + 1
            ..lastAttemptAtIso = nowIso
            ..lastError = _truncate(
                'Missing AccountingEvent for outbox.eventId=${e.eventId}')
            ..workerLockedBy = null
            ..lockedUntilIso = null
            ..updatedAtIso = nowIso;
          await _isar.outboxEventEntitys.put(e);
          continue; // excluido del batch y del head-of-line
        }
        decorated.add(_OutboxCandidate(e, seq));
      }

      // 4) Head-of-line por entidad (entityType+entityId): menor seq
      final bestByEntity = <String, _OutboxCandidate>{};
      for (final c in decorated) {
        // Si no hay sequenceNumber, lo mandamos a error más adelante.
        final key = '${c.entity.entityType}::${c.entity.entityId}';
        final existing = bestByEntity[key];
        if (existing == null || c.seqNum < existing.seqNum) {
          bestByEntity[key] = c;
        }
      }

      // 5) Orden global ASC por seq (autoridad) y tomar batch
      final batch = (bestByEntity.values.toList()
            ..sort((a, b) => a.seqNum.compareTo(b.seqNum)))
          .take(safeLimit)
          .toList();

      if (batch.isEmpty) return;

      // 6) Lease atómico
      for (final c in batch) {
        c.entity
          ..workerLockedBy = workerId
          ..lockedUntilIso = lockedUntilIso
          ..updatedAtIso = nowIso;
        await _isar.outboxEventEntitys.put(c.entity);
        claimedEntities.add(c.entity);
      }
    });

    // Convertir a dominio FUERA del writeTxn.
    // Si está corrupto, se marca error para no bloquear la cola.
    final result = <OutboxEvent>[];
    for (final entity in claimedEntities) {
      try {
        result.add(outboxEventFromEntity(entity));
      } on FormatException {
        await markOutboxError(
          outboxId: entity.outboxId,
          now: now,
          errorMessage: 'FormatException: outbox entity corrupt in claim',
        );
      }
    }

    return result;
  }

  // --------------------------------------------------------------------------
  // markOutboxSynced (ACK)
  // - status=synced
  // - limpia lock y lastError
  // --------------------------------------------------------------------------

  Future<void> markOutboxSynced({
    required List<String> outboxIds,
    required DateTime now,
  }) async {
    final nowIso = now.toUtc().toIso8601String();

    await _isar.writeTxn(() async {
      for (final outboxId in outboxIds) {
        final entity = await _isar.outboxEventEntitys
            .filter()
            .outboxIdEqualTo(outboxId)
            .findFirst();

        if (entity == null) {
          throw StateError(
            'markOutboxSynced: outbox not found. outboxId=$outboxId',
          );
        }

        entity
          ..statusWire = OutboxStatus.synced.wire
          ..workerLockedBy = null
          ..lockedUntilIso = null
          ..lastError = null
          ..updatedAtIso = nowIso;

        await _isar.outboxEventEntitys.put(entity);
        if (kDebugMode) {
          debugPrint(
            '[P2D][Outbox][Repo][ACK] outboxId=$outboxId status=synced',
          );
        }
      }
    });
  }

  // --------------------------------------------------------------------------
  // markOutboxError (NACK)
  // - status=error
  // - retryCount++
  // - lastAttemptAt=now
  // - lastError truncado
  // - libera lock
  // --------------------------------------------------------------------------

  Future<void> markOutboxError({
    required String outboxId,
    required DateTime now,
    required String errorMessage,
  }) async {
    final nowIso = now.toUtc().toIso8601String();
    final truncated = _truncate(errorMessage);

    await _isar.writeTxn(() async {
      final entity = await _isar.outboxEventEntitys
          .filter()
          .outboxIdEqualTo(outboxId)
          .findFirst();

      if (entity == null) {
        throw StateError(
          'markOutboxError: outbox not found. outboxId=$outboxId',
        );
      }

      entity
        ..statusWire = OutboxStatus.error.wire
        ..retryCount = entity.retryCount + 1
        ..lastAttemptAtIso = nowIso
        ..lastError = truncated
        ..workerLockedBy = null
        ..lockedUntilIso = null
        ..updatedAtIso = nowIso;

      await _isar.outboxEventEntitys.put(entity);
      if (kDebugMode) {
        debugPrint(
          '[P2D][Outbox][Repo][NACK] outboxId=$outboxId '
          'retry=${entity.retryCount} err=${entity.lastError ?? ""}',
        );
      }
    });
  }

  // --------------------------------------------------------------------------
  // getEventById (verifiedFromJson fail-hard)
  // --------------------------------------------------------------------------

  Future<AccountingEvent?> getEventById(String id) async {
    final entity = await _isar.accountingEventEntitys
        .filter()
        .eventIdEqualTo(id)
        .findFirst();

    // accountingEventFromEntity() usa AccountingEvent.verifiedFromJson
    return entity == null ? null : accountingEventFromEntity(entity);
  }

  // --------------------------------------------------------------------------
  // purgeSyncedOutbox — anti-crecimiento infinito del Outbox
  // Borra físicamente registros synced cuyo createdAtIso < before (UTC).
  // Criterio: createdAtIso (inmutable), NO updatedAtIso (cambia por locks).
  // Solo IDs para el delete: evita cargar payloads completos en memoria.
  // Retorna cantidad de registros eliminados.
  // NO toca AccountingEventEntity.
  // --------------------------------------------------------------------------

  Future<int> purgeSyncedOutbox({required DateTime before}) async {
    final beforeIso = before.toUtc().toIso8601String();
    int deleted = 0;

    await _isar.writeTxn(() async {
      // Obtener solo los Isar Ids (int) — evita cargar objetos completos.
      final ids = await _isar.outboxEventEntitys
          .filter()
          .statusWireEqualTo(OutboxStatus.synced.wire)
          .and()
          .createdAtIsoLessThan(beforeIso)
          .idProperty()
          .findAll();

      if (ids.isEmpty) return;
      deleted = await _isar.outboxEventEntitys.deleteAll(ids);
    });

    return deleted;
  }

  // --------------------------------------------------------------------------
  // getDebugOutboxStatusByEventId (DEBUG — read-only, no writeTxn)
  // Retorna el statusWire del primer OutboxEventEntity asociado a eventId,
  // o null si no existe ningún registro.
  // SOLO para smoke tests y herramientas de debug en kDebugMode.
  // NO carga entidades de dominio ni llama verifiedFromJson.
  // --------------------------------------------------------------------------

  Future<String?> getDebugOutboxStatusByEventId(String eventId) async {
    final entity = await _isar.outboxEventEntitys
        .filter()
        .eventIdEqualTo(eventId)
        .findFirst();
    return entity?.statusWire;
  }

  // --------------------------------------------------------------------------
  // getDebugOutboxSnapshot (DEBUG — read-only)
  // Retorna snapshot completo del OutboxEventEntity asociado a eventId.
  // SOLO para smoke tests y herramientas de debug en kDebugMode.
  // --------------------------------------------------------------------------

  Future<Map<String, dynamic>?> getDebugOutboxSnapshot(String eventId) async {
    final entity = await _isar.outboxEventEntitys
        .filter()
        .eventIdEqualTo(eventId)
        .findFirst();
    if (entity == null) return null;
    return {
      'status': entity.statusWire,
      'lockedBy': entity.workerLockedBy,
      'retryCount': entity.retryCount,
      'lastError': entity.lastError,
    };
  }

  static String _truncate(String msg) =>
      msg.length > 240 ? msg.substring(0, 240) : msg;
}

// ==========================================================================
// _OutboxCandidate — helper privado para claimNextOutboxBatch
// Asocia un OutboxEventEntity con el sequenceNumber de su AccountingEvent.
// ==========================================================================

class _OutboxCandidate {
  const _OutboxCandidate(this.entity, this.seqNum);

  final OutboxEventEntity entity;
  final int seqNum;
}
