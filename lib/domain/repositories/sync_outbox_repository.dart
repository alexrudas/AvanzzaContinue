// ============================================================================
// lib/domain/repositories/sync_outbox_repository.dart
// CONTRATO DOMAIN — Sync Outbox Repository (V2 Engine)
//
// QUÉ RESUELVE:
// - Persistencia durable de operaciones outbox (offline-first).
// - Lectura por elegibilidad (scheduler del Engine V2).
// - Lease locking atómico (anti doble-worker).
// - Transiciones de estado (state machine) persistidas.
// - Limpieza de entradas terminales (purge/housekeeping).
// - Movimiento a deadLetter por corrupción detectada en infra.
//
// QUÉ NO RESUELVE:
// - Lógica de coalescing/fusión (engine/use-case usa partitionKey).
// - Política de retry/backoff (engine calcula nextAttemptAt).
// - Detección de corrupción (infra: mapper/repo-impl detecta y llama
//   moveToDeadLetter con reason).
// - Red, Firestore, Dio, HTTP — esto es Domain puro.
// - Evaluación de políticas (SyncPolicy/SyncGatekeeper son ortogonales).
//
// INVARIANTES:
// - idempotencyKey es UNIQUE: insertar duplicado debe fallar o ser no-op
//   (la impl decide: throw vs ignore, documentar en impl).
// - createdAt corrupto (epoch fallback) NO debe llegar al engine; la infra
//   (mapper) detecta y lanza FormatException → repo-impl mueve a deadLetter.
// - Orden FIFO depende de createdAt/nextAttemptAt correctos.
// - partitionKey se usa para coalescing a nivel engine/use-case, NO en repo.
// - acquireLease DEBE ser atómico (read-check-write en una transacción).
//
// CONSUMIDORES:
// - Sync Engine V2 (orquestador): findEligible, acquireLease, transiciones.
// - Use-Cases (enqueue): upsert, existsByIdempotencyKey.
// - Housekeeping/Admin: findDeadLetters, purgeTerminalOlderThan.
// ============================================================================

import '../entities/sync/sync_outbox_entry.dart';

// ============================================================================
// SYNC OUTBOX REPOSITORY (DOMAIN CONTRACT)
// ============================================================================

/// Contrato Domain-puro para persistencia del Outbox (Sync Engine V2).
///
/// Todas las operaciones reciben [DateTime now] explícito donde sea relevante
/// para testabilidad (no depender de DateTime.now() interno).
///
/// La implementación (infra) es responsable de:
/// - Mapeo Entity ↔ Model (via SyncOutboxMapper).
/// - Detección de corrupción (JSON, DateTime) al leer.
/// - Atomicidad de acquireLease (transacción Isar).
/// - Índices para queries eficientes (status, nextAttemptAtIso, createdAtIso).
abstract class SyncOutboxRepository {
  // ==========================================================================
  // ESCRITURA / UPSERT
  // ==========================================================================

  /// Persiste o actualiza una entrada outbox.
  ///
  /// Semántica:
  /// - Upsert por [SyncOutboxEntry.id] (entryId en infra).
  /// - Si ya existe una entrada con el mismo id, la sobreescribe.
  /// - idempotencyKey UNIQUE: si otra entrada (distinto id) ya tiene la misma
  ///   idempotencyKey, la impl DEBE lanzar [StateError].
  ///
  /// La impl aplica sanitización (mapper) y guardrail de tamaño antes de
  /// persistir.
  Future<void> upsert(SyncOutboxEntry entry);

  // ==========================================================================
  // LECTURA PUNTUAL
  // ==========================================================================

  /// Obtiene una entrada por su ID de dominio (entryId).
  ///
  /// Retorna null si no existe.
  ///
  /// CORRUPCIÓN: si la entrada existe pero está corrupta (JSON o DateTime
  /// no parseable), la impl DEBE propagar [FormatException]. NO mover a
  /// deadLetter automáticamente — esa decisión la toma el caller (engine)
  /// que puede inspeccionar, loguear y luego llamar [moveToDeadLetter].
  ///
  /// El movimiento automático a deadLetter por corrupción aplica solo en
  /// procesos batch ([findEligible], sweeps), NO en lectura puntual.
  Future<SyncOutboxEntry?> getByEntryId(String entryId);

  /// Verifica si ya existe una entrada con la idempotencyKey dada.
  ///
  /// Útil para guards de idempotencia antes de crear una nueva entrada.
  /// Retorna true si existe (cualquier status, incluyendo terminales).
  Future<bool> existsByIdempotencyKey(String idempotencyKey);

