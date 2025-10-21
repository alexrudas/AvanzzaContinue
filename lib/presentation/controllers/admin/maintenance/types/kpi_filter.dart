import 'package:flutter/material.dart';

/// Enum para tipos de filtros en KPIs de mantenimientos
///
/// Representa los estados posibles de filtrado al tocar los KPI cards
enum KpiFilter {
  /// Filtrar por programados activas
  programados,

  /// Filtrar por mantenimientos en proceso
  enProceso,

  /// Filtrar por mantenimientos finalizados
  finalizados,
}

extension KpiFilterExtension on KpiFilter {
  /// Obtiene el label de display para UI
  String get label {
    switch (this) {
      case KpiFilter.programados:
        return 'Mttos.\nProgramados';
      case KpiFilter.enProceso:
        return 'Mttos.\nEn proceso';
      case KpiFilter.finalizados:
        return 'Finalizados\nEste mes';
    }
  }

  /// Color asociado al tipo de KPI
  Color get color {
    switch (this) {
      case KpiFilter.programados:
        return const Color(0xFFEF4444); // Rojo
      case KpiFilter.enProceso:
        return const Color(0xFF2563EB); // Azul
      case KpiFilter.finalizados:
        return const Color(0xFF10B981); // Verde
    }
  }

  /// Icono representativo
  IconData get icon {
    switch (this) {
      case KpiFilter.programados:
        return Icons.schedule;
      case KpiFilter.enProceso:
        return Icons.build_circle_outlined;
      case KpiFilter.finalizados:
        return Icons.check_circle_outline;
    }
  }

  /// Valores para mostrar en UI (orden de display)
  static List<KpiFilter> get valuesUi => [
        KpiFilter.programados,
        KpiFilter.enProceso,
        KpiFilter.finalizados,
      ];
}
