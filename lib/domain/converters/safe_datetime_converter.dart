// ============================================================================
// lib/domain/converters/safe_datetime_converter.dart
// CONVERTER CENTRALIZADO PARA DATETIME - JSON SAFE
//
// Soporta:
//   fromJson: String ISO 8601, int (millisSinceEpoch), DateTime directo
//   toJson: String ISO 8601 (UTC)
//
// NO soporta (pertenece a infra):
//   - Map con _seconds/_nanoseconds (Firestore Timestamp)
//   - Conversiones desde cloud_firestore Timestamp
//
// CONTRATO:
// - El dominio SOLO acepta fechas ya normalizadas a formatos JSON-safe.
// - Cualquier conversión desde tipos no estándar debe ocurrir en Infra.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Converter para DateTime que acepta:
/// - String ISO 8601 (con o sin zona horaria)
/// - int como millisSinceEpoch (UTC)
/// - DateTime directo
///
/// Siempre serializa a String ISO 8601 en UTC.
class SafeDateTimeConverter implements JsonConverter<DateTime, Object> {
  const SafeDateTimeConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is DateTime) {
      return json.toUtc();
    }

    if (json is String) {
      // DateTime.parse respeta la zona si viene en el string.
      // Se fuerza a UTC para consistencia de dominio.
      return DateTime.parse(json).toUtc();
    }

    if (json is int) {
      // Se asume millisSinceEpoch en UTC
      return DateTime.fromMillisecondsSinceEpoch(json, isUtc: true);
    }

    throw FormatException(
      'SafeDateTimeConverter: Cannot parse DateTime from ${json.runtimeType}',
    );
  }

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}

/// Converter nullable para DateTime.
///
/// Mismas reglas que SafeDateTimeConverter, pero acepta null.
class SafeDateTimeNullableConverter
    implements JsonConverter<DateTime?, Object?> {
  const SafeDateTimeNullableConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    return const SafeDateTimeConverter().fromJson(json);
  }

  @override
  String? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}
