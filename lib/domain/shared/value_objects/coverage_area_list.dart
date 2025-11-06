// lib/domain/shared/value_objects/coverage_area_list.dart
// VO para lista de áreas de cobertura con normalización, deduplicación y límites.
// Dominio puro: solo dart:core.

/// Representa una lista inmutable y normalizada de áreas de cobertura.
/// - Máx. 50 entradas.
/// - Máx. 120 caracteres por entrada.
/// - Deduplicación case-insensitive.
/// - Orden-sensible (se conserva el orden de ingreso).
class CoverageAreaList {
  static const int _maxItems = 50;
  static const int _maxLenPerItem = 120;

  final List<String> _values;
  List<String> get values => List.unmodifiable(_values);

  CoverageAreaList._(this._values);

  /// Crea una instancia inmutable con validación de formato y límites.
  factory CoverageAreaList(Iterable<dynamic> raw) {
    final cleaned = <String>[];
    final seen = <String>{};

    for (final entry in raw) {
      if (entry == null) continue;
      final s = entry.toString().trim();
      if (s.isEmpty) continue;
      if (s.length > _maxLenPerItem) {
        throw ArgumentError(
          'Área "${s.substring(0, 30)}..." excede $_maxLenPerItem caracteres',
        );
      }

      final norm = _normalize(s);
      if (seen.add(norm)) cleaned.add(s);
    }

    if (cleaned.length > _maxItems) {
      throw ArgumentError('No puede exceder $_maxItems áreas de cobertura');
    }

    return CoverageAreaList._(cleaned);
  }

  /// Normaliza una cadena eliminando tildes y minúsculas para comparación.
  static String _normalize(String input) {
    const withAccents = 'áéíóúÁÉÍÓÚ';
    const withoutAccents = 'aeiouAEIOU';
    var normalized = input;
    for (int i = 0; i < withAccents.length; i++) {
      normalized = normalized.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return normalized.toLowerCase();
  }

  /// Busca si un área existe (case- y accent-insensitive).
  bool containsNormalized(String area) {
    final norm = _normalize(area.trim());
    return _values.any((c) => _normalize(c) == norm);
  }

  /// Une dos listas eliminando duplicados manteniendo el orden original.
  CoverageAreaList merge(CoverageAreaList other) {
    final combined = [..._values, ...other._values];
    return CoverageAreaList(combined);
  }

  int get length => _values.length;
  bool get isEmpty => _values.isEmpty;
  bool get isNotEmpty => _values.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CoverageAreaList) return false;
    if (_values.length != other._values.length) return false;
    for (int i = 0; i < _values.length; i++) {
      if (_normalize(_values[i]) != _normalize(other._values[i])) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      Object.hashAll(_values.map((v) => _normalize(v)).toList());

  @override
  String toString() => 'CoverageAreaList(${_values.join(', ')})';
}
