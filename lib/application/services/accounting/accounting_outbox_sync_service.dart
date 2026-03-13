// ============================================================================
// lib/application/services/accounting/accounting_outbox_sync_service.dart
// MOBILE SYNC WORKER — Enterprise Ultra Pro (Application)
//
// QUÉ HACE:
// - Drena la cola Outbox hacia el backend con garantías enterprise:
//   • Single-flight: solo un loop activo (start() idempotente).
//   • Lease locking: evita doble procesamiento concurrente entre workers.
//   • Exponential backoff: base 5s × 2^retryCount, máx 5 min.
//   • Head-of-line protection: por entidad, solo el menor sequenceNumber.
//   • Fail-hard: FormatException/StateError → markOutboxError (sin silencio).
//   • Idempotencia: el gateway acepta o ignora por event.hash.
//
// QUÉ NO HACE:
// - NO modifica AccountingEvent (event store es append-only/inmutable).
// - NO conecta backend real (usa AccountingEventRemoteGateway — Fake en P2-D).
// - NO logea payload sensible (solo e.runtimeType en errores).
//
// NOTAS:
// - stop() es no-bloqueante: el loop termina tras el sleep activo (máx _tick).
// - _sendBatch() fail-hard: error de gateway → markOutboxError por cada evento.
// - getEventById llama verifiedFromJson internamente (anti-tamper).
// ============================================================================

import 'package:flutter/foundation.dart';

import '../../../domain/entities/accounting/accounting_event.dart';
import '../../../domain/entities/accounting/outbox_event.dart';
import '../../../infrastructure/isar/repositories/isar_accounting_event_repository.dart';
import '../../gateways/accounting/accounting_event_remote_gateway.dart';

class AccountingOutboxSyncService {
  AccountingOutboxSyncService(
    this._repo,
    this._gateway, {
    required this.workerId,
    Duration tick = const Duration(seconds: 10),
    Duration lease = const Duration(seconds: 45),
  })  : _tick = tick,
        _lease = lease;

  final IsarAccountingEventRepository _repo;
  final AccountingEventRemoteGateway _gateway;
  final String workerId;
  final Duration _tick;
  final Duration _lease;

  bool _running = false;

  /// Contador de iteraciones del loop (debug). Nunca se resetea en stop/start.
  int _tickCount = 0;

  /// Última ejecución de purga de outbox synced.
  /// null = nunca ejecutada (se ejecutará en el primer tick).
  DateTime? _lastPurgeAt;

  // ==========================================================================
  // CONTROL
  // ==========================================================================

  /// Inicia el loop de sync. Si ya está activo → no-op (single-flight).
  void start() {
    if (kDebugMode) {
      debugPrint(
        '[P2D][Worker] start() running=$_running '
        'workerId=$workerId hash=$hashCode',
      );
    }
    if (_running) return;
    _running = true;
    // catchError: hace visible cualquier crash fuera del try-catch interno de _loop().
    _loop().catchError((Object e, StackTrace st) {
      _running = false;
      if (kDebugMode) {
        debugPrint('[P2D][Worker][CRASH] _loop() fatal error: $e');
        debugPrint('StackTrace: $st');
      }
    });
  }

  /// Detiene el loop limpiamente. El loop termina tras el sleep activo.
  void stop() {
    if (kDebugMode) {
      debugPrint('[P2D][Worker] stop() called workerId=$workerId');
    }
    _running = false;
  }

  // ==========================================================================
  // LOOP
  // ==========================================================================

