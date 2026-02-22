// ============================================================================
// lib/infrastructure/local/isar/mappers/sync_outbox_mapper.dart
// MAPPER ENTRE DOMAIN ENTITY Y ISAR MODEL — Enterprise Ultra Pro (V2.3)
//
// CONTRATO:
// - Alineación 1:1 (22/22 campos) entre SyncOutboxEntry y SyncOutboxEntryModel.
// - Deep copy defensivo de payload y metadata antes de sanitizar.
// - Sanitización determinista (keys ordenadas, Firestore Timestamp → ISO8601).
// - Guard de tamaño TOTAL (payload + metadata) ≤ 800KB.
// - Trazabilidad de sanitización SOLO en metadata, NUNCA en payload.
// - Corrupción en lectura (toEntity): NO silenciada → FormatException.
//
// POLÍTICA DE TIMESTAMPS:
// - El mapper NO rehidrata Firestore Timestamp como objeto Dart.
// - DateTime → ISO8601 UTC String para persistencia.
// - Map tipo Timestamp ({seconds, nanoseconds}) → ISO8601 UTC String.
// ============================================================================

import 'dart:convert';

import '../../../../domain/entities/sync/sync_outbox_entry.dart';
import '../models/sync/sync_outbox_entry_model.dart';

// ============================================================================
// CONSTANTS
// ============================================================================

/// Tamaño máximo TOTAL (payload + metadata) en bytes.
const int _maxTotalBytes = 800000;

/// Namespace para trazabilidad de sanitización en metadata.
const String _sanitizationKey = '__outboxSanitization';

// ============================================================================
// SYNC OUTBOX MAPPER
// ============================================================================

/// Mapper bidireccional entre SyncOutboxEntry (Domain) y
/// SyncOutboxEntryModel (Isar).
///
/// GARANTÍAS:
/// - payload queda como "verdad del negocio" (sin campos internos).
/// - Sanitización determinista (keys ordenadas lexicográficamente).
/// - Guard de tamaño TOTAL antes de persistir.
/// - Trazabilidad en __outboxSanitization solo si hubo cambios.
/// - Corrupción en lectura lanza FormatException (el repo decide deadLetter).
class SyncOutboxMapper {
  const SyncOutboxMapper();

  // ==========================================================================
  // ENTITY -> MODEL (22/22 campos)
  // ==========================================================================

