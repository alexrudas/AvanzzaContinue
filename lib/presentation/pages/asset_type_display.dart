// ============================================================================
// lib/presentation/pages/asset_type_display.dart
// ASSET TYPE DISPLAY — Etiquetas e iconos en español para AssetType canónico
//
// QUÉ HACE:
// - Mapea el enum canónico AssetType (vehicle/realEstate/machinery/equipment)
//   a etiquetas humanas en español (singular y plural) e icono representativo,
//   reutilizables en pantallas de agrupación por tipo y vistas dedicadas.
//
// QUÉ NO HACE:
// - No reemplaza AssetRegistrationTypeUI (ese sirve al wizard de registro).
//   Aquí trabajamos sobre el AssetType del dominio ya persistido.
// - No define lógica de negocio.
//
// PRINCIPIOS:
// - Helper presentacional puro, sin estado.
// - Mantiene la consistencia idiomática (español, sin "Vehicle"/"Real Estate").
//
// ENTERPRISE NOTES:
// CREADO (2026-04): soporte para la nueva pantalla "Activos" agrupada por tipo.
// ============================================================================

import 'package:flutter/material.dart';

import '../../domain/entities/asset/asset_entity.dart';

class AssetTypeDisplay {
  final String singularLabel;
  final String pluralLabel;
  final IconData icon;

  const AssetTypeDisplay._({
    required this.singularLabel,
    required this.pluralLabel,
    required this.icon,
  });

  static AssetTypeDisplay of(AssetType type) => switch (type) {
        AssetType.vehicle => const AssetTypeDisplay._(
            singularLabel: 'Vehículo',
            pluralLabel: 'Vehículos',
            icon: Icons.directions_car_filled_outlined,
          ),
        AssetType.realEstate => const AssetTypeDisplay._(
            singularLabel: 'Inmueble',
            pluralLabel: 'Inmuebles',
            icon: Icons.apartment_outlined,
          ),
        AssetType.machinery => const AssetTypeDisplay._(
            singularLabel: 'Maquinaria',
            pluralLabel: 'Maquinaria',
            icon: Icons.precision_manufacturing_outlined,
          ),
        AssetType.equipment => const AssetTypeDisplay._(
            singularLabel: 'Equipo',
            pluralLabel: 'Equipos',
            icon: Icons.construction_outlined,
          ),
      };
}
