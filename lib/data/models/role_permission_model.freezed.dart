// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_permission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RolePermissionModel {
  String get roleId;
  List<String> get permissions;
  List<String> get scopes;

  /// Create a copy of RolePermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RolePermissionModelCopyWith<RolePermissionModel> get copyWith =>
      _$RolePermissionModelCopyWithImpl<RolePermissionModel>(
          this as RolePermissionModel, _$identity);

  /// Serializes this RolePermissionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RolePermissionModel &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            const DeepCollectionEquality()
                .equals(other.permissions, permissions) &&
            const DeepCollectionEquality().equals(other.scopes, scopes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      roleId,
      const DeepCollectionEquality().hash(permissions),
      const DeepCollectionEquality().hash(scopes));

  @override
  String toString() {
    return 'RolePermissionModel(roleId: $roleId, permissions: $permissions, scopes: $scopes)';
  }
}

/// @nodoc
abstract mixin class $RolePermissionModelCopyWith<$Res> {
  factory $RolePermissionModelCopyWith(
          RolePermissionModel value, $Res Function(RolePermissionModel) _then) =
      _$RolePermissionModelCopyWithImpl;
  @useResult
  $Res call({String roleId, List<String> permissions, List<String> scopes});
}

/// @nodoc
class _$RolePermissionModelCopyWithImpl<$Res>
    implements $RolePermissionModelCopyWith<$Res> {
  _$RolePermissionModelCopyWithImpl(this._self, this._then);

  final RolePermissionModel _self;
  final $Res Function(RolePermissionModel) _then;

  /// Create a copy of RolePermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleId = null,
    Object? permissions = null,
    Object? scopes = null,
  }) {
    return _then(_self.copyWith(
      roleId: null == roleId
          ? _self.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _self.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scopes: null == scopes
          ? _self.scopes
          : scopes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [RolePermissionModel].
extension RolePermissionModelPatterns on RolePermissionModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RolePermissionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RolePermissionModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RolePermissionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RolePermissionModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RolePermissionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RolePermissionModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String roleId, List<String> permissions, List<String> scopes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RolePermissionModel() when $default != null:
        return $default(_that.roleId, _that.permissions, _that.scopes);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String roleId, List<String> permissions, List<String> scopes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RolePermissionModel():
        return $default(_that.roleId, _that.permissions, _that.scopes);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String roleId, List<String> permissions, List<String> scopes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RolePermissionModel() when $default != null:
        return $default(_that.roleId, _that.permissions, _that.scopes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RolePermissionModel implements RolePermissionModel {
  const _RolePermissionModel(
      {required this.roleId,
      final List<String> permissions = const <String>[],
      final List<String> scopes = const <String>[]})
      : _permissions = permissions,
        _scopes = scopes;
  factory _RolePermissionModel.fromJson(Map<String, dynamic> json) =>
      _$RolePermissionModelFromJson(json);

  @override
  final String roleId;
  final List<String> _permissions;
  @override
  @JsonKey()
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  final List<String> _scopes;
  @override
  @JsonKey()
  List<String> get scopes {
    if (_scopes is EqualUnmodifiableListView) return _scopes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scopes);
  }

  /// Create a copy of RolePermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RolePermissionModelCopyWith<_RolePermissionModel> get copyWith =>
      __$RolePermissionModelCopyWithImpl<_RolePermissionModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RolePermissionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RolePermissionModel &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            const DeepCollectionEquality().equals(other._scopes, _scopes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      roleId,
      const DeepCollectionEquality().hash(_permissions),
      const DeepCollectionEquality().hash(_scopes));

  @override
  String toString() {
    return 'RolePermissionModel(roleId: $roleId, permissions: $permissions, scopes: $scopes)';
  }
}

/// @nodoc
abstract mixin class _$RolePermissionModelCopyWith<$Res>
    implements $RolePermissionModelCopyWith<$Res> {
  factory _$RolePermissionModelCopyWith(_RolePermissionModel value,
          $Res Function(_RolePermissionModel) _then) =
      __$RolePermissionModelCopyWithImpl;
  @override
  @useResult
  $Res call({String roleId, List<String> permissions, List<String> scopes});
}

/// @nodoc
class __$RolePermissionModelCopyWithImpl<$Res>
    implements _$RolePermissionModelCopyWith<$Res> {
  __$RolePermissionModelCopyWithImpl(this._self, this._then);

  final _RolePermissionModel _self;
  final $Res Function(_RolePermissionModel) _then;

  /// Create a copy of RolePermissionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? roleId = null,
    Object? permissions = null,
    Object? scopes = null,
  }) {
    return _then(_RolePermissionModel(
      roleId: null == roleId
          ? _self.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _self._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scopes: null == scopes
          ? _self._scopes
          : scopes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
