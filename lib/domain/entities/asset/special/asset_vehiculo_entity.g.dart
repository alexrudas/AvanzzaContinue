// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_vehiculo_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetVehiculoEntity _$AssetVehiculoEntityFromJson(Map<String, dynamic> json) =>
    _AssetVehiculoEntity(
      assetId: json['assetId'] as String,
      refCode: json['refCode'] as String,
      placa: json['placa'] as String,
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      anio: (json['anio'] as num).toInt(),
      color: json['color'] as String?,
      engineDisplacement: (json['engineDisplacement'] as num?)?.toDouble(),
      vin: json['vin'] as String?,
      engineNumber: json['engineNumber'] as String?,
      chassisNumber: json['chassisNumber'] as String?,
      line: json['line'] as String?,
      serviceType: json['serviceType'] as String?,
      vehicleClass: json['vehicleClass'] as String?,
      bodyType: json['bodyType'] as String?,
      fuelType: json['fuelType'] as String?,
      passengerCapacity: (json['passengerCapacity'] as num?)?.toInt(),
      loadCapacityKg: (json['loadCapacityKg'] as num?)?.toDouble(),
      grossWeightKg: (json['grossWeightKg'] as num?)?.toDouble(),
      axles: (json['axles'] as num?)?.toInt(),
      transitAuthority: json['transitAuthority'] as String?,
      initialRegistrationDate: json['initialRegistrationDate'] as String?,
      propertyLiens: json['propertyLiens'] as String?,
      ownerName: json['ownerName'] as String?,
      ownerDocumentType: json['ownerDocumentType'] as String?,
      ownerDocument: json['ownerDocument'] as String?,
      runtMetaJson: json['runtMetaJson'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssetVehiculoEntityToJson(
        _AssetVehiculoEntity instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'refCode': instance.refCode,
      'placa': instance.placa,
      'marca': instance.marca,
      'modelo': instance.modelo,
      'anio': instance.anio,
      'color': instance.color,
      'engineDisplacement': instance.engineDisplacement,
      'vin': instance.vin,
      'engineNumber': instance.engineNumber,
      'chassisNumber': instance.chassisNumber,
      'line': instance.line,
      'serviceType': instance.serviceType,
      'vehicleClass': instance.vehicleClass,
      'bodyType': instance.bodyType,
      'fuelType': instance.fuelType,
      'passengerCapacity': instance.passengerCapacity,
      'loadCapacityKg': instance.loadCapacityKg,
      'grossWeightKg': instance.grossWeightKg,
      'axles': instance.axles,
      'transitAuthority': instance.transitAuthority,
      'initialRegistrationDate': instance.initialRegistrationDate,
      'propertyLiens': instance.propertyLiens,
      'ownerName': instance.ownerName,
      'ownerDocumentType': instance.ownerDocumentType,
      'ownerDocument': instance.ownerDocument,
      'runtMetaJson': instance.runtMetaJson,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
