// ===================== lib/data/runt/models/runt_vehicle_models.dart =====================

import 'package:freezed_annotation/freezed_annotation.dart';
// Asegúrate de que tu archivo de converters exista, si no, usa el que definí al final
import '../../../core/utils/json_converters.dart'; 

part 'runt_vehicle_models.freezed.dart';
part 'runt_vehicle_models.g.dart';

// ==================== CONVERTIDOR LOCAL (Si no lo tienes en utils) ====================
// Úsalo si no tienes uno similar en tu proyecto. Transforma int/double a String.
class StringFlexibleConverter implements JsonConverter<String?, Object?> {
  const StringFlexibleConverter();

  @override
  String? fromJson(Object? json) {
    if (json == null) return null;
    return json.toString(); // Convierte 123456 -> "123456"
  }

  @override
  Object? toJson(String? object) => object;
}

// ==================== RESPONSE PRINCIPAL ====================

@freezed
abstract class RuntVehicleResponse with _$RuntVehicleResponse {
  const factory RuntVehicleResponse({
    required bool ok,
    required String source,
    required RuntVehicleData data,
    RuntVehicleMeta? meta,
  }) = _RuntVehicleResponse;

  factory RuntVehicleResponse.fromJson(Map<String, dynamic> json) =>
      _$RuntVehicleResponseFromJson(json);
}

// ==================== METADATA ====================

@freezed
abstract class RuntVehicleMeta with _$RuntVehicleMeta {
  const factory RuntVehicleMeta({
    DateTime? fetchedAt,
    String? strategy,
    bool? headless,
    String? requestId,
    int? durationMs,
    String? apiUrl,
    String? schemaVersion,
  }) = _RuntVehicleMeta;

  factory RuntVehicleMeta.fromJson(Map<String, dynamic> json) =>
      _$RuntVehicleMetaFromJson(json);
}

// ==================== DATA PRINCIPAL ====================

@freezed
abstract class RuntVehicleData with _$RuntVehicleData {
  const factory RuntVehicleData({
    @JsonKey(name: 'informacion_basica') required RuntVehicleBasicInfo basicInfo,
    @JsonKey(name: 'informacion_general') RuntVehicleGeneralInfo? generalInfo,
    @JsonKey(name: 'datos_tecnicos') RuntVehicleTechnicalData? technicalData,
    @Default([]) List<RuntSoatRecord> soat,
    @JsonKey(name: 'seguros_rc') @Default([]) List<RuntRcInsuranceRecord> rcInsurances,
    @JsonKey(name: 'revision_tecnica') @Default([]) List<RuntRtmRecord> rtmHistory,
    @JsonKey(name: 'limitaciones_propiedad') @Default([]) List<RuntOwnershipLimitation> ownershipLimitations,
    @JsonKey(name: 'garantias') @Default([]) List<RuntWarranty> warranties,
  }) = _RuntVehicleData;

  factory RuntVehicleData.fromJson(Map<String, dynamic> json) =>
      _$RuntVehicleDataFromJson(json);
}

// ==================== INFORMACIÓN BÁSICA ====================

@freezed
abstract class RuntVehicleBasicInfo with _$RuntVehicleBasicInfo {
  const factory RuntVehicleBasicInfo({
    @JsonKey(name: 'placa_del_veh_culo') required String plate,
    @JsonKey(name: 'estado_del_veh_culo') required String vehicleStatus,
    @JsonKey(name: 'tipo_de_servicio') required String serviceType,
    @JsonKey(name: 'clase_de_veh_culo') required String vehicleClass,
    
    // CAMBIO: Usamos String con convertidor para evitar desbordamientos o errores de tipo
    @JsonKey(name: 'nro_de_licencia_de_tr_nsito') 
    @StringFlexibleConverter() 
    String? transitLicenseNumber,
  }) = _RuntVehicleBasicInfo;

  factory RuntVehicleBasicInfo.fromJson(Map<String, dynamic> json) =>
      _$RuntVehicleBasicInfoFromJson(json);
}

