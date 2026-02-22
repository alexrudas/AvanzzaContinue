// ============================================================================
// lib/domain/entities/sync/sync_outbox_entry.dart
// ============================================================================
// SyncOutboxEntry — Enterprise Ultra Pro (Domain Pure)
// ----------------------------------------------------------------------------
// QUÉ ES:
// - Contrato de Dominio para Outbox Offline-First (Sync Engine).
//
// QUÉ HACE:
// - Modela operaciones pendientes/ejecutándose/terminadas para sincronizar
//   cambios locales hacia backend (ej: Firestore o API propia) de forma:
//   - Durable (persistible via Infra/Isar)
//   - Idempotente (IdempotencyKey determinística por intención)
//   - Segura ante cierres, red intermitente, timeouts y reintentos
//   - Coalescible (partitionKey) para fusionar operaciones redundantes
//
// DÓNDE SE USA:
// - Dominio: genera entradas outbox por intención de negocio.
// - Infra: persiste, agenda, bloquea (lease lock) y ejecuta envíos.
// ----------------------------------------------------------------------------
// PRINCIPIOS:
// - Dominio NO hace red.
// - Dominio define invariantes y transiciones seguras.
// - Infra decide jitter real (recomendado), pero Dominio soporta schedule
//   persistido via nextAttemptAt.
// ----------------------------------------------------------------------------
// NOTAS IMPORTANTES (CONTRATO):
// - idempotencyKey DEBE ser determinística y única por intención de usuario.
// - nextAttemptAt ES la fuente de verdad para el scheduling de retry.
// - lockToken + lockedUntil implementan lease locking (anti doble worker).
// - FAILED significa "RETRY_SCHEDULED" (fallo recuperable con reintento).
// - DEAD_LETTER es terminal (requiere intervención / acción manual).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../converters/safe_datetime_converter.dart';

part 'sync_outbox_entry.freezed.dart';
part 'sync_outbox_entry.g.dart';

// ============================================================================
// ENUMS — Operación, Estado, Tipo de Entidad
// ============================================================================

/// Tipo de operación de sincronización.
enum SyncOperationType {
  /// Crear documento
  @JsonValue('CREATE')
  create,

  /// Actualizar documento
  @JsonValue('UPDATE')
  update,

  /// Eliminar documento
  @JsonValue('DELETE')
  delete,

  /// Operación batch (múltiples documentos)
  @JsonValue('BATCH')
  batch,
}

/// Estado de la entrada del outbox.
///
/// CONTRATO:
/// - pending: lista para ser tomada por un worker.
/// - inProgress: tomada por un worker (con lease lock activo).
/// - completed: sincronizada exitosamente (terminal).
/// - failed: fallo recuperable, reintento programado por nextAttemptAt.
/// - deadLetter: fallo permanente (terminal).
enum SyncStatus {
  @JsonValue('PENDING')
  pending,

  @JsonValue('IN_PROGRESS')
  inProgress,

  @JsonValue('COMPLETED')
  completed,

  @JsonValue('FAILED')
  failed,

  @JsonValue('DEAD_LETTER')
  deadLetter,
}

/// Tipo de entidad (routing/dispatch de sync).
enum SyncEntityType {
  @JsonValue('ASSET')
  asset,

  @JsonValue('ASSET_DRAFT')
  assetDraft,

  @JsonValue('AUDIT_LOG')
  auditLog,

  @JsonValue('USER_ASSET_REF')
  userAssetRef,

  @JsonValue('PORTFOLIO')
  portfolio,
}

/// Clasificación de error (mínimo viable Enterprise).
///
/// Usar un enum permite políticas deterministas (recoverable vs permanent)
/// sin depender de strings frágiles.
enum SyncErrorCode {
  // -----------------------
  // Recoverable (retry)
  // -----------------------
  @JsonValue('NETWORK_UNAVAILABLE')
  networkUnavailable,

  @JsonValue('NETWORK_TIMEOUT')
  networkTimeout,

  @JsonValue('DNS_FAILURE')
  dnsFailure,

  @JsonValue('TLS_FAILURE')
  tlsFailure,

  @JsonValue('HTTP_429_RATE_LIMIT')
  http429RateLimit,

  @JsonValue('HTTP_500_SERVER_ERROR')
  http500ServerError,

  @JsonValue('HTTP_502_BAD_GATEWAY')
  http502BadGateway,