  Future<void> _loop() async {
    while (_running) {
      _tickCount++;
      try {
        // now único por iteración — consistencia entre purge/sweep/claim.
        final now = DateTime.now();
        if (kDebugMode) {
          debugPrint(
            '[P2D][Outbox][Worker][Tick] now=${now.toUtc().toIso8601String()} '
            'workerId=$workerId',
          );
        }

        // 0. Purga anti-crecimiento: once per 24h, registros synced > 30 días.
        if (_lastPurgeAt == null ||
            now.difference(_lastPurgeAt!) >= const Duration(hours: 24)) {
          final purged = await _repo.purgeSyncedOutbox(
            before: now.subtract(const Duration(days: 30)),
          );
          _lastPurgeAt = now;
          if (kDebugMode) {
            debugPrint('[OutboxSync] Purged $purged outbox records');
          }
        }

        // 1. Liberar leases vencidos de workers caídos.
        await _repo.sweepExpiredOutboxLocks(now: now);

        // 2. Claim 100% atómico con head-of-line + backoff.
        final batch = await _repo.claimNextOutboxBatch(
          workerId: workerId,
          now: now,
          limit: 25,
          lease: _lease,
        );

        if (kDebugMode) {
          final ids = batch.take(3).map((e) => e.id).join(', ');
          debugPrint(
            '[P2D][Outbox][Worker][Claim] claimed=${batch.length} ids=[$ids]',
          );
          if (batch.isNotEmpty) {
            final first = batch.first;
            debugPrint(
              '[P2D][Outbox][Worker][ClaimFirst] outboxId=${first.id} '
              'eventId=${first.eventId} '
              'entity=${first.entityType}::${first.entityId}',
            );
          }
        }

        if (batch.isEmpty) {
          // Cola vacía → esperar tick antes del próximo intento.
          await Future.delayed(_tick);
          continue;
        }

        // 3. Enviar batch al gateway.
        await _sendBatch(batch);
      } catch (e) {
        if (kDebugMode) debugPrint('[OutboxSync] loop error type=${e.runtimeType}');
        await Future.delayed(const Duration(seconds: 5));
      }

      // Pausa mínima entre batches consecutivos.
      if (_running) await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  // ==========================================================================
  // SEND BATCH
  // ==========================================================================

  Future<void> _sendBatch(List<OutboxEvent> batch) async {
    final now = DateTime.now();

    // Mapa eventId → outboxId para ACK/NACK tras respuesta del gateway.
    final eventToOutbox = <String, String>{};
    final eventsToSend = <AccountingEvent>[];

    // ── Cargar AccountingEvent verificado por cada outbox ──
    for (final outbox in batch) {
      try {
        final event = await _repo.getEventById(outbox.eventId);
        if (event == null) {
          throw StateError(
            'AccountingEvent not found. eventId=${outbox.eventId}',
          );
        }
        eventsToSend.add(event);
        eventToOutbox[outbox.eventId] = outbox.id;
      } on FormatException {
        if (kDebugMode) {
          debugPrint(
            '[OutboxSync] FormatException loading event. outboxId=${outbox.id}',
          );
        }
        await _repo.markOutboxError(
          outboxId: outbox.id,
          now: now,
          errorMessage: _truncate(
              'FormatException: event hash mismatch or payload corrupted'),
        );
      } on StateError catch (e) {
        if (kDebugMode) {
          debugPrint(
            '[OutboxSync] StateError loading event. outboxId=${outbox.id}',
          );
        }
        await _repo.markOutboxError(
          outboxId: outbox.id,
          now: now,
          errorMessage: _truncate('StateError: ${e.message}'),
        );
      }
    }

    if (eventsToSend.isEmpty) return;

    // ── Enviar al gateway ──
    try {
      final result = await _gateway.ingestBatch(eventsToSend);
      final now2 = DateTime.now();

      final syncedEventIds = {
        ...result.acceptedEventIds,
        ...result.ignoredAsDuplicateEventIds,
      };

      // ACK: aceptados + duplicados → synced (ambos son éxito de idempotencia).
      final syncedOutboxIds = syncedEventIds
          .map((eid) => eventToOutbox[eid])
          .whereType<String>()
          .toList();

      if (syncedOutboxIds.isNotEmpty) {
        await _repo.markOutboxSynced(outboxIds: syncedOutboxIds, now: now2);
      }

      // Eventos no retornados por gateway → markOutboxError (sin silencio).
      for (final eid in eventToOutbox.keys) {
        if (!syncedEventIds.contains(eid)) {
          await _repo.markOutboxError(
            outboxId: eventToOutbox[eid]!,
            now: now2,
            errorMessage: _truncate('Not returned by gateway. eventId=$eid'),
          );
        }
      }
    } catch (e) {
      // Error de red/servidor → NACK en todos los eventos del batch enviado.
      final now2 = DateTime.now();
      final msg = _truncate('Gateway error: ${e.runtimeType}');
      if (kDebugMode) debugPrint('[OutboxSync] gateway error type=${e.runtimeType}');
      for (final outboxId in eventToOutbox.values) {
        await _repo.markOutboxError(
          outboxId: outboxId,
          now: now2,
          errorMessage: msg,
        );
      }
    }
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  /// Número de iteraciones del loop completadas. Solo útil en kDebugMode.
  /// Un valor > 0 confirma que start() fue llamado y el loop está/estuvo activo.
  int debugTickCount() => _tickCount;

  static String _truncate(String msg) =>
      msg.length > 240 ? msg.substring(0, 240) : msg;
}