// ==================== INFORMACIÓN GENERAL ====================

@freezed
abstract class RuntVehicleGeneralInfo with _$RuntVehicleGeneralInfo {
  const factory RuntVehicleGeneralInfo({
    String? marca,
    @JsonKey(name: 'l_nea') String? line,
    @IntFlexibleConverter() int? modelo,
    String? color,
    @JsonKey(name: 'n_mero_de_serie') String? serialNumber,
    @JsonKey(name: 'n_mero_de_motor') String? engineNumber,
    @JsonKey(name: 'n_mero_de_chasis') String? chassisNumber,
    @JsonKey(name: 'n_mero_de_vin') String? vin,
    @IntFlexibleConverter() int? cilindraje,
    @JsonKey(name: 'tipo_de_carrocer_a') String? bodyType,
    @JsonKey(name: 'tipo_combustible') String? fuelType,
    @JsonKey(name: 'fecha_de_matricula_inicial_dd_mm_aaaa') String? initialRegistrationDate,
    @JsonKey(name: 'autoridad_de_tr_nsito') String? transitAuthority,
    @JsonKey(name: 'grav_menes_a_la_propiedad') String? propertyLiens,
    @JsonKey(name: 'cl_sico_o_antiguo') String? isClassicOrAntique,
    String? repotenciado,
    @JsonKey(name: 'regrabaci_n_motor_si_no') String? engineReengraving,
    @JsonKey(name: 'nro_regrabaci_n_motor') String? engineReengravingNumber,
    @JsonKey(name: 'regrabaci_n_chasis_si_no') String? chassisReengraving,
    @JsonKey(name: 'nro_regrabaci_n_chasis') String? chassisReengravingNumber,
    @JsonKey(name: 'regrabaci_n_serie_si_no') String? seriesReengraving,
    @JsonKey(name: 'nro_regrabaci_n_serie') String? seriesReengravingNumber,
    @JsonKey(name: 'regrabaci_n_vin_si_no') String? vinReengraving,
    @JsonKey(name: 'nro_regrabaci_n_vin') String? vinReengravingNumber,
    @JsonKey(name: 'veh_culo_ense_anza_si_no') String? isTeachingVehicle,
    @IntFlexibleConverter() int? puertas,
  }) = _RuntVehicleGeneralInfo;

  factory RuntVehicleGeneralInfo.fromJson(Map<String, dynamic> json) =>
      _$RuntVehicleGeneralInfoFromJson(json);
}

// ==================== DATOS TÉCNICOS ====================

@freezed
abstract class RuntVehicleTechnicalData with _$RuntVehicleTechnicalData {
  const factory RuntVehicleTechnicalData({
    @JsonKey(name: 'capacidad_de_carga') @IntFlexibleConverter() int? loadCapacityKg,
    @JsonKey(name: 'peso_bruto_vehicular') @IntFlexibleConverter() int? grossWeightKg,
    @JsonKey(name: 'capacidad_de_pasajeros') String? passengersCapacityRaw,
    @JsonKey(name: 'capacidad_pasajeros_sentados') @IntFlexibleConverter() int? seatedPassengers,
    @JsonKey(name: 'n_mero_de_ejes') @IntFlexibleConverter() int? axles,
  }) = _RuntVehicleTechnicalData;

  factory RuntVehicleTechnicalData.fromJson(Map<String, dynamic> json) =>
      _$RuntVehicleTechnicalDataFromJson(json);
}

// ==================== SOAT ====================

@freezed
abstract class RuntSoatRecord with _$RuntSoatRecord {
  const factory RuntSoatRecord({
    // CAMBIO CRÍTICO: El JSON trae int (ej: 94020727), convertimos a String
    @JsonKey(name: 'n_mero_de_p_liza') 
    @StringFlexibleConverter() 
    String? policyNumber,

    @JsonKey(name: 'fecha_expedici_n') String? issueDate,
    @JsonKey(name: 'fecha_inicio_de_vigencia') String? validityStart,
    @JsonKey(name: 'fecha_fin_de_vigencia') String? validityEnd,
    @JsonKey(name: 'entidad_expide_soat') String? insurer,
    @JsonKey(name: 'c_digo_tarifa') @IntFlexibleConverter() int? tariffCode,
    String? estado,
  }) = _RuntSoatRecord;

