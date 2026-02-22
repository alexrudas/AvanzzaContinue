// ============================================================================
// lib/data/repositories/sync_outbox_repository_impl.dart
// IMPLEMENTACIÓN INFRA — SyncOutboxRepository (Isar + Quarantine Gate)
// Enterprise Ultra Pro — V2
//
// QUÉ HACE:
// - Implementa el contrato Domain SyncOutboxRepository contra Isar.
// - Mapea Entity ↔ Model via SyncOutboxMapper (22/22 campos).
// - Quarantine Gate: en batch reads (findEligible, findStaleInProgress),
//   entradas corruptas se mueven a deadLetter y se excluyen del resultado.
// - acquireLease es atómico (writeTxn read-check-write).
// - getByEntryId propaga FormatException (NO mueve a deadLetter).
//
// QUÉ NO HACE:
// - Backoff / jitter (Engine).
// - Coalescing / fusión (Engine, via partitionKey).
// - Evaluación de políticas (SyncGatekeeper).
// - DateTime.now() interno — todos los timestamps vienen de parámetros.
//
// PREREQUISITO (BUILD_RUNNER):
// El .g.dart debe estar actualizado con los 22 campos del Model V2.
// Ejecutar: dart run build_runner build --delete-conflicting-outputs
// Los filter methods usan el patrón estándar Isar QueryBuilder:
//   filter().<field>EqualTo(), <field>IsNull(), <field>LessThan()
//   sortBy<Field>(), sortBy<Field>Desc(), limit(), findAll()
// Si .g.dart está stale (pre-V2), este archivo no compila hasta regenerar.
//
// ACCESSOR VERIFICADO:
// isar.syncOutboxEntryModels (sync_outbox_entry_model.g.dart L12-14)
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../domain/entities/sync/sync_outbox_entry.dart';
import '../../domain/repositories/sync_outbox_repository.dart';
import '../../infrastructure/local/isar/mappers/sync_outbox_mapper.dart';
import '../../infrastructure/local/isar/models/sync/sync_outbox_entry_model.dart';

// ============================================================================
// IMPLEMENTATION
// ============================================================================

class SyncOutboxRepositoryImpl implements SyncOutboxRepository {
  final Isar _isar;
  final SyncOutboxMapper _mapper;

  SyncOutboxRepositoryImpl({
    required Isar isar,
    SyncOutboxMapper mapper = const SyncOutboxMapper(),
  })  : _isar = isar,
        _mapper = mapper;

  /// Punto único de acceso a la colección Isar.
  /// Si el accessor generado cambia de nombre, ajustar SOLO aquí.
  IsarCollection<SyncOutboxEntryModel> get _col =>
      _isar.syncOutboxEntryModels; // BUILD_RUNNER REQUIRED

  // ==========================================================================
  // A) ESCRITURA / UPSERT
  // ==========================================================================

  /// Persiste o actualiza una entrada outbox.
  ///
  /// - Mapper aplica sanitización + guardrail 800KB.
  /// - Pre-check de idempotencyKey dentro de writeTxn (atómico).
  /// - entryId @Index(unique:true, replace:true) → upsert nativo en put().
  @override
  Future<void> upsert(SyncOutboxEntry entry) async {
    // Mapear fuera de txn: sanitización + guardrail 800KB.
    // Si falla (ArgumentError por tamaño), propaga al caller.
    final model = _mapper.toModel(entry);

    await _isar.writeTxn(() async {
      // Pre-check: idempotencyKey conflict (OTRA entrada con misma key).
      final existing = await _col
          .filter()
          .idempotencyKeyEqualTo(model.idempotencyKey) // BUILD_RUNNER REQUIRED
          .findFirst();

      if (existing != null && existing.entryId != model.entryId) {
        throw StateError(
          'idempotencyKey conflict: "${model.idempotencyKey}" already exists '
          'on entry ${existing.entryId} (attempted by ${model.entryId})',
        );
      }

      await _col.put(model);
    });
  }

  // ==========================================================================
  // B) LECTURA PUNTUAL
  // ==========================================================================

  /// Retorna la entrada o null. Propaga FormatException si corrupta.
  /// NO mueve a deadLetter — esa decisión es del caller (engine).
  @override
  Future<SyncOutboxEntry?> getByEntryId(String entryId) async {
    final model = await _col.filter().entryIdEqualTo(entryId).findFirst();
    if (model == null) return null;

    // FormatException propaga per contrato Domain.
    return _mapper.toEntity(model);
  }

  // ==========================================================================
  // C) EXISTENCIA POR IDEMPOTENCY KEY
  // ==========================================================================

