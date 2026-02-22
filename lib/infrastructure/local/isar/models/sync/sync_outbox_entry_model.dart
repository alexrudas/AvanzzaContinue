// ============================================================================
// lib/infrastructure/local/isar/models/sync/sync_outbox_entry_model.dart
// MODELO ISAR PARA SYNC OUTBOX - Infraestructura (V2)
//
// Alineado 1:1 con SyncOutboxEntry Domain V2 (22 campos).
//
// PK:   `id` (autoIncrement Isar, estable).
// BIZ:  `entryId` (UUID v4, UNIQUE+replace para upsert).
// IDEM: `idempotencyKey` (UNIQUE global, contrato Domain V2:
//        caller provee key determinística por intención de negocio).
//
// HARDENING:
// - JSON decode: catch Object (FormatException + TypeError + CastError).
// - Validate decoded is Map; normalize keys to String.
// - DateTime: tryParse + epoch fallback (puro, sin side effects).
// - Corruption flags runtime-only (never persisted).
// - corruptionSnapshot getter para quarantine/auditoría por engine.
//
// MIGRACIÓN ISAR:
// Este cambio agrega 8 campos nuevos al schema. Requiere schema version bump
// o DB wipe al actualizar.
// ============================================================================

import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../../domain/entities/sync/sync_outbox_entry.dart';

part 'sync_outbox_entry_model.g.dart';

/// Epoch UTC como fallback para DateTimes corruptos.
final DateTime _epochUtc = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

/// Snapshot de corrupción detectada en un SyncOutboxEntryModel.
/// El engine puede usar esto para decidir quarantine / deadLetter / rehydrate.
///
/// COMPUTED: cada campo se evalúa on-demand desde los datos persistidos.
/// No depende de flags runtime ni de accesos previos a payloadMap/metadataMap.
typedef SyncCorruptionSnapshot = ({
  bool payloadCorrupt,
  bool metadataCorrupt,
  String? corruptCreatedAtRaw,
  String? corruptNextAttemptAtRaw,
  String? corruptLockedUntilRaw,
});

@Collection(
  ignore: {
    // Computed getters (no persisten)
    'payloadMap',
    'metadataMap',
    'createdAt',
    'lastAttemptAt',
    'completedAt',
    'nextAttemptAt',
    'lockedUntil',
    'lastErrorCode',
    'corruptionSnapshot',
    // Boolean derived
    'isPending',
    'isInProgress',
    'isCompleted',
    'isFailed',
    'isDeadLetter',
    'isTerminal',
    'canRetry',
    'shouldMoveToDeadLetter',
    // Corruption helpers (runtime-only)
    'isPayloadCorrupt',
    'isMetadataCorrupt',
  },
)
class SyncOutboxEntryModel {
  // ==========================================================================
  // PRIMARY KEY (ISAR)
  // ==========================================================================

  Id id = Isar.autoIncrement;

  // ==========================================================================
  // BUSINESS ID (UNIQUE + upsert)
  // ==========================================================================

  /// UUID v4 del dominio. replace:true permite upsert por entryId.
  @Index(unique: true, replace: true)
  late String entryId;

  // ==========================================================================
  // IDENTITY & IDEMPOTENCY (V2)
  // ==========================================================================

  /// Clave de idempotencia globalmente única por intención de negocio.
  /// El caller (use-case) genera y provee la key; el model solo la persiste.
  /// UNIQUE sin replace: duplicados se rechazan (garantía de idempotencia).
  @Index(unique: true)
  late String idempotencyKey;

  /// Clave de partición para coalescing (fusión de operaciones redundantes).
  @Index()
  late String partitionKey;

  // ==========================================================================
  // ROUTING / TARGET
  // ==========================================================================

  @Enumerated(EnumType.name)
  late SyncOperationType operationType;

  @Enumerated(EnumType.name)
  late SyncEntityType entityType;

  @Index()
  late String entityId;

  late String firestorePath;

  // ==========================================================================
  // PAYLOAD
  // ==========================================================================

  late String payload;

  late int schemaVersion;

  // ==========================================================================
  // STATUS & SCHEDULING
  // ==========================================================================

  @Index()
  @Enumerated(EnumType.name)
  late SyncStatus status;

  late int retryCount;

  late int maxRetries;

  /// ISO8601 UTC. Indexado para scheduling queries del sync engine.
  @Index()
  String? nextAttemptAtIso;

  // ==========================================================================
  // ERROR DIAGNOSTICS
  // ==========================================================================

  String? lastError;

  /// Nombre del enum SyncErrorCode (persistido como String para compat Isar).
  String? lastErrorCodeName;

  int? lastHttpStatus;

  // ==========================================================================
  // LEASE LOCK
  // ==========================================================================

  String? lockToken;

  /// Indexado para sweep queries del engine al boot.
  @Index()
  String? lockedUntilIso;

