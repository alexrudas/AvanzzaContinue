// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_process_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MaintenanceProcessEntity {
  String get id;
  String get orgId;
  String get assetId;
  String get descripcion;
  String get tecnicoId;
  String get estado;
  DateTime get startedAt;
  String? get purchaseRequestId;
  String? get cityId;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of MaintenanceProcessEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MaintenanceProcessEntityCopyWith<MaintenanceProcessEntity> get copyWith =>
      _$MaintenanceProcessEntityCopyWithImpl<MaintenanceProcessEntity>(
          this as MaintenanceProcessEntity, _$identity);

  /// Serializes this MaintenanceProcessEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MaintenanceProcessEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.tecnicoId, tecnicoId) ||
                other.tecnicoId == tecnicoId) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.purchaseRequestId, purchaseRequestId) ||
                other.purchaseRequestId == purchaseRequestId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
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
      assetId,
      descripcion,
      tecnicoId,
      estado,
      startedAt,
      purchaseRequestId,
      cityId,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'MaintenanceProcessEntity(id: $id, orgId: $orgId, assetId: $assetId, descripcion: $descripcion, tecnicoId: $tecnicoId, estado: $estado, startedAt: $startedAt, purchaseRequestId: $purchaseRequestId, cityId: $cityId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $MaintenanceProcessEntityCopyWith<$Res> {
  factory $MaintenanceProcessEntityCopyWith(MaintenanceProcessEntity value,
          $Res Function(MaintenanceProcessEntity) _then) =
      _$MaintenanceProcessEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String assetId,
      String descripcion,
      String tecnicoId,
      String estado,
      DateTime startedAt,
      String? purchaseRequestId,
      String? cityId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$MaintenanceProcessEntityCopyWithImpl<$Res>
    implements $MaintenanceProcessEntityCopyWith<$Res> {
  _$MaintenanceProcessEntityCopyWithImpl(this._self, this._then);

  final MaintenanceProcessEntity _self;
  final $Res Function(MaintenanceProcessEntity) _then;

  /// Create a copy of MaintenanceProcessEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetId = null,
    Object? descripcion = null,
    Object? tecnicoId = null,
    Object? estado = null,
    Object? startedAt = null,
    Object? purchaseRequestId = freezed,
    Object? cityId = freezed,
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
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      descripcion: null == descripcion
          ? _self.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String,
      tecnicoId: null == tecnicoId
          ? _self.tecnicoId
          : tecnicoId // ignore: cast_nullable_to_non_nullable
              as String,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      purchaseRequestId: freezed == purchaseRequestId
          ? _self.purchaseRequestId
          : purchaseRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [MaintenanceProcessEntity].
extension MaintenanceProcessEntityPatterns on MaintenanceProcessEntity {
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
    TResult Function(_MaintenanceProcessEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MaintenanceProcessEntity() when $default != null:
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
    TResult Function(_MaintenanceProcessEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MaintenanceProcessEntity():
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
    TResult? Function(_MaintenanceProcessEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MaintenanceProcessEntity() when $default != null:
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
            String assetId,
            String descripcion,
            String tecnicoId,
            String estado,
            DateTime startedAt,
            String? purchaseRequestId,
            String? cityId,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MaintenanceProcessEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.descripcion,
            _that.tecnicoId,
            _that.estado,
            _that.startedAt,
            _that.purchaseRequestId,
            _that.cityId,
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
            String assetId,
            String descripcion,
            String tecnicoId,
            String estado,
            DateTime startedAt,
            String? purchaseRequestId,
            String? cityId,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MaintenanceProcessEntity():
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.descripcion,
            _that.tecnicoId,
            _that.estado,
            _that.startedAt,
            _that.purchaseRequestId,
            _that.cityId,
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
            String assetId,
            String descripcion,
            String tecnicoId,
            String estado,
            DateTime startedAt,
            String? purchaseRequestId,
            String? cityId,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MaintenanceProcessEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.descripcion,
            _that.tecnicoId,
            _that.estado,
            _that.startedAt,
            _that.purchaseRequestId,
            _that.cityId,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MaintenanceProcessEntity implements MaintenanceProcessEntity {
  const _MaintenanceProcessEntity(
      {required this.id,
      required this.orgId,
      required this.assetId,
      required this.descripcion,
      required this.tecnicoId,
      this.estado = 'en_proceso',
      required this.startedAt,
      this.purchaseRequestId,
      this.cityId,
      this.createdAt,
      this.updatedAt});
  factory _MaintenanceProcessEntity.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceProcessEntityFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String assetId;
  @override
  final String descripcion;
  @override
  final String tecnicoId;
  @override
  @JsonKey()
  final String estado;
  @override
  final DateTime startedAt;
  @override
  final String? purchaseRequestId;
  @override
  final String? cityId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of MaintenanceProcessEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MaintenanceProcessEntityCopyWith<_MaintenanceProcessEntity> get copyWith =>
      __$MaintenanceProcessEntityCopyWithImpl<_MaintenanceProcessEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MaintenanceProcessEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MaintenanceProcessEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.tecnicoId, tecnicoId) ||
                other.tecnicoId == tecnicoId) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.purchaseRequestId, purchaseRequestId) ||
                other.purchaseRequestId == purchaseRequestId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
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
      assetId,
      descripcion,
      tecnicoId,
      estado,
      startedAt,
      purchaseRequestId,
      cityId,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'MaintenanceProcessEntity(id: $id, orgId: $orgId, assetId: $assetId, descripcion: $descripcion, tecnicoId: $tecnicoId, estado: $estado, startedAt: $startedAt, purchaseRequestId: $purchaseRequestId, cityId: $cityId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$MaintenanceProcessEntityCopyWith<$Res>
    implements $MaintenanceProcessEntityCopyWith<$Res> {
  factory _$MaintenanceProcessEntityCopyWith(_MaintenanceProcessEntity value,
          $Res Function(_MaintenanceProcessEntity) _then) =
      __$MaintenanceProcessEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String assetId,
      String descripcion,
      String tecnicoId,
      String estado,
      DateTime startedAt,
      String? purchaseRequestId,
      String? cityId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$MaintenanceProcessEntityCopyWithImpl<$Res>
    implements _$MaintenanceProcessEntityCopyWith<$Res> {
  __$MaintenanceProcessEntityCopyWithImpl(this._self, this._then);

  final _MaintenanceProcessEntity _self;
  final $Res Function(_MaintenanceProcessEntity) _then;

  /// Create a copy of MaintenanceProcessEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetId = null,
    Object? descripcion = null,
    Object? tecnicoId = null,
    Object? estado = null,
    Object? startedAt = null,
    Object? purchaseRequestId = freezed,
    Object? cityId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_MaintenanceProcessEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      descripcion: null == descripcion
          ? _self.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String,
      tecnicoId: null == tecnicoId
          ? _self.tecnicoId
          : tecnicoId // ignore: cast_nullable_to_non_nullable
              as String,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      purchaseRequestId: freezed == purchaseRequestId
          ? _self.purchaseRequestId
          : purchaseRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
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
