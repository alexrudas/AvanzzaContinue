// Normalización de texto para búsqueda local en "Mi Red" y similares.
//
// Pipeline determinístico ES/CO (orden estricto):
//   1. trim
//   2. toLowerCase
//   3. Map de diacríticos:
//        á à ä â ã → a
//        é è ë ê   → e
//        í ì ï î   → i
//        ó ò ö ô õ → o
//        ú ù ü û   → u
//        ñ         → n     (política tolerante: "peña" ≈ "pena")
//        ç         → c
//   4. Strip de caracteres no-alfanuméricos y no-espacio
//   5. Collapse de espacios múltiples → uno
//   6. trim final
//
// La política `ñ → n` es deliberada: hace indistinguibles "peña" y "pena"
// en el índice, aceptando colisiones raras a cambio de búsqueda tolerante
// (usuario escribe "pena motors" y encuentra "Peña Motors").
//
// El campo `displayName` original se preserva aparte; esta función produce
// la variante normalizada que vive en `displayNameNormalized` y se usa para
// comparaciones e índices Isar.

const Map<String, String> _diacriticMap = {
  'á': 'a', 'à': 'a', 'ä': 'a', 'â': 'a', 'ã': 'a',
  'é': 'e', 'è': 'e', 'ë': 'e', 'ê': 'e',
  'í': 'i', 'ì': 'i', 'ï': 'i', 'î': 'i',
  'ó': 'o', 'ò': 'o', 'ö': 'o', 'ô': 'o', 'õ': 'o',
  'ú': 'u', 'ù': 'u', 'ü': 'u', 'û': 'u',
  'ñ': 'n',
  'ç': 'c',
};

final RegExp _nonAlnumOrSpace = RegExp(r'[^a-z0-9\s]+');
final RegExp _multiSpace = RegExp(r'\s+');

/// Normaliza un string libre para búsqueda local tolerante.
///
/// Pure, sin efectos, determinística. Retorna `""` para entrada vacía o
/// compuesta solo de whitespace/puntuación.
String normalizeForSearch(String input) {
  if (input.isEmpty) return '';

  final trimmed = input.trim();
  if (trimmed.isEmpty) return '';

  final lower = trimmed.toLowerCase();

  final stripped = StringBuffer();
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    stripped.write(_diacriticMap[ch] ?? ch);
  }

  final noPunct = stripped.toString().replaceAll(_nonAlnumOrSpace, '');
  final collapsed = noPunct.replaceAll(_multiSpace, ' ');
  return collapsed.trim();
}
