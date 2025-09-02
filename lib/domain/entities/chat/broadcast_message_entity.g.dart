// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BroadcastMessageEntity _$BroadcastMessageEntityFromJson(
        Map<String, dynamic> json) =>
    _BroadcastMessageEntity(
      id: json['id'] as String,
      adminId: json['adminId'] as String,
      orgId: json['orgId'] as String,
      rolObjetivo: json['rolObjetivo'] as String?,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      countryId: json['countryId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BroadcastMessageEntityToJson(
        _BroadcastMessageEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adminId': instance.adminId,
      'orgId': instance.orgId,
      'rolObjetivo': instance.rolObjetivo,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'countryId': instance.countryId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
