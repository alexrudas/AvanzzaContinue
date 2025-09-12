// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_permission_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RolePermissionEntity _$RolePermissionEntityFromJson(
        Map<String, dynamic> json) =>
    _RolePermissionEntity(
      roleId: json['roleId'] as String,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      scopes: (json['scopes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$RolePermissionEntityToJson(
        _RolePermissionEntity instance) =>
    <String, dynamic>{
      'roleId': instance.roleId,
      'permissions': instance.permissions,
      'scopes': instance.scopes,
    };
