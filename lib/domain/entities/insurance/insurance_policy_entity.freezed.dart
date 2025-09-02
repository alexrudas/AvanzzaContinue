// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insurance_policy_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InsurancePolicyEntity {
  String get id;
  String get assetId;
  String get tipo; // SOAT | todo_riesgo | inmueble
  String get aseguradora;
  double get tarifaBase;
  String get currencyCode;
  String get countryId;
  String? get cityId;
  DateTime get fechaInicio;
  DateTime get fechaFin;
  String get estado; // vigente | vencido | por_vencer
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of InsurancePolicyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InsurancePolicyEntityCopyWith<InsurancePolicyEntity> get copyWith =>
      _$InsurancePolicyEntityCopyWithImpl<InsurancePolicyEntity>(
          this as InsurancePolicyEntity, _$identity);

  /// Serializes this InsurancePolicyEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InsurancePolicyEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.aseguradora, aseguradora) ||
                other.aseguradora == aseguradora) &&
            (identical(other.tarifaBase, tarifaBase) ||
                other.tarifaBase == tarifaBase) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.fechaInicio, fechaInicio) ||
                other.fechaInicio == fechaInicio) &&
            (identical(other.fechaFin, fechaFin) ||
                other.fechaFin == fechaFin) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      assetId,
      tipo,
      aseguradora,
      tarifaBase,
      currencyCode,
      countryId,
      cityId,
      fechaInicio,
      fechaFin,
      estado,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'InsurancePolicyEntity(id: $id, assetId: $assetId, tipo: $tipo, aseguradora: $aseguradora, tarifaBase: $tarifaBase, currencyCode: $currencyCode, countryId: $countryId, cityId: $cityId, fechaInicio: $fechaInicio, fechaFin: $fechaFin, estado: $estado, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $InsurancePolicyEntityCopyWith<$Res> {
  factory $InsurancePolicyEntityCopyWith(InsurancePolicyEntity value,
          $Res Function(InsurancePolicyEntity) _then) =
      _$InsurancePolicyEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String assetId,
      String tipo,
      String aseguradora,
      double tarifaBase,
      String currencyCode,
      String countryId,
      String? cityId,
      DateTime fechaInicio,
      DateTime fechaFin,
      String estado,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$InsurancePolicyEntityCopyWithImpl<$Res>
    implements $InsurancePolicyEntityCopyWith<$Res> {
  _$InsurancePolicyEntityCopyWithImpl(this._self, this._then);

  final InsurancePolicyEntity _self;
  final $Res Function(InsurancePolicyEntity) _then;

  /// Create a copy of InsurancePolicyEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assetId = null,
    Object? tipo = null,
    Object? aseguradora = null,
    Object? tarifaBase = null,
    Object? currencyCode = null,
    Object? countryId = null,
    Object? cityId = freezed,
    Object? fechaInicio = null,
    Object? fechaFin = null,
    Object? estado = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _self.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      aseguradora: null == aseguradora
          ? _self.aseguradora
          : aseguradora // ignore: cast_nullable_to_non_nullable
              as String,
      tarifaBase: null == tarifaBase
          ? _self.tarifaBase
          : tarifaBase // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaInicio: null == fechaInicio
          ? _self.fechaInicio
          : fechaInicio // ignore: cast_nullable_to_non_nullable
              as DateTime,
      fechaFin: null == fechaFin
          ? _self.fechaFin
          : fechaFin // ignore: cast_nullable_to_non_nullable
              as DateTime,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
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

/// Adds pattern-matching-related methods to [InsurancePolicyEntity].
extension InsurancePolicyEntityPatterns on InsurancePolicyEntity {
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
    TResult Function(_InsurancePolicyEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InsurancePolicyEntity() when $default != null:
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
    TResult Function(_InsurancePolicyEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsurancePolicyEntity():
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
    TResult? Function(_InsurancePolicyEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsurancePolicyEntity() when $default != null:
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
            String id,
            String assetId,
            String tipo,
            String aseguradora,
            double tarifaBase,
            String currencyCode,
            String countryId,
            String? cityId,
            DateTime fechaInicio,
            DateTime fechaFin,
            String estado,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InsurancePolicyEntity() when $default != null:
        return $default(
            _that.id,
            _that.assetId,
            _that.tipo,
            _that.aseguradora,
            _that.tarifaBase,
            _that.currencyCode,
            _that.countryId,
            _that.cityId,
            _that.fechaInicio,
            _that.fechaFin,
            _that.estado,
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
            String id,
            String assetId,
            String tipo,
            String aseguradora,
            double tarifaBase,
            String currencyCode,
            String countryId,
            String? cityId,
            DateTime fechaInicio,
            DateTime fechaFin,
            String estado,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsurancePolicyEntity():
        return $default(
            _that.id,
            _that.assetId,
            _that.tipo,
            _that.aseguradora,
            _that.tarifaBase,
            _that.currencyCode,
            _that.countryId,
            _that.cityId,
            _that.fechaInicio,
            _that.fechaFin,
            _that.estado,
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
            String id,
            String assetId,
            String tipo,
            String aseguradora,
            double tarifaBase,
            String currencyCode,
            String countryId,
            String? cityId,
            DateTime fechaInicio,
            DateTime fechaFin,
            String estado,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsurancePolicyEntity() when $default != null:
        return $default(
            _that.id,
            _that.assetId,
            _that.tipo,
            _that.aseguradora,
            _that.tarifaBase,
            _that.currencyCode,
            _that.countryId,
            _that.cityId,
            _that.fechaInicio,
            _that.fechaFin,
            _that.estado,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _InsurancePolicyEntity implements InsurancePolicyEntity {
  const _InsurancePolicyEntity(
      {required this.id,
      required this.assetId,
      required this.tipo,
      required this.aseguradora,
      required this.tarifaBase,
      required this.currencyCode,
      required this.countryId,
      this.cityId,
      required this.fechaInicio,
      required this.fechaFin,
      required this.estado,
      this.createdAt,
      this.updatedAt});
  factory _InsurancePolicyEntity.fromJson(Map<String, dynamic> json) =>
      _$InsurancePolicyEntityFromJson(json);

  @override
  final String id;
  @override
  final String assetId;
  @override
  final String tipo;
// SOAT | todo_riesgo | inmueble
  @override
  final String aseguradora;
  @override
  final double tarifaBase;
  @override
  final String currencyCode;
  @override
  final String countryId;
  @override
  final String? cityId;
  @override
  final DateTime fechaInicio;
  @override
  final DateTime fechaFin;
  @override
  final String estado;
// vigente | vencido | por_vencer
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of InsurancePolicyEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InsurancePolicyEntityCopyWith<_InsurancePolicyEntity> get copyWith =>
      __$InsurancePolicyEntityCopyWithImpl<_InsurancePolicyEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InsurancePolicyEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InsurancePolicyEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.aseguradora, aseguradora) ||
                other.aseguradora == aseguradora) &&
            (identical(other.tarifaBase, tarifaBase) ||
                other.tarifaBase == tarifaBase) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.fechaInicio, fechaInicio) ||
                other.fechaInicio == fechaInicio) &&
            (identical(other.fechaFin, fechaFin) ||
                other.fechaFin == fechaFin) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      assetId,
      tipo,
      aseguradora,
      tarifaBase,
      currencyCode,
      countryId,
      cityId,
      fechaInicio,
      fechaFin,
      estado,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'InsurancePolicyEntity(id: $id, assetId: $assetId, tipo: $tipo, aseguradora: $aseguradora, tarifaBase: $tarifaBase, currencyCode: $currencyCode, countryId: $countryId, cityId: $cityId, fechaInicio: $fechaInicio, fechaFin: $fechaFin, estado: $estado, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$InsurancePolicyEntityCopyWith<$Res>
    implements $InsurancePolicyEntityCopyWith<$Res> {
  factory _$InsurancePolicyEntityCopyWith(_InsurancePolicyEntity value,
          $Res Function(_InsurancePolicyEntity) _then) =
      __$InsurancePolicyEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String assetId,
      String tipo,
      String aseguradora,
      double tarifaBase,
      String currencyCode,
      String countryId,
      String? cityId,
      DateTime fechaInicio,
      DateTime fechaFin,
      String estado,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$InsurancePolicyEntityCopyWithImpl<$Res>
    implements _$InsurancePolicyEntityCopyWith<$Res> {
  __$InsurancePolicyEntityCopyWithImpl(this._self, this._then);

  final _InsurancePolicyEntity _self;
  final $Res Function(_InsurancePolicyEntity) _then;

  /// Create a copy of InsurancePolicyEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? assetId = null,
    Object? tipo = null,
    Object? aseguradora = null,
    Object? tarifaBase = null,
    Object? currencyCode = null,
    Object? countryId = null,
    Object? cityId = freezed,
    Object? fechaInicio = null,
    Object? fechaFin = null,
    Object? estado = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_InsurancePolicyEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _self.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      aseguradora: null == aseguradora
          ? _self.aseguradora
          : aseguradora // ignore: cast_nullable_to_non_nullable
              as String,
      tarifaBase: null == tarifaBase
          ? _self.tarifaBase
          : tarifaBase // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaInicio: null == fechaInicio
          ? _self.fechaInicio
          : fechaInicio // ignore: cast_nullable_to_non_nullable
              as DateTime,
      fechaFin: null == fechaFin
          ? _self.fechaFin
          : fechaFin // ignore: cast_nullable_to_non_nullable
              as DateTime,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
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
