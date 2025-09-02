// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_entry_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountingEntryEntity _$AccountingEntryEntityFromJson(
        Map<String, dynamic> json) =>
    _AccountingEntryEntity(
      id: json['id'] as String? ?? '',
      orgId: json['orgId'] as String? ?? '',
      countryId: json['countryId'] as String? ?? '',
      cityId: json['cityId'] as String?,
      tipo: json['tipo'] as String? ?? 'ingreso',
      monto: (json['monto'] as num?)?.toDouble() ?? 0.0,
      currencyCode: json['currencyCode'] as String? ?? 'COP',
      descripcion: json['descripcion'] as String? ?? '',
      fecha: DateTime.parse(json['fecha'] as String),
      referenciaType: json['referenciaType'] as String? ?? '',
      referenciaId: json['referenciaId'] as String? ?? '',
      counterpartyId: json['counterpartyId'] as String?,
      method: json['method'] as String? ?? 'cash',
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AccountingEntryEntityToJson(
        _AccountingEntryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'countryId': instance.countryId,
      'cityId': instance.cityId,
      'tipo': instance.tipo,
      'monto': instance.monto,
      'currencyCode': instance.currencyCode,
      'descripcion': instance.descripcion,
      'fecha': instance.fecha.toIso8601String(),
      'referenciaType': instance.referenciaType,
      'referenciaId': instance.referenciaId,
      'counterpartyId': instance.counterpartyId,
      'method': instance.method,
      'taxAmount': instance.taxAmount,
      'taxRate': instance.taxRate,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
