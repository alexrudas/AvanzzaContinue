import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/accounting/accounting_entry_entity.dart'
    as domain;

part 'accounting_entry_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class AccountingEntryModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String orgId;
  @Index()
  final String countryId;
  @Index()
  final String? cityId;
  @Index()
  final String tipo;
  final double monto;
  final String currencyCode;
  final String descripcion;
  final DateTime fecha;
  @Index()
  final String referenciaType;
  @Index()
  final String referenciaId;
  final String? counterpartyId;
  final String method;
  final double? taxAmount;
  final double? taxRate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AccountingEntryModel({
    this.isarId,
    required this.id,
    required this.orgId,
    required this.countryId,
    this.cityId,
    required this.tipo,
    required this.monto,
    required this.currencyCode,
    required this.descripcion,
    required this.fecha,
    required this.referenciaType,
    required this.referenciaId,
    this.counterpartyId,
    required this.method,
    this.taxAmount,
    this.taxRate,
    this.createdAt,
    this.updatedAt,
  });

  factory AccountingEntryModel.fromJson(Map<String, dynamic> json) =>
      _$AccountingEntryModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountingEntryModelToJson(this);
  factory AccountingEntryModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      AccountingEntryModel.fromJson({...json, 'id': docId});

  factory AccountingEntryModel.fromEntity(domain.AccountingEntryEntity e) =>
      AccountingEntryModel(
        id: e.id,
        orgId: e.orgId,
        countryId: e.countryId,
        cityId: e.cityId,
        tipo: e.tipo,
        monto: e.monto,
        currencyCode: e.currencyCode,
        descripcion: e.descripcion,
        fecha: e.fecha,
        referenciaType: e.referenciaType,
        referenciaId: e.referenciaId,
        counterpartyId: e.counterpartyId,
        method: e.method,
        taxAmount: e.taxAmount,
        taxRate: e.taxRate,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.AccountingEntryEntity toEntity() => domain.AccountingEntryEntity(
        id: id,
        orgId: orgId,
        countryId: countryId,
        cityId: cityId,
        tipo: tipo,
        monto: monto,
        currencyCode: currencyCode,
        descripcion: descripcion,
        fecha: fecha,
        referenciaType: referenciaType,
        referenciaId: referenciaId,
        counterpartyId: counterpartyId,
        method: method,
        taxAmount: taxAmount ?? 0,
        taxRate: taxRate ?? 0,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
