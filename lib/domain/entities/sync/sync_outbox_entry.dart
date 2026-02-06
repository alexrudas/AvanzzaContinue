// ============================================================================
// lib/domain/entities/sync/sync_outbox_entry.dart
// OUTBOX ENTRY PARA SINCRONIZACIÓN OFFLINE-FIRST - Dominio Puro
//
// - Persiste operaciones pendientes de sincronización a Firestore
// - Payload JSON incluye runtimeType para polimorfismo
// - Garantiza entrega ordenada y atómica
// - Soporta reintentos con backoff exponencial
//
// SIN anotaciones Isar. El modelo Isar vive en Infraestructura.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../converters/safe_datetime_converter.dart';

part 'sync_outbox_entry.freezed.dart';
part 'sync_outbox_entry.g.dart';

// ============================================================================
// SYNC OPERATION TYPE
// ============================================================================

/// Tipo de operación de sincronización.
enum SyncOperationType {
  /// Crear documento en Firestore
  @JsonValue('CREATE')
  create,

  /// Actualizar documento existente
  @JsonValue('UPDATE')
  update,

  /// Eliminar documento
  @JsonValue('DELETE')
  delete,

  /// Operación batch (múltiples documentos)
  @JsonValue('BATCH')
  batch,
}

// ============================================================================
// SYNC STATUS
// ============================================================================

/// Estado de la entrada en el outbox.
enum SyncStatus {
  /// Pendiente de envío
  @JsonValue('PENDING')
  pending,

  /// En proceso de sincronización
  @JsonValue('IN_PROGRESS')
  inProgress,

  /// Sincronizado exitosamente (puede limpiarse)
  @JsonValue('COMPLETED')
  completed,

  /// Falló, pendiente de reintento
  @JsonValue('FAILED')
  failed,

  /// Falló definitivamente (requiere intervención manual)
  @JsonValue('DEAD_LETTER')
  deadLetter,
}

// ============================================================================
// ENTITY TYPE (para routing de sync)
// ============================================================================

/// Tipo de entidad a sincronizar.
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

// ============================================================================
// SYNC OUTBOX ENTRY
// ============================================================================

/// Entrada en el outbox de sincronización.
///
/// REGLAS:
/// - Cada operación pendiente genera una entrada.
/// - El payload JSON preserva runtimeType para polimorfismo.
/// - Las entradas se procesan en orden (por createdAt).
/// - Tras sincronización exitosa, se marca COMPLETED y se limpia.
/// - Tras N fallos, se mueve a DEAD_LETTER para revisión manual.
@Freezed()
abstract class SyncOutboxEntry with _$SyncOutboxEntry {
  const SyncOutboxEntry._();

  const factory SyncOutboxEntry({
    /// ID único de la entrada (UUID v4)
    required String id,

    /// Tipo de operación
    required SyncOperationType operationType,

    /// Tipo de entidad a sincronizar
    required SyncEntityType entityType,

    /// ID de la entidad afectada
    required String entityId,

    /// Ruta Firestore destino (ej: "assets/abc123")
    required String firestorePath,

    /// Payload JSON completo (incluye runtimeType para polimorfismo)
    required Map<String, dynamic> payload,

    /// Estado actual de sincronización
    @Default(SyncStatus.pending) SyncStatus status,

    /// Número de intentos de sincronización
    @Default(0) int retryCount,

    /// Máximo de reintentos antes de dead letter
    @Default(5) int maxRetries,

    /// Último error (si falló)
    String? lastError,

    /// Fecha de creación (orden de procesamiento)
    @SafeDateTimeConverter() required DateTime createdAt,

    /// Fecha de último intento
    @SafeDateTimeNullableConverter() DateTime? lastAttemptAt,

    /// Fecha de completado (si status == completed)
    @SafeDateTimeNullableConverter() DateTime? completedAt,

    /// Metadatos adicionales (userId, source, correlationId, etc.)
    @Default(<String, dynamic>{}) Map<String, dynamic> metadata,
  }) = _SyncOutboxEntry;

  factory SyncOutboxEntry.fromJson(Map<String, dynamic> json) =>
      _$SyncOutboxEntryFromJson(json);

  // ==========================================================================
  // FACTORY: Crear entrada para Asset
  // ==========================================================================