  @JsonValue('HTTP_503_SERVICE_UNAVAILABLE')
  http503ServiceUnavailable,

  @JsonValue('HTTP_504_GATEWAY_TIMEOUT')
  http504GatewayTimeout,

  // -----------------------
  // Potentially permanent (depends on your auth strategy)
  // -----------------------
  @JsonValue('AUTH_401_UNAUTHORIZED')
  auth401Unauthorized,

  @JsonValue('AUTH_REFRESH_FAILED')
  authRefreshFailed,

  // -----------------------
  // Permanent (dead letter)
  // -----------------------
  @JsonValue('HTTP_400_BAD_REQUEST')
  http400BadRequest,

  @JsonValue('HTTP_403_FORBIDDEN')
  http403Forbidden,

  @JsonValue('HTTP_404_NOT_FOUND')
  http404NotFound,

  @JsonValue('HTTP_409_CONFLICT')
  http409Conflict,

  @JsonValue('HTTP_422_VALIDATION')
  http422Validation,

  @JsonValue('SCHEMA_MISMATCH')
  schemaMismatch,

  @JsonValue('UNKNOWN')
  unknown,
}

// ============================================================================
// ENTITY — SyncOutboxEntry (Domain Contract)
// ============================================================================

@Freezed()
abstract class SyncOutboxEntry with _$SyncOutboxEntry {
  const SyncOutboxEntry._();

  const factory SyncOutboxEntry({
    // ------------------------------------------------------------------------
    // Identity & Idempotency
    // ------------------------------------------------------------------------

    /// ID único local de la entrada (UUID v4).
    required String id,

    /// CRÍTICO: clave determinística para idempotencia en backend.
    ///
    /// REGLA:
    /// - Debe ser única por "intención de negocio" (clientMutationId),
    ///   NO por reintento.
    ///
    /// Formato recomendado:
    /// "{deviceId}:{userId}:{entityType}:{entityId}:{operationType}:{clientMutationId}"
    required String idempotencyKey,

    /// Clave de partición para coalescing/fusión (operaciones redundantes).
    ///
    /// Recomendación:
    /// "{entityType}:{entityId}"
    required String partitionKey,

    // ------------------------------------------------------------------------
    // Routing / Target
    // ------------------------------------------------------------------------

    /// Tipo de operación.
    required SyncOperationType operationType,

    /// Tipo de entidad.
    required SyncEntityType entityType,

    /// ID de entidad afectada.
    required String entityId,

    /// Ruta destino (ej: "assets/abc123").
    ///
    /// Nota: Aunque "suena infra", aquí ayuda a routing y simplicidad.
    required String firestorePath,

    // ------------------------------------------------------------------------
    // Payload
    // ------------------------------------------------------------------------

    /// Payload JSON completo (incluye runtimeType para polimorfismo).
    required Map<String, dynamic> payload,

    /// Versión del esquema del payload (migraciones / compatibilidad).
    @Default(1) int schemaVersion,

    // ------------------------------------------------------------------------
    // Status & Scheduling
    // ------------------------------------------------------------------------

    /// Estado actual.
    @Default(SyncStatus.pending) SyncStatus status,

    /// Conteo de fallos/intententos de retry (solo incrementa cuando falla un envío).
    @Default(0) int retryCount,

    /// Máximo reintentos antes de dead letter.
    ///
    /// Default enterprise: 6 (con techo de 1h).
    @Default(6) int maxRetries,

    /// Fuente de verdad del scheduling:
    /// - Si status == failed, nextAttemptAt debe estar seteado (idealmente).
    /// - Si status == pending, puede ser null.
    /// - Si status es terminal, debe ser null.
    @SafeDateTimeNullableConverter() DateTime? nextAttemptAt,

    // ------------------------------------------------------------------------
    // Error Diagnostics (determinístico)
    // ------------------------------------------------------------------------

    /// Último error registrado (corto).
    String? lastError,

    /// Código estructurado del último error.
    SyncErrorCode? lastErrorCode,

    /// HTTP status del último intento (si aplica).
    int? lastHttpStatus,

    // ------------------------------------------------------------------------
    // Lease Lock (anti doble worker)
    // ------------------------------------------------------------------------

    /// Token del worker que tiene tomada la tarea.
    String? lockToken,

    /// Expiración del lock (lease).
    @SafeDateTimeNullableConverter() DateTime? lockedUntil,

    // ------------------------------------------------------------------------
    // Timestamps
    // ------------------------------------------------------------------------

    /// Fecha de creación (orden de procesamiento).
    @SafeDateTimeConverter() required DateTime createdAt,

    /// Fecha del último intento.
    @SafeDateTimeNullableConverter() DateTime? lastAttemptAt,

    /// Fecha de completado (si completed).
    @SafeDateTimeNullableConverter() DateTime? completedAt,

    // ------------------------------------------------------------------------
    // Metadata (contexto adicional)
    // ------------------------------------------------------------------------

    /// Metadatos adicionales (userId, deviceId, source, correlationId, etc.).
    @Default(<String, dynamic>{}) Map<String, dynamic> metadata,
  }) = _SyncOutboxEntry;

