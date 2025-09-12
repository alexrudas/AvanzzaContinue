// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_permission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RolePermissionModel _$RolePermissionModelFromJson(Map<String, dynamic> json) =>
    _RolePermissionModel(
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

Map<String, dynamic> _$RolePermissionModelToJson(
        _RolePermissionModel instance) =>
    <String, dynamic>{
      'roleId': instance.roleId,
      'permissions': instance.permissions,
      'scopes': instance.scopes,
    };
