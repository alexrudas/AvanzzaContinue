// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IncomeEntity _$IncomeEntityFromJson(Map<String, dynamic> json) =>
    _IncomeEntity(
      id: json['id'] as String,
      portfolioId: json['portfolioId'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      incomeType: $enumDecode(_$IncomeTypeEnumMap, json['incomeType']),
      description: json['description'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$IncomeEntityToJson(_IncomeEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'portfolioId': instance.portfolioId,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'incomeType': _$IncomeTypeEnumMap[instance.incomeType]!,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$IncomeTypeEnumMap = {
  IncomeType.alquiler: 'ALQUILER',
  IncomeType.venta: 'VENTA',
  IncomeType.servicio: 'SERVICIO',
  IncomeType.otro: 'OTRO',
};
