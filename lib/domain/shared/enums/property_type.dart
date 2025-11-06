// lib/domain/shared/enums/property_type.dart
// Enum para tipo de inmueble con serialización wire-stable.
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

// Comentarios en el código: enum tipado para normalizar tipo de inmueble y serializar a wireName.
enum PropertyType {
  apartamento,
  casa,
  local,
  bodega,
  oficina,
  otro,
}

// Comentarios en el código: extensión para mapeo bi-direccional entre PropertyType y string wire-stable.
extension PropertyTypeWire on PropertyType {
  String get wireName {
    switch (this) {
      case PropertyType.apartamento:
        return 'apartamento';
      case PropertyType.casa:
        return 'casa';
      case PropertyType.local:
        return 'local';
      case PropertyType.bodega:
        return 'bodega';
      case PropertyType.oficina:
        return 'oficina';
      case PropertyType.otro:
        return 'otro';
    }
  }

  static PropertyType fromWire(String? raw) {
    if (raw == null) return PropertyType.otro;
    switch (raw.trim().toLowerCase()) {
      case 'apartamento':
        return PropertyType.apartamento;
      case 'casa':
        return PropertyType.casa;
      case 'local':
        return PropertyType.local;
      case 'bodega':
        return PropertyType.bodega;
      case 'oficina':
        return PropertyType.oficina;
      default:
        return PropertyType.otro;
    }
  }
}
