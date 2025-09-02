import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/insurance/insurance_policy_entity.dart'
    as domain;

part 'insurance_policy_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class InsurancePolicyModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String assetId;
  final String tipo;
  final String aseguradora;
  final double tarifaBase;
  final String currencyCode;
  @Index()
  final String countryId;
  @Index()
  final String? cityId;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  @Index()
  final String estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InsurancePolicyModel({
    this.isarId,
    required this.id,
    required this.assetId,
    required this.tipo,
    required this.aseguradora,
    required this.tarifaBase,
    required this.currencyCode,
    required this.countryId,
    this.cityId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
    this.createdAt,
    this.updatedAt,
  });

  factory InsurancePolicyModel.fromJson(Map<String, dynamic> json) =>
      _$InsurancePolicyModelFromJson(json);
  Map<String, dynamic> toJson() => _$InsurancePolicyModelToJson(this);
  factory InsurancePolicyModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      InsurancePolicyModel.fromJson({...json, 'id': docId});

  factory InsurancePolicyModel.fromEntity(domain.InsurancePolicyEntity e) =>
      InsurancePolicyModel(
        id: e.id,
        assetId: e.assetId,
        tipo: e.tipo,
        aseguradora: e.aseguradora,
        tarifaBase: e.tarifaBase,
        currencyCode: e.currencyCode,
        countryId: e.countryId,
        cityId: e.cityId,
        fechaInicio: e.fechaInicio,
        fechaFin: e.fechaFin,
        estado: e.estado,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.InsurancePolicyEntity toEntity() => domain.InsurancePolicyEntity(
        id: id,
        assetId: assetId,
        tipo: tipo,
        aseguradora: aseguradora,
        tarifaBase: tarifaBase,
        currencyCode: currencyCode,
        countryId: countryId,
        cityId: cityId,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        estado: estado,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
