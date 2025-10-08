abstract class CatalogRepository {
  // Versión del catálogo local (para logs y control de cambios)
  String get version; // e.g., "2025.10"

  // Sincrónico en memoria
  List<Map<String, dynamic>> getProviderCategories(String providerType, String segment);

  // Preparado para remoto
  Future<List<Map<String, dynamic>>> fetchProviderCategories(String providerType, String segment) async {
    return getProviderCategories(providerType, segment);
  }
}
