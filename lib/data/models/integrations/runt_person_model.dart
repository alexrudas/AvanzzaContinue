// ============================================================================
// lib/data/models/integrations/runt_person_model.dart
//
// RUNT PERSON MODEL — DTO
//
// Data Transfer Object para la respuesta de la API RUNT Persona.
// Parsea exactamente el JSON devuelto por el endpoint:
//   GET /runt/person/consult/:document/:type
//
// Incluye lógica de serialización completa para:
//   - licencias[]
//   - detalles[] dentro de cada licencia
//
// NO tiene dependencias de dominio ni de frameworks.
// El mapper a entidad vive en IntegrationsRepositoryImpl.
// ============================================================================

/// DTO para el detalle de categoría de licencia.
class RuntLicenseDetailModel {
  final String categoria;
  final String fechaExpedicion;
  final String fechaVencimiento;
  final String? categoriaAntigua;

  const RuntLicenseDetailModel({
    required this.categoria,
    required this.fechaExpedicion,
    required this.fechaVencimiento,
    this.categoriaAntigua,
  });

  factory RuntLicenseDetailModel.fromJson(Map<String, dynamic> json) {
    return RuntLicenseDetailModel(
      categoria: (json['categoria'] as String?) ?? '',
      fechaExpedicion: (json['fecha_expedicion'] as String?) ?? '',
      fechaVencimiento: (json['fecha_vencimiento'] as String?) ?? '',
      categoriaAntigua: json['categoria_antigua'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'categoria': categoria,
        'fecha_expedicion': fechaExpedicion,
        'fecha_vencimiento': fechaVencimiento,
        'categoria_antigua': categoriaAntigua,
      };
}

/// DTO para una licencia de conducción RUNT.
class RuntLicenseModel {
  final String numeroLicencia;
  final String otExpide;
  final String fechaExpedicion;
  final String estado;
  final String restricciones;
  final String retencion;
  final String otCancelaSuspende;
  final List<RuntLicenseDetailModel> detalles;

  const RuntLicenseModel({
    required this.numeroLicencia,
    required this.otExpide,
    required this.fechaExpedicion,
    required this.estado,
    required this.restricciones,
    required this.retencion,
    required this.otCancelaSuspende,
    required this.detalles,
  });

  factory RuntLicenseModel.fromJson(Map<String, dynamic> json) {
    final rawDetalles = json['detalles'];
    final detalles = rawDetalles is List
        ? rawDetalles
            .whereType<Map<String, dynamic>>()
            .map(RuntLicenseDetailModel.fromJson)
            .toList()
        : <RuntLicenseDetailModel>[];

    return RuntLicenseModel(
      numeroLicencia: (json['numero_licencia'] as String?) ?? '',
      otExpide: (json['ot_expide'] as String?) ?? '',
      fechaExpedicion: (json['fecha_expedicion'] as String?) ?? '',
      estado: (json['estado'] as String?) ?? '',
      restricciones: (json['restricciones'] as String?) ?? '',
      retencion: (json['retencion'] as String?) ?? '',
      otCancelaSuspende: (json['ot_cancela_suspende'] as String?) ?? '',
      detalles: detalles,
    );
  }

  Map<String, dynamic> toJson() => {
        'numero_licencia': numeroLicencia,
        'ot_expide': otExpide,
        'fecha_expedicion': fechaExpedicion,
        'estado': estado,
        'restricciones': restricciones,
        'retencion': retencion,
        'ot_cancela_suspende': otCancelaSuspende,
        'detalles': detalles.map((d) => d.toJson()).toList(),
      };
}

/// DTO para el bloque `data` de la respuesta RUNT Persona.
class RuntPersonDataModel {
  final String nombreCompleto;
  final String tipoDocumento;
  final String numeroDocumento;
  final String estadoPersona;
  final String estadoConductor;
  final String numeroInscripcionRunt;
  final String fechaInscripcion;
  final List<RuntLicenseModel> licencias;

  const RuntPersonDataModel({
    required this.nombreCompleto,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.estadoPersona,
    required this.estadoConductor,
    required this.numeroInscripcionRunt,
    required this.fechaInscripcion,
    required this.licencias,
  });

  factory RuntPersonDataModel.fromJson(Map<String, dynamic> json) {
    final rawLicencias = json['licencias'];
    final licencias = rawLicencias is List
        ? rawLicencias
            .whereType<Map<String, dynamic>>()
            .map(RuntLicenseModel.fromJson)
            .toList()
        : <RuntLicenseModel>[];

    return RuntPersonDataModel(
      nombreCompleto: (json['nombre_completo'] as String?) ?? '',
      tipoDocumento: (json['tipo_documento'] as String?) ?? '',
      numeroDocumento: (json['numero_documento'] as String?) ?? '',
      estadoPersona: (json['estado_persona'] as String?) ?? '',
      estadoConductor: (json['estado_conductor'] as String?) ?? '',
      numeroInscripcionRunt: (json['numero_inscripcion_runt'] as String?) ?? '',
      fechaInscripcion: (json['fecha_inscripcion'] as String?) ?? '',
      licencias: licencias,
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre_completo': nombreCompleto,
        'tipo_documento': tipoDocumento,
        'numero_documento': numeroDocumento,
        'estado_persona': estadoPersona,
        'estado_conductor': estadoConductor,
        'numero_inscripcion_runt': numeroInscripcionRunt,
        'fecha_inscripcion': fechaInscripcion,
        'licencias': licencias.map((l) => l.toJson()).toList(),
      };
}

/// DTO raíz para la respuesta completa del endpoint RUNT Persona.
class RuntPersonResponseModel {
  final bool ok;
  final String source;
  final RuntPersonDataModel data;

  const RuntPersonResponseModel({
    required this.ok,
    required this.source,
    required this.data,
  });

  factory RuntPersonResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    if (rawData is! Map<String, dynamic>) {
      throw const FormatException(
        'RuntPersonResponseModel: campo "data" ausente o inválido.',
      );
    }

    return RuntPersonResponseModel(
      ok: (json['ok'] as bool?) ?? false,
      source: (json['source'] as String?) ?? 'RUNT',
      data: RuntPersonDataModel.fromJson(rawData),
    );
  }

  Map<String, dynamic> toJson() => {
        'ok': ok,
        'source': source,
        'data': data.toJson(),
      };
}
