// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runt_vehicle_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RuntVehicleResponse _$RuntVehicleResponseFromJson(Map<String, dynamic> json) =>
    _RuntVehicleResponse(
      ok: json['ok'] as bool,
      source: json['source'] as String,
      data: RuntVehicleData.fromJson(json['data'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : RuntVehicleMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RuntVehicleResponseToJson(
        _RuntVehicleResponse instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'source': instance.source,
      'data': instance.data,
      'meta': instance.meta,
    };

_RuntVehicleMeta _$RuntVehicleMetaFromJson(Map<String, dynamic> json) =>
    _RuntVehicleMeta(
      fetchedAt: json['fetchedAt'] == null
          ? null
          : DateTime.parse(json['fetchedAt'] as String),
      strategy: json['strategy'] as String?,
      headless: json['headless'] as bool?,
      requestId: json['requestId'] as String?,
      durationMs: (json['durationMs'] as num?)?.toInt(),
      apiUrl: json['apiUrl'] as String?,
      schemaVersion: json['schemaVersion'] as String?,
    );

Map<String, dynamic> _$RuntVehicleMetaToJson(_RuntVehicleMeta instance) =>
    <String, dynamic>{
      'fetchedAt': instance.fetchedAt?.toIso8601String(),
      'strategy': instance.strategy,
      'headless': instance.headless,
      'requestId': instance.requestId,
      'durationMs': instance.durationMs,
      'apiUrl': instance.apiUrl,
      'schemaVersion': instance.schemaVersion,
    };

_RuntVehicleData _$RuntVehicleDataFromJson(Map<String, dynamic> json) =>
    _RuntVehicleData(
      basicInfo: RuntVehicleBasicInfo.fromJson(
          json['informacion_basica'] as Map<String, dynamic>),
      generalInfo: json['informacion_general'] == null
          ? null
          : RuntVehicleGeneralInfo.fromJson(
              json['informacion_general'] as Map<String, dynamic>),
      technicalData: json['datos_tecnicos'] == null
          ? null
          : RuntVehicleTechnicalData.fromJson(
              json['datos_tecnicos'] as Map<String, dynamic>),
      soat: (json['soat'] as List<dynamic>?)
              ?.map((e) => RuntSoatRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rcInsurances: (json['seguros_rc'] as List<dynamic>?)
              ?.map((e) =>
                  RuntRcInsuranceRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rtmHistory: (json['revision_tecnica'] as List<dynamic>?)
              ?.map((e) => RuntRtmRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ownershipLimitations: (json['limitaciones_propiedad'] as List<dynamic>?)
              ?.map((e) =>
                  RuntOwnershipLimitation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      warranties: (json['garantias'] as List<dynamic>?)
              ?.map((e) => RuntWarranty.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RuntVehicleDataToJson(_RuntVehicleData instance) =>
    <String, dynamic>{
      'informacion_basica': instance.basicInfo,
      'informacion_general': instance.generalInfo,
      'datos_tecnicos': instance.technicalData,
      'soat': instance.soat,
      'seguros_rc': instance.rcInsurances,
      'revision_tecnica': instance.rtmHistory,
      'limitaciones_propiedad': instance.ownershipLimitations,
      'garantias': instance.warranties,
    };

_RuntVehicleBasicInfo _$RuntVehicleBasicInfoFromJson(
        Map<String, dynamic> json) =>
    _RuntVehicleBasicInfo(
      plate: json['placa_del_veh_culo'] as String,
      vehicleStatus: json['estado_del_veh_culo'] as String,
      serviceType: json['tipo_de_servicio'] as String,
      vehicleClass: json['clase_de_veh_culo'] as String,
      transitLicenseNumber: const StringFlexibleConverter()
          .fromJson(json['nro_de_licencia_de_tr_nsito']),
    );

Map<String, dynamic> _$RuntVehicleBasicInfoToJson(
        _RuntVehicleBasicInfo instance) =>
    <String, dynamic>{
      'placa_del_veh_culo': instance.plate,
      'estado_del_veh_culo': instance.vehicleStatus,
      'tipo_de_servicio': instance.serviceType,
      'clase_de_veh_culo': instance.vehicleClass,
      'nro_de_licencia_de_tr_nsito':
          const StringFlexibleConverter().toJson(instance.transitLicenseNumber),
    };

_RuntVehicleGeneralInfo _$RuntVehicleGeneralInfoFromJson(
        Map<String, dynamic> json) =>
    _RuntVehicleGeneralInfo(
      marca: json['marca'] as String?,
      line: json['l_nea'] as String?,
      modelo: const IntFlexibleConverter().fromJson(json['modelo']),
      color: json['color'] as String?,
      serialNumber: json['n_mero_de_serie'] as String?,
      engineNumber: json['n_mero_de_motor'] as String?,
      chassisNumber: json['n_mero_de_chasis'] as String?,
      vin: json['n_mero_de_vin'] as String?,
      cilindraje: const IntFlexibleConverter().fromJson(json['cilindraje']),
      bodyType: json['tipo_de_carrocer_a'] as String?,
      fuelType: json['tipo_combustible'] as String?,
      initialRegistrationDate:
          json['fecha_de_matricula_inicial_dd_mm_aaaa'] as String?,
      transitAuthority: json['autoridad_de_tr_nsito'] as String?,
      propertyLiens: json['grav_menes_a_la_propiedad'] as String?,
      isClassicOrAntique: json['cl_sico_o_antiguo'] as String?,
      repotenciado: json['repotenciado'] as String?,
      engineReengraving: json['regrabaci_n_motor_si_no'] as String?,
      engineReengravingNumber: json['nro_regrabaci_n_motor'] as String?,
      chassisReengraving: json['regrabaci_n_chasis_si_no'] as String?,
      chassisReengravingNumber: json['nro_regrabaci_n_chasis'] as String?,
      seriesReengraving: json['regrabaci_n_serie_si_no'] as String?,
      seriesReengravingNumber: json['nro_regrabaci_n_serie'] as String?,
      vinReengraving: json['regrabaci_n_vin_si_no'] as String?,
      vinReengravingNumber: json['nro_regrabaci_n_vin'] as String?,
      isTeachingVehicle: json['veh_culo_ense_anza_si_no'] as String?,
      puertas: const IntFlexibleConverter().fromJson(json['puertas']),
    );

Map<String, dynamic> _$RuntVehicleGeneralInfoToJson(
        _RuntVehicleGeneralInfo instance) =>
    <String, dynamic>{
      'marca': instance.marca,
      'l_nea': instance.line,
      'modelo': const IntFlexibleConverter().toJson(instance.modelo),
      'color': instance.color,
      'n_mero_de_serie': instance.serialNumber,
      'n_mero_de_motor': instance.engineNumber,
      'n_mero_de_chasis': instance.chassisNumber,
      'n_mero_de_vin': instance.vin,
      'cilindraje': const IntFlexibleConverter().toJson(instance.cilindraje),
      'tipo_de_carrocer_a': instance.bodyType,
      'tipo_combustible': instance.fuelType,
      'fecha_de_matricula_inicial_dd_mm_aaaa': instance.initialRegistrationDate,
      'autoridad_de_tr_nsito': instance.transitAuthority,
      'grav_menes_a_la_propiedad': instance.propertyLiens,
      'cl_sico_o_antiguo': instance.isClassicOrAntique,
      'repotenciado': instance.repotenciado,
      'regrabaci_n_motor_si_no': instance.engineReengraving,
      'nro_regrabaci_n_motor': instance.engineReengravingNumber,
      'regrabaci_n_chasis_si_no': instance.chassisReengraving,
      'nro_regrabaci_n_chasis': instance.chassisReengravingNumber,
      'regrabaci_n_serie_si_no': instance.seriesReengraving,
      'nro_regrabaci_n_serie': instance.seriesReengravingNumber,
      'regrabaci_n_vin_si_no': instance.vinReengraving,
      'nro_regrabaci_n_vin': instance.vinReengravingNumber,
      'veh_culo_ense_anza_si_no': instance.isTeachingVehicle,
      'puertas': const IntFlexibleConverter().toJson(instance.puertas),
    };

_RuntVehicleTechnicalData _$RuntVehicleTechnicalDataFromJson(
        Map<String, dynamic> json) =>
    _RuntVehicleTechnicalData(
      loadCapacityKg:
          const IntFlexibleConverter().fromJson(json['capacidad_de_carga']),
      grossWeightKg:
          const IntFlexibleConverter().fromJson(json['peso_bruto_vehicular']),
      passengersCapacityRaw: json['capacidad_de_pasajeros'] as String?,
      seatedPassengers: const IntFlexibleConverter()
          .fromJson(json['capacidad_pasajeros_sentados']),
      axles: const IntFlexibleConverter().fromJson(json['n_mero_de_ejes']),
    );

Map<String, dynamic> _$RuntVehicleTechnicalDataToJson(
        _RuntVehicleTechnicalData instance) =>
    <String, dynamic>{
      'capacidad_de_carga':
          const IntFlexibleConverter().toJson(instance.loadCapacityKg),
      'peso_bruto_vehicular':
          const IntFlexibleConverter().toJson(instance.grossWeightKg),
      'capacidad_de_pasajeros': instance.passengersCapacityRaw,
      'capacidad_pasajeros_sentados':
          const IntFlexibleConverter().toJson(instance.seatedPassengers),
      'n_mero_de_ejes': const IntFlexibleConverter().toJson(instance.axles),
    };

_RuntSoatRecord _$RuntSoatRecordFromJson(Map<String, dynamic> json) =>
    _RuntSoatRecord(
      policyNumber:
          const StringFlexibleConverter().fromJson(json['n_mero_de_p_liza']),
      issueDate: json['fecha_expedici_n'] as String?,
      validityStart: json['fecha_inicio_de_vigencia'] as String?,
      validityEnd: json['fecha_fin_de_vigencia'] as String?,
      insurer: json['entidad_expide_soat'] as String?,
      tariffCode: const IntFlexibleConverter().fromJson(json['c_digo_tarifa']),
      estado: json['estado'] as String?,
    );

Map<String, dynamic> _$RuntSoatRecordToJson(_RuntSoatRecord instance) =>
    <String, dynamic>{
      'n_mero_de_p_liza':
          const StringFlexibleConverter().toJson(instance.policyNumber),
      'fecha_expedici_n': instance.issueDate,
      'fecha_inicio_de_vigencia': instance.validityStart,
      'fecha_fin_de_vigencia': instance.validityEnd,
      'entidad_expide_soat': instance.insurer,
      'c_digo_tarifa': const IntFlexibleConverter().toJson(instance.tariffCode),
      'estado': instance.estado,
    };

_RuntRcInsuranceRecord _$RuntRcInsuranceRecordFromJson(
        Map<String, dynamic> json) =>
    _RuntRcInsuranceRecord(
      policyNumber:
          const StringFlexibleConverter().fromJson(json['n_mero_de_p_liza']),
      issueDate: json['fecha_expedici_n'] as String?,
      validityStart: json['fecha_inicio_de_vigencia'] as String?,
      validityEnd: json['fecha_fin_de_vigencia'] as String?,
      insurer: json['entidad_que_expide'] as String?,
      policyType: json['tipo_de_p_liza'] as String?,
      estado: json['estado'] as String?,
      detail: json['detalle'] as String?,
    );

Map<String, dynamic> _$RuntRcInsuranceRecordToJson(
        _RuntRcInsuranceRecord instance) =>
    <String, dynamic>{
      'n_mero_de_p_liza':
          const StringFlexibleConverter().toJson(instance.policyNumber),
      'fecha_expedici_n': instance.issueDate,
      'fecha_inicio_de_vigencia': instance.validityStart,
      'fecha_fin_de_vigencia': instance.validityEnd,
      'entidad_que_expide': instance.insurer,
      'tipo_de_p_liza': instance.policyType,
      'estado': instance.estado,
      'detalle': instance.detail,
    };

_RuntRtmRecord _$RuntRtmRecordFromJson(Map<String, dynamic> json) =>
    _RuntRtmRecord(
      revisionType: json['tipo_revisi_n'] as String?,
      issueDate: json['fecha_expedici_n'] as String?,
      validityDate: json['fecha_vigencia'] as String?,
      cda: json['cda_expide_rtm'] as String?,
      vigente: json['vigente'] as String?,
      certificateNumber:
          const IntFlexibleConverter().fromJson(json['nro_certificado']),
      informationConsistent: json['informaci_n_consistente'] as String?,
      acciones: json['acciones'] as String?,
    );

Map<String, dynamic> _$RuntRtmRecordToJson(_RuntRtmRecord instance) =>
    <String, dynamic>{
      'tipo_revisi_n': instance.revisionType,
      'fecha_expedici_n': instance.issueDate,
      'fecha_vigencia': instance.validityDate,
      'cda_expide_rtm': instance.cda,
      'vigente': instance.vigente,
      'nro_certificado':
          const IntFlexibleConverter().toJson(instance.certificateNumber),
      'informaci_n_consistente': instance.informationConsistent,
      'acciones': instance.acciones,
    };

_RuntOwnershipLimitation _$RuntOwnershipLimitationFromJson(
        Map<String, dynamic> json) =>
    _RuntOwnershipLimitation(
      limitationType: json['tipo_de_limitaci_n'] as String?,
      officeNumber:
          const IntFlexibleConverter().fromJson(json['n_mero_de_oficio']),
      legalEntity: json['entidad_jur_dica'] as String?,
      department: json['departamento'] as String?,
      municipality: json['municipio'] as String?,
      officeIssueDate: json['fecha_de_expedici_n_del_oficio'] as String?,
      systemRegistrationDate:
          json['fecha_de_registro_en_el_sistema'] as String?,
    );

Map<String, dynamic> _$RuntOwnershipLimitationToJson(
        _RuntOwnershipLimitation instance) =>
    <String, dynamic>{
      'tipo_de_limitaci_n': instance.limitationType,
      'n_mero_de_oficio':
          const IntFlexibleConverter().toJson(instance.officeNumber),
      'entidad_jur_dica': instance.legalEntity,
      'departamento': instance.department,
      'municipio': instance.municipality,
      'fecha_de_expedici_n_del_oficio': instance.officeIssueDate,
      'fecha_de_registro_en_el_sistema': instance.systemRegistrationDate,
    };

_RuntWarranty _$RuntWarrantyFromJson(Map<String, dynamic> json) =>
    _RuntWarranty(
      creditorId: json['identificaci_n_acreedor'] as String?,
      creditorName: json['acreedor'] as String?,
      registrationDate: json['fecha_de_inscripci_n'] as String?,
      autonomousPatrimony: json['patrimonio_aut_nomo'] as String?,
      confecamaras: json['confec_maras'] as String?,
    );

Map<String, dynamic> _$RuntWarrantyToJson(_RuntWarranty instance) =>
    <String, dynamic>{
      'identificaci_n_acreedor': instance.creditorId,
      'acreedor': instance.creditorName,
      'fecha_de_inscripci_n': instance.registrationDate,
      'patrimonio_aut_nomo': instance.autonomousPatrimony,
      'confec_maras': instance.confecamaras,
    };
