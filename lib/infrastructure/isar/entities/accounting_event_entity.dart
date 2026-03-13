// ============================================================================
// lib/infrastructure/isar/entities/accounting_event_entity.dart
// AUDIT TRAIL — Enterprise Ultra Pro (Infra / Isar)
//
// HARDENED — FAIL HARD — AUDIT GRADE
//
// PRINCIPIOS:
//
// - Infra NO corrige datos corruptos.
// - Infra NO permite overwrite silencioso.
// - JSON corrupto = excepción explícita.
// - Hash inválido = excepción explícita.
// - No replace automático en UNIQUE index.
// - Índice compuesto entityId + occurredAtIso para chain eficiente.
// - Domain sigue siendo la autoridad del hash y canonicalización.
//
// NOTA:
// build_runner genera el .g.dart.
// NO modificar manualmente el archivo generado.
// ============================================================================

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:isar_community/isar.dart';

import '../../../domain/entities/accounting/accounting_event.dart';

part 'accounting_event_entity.g.dart';

@Collection(
  ignore: {
    'occurredAt',
    'recordedAt',
    'payload',
  },
)
class AccountingEventEntity {
  // ===========================================================================
  // PRIMARY KEY (Isar internal auto increment)
  // ===========================================================================

  Id id = Isar.autoIncrement;

  // ===========================================================================
  // BUSINESS KEY — UNIQUE SIN REPLACE (anti-overwrite)
  // ===========================================================================

  /// UUID del evento de dominio.
  /// UNIQUE sin replace: el repositorio controla idempotencia y hash mismatch.
  @Index(unique: true)
  late String eventId;

  // ===========================================================================
  // ROUTING + QUERY OPTIMIZATION
  // ===========================================================================

  /// Tipo de entidad (ej: account_receivable).
  @Index()
  late String entityType;

  /// ID de la entidad.
  /// Índice compuesto con entityType + sequenceNumber para queries O(1) por chain.
  @Index(composite: [CompositeIndex('entityType'), CompositeIndex('sequenceNumber')])
  late String entityId;

  // ===========================================================================
  // EVENT METADATA
  // ===========================================================================

  late String eventType;

  /// ISO8601 UTC (ordenable lexicográficamente).
  @Index()
  late String occurredAtIso;

  /// ISO8601 UTC.
  late String recordedAtIso;

  late String actorId;

  // ===========================================================================
  // PAYLOAD + HASH
  // ===========================================================================

  /// JSON canónico proveniente del Domain.
  late String payloadJson;

  /// SHA-256 del payloadJson en reposo — checksum rápido de integridad.
  /// Calculado en el mapper al persistir. Indexado para detección de corrupción.
  @Index()
  late String payloadHash;

  /// Hash del evento previo en la chain (null si es el primero).
  String? prevHash;

  /// SHA-256 calculado en Domain.
  late String hash;

  // ===========================================================================
  // SEQUENCE (infra-level — no en domain entity)
  // ===========================================================================

  /// Número de secuencia 1-based dentro de la chain (entityId + entityType).
  /// Asignado atómicamente en appendAtomic. Garantiza ausencia de huecos.
  @Index()
  late int sequenceNumber;

  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================

  AccountingEventEntity();

  // ===========================================================================
  // COMPUTED GETTERS (NO PERSISTIDOS)
  // ===========================================================================

  DateTime get occurredAt => DateTime.parse(occurredAtIso);

  set occurredAt(DateTime value) =>
      occurredAtIso = value.toUtc().toIso8601String();

  DateTime get recordedAt => DateTime.parse(recordedAtIso);

  set recordedAt(DateTime value) =>
      recordedAtIso = value.toUtc().toIso8601String();

  /// Decodificación estricta del payload.
  /// JSON corrupto = FormatException.
  Map<String, dynamic> get payload => _decodeStrictJsonMap(payloadJson);
}

// ============================================================================
// STRICT JSON DECODER (FAIL-HARD + CONTEXTO FORENSE)
// ============================================================================

Map<String, dynamic> _decodeStrictJsonMap(String jsonStr) {
  if (jsonStr.isEmpty) {
    throw const FormatException(
      'AccountingEvent payloadJson is empty. '
      'Local storage integrity compromised.',
    );
  }

  try {
    final decoded = jsonDecode(jsonStr);

    if (decoded is! Map) {
      throw const FormatException(
        'AccountingEvent payloadJson must decode to Map.',
      );
    }

    return Map<String, dynamic>.from(decoded);
  } catch (e) {
    // No logging aquí (infra pura).
    // El repositorio superior debe capturar esta excepción
    // y enviarla a logging/telemetría.
    throw FormatException(
      'AccountingEvent payloadJson corrupted. '
      'Possible storage corruption or serialization bug. '
      'Original error: $e',
    );
  }
}

// ============================================================================
// MAPPERS (Domain ↔ Infra)
// ============================================================================

/// Domain → Entity
/// No recalcula hash.
/// No canonicaliza.
/// Confía en Domain como fuente de verdad.
AccountingEventEntity accountingEventToEntity(
  AccountingEvent event,
) {
  final payloadJson = jsonEncode(event.payload);

  final entity = AccountingEventEntity()
    ..eventId = event.id
    ..entityType = event.entityType
    ..entityId = event.entityId
    ..eventType = event.eventType
    ..occurredAtIso = event.occurredAt.toUtc().toIso8601String()
    ..recordedAtIso = event.recordedAt.toUtc().toIso8601String()
    ..actorId = event.actorId
    ..payloadJson = payloadJson
    ..payloadHash = sha256.convert(utf8.encode(payloadJson)).toString()
    ..prevHash = event.prevHash
    ..hash = event.hash;

  return entity;
}

/// Entity → Domain
/// Valida integridad usando verifiedFromJson.
/// Si el hash no coincide → FormatException.
/// Si el payload está corrupto → FormatException.
AccountingEvent accountingEventFromEntity(
  AccountingEventEntity entity,
) {
  final payloadMap = _decodeStrictJsonMap(entity.payloadJson);

  final json = <String, dynamic>{
    'id': entity.eventId,
    'entityType': entity.entityType,
    'entityId': entity.entityId,
    'eventType': entity.eventType,
    'occurredAt': entity.occurredAtIso,
    'recordedAt': entity.recordedAtIso,
    'actorId': entity.actorId,
    'payload': payloadMap,
    if (entity.prevHash != null) 'prevHash': entity.prevHash,
    'hash': entity.hash,
  };

  return AccountingEvent.verifiedFromJson(json);
}
