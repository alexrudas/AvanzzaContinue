// lib/domain/shared/value_objects/area_range.dart
// VO para rango de área en m² con validación de invariantes.
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

// Comentarios en el código: VO para rango de área en m² con validación de invariantes.
class AreaRange {
  final double? min;
  final double? max;

  const AreaRange({this.min, this.max});

  AreaRange validate() {
    if (min != null && min! < 0) {
      throw ArgumentError('AreaRange.min no puede ser negativo');
    }
    if (max != null && max! < 0) {
      throw ArgumentError('AreaRange.max no puede ser negativo');
    }
    if (min != null && max != null && min! > max!) {
      throw ArgumentError('AreaRange.min no puede exceder max');
    }
    return this;
  }

  bool get hasAny => min != null || max != null;
  double? get span => (min != null && max != null) ? (max! - min!) : null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AreaRange && other.min == min && other.max == max);

  @override
  int get hashCode => Object.hash(min, max);

  @override
  String toString() => 'AreaRange(min: $min, max: $max)';
}
