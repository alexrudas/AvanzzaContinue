// lib/domain/shared/enums/service_category.dart
// Enum para categoría de servicio con serialización wire-stable.
// Dominio puro: solo dart:core.

/// Representa las categorías de servicios de mantenimiento y reparación.
/// - Serialización "wire-stable": nombres fijos para persistencia.
/// - Tolerante a variantes lingüísticas (tildes, plurales, sinónimos).
enum ServiceCategory {
  alineacionBalanceo,
  diagnostico,
  electrica,
  latoneriaPintura,
  llantas,
  lubricacion,
  mecanica,
  otro,
}

/// Extensión para serialización y parseo robusto de [ServiceCategory].
extension ServiceCategoryWire on ServiceCategory {
  static const String defaultWireName = 'otro';

  /// Devuelve el nombre estable utilizado en persistencia (Firestore / JSON).
  String get wireName {
    switch (this) {
      case ServiceCategory.alineacionBalanceo:
        return 'alineacion_balanceo';
      case ServiceCategory.diagnostico:
        return 'diagnostico';
      case ServiceCategory.electrica:
        return 'electrica';
      case ServiceCategory.latoneriaPintura:
        return 'latoneria_pintura';
      case ServiceCategory.llantas:
        return 'llantas';
      case ServiceCategory.lubricacion:
        return 'lubricacion';
      case ServiceCategory.mecanica:
        return 'mecanica';
      case ServiceCategory.otro:
        return 'otro';
    }
  }

  /// Crea una instancia de [ServiceCategory] a partir de una cadena flexible.
  /// Acepta tildes, plurales y sinónimos frecuentes.
  static ServiceCategory fromWire(String? raw) {
    if (raw == null) return ServiceCategory.otro;

    final norm = raw
        .trim()
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');

    if (norm.contains('mecanic')) return ServiceCategory.mecanica;
    if (norm.contains('electri')) return ServiceCategory.electrica;
    if (norm.contains('laton') || norm.contains('pintur')) {
      return ServiceCategory.latoneriaPintura;
    }
    if (norm.contains('diagn')) return ServiceCategory.diagnostico;
    if (norm.contains('aline') || norm.contains('balance')) {
      return ServiceCategory.alineacionBalanceo;
    }
    if (norm.contains('llant')) return ServiceCategory.llantas;
    if (norm.contains('lubric')) return ServiceCategory.lubricacion;

    return ServiceCategory.otro;
  }
}