  @override
  Future<bool> existsByIdempotencyKey(String idempotencyKey) async {
    final count = await _col
        .filter()
        .idempotencyKeyEqualTo(idempotencyKey) // BUILD_RUNNER REQUIRED
        .count();
    return count > 0;
  }

  // ==========================================================================
  // D) LECTURA POR ELEGIBILIDAD (SCHEDULER)
  // ==========================================================================

  /// Encuentra entradas elegibles para procesamiento (FIFO).
  /// Quarantine Gate: corruptos van a deadLetter y se omiten.
  @override
  Future<List<SyncOutboxEntry>> findEligible({
    required DateTime now,
    int limit = 50,
  }) async {
    final nowIso = now.toUtc().toIso8601String();

    // Elegibilidad:
    //   status IN (pending, failed)
    //   AND (nextAttemptAtIso IS NULL OR nextAttemptAtIso <= nowIso)
    //   AND (lockedUntilIso IS NULL OR lockedUntilIso <= nowIso)
    //   ORDER BY createdAtIso ASC (FIFO)
    final models = await _col
        .filter()
        .group((q) => q
            .statusEqualTo(SyncStatus.pending)
            .or()
            .statusEqualTo(SyncStatus.failed))
        .group((q) => q
            .nextAttemptAtIsoIsNull() // BUILD_RUNNER REQUIRED
            .or()
            .nextAttemptAtIsoLessThan(nowIso, include: true))
        .group((q) => q
            .lockedUntilIsoIsNull() // BUILD_RUNNER REQUIRED
            .or()
            .lockedUntilIsoLessThan(nowIso, include: true))
        .sortByCreatedAtIso()
        .limit(limit)
        .findAll();

    return _mapWithQuarantine(models, now);
  }

  // ==========================================================================
  // E) LEASE LOCK — ATÓMICO (writeTxn read-check-write)
  // ==========================================================================

  /// Adquiere lease: lock + transición a inProgress + lastAttemptAt.
  /// Retorna false si no existe, es terminal, o tiene lease vigente.
  @override
  Future<bool> acquireLease({
    required String entryId,
    required String workerId,
    required Duration leaseDuration,
    required DateTime now,
  }) async {
    // Normaliza una vez (evita dobles toUtc y micro-inconsistencias).
    final nowUtc = now.toUtc();
    final nowIso = nowUtc.toIso8601String();
    final leaseExpiryIso = nowUtc.add(leaseDuration).toIso8601String();

    return _isar.writeTxn(() async {
      final model = await _col.filter().entryIdEqualTo(entryId).findFirst();
      if (model == null) return false;

      // Terminal → rechazar
      if (model.isTerminal) return false;

      // Lease vigente → rechazar. Corrupto → quarantine + rechazar.
      final lockedUntilIso = model.lockedUntilIso;
      if (lockedUntilIso != null) {
        final lockedUntil = DateTime.tryParse(lockedUntilIso);
        if (lockedUntil == null) {
          // ISO corrupto — quarantine in-place (ya estamos en writeTxn).
          _quarantineModelInTxn(
            model,
            'corrupt lockedUntilIso: "$lockedUntilIso"',
          );
          await _col.put(model);
          return false;
        }

        if (lockedUntil.toUtc().isAfter(nowUtc)) {
          return false;
        }
      }

      // Adquirir
      model.status = SyncStatus.inProgress;
      model.lockToken = workerId;
      model.lockedUntilIso = leaseExpiryIso;
      model.lastAttemptAtIso = nowIso;
      model.nextAttemptAtIso = null;

      await _col.put(model);
      return true;
    });
  }

  // ==========================================================================
  // F) RELEASE LEASE
  // ==========================================================================

  /// Best-effort: solo libera si lockToken == workerId. NO cambia status.
  @override
  Future<void> releaseLease({
    required String entryId,
    required String workerId,
  }) async {
    await _isar.writeTxn(() async {
      final model = await _col.filter().entryIdEqualTo(entryId).findFirst();
      if (model == null) return;
      if (model.lockToken != workerId) return;

      model.lockToken = null;
      model.lockedUntilIso = null;

      await _col.put(model);
    });
  }

  // ==========================================================================
  // G) MARK COMPLETED
  // ==========================================================================

  /// Marca como completada. Limpia scheduling y locks. No-op si no existe.
  @override
  Future<void> markCompleted({
    required String entryId,
    required DateTime now,
  }) async {
    final nowIso = now.toUtc().toIso8601String();

    await _isar.writeTxn(() async {
      final model = await _col.filter().entryIdEqualTo(entryId).findFirst();
      if (model == null) return;

      model.status = SyncStatus.completed;
      model.completedAtIso = nowIso;
      model.nextAttemptAtIso = null;
      model.lockToken = null;
      model.lockedUntilIso = null;

      await _col.put(model);
    });
  }

