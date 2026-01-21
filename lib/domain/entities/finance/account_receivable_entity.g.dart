// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_receivable_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountReceivableEntity _$AccountReceivableEntityFromJson(
        Map<String, dynamic> json) =>
    _AccountReceivableEntity(
      id: json['id'] as String,
      portfolioId: json['portfolioId'] as String,
      debtorActorId: json['debtorActorId'] as String,
      amount: (json['amount'] as num).toDouble(),
      issueDate: DateTime.parse(json['issueDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: $enumDecodeNullable(
              _$AccountReceivableStatusEnumMap, json['status']) ??
          AccountReceivableStatus.pendiente,
      description: json['description'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AccountReceivableEntityToJson(
        _AccountReceivableEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'portfolioId': instance.portfolioId,
      'debtorActorId': instance.debtorActorId,
      'amount': instance.amount,
      'issueDate': instance.issueDate.toIso8601String(),
      'dueDate': instance.dueDate.toIso8601String(),
      'status': _$AccountReceivableStatusEnumMap[instance.status]!,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$AccountReceivableStatusEnumMap = {
  AccountReceivableStatus.pendiente: 'PENDIENTE',
  AccountReceivableStatus.pagada: 'PAGADA',
  AccountReceivableStatus.vencida: 'VENCIDA',
  AccountReceivableStatus.cancelada: 'CANCELADA',
};
