// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_scope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MembershipScope {
  /// Tipo de alcance. Default seguro: restricted (sin acceso hasta asignar).
  ScopeType get type;

  /// IDs de activos asignados (solo aplica cuando type == restricted).
  List<String> get assignedAssetIds;

  /// IDs de grupos/portfolios asignados (escalabilidad para >N activos).
  List<String> get assignedGroupIds;

  /// Overrides granulares codificados como strings.
  ///
  /// **Contrato de formato obligatorio:**
  ///   `"asset:<assetId>:perm:<permKey>"`
  ///
  /// Ejemplos válidos:
  /// - `"asset:abc123:perm:readonly"`
  /// - `"asset:xyz999:perm:accounting_view"`
  /// - `"asset:veh001:perm:maintenance_rw"`
  ///
  /// Cualquier string que no siga el formato `asset:*:perm:*` se considera
  /// inválida y será ignorada silenciosamente por la capa de enforcement.
  /// Este Value Object no valida el formato; solo lo transporta.
  List<String> get granularOverrides;

  /// Create a copy of MembershipScope
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MembershipScopeCopyWith<MembershipScope> get copyWith =>
      _$MembershipScopeCopyWithImpl<MembershipScope>(
          this as MembershipScope, _$identity);

  /// Serializes this MembershipScope to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MembershipScope &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other.assignedAssetIds, assignedAssetIds) &&
            const DeepCollectionEquality()
                .equals(other.assignedGroupIds, assignedGroupIds) &&
            const DeepCollectionEquality()
                .equals(other.granularOverrides, granularOverrides));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      const DeepCollectionEquality().hash(assignedAssetIds),
      const DeepCollectionEquality().hash(assignedGroupIds),
      const DeepCollectionEquality().hash(granularOverrides));

  @override
  String toString() {
    return 'MembershipScope(type: $type, assignedAssetIds: $assignedAssetIds, assignedGroupIds: $assignedGroupIds, granularOverrides: $granularOverrides)';
  }
}

/// @nodoc
abstract mixin class $MembershipScopeCopyWith<$Res> {
  factory $MembershipScopeCopyWith(
          MembershipScope value, $Res Function(MembershipScope) _then) =
      _$MembershipScopeCopyWithImpl;
  @useResult
  $Res call(
      {ScopeType type,
      List<String> assignedAssetIds,
      List<String> assignedGroupIds,
      List<String> granularOverrides});
}

