// lib/domain/shared/value_objects/city_list.dart
// VO para lista de ciudades con normalización, deduplicación y límites.
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

// Comentarios en el código: VO para lista de ciudades con normalización, dedup y límite de 30.
class CityList {
  final List<String> _values;

  List<String> get values => List.unmodifiable(_values);

  CityList._(this._values);

  factory CityList(List<String> raw) {
    final cleaned = <String>[];
    final seen = <String>{};

    for (int i = 0; i < raw.length; i++) {
      final city = raw[i];
      final trimmed = city.trim();
      if (trimmed.isEmpty) continue;
      if (trimmed.length > 120) {
        throw ArgumentError(
            'Ciudad en índice $i excede 120 caracteres: "${trimmed.substring(0, 30)}..."');
      }
      if (seen.add(trimmed.toLowerCase())) {
        cleaned.add(trimmed);
      }
    }

    if (cleaned.length > 30) {
      throw ArgumentError('No puede exceder 30 entradas');
    }

    return CityList._(cleaned);
  }

  bool containsCaseInsensitive(String city) {
    final norm = city.trim().toLowerCase();
    return _values.any((c) => c.toLowerCase() == norm);
  }

  int get length => _values.length;
  bool get isEmpty => _values.isEmpty;
  bool get isNotEmpty => _values.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CityList) return false;
    if (_values.length != other._values.length) return false;
    for (int i = 0; i < _values.length; i++) {
      if (_values[i] != other._values[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_values);

  @override
  String toString() => 'CityList(${_values.join(', ')})';
}
