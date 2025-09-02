extension DateTimeX on DateTime {
  String toUtcIso() => toUtc().toIso8601String();

  DateTime stripMillis() => isUtc
      ? DateTime.utc(year, month, day, hour, minute, second)
      : DateTime(year, month, day, hour, minute, second);
}