  // ==========================================================================
  // LECTURA POR ELEGIBILIDAD (SCHEDULER)
  // ==========================================================================

  /// Encuentra entradas elegibles para procesamiento.
  ///
  /// Reglas de elegibilidad (implementadas en infra via query):
  /// - status IN [SyncStatus.pending, SyncStatus.failed]
  /// - nextAttemptAt == null OR nextAttemptAt <= [now]
  /// - lockedUntil == null OR lockedUntil <= [now] (lease libre o expirado)
  /// - EXCLUYE: completed, deadLetter, inProgress con lease vigente
  ///
  /// Orden: createdAt ASC (FIFO).
  /// [limit] controla el batch size (default 50).
  ///
  /// Entradas corruptas detectadas durante lectura deben ser movidas a
  /// deadLetter por la impl (transparente al caller) y NO incluidas en
  /// el resultado.
  Future<List<SyncOutboxEntry>> findEligible({
    required DateTime now,
    int limit = 50,
  });

  // ==========================================================================
  // LEASE LOCK (CRITICAL — ATOMICIDAD REQUERIDA)
  // ==========================================================================

  /// Adquiere un lease (lock) sobre una entrada para procesamiento exclusivo.
  ///
  /// ATOMICIDAD: esta operación DEBE ser atómica (read-check-write en una
  /// transacción). Aunque hoy el engine es single-worker local, el contrato
  /// garantiza seguridad para futura concurrencia.
  ///
  /// Semántica:
  /// - Si la entrada no existe → retorna false.
  /// - Si la entrada está en estado terminal (completed/deadLetter) → false.
  /// - Si lockedUntil != null Y lockedUntil > [now] (lease vigente de otro
  ///   worker) → false.
  /// - Si se adquiere exitosamente:
  ///   - lockToken = [workerId]
  ///   - lockedUntil = now + [leaseDuration]
  ///   - status = SyncStatus.inProgress
  ///   - lastAttemptAt = [now]
  ///   → retorna true.
  ///
  /// El caller (engine) debe verificar el retorno antes de proceder con
  /// el dispatch.
  Future<bool> acquireLease({
    required String entryId,
    required String workerId,
    required Duration leaseDuration,
    required DateTime now,
  });

  /// Libera un lease sobre una entrada.
  ///
  /// Best-effort: solo libera si lockToken == [workerId].
  /// Si la entrada no existe o el lockToken no coincide, es un no-op
  /// silencioso (el engine puede haber sido preemptado).
  ///
  /// Efectos (cuando lockToken coincide):
  /// - lockToken = null
  /// - lockedUntil = null
  /// - NO cambia status (el caller decide la transición posterior).
  ///
  /// No requiere [DateTime now] porque no involucra scheduling ni
  /// transiciones de estado.
  Future<void> releaseLease({
    required String entryId,
    required String workerId,
  });

  // ==========================================================================
  // TRANSICIONES DE ESTADO (STATE MACHINE)
  // ==========================================================================

  /// Marca una entrada como completada (ACK).
  ///
  /// Precondición esperada: status == inProgress.
  /// Efectos:
  /// - status = SyncStatus.completed
  /// - completedAt = [now]
  /// - lockToken = null, lockedUntil = null
  /// - nextAttemptAt = null
  ///
  /// Si la entrada no existe, es un no-op (idempotente).
  Future<void> markCompleted({
    required String entryId,
    required DateTime now,
  });

  /// Marca una entrada como fallida (retry programado).
  ///
  /// Precondición esperada: status == inProgress.
  /// Efectos:
  /// - status = SyncStatus.failed
  /// - lastError = [errorMessage]
  /// - lastErrorCode = [errorCode] (si se provee)
  /// - lastHttpStatus = [httpStatus] (si se provee)
  /// - nextAttemptAt = [nextAttemptAt] (scheduling del siguiente retry)
  /// - retryCount += 1 (si [incrementRetry] es true)
  /// - lockToken = null, lockedUntil = null
  ///
  /// El caller (engine) es responsable de calcular nextAttemptAt
  /// (usando backoff + jitter).
  ///
  /// Si retryCount >= maxRetries después del incremento, el caller
  /// debería llamar [moveToDeadLetter] en su lugar. Este método NO
  /// hace esa verificación (separación de responsabilidades).
  Future<void> markFailed({
    required String entryId,
    required DateTime now,
    required String errorMessage,
    SyncErrorCode? errorCode,
    int? httpStatus,
    DateTime? nextAttemptAt,
    bool incrementRetry = true,
  });

