// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_audit_log_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AIAuditLogEntity _$AIAuditLogEntityFromJson(Map<String, dynamic> json) =>
    _AIAuditLogEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      userId: json['userId'] as String,
      accion: json['accion'] as String,
      modulo: json['modulo'] as String,
      contexto: json['contexto'] as Map<String, dynamic>,
      resultado: json['resultado'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AIAuditLogEntityToJson(_AIAuditLogEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'userId': instance.userId,
      'accion': instance.accion,
      'modulo': instance.modulo,
      'contexto': instance.contexto,
      'resultado': instance.resultado,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
