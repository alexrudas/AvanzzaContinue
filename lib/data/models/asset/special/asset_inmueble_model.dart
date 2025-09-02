import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/asset/special/asset_inmueble_entity.dart'
    as domain;

part 'asset_inmueble_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class AssetInmuebleModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String assetId;
  @Index()
  final String matriculaInmobiliaria;
  final int? estrato;
  final double? metrosCuadrados;
  @Index()
  final String uso;
  final double? valorCatastral;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AssetInmuebleModel({
    this.isarId,
    required this.assetId,
    required this.matriculaInmobiliaria,
    this.estrato,
    this.metrosCuadrados,
    required this.uso,
    this.valorCatastral,
    this.createdAt,
    this.updatedAt,
  });

  factory AssetInmuebleModel.fromJson(Map<String, dynamic> json) =>
      _$AssetInmuebleModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetInmuebleModelToJson(this);
  factory AssetInmuebleModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      AssetInmuebleModel.fromJson({...json, 'assetId': docId});

  factory AssetInmuebleModel.fromEntity(domain.AssetInmuebleEntity e) =>
      AssetInmuebleModel(
        assetId: e.assetId,
        matriculaInmobiliaria: e.matriculaInmobiliaria,
        estrato: e.estrato,
        metrosCuadrados: e.metrosCuadrados,
        uso: e.uso,
        valorCatastral: e.valorCatastral,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.AssetInmuebleEntity toEntity() => domain.AssetInmuebleEntity(
        assetId: assetId,
        matriculaInmobiliaria: matriculaInmobiliaria,
        estrato: estrato,
        metrosCuadrados: metrosCuadrados,
        uso: uso,
        valorCatastral: valorCatastral,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