  // ==========================================================================
  // TIMESTAMPS
  // ==========================================================================

  @Index()
  late String createdAtIso;

  String? lastAttemptAtIso;

  String? completedAtIso;

  // ==========================================================================
  // METADATA
  // ==========================================================================

  late String metadata;

  // ==========================================================================
  // CONSTRUCTORS
  // ==========================================================================

  SyncOutboxEntryModel();

  SyncOutboxEntryModel.create({
    required String id,
    required this.idempotencyKey,
    required this.partitionKey,
    required this.operationType,
    required this.entityType,
    required this.entityId,
    required this.firestorePath,
    required this.payload,
    this.schemaVersion = 1,
    required this.status,
    required this.retryCount,
    required this.maxRetries,
    this.nextAttemptAtIso,
    this.lastError,
    this.lastErrorCodeName,
    this.lastHttpStatus,
    this.lockToken,
    this.lockedUntilIso,
    required this.createdAtIso,
    this.lastAttemptAtIso,
    this.completedAtIso,
    required this.metadata,
  }) {
    entryId = id;
  }

  // ==========================================================================
  // MAP ACCESSORS (hardened: no crash on corrupt JSON)
  //
  // Getters are PURE: no side effects on persisted fields.
  // Corruption detected via COMPUTED corruptionSnapshot (static helper).
  // ==========================================================================

  bool get isPayloadCorrupt => _isJsonMapCorrupt(payload);
  bool get isMetadataCorrupt => _isJsonMapCorrupt(metadata);

  Map<String, dynamic> get payloadMap => _safeDecodeJsonMap(payload);

  set payloadMap(Map<String, dynamic> value) {
    try {
      payload = jsonEncode(value);
    } on Object {
      payload = '{}';
    }
  }

  Map<String, dynamic> get metadataMap => _safeDecodeJsonMap(metadata);

  set metadataMap(Map<String, dynamic> value) {
    try {
      metadata = jsonEncode(value);
    } on Object {
      metadata = '{}';
    }
  }

  // ==========================================================================
  // DATETIME ACCESSORS (PURE: tryParse + epoch fallback, NO side effects)
  // ==========================================================================

  DateTime get createdAt => DateTime.tryParse(createdAtIso) ?? _epochUtc;
  set createdAt(DateTime value) =>
      createdAtIso = value.toUtc().toIso8601String();

  DateTime? get lastAttemptAt =>
      lastAttemptAtIso != null ? DateTime.tryParse(lastAttemptAtIso!) : null;
  set lastAttemptAt(DateTime? value) =>
      lastAttemptAtIso = value?.toUtc().toIso8601String();

  DateTime? get completedAt =>
      completedAtIso != null ? DateTime.tryParse(completedAtIso!) : null;
  set completedAt(DateTime? value) =>
      completedAtIso = value?.toUtc().toIso8601String();

  DateTime? get nextAttemptAt =>
      nextAttemptAtIso != null ? DateTime.tryParse(nextAttemptAtIso!) : null;
  set nextAttemptAt(DateTime? value) =>
      nextAttemptAtIso = value?.toUtc().toIso8601String();

  DateTime? get lockedUntil =>
      lockedUntilIso != null ? DateTime.tryParse(lockedUntilIso!) : null;
  set lockedUntil(DateTime? value) =>
      lockedUntilIso = value?.toUtc().toIso8601String();

  // ==========================================================================
  // ENUM ACCESSOR (SyncErrorCode <-> String name)
  // ==========================================================================

  SyncErrorCode? get lastErrorCode {
    if (lastErrorCodeName == null) return null;
    for (final code in SyncErrorCode.values) {
      if (code.name == lastErrorCodeName) return code;
    }
    return null;
  }

  set lastErrorCode(SyncErrorCode? value) {
    lastErrorCodeName = value?.name;
  }

  // ==========================================================================
  // CORRUPTION SNAPSHOT (PURE: no mutations, engine decides quarantine)
  // ==========================================================================

  /// Snapshot COMPUTADO de corrupción (JSON + DateTime).
  /// No depende de flags ni de accesos previos. Puro y determinista.
  SyncCorruptionSnapshot get corruptionSnapshot => (
        payloadCorrupt: _isJsonMapCorrupt(payload),
        metadataCorrupt: _isJsonMapCorrupt(metadata),
        corruptCreatedAtRaw:
            DateTime.tryParse(createdAtIso) == null ? createdAtIso : null,
        corruptNextAttemptAtRaw: _corruptDateTimeRaw(nextAttemptAtIso),
        corruptLockedUntilRaw: _corruptDateTimeRaw(lockedUntilIso),
      );

  // ==========================================================================
  // DERIVED GETTERS
  // ==========================================================================

