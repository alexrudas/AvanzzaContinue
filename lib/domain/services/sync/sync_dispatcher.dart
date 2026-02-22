// ============================================================================
// lib/domain/services/sync/sync_dispatcher.dart
// SYNC DISPATCHER — Enterprise Ultra Pro (Domain Service)
//
// QUÉ HACE:
// - Consume entradas elegibles desde SyncOutboxRepository.
// - Adquiere lease atómicamente por entry (anti doble procesamiento).
// - Despacha ejecución via SyncExecutor inyectable (HTTP/handler/comando).
// - Publica transiciones de estado: markCompleted / markFailed / moveToDeadLetter.
// - Libera lease en FINALLY (best-effort).
// - Ejecuta en paralelo con maxConcurrency (SEMAFORO REAL FIFO, sin isolates).
// - Retorna SyncDispatchReport inmutable con métricas + failures (max 20).
//
// QUÉ NO HACE:
// - Coalescing / fusión (Engine, via partitionKey).
// - Evaluación de políticas (SyncGatekeeper).
// - DateTime.now() interno — todos los timestamps vienen de parámetros.
// - Quarantine Gate — el repo ya lo hace en batch reads.
// - Logs / prints / assert.
//
// DEPENDENCIAS:
// - Solo Dart core + domain entities/repository.
// - SyncExecutor: interface domain (sync_executor.dart).
// - SyncExecutionResult: DTO inmutable (sync_execution_result.dart).
// - NextAttemptPolicy: inyectable para calcular nextAttemptAt en retryables.
// ============================================================================

import 'dart:async';
import 'dart:collection';

import '../../entities/sync/sync_outbox_entry.dart';
import '../../repositories/sync_outbox_repository.dart';
import 'next_attempt_policy.dart';
import 'sync_execution_result.dart';
import 'sync_executor.dart';

// ============================================================================
// SYNC DISPATCH REPORT — MÉTRICAS INMUTABLES
// ============================================================================

/// Reporte inmutable del resultado de un batch de dispatch.
class SyncDispatchReport {
  /// Entradas leídas de findEligible.
  final int fetched;

  /// Leases adquiridos exitosamente.
  final int leased;

  /// Entries donde acquireLease retornó false (skip silencioso).
  final int skippedLease;

  /// Entries completadas exitosamente.
  final int completed;

  /// Entries marcadas como failed (retryable).
  final int failedRetryable;

  /// Entries movidas a deadLetter.
  final int deadLettered;

  /// Excepciones no controladas durante procesamiento.
  final int exceptions;

  /// Detalle de fallos (max 20 para diagnóstico).
  final List<SyncDispatchFailure> failures;

  const SyncDispatchReport({
    required this.fetched,
    required this.leased,
    required this.skippedLease,
    required this.completed,
    required this.failedRetryable,
    required this.deadLettered,
    required this.exceptions,
    required this.failures,
  });

  /// Reporte vacío (no había entries elegibles).
  const SyncDispatchReport.empty()
      : fetched = 0,
        leased = 0,
        skippedLease = 0,
        completed = 0,
        failedRetryable = 0,
        deadLettered = 0,
        exceptions = 0,
        failures = const [];
}

/// Detalle de un fallo individual para diagnóstico (cap 20).
class SyncDispatchFailure {
  final String entryId;
  final String idempotencyKey;
  final String reason;
  final int? httpStatus;
  final String? errorCodeName;

  const SyncDispatchFailure({
    required this.entryId,
    required this.idempotencyKey,
    required this.reason,
    this.httpStatus,
    this.errorCodeName,
  });
}

// ============================================================================
// SYNC DISPATCHER — IMPLEMENTATION
// ============================================================================

class SyncDispatcher {
  final SyncOutboxRepository _outboxRepository;
  final SyncExecutor _executor;
  final String _workerId;
  final NextAttemptPolicy _nextAttemptPolicy;

  SyncDispatcher({
    required SyncOutboxRepository outboxRepository,
    required SyncExecutor executor,
    required String workerId,
    NextAttemptPolicy? nextAttemptPolicy,
  })  : _outboxRepository = outboxRepository,
        _executor = executor,
        _workerId = workerId,
        _nextAttemptPolicy =
            nextAttemptPolicy ?? ExponentialBackoffJitterPolicy();

