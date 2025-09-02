// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_maquinaria_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetMaquinariaEntity {
  String get assetId;
  String get serie;
  String get marca;
  String get capacidad;
  String get categoria;
  String? get certificadoOperacion;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of AssetMaquinariaEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetMaquinariaEntityCopyWith<AssetMaquinariaEntity> get copyWith =>
      _$AssetMaquinariaEntityCopyWithImpl<AssetMaquinariaEntity>(
          this as AssetMaquinariaEntity, _$identity);

  /// Serializes this AssetMaquinariaEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetMaquinariaEntity &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.serie, serie) || other.serie == serie) &&
            (identical(other.marca, marca) || other.marca == marca) &&
            (identical(other.capacidad, capacidad) ||
                other.capacidad == capacidad) &&
            (identical(other.categoria, categoria) ||
                other.categoria == categoria) &&
            (identical(other.certificadoOperacion, certificadoOperacion) ||
                other.certificadoOperacion == certificadoOperacion) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, assetId, serie, marca, capacidad,
      categoria, certificadoOperacion, createdAt, updatedAt);

  @override
  String toString() {
    return 'AssetMaquinariaEntity(assetId: $assetId, serie: $serie, marca: $marca, capacidad: $capacidad, categoria: $categoria, certificadoOperacion: $certificadoOperacion, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AssetMaquinariaEntityCopyWith<$Res> {
  factory $AssetMaquinariaEntityCopyWith(AssetMaquinariaEntity value,
          $Res Function(AssetMaquinariaEntity) _then) =
      _$AssetMaquinariaEntityCopyWithImpl;
  @useResult
  $Res call(
      {String assetId,
      String serie,
      String marca,
      String capacidad,
      String categoria,
      String? certificadoOperacion,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AssetMaquinariaEntityCopyWithImpl<$Res>
    implements $AssetMaquinariaEntityCopyWith<$Res> {
  _$AssetMaquinariaEntityCopyWithImpl(this._self, this._then);

  final AssetMaquinariaEntity _self;
  final $Res Function(AssetMaquinariaEntity) _then;

  /// Create a copy of AssetMaquinariaEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetId = null,
    Object? serie = null,
    Object? marca = null,
    Object? capacidad = null,
    Object? categoria = null,
    Object? certificadoOperacion = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      serie: null == serie
          ? _self.serie
          : serie // ignore: cast_nullable_to_non_nullable
              as String,
      marca: null == marca
          ? _self.marca
          : marca // ignore: cast_nullable_to_non_nullable
              as String,
      capacidad: null == capacidad
          ? _self.capacidad
          : capacidad // ignore: cast_nullable_to_non_nullable
              as String,
      categoria: null == categoria
          ? _self.categoria
          : categoria // ignore: cast_nullable_to_non_nullable
              as String,
      certificadoOperacion: freezed == certificadoOperacion
          ? _self.certificadoOperacion
          : certificadoOperacion // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AssetMaquinariaEntity].
extension AssetMaquinariaEntityPatterns on AssetMaquinariaEntity {
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
    TResult Function(_AssetMaquinariaEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetMaquinariaEntity() when $default != null:
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
    TResult Function(_AssetMaquinariaEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetMaquinariaEntity():
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
    TResult? Function(_AssetMaquinariaEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetMaquinariaEntity() when $default != null:
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
            String assetId,
            String serie,
            String marca,
            String capacidad,
            String categoria,
            String? certificadoOperacion,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetMaquinariaEntity() when $default != null:
        return $default(
            _that.assetId,
            _that.serie,
            _that.marca,
            _that.capacidad,
            _that.categoria,
            _that.certificadoOperacion,
            _that.createdAt,
            _that.updatedAt);
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
            String assetId,
            String serie,
            String marca,
            String capacidad,
            String categoria,
            String? certificadoOperacion,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetMaquinariaEntity():
        return $default(
            _that.assetId,
            _that.serie,
            _that.marca,
            _that.capacidad,
            _that.categoria,
            _that.certificadoOperacion,
            _that.createdAt,
            _that.updatedAt);
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
            String assetId,
            String serie,
            String marca,
            String capacidad,
            String categoria,
            String? certificadoOperacion,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetMaquinariaEntity() when $default != null:
        return $default(
            _that.assetId,
            _that.serie,
            _that.marca,
            _that.capacidad,
            _that.categoria,
            _that.certificadoOperacion,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AssetMaquinariaEntity implements AssetMaquinariaEntity {
  const _AssetMaquinariaEntity(
      {required this.assetId,
      required this.serie,
      required this.marca,
      required this.capacidad,
      required this.categoria,
      this.certificadoOperacion,
      this.createdAt,
      this.updatedAt});
  factory _AssetMaquinariaEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetMaquinariaEntityFromJson(json);

  @override
  final String assetId;
  @override
  final String serie;
  @override
  final String marca;
  @override
  final String capacidad;
  @override
  final String categoria;
  @override
  final String? certificadoOperacion;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of AssetMaquinariaEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetMaquinariaEntityCopyWith<_AssetMaquinariaEntity> get copyWith =>
      __$AssetMaquinariaEntityCopyWithImpl<_AssetMaquinariaEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetMaquinariaEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetMaquinariaEntity &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.serie, serie) || other.serie == serie) &&
            (identical(other.marca, marca) || other.marca == marca) &&
            (identical(other.capacidad, capacidad) ||
                other.capacidad == capacidad) &&
            (identical(other.categoria, categoria) ||
                other.categoria == categoria) &&
            (identical(other.certificadoOperacion, certificadoOperacion) ||
                other.certificadoOperacion == certificadoOperacion) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, assetId, serie, marca, capacidad,
      categoria, certificadoOperacion, createdAt, updatedAt);

  @override
  String toString() {
    return 'AssetMaquinariaEntity(assetId: $assetId, serie: $serie, marca: $marca, capacidad: $capacidad, categoria: $categoria, certificadoOperacion: $certificadoOperacion, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AssetMaquinariaEntityCopyWith<$Res>
    implements $AssetMaquinariaEntityCopyWith<$Res> {
  factory _$AssetMaquinariaEntityCopyWith(_AssetMaquinariaEntity value,
          $Res Function(_AssetMaquinariaEntity) _then) =
      __$AssetMaquinariaEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String assetId,
      String serie,
      String marca,
      String capacidad,
      String categoria,
      String? certificadoOperacion,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$AssetMaquinariaEntityCopyWithImpl<$Res>
    implements _$AssetMaquinariaEntityCopyWith<$Res> {
  __$AssetMaquinariaEntityCopyWithImpl(this._self, this._then);

  final _AssetMaquinariaEntity _self;
  final $Res Function(_AssetMaquinariaEntity) _then;

  /// Create a copy of AssetMaquinariaEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? assetId = null,
    Object? serie = null,
    Object? marca = null,
    Object? capacidad = null,
    Object? categoria = null,
    Object? certificadoOperacion = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_AssetMaquinariaEntity(
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      serie: null == serie
          ? _self.serie
          : serie // ignore: cast_nullable_to_non_nullable
              as String,
      marca: null == marca
          ? _self.marca
          : marca // ignore: cast_nullable_to_non_nullable
              as String,
      capacidad: null == capacidad
          ? _self.capacidad
          : capacidad // ignore: cast_nullable_to_non_nullable
              as String,
      categoria: null == categoria
          ? _self.categoria
          : categoria // ignore: cast_nullable_to_non_nullable
              as String,
      certificadoOperacion: freezed == certificadoOperacion
          ? _self.certificadoOperacion
          : certificadoOperacion // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
