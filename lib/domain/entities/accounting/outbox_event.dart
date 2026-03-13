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

extension OutboxStatusX on OutboxStatus {
  String get wire {
    switch (this) {
      case OutboxStatus.pending:
        return 'pending';
      case OutboxStatus.synced:
        return 'synced';
      case OutboxStatus.error:
        return 'error';
    }
  }

  static OutboxStatus fromWire(String v) {
    switch (v) {
      case 'pending':
        return OutboxStatus.pending;
      case 'synced':
        return OutboxStatus.synced;
      case 'error':
        return OutboxStatus.error;
      default:
        throw FormatException('OutboxStatus invalid: $v');
    }
  }
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

  // ---------------------------------------------------------------------------

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventId': eventId,
        'entityType': entityType,
        'entityId': entityId,
        'status': status.wire,
        'retryCount': retryCount,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'updatedAt': updatedAt.toUtc().toIso8601String(),
        if (lastAttemptAt != null)
          'lastAttemptAt': lastAttemptAt!.toUtc().toIso8601String(),
        if (lastError != null) 'lastError': lastError,
        if (lockedBy != null) 'lockedBy': lockedBy,
        if (lockedUntil != null)
          'lockedUntil': lockedUntil!.toUtc().toIso8601String(),
      };

  factory OutboxEvent.fromJson(Map<String, dynamic> json) => OutboxEvent(
        id: json['id'] as String,
        eventId: json['eventId'] as String,
        entityType: json['entityType'] as String,
        entityId: json['entityId'] as String,
        status: OutboxStatusX.fromWire(json['status'] as String),
        retryCount: (json['retryCount'] as int?) ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        lastAttemptAt: json['lastAttemptAt'] == null
            ? null
            : DateTime.parse(json['lastAttemptAt'] as String),
        lastError: json['lastError'] as String?,
        lockedBy: json['lockedBy'] as String?,
        lockedUntil: json['lockedUntil'] == null
            ? null
            : DateTime.parse(json['lockedUntil'] as String),
      );
}
