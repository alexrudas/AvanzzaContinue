// ============================================================================
// lib/domain/value/capability/refs/business_category_ref.dart
// BusinessCategoryRef — value object para FK al catálogo de business categories
// ============================================================================
// QUÉ HACE:
//   - Envuelve el id de una business category (lubricentro, mecanico_independiente,
//     autopartes_originales, ...) en un value object tipado e inmutable.
//   - Aplica validación SINTÁCTICA en construcción (snake_case ASCII, longitud,
//     no-blank). Falla rápido en valores malformados.
//   - Distinto tipo del String crudo: imposible pasar por error un texto libre
//     a campos que requieren BusinessCategoryRef.
//
// QUÉ NO HACE:
//   - NO valida la EXISTENCIA del id en el catálogo de business categories.
//     Esa es una validación SEMÁNTICA que requiere lookup externo y vive
//     detrás del contrato BusinessCategoryRegistry (domain interface,
//     implementación en data layer).
//   - NO carga ni cachea el catálogo. Eso es responsabilidad del registry.
//
// CONTRATO DE VALIDACIÓN (dos niveles):
//   1. Sintáctica  → BusinessCategoryRef(...) en construcción.
//   2. Semántica   → BusinessCategoryRegistry.exists(ref) antes de persistir
//                    o promover a estado autoritativo.
//
// FORMATO ACEPTADO:
//   ^[a-z][a-z0-9_]{0,63}$  — snake_case ASCII puro, ≤ 64 chars,
//   debe empezar por letra. Ejemplos:
//     ✓ 'lubricentro', 'mecanico_independiente', 'autopartes_originales'
//     ✗ 'Lubricentro' (mayúscula), '1_taller' (empieza con dígito),
//       'cat-egoria' (guion), '' (vacío), ' lubricentro ' (whitespace).
// ============================================================================

class BusinessCategoryRef {
  /// Id estable de la categoría (snake_case ASCII).
  final String value;

  /// Construye un BusinessCategoryRef validando sintaxis. Throws
  /// [ArgumentError] si [raw] no cumple el formato canónico.
  BusinessCategoryRef(String raw) : value = _validate(raw);

  /// Variante no-throw: retorna null si [raw] no cumple el formato.
  static BusinessCategoryRef? tryParse(String? raw) {
    if (raw == null) return null;
    try {
      return BusinessCategoryRef(raw);
    } on ArgumentError {
      return null;
    }
  }

  static final RegExp _pattern = RegExp(r'^[a-z][a-z0-9_]{0,63}$');

  static String _validate(String raw) {
    if (raw.isEmpty) {
      throw ArgumentError('BusinessCategoryRef: id no puede ser vacío');
    }
    if (raw.length > 64) {
      throw ArgumentError(
        'BusinessCategoryRef: id excede máximo de 64 caracteres ($raw)',
      );
    }
    if (!_pattern.hasMatch(raw)) {
      throw ArgumentError(
        'BusinessCategoryRef: id debe ser snake_case ASCII '
        '(letras minúsculas, dígitos, _; debe empezar por letra). '
        'Recibido: "$raw"',
      );
    }
    return raw;
  }

  /// Serializa al wire como un string plano (el id estable).
  String toJson() => value;

  /// Reconstruye desde wire. Throws si el id es inválido.
  factory BusinessCategoryRef.fromJson(String raw) => BusinessCategoryRef(raw);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessCategoryRef && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'BusinessCategoryRef($value)';
}
