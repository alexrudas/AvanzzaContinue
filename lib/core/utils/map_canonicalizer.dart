// ============================================================================
// lib/core/utils/map_canonicalizer.dart
// MAP CANONICALIZER — Canonicalización determinista de Map para hash estable
//
// QUÉ HACE:
// - Ordena recursivamente todas las keys de un Map<String, dynamic>
//   en orden lexicográfico.
// - Recurre en Maps anidados a cualquier profundidad.
// - Preserva el orden original de los elementos en List.
// - Convierte DateTime a ISO-8601 UTC string para garantizar serialización
//   estable y hash consistente.
// - Convierte Timestamp (Firestore) a ISO-8601 UTC string para garantizar
//   serialización estable cuando el documento contiene campos Timestamp
//   (p.ej. governance.historyPendingSince).
// - Produce un Map canónico que garantiza hash SHA-256 estable,
//   independientemente del orden de inserción original.
//
// QUÉ NO HACE:
// - No modifica el Map original (retorna una copia nueva).
// - No ordena los items de List (solo recurre en Maps dentro de listas).
// - No valida tipos JSON-safe de forma estricta.
// - No depende de Isar.
//
// PRINCIPIOS:
// - Función pura: mismo input → mismo output siempre.
// - Sin estado global.
// - `deepSortKeys` es la única fuente de canonicalización en el codebase
//   para fines de payloadHash.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Asset Schema v1.3.4.
// REGLA: payloadHash SIEMPRE debe calcularse sobre deepSortKeys(payload).
//        NUNCA sobre el Map raw sin canonicalizar.
// ACTUALIZADO (2026-03): Soporte para Timestamp de Firestore — necesario
//   porque governance.historyPendingSince es Timestamp en el documento
//   construido por AssetDocumentBuilder.
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';

/// Ordena recursivamente todas las keys de [map] en orden lexicográfico.
///
/// Reglas:
/// - Keys de Maps (a cualquier profundidad) → orden lexicográfico.
/// - Elementos de List → orden preservado; Maps dentro de List recursados.
/// - DateTime → ISO-8601 UTC string.
/// - Timestamp (Firestore) → ISO-8601 UTC string.
/// - Otros tipos de valor → retornados sin modificación.
///
/// Garantiza que dos Maps lógicamente iguales pero con distinto orden de
/// inserción produzcan el mismo output y, por tanto, el mismo hash SHA-256.
///
/// IMPORTANTE:
/// - El resultado debe tratarse como inmutable.
/// - No modificar el Map retornado antes de calcular el hash.
Map<String, dynamic> deepSortKeys(Map<String, dynamic> map) {
  final sorted = <String, dynamic>{};
  final keys = map.keys.toList()..sort();

  for (final key in keys) {
    sorted[key] = _sortValue(map[key]);
  }

  return Map<String, dynamic>.unmodifiable(sorted);
}

// ---------------------------------------------------------------------------
// PRIVADOS
// ---------------------------------------------------------------------------

dynamic _sortValue(dynamic value) {
  if (value is DateTime) {
    return value.toUtc().toIso8601String();
  }

  // Firestore Timestamp — puede aparecer en campos como governance.historyPendingSince.
  // Se convierte a ISO-8601 UTC para garantizar serialización JSON estable y hash
  // consistente con los campos DateTime.
  if (value is Timestamp) {
    return value.toDate().toUtc().toIso8601String();
  }

  if (value is Map<String, dynamic>) {
    return deepSortKeys(value);
  }

  if (value is Map) {
    final coerced = value.map<String, dynamic>(
      (k, v) => MapEntry(k.toString(), v),
    );
    return deepSortKeys(coerced);
  }

  if (value is List) {
    final sortedList = value.map(_sortValue).toList(growable: false);
    return List<dynamic>.unmodifiable(sortedList);
  }

  return value;
}