  /// Crea una entrada de outbox para sincronizar un Asset.
  factory SyncOutboxEntry.forAsset({
    required String id,
    required SyncOperationType operationType,
    required String assetId,
    required Map<String, dynamic> assetJson,
    Map<String, dynamic> metadata = const {},
  }) {
    return SyncOutboxEntry(
      id: id,
      operationType: operationType,
      entityType: SyncEntityType.asset,
      entityId: assetId,
      firestorePath: 'assets/$assetId',
      payload: assetJson,
      status: SyncStatus.pending,
      createdAt: DateTime.now().toUtc(),
      metadata: metadata,
    );
  }

  /// Crea una entrada de outbox para sincronizar un AuditLog.
  factory SyncOutboxEntry.forAuditLog({
    required String id,
    required String assetId,
    required String logId,
    required Map<String, dynamic> logJson,
    Map<String, dynamic> metadata = const {},
  }) {
    return SyncOutboxEntry(
      id: id,
      operationType: SyncOperationType.create,
      entityType: SyncEntityType.auditLog,
      entityId: logId,
      firestorePath: 'assets/$assetId/audit_log/$logId',
      payload: logJson,
      status: SyncStatus.pending,
      createdAt: DateTime.now().toUtc(),
      metadata: metadata,
    );
  }

  /// Crea una entrada de outbox para sincronizar UserAssetRef.
  factory SyncOutboxEntry.forUserAssetRef({
    required String id,
    required SyncOperationType operationType,
    required String userId,
    required String assetId,
    required Map<String, dynamic> refJson,
    Map<String, dynamic> metadata = const {},
  }) {
    return SyncOutboxEntry(
      id: id,
      operationType: operationType,
      entityType: SyncEntityType.userAssetRef,
      entityId: assetId,
      firestorePath: 'users/$userId/asset_refs/$assetId',
      payload: refJson,
      status: SyncStatus.pending,
      createdAt: DateTime.now().toUtc(),
      metadata: metadata,
    );
  }

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  bool get isPending => status == SyncStatus.pending;
  bool get isInProgress => status == SyncStatus.inProgress;
  bool get isCompleted => status == SyncStatus.completed;
  bool get isFailed => status == SyncStatus.failed;
  bool get isDeadLetter => status == SyncStatus.deadLetter;

  bool get canRetry => status == SyncStatus.failed && retryCount < maxRetries;
  bool get shouldMoveToDeadLetter =>
      status == SyncStatus.failed && retryCount >= maxRetries;

  /// Calcula el delay para el próximo reintento (backoff exponencial).
  Duration get nextRetryDelay {
    if (retryCount == 0) return Duration.zero;
    // 1s, 2s, 4s, 8s, 16s, max 32s
    final seconds = (1 << retryCount).clamp(1, 32);
    return Duration(seconds: seconds);
  }
}

// ============================================================================
// TRANSICIONES DE ESTADO
// ============================================================================

extension SyncOutboxEntryTransitions on SyncOutboxEntry {
  /// Marca como en progreso.
  SyncOutboxEntry markInProgress() {
    if (status != SyncStatus.pending && status != SyncStatus.failed) {
      throw StateError('markInProgress solo válido desde PENDING o FAILED');
    }
    return copyWith(
      status: SyncStatus.inProgress,
      lastAttemptAt: DateTime.now().toUtc(),
    );
  }

  /// Marca como completado exitosamente.
  SyncOutboxEntry markCompleted() {
    if (status != SyncStatus.inProgress) {
      throw StateError('markCompleted solo válido desde IN_PROGRESS');
    }
    return copyWith(
      status: SyncStatus.completed,
      completedAt: DateTime.now().toUtc(),
    );
  }

  /// Marca como fallido con error.
  SyncOutboxEntry markFailed(String error) {
    if (status != SyncStatus.inProgress) {
      throw StateError('markFailed solo válido desde IN_PROGRESS');
    }
    final newRetryCount = retryCount + 1;
    final newStatus =
        newRetryCount >= maxRetries ? SyncStatus.deadLetter : SyncStatus.failed;

    return copyWith(
      status: newStatus,
      lastError: error,
      retryCount: newRetryCount,
    );
  }

  /// Mueve manualmente a dead letter.
  SyncOutboxEntry moveToDeadLetter(String reason) {
    return copyWith(
      status: SyncStatus.deadLetter,
      lastError: reason,
    );
  }

  /// Resetea para reintento manual (desde dead letter).
  SyncOutboxEntry resetForRetry() {
    if (status != SyncStatus.deadLetter) {
      throw StateError('resetForRetry solo válido desde DEAD_LETTER');
    }
    return copyWith(
      status: SyncStatus.pending,
      retryCount: 0,
      lastError: null,
    );
  }
}
