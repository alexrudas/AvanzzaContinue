// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjustment_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdjustmentEntity _$AdjustmentEntityFromJson(Map<String, dynamic> json) =>
    _AdjustmentEntity(
      id: json['id'] as String,
      entryId: json['entryId'] as String,
      tipo: json['tipo'] as String,
      valor: (json['valor'] as num).toDouble(),
      motivo: json['motivo'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AdjustmentEntityToJson(_AdjustmentEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entryId': instance.entryId,
      'tipo': instance.tipo,
      'valor': instance.valor,
      'motivo': instance.motivo,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
