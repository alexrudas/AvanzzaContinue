// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier_response_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupplierResponseEntity {
  String get id;
  String get purchaseRequestId;
  String get proveedorId;
  double get precio;
  String get disponibilidad;
  String get currencyCode;
  String? get catalogoUrl;
  String? get notas;
  int? get leadTimeDays;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of SupplierResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SupplierResponseEntityCopyWith<SupplierResponseEntity> get copyWith =>
      _$SupplierResponseEntityCopyWithImpl<SupplierResponseEntity>(
          this as SupplierResponseEntity, _$identity);

  /// Serializes this SupplierResponseEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SupplierResponseEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.purchaseRequestId, purchaseRequestId) ||
                other.purchaseRequestId == purchaseRequestId) &&
            (identical(other.proveedorId, proveedorId) ||
                other.proveedorId == proveedorId) &&
            (identical(other.precio, precio) || other.precio == precio) &&
            (identical(other.disponibilidad, disponibilidad) ||
                other.disponibilidad == disponibilidad) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.catalogoUrl, catalogoUrl) ||
                other.catalogoUrl == catalogoUrl) &&
            (identical(other.notas, notas) || other.notas == notas) &&
            (identical(other.leadTimeDays, leadTimeDays) ||
                other.leadTimeDays == leadTimeDays) &&
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
      purchaseRequestId,
      proveedorId,
      precio,
      disponibilidad,
      currencyCode,
      catalogoUrl,
      notas,
      leadTimeDays,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'SupplierResponseEntity(id: $id, purchaseRequestId: $purchaseRequestId, proveedorId: $proveedorId, precio: $precio, disponibilidad: $disponibilidad, currencyCode: $currencyCode, catalogoUrl: $catalogoUrl, notas: $notas, leadTimeDays: $leadTimeDays, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $SupplierResponseEntityCopyWith<$Res> {
  factory $SupplierResponseEntityCopyWith(SupplierResponseEntity value,
          $Res Function(SupplierResponseEntity) _then) =
      _$SupplierResponseEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String purchaseRequestId,
      String proveedorId,
      double precio,
      String disponibilidad,
      String currencyCode,
      String? catalogoUrl,
      String? notas,
      int? leadTimeDays,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$SupplierResponseEntityCopyWithImpl<$Res>
    implements $SupplierResponseEntityCopyWith<$Res> {
  _$SupplierResponseEntityCopyWithImpl(this._self, this._then);

  final SupplierResponseEntity _self;
  final $Res Function(SupplierResponseEntity) _then;

  /// Create a copy of SupplierResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? purchaseRequestId = null,
    Object? proveedorId = null,
    Object? precio = null,
    Object? disponibilidad = null,
    Object? currencyCode = null,
    Object? catalogoUrl = freezed,
    Object? notas = freezed,
    Object? leadTimeDays = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseRequestId: null == purchaseRequestId
          ? _self.purchaseRequestId
          : purchaseRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      proveedorId: null == proveedorId
          ? _self.proveedorId
          : proveedorId // ignore: cast_nullable_to_non_nullable
              as String,
      precio: null == precio
          ? _self.precio
          : precio // ignore: cast_nullable_to_non_nullable
              as double,
      disponibilidad: null == disponibilidad
          ? _self.disponibilidad
          : disponibilidad // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      catalogoUrl: freezed == catalogoUrl
          ? _self.catalogoUrl
          : catalogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notas: freezed == notas
          ? _self.notas
          : notas // ignore: cast_nullable_to_non_nullable
              as String?,
      leadTimeDays: freezed == leadTimeDays
          ? _self.leadTimeDays
          : leadTimeDays // ignore: cast_nullable_to_non_nullable
              as int?,
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

/// Adds pattern-matching-related methods to [SupplierResponseEntity].
extension SupplierResponseEntityPatterns on SupplierResponseEntity {
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
    TResult Function(_SupplierResponseEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupplierResponseEntity() when $default != null:
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
    TResult Function(_SupplierResponseEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierResponseEntity():
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
    TResult? Function(_SupplierResponseEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierResponseEntity() when $default != null:
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
            String purchaseRequestId,
            String proveedorId,
            double precio,
            String disponibilidad,
            String currencyCode,
            String? catalogoUrl,
            String? notas,
            int? leadTimeDays,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupplierResponseEntity() when $default != null:
        return $default(
            _that.id,
            _that.purchaseRequestId,
            _that.proveedorId,
            _that.precio,
            _that.disponibilidad,
            _that.currencyCode,
            _that.catalogoUrl,
            _that.notas,
            _that.leadTimeDays,
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
            String purchaseRequestId,
            String proveedorId,
            double precio,
            String disponibilidad,
            String currencyCode,
            String? catalogoUrl,
            String? notas,
            int? leadTimeDays,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierResponseEntity():
        return $default(
            _that.id,
            _that.purchaseRequestId,
            _that.proveedorId,
            _that.precio,
            _that.disponibilidad,
            _that.currencyCode,
            _that.catalogoUrl,
            _that.notas,
            _that.leadTimeDays,
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
            String purchaseRequestId,
            String proveedorId,
            double precio,
            String disponibilidad,
            String currencyCode,
            String? catalogoUrl,
            String? notas,
            int? leadTimeDays,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierResponseEntity() when $default != null:
        return $default(
            _that.id,
            _that.purchaseRequestId,
            _that.proveedorId,
            _that.precio,
            _that.disponibilidad,
            _that.currencyCode,
            _that.catalogoUrl,
            _that.notas,
            _that.leadTimeDays,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SupplierResponseEntity implements SupplierResponseEntity {
  const _SupplierResponseEntity(
      {required this.id,
      required this.purchaseRequestId,
      required this.proveedorId,
      required this.precio,
      required this.disponibilidad,
      required this.currencyCode,
      this.catalogoUrl,
      this.notas,
      this.leadTimeDays,
      this.createdAt,
      this.updatedAt});
  factory _SupplierResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$SupplierResponseEntityFromJson(json);

  @override
  final String id;
  @override
  final String purchaseRequestId;
  @override
  final String proveedorId;
  @override
  final double precio;
  @override
  final String disponibilidad;
  @override
  final String currencyCode;
  @override
  final String? catalogoUrl;
  @override
  final String? notas;
  @override
  final int? leadTimeDays;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of SupplierResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SupplierResponseEntityCopyWith<_SupplierResponseEntity> get copyWith =>
      __$SupplierResponseEntityCopyWithImpl<_SupplierResponseEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SupplierResponseEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SupplierResponseEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.purchaseRequestId, purchaseRequestId) ||
                other.purchaseRequestId == purchaseRequestId) &&
            (identical(other.proveedorId, proveedorId) ||
                other.proveedorId == proveedorId) &&
            (identical(other.precio, precio) || other.precio == precio) &&
            (identical(other.disponibilidad, disponibilidad) ||
                other.disponibilidad == disponibilidad) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.catalogoUrl, catalogoUrl) ||
                other.catalogoUrl == catalogoUrl) &&
            (identical(other.notas, notas) || other.notas == notas) &&
            (identical(other.leadTimeDays, leadTimeDays) ||
                other.leadTimeDays == leadTimeDays) &&
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
      purchaseRequestId,
      proveedorId,
      precio,
      disponibilidad,
      currencyCode,
      catalogoUrl,
      notas,
      leadTimeDays,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'SupplierResponseEntity(id: $id, purchaseRequestId: $purchaseRequestId, proveedorId: $proveedorId, precio: $precio, disponibilidad: $disponibilidad, currencyCode: $currencyCode, catalogoUrl: $catalogoUrl, notas: $notas, leadTimeDays: $leadTimeDays, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$SupplierResponseEntityCopyWith<$Res>
    implements $SupplierResponseEntityCopyWith<$Res> {
  factory _$SupplierResponseEntityCopyWith(_SupplierResponseEntity value,
          $Res Function(_SupplierResponseEntity) _then) =
      __$SupplierResponseEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String purchaseRequestId,
      String proveedorId,
      double precio,
      String disponibilidad,
      String currencyCode,
      String? catalogoUrl,
      String? notas,
      int? leadTimeDays,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$SupplierResponseEntityCopyWithImpl<$Res>
    implements _$SupplierResponseEntityCopyWith<$Res> {
  __$SupplierResponseEntityCopyWithImpl(this._self, this._then);

  final _SupplierResponseEntity _self;
  final $Res Function(_SupplierResponseEntity) _then;

  /// Create a copy of SupplierResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? purchaseRequestId = null,
    Object? proveedorId = null,
    Object? precio = null,
    Object? disponibilidad = null,
    Object? currencyCode = null,
    Object? catalogoUrl = freezed,
    Object? notas = freezed,
    Object? leadTimeDays = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_SupplierResponseEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseRequestId: null == purchaseRequestId
          ? _self.purchaseRequestId
          : purchaseRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      proveedorId: null == proveedorId
          ? _self.proveedorId
          : proveedorId // ignore: cast_nullable_to_non_nullable
              as String,
      precio: null == precio
          ? _self.precio
          : precio // ignore: cast_nullable_to_non_nullable
              as double,
      disponibilidad: null == disponibilidad
          ? _self.disponibilidad
          : disponibilidad // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      catalogoUrl: freezed == catalogoUrl
          ? _self.catalogoUrl
          : catalogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notas: freezed == notas
          ? _self.notas
          : notas // ignore: cast_nullable_to_non_nullable
              as String?,
      leadTimeDays: freezed == leadTimeDays
          ? _self.leadTimeDays
          : leadTimeDays // ignore: cast_nullable_to_non_nullable
              as int?,
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