  bool get isPending => status == SyncStatus.pending;
  bool get isInProgress => status == SyncStatus.inProgress;
  bool get isCompleted => status == SyncStatus.completed;
  bool get isFailed => status == SyncStatus.failed;
  bool get isDeadLetter => status == SyncStatus.deadLetter;
  bool get isTerminal =>
      status == SyncStatus.completed || status == SyncStatus.deadLetter;

  bool get canRetry => status == SyncStatus.failed && retryCount < maxRetries;
  bool get shouldMoveToDeadLetter =>
      status == SyncStatus.failed && retryCount >= maxRetries;

  // ==========================================================================
  // CONVENIENCE FACTORIES
  // ==========================================================================

  static const int _defaultMaxRetries = 6;

  factory SyncOutboxEntryModel.forAsset({
    required String id,
    required String idempotencyKey,
    required String partitionKey,
    required SyncOperationType operationType,
    required String assetId,
    required Map<String, dynamic> assetJson,
    Map<String, dynamic> metadata = const {},
    int schemaVersion = 1,
  }) {
    return SyncOutboxEntryModel.create(
      id: id,
      idempotencyKey: idempotencyKey,
      partitionKey: partitionKey,
      operationType: operationType,
      entityType: SyncEntityType.asset,
      entityId: assetId,
      firestorePath: 'assets/$assetId',
      payload: jsonEncode(assetJson),
      schemaVersion: schemaVersion,
      status: SyncStatus.pending,
      retryCount: 0,
      maxRetries: _defaultMaxRetries,
      createdAtIso: DateTime.now().toUtc().toIso8601String(),
      metadata: jsonEncode(metadata),
    );
  }

  factory SyncOutboxEntryModel.forAuditLog({
    required String id,
    required String idempotencyKey,
    required String partitionKey,
    required String assetId,
    required String logId,
    required Map<String, dynamic> logJson,
    Map<String, dynamic> metadata = const {},
    int schemaVersion = 1,
  }) {
    return SyncOutboxEntryModel.create(
      id: id,
      idempotencyKey: idempotencyKey,
      partitionKey: partitionKey,
      operationType: SyncOperationType.create,
      entityType: SyncEntityType.auditLog,
      entityId: logId,
      firestorePath: 'assets/$assetId/audit_log/$logId',
      payload: jsonEncode(logJson),
      schemaVersion: schemaVersion,
      status: SyncStatus.pending,
      retryCount: 0,
      maxRetries: _defaultMaxRetries,
      createdAtIso: DateTime.now().toUtc().toIso8601String(),
      metadata: jsonEncode(metadata),
    );
  }

  factory SyncOutboxEntryModel.forUserAssetRef({
    required String id,
    required String idempotencyKey,
    required String partitionKey,
    required SyncOperationType operationType,
    required String userId,
    required String assetId,
    required Map<String, dynamic> refJson,
    Map<String, dynamic> metadata = const {},
    int schemaVersion = 1,
  }) {
    return SyncOutboxEntryModel.create(
      id: id,
      idempotencyKey: idempotencyKey,
      partitionKey: partitionKey,
      operationType: operationType,
      entityType: SyncEntityType.userAssetRef,
      entityId: assetId,
      firestorePath: 'users/$userId/asset_refs/$assetId',
      payload: jsonEncode(refJson),
      schemaVersion: schemaVersion,
      status: SyncStatus.pending,
      retryCount: 0,
      maxRetries: _defaultMaxRetries,
      createdAtIso: DateTime.now().toUtc().toIso8601String(),
      metadata: jsonEncode(metadata),
    );
  }
}

// ============================================================================
// FILE-PRIVATE HELPERS (fuera de la clase: no contaminan schema Isar)
// ============================================================================

/// Decode JSON seguro: retorna Map<String, dynamic> o vacío si corrupto.
/// PURO: sin side effects, sin flags.
Map<String, dynamic> _safeDecodeJsonMap(String json) {
  if (json.isEmpty) return <String, dynamic>{};
  try {
    final decoded = jsonDecode(json);
    if (decoded is Map) {
      return decoded.map((k, v) => MapEntry(k?.toString() ?? 'null', v));
    }
    return <String, dynamic>{};
  } on Object {
    return <String, dynamic>{};
  }
}

/// Retorna true si el JSON string NO es un Map válido.
/// PURO: sin side effects. Usado por corruptionSnapshot y isPayloadCorrupt.
bool _isJsonMapCorrupt(String json) {
  if (json.isEmpty) return false; // vacío no es corrupto, es ausencia
  try {
    final decoded = jsonDecode(json);
    return decoded is! Map;
  } on Object {
    return true;
  }
}

/// Retorna el raw string si es non-null y no parseable como DateTime.
/// Null input => null output (campo ausente, no corrupto).
String? _corruptDateTimeRaw(String? iso) {
  if (iso == null) return null;
  return DateTime.tryParse(iso) == null ? iso : null;
}
