// ============================================================================
// lib/data/sync/asset_audit_service.dart
// ASSET AUDIT SERVICE — Enterprise Ultra Pro Premium (v1.3.4)
//
// QUÉ HACE:
// - Enruta eventos de auditoría de activos según su prioridad:
//     criticalAlways   -> escritura directa a Firestore
//     importantBatched -> enqueue en outbox persistente (sin RAM buffer)
//     lowValueSampled  -> persistencia probabilística controlada
// - Construye el payload canónico del evento.
// - Mantiene una sola verdad de shape para audit events.
// - Evita inventar contratos concretos de FirestorePaths o del repositorio
//   outbox: esas integraciones se inyectan vía callbacks explícitos.
//
// QUÉ NO HACE:
// - No implementa OCC, dispatcher, reconciliation ni telemetry.
// - No asume conectividad garantizada.
// - No crea rutas Firestore mágicas dentro del servicio.
// - No inventa nombres de métodos del repositorio SyncOutboxRepository.
//
// PRINCIPIOS:
// - Una sola verdad para el shape del audit event.
// - Cero buffers en RAM.
// - Integración explícita > contratos inventados.
// - Mismo input -> mismo payload salvo eventId/timestamp.
// - El servicio decide la prioridad; el caller no tiene que hacerlo.
//
// NOTA DE ARQUITECTURA:
// Este archivo está diseñado para NO acoplarse a nombres concretos como:
// - FirestorePaths.assetAuditLog(...)
// - outboxRepository.upsert(...)
// - outboxRepository.enqueue(...)
// porque esos contratos deben venir del codebase real.
// Por eso se inyectan dos callbacks:
//
// 1) auditEventsCollectionBuilder(assetId)
//    -> retorna la colección Firestore real donde se escriben audit events
//
// 2) enqueueAuditOutboxEntry(entry)
//    -> el closure captura el repo y llama el método real (upsert, enqueue, etc.)
//
// Esto elimina inventos de rutas y métodos, y deja el wiring exacto al DI.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 4 — Asset Schema v1.3.4.
// ============================================================================

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/sync/sync_outbox_entry.dart';

// ============================================================================
// ENUMS — PRIORIDAD Y TIPO DE EVENTO
// ============================================================================

/// Prioridad de persistencia del evento.
///
/// - [criticalAlways]:
///   Escritura directa a Firestore. No usa outbox.
/// - [importantBatched]:
///   Se persiste en outbox durable. Sin RAM buffer.
/// - [lowValueSampled]:
///   Se persiste solo si pasa sampling.
enum AuditPriority {
  criticalAlways,
  importantBatched,
  lowValueSampled,
}

/// Tipos de evento soportados en Fase 4.
///
/// Cada tipo resuelve internamente su prioridad y wireName.
enum AuditEventType {
  // ── criticalAlways ─────────────────────────────────────────────────────────
  snapshotTruncated,
  syncConflict,

  // ── importantBatched ──────────────────────────────────────────────────────
  historyPruned,
  historyReconciliationFailed,

  // ── lowValueSampled ───────────────────────────────────────────────────────
  writeSkippedNoChange;

  /// Prioridad de routing asociada al tipo de evento.
  AuditPriority get priority => switch (this) {
        AuditEventType.snapshotTruncated => AuditPriority.criticalAlways,
        AuditEventType.syncConflict => AuditPriority.criticalAlways,
        AuditEventType.historyPruned => AuditPriority.importantBatched,
        AuditEventType.historyReconciliationFailed =>
          AuditPriority.importantBatched,
        AuditEventType.writeSkippedNoChange => AuditPriority.lowValueSampled,
      };

  /// Wire name estable para persistencia.
  String get wireName => switch (this) {
        AuditEventType.snapshotTruncated => 'snapshot_truncated',
        AuditEventType.syncConflict => 'sync_conflict',
        AuditEventType.historyPruned => 'history_pruned',
        AuditEventType.historyReconciliationFailed =>
          'history_reconciliation_failed',
        AuditEventType.writeSkippedNoChange => 'write_skipped_no_change',
      };
}

// ============================================================================
// VALUE OBJECT — EVENTO CANÓNICO
// ============================================================================

/// Evento canónico de auditoría.
///
/// Se usa tanto para Firestore directo como para serialización a outbox.
final class AssetAuditEvent {
  final String eventId;
  final AuditEventType eventType;
  final String assetId;
  final DateTime timestampUtc;
  final AuditPriority priority;
  final Map<String, dynamic> data;
  final Map<String, dynamic>? metadata;

  const AssetAuditEvent({
    required this.eventId,
    required this.eventType,
    required this.assetId,
    required this.timestampUtc,
    required this.priority,
    required this.data,
    this.metadata,
  });

  /// Serialización canónica del evento.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'eventId': eventId,
      'eventType': eventType.wireName,
      'assetId': assetId,
      'timestamp': timestampUtc.toIso8601String(),
      'priority': priority.name,
      'data': data,
      if (metadata != null && metadata!.isNotEmpty) 'metadata': metadata,
    };
  }
}

// ============================================================================
// TYPEDEFS DE INTEGRACIÓN EXPLÍCITA
// ============================================================================