  // ==========================================================================
  // MÉTODO PRINCIPAL — DISPATCH BATCH
  // ==========================================================================

  /// Despacha un batch de entradas elegibles.
  ///
  /// Flujo:
  /// 1) Lee entries con findEligible(now, limit).
  /// 2) Para cada entry: toma un slot del semáforo (maxConcurrency).
  /// 3) Con el slot tomado: intenta acquireLease (evita "secuestrar" locks).
  /// 4) Si lease OK → procesa entry y publica transición de estado.
  /// 5) Si lease FAIL → skip silencioso.
  /// 6) Retorna SyncDispatchReport con métricas + failures (cap 20).
  ///
  /// Concurrencia: semáforo FIFO real (Queue<Completer<void>>).
  Future<SyncDispatchReport> dispatchEligibleBatch({
    required DateTime now,
    int limit = 50,
    int maxConcurrency = 4,
    Duration leaseDuration = const Duration(minutes: 2),
  }) async {
    // Guardrails duros: nunca permitir valores tóxicos.
    if (limit <= 0) return const SyncDispatchReport.empty();
    if (maxConcurrency <= 0) maxConcurrency = 1;

    final entries =
        await _outboxRepository.findEligible(now: now, limit: limit);
    if (entries.isEmpty) return const SyncDispatchReport.empty();

    final semaphore = _AsyncSemaphore(maxConcurrency);

    // Ejecutar cada entry como tarea que retorna un resultado (sin contadores mutables concurrentes).
    final tasks = <Future<_DispatchItemResult>>[];

    for (final entry in entries) {
      tasks.add(_runSingleEntry(
        entry: entry,
        now: now,
        semaphore: semaphore,
        leaseDuration: leaseDuration,
      ));
    }

    final results = await Future.wait(tasks);

    // Consolidación serial (sin data races).
    var leased = 0;
    var skippedLease = 0;
    var completed = 0;
    var failedRetryable = 0;
    var deadLettered = 0;
    var exceptions = 0;

    final failures = <SyncDispatchFailure>[];
    for (final r in results) {
      if (r.leaseAcquired) leased++;
      if (r.skippedLease) skippedLease++;

      switch (r.outcome) {
        case _EntryOutcome.completed:
          completed++;
        case _EntryOutcome.failedRetryable:
          failedRetryable++;
        case _EntryOutcome.deadLettered:
          deadLettered++;
        case _EntryOutcome.exception:
          exceptions++;
        case _EntryOutcome.skippedLease:
          break; // Ya contado arriba via r.skippedLease.
      }

      // Failures: cap 20, no incluir completed ni skippedLease.
      if (failures.length < 20 &&
          !r.skippedLease &&
          r.outcome != _EntryOutcome.completed) {
        failures.add(SyncDispatchFailure(
          entryId: r.entryId,
          idempotencyKey: r.idempotencyKey,
          reason: r.failureReason ?? r.outcome.name,
          httpStatus: r.httpStatus,
          errorCodeName: r.errorCodeName,
        ));
      }
    }

    return SyncDispatchReport(
      fetched: entries.length,
      leased: leased,
      skippedLease: skippedLease,
      completed: completed,
      failedRetryable: failedRetryable,
      deadLettered: deadLettered,
      exceptions: exceptions,
      failures: List.unmodifiable(failures),
    );
  }

  // ==========================================================================
  // SINGLE ENTRY RUNNER — SEMÁFORO + LEASE TIMING CORRECTO
  // ==========================================================================