  factory RuntSoatRecord.fromJson(Map<String, dynamic> json) =>
      _$RuntSoatRecordFromJson(json);
}

// ==================== SEGURO RC ====================

@freezed
abstract class RuntRcInsuranceRecord with _$RuntRcInsuranceRecord {
  const factory RuntRcInsuranceRecord({
    // CAMBIO CRÍTICO: El JSON trae int (ej: 2000674202), convertimos a String
    @JsonKey(name: 'n_mero_de_p_liza') 
    @StringFlexibleConverter() 
    String? policyNumber,

    @JsonKey(name: 'fecha_expedici_n') String? issueDate,
    @JsonKey(name: 'fecha_inicio_de_vigencia') String? validityStart,
    @JsonKey(name: 'fecha_fin_de_vigencia') String? validityEnd,
    @JsonKey(name: 'entidad_que_expide') String? insurer,
    @JsonKey(name: 'tipo_de_p_liza') String? policyType,
    String? estado,
    @JsonKey(name: 'detalle') String? detail,
  }) = _RuntRcInsuranceRecord;

  factory RuntRcInsuranceRecord.fromJson(Map<String, dynamic> json) =>
      _$RuntRcInsuranceRecordFromJson(json);
}

// ==================== RTM ====================

@freezed
abstract class RuntRtmRecord with _$RuntRtmRecord {
  const factory RuntRtmRecord({
    @JsonKey(name: 'tipo_revisi_n') String? revisionType,
    @JsonKey(name: 'fecha_expedici_n') String? issueDate,
    @JsonKey(name: 'fecha_vigencia') String? validityDate,
    @JsonKey(name: 'cda_expide_rtm') String? cda,
    String? vigente,
    @JsonKey(name: 'nro_certificado') @IntFlexibleConverter() int? certificateNumber,
    @JsonKey(name: 'informaci_n_consistente') String? informationConsistent,
    String? acciones,
  }) = _RuntRtmRecord;

  factory RuntRtmRecord.fromJson(Map<String, dynamic> json) =>
      _$RuntRtmRecordFromJson(json);
}

// ==================== LIMITACIONES ====================

@freezed
abstract class RuntOwnershipLimitation with _$RuntOwnershipLimitation {
  const factory RuntOwnershipLimitation({
    @JsonKey(name: 'tipo_de_limitaci_n') String? limitationType,
    @JsonKey(name: 'n_mero_de_oficio') @IntFlexibleConverter() int? officeNumber,
    @JsonKey(name: 'entidad_jur_dica') String? legalEntity,
    @JsonKey(name: 'departamento') String? department,
    @JsonKey(name: 'municipio') String? municipality,
    @JsonKey(name: 'fecha_de_expedici_n_del_oficio') String? officeIssueDate,
    @JsonKey(name: 'fecha_de_registro_en_el_sistema') String? systemRegistrationDate,
  }) = _RuntOwnershipLimitation;

  factory RuntOwnershipLimitation.fromJson(Map<String, dynamic> json) =>
      _$RuntOwnershipLimitationFromJson(json);
}

// ==================== GARANTÍAS ====================

@freezed
abstract class RuntWarranty with _$RuntWarranty {
  const factory RuntWarranty({
    @JsonKey(name: 'identificaci_n_acreedor') String? creditorId,
    @JsonKey(name: 'acreedor') String? creditorName,
    @JsonKey(name: 'fecha_de_inscripci_n') String? registrationDate,
    @JsonKey(name: 'patrimonio_aut_nomo') String? autonomousPatrimony,
    @JsonKey(name: 'confec_maras') String? confecamaras,
  }) = _RuntWarranty;

  factory RuntWarranty.fromJson(Map<String, dynamic> json) =>
      _$RuntWarrantyFromJson(json);
}