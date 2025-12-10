// ===================== lib/data/simit/models/simit_models.dart =====================

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'simit_models.freezed.dart';
part 'simit_models.g.dart';

// ==================== RESPONSE PRINCIPAL ====================

/// Respuesta completa del endpoint SIMIT Multas.
///
/// Endpoint: GET /simit/multas/:license
///
/// Contiene información sobre multas de tránsito asociadas a una cédula:
/// - Resumen general de multas y comparendos
/// - Detalle completo de cada multa
/// - Información del infractor y vehículo involucrado
@freezed
abstract class SimitResponse with _$SimitResponse {
  const factory SimitResponse({
    required bool ok,
    required String source,
    required SimitData data,
    SimitMeta? meta,
  }) = _SimitResponse;

  factory SimitResponse.fromJson(Map<String, dynamic> json) =>
      _$SimitResponseFromJson(json);
}

// ==================== METADATA ====================

/// Metadatos de la operación de scraping para SIMIT.
///
/// Incluye información técnica sobre la ejecución del scraping.
@freezed
abstract class SimitMeta with _$SimitMeta {
  const factory SimitMeta({
    /// Timestamp ISO de cuando se realizó el fetch
    DateTime? fetchedAt,

    /// Estrategia de scraping: "puppeteer"
    String? strategy,

    /// Si se ejecutó en modo headless (sin GUI)
    bool? headless,

    /// ID único del request para trazabilidad
    String? requestId,

    /// Duración total de la operación en milisegundos
    int? durationMs,
  }) = _SimitMeta;

  factory SimitMeta.fromJson(Map<String, dynamic> json) =>
      _$SimitMetaFromJson(json);
}

// ==================== DATA PRINCIPAL ====================

/// Datos completos de multas de tránsito para una cédula.
///
/// Incluye resumen ejecutivo y detalle completo de cada multa.
@freezed
abstract class SimitData with _$SimitData {
  const factory SimitData({
    /// Indica si la persona tiene multas registradas (REQUIRED)
    @JsonKey(name: 'tieneMultas') required bool hasFines,

    /// Monto total de todas las multas en pesos colombianos (REQUIRED)
    required num total,

    /// Resumen ejecutivo de multas y comparendos (REQUIRED)
    @JsonKey(name: 'resumen') required SimitSummary summary,

    /// Lista detallada de todas las multas
    @JsonKey(name: 'multas') @Default([]) List<SimitFine> fines,
  }) = _SimitData;

  factory SimitData.fromJson(Map<String, dynamic> json) =>
      _$SimitDataFromJson(json);
}

// ==================== RESUMEN ====================

/// Resumen ejecutivo de multas y comparendos.
///
/// Proporciona contadores y totales consolidados.
@freezed
abstract class SimitSummary with _$SimitSummary {
  const factory SimitSummary({
    /// Cantidad de comparendos (REQUIRED)
    required int comparendos,

    /// Cantidad de multas (puede venir como String "3", parsear a int)
    /// Usa MultasCountConverter para parsing defensivo
    @MultasCountConverter() required int multas,

    /// Cantidad de acuerdos de pago activos (REQUIRED)
    @JsonKey(name: 'acuerdosDePago') required int paymentAgreementsCount,

    /// Total formateado con símbolo de pesos: "$ 3.227.005"
    @JsonKey(name: 'totalFormateado') String? formattedTotal,

    /// Nombre parcialmente enmascarado: "VIC*** ANT****"
    @JsonKey(name: 'nombre') String? maskedName,

    /// Número de cédula (REQUIRED)
    @JsonKey(name: 'cedula') required String document,
  }) = _SimitSummary;

  factory SimitSummary.fromJson(Map<String, dynamic> json) =>
      _$SimitSummaryFromJson(json);
}

// ==================== MULTA ====================

