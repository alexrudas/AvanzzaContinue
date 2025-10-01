// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActiveContext {
  String get orgId;
  String get orgName;
  String
      get rol; // 'administrador'|'propietario'|'arrendatario'|'proveedor'|...
  String? get providerType; // 'servicios'|'articulos'
  List<String> get categories; // categorías proveedor seleccionadas
  List<String> get assetTypes;

  /// Create a copy of ActiveContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActiveContextCopyWith<ActiveContext> get copyWith =>
      _$ActiveContextCopyWithImpl<ActiveContext>(
          this as ActiveContext, _$identity);

  /// Serializes this ActiveContext to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActiveContext &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.orgName, orgName) || other.orgName == orgName) &&
            (identical(other.rol, rol) || other.rol == rol) &&
            (identical(other.providerType, providerType) ||
                other.providerType == providerType) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            const DeepCollectionEquality()
                .equals(other.assetTypes, assetTypes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      orgId,
      orgName,
      rol,
      providerType,
      const DeepCollectionEquality().hash(categories),
      const DeepCollectionEquality().hash(assetTypes));

  @override
  String toString() {
    return 'ActiveContext(orgId: $orgId, orgName: $orgName, rol: $rol, providerType: $providerType, categories: $categories, assetTypes: $assetTypes)';
  }
}

/// @nodoc
abstract mixin class $ActiveContextCopyWith<$Res> {
  factory $ActiveContextCopyWith(
          ActiveContext value, $Res Function(ActiveContext) _then) =
      _$ActiveContextCopyWithImpl;
  @useResult
  $Res call(
      {String orgId,
      String orgName,
      String rol,
      String? providerType,
      List<String> categories,
      List<String> assetTypes});
}

/// @nodoc
class _$ActiveContextCopyWithImpl<$Res>
    implements $ActiveContextCopyWith<$Res> {
  _$ActiveContextCopyWithImpl(this._self, this._then);

  final ActiveContext _self;
  final $Res Function(ActiveContext) _then;

  /// Create a copy of ActiveContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orgId = null,
    Object? orgName = null,
    Object? rol = null,
    Object? providerType = freezed,
    Object? categories = null,
    Object? assetTypes = null,
  }) {
    return _then(_self.copyWith(
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      orgName: null == orgName
          ? _self.orgName
          : orgName // ignore: cast_nullable_to_non_nullable
              as String,
      rol: null == rol
          ? _self.rol
          : rol // ignore: cast_nullable_to_non_nullable
              as String,
      providerType: freezed == providerType
          ? _self.providerType
          : providerType // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      assetTypes: null == assetTypes
          ? _self.assetTypes
          : assetTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ActiveContext].
extension ActiveContextPatterns on ActiveContext {
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
    TResult Function(_ActiveContext value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActiveContext() when $default != null:
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
    TResult Function(_ActiveContext value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActiveContext():
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
    TResult? Function(_ActiveContext value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActiveContext() when $default != null:
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
            String orgId,
            String orgName,
            String rol,
            String? providerType,
            List<String> categories,
            List<String> assetTypes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActiveContext() when $default != null:
        return $default(_that.orgId, _that.orgName, _that.rol,
            _that.providerType, _that.categories, _that.assetTypes);
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
            String orgId,
            String orgName,
            String rol,
            String? providerType,
            List<String> categories,
            List<String> assetTypes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActiveContext():
        return $default(_that.orgId, _that.orgName, _that.rol,
            _that.providerType, _that.categories, _that.assetTypes);
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
            String orgId,
            String orgName,
            String rol,
            String? providerType,
            List<String> categories,
            List<String> assetTypes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActiveContext() when $default != null:
        return $default(_that.orgId, _that.orgName, _that.rol,
            _that.providerType, _that.categories, _that.assetTypes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActiveContext implements ActiveContext {
  const _ActiveContext(
      {required this.orgId,
      required this.orgName,
      required this.rol,
      this.providerType,
      final List<String> categories = const <String>[],
      final List<String> assetTypes = const <String>[]})
      : _categories = categories,
        _assetTypes = assetTypes;
  factory _ActiveContext.fromJson(Map<String, dynamic> json) =>
      _$ActiveContextFromJson(json);

  @override
  final String orgId;
  @override
  final String orgName;
  @override
  final String rol;
// 'administrador'|'propietario'|'arrendatario'|'proveedor'|...
  @override
  final String? providerType;
// 'servicios'|'articulos'
  final List<String> _categories;
// 'servicios'|'articulos'
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

// categorías proveedor seleccionadas
  final List<String> _assetTypes;
// categorías proveedor seleccionadas
  @override
  @JsonKey()
  List<String> get assetTypes {
    if (_assetTypes is EqualUnmodifiableListView) return _assetTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assetTypes);
  }

  /// Create a copy of ActiveContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActiveContextCopyWith<_ActiveContext> get copyWith =>
      __$ActiveContextCopyWithImpl<_ActiveContext>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActiveContextToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActiveContext &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.orgName, orgName) || other.orgName == orgName) &&
            (identical(other.rol, rol) || other.rol == rol) &&
            (identical(other.providerType, providerType) ||
                other.providerType == providerType) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality()
                .equals(other._assetTypes, _assetTypes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      orgId,
      orgName,
      rol,
      providerType,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_assetTypes));

  @override
  String toString() {
    return 'ActiveContext(orgId: $orgId, orgName: $orgName, rol: $rol, providerType: $providerType, categories: $categories, assetTypes: $assetTypes)';
  }
}

/// @nodoc
abstract mixin class _$ActiveContextCopyWith<$Res>
    implements $ActiveContextCopyWith<$Res> {
  factory _$ActiveContextCopyWith(
          _ActiveContext value, $Res Function(_ActiveContext) _then) =
      __$ActiveContextCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String orgId,
      String orgName,
      String rol,
      String? providerType,
      List<String> categories,
      List<String> assetTypes});
}

/// @nodoc
class __$ActiveContextCopyWithImpl<$Res>
    implements _$ActiveContextCopyWith<$Res> {
  __$ActiveContextCopyWithImpl(this._self, this._then);

  final _ActiveContext _self;
  final $Res Function(_ActiveContext) _then;

  /// Create a copy of ActiveContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? orgId = null,
    Object? orgName = null,
    Object? rol = null,
    Object? providerType = freezed,
    Object? categories = null,
    Object? assetTypes = null,
  }) {
    return _then(_ActiveContext(
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      orgName: null == orgName
          ? _self.orgName
          : orgName // ignore: cast_nullable_to_non_nullable
              as String,
      rol: null == rol
          ? _self.rol
          : rol // ignore: cast_nullable_to_non_nullable
              as String,
      providerType: freezed == providerType
          ? _self.providerType
          : providerType // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      assetTypes: null == assetTypes
          ? _self._assetTypes
          : assetTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
