// ============================================================================
// lib/domain/value/capability/refs/regulator_license_ref.dart
// RegulatorLicenseRef — value object para FK al registro regulatorio
// ============================================================================
// QUÉ HACE:
//   - Envuelve la licencia/identificador regulatorio de una aseguradora
//     (ej: SFC-12345 en CO, NAIC-67890 en US) en un value object tipado.
//   - Normaliza a uppercase + trim para wire-stability sin perder casos
//     donde el regulador emite la licencia en case mixto.
//   - Valida sintaxis en construcción (charset, longitud, no-blank).
//
// QUÉ NO HACE:
//   - NO valida la EXISTENCIA de la licencia ante el regulador real.
//     Esa validación requiere consulta externa (API SFC en CO, NAIC en US,
//     SuperVS en EC, ...) y vive detrás del contrato
//     RegulatorLicenseValidator (domain interface, implementación en data).
//   - NO infiere el regulador desde el formato. El countryId / regulator
//     se pasan al validador como contexto, no se derivan del string.
//
// CONTRATO DE VALIDACIÓN:
//   1. Sintáctica  → RegulatorLicenseRef(...) en construcción.
//   2. Semántica   → RegulatorLicenseValidator.validate(ref, countryId: ...)
//                    antes de marcar el workspace como aseguradora autorizada.
//
// FORMATO ACEPTADO (post-normalización):
//   ^[A-Z0-9.\-]{1,32}$  — alfanumérico uppercase + punto + guion,
//   1 a 32 chars. Ejemplos válidos tras normalización:
//     ✓ 'SFC-12345', 'NAIC.67890', 'REG-ABC-2026'
//     ✗ '' (vacío), '   ' (solo whitespace), 'SFC#12345' (símbolo no permitido),
//       longitud > 32.
// ============================================================================

class RegulatorLicenseRef {
  /// Identificador normalizado (uppercase, trimmed).
  final String value;

  /// Construye un RegulatorLicenseRef. Trim + uppercase aplicados a [raw]
  /// antes de validar. Throws [ArgumentError] si el resultado no cumple
  /// el formato canónico.
  RegulatorLicenseRef(String raw) : value = _validateAndNormalize(raw);

  /// Variante no-throw: retorna null si [raw] es null o no cumple sintaxis.
  static RegulatorLicenseRef? tryParse(String? raw) {
    if (raw == null) return null;
    try {
      return RegulatorLicenseRef(raw);
    } on ArgumentError {
      return null;
    }
  }

  static final RegExp _pattern = RegExp(r'^[A-Z0-9.\-]{1,32}$');

  static String _validateAndNormalize(String raw) {
    final cleaned = raw.trim().toUpperCase();
    if (cleaned.isEmpty) {
      throw ArgumentError(
        'RegulatorLicenseRef: licencia no puede ser vacía o solo whitespace',
      );
    }
    if (cleaned.length > 32) {
      throw ArgumentError(
        'RegulatorLicenseRef: licencia excede máximo de 32 caracteres '
        '($cleaned)',
      );
    }
    if (!_pattern.hasMatch(cleaned)) {
      throw ArgumentError(
        'RegulatorLicenseRef: solo se permiten A-Z, 0-9, ".", "-". '
        'Recibido tras normalización: "$cleaned"',
      );
    }
    return cleaned;
  }

  /// Serializa al wire (forma normalizada).
  String toJson() => value;

  /// Reconstruye desde wire. Re-aplica normalización por seguridad.
  factory RegulatorLicenseRef.fromJson(String raw) => RegulatorLicenseRef(raw);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegulatorLicenseRef && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'RegulatorLicenseRef($value)';
}
