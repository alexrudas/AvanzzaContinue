// -----------------------------------------------------------------------------
// MaintenanceItem
// -----------------------------------------------------------------------------
// Modelo base que representa un mantenimiento (incidencia, programado,
// en proceso o finalizado).
//
// Este modelo se usa en MaintenanceStatsController y en toda la vista
// "Estado de Mantenimientos" para:
//
// 1. Calcular los KPIs.
// 2. Generar dinámicamente los filtros tipo chip según el tipo de activo
//    (vehículos, inmuebles, maquinaria, etc.).
// -----------------------------------------------------------------------------

class MaintenanceItem {
  /// ID único del mantenimiento.
  final String id;

  /// Tipo del mantenimiento:
  /// 'incidencia' | 'programacion' | 'proceso' | 'finalizado'
  final String type;

  /// Título o nombre del mantenimiento (visible en la card principal).
  final String title;

  /// Subtítulo o descripción corta (opcional).
  final String? subtitle;

  /// Prioridad textual (opcional): 'alta' | 'media' | 'baja'
  final String? priority;

  /// Estado textual del mantenimiento (ej.: 'abierto', 'cerrado', etc.)
  final String status;

  /// Fecha programada o de ejecución.
  final DateTime? date;

  /// ID del activo asociado al mantenimiento.
  final String? assetId;

  /// Nombre del activo (placa, código, etc.)
  final String? assetName;

  /// Tipo de activo: 'Vehículos' | 'Inmuebles' | 'Maquinaria' | etc.
  /// Este campo es clave para que los chips del dashboard se generen correctamente.
  final String? assetType;

  /// Constructor principal.
  MaintenanceItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.priority,
    required this.status,
    this.date,
    this.assetId,
    this.assetName,
    this.assetType, // <-- nuevo campo opcional
  });

  // ---------------------------------------------------------------------------
  // Métodos utilitarios opcionales
  // ---------------------------------------------------------------------------

  /// Constructor de conveniencia (útil para placeholders)
  factory MaintenanceItem.empty() => MaintenanceItem(
        id: '',
        type: 'incidencia',
        title: 'Sin título',
        status: 'pendiente',
        assetType: 'Vehículos',
      );

  /// Convierte desde un JSON (Firestore o local)
  factory MaintenanceItem.fromJson(Map<String, dynamic> json) {
    return MaintenanceItem(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      priority: json['priority'],
      status: json['status'] ?? '',
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      assetId: json['assetId'],
      assetName: json['assetName'],
      assetType: json['assetType'], // <-- campo agregado
    );
  }

  /// Convierte el objeto a JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'subtitle': subtitle,
        'priority': priority,
        'status': status,
        'date': date?.toIso8601String(),
        'assetId': assetId,
        'assetName': assetName,
        'assetType': assetType, // <-- incluido
      };
}
