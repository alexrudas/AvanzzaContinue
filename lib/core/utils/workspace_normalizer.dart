/// Normalizador único de roles de workspace para garantizar consistencia
/// en comparaciones y ordenamientos alfabéticos entre todos los módulos.
///
/// Usado por:
/// - SessionContextController (auth)
/// - RegistrationController (guest)
/// - WorkspaceController (derived)
/// - WorkspaceConfig (mapping)
class WorkspaceNormalizer {
  /// Normaliza un rol a minúsculas y sin espacios extras
  static String normalize(String role) {
    return role.trim().toLowerCase();
  }

  /// Normaliza una lista de roles, eliminando duplicados y ordenando alfabéticamente
  static List<String> normalizeList(List<String> roles) {
    final normalized = roles.map((r) => normalize(r)).toSet().toList();
    normalized.sort();
    return normalized;
  }

  /// Encuentra el siguiente rol alfabético en una lista normalizada,
  /// excluyendo opcionalmente un rol específico.
  ///
  /// Retorna null si la lista está vacía o solo contiene el rol excluido.
  static String? findNextAlphabetic(List<String> roles, {String? exclude}) {
    final normalized = normalizeList(roles);

    if (exclude != null) {
      final excludeNormalized = normalize(exclude);
      normalized.removeWhere((r) => r == excludeNormalized);
    }

    return normalized.isEmpty ? null : normalized.first;
  }

  /// Compara dos roles normalizados para igualdad
  static bool areEqual(String role1, String role2) {
    return normalize(role1) == normalize(role2);
  }

  /// Ordena roles alfabéticamente (retorna lista nueva)
  static List<String> sortAlphabetically(List<String> roles) {
    final sorted = List<String>.from(roles);
    sorted.sort((a, b) => normalize(a).compareTo(normalize(b)));
    return sorted;
  }

  /// Filtra roles de una lista que pertenecen a un orgId específico
  /// (útil para contexto autenticado con múltiples orgs)
  static List<String> filterByOrg(
    List<String> roles,
    String targetOrgId,
    String Function(String role) getOrgIdForRole,
  ) {
    return roles.where((r) => getOrgIdForRole(r) == targetOrgId).toList();
  }
}
