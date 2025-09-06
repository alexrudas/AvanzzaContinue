// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insurance_purchase_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InsurancePurchaseEntity {
  String get id;
  String get assetId;
  String get compradorId;
  String get orgId;
  String get contactEmail;
  AddressEntity get address;
  String get currencyCode;
  String get estadoCompra; // pendiente | pagado | confirmado
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of InsurancePurchaseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InsurancePurchaseEntityCopyWith<InsurancePurchaseEntity> get copyWith =>
      _$InsurancePurchaseEntityCopyWithImpl<InsurancePurchaseEntity>(
          this as InsurancePurchaseEntity, _$identity);

  /// Serializes this InsurancePurchaseEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InsurancePurchaseEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.compradorId, compradorId) ||
                other.compradorId == compradorId) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.estadoCompra, estadoCompra) ||
                other.estadoCompra == estadoCompra) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, assetId, compradorId, orgId,
      contactEmail, address, currencyCode, estadoCompra, createdAt, updatedAt);

  @override
  String toString() {
    return 'InsurancePurchaseEntity(id: $id, assetId: $assetId, compradorId: $compradorId, orgId: $orgId, contactEmail: $contactEmail, address: $address, currencyCode: $currencyCode, estadoCompra: $estadoCompra, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $InsurancePurchaseEntityCopyWith<$Res> {
  factory $InsurancePurchaseEntityCopyWith(InsurancePurchaseEntity value,
          $Res Function(InsurancePurchaseEntity) _then) =
      _$InsurancePurchaseEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String assetId,
      String compradorId,
      String orgId,
      String contactEmail,
      AddressEntity address,
      String currencyCode,
      String estadoCompra,
      DateTime? createdAt,
      DateTime? updatedAt});

  $AddressEntityCopyWith<$Res> get address;
}

/// @nodoc
class _$InsurancePurchaseEntityCopyWithImpl<$Res>
    implements $InsurancePurchaseEntityCopyWith<$Res> {
  _$InsurancePurchaseEntityCopyWithImpl(this._self, this._then);

  final InsurancePurchaseEntity _self;
  final $Res Function(InsurancePurchaseEntity) _then;

  /// Create a copy of InsurancePurchaseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assetId = null,
    Object? compradorId = null,
    Object? orgId = null,
    Object? contactEmail = null,
    Object? address = null,
    Object? currencyCode = null,
    Object? estadoCompra = null,
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
      compradorId: null == compradorId
          ? _self.compradorId
          : compradorId // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      contactEmail: null == contactEmail
          ? _self.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as AddressEntity,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      estadoCompra: null == estadoCompra
          ? _self.estadoCompra
          : estadoCompra // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of InsurancePurchaseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressEntityCopyWith<$Res> get address {
    return $AddressEntityCopyWith<$Res>(_self.address, (value) {
      return _then(_self.copyWith(address: value));
    });
  }
}

