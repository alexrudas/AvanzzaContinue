// lib/domain/shared/enums/vehicle_category.dart
// Enum para categoría de vehículo con serialización wire-stable.
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

// Comentarios en el código: enum tipado para categoría de vehículo y serializar a wireName.
enum VehicleCategory {
  auto,
  camion,
  moto,
  autobus,
  maquinariaPesada,
  otro,
}

// Comentarios en el código: extensión para mapeo bi-direccional entre VehicleCategory y string wire-stable.
extension VehicleCategoryWire on VehicleCategory {
  String get wireName {
    switch (this) {
      case VehicleCategory.auto:
        return 'auto';
      case VehicleCategory.camion:
        return 'camion';
      case VehicleCategory.moto:
        return 'moto';
      case VehicleCategory.autobus:
        return 'autobus';
      case VehicleCategory.maquinariaPesada:
        return 'maquinaria_pesada';
      case VehicleCategory.otro:
        return 'otro';
    }
  }

  static VehicleCategory fromWire(String? raw) {
    if (raw == null) return VehicleCategory.otro;
    switch (raw.trim().toLowerCase()) {
      case 'auto':
        return VehicleCategory.auto;
      case 'camion':
      case 'camión':
        return VehicleCategory.camion;
      case 'moto':
        return VehicleCategory.moto;
      case 'autobus':
      case 'autobús':
        return VehicleCategory.autobus;
      case 'maquinaria_pesada':
      case 'maquinariapesada':
        return VehicleCategory.maquinariaPesada;
      default:
        return VehicleCategory.otro;
    }
  }
}
