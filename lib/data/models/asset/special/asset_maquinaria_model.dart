import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/asset/special/asset_maquinaria_entity.dart'
    as domain;

part 'asset_maquinaria_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class AssetMaquinariaModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String assetId;
  @Index()
  final String serie;
  final String marca;
  final String capacidad;
  @Index()
  final String categoria;
  final String? certificadoOperacion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AssetMaquinariaModel({
    this.isarId,
    required this.assetId,
    required this.serie,
    required this.marca,
    required this.capacidad,
    required this.categoria,
    this.certificadoOperacion,
    this.createdAt,
    this.updatedAt,
  });

  factory AssetMaquinariaModel.fromJson(Map<String, dynamic> json) =>
      _$AssetMaquinariaModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetMaquinariaModelToJson(this);
  factory AssetMaquinariaModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      AssetMaquinariaModel.fromJson({...json, 'assetId': docId});

  factory AssetMaquinariaModel.fromEntity(domain.AssetMaquinariaEntity e) =>
      AssetMaquinariaModel(
        assetId: e.assetId,
        serie: e.serie,
        marca: e.marca,
        capacidad: e.capacidad,
        categoria: e.categoria,
        certificadoOperacion: e.certificadoOperacion,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.AssetMaquinariaEntity toEntity() => domain.AssetMaquinariaEntity(
        assetId: assetId,
        serie: serie,
        marca: marca,
        capacidad: capacidad,
        categoria: categoria,
        certificadoOperacion: certificadoOperacion,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
