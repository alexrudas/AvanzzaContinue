// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_vehiculo_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetVehiculoEntity {
  String get assetId;
  String get refCode; // 3 letters + 3 numbers
  String get placa;
  String get marca;
  String get modelo;
  int get anio;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of AssetVehiculoEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetVehiculoEntityCopyWith<AssetVehiculoEntity> get copyWith =>
      _$AssetVehiculoEntityCopyWithImpl<AssetVehiculoEntity>(
          this as AssetVehiculoEntity, _$identity);

  /// Serializes this AssetVehiculoEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetVehiculoEntity &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.refCode, refCode) || other.refCode == refCode) &&
            (identical(other.placa, placa) || other.placa == placa) &&
            (identical(other.marca, marca) || other.marca == marca) &&
            (identical(other.modelo, modelo) || other.modelo == modelo) &&
            (identical(other.anio, anio) || other.anio == anio) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, assetId, refCode, placa, marca,
      modelo, anio, createdAt, updatedAt);

  @override
  String toString() {
    return 'AssetVehiculoEntity(assetId: $assetId, refCode: $refCode, placa: $placa, marca: $marca, modelo: $modelo, anio: $anio, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AssetVehiculoEntityCopyWith<$Res> {
  factory $AssetVehiculoEntityCopyWith(
          AssetVehiculoEntity value, $Res Function(AssetVehiculoEntity) _then) =
      _$AssetVehiculoEntityCopyWithImpl;
  @useResult
  $Res call(
      {String assetId,
      String refCode,
      String placa,
      String marca,
      String modelo,
      int anio,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AssetVehiculoEntityCopyWithImpl<$Res>
    implements $AssetVehiculoEntityCopyWith<$Res> {
  _$AssetVehiculoEntityCopyWithImpl(this._self, this._then);

  final AssetVehiculoEntity _self;
  final $Res Function(AssetVehiculoEntity) _then;

  /// Create a copy of AssetVehiculoEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetId = null,
    Object? refCode = null,
    Object? placa = null,
    Object? marca = null,
    Object? modelo = null,
    Object? anio = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      refCode: null == refCode
          ? _self.refCode
          : refCode // ignore: cast_nullable_to_non_nullable
              as String,
      placa: null == placa
          ? _self.placa
          : placa // ignore: cast_nullable_to_non_nullable
              as String,
      marca: null == marca
          ? _self.marca
          : marca // ignore: cast_nullable_to_non_nullable
              as String,
      modelo: null == modelo
          ? _self.modelo
          : modelo // ignore: cast_nullable_to_non_nullable
              as String,
      anio: null == anio
          ? _self.anio
          : anio // ignore: cast_nullable_to_non_nullable
              as int,
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

/// Adds pattern-matching-related methods to [AssetVehiculoEntity].
extension AssetVehiculoEntityPatterns on AssetVehiculoEntity {
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
    TResult Function(_AssetVehiculoEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetVehiculoEntity() when $default != null:
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
    TResult Function(_AssetVehiculoEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetVehiculoEntity():
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
    TResult? Function(_AssetVehiculoEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetVehiculoEntity() when $default != null:
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
    TResult Function(String assetId, String refCode, String placa, String marca,
            String modelo, int anio, DateTime? createdAt, DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetVehiculoEntity() when $default != null:
        return $default(_that.assetId, _that.refCode, _that.placa, _that.marca,
            _that.modelo, _that.anio, _that.createdAt, _that.updatedAt);
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
    TResult Function(String assetId, String refCode, String placa, String marca,
            String modelo, int anio, DateTime? createdAt, DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetVehiculoEntity():
        return $default(_that.assetId, _that.refCode, _that.placa, _that.marca,
            _that.modelo, _that.anio, _that.createdAt, _that.updatedAt);
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
            String refCode,
            String placa,
            String marca,
            String modelo,
            int anio,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetVehiculoEntity() when $default != null:
        return $default(_that.assetId, _that.refCode, _that.placa, _that.marca,
            _that.modelo, _that.anio, _that.createdAt, _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssetVehiculoEntity implements AssetVehiculoEntity {
  const _AssetVehiculoEntity(
      {required this.assetId,
      required this.refCode,
      required this.placa,
      required this.marca,
      required this.modelo,
      required this.anio,
      this.createdAt,
      this.updatedAt});
  factory _AssetVehiculoEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetVehiculoEntityFromJson(json);

  @override
  final String assetId;
  @override
  final String refCode;
// 3 letters + 3 numbers
  @override
  final String placa;
  @override
  final String marca;
  @override
  final String modelo;
  @override
  final int anio;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of AssetVehiculoEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetVehiculoEntityCopyWith<_AssetVehiculoEntity> get copyWith =>
      __$AssetVehiculoEntityCopyWithImpl<_AssetVehiculoEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetVehiculoEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetVehiculoEntity &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.refCode, refCode) || other.refCode == refCode) &&
            (identical(other.placa, placa) || other.placa == placa) &&
            (identical(other.marca, marca) || other.marca == marca) &&
            (identical(other.modelo, modelo) || other.modelo == modelo) &&
            (identical(other.anio, anio) || other.anio == anio) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, assetId, refCode, placa, marca,
      modelo, anio, createdAt, updatedAt);

  @override
  String toString() {
    return 'AssetVehiculoEntity(assetId: $assetId, refCode: $refCode, placa: $placa, marca: $marca, modelo: $modelo, anio: $anio, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AssetVehiculoEntityCopyWith<$Res>
    implements $AssetVehiculoEntityCopyWith<$Res> {
  factory _$AssetVehiculoEntityCopyWith(_AssetVehiculoEntity value,
          $Res Function(_AssetVehiculoEntity) _then) =
      __$AssetVehiculoEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String assetId,
      String refCode,
      String placa,
      String marca,
      String modelo,
      int anio,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$AssetVehiculoEntityCopyWithImpl<$Res>
    implements _$AssetVehiculoEntityCopyWith<$Res> {
  __$AssetVehiculoEntityCopyWithImpl(this._self, this._then);

  final _AssetVehiculoEntity _self;
  final $Res Function(_AssetVehiculoEntity) _then;

  /// Create a copy of AssetVehiculoEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? assetId = null,
    Object? refCode = null,
    Object? placa = null,
    Object? marca = null,
    Object? modelo = null,
    Object? anio = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_AssetVehiculoEntity(
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      refCode: null == refCode
          ? _self.refCode
          : refCode // ignore: cast_nullable_to_non_nullable
              as String,
      placa: null == placa
          ? _self.placa
          : placa // ignore: cast_nullable_to_non_nullable
              as String,
      marca: null == marca
          ? _self.marca
          : marca // ignore: cast_nullable_to_non_nullable
              as String,
      modelo: null == modelo
          ? _self.modelo
          : modelo // ignore: cast_nullable_to_non_nullable
              as String,
      anio: null == anio
          ? _self.anio
          : anio // ignore: cast_nullable_to_non_nullable
              as int,
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
