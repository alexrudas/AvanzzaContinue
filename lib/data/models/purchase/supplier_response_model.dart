import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/purchase/supplier_response_entity.dart'
    as domain;

part 'supplier_response_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class SupplierResponseModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String purchaseRequestId;
  @Index()
  final String proveedorId;
  final double precio;
  final String disponibilidad;
  final String currencyCode;
  final String? catalogoUrl;
  final String? notas;
  final int? leadTimeDays;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SupplierResponseModel({
    this.isarId,
    required this.id,
    required this.purchaseRequestId,
    required this.proveedorId,
    required this.precio,
    required this.disponibilidad,
    required this.currencyCode,
    this.catalogoUrl,
    this.notas,
    this.leadTimeDays,
    this.createdAt,
    this.updatedAt,
  });

  factory SupplierResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierResponseModelToJson(this);
  factory SupplierResponseModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      SupplierResponseModel.fromJson({...json, 'id': docId});

  factory SupplierResponseModel.fromEntity(domain.SupplierResponseEntity e) =>
      SupplierResponseModel(
        id: e.id,
        purchaseRequestId: e.purchaseRequestId,
        proveedorId: e.proveedorId,
        precio: e.precio,
        disponibilidad: e.disponibilidad,
        currencyCode: e.currencyCode,
        catalogoUrl: e.catalogoUrl,
        notas: e.notas,
        leadTimeDays: e.leadTimeDays,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.SupplierResponseEntity toEntity() => domain.SupplierResponseEntity(
        id: id,
        purchaseRequestId: purchaseRequestId,
        proveedorId: proveedorId,
        precio: precio,
        disponibilidad: disponibilidad,
        currencyCode: currencyCode,
        catalogoUrl: catalogoUrl,
        notas: notas,
        leadTimeDays: leadTimeDays,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
