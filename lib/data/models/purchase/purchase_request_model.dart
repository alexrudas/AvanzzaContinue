import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/purchase/purchase_request_entity.dart'
    as domain;

part 'purchase_request_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class PurchaseRequestModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String orgId;
  @Index()
  final String? assetId;
  final String tipoRepuesto;
  final String? specs;
  final int cantidad;
  @Index()
  final String ciudadEntrega; // cityId
  final List<String> proveedorIdsInvitados;
  @Index()
  final String estado;
  final int respuestasCount;
  final String currencyCode;
  @DateTimeTimestampConverter()
  final DateTime? expectedDate;
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  PurchaseRequestModel({
    this.isarId,
    required this.id,
    required this.orgId,
    this.assetId,
    required this.tipoRepuesto,
    this.specs,
    required this.cantidad,
    required this.ciudadEntrega,
    this.proveedorIdsInvitados = const [],
    required this.estado,
    this.respuestasCount = 0,
    required this.currencyCode,
    this.expectedDate,
    this.createdAt,
    this.updatedAt,
  });

  factory PurchaseRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseRequestModelToJson(this);
  factory PurchaseRequestModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      PurchaseRequestModel.fromJson({...json, 'id': docId});

  factory PurchaseRequestModel.fromEntity(domain.PurchaseRequestEntity e) =>
      PurchaseRequestModel(
        id: e.id,
        orgId: e.orgId,
        assetId: e.assetId,
        tipoRepuesto: e.tipoRepuesto,
        specs: e.specs,
        cantidad: e.cantidad,
        ciudadEntrega: e.ciudadEntrega,
        proveedorIdsInvitados: e.proveedorIdsInvitados,
        estado: e.estado,
        respuestasCount: e.respuestasCount,
        currencyCode: e.currencyCode,
        expectedDate: e.expectedDate,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.PurchaseRequestEntity toEntity() => domain.PurchaseRequestEntity(
        id: id,
        orgId: orgId,
        assetId: assetId,
        tipoRepuesto: tipoRepuesto,
        specs: specs,
        cantidad: cantidad,
        ciudadEntrega: ciudadEntrega,
        proveedorIdsInvitados: proveedorIdsInvitados,
        estado: estado,
        respuestasCount: respuestasCount,
        currencyCode: currencyCode,
        expectedDate: expectedDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
