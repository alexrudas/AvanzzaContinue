// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runt_person_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RuntPersonResponse _$RuntPersonResponseFromJson(Map<String, dynamic> json) =>
    _RuntPersonResponse(
      ok: json['ok'] as bool,
      source: json['source'] as String,
      data: RuntPersonData.fromJson(json['data'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : RuntPersonMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RuntPersonResponseToJson(_RuntPersonResponse instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'source': instance.source,
      'data': instance.data,
      'meta': instance.meta,
    };

_RuntPersonMeta _$RuntPersonMetaFromJson(Map<String, dynamic> json) =>
    _RuntPersonMeta(
      fetchedAt: json['fetchedAt'] == null
          ? null
          : DateTime.parse(json['fetchedAt'] as String),
      strategy: json['strategy'] as String?,
      headless: json['headless'] as bool?,
      requestId: json['requestId'] as String?,
      durationMs: (json['durationMs'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RuntPersonMetaToJson(_RuntPersonMeta instance) =>
    <String, dynamic>{
      'fetchedAt': instance.fetchedAt?.toIso8601String(),
      'strategy': instance.strategy,
      'headless': instance.headless,
      'requestId': instance.requestId,
      'durationMs': instance.durationMs,
    };

_RuntPersonData _$RuntPersonDataFromJson(Map<String, dynamic> json) =>
    _RuntPersonData(
      fullName: json['nombre_completo'] as String,
      documentNumber: json['numero_documento'] as String,
      documentType: json['tipo_documento'] as String?,
      personStatus: json['estado_persona'] as String?,
      driverStatus: json['estado_conductor'] as String?,
      runtRegistrationNumber: json['numero_inscripcion_runt'] as String?,
      registrationDate: json['fecha_inscripcion'] as String?,
      licencias: (json['licencias'] as List<dynamic>?)
              ?.map((e) => RuntLicense.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      internalMetadata: json['_metadata'] == null
          ? null
          : RuntPersonInternalMetadata.fromJson(
              json['_metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RuntPersonDataToJson(_RuntPersonData instance) =>
    <String, dynamic>{
      'nombre_completo': instance.fullName,
      'numero_documento': instance.documentNumber,
      'tipo_documento': instance.documentType,
      'estado_persona': instance.personStatus,
      'estado_conductor': instance.driverStatus,
      'numero_inscripcion_runt': instance.runtRegistrationNumber,
      'fecha_inscripcion': instance.registrationDate,
      'licencias': instance.licencias,
      '_metadata': instance.internalMetadata,
    };

_RuntPersonInternalMetadata _$RuntPersonInternalMetadataFromJson(
        Map<String, dynamic> json) =>
    _RuntPersonInternalMetadata(
      totalLicenses: (json['total_licencias'] as num?)?.toInt(),
      queryDate: json['fecha_consulta'] == null
          ? null
          : DateTime.parse(json['fecha_consulta'] as String),
    );

Map<String, dynamic> _$RuntPersonInternalMetadataToJson(
        _RuntPersonInternalMetadata instance) =>
    <String, dynamic>{
      'total_licencias': instance.totalLicenses,
      'fecha_consulta': instance.queryDate?.toIso8601String(),
    };

_RuntLicense _$RuntLicenseFromJson(Map<String, dynamic> json) => _RuntLicense(
      licenseNumber: json['numero_licencia'] as String?,
      issuingAuthority: json['ot_expide'] as String?,
      issueDate: json['fecha_expedicion'] as String?,
      estado: json['estado'] as String?,
      restricciones: json['restricciones'] as String?,
      retention: json['retencion'] as String?,
      cancelingAuthority: json['ot_cancela_suspende'] as String?,
      detalles: (json['detalles'] as List<dynamic>?)
              ?.map(
                  (e) => RuntLicenseDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RuntLicenseToJson(_RuntLicense instance) =>
    <String, dynamic>{
      'numero_licencia': instance.licenseNumber,
      'ot_expide': instance.issuingAuthority,
      'fecha_expedicion': instance.issueDate,
      'estado': instance.estado,
      'restricciones': instance.restricciones,
      'retencion': instance.retention,
      'ot_cancela_suspende': instance.cancelingAuthority,
      'detalles': instance.detalles,
    };

_RuntLicenseDetail _$RuntLicenseDetailFromJson(Map<String, dynamic> json) =>
    _RuntLicenseDetail(
      category: json['categoria'] as String?,
      issueDate: json['fecha_expedicion'] as String?,
      expiryDate: json['fecha_vencimiento'] as String?,
      previousCategory: json['categoria_antigua'] as String?,
    );

Map<String, dynamic> _$RuntLicenseDetailToJson(_RuntLicenseDetail instance) =>
    <String, dynamic>{
      'categoria': instance.category,
      'fecha_expedicion': instance.issueDate,
      'fecha_vencimiento': instance.expiryDate,
      'categoria_antigua': instance.previousCategory,
    };
