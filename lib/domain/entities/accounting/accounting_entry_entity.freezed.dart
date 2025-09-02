// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_entry_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountingEntryEntity {
  String get id;
  String get orgId;
  String get countryId;
  String? get cityId;
  String get tipo;
  double get monto;
  String get currencyCode;
  String get descripcion;
  DateTime get fecha; // required, no @Default here
  String get referenciaType;
  String get referenciaId;
  String? get counterpartyId;
  String get method;
  double get taxAmount;
  double get taxRate;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of AccountingEntryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountingEntryEntityCopyWith<AccountingEntryEntity> get copyWith =>
      _$AccountingEntryEntityCopyWithImpl<AccountingEntryEntity>(
          this as AccountingEntryEntity, _$identity);

  /// Serializes this AccountingEntryEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountingEntryEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.monto, monto) || other.monto == monto) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.referenciaType, referenciaType) ||
                other.referenciaType == referenciaType) &&
            (identical(other.referenciaId, referenciaId) ||
                other.referenciaId == referenciaId) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
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
      orgId,
      countryId,
      cityId,
      tipo,
      monto,
      currencyCode,
      descripcion,
      fecha,
      referenciaType,
      referenciaId,
      counterpartyId,
      method,
      taxAmount,
      taxRate,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AccountingEntryEntity(id: $id, orgId: $orgId, countryId: $countryId, cityId: $cityId, tipo: $tipo, monto: $monto, currencyCode: $currencyCode, descripcion: $descripcion, fecha: $fecha, referenciaType: $referenciaType, referenciaId: $referenciaId, counterpartyId: $counterpartyId, method: $method, taxAmount: $taxAmount, taxRate: $taxRate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AccountingEntryEntityCopyWith<$Res> {
  factory $AccountingEntryEntityCopyWith(AccountingEntryEntity value,
          $Res Function(AccountingEntryEntity) _then) =
      _$AccountingEntryEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String countryId,
      String? cityId,
      String tipo,
      double monto,
      String currencyCode,
      String descripcion,
      DateTime fecha,
      String referenciaType,
      String referenciaId,
      String? counterpartyId,
      String method,
      double taxAmount,
      double taxRate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AccountingEntryEntityCopyWithImpl<$Res>
    implements $AccountingEntryEntityCopyWith<$Res> {
  _$AccountingEntryEntityCopyWithImpl(this._self, this._then);

  final AccountingEntryEntity _self;
  final $Res Function(AccountingEntryEntity) _then;

  /// Create a copy of AccountingEntryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? countryId = null,
    Object? cityId = freezed,
    Object? tipo = null,
    Object? monto = null,
    Object? currencyCode = null,
    Object? descripcion = null,
    Object? fecha = null,
    Object? referenciaType = null,
    Object? referenciaId = null,
    Object? counterpartyId = freezed,
    Object? method = null,
    Object? taxAmount = null,
    Object? taxRate = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      tipo: null == tipo
          ? _self.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      monto: null == monto
          ? _self.monto
          : monto // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      descripcion: null == descripcion
          ? _self.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String,
      fecha: null == fecha
          ? _self.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as DateTime,
      referenciaType: null == referenciaType
          ? _self.referenciaType
          : referenciaType // ignore: cast_nullable_to_non_nullable
              as String,
      referenciaId: null == referenciaId
          ? _self.referenciaId
          : referenciaId // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyId: freezed == counterpartyId
          ? _self.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      method: null == method
          ? _self.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      taxAmount: null == taxAmount
          ? _self.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      taxRate: null == taxRate
          ? _self.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
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

/// Adds pattern-matching-related methods to [AccountingEntryEntity].
extension AccountingEntryEntityPatterns on AccountingEntryEntity {
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
    TResult Function(_AccountingEntryEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountingEntryEntity() when $default != null:
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
    TResult Function(_AccountingEntryEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountingEntryEntity():
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
    TResult? Function(_AccountingEntryEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountingEntryEntity() when $default != null:
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
            String orgId,
            String countryId,
            String? cityId,
            String tipo,
            double monto,
            String currencyCode,
            String descripcion,
            DateTime fecha,
            String referenciaType,
            String referenciaId,
            String? counterpartyId,
            String method,
            double taxAmount,
            double taxRate,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountingEntryEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.countryId,
            _that.cityId,
            _that.tipo,
            _that.monto,
            _that.currencyCode,
            _that.descripcion,
            _that.fecha,
            _that.referenciaType,
            _that.referenciaId,
            _that.counterpartyId,
            _that.method,
            _that.taxAmount,
            _that.taxRate,
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
            String orgId,
            String countryId,
            String? cityId,
            String tipo,
            double monto,
            String currencyCode,
            String descripcion,
            DateTime fecha,
            String referenciaType,
            String referenciaId,
            String? counterpartyId,
            String method,
            double taxAmount,
            double taxRate,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountingEntryEntity():
        return $default(
            _that.id,
            _that.orgId,
            _that.countryId,
            _that.cityId,
            _that.tipo,
            _that.monto,
            _that.currencyCode,
            _that.descripcion,
            _that.fecha,
            _that.referenciaType,
            _that.referenciaId,
            _that.counterpartyId,
            _that.method,
            _that.taxAmount,
            _that.taxRate,
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
            String orgId,
            String countryId,
            String? cityId,
            String tipo,
            double monto,
            String currencyCode,
            String descripcion,
            DateTime fecha,
            String referenciaType,
            String referenciaId,
            String? counterpartyId,
            String method,
            double taxAmount,
            double taxRate,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountingEntryEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.countryId,
            _that.cityId,
            _that.tipo,
            _that.monto,
            _that.currencyCode,
            _that.descripcion,
            _that.fecha,
            _that.referenciaType,
            _that.referenciaId,
            _that.counterpartyId,
            _that.method,
            _that.taxAmount,
            _that.taxRate,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AccountingEntryEntity implements AccountingEntryEntity {
  const _AccountingEntryEntity(
      {this.id = '',
      this.orgId = '',
      this.countryId = '',
      this.cityId,
      this.tipo = 'ingreso',
      this.monto = 0.0,
      this.currencyCode = 'COP',
      this.descripcion = '',
      required this.fecha,
      this.referenciaType = '',
      this.referenciaId = '',
      this.counterpartyId,
      this.method = 'cash',
      this.taxAmount = 0.0,
      this.taxRate = 0.0,
      this.createdAt,
      this.updatedAt});
  factory _AccountingEntryEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountingEntryEntityFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String orgId;
  @override
  @JsonKey()
  final String countryId;
  @override
  final String? cityId;
  @override
  @JsonKey()
  final String tipo;
  @override
  @JsonKey()
  final double monto;
  @override
  @JsonKey()
  final String currencyCode;
  @override
  @JsonKey()
  final String descripcion;
  @override
  final DateTime fecha;
// required, no @Default here
  @override
  @JsonKey()
  final String referenciaType;
  @override
  @JsonKey()
  final String referenciaId;
  @override
  final String? counterpartyId;
  @override
  @JsonKey()
  final String method;
  @override
  @JsonKey()
  final double taxAmount;
  @override
  @JsonKey()
  final double taxRate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of AccountingEntryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccountingEntryEntityCopyWith<_AccountingEntryEntity> get copyWith =>
      __$AccountingEntryEntityCopyWithImpl<_AccountingEntryEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccountingEntryEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountingEntryEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.monto, monto) || other.monto == monto) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.referenciaType, referenciaType) ||
                other.referenciaType == referenciaType) &&
            (identical(other.referenciaId, referenciaId) ||
                other.referenciaId == referenciaId) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
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
      orgId,
      countryId,
      cityId,
      tipo,
      monto,
      currencyCode,
      descripcion,
      fecha,
      referenciaType,
      referenciaId,
      counterpartyId,
      method,
      taxAmount,
      taxRate,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AccountingEntryEntity(id: $id, orgId: $orgId, countryId: $countryId, cityId: $cityId, tipo: $tipo, monto: $monto, currencyCode: $currencyCode, descripcion: $descripcion, fecha: $fecha, referenciaType: $referenciaType, referenciaId: $referenciaId, counterpartyId: $counterpartyId, method: $method, taxAmount: $taxAmount, taxRate: $taxRate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AccountingEntryEntityCopyWith<$Res>
    implements $AccountingEntryEntityCopyWith<$Res> {
  factory _$AccountingEntryEntityCopyWith(_AccountingEntryEntity value,
          $Res Function(_AccountingEntryEntity) _then) =
      __$AccountingEntryEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String countryId,
      String? cityId,
      String tipo,
      double monto,
      String currencyCode,
      String descripcion,
      DateTime fecha,
      String referenciaType,
      String referenciaId,
      String? counterpartyId,
      String method,
      double taxAmount,
      double taxRate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$AccountingEntryEntityCopyWithImpl<$Res>
    implements _$AccountingEntryEntityCopyWith<$Res> {
  __$AccountingEntryEntityCopyWithImpl(this._self, this._then);

  final _AccountingEntryEntity _self;
  final $Res Function(_AccountingEntryEntity) _then;

  /// Create a copy of AccountingEntryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? countryId = null,
    Object? cityId = freezed,
    Object? tipo = null,
    Object? monto = null,
    Object? currencyCode = null,
    Object? descripcion = null,
    Object? fecha = null,
    Object? referenciaType = null,
    Object? referenciaId = null,
    Object? counterpartyId = freezed,
    Object? method = null,
    Object? taxAmount = null,
    Object? taxRate = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_AccountingEntryEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      tipo: null == tipo
          ? _self.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      monto: null == monto
          ? _self.monto
          : monto // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      descripcion: null == descripcion
          ? _self.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String,
      fecha: null == fecha
          ? _self.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as DateTime,
      referenciaType: null == referenciaType
          ? _self.referenciaType
          : referenciaType // ignore: cast_nullable_to_non_nullable
              as String,
      referenciaId: null == referenciaId
          ? _self.referenciaId
          : referenciaId // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyId: freezed == counterpartyId
          ? _self.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      method: null == method
          ? _self.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      taxAmount: null == taxAmount
          ? _self.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      taxRate: null == taxRate
          ? _self.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
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