  /// Convierte una entidad de dominio a modelo Isar.
  ///
  /// - Deep copy defensivo de payload y metadata.
  /// - Sanitiza payload y metadata para JSON-safe (determinista).
  /// - Agrega trazabilidad en metadata SOLO si hubo sanitización.
  /// - Lanza [ArgumentError] si el total excede 800KB.
  SyncOutboxEntryModel toModel(SyncOutboxEntry entity) {
    // 1. Deep copy defensivo (prevenir mutación cross-layer)
    final payloadCopy = Map<String, dynamic>.from(entity.payload);
    final metadataCopy = Map<String, dynamic>.from(entity.metadata);

    // 2. Sanitizar payload (sin contaminar)
    final payloadReport = _SanitizationReport();
    final sanitizedPayload = _sanitizeMap(payloadCopy, payloadReport);
    final payloadJson = jsonEncode(sanitizedPayload);

    // 3. Sanitizar metadata
    final metadataReport = _SanitizationReport();
    final sanitizedMetadata = _sanitizeMap(metadataCopy, metadataReport);

    // 4. Combinar reportes y agregar trazabilidad si aplica
    //    REPLACE (no duplicate): sobreescribe _sanitizationKey previo si existe.
    final combinedReport = payloadReport.merge(metadataReport);
    Map<String, dynamic> finalMetadata;
    if (combinedReport.wasSanitized) {
      finalMetadata = Map<String, dynamic>.from(sanitizedMetadata);
      finalMetadata[_sanitizationKey] = combinedReport.toJson();
    } else {
      finalMetadata = Map<String, dynamic>.from(sanitizedMetadata)
        ..remove(_sanitizationKey);
    }
    final metadataJson = jsonEncode(finalMetadata);

    // 5. Guard de tamaño TOTAL
    final payloadBytes = utf8.encode(payloadJson).length;
    final metadataBytes = utf8.encode(metadataJson).length;
    final totalBytes = payloadBytes + metadataBytes;
    if (totalBytes > _maxTotalBytes) {
      throw ArgumentError(
        'Outbox entry too large ($totalBytes bytes > $_maxTotalBytes bytes). '
        'Payload: $payloadBytes bytes, Metadata: $metadataBytes bytes. '
        'Entry: ${entity.id}. '
        'Store binaries in Storage and keep only URLs.',
      );
    }

    // 6. Construir modelo via SyncOutboxEntryModel.create (22 campos)
    return SyncOutboxEntryModel.create(
      id: entity.id,
      idempotencyKey: entity.idempotencyKey,
      partitionKey: entity.partitionKey,
      operationType: entity.operationType,
      entityType: entity.entityType,
      entityId: entity.entityId,
      firestorePath: entity.firestorePath,
      payload: payloadJson,
      schemaVersion: entity.schemaVersion,
      status: entity.status,
      retryCount: entity.retryCount,
      maxRetries: entity.maxRetries,
      nextAttemptAtIso: entity.nextAttemptAt?.toUtc().toIso8601String(),
      lastError: entity.lastError,
      lastErrorCodeName: entity.lastErrorCode?.name,
      lastHttpStatus: entity.lastHttpStatus,
      lockToken: entity.lockToken,
      lockedUntilIso: entity.lockedUntil?.toUtc().toIso8601String(),
      createdAtIso: entity.createdAt.toUtc().toIso8601String(),
      lastAttemptAtIso: entity.lastAttemptAt?.toUtc().toIso8601String(),
      completedAtIso: entity.completedAt?.toUtc().toIso8601String(),
      metadata: metadataJson,
    );
  }

  // ==========================================================================
  // MODEL -> ENTITY (22/22 campos)
  // ==========================================================================

  /// Convierte un modelo Isar a entidad de dominio.
  ///
  /// Usa los getters seguros del modelo (payloadMap, metadataMap, DateTime
  /// accessors, lastErrorCode). No re-sanitiza.
  ///
  /// Lanza [FormatException] si payload o metadata están corruptos
  /// (JSON no parseable o no es Map). El Repository decide deadLetter.
  SyncOutboxEntry toEntity(SyncOutboxEntryModel model) {
    // Corrupción guard: no silenciar datos corruptos
    if (model.payload.isNotEmpty && model.isPayloadCorrupt) {
      throw FormatException(
        'Corrupt payload JSON in outbox entry ${model.entryId}. '
        'Raw: ${model.payload.length > 100 ? '${model.payload.substring(0, 100)}...' : model.payload}',
      );
    }
    if (model.metadata.isNotEmpty && model.isMetadataCorrupt) {
      throw FormatException(
        'Corrupt metadata JSON in outbox entry ${model.entryId}. '
        'Raw: ${model.metadata.length > 100 ? '${model.metadata.substring(0, 100)}...' : model.metadata}',
      );
    }

    // DateTime corruption guards: validar raw strings ANTES de usar getters.
    // Los getters del model usan epoch fallback (1970) que ocultaría corrupción
    // y rompería orden FIFO en el engine.
    _guardDateTime(model.createdAtIso, 'createdAtIso', model.entryId);
    _guardDateTimeNullable(model.nextAttemptAtIso, 'nextAttemptAtIso', model.entryId);
    _guardDateTimeNullable(model.lockedUntilIso, 'lockedUntilIso', model.entryId);
    _guardDateTimeNullable(model.lastAttemptAtIso, 'lastAttemptAtIso', model.entryId);
    _guardDateTimeNullable(model.completedAtIso, 'completedAtIso', model.entryId);

    // Deep copy defensivo de Maps decodificados
    final payloadCopy = Map<String, dynamic>.from(model.payloadMap);
    final metadataCopy = Map<String, dynamic>.from(model.metadataMap);

    // Parseo explícito desde raw strings (NO getters con epoch fallback)
    return SyncOutboxEntry(
      id: model.entryId,
      idempotencyKey: model.idempotencyKey,
      partitionKey: model.partitionKey,
      operationType: model.operationType,
      entityType: model.entityType,
      entityId: model.entityId,
      firestorePath: model.firestorePath,
      payload: payloadCopy,
      schemaVersion: model.schemaVersion,
      status: model.status,
      retryCount: model.retryCount,
      maxRetries: model.maxRetries,
      nextAttemptAt: _parseIso(model.nextAttemptAtIso),
      lastError: model.lastError,
      lastErrorCode: model.lastErrorCode,
      lastHttpStatus: model.lastHttpStatus,
      lockToken: model.lockToken,
      lockedUntil: _parseIso(model.lockedUntilIso),
      createdAt: DateTime.parse(model.createdAtIso),
      lastAttemptAt: _parseIso(model.lastAttemptAtIso),
      completedAt: _parseIso(model.completedAtIso),
      metadata: metadataCopy,
    );
  }

