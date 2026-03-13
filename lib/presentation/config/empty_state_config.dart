// ============================================================================
// lib/presentation/config/empty_state_config.dart
// EMPTY STATE CONFIG — Configuración centralizada de estados vacíos
// ============================================================================

import 'package:flutter/material.dart';

class EmptyStateConfig {
  final IconData icon;
  final String title;
  final String description;
  final String ctaLabel;

  const EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.description,
    required this.ctaLabel,
  });

  static const EmptyStateConfig home = EmptyStateConfig(
    icon: Icons.inventory_2_outlined,
    title: 'No tienes activos registrados',
    description:
        'Registra tu primer activo para gestionar mantenimientos, gastos y alertas desde Avanzza.',
    ctaLabel: 'Registrar activo',
  );

  static const EmptyStateConfig maintenance = EmptyStateConfig(
    icon: Icons.build_outlined,
    title: 'No hay activos registrados',
    description:
        'Los mantenimientos se gestionan por activo. Registra tu primer activo para comenzar.',
    ctaLabel: 'Registrar activo',
  );

  static const EmptyStateConfig accounting = EmptyStateConfig(
    icon: Icons.receipt_long_outlined,
    title: 'No hay activos registrados',
    description:
        'Los ingresos y gastos se asocian a un activo. Registra tu primer activo.',
    ctaLabel: 'Registrar activo',
  );

  static const EmptyStateConfig purchases = EmptyStateConfig(
    icon: Icons.shopping_cart_outlined,
    title: 'No hay activos registrados',
    description:
        'Registra un activo para gestionar compras de repuestos y servicios.',
    ctaLabel: 'Registrar activo',
  );

  factory EmptyStateConfig.custom({
    required IconData icon,
    required String title,
    required String description,
    String ctaLabel = 'Registrar activo',
  }) {
    return EmptyStateConfig(
      icon: icon,
      title: title,
      description: description,
      ctaLabel: ctaLabel,
    );
  }
}
