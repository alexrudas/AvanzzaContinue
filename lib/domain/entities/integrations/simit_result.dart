// ============================================================================
// lib/domain/entities/integrations/simit_result.dart
//
// SIMIT RESULT ENTITY
//
// Entidad pura de dominio para el resultado de consulta de multas en SIMIT.
// No tiene dependencias de frameworks, Dio ni Isar.
// Inmutable por diseño — todos los campos son final.
// ============================================================================

/// Entidad de dominio que representa el resultado de una consulta SIMIT.
///
/// La consulta puede realizarse por número de documento o por placa.
/// Producida por [IntegrationsRepository.consultSimit].
class SimitResultEntity {
  /// Indica si la persona/vehículo tiene multas registradas en SIMIT.
  final bool tieneMultas;

  /// Valor total de las multas en pesos colombianos.
  final double total;

  /// Resumen agrupado de las multas (ej. por tipo, estado, etc.).
  final Map<String, dynamic> resumen;

  /// Lista completa de multas. Cada elemento es un mapa con los detalles
  /// del comparendo según la respuesta del SIMIT.
  final List<dynamic> multas;

  /// Query usada para la consulta (placa o documento).
  final String query;

  const SimitResultEntity({
    required this.tieneMultas,
    required this.total,
    required this.resumen,
    required this.multas,
    required this.query,
  });

  /// Número total de multas encontradas.
  int get cantidadMultas => multas.length;

  /// true si el total de deuda es mayor a cero.
  bool get tieneDeuda => total > 0;

  @override
  String toString() =>
      'SimitResultEntity(query: $query, tieneMultas: $tieneMultas, total: $total)';
}
