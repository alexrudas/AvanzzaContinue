// ============================================================================
// lib/infrastructure/local/isar/mappers/sync_outbox_mapper.dart
// MAPPER ENTRE DOMAIN ENTITY Y ISAR MODEL - ULTRA PRO (Bulletproof)
//
// - Sanitización JSON-safe determinista (keys ordenadas)
// - Parsing robusto de Firestore Timestamp (anti-crash)
// - Guard de tamaño TOTAL (payload + metadata) 800KB
// - Trazabilidad SOLO en metadata, NUNCA en payload
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

/// Mapper para convertir entre SyncOutboxEntry (Domain) y
/// SyncOutboxEntryModel (Isar).
///
/// GARANTÍAS:
/// - payload queda como "verdad del negocio" (sin campos internos).
/// - Sanitización determinista (keys ordenadas lexicográficamente).
/// - Guard de tamaño TOTAL antes de persistir.
/// - Trazabilidad en __outboxSanitization solo si hubo cambios.
class SyncOutboxMapper {
  const SyncOutboxMapper();

  // ==========================================================================
  // ENTITY -> MODEL
  // ==========================================================================

  /// Convierte una entidad de dominio a modelo Isar.
  ///
  /// - Sanitiza payload y metadata para JSON-safe (determinista).
  /// - Agrega trazabilidad en metadata SOLO si hubo sanitización.
  /// - Lanza [ArgumentError] si el total excede 800KB.
  SyncOutboxEntryModel toModel(SyncOutboxEntry entity) {
    // 1. Sanitizar payload (sin contaminar)
    final payloadReport = _SanitizationReport();
    final sanitizedPayload = _sanitizeMap(entity.payload, payloadReport);
    final payloadJson = jsonEncode(sanitizedPayload);

    // 2. Sanitizar metadata
    final metadataReport = _SanitizationReport();
    final sanitizedMetadata = _sanitizeMap(entity.metadata, metadataReport);

    // 3. Combinar reportes y agregar trazabilidad si aplica
    final combinedReport = payloadReport.merge(metadataReport);
    Map<String, dynamic> finalMetadata;
    if (combinedReport.wasSanitized) {
      // Agregar reporte al final de metadata (ya sanitizada)
      finalMetadata = Map<String, dynamic>.from(sanitizedMetadata);
      finalMetadata[_sanitizationKey] = combinedReport.toJson();
    } else {
      finalMetadata = sanitizedMetadata;
    }
    final metadataJson = jsonEncode(finalMetadata);

    // 4. Guard de tamaño TOTAL
    final payloadBytes = utf8.encode(payloadJson).length;
    final metadataBytes = utf8.encode(metadataJson).length;
    final totalBytes = payloadBytes + metadataBytes;
    if (totalBytes > _maxTotalBytes) {
      throw ArgumentError(
        'Outbox entry too large ($totalBytes bytes > $_maxTotalBytes bytes). '
        'Payload: $payloadBytes bytes, Metadata: $metadataBytes bytes. '
        'Store binaries in Storage and keep only URLs.',
      );
    }

    // 5. Construir modelo
    return SyncOutboxEntryModel.create(
      id: entity.id,
      operationType: entity.operationType,
      entityType: entity.entityType,
      entityId: entity.entityId,
      firestorePath: entity.firestorePath,
      payload: payloadJson,
      status: entity.status,
      retryCount: entity.retryCount,
      maxRetries: entity.maxRetries,
      createdAtIso: entity.createdAt.toUtc().toIso8601String(),
      metadata: metadataJson,
      lastError: entity.lastError,
      lastAttemptAtIso: entity.lastAttemptAt?.toUtc().toIso8601String(),
      completedAtIso: entity.completedAt?.toUtc().toIso8601String(),
    );
  }

  // ==========================================================================
  // MODEL -> ENTITY
  // ==========================================================================

  /// Convierte un modelo Isar a entidad de dominio.
  /// Reconstruye exactamente payloadMap y metadataMap sin re-sanitizar.
  SyncOutboxEntry toEntity(SyncOutboxEntryModel model) {
    return SyncOutboxEntry(
      id: model.entryId,
      operationType: model.operationType,
      entityType: model.entityType,
      entityId: model.entityId,
      firestorePath: model.firestorePath,
      payload: model.payloadMap,
      status: model.status,
      retryCount: model.retryCount,
      maxRetries: model.maxRetries,
      createdAt: model.createdAt,
      metadata: model.metadataMap,
      lastError: model.lastError,
      lastAttemptAt: model.lastAttemptAt,
      completedAt: model.completedAt,
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
    // Ordenar keys lexicográficamente para determinismo
    final sortedKeys = input.keys.toList()..sort();
    final result = <String, dynamic>{};

    for (final key in sortedKeys) {
      result[key] = _sanitizeValue(input[key], report);
    }

    return result;
  }

  /// Sanitiza un valor individual, actualizando el reporte.
  dynamic _sanitizeValue(dynamic value, _SanitizationReport report) {
    // null, bool, num, String son JSON-safe
    if (value == null || value is bool || value is num || value is String) {
      return value;
    }

    // DateTime -> ISO8601 UTC
    if (value is DateTime) {
      report.dateTimeConvertedCount++;
      return value.toUtc().toIso8601String();
    }

    // List -> sanitizar elementos (mantener orden original)
    if (value is List) {
      return value.map((item) => _sanitizeValue(item, report)).toList();
    }

    // Map
    if (value is Map) {
      // Detectar Firestore Timestamp primero
      if (_isFirestoreTimestamp(value)) {
        report.timestampConvertedCount++;
        return _convertFirestoreTimestamp(value);
      }

      // Map normal -> sanitizar con keys ordenadas
      final sortedKeys = value.keys.toList()
        ..sort((a, b) => a.toString().compareTo(b.toString()));
      final sanitizedMap = <String, dynamic>{};

      for (final key in sortedKeys) {
        // Keys no-string -> convertir a String
        final stringKey = key is String ? key : key.toString();
        if (key is! String) {
          report.nonStringKeyConvertedCount++;
        }
        sanitizedMap[stringKey] = _sanitizeValue(value[key], report);
      }
      return sanitizedMap;
    }

    // Tipo no soportado -> toString() y registrar
    report.unsupportedTypeNames.add(value.runtimeType.toString());
    return value.toString();
  }

  // ==========================================================================
  // FIRESTORE TIMESTAMP HANDLING (ROBUST)
  // ==========================================================================

  /// Detecta si un Map es un Firestore Timestamp.
  bool _isFirestoreTimestamp(Map<dynamic, dynamic> map) {
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
  /// Soporta: int, num, String parseable.
  int _readInt(dynamic v, {int defaultValue = 0}) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? defaultValue;
    return defaultValue;
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

  /// True si hubo alguna conversión/degradación.
  bool get wasSanitized =>
      timestampConvertedCount > 0 ||
      dateTimeConvertedCount > 0 ||
      nonStringKeyConvertedCount > 0 ||
      unsupportedTypeNames.isNotEmpty;

  /// Combina dos reportes.
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

  /// Serializa a JSON (solo campos con valor).
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
