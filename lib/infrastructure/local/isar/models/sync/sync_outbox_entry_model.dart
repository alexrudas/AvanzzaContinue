// ============================================================================
// lib/infrastructure/local/isar/models/sync/sync_outbox_entry_model.dart
// MODELO ISAR PARA SYNC OUTBOX - Infraestructura
//
// OPCIÓN A (ULTRA PRO):
// - PK real Isar: `id` (autoIncrement, estable, sin colisiones).
// - ID de negocio: `entryId` (UUID v4) con índice UNIQUE para idempotencia.
// - Sin hashes como PK (evita riesgos y edge-cases).
// - payload/metadata persistidos como JSON String.
// - Fechas en ISO8601 UTC.
// ============================================================================

import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../../domain/entities/sync/sync_outbox_entry.dart';

part 'sync_outbox_entry_model.g.dart';

@Collection(
  ignore: {
    'copyWith',
    'payloadMap',
    'metadataMap',
    'createdAt',
    'lastAttemptAt',
    'completedAt',
    'isPending',
    'isInProgress',
    'isCompleted',
    'isFailed',
    'isDeadLetter',
    'canRetry',
    'shouldMoveToDeadLetter',
    'nextRetryDelay',
  },
)
class SyncOutboxEntryModel {
  // ==========================================================================
  // PRIMARY KEY (ISAR STANDARD)
  // ==========================================================================

  /// PK real de Isar: estable, auto-incremental.
  Id id = Isar.autoIncrement;

  // ==========================================================================
  // BUSINESS ID (UNIQUE)
  // ==========================================================================

  /// UUID v4 del dominio (idempotencia / correlación).
  /// UNIQUE + replace:true permite upsert por entryId si lo necesitas.
  @Index(unique: true, replace: true)
  late String entryId;

  // ==========================================================================
  // FIELDS
  // ==========================================================================

  @Enumerated(EnumType.name)
  late SyncOperationType operationType;

  @Enumerated(EnumType.name)
  late SyncEntityType entityType;

  /// ID de la entidad afectada (assetId, logId, etc.).
  @Index()
  late String entityId;

  /// Ruta Firestore destino (ej: "assets/abc123").
  late String firestorePath;

  /// Payload JSON completo (serializado como String).
  late String payload;

  @Enumerated(EnumType.name)
  late SyncStatus status;

  late int retryCount;

  late int maxRetries;

  String? lastError;

  /// ISO8601 UTC para ordenar/consultar.
  @Index()
  late String createdAtIso;

  String? lastAttemptAtIso;

  String? completedAtIso;

  /// Metadata JSON (serializado como String).
  late String metadata;

  // ==========================================================================
  // CONSTRUCTORS
  // ==========================================================================

  SyncOutboxEntryModel();

  /// Constructor “full”.
  /// Regla: el UUID del dominio entra como `entryId` (no toca la PK de Isar).
  SyncOutboxEntryModel.create({
    required String id, // UUID del dominio
    required this.operationType,
    required this.entityType,
    required this.entityId,
    required this.firestorePath,
    required this.payload,
    required this.status,
    required this.retryCount,
    required this.maxRetries,
    required this.createdAtIso,
    required this.metadata,
    this.lastError,
    this.lastAttemptAtIso,
    this.completedAtIso,
  }) {
    entryId = id;
  }

  // ==========================================================================
  // MAP ACCESSORS (para uso en mapper)
  // ==========================================================================

  Map<String, dynamic> get payloadMap {
    if (payload.isEmpty) return <String, dynamic>{};
    return jsonDecode(payload) as Map<String, dynamic>;
  }

  set payloadMap(Map<String, dynamic> value) {
    payload = jsonEncode(value);
  }

  Map<String, dynamic> get metadataMap {
    if (metadata.isEmpty) return <String, dynamic>{};
    return jsonDecode(metadata) as Map<String, dynamic>;
  }

  set metadataMap(Map<String, dynamic> value) {
    metadata = jsonEncode(value);
  }