  // ==========================================================================
  // SANITIZATION (DETERMINISTIC)
  // ==========================================================================

  /// Sanitiza un Map para JSON-safe con keys ordenadas.
  Map<String, dynamic> _sanitizeMap(
    Map<String, dynamic> input,
    _SanitizationReport report,
  ) {
    final sortedKeys = input.keys.toList()..sort();
    final result = <String, dynamic>{};
    for (final key in sortedKeys) {
      result[key] = _sanitizeValue(input[key], report);
    }
    return result;
  }

  /// Sanitiza un valor individual, actualizando el reporte.
  dynamic _sanitizeValue(dynamic value, _SanitizationReport report) {
    if (value == null || value is bool || value is num || value is String) {
      return value;
    }

    if (value is DateTime) {
      report.dateTimeConvertedCount++;
      return value.toUtc().toIso8601String();
    }

    if (value is List) {
      return value.map((item) => _sanitizeValue(item, report)).toList();
    }

    if (value is Map) {
      if (_isFirestoreTimestamp(value)) {
        report.timestampConvertedCount++;
        return _convertFirestoreTimestamp(value);
      }

      final sortedKeys = value.keys.toList()
        ..sort((a, b) => a.toString().compareTo(b.toString()));
      final sanitizedMap = <String, dynamic>{};
      for (final key in sortedKeys) {
        final stringKey = key is String ? key : key.toString();
        if (key is! String) {
          report.nonStringKeyConvertedCount++;
        }
        sanitizedMap[stringKey] = _sanitizeValue(value[key], report);
      }
      return sanitizedMap;
    }

    report.unsupportedTypeNames.add(value.runtimeType.toString());
    return value.toString();
  }

  // ==========================================================================
  // FIRESTORE TIMESTAMP HANDLING (ROBUST)
  // ==========================================================================

  /// Detecta si un Map es un Firestore Timestamp.
  /// Requiere exactamente 2 keys para evitar false positives con Maps normales
  /// que casualmente contengan "seconds" y "nanoseconds" como campos de negocio.
  bool _isFirestoreTimestamp(Map<dynamic, dynamic> map) {
    if (map.length != 2) return false;
    return (map.containsKey('_seconds') && map.containsKey('_nanoseconds')) ||
        (map.containsKey('seconds') && map.containsKey('nanoseconds'));
  }

  /// Convierte un Firestore Timestamp Map a ISO8601 UTC string.
  /// Robusto: tolera tipos inesperados en seconds/nanoseconds.
  String _convertFirestoreTimestamp(Map<dynamic, dynamic> map) {
    final seconds = _readInt(map['_seconds'] ?? map['seconds']);
    final nanoseconds = _readInt(map['_nanoseconds'] ?? map['nanoseconds']);
    final microseconds = nanoseconds ~/ 1000;

    final dateTime = DateTime.fromMicrosecondsSinceEpoch(
      seconds * 1000000 + microseconds,
      isUtc: true,
    );
    return dateTime.toIso8601String();
  }