/// @nodoc
class _$MembershipScopeCopyWithImpl<$Res>
    implements $MembershipScopeCopyWith<$Res> {
  _$MembershipScopeCopyWithImpl(this._self, this._then);

  final MembershipScope _self;
  final $Res Function(MembershipScope) _then;

  /// Create a copy of MembershipScope
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? assignedAssetIds = null,
    Object? assignedGroupIds = null,
    Object? granularOverrides = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as ScopeType,
      assignedAssetIds: null == assignedAssetIds
          ? _self.assignedAssetIds
          : assignedAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      assignedGroupIds: null == assignedGroupIds
          ? _self.assignedGroupIds
          : assignedGroupIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      granularOverrides: null == granularOverrides
          ? _self.granularOverrides
          : granularOverrides // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MembershipScope].
extension MembershipScopePatterns on MembershipScope {
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
    TResult Function(_MembershipScope value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MembershipScope() when $default != null:
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
    TResult Function(_MembershipScope value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MembershipScope():
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
    TResult? Function(_MembershipScope value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MembershipScope() when $default != null:
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
    TResult Function(ScopeType type, List<String> assignedAssetIds,
            List<String> assignedGroupIds, List<String> granularOverrides)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MembershipScope() when $default != null:
        return $default(_that.type, _that.assignedAssetIds,
            _that.assignedGroupIds, _that.granularOverrides);
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
    TResult Function(ScopeType type, List<String> assignedAssetIds,
            List<String> assignedGroupIds, List<String> granularOverrides)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MembershipScope():
        return $default(_that.type, _that.assignedAssetIds,
            _that.assignedGroupIds, _that.granularOverrides);
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
    TResult? Function(ScopeType type, List<String> assignedAssetIds,
            List<String> assignedGroupIds, List<String> granularOverrides)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MembershipScope() when $default != null:
        return $default(_that.type, _that.assignedAssetIds,
            _that.assignedGroupIds, _that.granularOverrides);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MembershipScope extends MembershipScope {
  const _MembershipScope(
      {this.type = ScopeType.restricted,
      final List<String> assignedAssetIds = const <String>[],
      final List<String> assignedGroupIds = const <String>[],
      final List<String> granularOverrides = const <String>[]})
      : _assignedAssetIds = assignedAssetIds,
        _assignedGroupIds = assignedGroupIds,
        _granularOverrides = granularOverrides,
        super._();
  factory _MembershipScope.fromJson(Map<String, dynamic> json) =>
      _$MembershipScopeFromJson(json);

  /// Tipo de alcance. Default seguro: restricted (sin acceso hasta asignar).
  @override
  @JsonKey()
  final ScopeType type;

  /// IDs de activos asignados (solo aplica cuando type == restricted).
  final List<String> _assignedAssetIds;

  /// IDs de activos asignados (solo aplica cuando type == restricted).
  @override
  @JsonKey()
  List<String> get assignedAssetIds {
    if (_assignedAssetIds is EqualUnmodifiableListView)
      return _assignedAssetIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignedAssetIds);
  }

  /// IDs de grupos/portfolios asignados (escalabilidad para >N activos).
  final List<String> _assignedGroupIds;

  /// IDs de grupos/portfolios asignados (escalabilidad para >N activos).
  @override
  @JsonKey()
  List<String> get assignedGroupIds {
    if (_assignedGroupIds is EqualUnmodifiableListView)
      return _assignedGroupIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignedGroupIds);
  }

  /// Overrides granulares codificados como strings.
  ///
  /// **Contrato de formato obligatorio:**
  ///   `"asset:<assetId>:perm:<permKey>"`
  ///
  /// Ejemplos válidos:
  /// - `"asset:abc123:perm:readonly"`
  /// - `"asset:xyz999:perm:accounting_view"`
  /// - `"asset:veh001:perm:maintenance_rw"`
  ///
  /// Cualquier string que no siga el formato `asset:*:perm:*` se considera
  /// inválida y será ignorada silenciosamente por la capa de enforcement.
  /// Este Value Object no valida el formato; solo lo transporta.
  final List<String> _granularOverrides;

  /// Overrides granulares codificados como strings.
  ///
  /// **Contrato de formato obligatorio:**
  ///   `"asset:<assetId>:perm:<permKey>"`
  ///
  /// Ejemplos válidos:
  /// - `"asset:abc123:perm:readonly"`
  /// - `"asset:xyz999:perm:accounting_view"`
  /// - `"asset:veh001:perm:maintenance_rw"`
  ///
  /// Cualquier string que no siga el formato `asset:*:perm:*` se considera
  /// inválida y será ignorada silenciosamente por la capa de enforcement.
  /// Este Value Object no valida el formato; solo lo transporta.
  @override
  @JsonKey()
  List<String> get granularOverrides {
    if (_granularOverrides is EqualUnmodifiableListView)
      return _granularOverrides;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_granularOverrides);
  }

  /// Create a copy of MembershipScope
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MembershipScopeCopyWith<_MembershipScope> get copyWith =>
      __$MembershipScopeCopyWithImpl<_MembershipScope>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MembershipScopeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MembershipScope &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._assignedAssetIds, _assignedAssetIds) &&
            const DeepCollectionEquality()
                .equals(other._assignedGroupIds, _assignedGroupIds) &&
            const DeepCollectionEquality()
                .equals(other._granularOverrides, _granularOverrides));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      const DeepCollectionEquality().hash(_assignedAssetIds),
      const DeepCollectionEquality().hash(_assignedGroupIds),
      const DeepCollectionEquality().hash(_granularOverrides));

  @override
  String toString() {
    return 'MembershipScope(type: $type, assignedAssetIds: $assignedAssetIds, assignedGroupIds: $assignedGroupIds, granularOverrides: $granularOverrides)';
  }
}

/// @nodoc
abstract mixin class _$MembershipScopeCopyWith<$Res>
    implements $MembershipScopeCopyWith<$Res> {
  factory _$MembershipScopeCopyWith(
          _MembershipScope value, $Res Function(_MembershipScope) _then) =
      __$MembershipScopeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ScopeType type,
      List<String> assignedAssetIds,
      List<String> assignedGroupIds,
      List<String> granularOverrides});
}

/// @nodoc
class __$MembershipScopeCopyWithImpl<$Res>
    implements _$MembershipScopeCopyWith<$Res> {
  __$MembershipScopeCopyWithImpl(this._self, this._then);

  final _MembershipScope _self;
  final $Res Function(_MembershipScope) _then;

  /// Create a copy of MembershipScope
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? assignedAssetIds = null,
    Object? assignedGroupIds = null,
    Object? granularOverrides = null,
  }) {
    return _then(_MembershipScope(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as ScopeType,
      assignedAssetIds: null == assignedAssetIds
          ? _self._assignedAssetIds
          : assignedAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      assignedGroupIds: null == assignedGroupIds
          ? _self._assignedGroupIds
          : assignedGroupIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      granularOverrides: null == granularOverrides
          ? _self._granularOverrides
          : granularOverrides // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