  // ==========================================================================
  // DATETIME ACCESSORS
  // ==========================================================================

  DateTime get createdAt => DateTime.parse(createdAtIso);
  set createdAt(DateTime value) =>
      createdAtIso = value.toUtc().toIso8601String();

  DateTime? get lastAttemptAt =>
      lastAttemptAtIso != null ? DateTime.parse(lastAttemptAtIso!) : null;
  set lastAttemptAt(DateTime? value) =>
      lastAttemptAtIso = value?.toUtc().toIso8601String();

  DateTime? get completedAt =>
      completedAtIso != null ? DateTime.parse(completedAtIso!) : null;
  set completedAt(DateTime? value) =>
      completedAtIso = value?.toUtc().toIso8601String();

  // ==========================================================================
  // FACTORIES
  // ==========================================================================

  static const int _defaultMaxRetries = 5;

  factory SyncOutboxEntryModel.forAsset({
    required String id, // UUID dominio
    required SyncOperationType operationType,
    required String assetId,
    required Map<String, dynamic> assetJson,
    Map<String, dynamic> metadata = const {},
  }) {
    return SyncOutboxEntryModel.create(
      id: id,
      operationType: operationType,
      entityType: SyncEntityType.asset,
      entityId: assetId,
      firestorePath: 'assets/$assetId',
      payload: jsonEncode(assetJson),
      status: SyncStatus.pending,
      retryCount: 0,
      maxRetries: _defaultMaxRetries,
      createdAtIso: DateTime.now().toUtc().toIso8601String(),
      metadata: jsonEncode(metadata),
    );
  }

  factory SyncOutboxEntryModel.forAuditLog({
    required String id, // UUID dominio
    required String assetId,
    required String logId,
    required Map<String, dynamic> logJson,
    Map<String, dynamic> metadata = const {},
  }) {
    return SyncOutboxEntryModel.create(
      id: id,
      operationType: SyncOperationType.create,
      entityType: SyncEntityType.auditLog,
      entityId: logId,
      firestorePath: 'assets/$assetId/audit_log/$logId',
      payload: jsonEncode(logJson),
      status: SyncStatus.pending,
      retryCount: 0,
      maxRetries: _defaultMaxRetries,
      createdAtIso: DateTime.now().toUtc().toIso8601String(),
      metadata: jsonEncode(metadata),
    );
  }

  factory SyncOutboxEntryModel.forUserAssetRef({
    required String id, // UUID dominio
    required SyncOperationType operationType,
    required String userId,
    required String assetId,
    required Map<String, dynamic> refJson,
    Map<String, dynamic> metadata = const {},
  }) {
    return SyncOutboxEntryModel.create(
      id: id,
      operationType: operationType,
      entityType: SyncEntityType.userAssetRef,
      entityId: assetId,
      firestorePath: 'users/$userId/asset_refs/$assetId',
      payload: jsonEncode(refJson),
      status: SyncStatus.pending,
      retryCount: 0,
      maxRetries: _defaultMaxRetries,
      createdAtIso: DateTime.now().toUtc().toIso8601String(),
      metadata: jsonEncode(metadata),
    );
  }

  // ==========================================================================
  // GETTERS (mirror domain)
  // ==========================================================================

  bool get isPending => status == SyncStatus.pending;
  bool get isInProgress => status == SyncStatus.inProgress;
  bool get isCompleted => status == SyncStatus.completed;
  bool get isFailed => status == SyncStatus.failed;
  bool get isDeadLetter => status == SyncStatus.deadLetter;

  bool get canRetry => status == SyncStatus.failed && retryCount < maxRetries;
  bool get shouldMoveToDeadLetter =>
      status == SyncStatus.failed && retryCount >= maxRetries;

  Duration get nextRetryDelay {
    if (retryCount == 0) return Duration.zero;
    final seconds = (1 << retryCount).clamp(1, 32);
    return Duration(seconds: seconds);
  }
}