/// Builder de colección Firestore real para audit events.
///
/// El caller/DI decide la ruta canónica y captura Firestore en el closure.
/// Ejemplo en DI:
/// ```dart
/// auditEventsCollectionBuilder: (assetId) => firestore
///     .collection(FirestorePaths.assetAuditLog)
///     .doc(assetId)
///     .collection(FirestorePaths.assetAuditLogEvents),
/// ```
typedef AuditEventsCollectionBuilder = CollectionReference<Map<String, dynamic>>
    Function(String assetId);

/// Estrategia real para persistir un SyncOutboxEntry de audit.
///
/// El caller/DI captura el repo en el closure y decide el método exacto.
/// Ejemplo en DI:
/// ```dart
/// enqueueAuditOutboxEntry: (entry) => outboxRepository.upsert(entry),
/// ```
typedef AuditOutboxEnqueuer = Future<void> Function(SyncOutboxEntry entry);

// ============================================================================
// SERVICE
// ============================================================================

/// Servicio de routing de eventos de auditoría.
///
/// Diseño deliberadamente explícito:
/// - No inventa rutas Firestore.
/// - No inventa métodos del repo outbox.
/// - El wiring exacto se resuelve en DI.
///
/// Uso esperado:
/// ```dart
/// await assetAuditService.logEvent(
///   eventType: AuditEventType.snapshotTruncated,
///   assetId: 'asset-123',
///   data: {
///     'originalSizeBytes': 12345,
///     'persistedSizeBytes': 812,
///   },
/// );
/// ```
final class AssetAuditService {
  AssetAuditService({
    required AuditEventsCollectionBuilder auditEventsCollectionBuilder,
    required AuditOutboxEnqueuer enqueueAuditOutboxEntry,
    double lowValueSamplingRate = 0.10,
    Random? random,
    Uuid? uuid,
  })  : assert(
          lowValueSamplingRate >= 0.0 && lowValueSamplingRate <= 1.0,
          'lowValueSamplingRate must be between 0.0 and 1.0',
        ),
        _auditEventsCollectionBuilder = auditEventsCollectionBuilder,
        _enqueueAuditOutboxEntry = enqueueAuditOutboxEntry,
        _lowValueSamplingRate = lowValueSamplingRate,
        _random = random ?? Random(),
        _uuid = uuid ?? const Uuid();

  final AuditEventsCollectionBuilder _auditEventsCollectionBuilder;
  final AuditOutboxEnqueuer _enqueueAuditOutboxEntry;
  final double _lowValueSamplingRate;
  final Random _random;
  final Uuid _uuid;

  // ==========================================================================
  // API PÚBLICA
  // ==========================================================================

  /// Registra un evento de auditoría.
  ///
  /// Routing:
  /// - criticalAlways   -> Firestore directo
  /// - importantBatched -> outbox durable
  /// - lowValueSampled  -> Firestore directo solo si pasa sampling
  ///
  /// Retorna el evento canónico construido, útil para logs o tests.
  Future<AssetAuditEvent> logEvent({
    required AuditEventType eventType,
    required String assetId,
    required Map<String, dynamic> data,
    Map<String, dynamic>? metadata,
    DateTime? nowUtc,
  }) async {
    final event = AssetAuditEvent(
      eventId: _uuid.v4(),
      eventType: eventType,
      assetId: assetId,
      timestampUtc: (nowUtc ?? DateTime.now()).toUtc(),
      priority: eventType.priority,
      data: Map<String, dynamic>.unmodifiable(data),
      metadata: metadata == null || metadata.isEmpty
          ? null
          : Map<String, dynamic>.unmodifiable(metadata),
    );

    switch (event.priority) {
      case AuditPriority.criticalAlways:
        await _writeDirect(event);
        return event;

      case AuditPriority.importantBatched:
        await _enqueueDurably(event);
        return event;

      case AuditPriority.lowValueSampled:
        if (_shouldPersistLowValueEvent()) {
          await _writeDirect(event);
        }
        return event;
    }
  }

  // ==========================================================================
  // RUTAS DE ENTREGA
  // ==========================================================================

  /// Escritura directa de un evento a la colección Firestore real.
  Future<void> _writeDirect(AssetAuditEvent event) async {
    final collection = _auditEventsCollectionBuilder(event.assetId);
    await collection.doc(event.eventId).set(event.toMap());
  }

  /// Enqueue durable del evento al SyncOutbox.
  Future<void> _enqueueDurably(AssetAuditEvent event) async {
    final outboxEntry = SyncOutboxEntry.forAuditLog(
      id: _uuid.v4(),
      idempotencyKey:
          'audit_log:${event.assetId}:${event.eventType.wireName}:${event.eventId}',
      partitionKey: 'auditLog:${event.assetId}',
      assetId: event.assetId,
      logId: event.eventId,
      logJson: event.toMap(),
      nowUtc: event.timestampUtc,
    );

    await _enqueueAuditOutboxEntry(outboxEntry);
  }

  // ==========================================================================
  // POLÍTICA DE SAMPLING
  // ==========================================================================

  bool _shouldPersistLowValueEvent() {
    return _random.nextDouble() < _lowValueSamplingRate;
  }
}
