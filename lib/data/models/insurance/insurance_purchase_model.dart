import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/insurance/insurance_purchase_entity.dart'
    as domain;
import '../geo/address_model.dart';

part 'insurance_purchase_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class InsurancePurchaseModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String assetId;
  @Index()
  final String orgId;
  final String compradorId;
  final String contactEmail;
  final AddressModel address;
  final String currencyCode;
  @Index()
  final String estadoCompra; // pendiente | pagado | confirmado
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  InsurancePurchaseModel({
    this.isarId,
    required this.id,
    required this.assetId,
    required this.compradorId,
    required this.orgId,
    required this.contactEmail,
    required this.address,
    required this.currencyCode,
    required this.estadoCompra,
    this.createdAt,
    this.updatedAt,
  });

  factory InsurancePurchaseModel.fromJson(Map<String, dynamic> json) =>
      _$InsurancePurchaseModelFromJson(json);
  Map<String, dynamic> toJson() => _$InsurancePurchaseModelToJson(this);
  factory InsurancePurchaseModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      InsurancePurchaseModel.fromJson({...json, 'id': docId});

  factory InsurancePurchaseModel.fromEntity(domain.InsurancePurchaseEntity e) =>
      InsurancePurchaseModel(
        id: e.id,
        assetId: e.assetId,
        compradorId: e.compradorId,
        orgId: e.orgId,
        contactEmail: e.contactEmail,
        address: AddressModel.fromEntity(e.address),
        currencyCode: e.currencyCode,
        estadoCompra: e.estadoCompra,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.InsurancePurchaseEntity toEntity() => domain.InsurancePurchaseEntity(
        id: id,
        assetId: assetId,
        compradorId: compradorId,
        orgId: orgId,
        contactEmail: contactEmail,
        address: address.toEntity(),
        currencyCode: currencyCode,
        estadoCompra: estadoCompra,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