/// Adds pattern-matching-related methods to [InsurancePurchaseEntity].
extension InsurancePurchaseEntityPatterns on InsurancePurchaseEntity {
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
    TResult Function(_InsurancePurchaseEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InsurancePurchaseEntity() when $default != null:
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
    TResult Function(_InsurancePurchaseEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsurancePurchaseEntity():
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
    TResult? Function(_InsurancePurchaseEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsurancePurchaseEntity() when $default != null:
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
            String compradorId,
            String orgId,
            String contactEmail,
            AddressEntity address,
            String currencyCode,
            String estadoCompra,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InsurancePurchaseEntity() when $default != null:
        return $default(
            _that.id,
            _that.assetId,
            _that.compradorId,
            _that.orgId,
            _that.contactEmail,
            _that.address,
            _that.currencyCode,
            _that.estadoCompra,
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
            String compradorId,
            String orgId,
            String contactEmail,
            AddressEntity address,
            String currencyCode,
            String estadoCompra,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsurancePurchaseEntity():
        return $default(
            _that.id,
            _that.assetId,
            _that.compradorId,
            _that.orgId,
            _that.contactEmail,
            _that.address,
            _that.currencyCode,
            _that.estadoCompra,
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
            String compradorId,
            String orgId,
            String contactEmail,
            AddressEntity address,
            String currencyCode,
            String estadoCompra,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsurancePurchaseEntity() when $default != null:
        return $default(
            _that.id,
            _that.assetId,
            _that.compradorId,
            _that.orgId,
            _that.contactEmail,
            _that.address,
            _that.currencyCode,
            _that.estadoCompra,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _InsurancePurchaseEntity implements InsurancePurchaseEntity {
  const _InsurancePurchaseEntity(
      {required this.id,
      required this.assetId,
      required this.compradorId,
      required this.orgId,
      required this.contactEmail,
      required this.address,
      required this.currencyCode,
      required this.estadoCompra,
      this.createdAt,
      this.updatedAt});
  factory _InsurancePurchaseEntity.fromJson(Map<String, dynamic> json) =>
      _$InsurancePurchaseEntityFromJson(json);

  @override
  final String id;
  @override
  final String assetId;
  @override
  final String compradorId;
  @override
  final String orgId;
  @override
  final String contactEmail;
  @override
  final AddressEntity address;
  @override
  final String currencyCode;
  @override
  final String estadoCompra;
// pendiente | pagado | confirmado
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of InsurancePurchaseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InsurancePurchaseEntityCopyWith<_InsurancePurchaseEntity> get copyWith =>
      __$InsurancePurchaseEntityCopyWithImpl<_InsurancePurchaseEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InsurancePurchaseEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InsurancePurchaseEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.compradorId, compradorId) ||
                other.compradorId == compradorId) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.estadoCompra, estadoCompra) ||
                other.estadoCompra == estadoCompra) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, assetId, compradorId, orgId,
      contactEmail, address, currencyCode, estadoCompra, createdAt, updatedAt);

  @override
  String toString() {
    return 'InsurancePurchaseEntity(id: $id, assetId: $assetId, compradorId: $compradorId, orgId: $orgId, contactEmail: $contactEmail, address: $address, currencyCode: $currencyCode, estadoCompra: $estadoCompra, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$InsurancePurchaseEntityCopyWith<$Res>
    implements $InsurancePurchaseEntityCopyWith<$Res> {
  factory _$InsurancePurchaseEntityCopyWith(_InsurancePurchaseEntity value,
          $Res Function(_InsurancePurchaseEntity) _then) =
      __$InsurancePurchaseEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String assetId,
      String compradorId,
      String orgId,
      String contactEmail,
      AddressEntity address,
      String currencyCode,
      String estadoCompra,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $AddressEntityCopyWith<$Res> get address;
}

/// @nodoc
class __$InsurancePurchaseEntityCopyWithImpl<$Res>
    implements _$InsurancePurchaseEntityCopyWith<$Res> {
  __$InsurancePurchaseEntityCopyWithImpl(this._self, this._then);

  final _InsurancePurchaseEntity _self;
  final $Res Function(_InsurancePurchaseEntity) _then;

  /// Create a copy of InsurancePurchaseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? assetId = null,
    Object? compradorId = null,
    Object? orgId = null,
    Object? contactEmail = null,
    Object? address = null,
    Object? currencyCode = null,
    Object? estadoCompra = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_InsurancePurchaseEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      compradorId: null == compradorId
          ? _self.compradorId
          : compradorId // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      contactEmail: null == contactEmail
          ? _self.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as AddressEntity,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      estadoCompra: null == estadoCompra
          ? _self.estadoCompra
          : estadoCompra // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of InsurancePurchaseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressEntityCopyWith<$Res> get address {
    return $AddressEntityCopyWith<$Res>(_self.address, (value) {
      return _then(_self.copyWith(address: value));
    });
  }
}

// dart format on
