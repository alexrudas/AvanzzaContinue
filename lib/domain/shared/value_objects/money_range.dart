// lib/domain/shared/value_objects/money_range.dart
// VO para rango de presupuesto/precio con validación de invariantes.
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

// Comentarios en el código: VO para rango de presupuesto con validación de invariantes (min≤max, ≥0).
class MoneyRange {
  final int? min;
  final int? max;

  const MoneyRange({this.min, this.max});

  MoneyRange validate() {
    if (min != null && min! < 0) {
      throw ArgumentError('MoneyRange.min no puede ser negativo');
    }
    if (max != null && max! < 0) {
      throw ArgumentError('MoneyRange.max no puede ser negativo');
    }
    if (min != null && max != null && min! > max!) {
      throw ArgumentError('MoneyRange.min no puede exceder max');
    }
    return this;
  }

  bool get hasAny => min != null || max != null;
  int? get span => (min != null && max != null) ? (max! - min!) : null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoneyRange && other.min == min && other.max == max);

  @override
  int get hashCode => Object.hash(min, max);

  @override
  String toString() => 'MoneyRange(min: $min, max: $max)';
}