  Future<_DispatchItemResult> _runSingleEntry({
    required SyncOutboxEntry entry,
    required DateTime now,
    required _AsyncSemaphore semaphore,
    required Duration leaseDuration,
  }) async {
    await semaphore.acquire(); // Slot primero (evita "secuestrar" locks).

    var leaseOk = false;
    try {
      leaseOk = await _outboxRepository.acquireLease(
        entryId: entry.id,
        workerId: _workerId,
        leaseDuration: leaseDuration,
        now: now,
      );

      if (!leaseOk) {
        return _DispatchItemResult.skippedLease(entry: entry);
      }

      final processed = await _processEntry(entry: entry, now: now);
      return _DispatchItemResult.fromProcess(
        entry: entry,
        process: processed,
      );
    } finally {
      // Semáforo SIEMPRE.
      semaphore.release();
      // Nota: releaseLease se hace dentro de _processEntry (finally) cuando leaseOk=true.
    }
  }

  // ==========================================================================
  // PROCESS ENTRY — EJECUTA + CLASIFICA + TRANSICIONA ESTADO
  // ==========================================================================

  /// Ejecuta una entry (ya leaseada) y publica la transición de estado.
  ///
  /// Retorna outcome + metadata para telemetría.
  /// SIEMPRE libera lease en finally (best-effort).
  Future<_ProcessResult> _processEntry({
    required SyncOutboxEntry entry,
    required DateTime now,
  }) async {
    try {
      final result = await _executor.execute(entry: entry, now: now);

      // --- SUCCESS ---
      if (result.success) {
        await _outboxRepository.markCompleted(entryId: entry.id, now: now);
        return const _ProcessResult(
          outcome: _EntryOutcome.completed,
          failureReason: null,
          httpStatus: null,
          errorCodeName: null,
        );
      }

      // --- TERMINAL (executor afirma que no hay retry posible) ---
      if (result.terminal) {
        final reason = result.errorMessage ?? 'Terminal error from executor';
        await _outboxRepository.moveToDeadLetter(
          entryId: entry.id,
          now: now,
          reason: reason,
          errorCode: result.errorCode,
          httpStatus: result.httpStatus,
        );
        return _ProcessResult(
          outcome: _EntryOutcome.deadLettered,
          failureReason: reason,
          httpStatus: result.httpStatus,
          errorCodeName: result.errorCode?.name,
        );
      }

      // --- RETRYABLE (executor afirma que se puede reintentar) ---
      if (result.retryable) {
        return _handleRetryable(entry: entry, now: now, result: result);
      }

      // --- DEFAULT: success=false, terminal=false, retryable=false ---
      // El executor no clasificó explícitamente. Tratar como terminal (deadLetter).
      final reason = result.errorMessage ??
          'Unclassified error from executor (terminal by default)';
      await _outboxRepository.moveToDeadLetter(
        entryId: entry.id,
        now: now,
        reason: reason,
        errorCode: result.errorCode ?? SyncErrorCode.unknown,
        httpStatus: result.httpStatus,
      );
      return _ProcessResult(
        outcome: _EntryOutcome.deadLettered,
        failureReason: reason,
        httpStatus: result.httpStatus,
        errorCodeName: (result.errorCode ?? SyncErrorCode.unknown).name,
      );
    } on FormatException catch (e) {
      final reason = 'FormatException: ${e.message}';
      await _outboxRepository.moveToDeadLetter(
        entryId: entry.id,
        now: now,
        reason: reason,
        errorCode: SyncErrorCode.unknown,
      );
      return _ProcessResult(
        outcome: _EntryOutcome.deadLettered,
        failureReason: reason,
        httpStatus: null,
        errorCodeName: 'unknown',
      );
    } on ArgumentError catch (e) {
      final reason = 'ArgumentError: ${e.message}';
      await _outboxRepository.moveToDeadLetter(
        entryId: entry.id,
        now: now,
        reason: reason,
        errorCode: SyncErrorCode.unknown,
      );
      return _ProcessResult(
        outcome: _EntryOutcome.deadLettered,
        failureReason: reason,
        httpStatus: null,
        errorCodeName: 'unknown',
      );
    } catch (_) {
      // Excepción no tipificada:
      // - Si retries agotados → deadLetter
      // - Si no → markFailed (una oportunidad)
      if (entry.retryCount >= entry.maxRetries) {
        await _outboxRepository.moveToDeadLetter(
          entryId: entry.id,
          now: now,
          reason: 'Unhandled exception (retries exhausted)',
          errorCode: SyncErrorCode.unknown,
        );
        return const _ProcessResult(
          outcome: _EntryOutcome.deadLettered,
          failureReason: 'Unhandled exception (retries exhausted)',
          httpStatus: null,
          errorCodeName: 'unknown',
        );
      }

      await _outboxRepository.markFailed(
        entryId: entry.id,
        now: now,
        errorMessage: 'Unhandled exception',
        errorCode: SyncErrorCode.unknown,
        nextAttemptAt: _nextAttemptPolicy.nextAttemptAt(
          now: now,
          retryCount: entry.retryCount,
        ),
        incrementRetry: true,
      );
      return const _ProcessResult(
        outcome: _EntryOutcome.exception,
        failureReason: 'Unhandled exception',
        httpStatus: null,
        errorCodeName: 'unknown',
      );
    } finally {
      // Best-effort release — silencioso si falla.
      try {
        await _outboxRepository.releaseLease(
          entryId: entry.id,
          workerId: _workerId,
        );
      } catch (_) {
        // Silencioso: el lease expirará naturalmente.
      }
    }
  }

