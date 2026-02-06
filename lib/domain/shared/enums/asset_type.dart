// lib/domain/shared/enums/asset_type.dart
// Enum para tipo de activo con serialización wire-stable.
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

import 'package:flutter/material.dart';

import '../../entities/portfolio/portfolio_entity.dart';

// Comentarios en el código: enum tipado para tipo de activo y serializar a wireName.
enum AssetType {
  vehiculo,
  inmueble,
  maquinaria,
  equipo,
  otro,
}

// Comentarios en el código: extensión para mapeo bi-direccional entre AssetType y string wire-stable.
extension AssetTypeWire on AssetType {
  String get wireName {
    switch (this) {
      case AssetType.vehiculo:
        return 'vehiculo';
      case AssetType.inmueble:
        return 'inmueble';
      case AssetType.maquinaria:
        return 'maquinaria';
      case AssetType.equipo:
        return 'equipo';
      case AssetType.otro:
        return 'otro';
    }
  }

  static AssetType fromWire(String? raw) {
    if (raw == null) return AssetType.otro;
    switch (raw.trim().toLowerCase()) {
      case 'vehiculo':
      case 'vehículo':
        return AssetType.vehiculo;
      case 'inmueble':
        return AssetType.inmueble;
      case 'maquinaria':
        return AssetType.maquinaria;
      case 'equipo':
      case 'equipoconstruccion':
      case 'equipo_construccion':
      case 'equipooficina':
      case 'equipo_oficina':
        return AssetType.equipo;
      default:
        return AssetType.otro;
    }
  }
}

// Comentarios en el código: extensión para UI - etiquetas e iconos de presentación.
extension AssetTypeUI on AssetType {
  /// Etiqueta legible para el usuario
  String get displayName {
    switch (this) {
      case AssetType.vehiculo:
        return 'Vehículo';
      case AssetType.inmueble:
        return 'Inmueble';
      case AssetType.maquinaria:
        return 'Maquinaria';
      case AssetType.equipo:
        return 'Equipo';
      case AssetType.otro:
        return 'Otro';
    }
  }

  /// Icono representativo del tipo de activo
  IconData get icon {
    switch (this) {
      case AssetType.vehiculo:
        return Icons.directions_car_filled_outlined;
      case AssetType.inmueble:
        return Icons.apartment_outlined;
      case AssetType.maquinaria:
        return Icons.precision_manufacturing_outlined;
      case AssetType.equipo:
        return Icons.construction_outlined;
      case AssetType.otro:
        return Icons.widgets_outlined;
    }
  }
}

// Comentarios en el código: extensión para mapeo a PortfolioType.
extension AssetTypePortfolio on AssetType {
  /// Mapea AssetType a PortfolioType para creación automática de portafolio
  PortfolioType get portfolioType {
    switch (this) {
      case AssetType.vehiculo:
        return PortfolioType.vehiculos;
      case AssetType.inmueble:
        return PortfolioType.inmuebles;
      case AssetType.maquinaria:
      case AssetType.equipo:
      case AssetType.otro:
        return PortfolioType.operacionGeneral;
    }
  }

  /// Nombre sugerido para el portafolio basado en el tipo de activo
  String get suggestedPortfolioName {
    switch (this) {
      case AssetType.vehiculo:
        return 'Mi Flota de Vehículos';
      case AssetType.inmueble:
        return 'Mis Inmuebles';
      case AssetType.maquinaria:
        return 'Mi Maquinaria';
      case AssetType.equipo:
        return 'Mis Equipos';
      case AssetType.otro:
        return 'Mis Activos';
    }
  }
}

// Comentarios en el código: extensión para verificación de tipo de activo.
extension AssetTypeChecks on AssetType {
  /// Verifica si el tipo de activo es Vehículo
  bool get isVehiculo => this == AssetType.vehiculo;

  /// Verifica si el tipo de activo es Inmueble
  bool get isInmueble => this == AssetType.inmueble;

  /// Verifica si el tipo de activo es Maquinaria
  bool get isMaquinaria => this == AssetType.maquinaria;

  /// Verifica si el tipo de activo es Equipo
  bool get isEquipo => this == AssetType.equipo;

  /// Verifica si el tipo de activo es Otro
  bool get isOtro => this == AssetType.otro;
}