import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/asset/asset_document_entity.dart' as domain;

part 'asset_document_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class AssetDocumentModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String assetId;
  final String tipoDoc;
  @Index()
  final String countryId;
  @Index()
  final String? cityId;
  @DateTimeTimestampConverter()
  final DateTime? fechaEmision;
  @DateTimeTimestampConverter()
  final DateTime? fechaVencimiento;
  @Index()
  final String estado;
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  AssetDocumentModel({
    this.isarId,
    required this.id,
    required this.assetId,
    required this.tipoDoc,
    required this.countryId,
    this.cityId,
    this.fechaEmision,
    this.fechaVencimiento,
    required this.estado,
    this.createdAt,
    this.updatedAt,
  });

  factory AssetDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$AssetDocumentModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetDocumentModelToJson(this);
  factory AssetDocumentModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      AssetDocumentModel.fromJson({...json, 'id': docId});

  factory AssetDocumentModel.fromEntity(domain.AssetDocumentEntity e) =>
      AssetDocumentModel(
        id: e.id,
        assetId: e.assetId,
        tipoDoc: e.tipoDoc,
        countryId: e.countryId,
        cityId: e.cityId,
        fechaEmision: e.fechaEmision,
        fechaVencimiento: e.fechaVencimiento,
        estado: e.estado,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.AssetDocumentEntity toEntity() => domain.AssetDocumentEntity(
        id: id,
        assetId: assetId,
        tipoDoc: tipoDoc,
        countryId: countryId,
        cityId: cityId,
        fechaEmision: fechaEmision,
        fechaVencimiento: fechaVencimiento,
        estado: estado,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
