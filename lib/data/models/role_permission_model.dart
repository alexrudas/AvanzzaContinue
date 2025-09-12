import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/role_permission_entity.dart' as domain;

part 'role_permission_model.freezed.dart';
part 'role_permission_model.g.dart';

@freezed
abstract class RolePermissionModel with _$RolePermissionModel {
  const factory RolePermissionModel({
    required String roleId,
    @Default(<String>[]) List<String> permissions,
    @Default(<String>[]) List<String> scopes,
  }) = _RolePermissionModel;

  factory RolePermissionModel.fromJson(Map<String, dynamic> json) => _$RolePermissionModelFromJson(json);

  factory RolePermissionModel.fromEntity(domain.RolePermissionEntity e) => RolePermissionModel(roleId: e.roleId, permissions: e.permissions, scopes: e.scopes);
}


extension RolePermissionModelX on RolePermissionModel {
  domain.RolePermissionEntity toEntity() {
    return domain.RolePermissionEntity(
      roleId: roleId,
      permissions: permissions,
      scopes: scopes,
    );
  }
}