/// Representa una multa de tránsito individual.
///
/// Incluye información básica y detalle completo del comparendo.
@freezed
abstract class SimitFine with _$SimitFine {
  const factory SimitFine({
    /// ID único de la multa (REQUIRED)
    required String id,

    /// Fecha de la multa (formato dd/MM/yyyy)
    String? fecha,

    /// Ciudad donde se impuso la multa
    String? ciudad,

    /// Valor original de la multa en pesos
    int? valor,

    /// Valor a pagar actualizado (incluye intereses/descuentos) (REQUIRED)
    @JsonKey(name: 'valorAPagar') required num amountToPay,

    /// Estado actual: "Cobro coactivo", "Pendiente de pago", etc. (REQUIRED)
    required String estado,

    /// Placa del vehículo involucrado (REQUIRED)
    required String placa,

    /// Código corto de infracción: "D02...", "C24...", etc.
    @JsonKey(name: 'infraccion') String? infractionCodeShort,

    /// Detalle completo del comparendo (nullable para degradación elegante)
    SimitFineDetail? detalle,
  }) = _SimitFine;

  factory SimitFine.fromJson(Map<String, dynamic> json) =>
      _$SimitFineFromJson(json);
}

// ==================== DETALLE DE MULTA ====================

/// Detalle completo de un comparendo de tránsito.
///
/// Agrupa toda la información en secciones lógicas.
/// Si este objeto viene null o incompleto, la app debe seguir funcionando
/// mostrando solo la información básica de la multa.
@freezed
abstract class SimitFineDetail with _$SimitFineDetail {
  const factory SimitFineDetail({
    /// Información del comparendo
    @JsonKey(name: 'informacion_comparendo') SimitTicketInfo? ticketInfo,

    /// Información de la infracción cometida
    @JsonKey(name: 'infraccion') SimitInfractionInfo? infraction,

    /// Datos del conductor infractor
    @JsonKey(name: 'datos_conductor') SimitDriverInfo? driver,

    /// Información del vehículo involucrado
    @JsonKey(name: 'informacion_vehiculo') SimitVehicleInfo? vehicle,

    /// Información del servicio y licencia
    @JsonKey(name: 'servicio') SimitServiceInfo? service,

    /// Información adicional del comparendo
    @JsonKey(name: 'informacion_adicional') SimitExtraInfo? extraInfo,
  }) = _SimitFineDetail;

  factory SimitFineDetail.fromJson(Map<String, dynamic> json) =>
      _$SimitFineDetailFromJson(json);
}

// ==================== INFORMACIÓN DEL COMPARENDO ====================

/// Información básica del comparendo de tránsito.
@freezed
abstract class SimitTicketInfo with _$SimitTicketInfo {
  const factory SimitTicketInfo({
    /// Número único del comparendo
    @JsonKey(name: 'No. comparendo') String? ticketNumber,

    /// Fecha del comparendo (formato dd/MM/yyyy)
    @JsonKey(name: 'Fecha') String? date,

    /// Hora del comparendo (formato HH:mm:ss)
    @JsonKey(name: 'Hora') String? time,

    /// Dirección donde se impuso el comparendo
    @JsonKey(name: 'Dirección') String? address,

    /// Indica si es comparendo electrónico: "S" o "N"
    @JsonKey(name: 'Comparendo electrónico') String? isElectronic,

    /// Fuente del comparendo: "Comparenderas electrónicas SIMIT", etc.
    @JsonKey(name: 'Fuente comparendo') String? source,

    /// Secretaría de tránsito que impuso el comparendo
    @JsonKey(name: 'Secretaría') String? secretary,

    /// Agente de tránsito que impuso el comparendo
    @JsonKey(name: 'Agente') String? agent,
  }) = _SimitTicketInfo;

  factory SimitTicketInfo.fromJson(Map<String, dynamic> json) =>
      _$SimitTicketInfoFromJson(json);
}

// ==================== INFORMACIÓN DE LA INFRACCIÓN ====================

/// Detalles de la infracción de tránsito cometida.
@freezed
abstract class SimitInfractionInfo with _$SimitInfractionInfo {
  const factory SimitInfractionInfo({
    /// Código de la infracción: "D02", "C24", "C35", etc.
    @JsonKey(name: 'Código') String? code,

    /// Descripción completa de la infracción
    @JsonKey(name: 'Descripción') String? description,
  }) = _SimitInfractionInfo;

  factory SimitInfractionInfo.fromJson(Map<String, dynamic> json) =>
      _$SimitInfractionInfoFromJson(json);
}

// ==================== DATOS DEL CONDUCTOR ====================

