import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DateTimeTimestampConverter implements JsonConverter<DateTime?, Object?> {
  const DateTimeTimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.tryParse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    throw ArgumentError('Invalid date: $json');
  }

  @override
  Object? toJson(DateTime? value) => value?.toIso8601String();
}
