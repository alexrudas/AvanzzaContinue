// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_document_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetDocumentEntity {
  String get id;
  String get assetId;
  String get tipoDoc;
  String get countryId;
  String? get cityId;
  DateTime? get fechaEmision;
  DateTime? get fechaVencimiento;
  String get estado; // vigente | vencido | por_vencer
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of AssetDocumentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetDocumentEntityCopyWith<AssetDocumentEntity> get copyWith =>
      _$AssetDocumentEntityCopyWithImpl<AssetDocumentEntity>(
          this as AssetDocumentEntity, _$identity);

  /// Serializes this AssetDocumentEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetDocumentEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.tipoDoc, tipoDoc) || other.tipoDoc == tipoDoc) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.fechaEmision, fechaEmision) ||
                other.fechaEmision == fechaEmision) &&
            (identical(other.fechaVencimiento, fechaVencimiento) ||
                other.fechaVencimiento == fechaVencimiento) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, assetId, tipoDoc, countryId,
      cityId, fechaEmision, fechaVencimiento, estado, createdAt, updatedAt);

  @override
  String toString() {
    return 'AssetDocumentEntity(id: $id, assetId: $assetId, tipoDoc: $tipoDoc, countryId: $countryId, cityId: $cityId, fechaEmision: $fechaEmision, fechaVencimiento: $fechaVencimiento, estado: $estado, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AssetDocumentEntityCopyWith<$Res> {
  factory $AssetDocumentEntityCopyWith(
          AssetDocumentEntity value, $Res Function(AssetDocumentEntity) _then) =
      _$AssetDocumentEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String assetId,
      String tipoDoc,
      String countryId,
      String? cityId,
      DateTime? fechaEmision,
      DateTime? fechaVencimiento,
      String estado,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AssetDocumentEntityCopyWithImpl<$Res>
    implements $AssetDocumentEntityCopyWith<$Res> {
  _$AssetDocumentEntityCopyWithImpl(this._self, this._then);

  final AssetDocumentEntity _self;
  final $Res Function(AssetDocumentEntity) _then;

  /// Create a copy of AssetDocumentEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assetId = null,
    Object? tipoDoc = null,
    Object? countryId = null,
    Object? cityId = freezed,
    Object? fechaEmision = freezed,
    Object? fechaVencimiento = freezed,
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
      tipoDoc: null == tipoDoc
          ? _self.tipoDoc
          : tipoDoc // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaEmision: freezed == fechaEmision
          ? _self.fechaEmision
          : fechaEmision // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      fechaVencimiento: freezed == fechaVencimiento
          ? _self.fechaVencimiento
          : fechaVencimiento // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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

/// Adds pattern-matching-related methods to [AssetDocumentEntity].
extension AssetDocumentEntityPatterns on AssetDocumentEntity {
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
    TResult Function(_AssetDocumentEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetDocumentEntity() when $default != null:
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
    TResult Function(_AssetDocumentEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetDocumentEntity():
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
    TResult? Function(_AssetDocumentEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetDocumentEntity() when $default != null:
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
            String tipoDoc,
            String countryId,
            String? cityId,
            DateTime? fechaEmision,
            DateTime? fechaVencimiento,
            String estado,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetDocumentEntity() when $default != null:
        return $default(
            _that.id,
            _that.assetId,
            _that.tipoDoc,
            _that.countryId,
            _that.cityId,
            _that.fechaEmision,
            _that.fechaVencimiento,
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
            String tipoDoc,
            String countryId,
            String? cityId,
            DateTime? fechaEmision,
            DateTime? fechaVencimiento,
            String estado,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetDocumentEntity():
        return $default(
            _that.id,
            _that.assetId,
            _that.tipoDoc,
            _that.countryId,
            _that.cityId,
            _that.fechaEmision,
            _that.fechaVencimiento,
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
            String tipoDoc,
            String countryId,
            String? cityId,
            DateTime? fechaEmision,
            DateTime? fechaVencimiento,
            String estado,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetDocumentEntity() when $default != null:
        return $default(
            _that.id,
            _that.assetId,
            _that.tipoDoc,
            _that.countryId,
            _that.cityId,
            _that.fechaEmision,
            _that.fechaVencimiento,
            _that.estado,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssetDocumentEntity implements AssetDocumentEntity {
  const _AssetDocumentEntity(
      {required this.id,
      required this.assetId,
      required this.tipoDoc,
      required this.countryId,
      this.cityId,
      this.fechaEmision,
      this.fechaVencimiento,
      required this.estado,
      this.createdAt,
      this.updatedAt});
  factory _AssetDocumentEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetDocumentEntityFromJson(json);

  @override
  final String id;
  @override
  final String assetId;
  @override
  final String tipoDoc;
  @override
  final String countryId;
  @override
  final String? cityId;
  @override
  final DateTime? fechaEmision;
  @override
  final DateTime? fechaVencimiento;
  @override
  final String estado;
// vigente | vencido | por_vencer
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of AssetDocumentEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetDocumentEntityCopyWith<_AssetDocumentEntity> get copyWith =>
      __$AssetDocumentEntityCopyWithImpl<_AssetDocumentEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetDocumentEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetDocumentEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.tipoDoc, tipoDoc) || other.tipoDoc == tipoDoc) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.fechaEmision, fechaEmision) ||
                other.fechaEmision == fechaEmision) &&
            (identical(other.fechaVencimiento, fechaVencimiento) ||
                other.fechaVencimiento == fechaVencimiento) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, assetId, tipoDoc, countryId,
      cityId, fechaEmision, fechaVencimiento, estado, createdAt, updatedAt);

  @override
  String toString() {
    return 'AssetDocumentEntity(id: $id, assetId: $assetId, tipoDoc: $tipoDoc, countryId: $countryId, cityId: $cityId, fechaEmision: $fechaEmision, fechaVencimiento: $fechaVencimiento, estado: $estado, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AssetDocumentEntityCopyWith<$Res>
    implements $AssetDocumentEntityCopyWith<$Res> {
  factory _$AssetDocumentEntityCopyWith(_AssetDocumentEntity value,
          $Res Function(_AssetDocumentEntity) _then) =
      __$AssetDocumentEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String assetId,
      String tipoDoc,
      String countryId,
      String? cityId,
      DateTime? fechaEmision,
      DateTime? fechaVencimiento,
      String estado,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$AssetDocumentEntityCopyWithImpl<$Res>
    implements _$AssetDocumentEntityCopyWith<$Res> {
  __$AssetDocumentEntityCopyWithImpl(this._self, this._then);

  final _AssetDocumentEntity _self;
  final $Res Function(_AssetDocumentEntity) _then;

  /// Create a copy of AssetDocumentEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? assetId = null,
    Object? tipoDoc = null,
    Object? countryId = null,
    Object? cityId = freezed,
    Object? fechaEmision = freezed,
    Object? fechaVencimiento = freezed,
    Object? estado = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_AssetDocumentEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      tipoDoc: null == tipoDoc
          ? _self.tipoDoc
          : tipoDoc // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaEmision: freezed == fechaEmision
          ? _self.fechaEmision
          : fechaEmision // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      fechaVencimiento: freezed == fechaVencimiento
          ? _self.fechaVencimiento
          : fechaVencimiento // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