/// Información del conductor infractor.
@freezed
abstract class SimitDriverInfo with _$SimitDriverInfo {
  const factory SimitDriverInfo({
    /// Tipo de documento: "Cédula", "C.E.", "Pasaporte", etc.
    @JsonKey(name: 'Tipo documento') String? documentType,

    /// Número de documento (puede estar parcialmente enmascarado)
    @JsonKey(name: 'Número documento') String? documentNumber,

    /// Nombres del infractor
    @JsonKey(name: 'Nombres') String? firstNames,

    /// Apellidos del infractor
    @JsonKey(name: 'Apellidos') String? lastNames,

    /// Tipo de infractor: "Motociclista", "Conductor", "Peatón", etc.
    @JsonKey(name: 'Tipo de infractor') String? infractorType,
  }) = _SimitDriverInfo;

  factory SimitDriverInfo.fromJson(Map<String, dynamic> json) =>
      _$SimitDriverInfoFromJson(json);
}

// ==================== INFORMACIÓN DEL VEHÍCULO ====================

/// Información del vehículo involucrado en la infracción.
@freezed
abstract class SimitVehicleInfo with _$SimitVehicleInfo {
  const factory SimitVehicleInfo({
    /// Placa del vehículo
    @JsonKey(name: 'Placa') String? plate,

    /// Número de licencia de tránsito del vehículo
    @JsonKey(name: 'No. Licencia del vehículo') String? vehicleLicenseNumber,

    /// Tipo de vehículo: "MOTOCICLETA", "AUTOMOVIL", etc.
    @JsonKey(name: 'Tipo') String? type,

    /// Tipo de servicio: "Particular", "Público", "Oficial"
    @JsonKey(name: 'Servicio') String? service,

    /// Indica si fue inmovilizado: "S" o "N"
    @JsonKey(name: 'Inmovilización') String? immobilized,
  }) = _SimitVehicleInfo;

  factory SimitVehicleInfo.fromJson(Map<String, dynamic> json) =>
      _$SimitVehicleInfoFromJson(json);
}

// ==================== INFORMACIÓN DEL SERVICIO ====================

/// Información de la licencia de conducción al momento de la infracción.
@freezed
abstract class SimitServiceInfo with _$SimitServiceInfo {
  const factory SimitServiceInfo({
    /// Número de la licencia de conducción
    @JsonKey(name: 'No. Licencia') String? licenseNumber,

    /// Fecha de vencimiento de la licencia (formato dd/MM/yyyy)
    @JsonKey(name: 'Fecha vencimiento') String? expiryDate,

    /// Categoría de la licencia: "A1", "A2", "B1", "C1", etc.
    @JsonKey(name: 'Categoría') String? category,

    /// Secretaría que expidió la licencia
    @JsonKey(name: 'Secretaría') String? secretary,
  }) = _SimitServiceInfo;

  factory SimitServiceInfo.fromJson(Map<String, dynamic> json) =>
      _$SimitServiceInfoFromJson(json);
}

// ==================== INFORMACIÓN ADICIONAL ====================

/// Información adicional del comparendo.
///
/// Incluye datos geográficos y demográficos complementarios.
@freezed
abstract class SimitExtraInfo with _$SimitExtraInfo {
  const factory SimitExtraInfo({
    /// Municipio donde se impuso el comparendo
    @JsonKey(name: 'Municipio comparendo') String? ticketMunicipality,

    /// Localidad o comuna
    @JsonKey(name: 'Localidad comuna') String? locality,

    /// Municipio de matrícula del vehículo
    @JsonKey(name: 'Municipio matrícula') String? plateMunicipality,

    /// Radio de acción del vehículo
    @JsonKey(name: 'Radio acción') String? operationRadius,

    /// Modalidad de transporte
    @JsonKey(name: 'Modalidad transporte') String? transportMode,

    /// Número de pasajeros
    @JsonKey(name: 'Pasajeros') String? passengers,

    /// Edad del infractor al momento de la infracción
    @JsonKey(name: 'Edad infractor') String? infractorAge,
  }) = _SimitExtraInfo;

  factory SimitExtraInfo.fromJson(Map<String, dynamic> json) =>
      _$SimitExtraInfoFromJson(json);
}