// ============================================================================
// lib/infrastructure/isar/entities/outbox_event_entity.dart
// AUDIT TRAIL OUTBOX — Enterprise Ultra Pro (Infra / Isar)
//
// HARDENED — DETERMINISTIC — FAIL HARD — AUDIT GRADE
//
// PRINCIPIOS:
//
// - Infra NO usa reloj global.
// - Infra NO corrige datos corruptos.
// - Infra valida invariantes mínimas.
// - Upsert permitido SOLO por outboxId (estado cambia).
// - Índice compuesto statusWire + lockedUntilIso para claim eficiente.
// - ISO8601 UTC strings (orden lexicográfico estable).
// - Mappers top-level (infra pura).
//
// NOTA:
// build_runner genera el .g.dart.
// NO modificar manualmente el archivo generado.
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../domain/entities/accounting/outbox_event.dart';

part 'outbox_event_entity.g.dart';

@Collection(
  ignore: {
    'createdAt',
    'updatedAt',
    'lastAttemptAt',
    'lockedUntil',
    'statusEnum',
  },
)
class OutboxEventEntity {
  // ===========================================================================
  // PRIMARY KEY
  // ===========================================================================

  Id id = Isar.autoIncrement;

  // ===========================================================================
  // BUSINESS KEY — UNIQUE + REPLACE (estado cambia frecuentemente)
  // ===========================================================================

  @Index(unique: true, replace: true)
  late String outboxId;

  // ===========================================================================
  // ROUTING
  // ===========================================================================

  @Index()
  late String eventId;

  /// Tipo de entidad (ej: 'account_receivable'). Para queries sin join al evento.
  @Index()
  late String entityType;

  @Index()
  late String entityId;

  // ===========================================================================
  // STATUS + CLAIM OPTIMIZATION
  // ===========================================================================

  /// statusWire: 'pending' | 'synced' | 'error'
  /// Índice compuesto con lockedUntilIso para claim eficiente.
  @Index(composite: [CompositeIndex('lockedUntilIso')])
  late String statusWire;

  late int retryCount;

  // ===========================================================================
  // TIMESTAMPS (ISO8601 UTC STRING)
  // ===========================================================================

  @Index()
  late String createdAtIso;

  late String updatedAtIso;

  String? lastAttemptAtIso;

  // ===========================================================================
  // IDEMPOTENCY
  // ===========================================================================

  /// Hash del AccountingEvent original.
  /// Garantiza que el worker no procese dos veces el mismo evento lógico.
  @Index()
  String? idempotencyKey;

  // ===========================================================================
  // LEASE LOCK
  // ===========================================================================

  String? workerLockedBy;

  @Index()
  String? lockedUntilIso;

  // ===========================================================================
  // ERROR DIAGNOSTICS
  // ===========================================================================

  /// Mensaje de error (limitado para evitar bloat).
  String? lastError;

  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================

  OutboxEventEntity();

  // ===========================================================================
  // COMPUTED GETTERS (NO PERSISTIDOS)
  // ===========================================================================

  DateTime get createdAt => DateTime.parse(createdAtIso);
  set createdAt(DateTime v) => createdAtIso = v.toUtc().toIso8601String();

  DateTime get updatedAt => DateTime.parse(updatedAtIso);
  set updatedAt(DateTime v) => updatedAtIso = v.toUtc().toIso8601String();

  DateTime? get lastAttemptAt =>
      lastAttemptAtIso != null ? DateTime.parse(lastAttemptAtIso!) : null;

  set lastAttemptAt(DateTime? v) =>
      lastAttemptAtIso = v?.toUtc().toIso8601String();

  DateTime? get lockedUntil =>
      lockedUntilIso != null ? DateTime.parse(lockedUntilIso!) : null;

  set lockedUntil(DateTime? v) => lockedUntilIso = v?.toUtc().toIso8601String();

  OutboxStatus get statusEnum => OutboxStatusX.fromWire(statusWire);
}

// ============================================================================
// MAPPERS (Domain ↔ Infra)
// ============================================================================

OutboxEventEntity outboxEventToEntity(OutboxEvent event) {
  if (event.retryCount < 0) {
    throw StateError(
      'OutboxEvent retryCount cannot be negative '
      '(outboxId=${event.id})',
    );
  }

  final error = event.lastError;
  if (error != null && error.length > 1000) {
    throw StateError(
      'OutboxEvent lastError too large '
      '(max 1000 chars, outboxId=${event.id})',
    );
  }

  return OutboxEventEntity()
    ..outboxId = event.id
    ..eventId = event.eventId
    ..entityType = event.entityType
    ..entityId = event.entityId
    ..statusWire = event.status.wire
    ..retryCount = event.retryCount
    ..createdAtIso = event.createdAt.toUtc().toIso8601String()
    ..updatedAtIso = event.updatedAt.toUtc().toIso8601String()
    ..lastAttemptAtIso = event.lastAttemptAt?.toUtc().toIso8601String()
    ..workerLockedBy = event.lockedBy
    ..lockedUntilIso = event.lockedUntil?.toUtc().toIso8601String()
    ..lastError = event.lastError;
}

OutboxEvent outboxEventFromEntity(
  OutboxEventEntity entity,
) {
  _guardIso(entity.createdAtIso, 'createdAtIso', entity.outboxId);
  _guardIso(entity.updatedAtIso, 'updatedAtIso', entity.outboxId);
  _guardIsoNullable(
      entity.lastAttemptAtIso, 'lastAttemptAtIso', entity.outboxId);
  _guardIsoNullable(entity.lockedUntilIso, 'lockedUntilIso', entity.outboxId);

  if (!_isValidStatus(entity.statusWire)) {
    throw FormatException(
      'OutboxEventEntity invalid statusWire="${entity.statusWire}" '
      '(outboxId=${entity.outboxId})',
    );
  }

  if (entity.retryCount < 0) {
    throw FormatException(
      'OutboxEventEntity retryCount negative '
      '(outboxId=${entity.outboxId})',
    );
  }

  if (entity.lastError != null && entity.lastError!.length > 1000) {
    throw FormatException(
      'OutboxEventEntity lastError too large '
      '(outboxId=${entity.outboxId})',
    );
  }

  return OutboxEvent(
    id: entity.outboxId,
    eventId: entity.eventId,
    entityType: entity.entityType,
    entityId: entity.entityId,
    status: OutboxStatusX.fromWire(entity.statusWire),
    retryCount: entity.retryCount,
    createdAt: DateTime.parse(entity.createdAtIso),
    updatedAt: DateTime.parse(entity.updatedAtIso),
    lastAttemptAt: entity.lastAttemptAtIso != null
        ? DateTime.parse(entity.lastAttemptAtIso!)
        : null,
    lockedBy: entity.workerLockedBy,
    lockedUntil: entity.lockedUntilIso != null
        ? DateTime.parse(entity.lockedUntilIso!)
        : null,
    lastError: entity.lastError,
  );
}

// ============================================================================
// GUARDS
// ============================================================================

void _guardIso(String iso, String field, String id) {
  if (DateTime.tryParse(iso) == null) {
    throw FormatException(
      'OutboxEventEntity corrupt $field '
      '(outboxId=$id, raw="$iso")',
    );
  }
}

void _guardIsoNullable(String? iso, String field, String id) {
  if (iso != null && DateTime.tryParse(iso) == null) {
    throw FormatException(
      'OutboxEventEntity corrupt $field '
      '(outboxId=$id, raw="$iso")',
    );
  }
}

bool _isValidStatus(String wire) {
  return wire == 'pending' || wire == 'synced' || wire == 'error';
}
