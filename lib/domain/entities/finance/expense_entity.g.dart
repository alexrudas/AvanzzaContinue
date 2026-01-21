// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseEntity _$ExpenseEntityFromJson(Map<String, dynamic> json) =>
    _ExpenseEntity(
      id: json['id'] as String,
      portfolioId: json['portfolioId'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      expenseType: $enumDecode(_$ExpenseTypeEnumMap, json['expenseType']),
      description: json['description'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ExpenseEntityToJson(_ExpenseEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'portfolioId': instance.portfolioId,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'expenseType': _$ExpenseTypeEnumMap[instance.expenseType]!,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ExpenseTypeEnumMap = {
  ExpenseType.mantenimiento: 'MANTENIMIENTO',
  ExpenseType.seguro: 'SEGURO',
  ExpenseType.servicio: 'SERVICIO',
  ExpenseType.impuesto: 'IMPUESTO',
  ExpenseType.otro: 'OTRO',
};
