// lib/domain/shared/value_objects/currency_code.dart
// VO que valida formato ISO 4217 para códigos de moneda.
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

// Comentarios en el código: VO que valida formato ISO 4217 y expone value inmutable.
class CurrencyCode {
  static final _iso4217Pattern = RegExp(r'^[A-Z]{3}$');
  final String value;

  const CurrencyCode._(this.value);

  factory CurrencyCode(String raw) {
    final trimmed = raw.trim().toUpperCase();
    if (!_iso4217Pattern.hasMatch(trimmed)) {
      throw ArgumentError(
          'CurrencyCode debe ser ISO 4217 (3 letras mayúsculas)');
    }
    return CurrencyCode._(trimmed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CurrencyCode && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
