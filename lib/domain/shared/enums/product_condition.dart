// lib/domain/shared/enums/product_condition.dart
// Enum para condición de producto con serialización wire-stable.
// Dominio puro: solo dart:core.

enum ProductCondition {
  nuevo,
  usado,
  reacondicionado,
  otro,
}

/// Extensión para serialización y parseo robusto de ProductCondition.
/// - wireName: representación estable y portable.
/// - fromWire: parse tolerante a variaciones lingüísticas.
extension ProductConditionWire on ProductCondition {
  static const String defaultWireName = 'otro';

  String get wireName {
    switch (this) {
      case ProductCondition.nuevo:
        return 'nuevo';
      case ProductCondition.usado:
        return 'usado';
      case ProductCondition.reacondicionado:
        return 'reacondicionado';
      case ProductCondition.otro:
        return 'otro';
    }
  }

  static ProductCondition fromWire(String? raw) {
    if (raw == null) return ProductCondition.otro;
    final norm = raw.trim().toLowerCase();

    if (norm.contains('nuev')) return ProductCondition.nuevo;
    if (norm.contains('usad')) return ProductCondition.usado;
    if (norm.contains('reacond') ||
        norm.contains('refurb') ||
        norm.contains('rehabil') ||
        norm.contains('restaur')) {
      return ProductCondition.reacondicionado;
    }

    return ProductCondition.otro;
  }
}
