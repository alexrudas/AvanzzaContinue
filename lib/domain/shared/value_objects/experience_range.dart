// lib/domain/shared/value_objects/experience_range.dart
// VO para rango de experiencia en años con validación de invariantes.
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

// Comentarios en el código: VO para rango de experiencia en años con validación de invariantes (min≤max, ≥0).
class ExperienceRange {
  final int? min;
  final int? max;

  const ExperienceRange({this.min, this.max});

  ExperienceRange validate() {
    if (min != null && min! < 0) {
      throw ArgumentError('ExperienceRange.min no puede ser negativo');
    }
    if (max != null && max! < 0) {
      throw ArgumentError('ExperienceRange.max no puede ser negativo');
    }
    if (min != null && max != null && min! > max!) {
      throw ArgumentError('ExperienceRange.min no puede exceder max');
    }
    return this;
  }

  bool get hasAny => min != null || max != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExperienceRange && other.min == min && other.max == max);

  @override
  int get hashCode => Object.hash(min, max);

  @override
  String toString() => 'ExperienceRange(min: $min, max: $max)';
}
