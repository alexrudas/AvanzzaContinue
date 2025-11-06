import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_permission_entity.freezed.dart';
part 'role_permission_entity.g.dart';

@freezed
abstract class RolePermissionEntity with _$RolePermissionEntity {
  const factory RolePermissionEntity({
    required String roleId,
    @Default(<String>[]) List<String> permissions,
    @Default(<String>[]) List<String> scopes,
  }) = _RolePermissionEntity;

  factory RolePermissionEntity.fromJson(Map<String, dynamic> json) =>
      _$RolePermissionEntityFromJson(json);
}
