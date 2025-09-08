import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/asset/asset_entity.dart' as domain;

part 'asset_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class AssetModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String orgId;
  @Index()
  final String assetType;
  @Index()
  final String countryId;
  final String? regionId;
  @Index()
  final String? cityId;
  final String ownerType;
  @Index()
  final String ownerId;
  @Index()
  final String estado;
  final List<String> etiquetas;
  final List<String> fotosUrls;
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  AssetModel({
    this.isarId,
    required this.id,
    required this.orgId,
    required this.assetType,
    required this.countryId,
    this.regionId,
    this.cityId,
    required this.ownerType,
    required this.ownerId,
    required this.estado,
    this.etiquetas = const [],
    this.fotosUrls = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) =>
      _$AssetModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetModelToJson(this);
  factory AssetModel.fromFirestore(String docId, Map<String, dynamic> json) =>
      AssetModel.fromJson({...json, 'id': docId});

  factory AssetModel.fromEntity(domain.AssetEntity e) => AssetModel(
        id: e.id,
        orgId: e.orgId,
        assetType: e.assetType,
        countryId: e.countryId,
        regionId: e.regionId,
        cityId: e.cityId,
        ownerType: e.ownerType,
        ownerId: e.ownerId,
        estado: e.estado,
        etiquetas: e.etiquetas,
        fotosUrls: e.fotosUrls,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.AssetEntity toEntity() => domain.AssetEntity(
        id: id,
        orgId: orgId,
        assetType: assetType,
        countryId: countryId,
        regionId: regionId,
        cityId: cityId,
        ownerType: ownerType,
        ownerId: ownerId,
        estado: estado,
        etiquetas: etiquetas,
        fotosUrls: fotosUrls,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