  factory SyncOutboxEntry.fromJson(Map<String, dynamic> json) =>
      _$SyncOutboxEntryFromJson(json);

  // ==========================================================================
  // FACTORIES — patrones recomendados (Asset, AuditLog, UserAssetRef)
  // ==========================================================================

  /// Factory: Asset.
  ///
  /// Recomendación: construir idempotencyKey y partitionKey fuera (use-case),
  /// para que el dominio reciba llaves ya validadas y determinísticas.
  factory SyncOutboxEntry.forAsset({
    required String id,
    required String idempotencyKey,
    required String partitionKey,
    required SyncOperationType operationType,
    required String assetId,
    required Map<String, dynamic> assetJson,
    Map<String, dynamic> metadata = const {},
    int schemaVersion = 1,
    DateTime? nowUtc,
  }) {
    final now = (nowUtc ?? DateTime.now().toUtc());
    return SyncOutboxEntry(
      id: id,
      idempotencyKey: idempotencyKey,
      partitionKey: partitionKey,
      operationType: operationType,
      entityType: SyncEntityType.asset,
      entityId: assetId,
      firestorePath: 'assets/$assetId',
      payload: assetJson,
      schemaVersion: schemaVersion,
      status: SyncStatus.pending,
      createdAt: now,
      metadata: metadata,
    );
  }

  /// Factory: AuditLog (creación).
  factory SyncOutboxEntry.forAuditLog({
    required String id,
    required String idempotencyKey,
    required String partitionKey,
    required String assetId,
    required String logId,
    required Map<String, dynamic> logJson,
    Map<String, dynamic> metadata = const {},
    int schemaVersion = 1,
    DateTime? nowUtc,
  }) {
    final now = (nowUtc ?? DateTime.now().toUtc());
    return SyncOutboxEntry(
      id: id,
      idempotencyKey: idempotencyKey,
      partitionKey: partitionKey,
      operationType: SyncOperationType.create,
      entityType: SyncEntityType.auditLog,
      entityId: logId,
      firestorePath: 'assets/$assetId/audit_log/$logId',
      payload: logJson,
      schemaVersion: schemaVersion,
      status: SyncStatus.pending,
      createdAt: now,
      metadata: metadata,
    );
  }

  /// Factory: UserAssetRef.
  factory SyncOutboxEntry.forUserAssetRef({
    required String id,
    required String idempotencyKey,
    required String partitionKey,
    required SyncOperationType operationType,
    required String userId,
    required String assetId,
    required Map<String, dynamic> refJson,
    Map<String, dynamic> metadata = const {},
    int schemaVersion = 1,
    DateTime? nowUtc,
  }) {
    final now = (nowUtc ?? DateTime.now().toUtc());
    return SyncOutboxEntry(
      id: id,
      idempotencyKey: idempotencyKey,
      partitionKey: partitionKey,
      operationType: operationType,
      entityType: SyncEntityType.userAssetRef,
      entityId: assetId,
      firestorePath: 'users/$userId/asset_refs/$assetId',
      payload: refJson,
      schemaVersion: schemaVersion,
      status: SyncStatus.pending,
      createdAt: now,
      metadata: metadata,
    );
  }

  // ==========================================================================
  // DERIVED GETTERS — estado, terminalidad, elegibilidad, locking
  // ==========================================================================

  bool get isPending => status == SyncStatus.pending;
  bool get isInProgress => status == SyncStatus.inProgress;
  bool get isCompleted => status == SyncStatus.completed;
  bool get isFailed => status == SyncStatus.failed;
  bool get isDeadLetter => status == SyncStatus.deadLetter;

  /// Terminal: no debe volver a estados vivos.
  bool get isTerminal => status == SyncStatus.completed || status == SyncStatus.deadLetter;