  // ==========================================================================
  // H) MARK FAILED
  // ==========================================================================

  /// Marca como fallida con error diagnostics + scheduling.
  /// El engine provee nextAttemptAt (backoff + jitter).
  @override
  Future<void> markFailed({
    required String entryId,
    required DateTime now,
    required String errorMessage,
    SyncErrorCode? errorCode,
    int? httpStatus,
    DateTime? nextAttemptAt,
    bool incrementRetry = true,
  }) async {
    await _isar.writeTxn(() async {
      final model = await _col.filter().entryIdEqualTo(entryId).findFirst();
      if (model == null) return;

      model.status = SyncStatus.failed;
      model.lastError = errorMessage;
      model.lastErrorCodeName = errorCode?.name;
      model.lastHttpStatus = httpStatus;
      model.nextAttemptAtIso = nextAttemptAt?.toUtc().toIso8601String();

      if (incrementRetry) {
        model.retryCount = model.retryCount + 1;
      }

      model.lockToken = null;
      model.lockedUntilIso = null;

      await _col.put(model);
    });
  }

  // ==========================================================================
  // I) MOVE TO DEAD LETTER
  // ==========================================================================

  /// Válido desde cualquier estado. Limpia scheduling y locks.
  @override
  Future<void> moveToDeadLetter({
    required String entryId,
    required DateTime now,
    required String reason,
    SyncErrorCode? errorCode,
    int? httpStatus,
  }) async {
    await _isar.writeTxn(() async {
      final model = await _col.filter().entryIdEqualTo(entryId).findFirst();
      if (model == null) return;

      model.status = SyncStatus.deadLetter;
      model.lastError = reason;
      model.lastErrorCodeName = errorCode?.name;
      model.lastHttpStatus = httpStatus;
      model.nextAttemptAtIso = null;
      model.lockToken = null;
      model.lockedUntilIso = null;

      await _col.put(model);
    });
  }

  // ==========================================================================
  // J) FIND STALE IN-PROGRESS (CRASH RECOVERY)
  // ==========================================================================

  /// Entradas stuck: inProgress con lease expirado o null.
  /// Quarantine Gate: corruptos van a deadLetter y se omiten.
  @override
  Future<List<SyncOutboxEntry>> findStaleInProgress({
    required DateTime now,
    int limit = 50,
  }) async {
    final nowIso = now.toUtc().toIso8601String();

    final models = await _col
        .filter()
        .statusEqualTo(SyncStatus.inProgress)
        .group((q) => q
            .lockedUntilIsoIsNull() // BUILD_RUNNER REQUIRED
            .or()
            .lockedUntilIsoLessThan(nowIso, include: true))
        .sortByCreatedAtIso()
        .limit(limit)
        .findAll();

    return _mapWithQuarantine(models, now);
  }

  // ==========================================================================
  // K) FIND DEAD LETTERS
  // ==========================================================================

  /// Lista dead letters para diagnóstico.
  ///
  /// Omite corruptos para no tumbar dashboards (ya son terminales).
  /// NO re-quarantine aquí: el objetivo es observabilidad, no side-effects.
  @override
  Future<List<SyncOutboxEntry>> findDeadLetters({int limit = 50}) async {
    final models = await _col
        .filter()
        .statusEqualTo(SyncStatus.deadLetter)
        .sortByCreatedAtIsoDesc()
        .limit(limit)
        .findAll();

    final results = <SyncOutboxEntry>[];
    for (final model in models) {
      try {
        results.add(_mapper.toEntity(model));
      } on FormatException {
        // Skip silencioso: entrada terminal corrupta.
      }
    }
    return results;
  }

  // ==========================================================================
  // L) FIND TERMINAL OLDER THAN
  // ==========================================================================

  /// Encuentra terminales viejos para auditoría pre-purge.
  /// Propaga FormatException (uso diagnóstico; caller puede manejar).
  @override
  Future<List<SyncOutboxEntry>> findTerminalOlderThan({
    required DateTime olderThan,
    int limit = 200,
  }) async {
    final olderThanIso = olderThan.toUtc().toIso8601String();

    final models = await _col
        .filter()
        .group((q) => q
            .statusEqualTo(SyncStatus.completed)
            .or()
            .statusEqualTo(SyncStatus.deadLetter))
        .createdAtIsoLessThan(olderThanIso)
        .sortByCreatedAtIso()
        .limit(limit)
        .findAll();

    return models.map(_mapper.toEntity).toList();
  }

  // ==========================================================================
  // M) PURGE TERMINAL OLDER THAN
  // ==========================================================================

