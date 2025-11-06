import 'package:flutter/foundation.dart';

/// Modelo inmutable para estadísticas de mantenimientos
@immutable
class MaintenanceStats {
  final int totalProgramados;
  final int totalEnProceso;
  final int totalFinalizados;
  final int totalActivos; // Total de activos gestionados
  final DateTime lastUpdate;

  const MaintenanceStats({
    required this.totalProgramados,
    required this.totalEnProceso,
    required this.totalFinalizados,
    required this.totalActivos,
    required this.lastUpdate,
  });

  /// Constructor para estado vacío/inicial
  factory MaintenanceStats.empty() {
    return MaintenanceStats(
      totalProgramados: 0,
      totalEnProceso: 0,
      totalFinalizados: 0,
      totalActivos: 0,
      lastUpdate: DateTime.now(),
    );
  }

  /// Crea copia con campos actualizados
  MaintenanceStats copyWith({
    int? totalProgramados,
    int? totalEnProceso,
    int? totalFinalizados,
    int? totalActivos,
    DateTime? lastUpdate,
  }) {
    return MaintenanceStats(
      totalProgramados: totalProgramados ?? this.totalProgramados,
      totalEnProceso: totalEnProceso ?? this.totalEnProceso,
      totalFinalizados: totalFinalizados ?? this.totalFinalizados,
      totalActivos: totalActivos ?? this.totalActivos,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  /// Formatea la hora de última actualización
  String get formattedUpdateTime {
    final hour = lastUpdate.hour % 12 == 0 ? 12 : lastUpdate.hour % 12;
    final minute = lastUpdate.minute.toString().padLeft(2, '0');
    final period = lastUpdate.hour < 12 ? 'a.m.' : 'p.m.';
    return '$hour:$minute $period';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaintenanceStats &&
          runtimeType == other.runtimeType &&
          totalProgramados == other.totalProgramados &&
          totalEnProceso == other.totalEnProceso &&
          totalFinalizados == other.totalFinalizados &&
          totalActivos == other.totalActivos;

  @override
  int get hashCode => Object.hash(
        totalProgramados,
        totalEnProceso,
        totalFinalizados,
        totalActivos,
      );
}
