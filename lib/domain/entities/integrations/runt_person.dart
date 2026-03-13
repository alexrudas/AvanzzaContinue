// ============================================================================
// lib/domain/entities/integrations/runt_person.dart
//
// RUNT PERSON ENTITY
//
// Entidad pura de dominio para la consulta RUNT Persona.
// No tiene dependencias de frameworks, Dio ni Isar.
// Inmutable por diseño — todos los campos son final.
// ============================================================================

/// Detalle de una categoría dentro de una licencia de conducción.
class RuntLicenseDetailEntity {
  final String categoria;
  final String fechaExpedicion;
  final String fechaVencimiento;
  final String? categoriaAntigua;

  const RuntLicenseDetailEntity({
    required this.categoria,
    required this.fechaExpedicion,
    required this.fechaVencimiento,
    this.categoriaAntigua,
  });

  @override
  String toString() =>
      'RuntLicenseDetailEntity(categoria: $categoria, vencimiento: $fechaVencimiento)';
}

/// Licencia de conducción de una persona según el RUNT.
class RuntLicenseEntity {
  final String numeroLicencia;
  final String otExpide;
  final String fechaExpedicion;
  final String estado;
  final String restricciones;
  final String retencion;
  final String otCancelaSuspende;
  final List<RuntLicenseDetailEntity> detalles;

  const RuntLicenseEntity({
    required this.numeroLicencia,
    required this.otExpide,
    required this.fechaExpedicion,
    required this.estado,
    required this.restricciones,
    required this.retencion,
    required this.otCancelaSuspende,
    required this.detalles,
  });

  /// true si la licencia está activa según el RUNT.
  bool get isActiva => estado.toUpperCase() == 'ACTIVA';

  @override
  String toString() =>
      'RuntLicenseEntity(numero: $numeroLicencia, estado: $estado)';
}

/// Entidad de dominio que representa los datos de una persona consultada en el RUNT.
///
/// Producida por [IntegrationsRepository.consultRuntPerson].
/// Consumida exclusivamente por la capa de presentación.
class RuntPersonEntity {
  final String nombreCompleto;
  final String tipoDocumento;
  final String numeroDocumento;
  final String estadoPersona;
  final String estadoConductor;
  final String numeroInscripcionRunt;
  final String fechaInscripcion;
  final List<RuntLicenseEntity> licencias;

  const RuntPersonEntity({
    required this.nombreCompleto,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.estadoPersona,
    required this.estadoConductor,
    required this.numeroInscripcionRunt,
    required this.fechaInscripcion,
    required this.licencias,
  });

  /// true si la persona está en estado activo según el RUNT.
  bool get isActiva => estadoPersona.toUpperCase() == 'ACTIVA';

  /// Licencias activas de la persona.
  List<RuntLicenseEntity> get licenciasActivas =>
      licencias.where((l) => l.isActiva).toList();

  @override
  String toString() =>
      'RuntPersonEntity(nombre: $nombreCompleto, doc: $numeroDocumento)';
}