  /// Elimina terminales viejos por Isar PK (no mapea a entity).
  /// Solo completed/deadLetter — NUNCA pending/failed/inProgress.
  @override
  Future<int> purgeTerminalOlderThan({
    required DateTime olderThan,
    int limit = 200,
  }) async {
    final olderThanIso = olderThan.toUtc().toIso8601String();

    final models = await _col
        .filter()
        .group((q) => q
            .statusEqualTo(SyncStatus.completed)
            .or()
            .statusEqualTo(SyncStatus.deadLetter))
        .createdAtIsoLessThan(olderThanIso)
        .limit(limit)
        .findAll();

    if (models.isEmpty) return 0;

    final ids = models.map((m) => m.id).toList();
    await _isar.writeTxn(() async {
      await _col.deleteAll(ids);
    });

    return ids.length;
  }

  // ==========================================================================
  // N) COUNT BY STATUS
  // ==========================================================================

  @override
  Future<int> countByStatus(SyncStatus status) async {
    return _col.filter().statusEqualTo(status).count();
  }

  // ==========================================================================
  // QUARANTINE GATE (BATCH READS ONLY)
  // ==========================================================================

  /// Mapea modelos a entities. Corruptos van a deadLetter y se omiten.
  ///
  /// Aplica SOLO en: findEligible, findStaleInProgress.
  /// NO aplica en: getByEntryId (propaga), findDeadLetters (skip).
  Future<List<SyncOutboxEntry>> _mapWithQuarantine(
    List<SyncOutboxEntryModel> models,
    DateTime now,
  ) async {
    final results = <SyncOutboxEntry>[];

    for (final model in models) {
      try {
        results.add(_mapper.toEntity(model));
      } on FormatException catch (e) {
        await _quarantineCorrupt(model.entryId, now, e.message);
      }
    }

    return results;
  }

  /// Muta un modelo in-place para quarantine SIN abrir writeTxn.
  ///
  /// Diseñado para uso DENTRO de un writeTxn existente (e.g. acquireLease).
  /// El caller es responsable de hacer _col.put(model) después.
  void _quarantineModelInTxn(SyncOutboxEntryModel model, String reason) {
    model.status = SyncStatus.deadLetter;
    model.lastError = 'QUARANTINE: $reason';
    model.lastErrorCodeName = SyncErrorCode.unknown.name;
    model.nextAttemptAtIso = null;
    model.lockToken = null;
    model.lockedUntilIso = null;
  }

  /// Mueve una entrada corrupta a deadLetter.
  ///
  /// Usa SyncErrorCode.unknown (verificado en el enum real).
  /// Limpia scheduling + locks.
  ///
  /// NOTA:
  /// - Se hace writeTxn propio porque típicamente se llama desde lecturas batch
  ///   fuera de transacción.
  /// - NO reutiliza moveToDeadLetter para evitar overhead/recursión accidental.
  Future<void> _quarantineCorrupt(
    String entryId,
    DateTime now,
    String reason,
  ) async {
    await _isar.writeTxn(() async {
      final model = await _col.filter().entryIdEqualTo(entryId).findFirst();
      if (model == null) return;

      _quarantineModelInTxn(model, reason);
      await _col.put(model);
    });
  }
}

// ============================================================================
// CHECKLIST FINAL
// ============================================================================
// [x] Accessor real: isar.syncOutboxEntryModels (verificado .g.dart L12-14)
// [x] Sin SyncErrorCode inventado: usa SyncErrorCode.unknown (enum real)
// [x] Implementa TODOS los métodos del contrato (14/14):
//     A) upsert — pre-check idempotencyKey + put (writeTxn)
//     B) getByEntryId — propaga FormatException (NO quarantine)
//     C) existsByIdempotencyKey — count > 0
//     D) findEligible — query elegibilidad + quarantine gate
//     E) acquireLease — atómico (writeTxn read-check-write)
//     F) releaseLease — best-effort, NO cambia status
//     G) markCompleted — limpia scheduling + locks
//     H) markFailed — error diagnostics + retryCount++
//     I) moveToDeadLetter — válido desde cualquier estado
//     J) findStaleInProgress — crash recovery + quarantine gate
//     K) findDeadLetters — skip corrupt (no crashear dashboards)
//     L) findTerminalOlderThan — propaga FormatException (diagnóstico)
//     M) purgeTerminalOlderThan — delete por Isar PK (no mapea)
//     N) countByStatus — count por filter
// [x] acquireLease = lock + inProgress + lastAttemptAt (sin markInProgress sep.)
// [x] _quarantineModelInTxn evita txn anidada (uso dentro de writeTxn existente)
// [x] acquireLease: lockedUntilIso corrupto → quarantine + return false
// [x] Fechas: ISO8601 UTC en comparaciones y persistencia
// [x] Prerequisito documentado: build_runner para .g.dart V2
