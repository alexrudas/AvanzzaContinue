// ============================================================================
// lib/domain/services/core_common/key_normalizer.dart
// KEY NORMALIZER — Core Common v1 / Funciones puras (F4.a)
// ============================================================================
// QUÉ HACE:
//   - Normaliza llaves candidatas a formato canónico determinístico para el
//     matcher:
//       · phone → E.164 (+CCXXXXXXXX)
//       · email → lowercase + trim, con validación mínima
//       · docId → solo dígitos (cédula)
//       · taxId → solo dígitos sin dígito de verificación (NIT)
//   - Retorna null cuando el input no se puede normalizar con seguridad.
//
// QUÉ NO HACE:
//   - No hace I/O. No consulta repositorios. No valida existencia.
//   - No usa librerías externas de parsing telefónico (libphonenumber, etc.).
//     La normalización es manual y acotada: el contrato habla de E.164
//     sintáctico, no de resolución de rangos regionales.
//
// PRINCIPIOS:
//   - Funciones top-level puras. Determinísticas. Sin estado compartido.
//   - Misma entrada → misma salida, siempre.
//   - Si el input es inválido, null (no excepción).
//
// REUSO BACKEND:
//   - La lógica aquí debe replicarse palabra por palabra en NestJS para que
//     el matcher global y el cliente normalicen idénticamente.
//
// TABLA DE NORMALIZACIÓN:
//   | Entrada                        | defaultCC | Salida         |
//   | ------------------------------ | --------- | -------------- |
//   | "+57 300 123 4567"             | "57"      | "+573001234567"|
//   | "(+57) 300-123-4567"           | "57"      | "+573001234567"|
//   | "300 123 4567"                 | "57"      | "+573001234567"|
//   | "573001234567"                 | "57"      | "+57573001234567" → null (16 dígitos > 15) |
//   | "123"                          | "57"      | "+57123" → null (5 dígitos < 8) |
//   | ""                             | "57"      | null           |
//   | " Juan@ACME.co  "              | —         | "juan@acme.co" |
//   | "Juan ACME"                    | —         | null           |
//   | "900.123.456-7"                | —         | "900123456"    |
//   | "900-123-456-7"                | —         | "900123456"    |
//   | "900123456"                    | —         | "900123456"    |
//   | "1.020.304.050"                | —         | "1020304050"   |
// ============================================================================

/// Normaliza un teléfono a E.164 sintáctico.
///
/// Reglas:
///   - Si [raw] contiene un '+' ANTES de cualquier dígito (incluye patrones
///     como "+57 ...", "(+57) ...", "  + 57 ..."), se considera que ya trae
///     prefijo internacional y se conservan solo los dígitos que lo siguen.
///   - Si no hay '+' o está después del primer dígito, se antepone
///     [defaultCountryCallingCode] (saneado a solo dígitos).
///   - Longitud final (sin el '+'): entre 8 y 15 dígitos. Fuera de ese rango
///     → null.
///   - Si el input queda vacío tras limpiar, → null.
String? normalizePhoneE164(
  String raw, {
  required String defaultCountryCallingCode,
}) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;

  final plusPos = trimmed.indexOf('+');
  final firstDigitMatch = RegExp(r'\d').firstMatch(trimmed);
  final firstDigitPos = firstDigitMatch?.start ?? -1;
  final hasInternationalPrefix =
      plusPos >= 0 && (firstDigitPos == -1 || plusPos < firstDigitPos);

  String digits;
  if (hasInternationalPrefix) {
    digits =
        trimmed.substring(plusPos + 1).replaceAll(RegExp(r'\D'), '');
  } else {
    final cc = defaultCountryCallingCode.replaceAll(RegExp(r'\D'), '');
    if (cc.isEmpty) return null;
    final local = trimmed.replaceAll(RegExp(r'\D'), '');
    if (local.isEmpty) return null;
    digits = '$cc$local';
  }

  if (digits.length < 8 || digits.length > 15) return null;
  return '+$digits';
}

/// Normaliza un email: trim + lowercase + validación mínima.
///
/// Reglas:
///   - Trim + toLowerCase.
///   - Debe matchear ^[^@\s]+@[^@\s]+\.[^@\s]+$ (una @, sin espacios, TLD).
///   - Input vacío o inválido → null.
String? normalizeEmail(String raw) {
  final trimmed = raw.trim().toLowerCase();
  if (trimmed.isEmpty) return null;
  final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!pattern.hasMatch(trimmed)) return null;
  return trimmed;
}

/// Normaliza un documento de identidad (cédula persona): solo dígitos.
///
/// Reglas:
///   - Elimina todo carácter que no sea dígito.
///   - Si queda vacío, → null.
String? normalizeDocId(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  return digits.isEmpty ? null : digits;
}

/// Normaliza un NIT (organización): solo dígitos sin dígito de verificación.
///
/// Reglas:
///   - Si termina con '-D' (donde D es 1 dígito), se remueve el sufijo.
///   - Se eliminan todos los no-dígitos del resultado.
///   - Si queda vacío, → null.
String? normalizeTaxId(String raw) {
  String s = raw.trim();
  final dvMatch = RegExp(r'-(\d)$').firstMatch(s);
  if (dvMatch != null) {
    s = s.substring(0, dvMatch.start);
  }
  final digits = s.replaceAll(RegExp(r'\D'), '');
  return digits.isEmpty ? null : digits;
}
