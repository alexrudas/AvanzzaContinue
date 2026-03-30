// ============================================================================
// lib/data/models/asset/special/asset_vehiculo_model.dart
// ASSET VEHICULO MODEL — Enterprise Ultra Pro (Data / Models)
//
// QUÉ HACE:
// - Modelo Isar + JSON para datos específicos de vehículos.
// - placa tiene @Index(unique:true) SIN replace → el motor Isar rechaza
//   duplicados con IsarError; el repositorio lo mapea a duplicatePlate().
// - assetId tiene @Index(unique:true, replace:true) → idempotente en upsert.
//
// QUÉ NO HACE:
// - No contiene lógica de negocio.
// - No expone detalles técnicos a capas superiores.
//
// NOTAS:
// - isar_community 3.x no soporta caseSensitive en @Index.
//   La normalización a uppercase se realiza ANTES de persistir (repositorio).
// - Requiere re-generar código: dart run build_runner build --delete-conflicting-outputs
// ============================================================================

import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/asset/special/asset_vehiculo_entity.dart'
    as domain;

part 'asset_vehiculo_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class AssetVehiculoModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String assetId;
  @Index()
  final String refCode;
  @Index(unique: true)
  final String placa;
  final String marca;
  final String modelo;
  final int anio;

  // ── Campos enriquecidos desde RUNT (nullable — backward compatible) ──────
  // Null para activos registrados antes de la Fase RUNT Grid (2026-03).
  final String? color;
  final double? engineDisplacement;
  final String? vin;
  final String? engineNumber;
  final String? chassisNumber;
  final String? line;
  final String? serviceType;
  final String? vehicleClass;
  final String? bodyType;
  final String? fuelType;
  final int? passengerCapacity;
  final double? loadCapacityKg;
  final double? grossWeightKg;
  final int? axles;
  final String? transitAuthority;
  final String? initialRegistrationDate;
  final String? propertyLiens;

  // ── Propietario registrado en RUNT ───────────────────────────────────────
  // Null para activos registrados antes de la Fase Propietario (2026-03).
  final String? ownerDocumentType;
  final String? ownerDocument;

  /// JSON serializado de snapshots RTM, limitaciones y garantías.
  /// Formato: {'runt_rtm': [...], 'runt_limitations': [...], 'runt_warranties': [...]}
  final String? runtMetaJson;

  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  AssetVehiculoModel({
    this.isarId,
    required this.assetId,
    required this.refCode,
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.anio,
    this.color,
    this.engineDisplacement,
    this.vin,
    this.engineNumber,
    this.chassisNumber,
    this.line,
    this.serviceType,
    this.vehicleClass,
    this.bodyType,
    this.fuelType,
    this.passengerCapacity,
    this.loadCapacityKg,
    this.grossWeightKg,
    this.axles,
    this.transitAuthority,
    this.initialRegistrationDate,
    this.propertyLiens,
    this.ownerDocumentType,
    this.ownerDocument,
    this.runtMetaJson,
    this.createdAt,
    this.updatedAt,
  });

  factory AssetVehiculoModel.fromJson(Map<String, dynamic> json) =>
      _$AssetVehiculoModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetVehiculoModelToJson(this);
  factory AssetVehiculoModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      AssetVehiculoModel.fromJson({...json, 'assetId': docId});

  factory AssetVehiculoModel.fromEntity(domain.AssetVehiculoEntity e) =>
      AssetVehiculoModel(
        assetId: e.assetId,
        refCode: e.refCode,
        placa: e.placa,
        marca: e.marca,
        modelo: e.modelo,
        anio: e.anio,
        color: e.color,
        engineDisplacement: e.engineDisplacement,
        vin: e.vin,
        engineNumber: e.engineNumber,
        chassisNumber: e.chassisNumber,
        line: e.line,
        serviceType: e.serviceType,
        vehicleClass: e.vehicleClass,
        bodyType: e.bodyType,
        fuelType: e.fuelType,
        passengerCapacity: e.passengerCapacity,
        loadCapacityKg: e.loadCapacityKg,
        grossWeightKg: e.grossWeightKg,
        axles: e.axles,
        transitAuthority: e.transitAuthority,
        initialRegistrationDate: e.initialRegistrationDate,
        propertyLiens: e.propertyLiens,
        ownerDocumentType: e.ownerDocumentType,
        ownerDocument: e.ownerDocument,
        runtMetaJson: e.runtMetaJson,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.AssetVehiculoEntity toEntity() => domain.AssetVehiculoEntity(
        assetId: assetId,
        refCode: refCode,
        placa: placa,
        marca: marca,
        modelo: modelo,
        anio: anio,
        color: color,
        engineDisplacement: engineDisplacement,
        vin: vin,
        engineNumber: engineNumber,
        chassisNumber: chassisNumber,
        line: line,
        serviceType: serviceType,
        vehicleClass: vehicleClass,
        bodyType: bodyType,
        fuelType: fuelType,
        passengerCapacity: passengerCapacity,
        loadCapacityKg: loadCapacityKg,
        grossWeightKg: grossWeightKg,
        axles: axles,
        transitAuthority: transitAuthority,
        initialRegistrationDate: initialRegistrationDate,
        propertyLiens: propertyLiens,
        ownerDocumentType: ownerDocumentType,
        ownerDocument: ownerDocument,
        runtMetaJson: runtMetaJson,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