  // ==========================================================================
  // CLASIFICACIÓN DE ERRORES
  // ==========================================================================

  /// Maneja resultado retryable: markFailed o deadLetter si retries agotados.
  Future<_ProcessResult> _handleRetryable({
    required SyncOutboxEntry entry,
    required DateTime now,
    required SyncExecutionResult result,
  }) async {
    final reason = result.errorMessage ?? 'Retryable error';

    // Si retries agotados → deadLetter (aunque el executor diga retryable).
    if (entry.retryCount >= entry.maxRetries) {
      await _outboxRepository.moveToDeadLetter(
        entryId: entry.id,
        now: now,
        reason: reason,
        errorCode: result.errorCode ?? SyncErrorCode.unknown,
        httpStatus: result.httpStatus,
      );
      return _ProcessResult(
        outcome: _EntryOutcome.deadLettered,
        failureReason: reason,
        httpStatus: result.httpStatus,
        errorCodeName: (result.errorCode ?? SyncErrorCode.unknown).name,
      );
    }

    // Si el executor provee nextAttemptAt, respetarlo.
    // Si no, calcular via policy usando retryCount actual.
    final computedNextAttempt = result.nextAttemptAt ??
        _nextAttemptPolicy.nextAttemptAt(
          now: now,
          retryCount: entry.retryCount,
        );

    await _outboxRepository.markFailed(
      entryId: entry.id,
      now: now,
      errorMessage: reason,
      errorCode: result.errorCode,
      httpStatus: result.httpStatus,
      nextAttemptAt: computedNextAttempt,
      incrementRetry: true,
    );

    return _ProcessResult(
      outcome: _EntryOutcome.failedRetryable,
      failureReason: reason,
      httpStatus: result.httpStatus,
      errorCodeName: result.errorCode?.name,
    );
  }
}

// ============================================================================
// CONCURRENCY — SEMÁFORO FIFO REAL (SIN BUSY-WAITING)
// ============================================================================

/// Semáforo asíncrono FIFO para controlar maxConcurrency en un solo isolate.
///
/// - acquire() espera hasta que haya un slot disponible.
/// - release() libera un slot y despierta al siguiente en cola.
/// - FIFO: respeta orden de llegada (Queue<Completer<void>>).
class _AsyncSemaphore {
  final int _maxPermits;
  int _inUse = 0;
  final Queue<Completer<void>> _waitQueue = Queue<Completer<void>>();

  _AsyncSemaphore(int maxPermits)
      : _maxPermits = maxPermits < 1 ? 1 : maxPermits;

  Future<void> acquire() {
    if (_inUse < _maxPermits) {
      _inUse++;
      return Future.value();
    }

    final completer = Completer<void>();
    _waitQueue.addLast(completer);
    return completer.future;
  }

  void release() {
    if (_waitQueue.isNotEmpty) {
      final next = _waitQueue.removeFirst();
      // El permit se transfiere al siguiente waiter (no cambia _inUse).
      next.complete();
      return;
    }

    // Nadie esperando: liberar un permit real.
    if (_inUse > 0) _inUse--;
  }
}

