// lib/domain/shared/enums/product_category.dart
// Enum para categoría de producto con serialización wire-stable.
// Dominio puro: solo dart:core. Sin dependencias externas.

/// Representa las categorías principales de productos ofrecidos por proveedores.
/// - Serialización "wire-stable": nombres fijos para persistencia y transmisión.
/// - Tolerante a variantes lingüísticas (tildes, plurales, capitalización).
enum ProductCategory {
  accesorios,
  herramientas,
  lubricantes,
  maquinaria,
  materiales,
  neumaticos,
  repuestos,
  otro,
}

/// Extensión para serialización y parseo robusto de [ProductCategory].
extension ProductCategoryWire on ProductCategory {
  static const String defaultWireName = 'otro';

  /// Devuelve el nombre estable utilizado en persistencia (Firestore / JSON).
  String get wireName {
    switch (this) {
      case ProductCategory.accesorios:
        return 'accesorios';
      case ProductCategory.herramientas:
        return 'herramientas';
      case ProductCategory.lubricantes:
        return 'lubricantes';
      case ProductCategory.maquinaria:
        return 'maquinaria';
      case ProductCategory.materiales:
        return 'materiales';
      case ProductCategory.neumaticos:
        return 'neumaticos';
      case ProductCategory.repuestos:
        return 'repuestos';
      case ProductCategory.otro:
        return 'otro';
    }
  }

  /// Crea una instancia de [ProductCategory] a partir de una cadena flexible.
  /// Acepta plurales, tildes y variaciones comunes (por ejemplo: "neumáticos").
  static ProductCategory fromWire(String? raw) {
    if (raw == null) return ProductCategory.otro;

    final norm = raw
        .trim()
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');

    if (norm.contains('repuesto')) return ProductCategory.repuestos;
    if (norm.contains('neumatic')) return ProductCategory.neumaticos;
    if (norm.contains('herramient')) return ProductCategory.herramientas;
    if (norm.contains('lubric')) return ProductCategory.lubricantes;
    if (norm.contains('accesor')) return ProductCategory.accesorios;
    if (norm.contains('material')) return ProductCategory.materiales;
    if (norm.contains('maquin')) return ProductCategory.maquinaria;

    return ProductCategory.otro;
  }
}
