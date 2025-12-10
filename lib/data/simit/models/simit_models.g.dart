// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simit_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SimitResponse _$SimitResponseFromJson(Map<String, dynamic> json) =>
    _SimitResponse(
      ok: json['ok'] as bool,
      source: json['source'] as String,
      data: SimitData.fromJson(json['data'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : SimitMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SimitResponseToJson(_SimitResponse instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'source': instance.source,
      'data': instance.data,
      'meta': instance.meta,
    };

_SimitMeta _$SimitMetaFromJson(Map<String, dynamic> json) => _SimitMeta(
      fetchedAt: json['fetchedAt'] == null
          ? null
          : DateTime.parse(json['fetchedAt'] as String),
      strategy: json['strategy'] as String?,
      headless: json['headless'] as bool?,
      requestId: json['requestId'] as String?,
      durationMs: (json['durationMs'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SimitMetaToJson(_SimitMeta instance) =>
    <String, dynamic>{
      'fetchedAt': instance.fetchedAt?.toIso8601String(),
      'strategy': instance.strategy,
      'headless': instance.headless,
      'requestId': instance.requestId,
      'durationMs': instance.durationMs,
    };

_SimitData _$SimitDataFromJson(Map<String, dynamic> json) => _SimitData(
      hasFines: json['tieneMultas'] as bool,
      total: json['total'] as num,
      summary: SimitSummary.fromJson(json['resumen'] as Map<String, dynamic>),
      fines: (json['multas'] as List<dynamic>?)
              ?.map((e) => SimitFine.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SimitDataToJson(_SimitData instance) =>
    <String, dynamic>{
      'tieneMultas': instance.hasFines,
      'total': instance.total,
      'resumen': instance.summary,
      'multas': instance.fines,
    };

_SimitSummary _$SimitSummaryFromJson(Map<String, dynamic> json) =>
    _SimitSummary(
      comparendos: (json['comparendos'] as num).toInt(),
      multas: const MultasCountConverter().fromJson(json['multas']),
      paymentAgreementsCount: (json['acuerdosDePago'] as num).toInt(),
      formattedTotal: json['totalFormateado'] as String?,
      maskedName: json['nombre'] as String?,
      document: json['cedula'] as String,
    );

Map<String, dynamic> _$SimitSummaryToJson(_SimitSummary instance) =>
    <String, dynamic>{
      'comparendos': instance.comparendos,
      'multas': const MultasCountConverter().toJson(instance.multas),
      'acuerdosDePago': instance.paymentAgreementsCount,
      'totalFormateado': instance.formattedTotal,
      'nombre': instance.maskedName,
      'cedula': instance.document,
    };

_SimitFine _$SimitFineFromJson(Map<String, dynamic> json) => _SimitFine(
      id: json['id'] as String,
      fecha: json['fecha'] as String?,
      ciudad: json['ciudad'] as String?,
      valor: (json['valor'] as num?)?.toInt(),
      amountToPay: json['valorAPagar'] as num,
      estado: json['estado'] as String,
      placa: json['placa'] as String,
      infractionCodeShort: json['infraccion'] as String?,
      detalle: json['detalle'] == null
          ? null
          : SimitFineDetail.fromJson(json['detalle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SimitFineToJson(_SimitFine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fecha': instance.fecha,
      'ciudad': instance.ciudad,
      'valor': instance.valor,
      'valorAPagar': instance.amountToPay,
      'estado': instance.estado,
      'placa': instance.placa,
      'infraccion': instance.infractionCodeShort,
      'detalle': instance.detalle,
    };

_SimitFineDetail _$SimitFineDetailFromJson(Map<String, dynamic> json) =>
    _SimitFineDetail(
      ticketInfo: json['informacion_comparendo'] == null
          ? null
          : SimitTicketInfo.fromJson(
              json['informacion_comparendo'] as Map<String, dynamic>),
      infraction: json['infraccion'] == null
          ? null
          : SimitInfractionInfo.fromJson(
              json['infraccion'] as Map<String, dynamic>),
      driver: json['datos_conductor'] == null
          ? null
          : SimitDriverInfo.fromJson(
              json['datos_conductor'] as Map<String, dynamic>),
      vehicle: json['informacion_vehiculo'] == null
          ? null
          : SimitVehicleInfo.fromJson(
              json['informacion_vehiculo'] as Map<String, dynamic>),
      service: json['servicio'] == null
          ? null
          : SimitServiceInfo.fromJson(json['servicio'] as Map<String, dynamic>),
      extraInfo: json['informacion_adicional'] == null
          ? null
          : SimitExtraInfo.fromJson(
              json['informacion_adicional'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SimitFineDetailToJson(_SimitFineDetail instance) =>
    <String, dynamic>{
      'informacion_comparendo': instance.ticketInfo,
      'infraccion': instance.infraction,
      'datos_conductor': instance.driver,
      'informacion_vehiculo': instance.vehicle,
      'servicio': instance.service,
      'informacion_adicional': instance.extraInfo,
    };

_SimitTicketInfo _$SimitTicketInfoFromJson(Map<String, dynamic> json) =>
    _SimitTicketInfo(
      ticketNumber: json['No. comparendo'] as String?,
      date: json['Fecha'] as String?,
      time: json['Hora'] as String?,
      address: json['Dirección'] as String?,
      isElectronic: json['Comparendo electrónico'] as String?,
      source: json['Fuente comparendo'] as String?,
      secretary: json['Secretaría'] as String?,
      agent: json['Agente'] as String?,
    );

Map<String, dynamic> _$SimitTicketInfoToJson(_SimitTicketInfo instance) =>
    <String, dynamic>{
      'No. comparendo': instance.ticketNumber,
      'Fecha': instance.date,
      'Hora': instance.time,
      'Dirección': instance.address,
      'Comparendo electrónico': instance.isElectronic,
      'Fuente comparendo': instance.source,
      'Secretaría': instance.secretary,
      'Agente': instance.agent,
    };

_SimitInfractionInfo _$SimitInfractionInfoFromJson(Map<String, dynamic> json) =>
    _SimitInfractionInfo(
      code: json['Código'] as String?,
      description: json['Descripción'] as String?,
    );

Map<String, dynamic> _$SimitInfractionInfoToJson(
        _SimitInfractionInfo instance) =>
    <String, dynamic>{
      'Código': instance.code,
      'Descripción': instance.description,
    };

_SimitDriverInfo _$SimitDriverInfoFromJson(Map<String, dynamic> json) =>
    _SimitDriverInfo(
      documentType: json['Tipo documento'] as String?,
      documentNumber: json['Número documento'] as String?,
      firstNames: json['Nombres'] as String?,
      lastNames: json['Apellidos'] as String?,
      infractorType: json['Tipo de infractor'] as String?,
    );

Map<String, dynamic> _$SimitDriverInfoToJson(_SimitDriverInfo instance) =>
    <String, dynamic>{
      'Tipo documento': instance.documentType,
      'Número documento': instance.documentNumber,
      'Nombres': instance.firstNames,
      'Apellidos': instance.lastNames,
      'Tipo de infractor': instance.infractorType,
    };

_SimitVehicleInfo _$SimitVehicleInfoFromJson(Map<String, dynamic> json) =>
    _SimitVehicleInfo(
      plate: json['Placa'] as String?,
      vehicleLicenseNumber: json['No. Licencia del vehículo'] as String?,
      type: json['Tipo'] as String?,
      service: json['Servicio'] as String?,
      immobilized: json['Inmovilización'] as String?,
    );

Map<String, dynamic> _$SimitVehicleInfoToJson(_SimitVehicleInfo instance) =>
    <String, dynamic>{
      'Placa': instance.plate,
      'No. Licencia del vehículo': instance.vehicleLicenseNumber,
      'Tipo': instance.type,
      'Servicio': instance.service,
      'Inmovilización': instance.immobilized,
    };

_SimitServiceInfo _$SimitServiceInfoFromJson(Map<String, dynamic> json) =>
    _SimitServiceInfo(
      licenseNumber: json['No. Licencia'] as String?,
      expiryDate: json['Fecha vencimiento'] as String?,
      category: json['Categoría'] as String?,
      secretary: json['Secretaría'] as String?,
    );

Map<String, dynamic> _$SimitServiceInfoToJson(_SimitServiceInfo instance) =>
    <String, dynamic>{
      'No. Licencia': instance.licenseNumber,
      'Fecha vencimiento': instance.expiryDate,
      'Categoría': instance.category,
      'Secretaría': instance.secretary,
    };

_SimitExtraInfo _$SimitExtraInfoFromJson(Map<String, dynamic> json) =>
    _SimitExtraInfo(
      ticketMunicipality: json['Municipio comparendo'] as String?,
      locality: json['Localidad comuna'] as String?,
      plateMunicipality: json['Municipio matrícula'] as String?,
      operationRadius: json['Radio acción'] as String?,
      transportMode: json['Modalidad transporte'] as String?,
      passengers: json['Pasajeros'] as String?,
      infractorAge: json['Edad infractor'] as String?,
    );

Map<String, dynamic> _$SimitExtraInfoToJson(_SimitExtraInfo instance) =>
    <String, dynamic>{
      'Municipio comparendo': instance.ticketMunicipality,
      'Localidad comuna': instance.locality,
      'Municipio matrícula': instance.plateMunicipality,
      'Radio acción': instance.operationRadius,
      'Modalidad transporte': instance.transportMode,
      'Pasajeros': instance.passengers,
      'Edad infractor': instance.infractorAge,
    };
