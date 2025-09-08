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
  @Index()
  final String placa;
  final String marca;
  final String modelo;
  final int anio;
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
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
