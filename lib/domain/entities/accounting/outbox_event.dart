// ============================================================================
// lib/domain/entities/accounting/outbox_event.dart
// OUTBOX — Offline-first Sync Queue (Domain) — Enterprise Ultra Pro
//
// QUÉ HACE:
// - Entidad inmutable que representa una fila en la cola Outbox.
// - Referencia a un AccountingEvent (eventId) y rastrea su estado de sync.
// - Permite auditoría operativa: reintentos, último error, timestamps.
// - Incluye lock/lease opcional para evitar doble procesamiento concurrente.
//
// QUÉ NO HACE:
// - NO persiste datos (repositorio).
// - NO ejecuta reintentos/backoff (servicio de sync).
// - NO depende de Flutter ni GetX.
// - NO expone mapping enum ↔ string (DOMAIN_CONTRACTS.md v1.1.3 §C). El
//   mapping canónico de `OutboxStatus` ↔ persistencia vive únicamente en
//   `infrastructure/isar/codecs/outbox_status_codec.dart`.
// - NO define toJson/fromJson: sin callers vivos y cualquier serialización
//   actual pasa por los mappers Isar dedicados. Agregar serialización aquí
//   reintroduciría una segunda fuente del mapping.
//
// NOTAS ENTERPRISE:
// - status es enum (no strings sueltas).
// - createdAt: momento en que se encola.
// - updatedAt: último cambio de estado.
// - lastAttemptAt: último intento de envío.
// - lastError: mensaje corto (sin PII). Útil para soporte.
// - lockedBy/lockedUntil: lease suave para workers concurrentes.
// ============================================================================

enum OutboxStatus {
  pending,
  synced,
  error,
}

class OutboxEvent {
  OutboxEvent({
    required this.id,
    required this.eventId,
    required this.entityType,
    required this.entityId,
    this.status = OutboxStatus.pending,
    this.retryCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.lastAttemptAt,
    this.lastError,
    this.lockedBy,
    this.lockedUntil,
  })  : assert(id.isNotEmpty, 'id must not be empty'),
        assert(eventId.isNotEmpty, 'eventId must not be empty'),
        assert(entityType.isNotEmpty, 'entityType must not be empty'),
        assert(entityId.isNotEmpty, 'entityId must not be empty'),
        assert(retryCount >= 0, 'retryCount must be >= 0');

  /// ID local de la fila outbox (uuid v4 recomendado).
  final String id;

  /// ID del AccountingEvent a sincronizar.
  final String eventId;

  /// Para queries eficientes (sin cargar evento completo).
  /// Ej: 'account_receivable' / 'account_payable' / 'journal_entry'
  final String entityType;

  /// ID de la entidad (CxC/CxP/etc).
  final String entityId;

  final OutboxStatus status;

  /// Incrementa solo cuando falla un intento real de sync.
  final int retryCount;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Último intento de envío.
  final DateTime? lastAttemptAt;

  /// Último error (texto corto, sin datos sensibles).
  final String? lastError;

  /// Lease/lock suave para evitar doble procesamiento.
  /// lockedUntil: si es < now, el lock se considera expirado.
  final String? lockedBy;
  final DateTime? lockedUntil;

  // ---------------------------------------------------------------------------

  bool get isLocked {
    final until = lockedUntil;
    if (until == null) return false;
    return until.isAfter(DateTime.now());
  }

  bool canBeProcessedBy(String workerId) {
    // Sin lock → OK
    if (!isLocked) return true;
    // Lock mío → OK
    return lockedBy == workerId;
  }

  // ---------------------------------------------------------------------------

  OutboxEvent copyWith({
    OutboxStatus? status,
    int? retryCount,
    DateTime? updatedAt,
    DateTime? lastAttemptAt,
    String? lastError,
    String? lockedBy,
    DateTime? lockedUntil,
    bool clearLastError = false,
    bool clearLock = false,
  }) {
    return OutboxEvent(
      id: id,
      eventId: eventId,
      entityType: entityType,
      entityId: entityId,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      lastError: clearLastError ? null : (lastError ?? this.lastError),
      lockedBy: clearLock ? null : (lockedBy ?? this.lockedBy),
      lockedUntil: clearLock ? null : (lockedUntil ?? this.lockedUntil),
    );
  }
}
