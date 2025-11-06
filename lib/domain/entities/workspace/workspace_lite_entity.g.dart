// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_lite_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkspaceLiteEntity _$WorkspaceLiteEntityFromJson(Map<String, dynamic> json) =>
    _WorkspaceLiteEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String?,
      iconName: json['iconName'] as String?,
      lastUsed: json['lastUsed'] == null
          ? null
          : DateTime.parse(json['lastUsed'] as String),
    );

Map<String, dynamic> _$WorkspaceLiteEntityToJson(
        _WorkspaceLiteEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'subtitle': instance.subtitle,
      'iconName': instance.iconName,
      'lastUsed': instance.lastUsed?.toIso8601String(),
    };
