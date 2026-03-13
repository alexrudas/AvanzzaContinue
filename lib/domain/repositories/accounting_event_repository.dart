// ============================================================================
// lib/domain/repositories/accounting_event_repository.dart
// AUDIT TRAIL + OUTBOX CONTRACTS — Enterprise Ultra Pro (Domain)
//
// QUÉ HACE:
// - Define contratos domain-puros para:
//   1) Ledger auditable (AccountingEvent)
//   2) Cola offline-first (OutboxEvent) con lease/claim para sync
// - Permite:
//   - Persistencia idempotente de eventos (anti-tamper)
//   - Lectura paginada por entidad (timeline/auditoría)
//   - Verificación opcional de cadena (prevHash integrity)
//   - Outbox pattern real: claim batch + ack/fail
//
// QUÉ NO HACE:
// - NO persiste datos (infra).
// - NO implementa reintentos/backoff (Sync Service).
// - NO depende de Flutter/GetX.
//
// PRINCIPIOS ENTERPRISE:
// - Idempotencia por eventId (no duplicar)
// - Anti-tamper: si mismo id pero distinto hash => StateError
// - Outbox con lease: evita doble procesamiento concurrente
// - Operación atómica: append(event) + enqueue(outbox) como 1 unidad
// ============================================================================

import '../entities/accounting/accounting_event.dart';
import '../entities/accounting/outbox_event.dart';

// ============================== EVENT LOG ===================================

/// Contrato para el Audit Trail contable (event log).
abstract class AccountingEventRepository {
  /// Upsert por [AccountingEvent.id].
  ///
  /// Reglas:
  /// - Si NO existe: inserta.
  /// - Si existe y hash coincide: NO-OP (idempotente).
  /// - Si existe y hash difiere: throw StateError (anti-tamper / corrupción).
  Future<void> upsertEvent(AccountingEvent event);

  /// Obtiene un evento por ID (null si no existe).
  ///
  /// La infra DEBE deserializar con `AccountingEvent.verifiedFromJson`
  /// (o equivalente) para evitar lectura corrupta.
  Future<AccountingEvent?> getById(String eventId);

  /// Retorna el último evento de una entidad (por occurredAt DESC, tie-breaker recordedAt DESC).
  /// Útil para obtener prevHash y encadenar.
  Future<AccountingEvent?> getLastByEntity({
    required String entityType,
    required String entityId,
  });

  /// Lista paginada de eventos de una entidad, orden cronológico ASC.
  ///
  /// Recomendación de cursor:
  /// - cursor = lastEvent.occurredAt.toUtc().toIso8601String() + '|' + lastEvent.id
  ///
  /// `limit` debe ser defensivo (ej. 200 max en infra).
  Future<AccountingEventPage> listByEntity({
    required String entityType,
    required String entityId,
    int limit = 50,
    String? cursor,
  });

  /// Verifica integridad de cadena (prevHash) para una entidad.
  ///
  /// Retorna:
  /// - ok=true si la cadena es consistente
  /// - ok=false con detalles si hay ruptura
  ///
  /// Nota: para performance, puede verificarse solo una ventana (limit/cursor).
  Future<AccountingChainVerification> verifyChainByEntity({
    required String entityType,
    required String entityId,
    int limit = 500,
    String? cursor,
  });
}

class AccountingEventPage {
  AccountingEventPage({
    required this.items,
    this.nextCursor,
  });

  final List<AccountingEvent> items;
  final String? nextCursor;
}

class AccountingChainVerification {
  AccountingChainVerification({
    required this.ok,
    this.brokenAtEventId,
    this.expectedPrevHash,
    this.foundPrevHash,
    this.message,
  });

  final bool ok;
  final String? brokenAtEventId;
  final String? expectedPrevHash;
  final String? foundPrevHash;
  final String? message;
}

// ================================ OUTBOX ====================================

/// Contrato para la cola offline-first (OutboxEvent) asociada a eventos contables.
abstract class AccountingOutboxRepository {
  /// Upsert por [OutboxEvent.id].
  ///
  /// Reglas:
  /// - Si NO existe: inserta.
  /// - Si existe: actualiza campos mutables (status/retry/locks/etc).
  Future<void> upsertOutbox(OutboxEvent outbox);

  /// Operación CANÓNICA (Outbox Pattern):
  /// Persistir el evento + encolar outbox en una sola unidad atómica.
  ///
  /// La infra DEBE garantizar atomicidad (transacción Isar / batch Firestore, etc).
  Future<void> appendAtomic({
    required AccountingEvent event,
    required OutboxEvent outbox,
  });

  /// Claim de un batch FIFO para procesamiento, con lease.
  ///
  /// - workerId identifica el worker/proceso (ej. deviceId+pid).
  /// - leaseDuration define cuánto dura el lock para evitar dobles envíos.
  ///
  /// Debe retornar items ya "lockeados" para ese worker.
  Future<List<OutboxEvent>> claimPendingBatch({
    required String workerId,
    required Duration leaseDuration,
    int limit = 50,
  });

  /// Marca un outbox como sincronizado (ACK).
  ///
  /// Recomendado: limpiar lastError y lock.
  Future<void> markSynced({
    required String outboxId,
    required DateTime syncedAt,
  });

  /// Marca un outbox como error (NACK).
  ///
  /// Debe:
  /// - status=error
  /// - retryCount++
  /// - lastAttemptAt=attemptedAt
  /// - lastError=mensaje corto
  /// - liberar lock (o extenderlo si aplicas backoff a nivel de lock)
  Future<void> markError({
    required String outboxId,
    required DateTime attemptedAt,
    required String errorMessage,
  });

  /// Devuelve conteo simple por estado (útil para UI/monitoring).
  Future<OutboxCounters> getCounters();
}

class OutboxCounters {
  OutboxCounters({
    required this.pending,
    required this.error,
    required this.synced,
  });

  final int pending;
  final int error;
  final int synced;
}