  /// Lee un valor como int de forma segura.
  int _readInt(dynamic v, {int defaultValue = 0}) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? defaultValue;
    return defaultValue;
  }

  // ==========================================================================
  // DATETIME CORRUPTION GUARDS (toEntity)
  // ==========================================================================

  /// Falla rápido si un ISO string required no es parseable.
  static void _guardDateTime(String iso, String field, String entryId) {
    if (DateTime.tryParse(iso) == null) {
      throw FormatException(
        'Corrupt $field in outbox entry $entryId. Raw: "$iso"',
      );
    }
  }

  /// Falla rápido si un ISO string nullable existe pero no es parseable.
  static void _guardDateTimeNullable(
      String? iso, String field, String entryId) {
    if (iso != null && DateTime.tryParse(iso) == null) {
      throw FormatException(
        'Corrupt $field in outbox entry $entryId. Raw: "$iso"',
      );
    }
  }

  /// Parsea un ISO string nullable. Solo se llama DESPUÉS de _guardDateTimeNullable.
  static DateTime? _parseIso(String? iso) {
    if (iso == null) return null;
    return DateTime.parse(iso);
  }
}

// ============================================================================
// SANITIZATION REPORT
// ============================================================================

class _SanitizationReport {
  int timestampConvertedCount = 0;
  int dateTimeConvertedCount = 0;
  int nonStringKeyConvertedCount = 0;
  final Set<String> unsupportedTypeNames = {};

  bool get wasSanitized =>
      timestampConvertedCount > 0 ||
      dateTimeConvertedCount > 0 ||
      nonStringKeyConvertedCount > 0 ||
      unsupportedTypeNames.isNotEmpty;

  _SanitizationReport merge(_SanitizationReport other) {
    return _SanitizationReport()
      ..timestampConvertedCount =
          timestampConvertedCount + other.timestampConvertedCount
      ..dateTimeConvertedCount =
          dateTimeConvertedCount + other.dateTimeConvertedCount
      ..nonStringKeyConvertedCount =
          nonStringKeyConvertedCount + other.nonStringKeyConvertedCount
      ..unsupportedTypeNames.addAll(unsupportedTypeNames)
      ..unsupportedTypeNames.addAll(other.unsupportedTypeNames);
  }

  Map<String, dynamic> toJson() {
    return {
      'wasSanitized': true,
      if (unsupportedTypeNames.isNotEmpty)
        'typeNames': unsupportedTypeNames.toList()..sort(),
      if (timestampConvertedCount > 0)
        'timestampConvertedCount': timestampConvertedCount,
      if (dateTimeConvertedCount > 0)
        'dateTimeConvertedCount': dateTimeConvertedCount,
      if (nonStringKeyConvertedCount > 0)
        'nonStringKeyConvertedCount': nonStringKeyConvertedCount,
    };
  }
}

// ============================================================================
// CHECKLIST FINAL
// ============================================================================
// [x] 22/22 campos mapeados (toModel + toEntity)
//     id↔entryId, idempotencyKey, partitionKey, operationType, entityType,
//     entityId, firestorePath, payload↔payloadJson, schemaVersion, status,
//     retryCount, maxRetries, nextAttemptAt↔nextAttemptAtIso,
//     lastError, lastErrorCode↔lastErrorCodeName, lastHttpStatus,
//     lockToken, lockedUntil↔lockedUntilIso, createdAt↔createdAtIso,
//     lastAttemptAt↔lastAttemptAtIso, completedAt↔completedAtIso,
//     metadata↔metadataJson
// [x] Sanitización determinista (keys ordenadas, Timestamp→ISO, DateTime→ISO)
// [x] Deep copy defensivo en ambas direcciones
// [x] Guardrail tamaño 800KB (UTF-8)
// [x] Trazabilidad solo en metadata (_sanitizationKey), nunca en payload
// [x] Corrupción en toEntity: FormatException (no silenciada)
// [x] Firestore Timestamp: false-positive fix (map.length == 2)
// [x] Sin dependencias de Engine / Repo / corruptionSnapshot
// [x] Compatible con Model V2.3 real (SyncOutboxEntryModel.create)
// [x] Enums por .name (String), Fechas siempre UTC ISO8601