  /// Retorna TRUE si hay un lock vigente.
  bool isLocked(DateTime nowUtc) {
    if (lockToken == null || lockedUntil == null) return false;
    return lockedUntil!.isAfter(nowUtc);
  }

  /// Retorna TRUE si la entrada está elegible para ejecución ahora.
  ///
  /// Contrato:
  /// - pending: elegible si no está locked.
  /// - failed: elegible si now >= nextAttemptAt (o nextAttemptAt null) y no locked.
  /// - inProgress: no elegible (hasta que lock expire, el engine lo recupera).
  bool isEligibleNow(DateTime nowUtc) {
    if (isTerminal) return false;
    if (isLocked(nowUtc)) return false;

    if (status == SyncStatus.pending) return true;

    if (status == SyncStatus.failed) {
      final next = nextAttemptAt;
      if (next == null) return true; // fallback; idealmente nunca null en FAILED
      return !nowUtc.isBefore(next);
    }

    return false;
  }

  /// Puede reintentar (FAILED y no excede maxRetries).
  bool get canRetry => status == SyncStatus.failed && retryCount < maxRetries;

  /// Debe moverse a dead letter (FAILED y excede maxRetries).
  bool get shouldMoveToDeadLetter => status == SyncStatus.failed && retryCount >= maxRetries;

  // ==========================================================================
  // BACKOFF — base (sin jitter). Infra debería aplicar jitter al programar.
  // ==========================================================================

  /// Tabla LatAm-Grade (base) para reintentos.
  ///
  /// Nota:
  /// - retryCount representa "fallos previos".
  /// - El primer fallo produce retryCount = 1.
  /// - El delay base para retryCount==1 NO debe ser cero.
  Duration get nextRetryDelayBase {
    // Tabla:
    // 1 => 10s
    // 2 => 30s
    // 3 => 2m
    // 4 => 10m
    // 5 => 30m
    // 6+ => 1h (techo)
    return switch (retryCount) {
      0 => const Duration(seconds: 10), // defensivo: si falló y aún 0, no spamees
      1 => const Duration(seconds: 10),
      2 => const Duration(seconds: 30),
      3 => const Duration(minutes: 2),
      4 => const Duration(minutes: 10),
      5 => const Duration(minutes: 30),
      _ => const Duration(hours: 1),
    };
  }
}

// ============================================================================
// TRANSICIONES — State Machine (seguro, explícito, enterprise)
// ============================================================================

extension SyncOutboxEntryTransitions on SyncOutboxEntry {
  /// Adquiere lock (lease) y pasa a IN_PROGRESS.
  ///
  /// Reglas:
  /// - No permitido desde estados terminales.
  /// - Si está locked por otro worker y no expiró, se rechaza.
  /// - El caller (Infra) debe proveer workerId y leaseTime.
  SyncOutboxEntry acquireLock({
    required String workerId,
    required Duration leaseTime,
    DateTime? nowUtc,
  }) {
    final now = (nowUtc ?? DateTime.now().toUtc());

    if (isTerminal) {
      throw StateError('No se puede bloquear una tarea terminal ($status)');
    }

    // Anti "lock stealing" (si ya hay un lock vigente de otro worker).
    if (isLocked(now) && lockToken != workerId) {
      throw StateError('Tarea ya bloqueada por otro worker (lockToken=$lockToken)');
    }

    // Solo se permite desde PENDING o FAILED (retry programado).
    if (status != SyncStatus.pending && status != SyncStatus.failed) {
      throw StateError('acquireLock solo válido desde PENDING o FAILED (estado actual: $status)');
    }

    return copyWith(
      status: SyncStatus.inProgress,
      lockToken: workerId,
      lockedUntil: now.add(leaseTime),
      lastAttemptAt: now,
      // mientras está inProgress, no importa nextAttemptAt
      nextAttemptAt: null,
    );
  }

  /// Marca como COMPLETED (ACK) y libera locks/scheduling.
  SyncOutboxEntry markCompleted({DateTime? nowUtc}) {
    final now = (nowUtc ?? DateTime.now().toUtc());

    if (status != SyncStatus.inProgress) {
      throw StateError('markCompleted solo válido desde IN_PROGRESS');
    }

    return copyWith(
      status: SyncStatus.completed,
      completedAt: now,
      lockToken: null,
      lockedUntil: null,
      nextAttemptAt: null,
    );
  }