  /// Mueve una entrada a dead letter (terminal).
  ///
  /// Válido desde CUALQUIER estado (incluyendo corrupción detectada en
  /// infra durante lectura/migración).
  ///
  /// Efectos:
  /// - status = SyncStatus.deadLetter
  /// - lastError = [reason]
  /// - lastErrorCode = [errorCode] (opcional, queda null si no se provee)
  /// - lastHttpStatus = [httpStatus] (opcional, queda null si no se provee)
  /// - nextAttemptAt = null
  /// - lockToken = null, lockedUntil = null
  ///
  /// Casos de uso:
  /// - Engine: retryCount >= maxRetries.
  /// - Infra: corrupción detectada al leer (JSON o DateTime).
  /// - Admin/Ops: intervención manual.
  Future<void> moveToDeadLetter({
    required String entryId,
    required DateTime now,
    required String reason,
    SyncErrorCode? errorCode,
    int? httpStatus,
  });

  // ==========================================================================
  // RECOVERY (BOOT / CRASH RECOVERY)
  // ==========================================================================

  /// Recupera entradas stuck en inProgress con lease expirado.
  ///
  /// Útil al boot del engine para detectar tareas que quedaron huérfanas
  /// (app crash, kill, etc.).
  ///
  /// Reglas:
  /// - status == SyncStatus.inProgress
  /// - lockedUntil == null OR lockedUntil <= [now]
  ///
  /// El engine decide si moverlas a failed (retry) o deadLetter.
  Future<List<SyncOutboxEntry>> findStaleInProgress({
    required DateTime now,
    int limit = 50,
  });

  // ==========================================================================
  // UTILIDADES OPERATIVAS (HOUSEKEEPING)
  // ==========================================================================

  /// Lista entradas en dead letter.
  ///
  /// Orden: createdAt DESC (más recientes primero para diagnóstico).
  /// Útil para dashboards de admin y diagnóstico.
  Future<List<SyncOutboxEntry>> findDeadLetters({int limit = 50});

  /// Encuentra entradas terminales (completed o deadLetter) más antiguas
  /// que [olderThan].
  ///
  /// Útil para auditoría antes de purge.
  Future<List<SyncOutboxEntry>> findTerminalOlderThan({
    required DateTime olderThan,
    int limit = 200,
  });

  /// Elimina entradas terminales (completed o deadLetter) más antiguas
  /// que [olderThan].
  ///
  /// Retorna la cantidad de entradas eliminadas.
  /// Solo elimina entradas terminales — NUNCA pending/failed/inProgress.
  ///
  /// Recomendación: ejecutar periódicamente (ej: cada 24h) para evitar
  /// crecimiento indefinido de la tabla outbox.
  Future<int> purgeTerminalOlderThan({
    required DateTime olderThan,
    int limit = 200,
  });

  /// Cuenta entradas por status.
  ///
  /// Útil para telemetría y health checks del engine.
  Future<int> countByStatus(SyncStatus status);
}

// ============================================================================
// CHECKLIST FINAL
// ============================================================================
// [x] Domain puro (sin infra imports — solo dart:core + domain entities)
// [x] Métodos mínimos para Engine V2:
//     - upsert, getByEntryId, existsByIdempotencyKey
//     - findEligible (scheduler)
//     - acquireLease, releaseLease (lease lock)
//     - markCompleted, markFailed, moveToDeadLetter (state machine)
//     - findStaleInProgress (crash recovery)
//     - findDeadLetters, findTerminalOlderThan, purgeTerminalOlderThan
//     - countByStatus (telemetría)
// [x] Lease lock semántica documentada (atómico, read-check-write)
// [x] Manejo de DeadLetter y corrupción contemplado:
//     - moveToDeadLetter válido desde cualquier estado
//     - findEligible documenta que impl mueve corruptos a deadLetter
//     - getByEntryId propaga FormatException (NO mueve a deadLetter)
// [x] acquireLease = lock + transición a inProgress + lastAttemptAt
// [x] releaseLease: limpia lock, NO cambia status, NO requiere now
// [x] No lógica de negocio dentro del repo:
//     - No coalescing (engine usa partitionKey)
//     - No backoff/jitter (engine calcula nextAttemptAt)
//     - No policy evaluation (SyncGatekeeper es ortogonal)
// [x] Tipos del Domain real: SyncOutboxEntry, SyncStatus, SyncErrorCode
// [x] Invariantes documentados en header (idempotencyKey, FIFO, corrupción)
// [x] DateTime now explícito para testabilidad
