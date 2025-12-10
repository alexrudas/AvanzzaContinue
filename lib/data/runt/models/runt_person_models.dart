// ===================== lib/data/runt/models/runt_person_models.dart =====================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'runt_person_models.freezed.dart';
part 'runt_person_models.g.dart';

// ==================== RESPONSE PRINCIPAL ====================

/// Respuesta completa del endpoint RUNT Persona.
///
/// Endpoint: GET /runt/person/consult/:document/:typeDcm
///
/// Contiene:
/// - [ok]: Indica si la consulta fue exitosa
/// - [source]: Fuente de datos (siempre "RUNT")
/// - [data]: Información detallada de la persona consultada
/// - [meta]: Metadatos de la operación de scraping
@freezed
abstract class RuntPersonResponse with _$RuntPersonResponse {
  const factory RuntPersonResponse({
    required bool ok,
    required String source,
    required RuntPersonData data,
    RuntPersonMeta? meta,
  }) = _RuntPersonResponse;

  factory RuntPersonResponse.fromJson(Map<String, dynamic> json) =>
      _$RuntPersonResponseFromJson(json);
}

// ==================== METADATA ====================

/// Metadatos de la operación de scraping para RUNT Persona.
///
/// Incluye información técnica sobre la ejecución:
/// - Timestamp de consulta
/// - Estrategia de scraping utilizada (puppeteer)
/// - Modo headless
/// - ID único de request
/// - Duración en milisegundos
@freezed
abstract class RuntPersonMeta with _$RuntPersonMeta {
  const factory RuntPersonMeta({
    /// Timestamp ISO de cuando se realizó el fetch
    DateTime? fetchedAt,

    /// Estrategia de scraping: "puppeteer" o similar
    String? strategy,

    /// Si se ejecutó en modo headless (sin GUI)
    bool? headless,

    /// ID único del request para trazabilidad
    String? requestId,

    /// Duración total de la operación en milisegundos
    int? durationMs,
  }) = _RuntPersonMeta;

  factory RuntPersonMeta.fromJson(Map<String, dynamic> json) =>
      _$RuntPersonMetaFromJson(json);
}

// ==================== DATA PRINCIPAL ====================

/// Datos completos de la persona consultada en el RUNT.
///
/// Contiene información personal, estado como conductor y todas las licencias asociadas.
@freezed
abstract class RuntPersonData with _$RuntPersonData {
  const factory RuntPersonData({
    /// Nombre completo de la persona
    @JsonKey(name: 'nombre_completo') required String fullName,

    /// Número de documento (cédula, pasaporte, etc.)
    @JsonKey(name: 'numero_documento') required String documentNumber,

    /// Tipo de documento: "C.C.", "C.E.", "PAS", etc.
    @JsonKey(name: 'tipo_documento') String? documentType,

    /// Estado de la persona en el RUNT: "ACTIVA", "INACTIVA", etc.
    @JsonKey(name: 'estado_persona') String? personStatus,

    /// Estado como conductor: "ACTIVO", "SUSPENDIDO", "INACTIVO", etc.
    @JsonKey(name: 'estado_conductor') String? driverStatus,

    /// Número de inscripción única en el RUNT
    @JsonKey(name: 'numero_inscripcion_runt') String? runtRegistrationNumber,

    /// Fecha de inscripción en el RUNT (formato dd/MM/yyyy)
    @JsonKey(name: 'fecha_inscripcion') String? registrationDate,

    /// Lista de todas las licencias de conducción (históricas y actuales)
    @Default([]) List<RuntLicense> licencias,

    /// Metadatos internos de la consulta
    @JsonKey(name: '_metadata') RuntPersonInternalMetadata? internalMetadata,
  }) = _RuntPersonData;

  factory RuntPersonData.fromJson(Map<String, dynamic> json) =>
      _$RuntPersonDataFromJson(json);
}

// ==================== METADATA INTERNA ====================

/// Metadatos internos generados por la API sobre la consulta de persona.
///
/// Incluye contadores y timestamp de la consulta.
@freezed
abstract class RuntPersonInternalMetadata with _$RuntPersonInternalMetadata {
  const factory RuntPersonInternalMetadata({
    /// Total de licencias encontradas para esta persona
    @JsonKey(name: 'total_licencias') int? totalLicenses,

    /// Timestamp ISO de cuando se realizó la consulta
    @JsonKey(name: 'fecha_consulta') DateTime? queryDate,
  }) = _RuntPersonInternalMetadata;

  factory RuntPersonInternalMetadata.fromJson(Map<String, dynamic> json) =>
      _$RuntPersonInternalMetadataFromJson(json);
}

// ==================== LICENCIA ====================

/// Representa una licencia de conducción emitida a la persona.
///
/// Una persona puede tener múltiples licencias a lo largo del tiempo
/// (renovaciones, cambios de categoría, etc.).
@freezed
abstract class RuntLicense with _$RuntLicense {
  const factory RuntLicense({
    /// Número único de la licencia de conducción
    @JsonKey(name: 'numero_licencia') String? licenseNumber,

    /// Organismo de tránsito que expidió la licencia
    @JsonKey(name: 'ot_expide') String? issuingAuthority,

    /// Fecha de expedición (formato dd/MM/yyyy)
    @JsonKey(name: 'fecha_expedicion') String? issueDate,

    /// Estado actual: "ACTIVA", "INACTIVA", "SUSPENDIDA", etc.
    String? estado,

    /// Restricciones especiales (ej: uso de lentes, audífonos)
    String? restricciones,

    /// Indica si la licencia está retenida: "SI" o "NO"
    @JsonKey(name: 'retencion') String? retention,

    /// Organismo que canceló o suspendió (si aplica)
    @JsonKey(name: 'ot_cancela_suspende') String? cancelingAuthority,

    /// Detalles de categorías de esta licencia
    @Default([]) List<RuntLicenseDetail> detalles,
  }) = _RuntLicense;

  factory RuntLicense.fromJson(Map<String, dynamic> json) =>
      _$RuntLicenseFromJson(json);
}

// ==================== DETALLE DE CATEGORÍA ====================

/// Detalle de una categoría específica dentro de una licencia.
///
/// Una licencia puede tener múltiples categorías (A1, A2, B1, C1, etc.)
/// cada una con su propia fecha de expedición y vencimiento.
@freezed
abstract class RuntLicenseDetail with _$RuntLicenseDetail {
  const factory RuntLicenseDetail({
    /// Categoría de la licencia: "A1", "A2", "B1", "B2", "C1", etc.
    @JsonKey(name: 'categoria') String? category,

    /// Fecha de expedición de esta categoría (formato dd/MM/yyyy)
    @JsonKey(name: 'fecha_expedicion') String? issueDate,

    /// Fecha de vencimiento de esta categoría (formato dd/MM/yyyy)
    @JsonKey(name: 'fecha_vencimiento') String? expiryDate,

    /// Categoría antigua (antes del cambio normativo), si aplica
    @JsonKey(name: 'categoria_antigua') String? previousCategory,
  }) = _RuntLicenseDetail;

  factory RuntLicenseDetail.fromJson(Map<String, dynamic> json) =>
      _$RuntLicenseDetailFromJson(json);
}