  /// Marca como FAILED (reintentable) o DEAD_LETTER (terminal), y programa reintento.
  ///
  /// Contrato:
  /// - Solo válido desde IN_PROGRESS.
  /// - Incrementa retryCount.
  /// - Si excede maxRetries => DEAD_LETTER (sin nextAttemptAt).
  /// - Si no excede => FAILED y nextAttemptAt obligatorio.
  ///
  /// Nota:
  /// - Infra debería calcular jitter y proveer nextAttemptAt final.
  SyncOutboxEntry markFailed({
    required String error,
    SyncErrorCode? errorCode,
    int? httpStatus,
    DateTime? nextAttemptAtUtc,
    DateTime? nowUtc,
  }) {
    final now = (nowUtc ?? DateTime.now().toUtc());

    if (status != SyncStatus.inProgress) {
      throw StateError('markFailed solo válido desde IN_PROGRESS');
    }

    final newRetryCount = retryCount + 1;
    final isDead = newRetryCount >= maxRetries;

    if (!isDead && nextAttemptAtUtc == null) {
      throw StateError('FAILED requiere nextAttemptAtUtc (scheduling persistido)');
    }

    return copyWith(
      status: isDead ? SyncStatus.deadLetter : SyncStatus.failed,
      lastError: error,
      lastErrorCode: errorCode,
      lastHttpStatus: httpStatus,
      retryCount: newRetryCount,
      nextAttemptAt: isDead ? null : nextAttemptAtUtc,
      lockToken: null,
      lockedUntil: null,
      // no tocamos completedAt aquí
      completedAt: completedAt,
    );
  }

  /// Mueve manualmente a DEAD_LETTER (intervención manual / regla de negocio).
  SyncOutboxEntry moveToDeadLetter({
    required String reason,
    SyncErrorCode errorCode = SyncErrorCode.unknown,
    int? httpStatus,
    DateTime? nowUtc,
  }) {
    final now = (nowUtc ?? DateTime.now().toUtc());

    return copyWith(
      status: SyncStatus.deadLetter,
      lastError: reason,
      lastErrorCode: errorCode,
      lastHttpStatus: httpStatus,
      nextAttemptAt: null,
      lockToken: null,
      lockedUntil: null,
      // opcional: si quieres, puedes registrar lastAttemptAt para auditoría
      lastAttemptAt: lastAttemptAt ?? now,
    );
  }

  /// Resetea para reintento manual (desde DEAD_LETTER).
  ///
  /// Útil para soporte/ops cuando ya se resolvió el problema.
  SyncOutboxEntry resetForRetry({DateTime? nowUtc}) {
    final now = (nowUtc ?? DateTime.now().toUtc());

    if (status != SyncStatus.deadLetter) {
      throw StateError('resetForRetry solo válido desde DEAD_LETTER');
    }

    return copyWith(
      status: SyncStatus.pending,
      retryCount: 0,
      lastError: null,
      lastErrorCode: null,
      lastHttpStatus: null,
      nextAttemptAt: null,
      lockToken: null,
      lockedUntil: null,
      completedAt: null,
      // createdAt se mantiene (histórico), lastAttemptAt puede dejarse intacto
      lastAttemptAt: lastAttemptAt ?? now,
    );
  }

  /// Libera lock cuando expira o cuando detectas un "stuck in progress".
  ///
  /// Infra suele usar esto al boot:
  /// - si status == inProgress y lockedUntil < now => liberar y pasar a FAILED/PENDING.
  SyncOutboxEntry releaseLock({DateTime? nowUtc}) {
    final now = (nowUtc ?? DateTime.now().toUtc());

    // Solo tiene sentido si estaba en progreso.
    if (status != SyncStatus.inProgress) {
      return this;
    }

    // Si el lock aún es vigente, no liberes.
    if (isLocked(now)) return this;

    // Estrategia conservadora: devolver a FAILED con retry programado.
    // OJO: esto no incrementa retryCount aquí (evita doble conteo),
    // el engine puede decidir si contar como "fallo" o solo "recover".
    return copyWith(
      status: SyncStatus.failed,
      lockToken: null,
      lockedUntil: null,
      nextAttemptAt: now.add(const Duration(seconds: 30)),
      lastError: lastError ?? 'LOCK_EXPIRED_RECOVERY',
      lastErrorCode: lastErrorCode ?? SyncErrorCode.unknown,
    );
  }
}
