import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// Acepta: null | Timestamp | ISO-8601 | epoch ms/seg | map {seconds,nanoseconds} | map {_seconds,_nanoseconds}
class DateTimeTimestampConverter implements JsonConverter<DateTime?, Object?> {
  const DateTimeTimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;

    if (json is Timestamp) return json.toDate();

    if (json is String) {
      final dt = DateTime.tryParse(json);
      return dt?.toUtc(); // normaliza
    }

    if (json is num) {
      // Heurística: >= 10^12 -> ms, si no -> seg
      final isMillis = json.abs() >= 1000000000000;
      final ms = isMillis ? json.toInt() : (json * 1000).toInt();
      return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
    }

    if (json is Map) {
      // SDKs/exports pueden usar {seconds,nanoseconds} o {_seconds,_nanoseconds}
      final s = json['seconds'] ?? json['_seconds'];
      final ns = json['nanoseconds'] ?? json['_nanoseconds'] ?? 0;
      if (s is num && ns is num) {
        final ms = (s * 1000).toInt() + (ns / 1e6).round();
        return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
      }
    }

    throw ArgumentError('Invalid date: $json');
  }

  @override
  Object? toJson(DateTime? value) {
    if (value == null) return null;
    // Si se serializa para Firestore, escribe Timestamp real:
    return Timestamp.fromDate(value.toUtc());
  }
}