// ============================================================================
// ENTRY OUTCOME (PRIVADO — PARA MÉTRICAS)
// ============================================================================

enum _EntryOutcome {
  completed,
  failedRetryable,
  deadLettered,
  exception,
  skippedLease,
}

// ============================================================================
// RESULTADOS PRIVADOS — PARA CONSOLIDACIÓN SIN DATA RACE
// ============================================================================

class _ProcessResult {
  final _EntryOutcome outcome;
  final String? failureReason;
  final int? httpStatus;
  final String? errorCodeName;

  const _ProcessResult({
    required this.outcome,
    required this.failureReason,
    required this.httpStatus,
    required this.errorCodeName,
  });
}

class _DispatchItemResult {
  final String entryId;
  final String idempotencyKey;

  /// true si acquireLease fue exitoso.
  final bool leaseAcquired;

  /// true si acquireLease falló y se skippeó.
  final bool skippedLease;

  final _EntryOutcome outcome;

  final String? failureReason;
  final int? httpStatus;
  final String? errorCodeName;

  const _DispatchItemResult({
    required this.entryId,
    required this.idempotencyKey,
    required this.leaseAcquired,
    required this.skippedLease,
    required this.outcome,
    required this.failureReason,
    required this.httpStatus,
    required this.errorCodeName,
  });

  factory _DispatchItemResult.skippedLease({required SyncOutboxEntry entry}) {
    return _DispatchItemResult(
      entryId: entry.id,
      idempotencyKey: entry.idempotencyKey,
      leaseAcquired: false,
      skippedLease: true,
      outcome: _EntryOutcome.skippedLease,
      failureReason: null,
      httpStatus: null,
      errorCodeName: null,
    );
  }

  factory _DispatchItemResult.fromProcess({
    required SyncOutboxEntry entry,
    required _ProcessResult process,
  }) {
    return _DispatchItemResult(
      entryId: entry.id,
      idempotencyKey: entry.idempotencyKey,
      leaseAcquired: true,
      skippedLease: false,
      outcome: process.outcome,
      failureReason: process.failureReason,
      httpStatus: process.httpStatus,
      errorCodeName: process.errorCodeName,
    );
  }
}

// ============================================================================
// CHECKLIST FINAL
// ============================================================================
// [x] Single Source of Truth: SyncExecutor importado de sync_executor.dart
// [x] Single Source of Truth: SyncExecutionResult importado de sync_execution_result.dart
// [x] CERO definiciones duplicadas de SyncExecutor o SyncExecutionResult
// [x] _EntryOutcome.skippedLease: valor propio (no placeholder .completed)
// [x] Default fallback: success=false + terminal=false + retryable=false → deadLetter
// [x] Eliminada lógica HTTP (_classifyByHttpStatus / _isRetryableHttpStatus)
// [x] Semáforo REAL FIFO (Queue<Completer<void>>) — sin busy-waiting
// [x] Guardrail semáforo: maxPermits < 1 => 1
// [x] Lease timing correcto: acquire slot ANTES de acquireLease (evita secuestro)
// [x] No DateTime.now() — timestamps solo por parámetros
// [x] NextAttemptPolicy inyectable (default ExponentialBackoffJitterPolicy)
// [x] _handleRetryable: result.nextAttemptAt ?? policy.nextAttemptAt(now, retryCount)
// [x] Unhandled exception: nextAttemptAt via policy
// [x] Estado consistente — markCompleted / markFailed / moveToDeadLetter
// [x] releaseLease en FINALLY (best-effort, silencioso si falla)
// [x] Métricas SIN data race: consolidación serial post Future.wait
// [x] Telemetría failures incluye reason/httpStatus/errorCodeName (cap 20)
// [x] FormatException/ArgumentError: failureReason preserva detalle real
// [x] Guardrail de enums: NO se inventan SyncErrorCode (fallback unknown)
// [x] CERO helpers redundantes (entryIdOrFallback eliminado)
// [x] CERO dependencias externas (solo Dart core + domain)
// [x] Production-ready FASE 5.3.2
