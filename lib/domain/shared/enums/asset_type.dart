// ============================================================================
// lib/domain/shared/enums/asset_type.dart
// ASSET REGISTRATION TYPE — Enum de categoría para el wizard de registro
//
// QUÉ HACE:
// - Define AssetRegistrationType, el enum que el wizard (Step1/Step2) usa para
//   que el usuario seleccione la categoría del activo a registrar.
// - Provee extensiones de UI (displayName, icon), wire-names (wireName/fromWire),
//   mapeo a PortfolioType, nombre sugerido y checks booleanos.
//
// QUÉ NO HACE:
// - No es el AssetType canónico del dominio (ese vive en asset_entity.dart).
// - No se usa en Isar ni en Firebase directamente.
//
// PRINCIPIOS:
// - Wire-names son estables: los valores de wireName NO cambian.
// - Para convertir AssetRegistrationType → AssetType (canonical), usar
//   AssetTypeMapper en domain/mappers/asset_type_mapper.dart.
//
// ENTERPRISE NOTES:
// RENOMBRADO (2026-03): era `AssetType`; renombrado a `AssetRegistrationType`
// para eliminar colisión conceptual con el `AssetType` canónico definido en
// domain/entities/asset/asset_entity.dart. Los wire-names permanecen intactos.
// ============================================================================

import 'package:flutter/material.dart';

import '../../entities/portfolio/portfolio_entity.dart';

/// Categoría de activo usada en el wizard de registro.
///
/// Distinct from the canonical `AssetType` in `asset_entity.dart`.
/// Use `AssetTypeMapper` to convert between both.
enum AssetRegistrationType {
  vehiculo,
  inmueble,
  maquinaria,
  equipo,
  otro,
}

// Wire-stable serialization
extension AssetRegistrationTypeWire on AssetRegistrationType {
  String get wireName {
    switch (this) {
      case AssetRegistrationType.vehiculo:
        return 'vehiculo';
      case AssetRegistrationType.inmueble:
        return 'inmueble';
      case AssetRegistrationType.maquinaria:
        return 'maquinaria';
      case AssetRegistrationType.equipo:
        return 'equipo';
      case AssetRegistrationType.otro:
        return 'otro';
    }
  }

  static AssetRegistrationType fromWire(String? raw) {
    if (raw == null) return AssetRegistrationType.otro;
    switch (raw.trim().toLowerCase()) {
      case 'vehiculo':
      case 'vehículo':
        return AssetRegistrationType.vehiculo;
      case 'inmueble':
        return AssetRegistrationType.inmueble;
      case 'maquinaria':
        return AssetRegistrationType.maquinaria;
      case 'equipo':
      case 'equipoconstruccion':
      case 'equipo_construccion':
      case 'equipooficina':
      case 'equipo_oficina':
        return AssetRegistrationType.equipo;
      default:
        return AssetRegistrationType.otro;
    }
  }
}

// UI: display labels and icons
extension AssetRegistrationTypeUI on AssetRegistrationType {
  /// Etiqueta legible para el usuario
  String get displayName {
    switch (this) {
      case AssetRegistrationType.vehiculo:
        return 'Vehículo';
      case AssetRegistrationType.inmueble:
        return 'Inmueble';
      case AssetRegistrationType.maquinaria:
        return 'Maquinaria';
      case AssetRegistrationType.equipo:
        return 'Equipo';
      case AssetRegistrationType.otro:
        return 'Otro';
    }
  }

  /// Icono representativo del tipo de activo
  IconData get icon {
    switch (this) {
      case AssetRegistrationType.vehiculo:
        return Icons.directions_car_filled_outlined;
      case AssetRegistrationType.inmueble:
        return Icons.apartment_outlined;
      case AssetRegistrationType.maquinaria:
        return Icons.precision_manufacturing_outlined;
      case AssetRegistrationType.equipo:
        return Icons.construction_outlined;
      case AssetRegistrationType.otro:
        return Icons.widgets_outlined;
    }
  }
}

// PortfolioType mapping
extension AssetRegistrationTypePortfolio on AssetRegistrationType {
  /// Mapea AssetRegistrationType a PortfolioType para creación de portafolio
  PortfolioType get portfolioType {
    switch (this) {
      case AssetRegistrationType.vehiculo:
        return PortfolioType.vehiculos;
      case AssetRegistrationType.inmueble:
        return PortfolioType.inmuebles;
      case AssetRegistrationType.maquinaria:
      case AssetRegistrationType.equipo:
      case AssetRegistrationType.otro:
        return PortfolioType.operacionGeneral;
    }
  }

  /// Nombre sugerido para el portafolio basado en el tipo de activo
  String get suggestedPortfolioName {
    switch (this) {
      case AssetRegistrationType.vehiculo:
        return 'Mi Flota de Vehículos';
      case AssetRegistrationType.inmueble:
        return 'Mis Inmuebles';
      case AssetRegistrationType.maquinaria:
        return 'Mi Maquinaria';
      case AssetRegistrationType.equipo:
        return 'Mis Equipos';
      case AssetRegistrationType.otro:
        return 'Mis Activos';
    }
  }
}

// Boolean type checks
extension AssetRegistrationTypeChecks on AssetRegistrationType {
  bool get isVehiculo => this == AssetRegistrationType.vehiculo;
  bool get isInmueble => this == AssetRegistrationType.inmueble;
  bool get isMaquinaria => this == AssetRegistrationType.maquinaria;
  bool get isEquipo => this == AssetRegistrationType.equipo;
  bool get isOtro => this == AssetRegistrationType.otro;
}
