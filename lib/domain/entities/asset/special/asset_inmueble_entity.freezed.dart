// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_inmueble_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetInmuebleEntity {
  String get assetId;
  String get matriculaInmobiliaria;
  int? get estrato;
  double? get metrosCuadrados;
  String get uso; // residencial | comercial
  double? get valorCatastral;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of AssetInmuebleEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetInmuebleEntityCopyWith<AssetInmuebleEntity> get copyWith =>
      _$AssetInmuebleEntityCopyWithImpl<AssetInmuebleEntity>(
          this as AssetInmuebleEntity, _$identity);

  /// Serializes this AssetInmuebleEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetInmuebleEntity &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.matriculaInmobiliaria, matriculaInmobiliaria) ||
                other.matriculaInmobiliaria == matriculaInmobiliaria) &&
            (identical(other.estrato, estrato) || other.estrato == estrato) &&
            (identical(other.metrosCuadrados, metrosCuadrados) ||
                other.metrosCuadrados == metrosCuadrados) &&
            (identical(other.uso, uso) || other.uso == uso) &&
            (identical(other.valorCatastral, valorCatastral) ||
                other.valorCatastral == valorCatastral) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, assetId, matriculaInmobiliaria,
      estrato, metrosCuadrados, uso, valorCatastral, createdAt, updatedAt);

  @override
  String toString() {
    return 'AssetInmuebleEntity(assetId: $assetId, matriculaInmobiliaria: $matriculaInmobiliaria, estrato: $estrato, metrosCuadrados: $metrosCuadrados, uso: $uso, valorCatastral: $valorCatastral, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AssetInmuebleEntityCopyWith<$Res> {
  factory $AssetInmuebleEntityCopyWith(
          AssetInmuebleEntity value, $Res Function(AssetInmuebleEntity) _then) =
      _$AssetInmuebleEntityCopyWithImpl;
  @useResult
  $Res call(
      {String assetId,
      String matriculaInmobiliaria,
      int? estrato,
      double? metrosCuadrados,
      String uso,
      double? valorCatastral,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AssetInmuebleEntityCopyWithImpl<$Res>
    implements $AssetInmuebleEntityCopyWith<$Res> {
  _$AssetInmuebleEntityCopyWithImpl(this._self, this._then);

  final AssetInmuebleEntity _self;
  final $Res Function(AssetInmuebleEntity) _then;

  /// Create a copy of AssetInmuebleEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetId = null,
    Object? matriculaInmobiliaria = null,
    Object? estrato = freezed,
    Object? metrosCuadrados = freezed,
    Object? uso = null,
    Object? valorCatastral = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      matriculaInmobiliaria: null == matriculaInmobiliaria
          ? _self.matriculaInmobiliaria
          : matriculaInmobiliaria // ignore: cast_nullable_to_non_nullable
              as String,
      estrato: freezed == estrato
          ? _self.estrato
          : estrato // ignore: cast_nullable_to_non_nullable
              as int?,
      metrosCuadrados: freezed == metrosCuadrados
          ? _self.metrosCuadrados
          : metrosCuadrados // ignore: cast_nullable_to_non_nullable
              as double?,
      uso: null == uso
          ? _self.uso
          : uso // ignore: cast_nullable_to_non_nullable
              as String,
      valorCatastral: freezed == valorCatastral
          ? _self.valorCatastral
          : valorCatastral // ignore: cast_nullable_to_non_nullable
              as double?,
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

/// Adds pattern-matching-related methods to [AssetInmuebleEntity].
extension AssetInmuebleEntityPatterns on AssetInmuebleEntity {
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
    TResult Function(_AssetInmuebleEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetInmuebleEntity() when $default != null:
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
    TResult Function(_AssetInmuebleEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetInmuebleEntity():
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
    TResult? Function(_AssetInmuebleEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetInmuebleEntity() when $default != null:
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
            String matriculaInmobiliaria,
            int? estrato,
            double? metrosCuadrados,
            String uso,
            double? valorCatastral,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetInmuebleEntity() when $default != null:
        return $default(
            _that.assetId,
            _that.matriculaInmobiliaria,
            _that.estrato,
            _that.metrosCuadrados,
            _that.uso,
            _that.valorCatastral,
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
            String matriculaInmobiliaria,
            int? estrato,
            double? metrosCuadrados,
            String uso,
            double? valorCatastral,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetInmuebleEntity():
        return $default(
            _that.assetId,
            _that.matriculaInmobiliaria,
            _that.estrato,
            _that.metrosCuadrados,
            _that.uso,
            _that.valorCatastral,
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
            String matriculaInmobiliaria,
            int? estrato,
            double? metrosCuadrados,
            String uso,
            double? valorCatastral,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetInmuebleEntity() when $default != null:
        return $default(
            _that.assetId,
            _that.matriculaInmobiliaria,
            _that.estrato,
            _that.metrosCuadrados,
            _that.uso,
            _that.valorCatastral,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssetInmuebleEntity implements AssetInmuebleEntity {
  const _AssetInmuebleEntity(
      {required this.assetId,
      required this.matriculaInmobiliaria,
      this.estrato,
      this.metrosCuadrados,
      required this.uso,
      this.valorCatastral,
      this.createdAt,
      this.updatedAt});
  factory _AssetInmuebleEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetInmuebleEntityFromJson(json);

  @override
  final String assetId;
  @override
  final String matriculaInmobiliaria;
  @override
  final int? estrato;
  @override
  final double? metrosCuadrados;
  @override
  final String uso;
// residencial | comercial
  @override
  final double? valorCatastral;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of AssetInmuebleEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetInmuebleEntityCopyWith<_AssetInmuebleEntity> get copyWith =>
      __$AssetInmuebleEntityCopyWithImpl<_AssetInmuebleEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetInmuebleEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetInmuebleEntity &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.matriculaInmobiliaria, matriculaInmobiliaria) ||
                other.matriculaInmobiliaria == matriculaInmobiliaria) &&
            (identical(other.estrato, estrato) || other.estrato == estrato) &&
            (identical(other.metrosCuadrados, metrosCuadrados) ||
                other.metrosCuadrados == metrosCuadrados) &&
            (identical(other.uso, uso) || other.uso == uso) &&
            (identical(other.valorCatastral, valorCatastral) ||
                other.valorCatastral == valorCatastral) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, assetId, matriculaInmobiliaria,
      estrato, metrosCuadrados, uso, valorCatastral, createdAt, updatedAt);

  @override
  String toString() {
    return 'AssetInmuebleEntity(assetId: $assetId, matriculaInmobiliaria: $matriculaInmobiliaria, estrato: $estrato, metrosCuadrados: $metrosCuadrados, uso: $uso, valorCatastral: $valorCatastral, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AssetInmuebleEntityCopyWith<$Res>
    implements $AssetInmuebleEntityCopyWith<$Res> {
  factory _$AssetInmuebleEntityCopyWith(_AssetInmuebleEntity value,
          $Res Function(_AssetInmuebleEntity) _then) =
      __$AssetInmuebleEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String assetId,
      String matriculaInmobiliaria,
      int? estrato,
      double? metrosCuadrados,
      String uso,
      double? valorCatastral,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$AssetInmuebleEntityCopyWithImpl<$Res>
    implements _$AssetInmuebleEntityCopyWith<$Res> {
  __$AssetInmuebleEntityCopyWithImpl(this._self, this._then);

  final _AssetInmuebleEntity _self;
  final $Res Function(_AssetInmuebleEntity) _then;

  /// Create a copy of AssetInmuebleEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? assetId = null,
    Object? matriculaInmobiliaria = null,
    Object? estrato = freezed,
    Object? metrosCuadrados = freezed,
    Object? uso = null,
    Object? valorCatastral = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_AssetInmuebleEntity(
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      matriculaInmobiliaria: null == matriculaInmobiliaria
          ? _self.matriculaInmobiliaria
          : matriculaInmobiliaria // ignore: cast_nullable_to_non_nullable
              as String,
      estrato: freezed == estrato
          ? _self.estrato
          : estrato // ignore: cast_nullable_to_non_nullable
              as int?,
      metrosCuadrados: freezed == metrosCuadrados
          ? _self.metrosCuadrados
          : metrosCuadrados // ignore: cast_nullable_to_non_nullable
              as double?,
      uso: null == uso
          ? _self.uso
          : uso // ignore: cast_nullable_to_non_nullable
              as String,
      valorCatastral: freezed == valorCatastral
          ? _self.valorCatastral
          : valorCatastral // ignore: cast_nullable_to_non_nullable
              as double?,
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
