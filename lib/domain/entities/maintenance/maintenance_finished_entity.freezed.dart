// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_finished_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MaintenanceFinishedEntity {
  String get id;
  String get orgId;
  String get assetId;
  String get descripcion;
  DateTime get fechaFin;
  double get costoTotal;
  List<String> get itemsUsados;
  List<String> get comprobantesUrls;
  String? get cityId;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of MaintenanceFinishedEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MaintenanceFinishedEntityCopyWith<MaintenanceFinishedEntity> get copyWith =>
      _$MaintenanceFinishedEntityCopyWithImpl<MaintenanceFinishedEntity>(
          this as MaintenanceFinishedEntity, _$identity);

  /// Serializes this MaintenanceFinishedEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MaintenanceFinishedEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.fechaFin, fechaFin) ||
                other.fechaFin == fechaFin) &&
            (identical(other.costoTotal, costoTotal) ||
                other.costoTotal == costoTotal) &&
            const DeepCollectionEquality()
                .equals(other.itemsUsados, itemsUsados) &&
            const DeepCollectionEquality()
                .equals(other.comprobantesUrls, comprobantesUrls) &&
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
      fechaFin,
      costoTotal,
      const DeepCollectionEquality().hash(itemsUsados),
      const DeepCollectionEquality().hash(comprobantesUrls),
      cityId,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'MaintenanceFinishedEntity(id: $id, orgId: $orgId, assetId: $assetId, descripcion: $descripcion, fechaFin: $fechaFin, costoTotal: $costoTotal, itemsUsados: $itemsUsados, comprobantesUrls: $comprobantesUrls, cityId: $cityId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $MaintenanceFinishedEntityCopyWith<$Res> {
  factory $MaintenanceFinishedEntityCopyWith(MaintenanceFinishedEntity value,
          $Res Function(MaintenanceFinishedEntity) _then) =
      _$MaintenanceFinishedEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String assetId,
      String descripcion,
      DateTime fechaFin,
      double costoTotal,
      List<String> itemsUsados,
      List<String> comprobantesUrls,
      String? cityId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$MaintenanceFinishedEntityCopyWithImpl<$Res>
    implements $MaintenanceFinishedEntityCopyWith<$Res> {
  _$MaintenanceFinishedEntityCopyWithImpl(this._self, this._then);

  final MaintenanceFinishedEntity _self;
  final $Res Function(MaintenanceFinishedEntity) _then;

  /// Create a copy of MaintenanceFinishedEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetId = null,
    Object? descripcion = null,
    Object? fechaFin = null,
    Object? costoTotal = null,
    Object? itemsUsados = null,
    Object? comprobantesUrls = null,
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
      fechaFin: null == fechaFin
          ? _self.fechaFin
          : fechaFin // ignore: cast_nullable_to_non_nullable
              as DateTime,
      costoTotal: null == costoTotal
          ? _self.costoTotal
          : costoTotal // ignore: cast_nullable_to_non_nullable
              as double,
      itemsUsados: null == itemsUsados
          ? _self.itemsUsados
          : itemsUsados // ignore: cast_nullable_to_non_nullable
              as List<String>,
      comprobantesUrls: null == comprobantesUrls
          ? _self.comprobantesUrls
          : comprobantesUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
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

/// Adds pattern-matching-related methods to [MaintenanceFinishedEntity].
extension MaintenanceFinishedEntityPatterns on MaintenanceFinishedEntity {
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
    TResult Function(_MaintenanceFinishedEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MaintenanceFinishedEntity() when $default != null:
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
    TResult Function(_MaintenanceFinishedEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MaintenanceFinishedEntity():
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
    TResult? Function(_MaintenanceFinishedEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MaintenanceFinishedEntity() when $default != null:
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
            DateTime fechaFin,
            double costoTotal,
            List<String> itemsUsados,
            List<String> comprobantesUrls,
            String? cityId,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MaintenanceFinishedEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.descripcion,
            _that.fechaFin,
            _that.costoTotal,
            _that.itemsUsados,
            _that.comprobantesUrls,
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
            DateTime fechaFin,
            double costoTotal,
            List<String> itemsUsados,
            List<String> comprobantesUrls,
            String? cityId,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MaintenanceFinishedEntity():
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.descripcion,
            _that.fechaFin,
            _that.costoTotal,
            _that.itemsUsados,
            _that.comprobantesUrls,
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
            DateTime fechaFin,
            double costoTotal,
            List<String> itemsUsados,
            List<String> comprobantesUrls,
            String? cityId,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MaintenanceFinishedEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.descripcion,
            _that.fechaFin,
            _that.costoTotal,
            _that.itemsUsados,
            _that.comprobantesUrls,
            _that.cityId,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MaintenanceFinishedEntity implements MaintenanceFinishedEntity {
  const _MaintenanceFinishedEntity(
      {required this.id,
      required this.orgId,
      required this.assetId,
      required this.descripcion,
      required this.fechaFin,
      required this.costoTotal,
      final List<String> itemsUsados = const <String>[],
      final List<String> comprobantesUrls = const <String>[],
      this.cityId,
      this.createdAt,
      this.updatedAt})
      : _itemsUsados = itemsUsados,
        _comprobantesUrls = comprobantesUrls;
  factory _MaintenanceFinishedEntity.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceFinishedEntityFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String assetId;
  @override
  final String descripcion;
  @override
  final DateTime fechaFin;
  @override
  final double costoTotal;
  final List<String> _itemsUsados;
  @override
  @JsonKey()
  List<String> get itemsUsados {
    if (_itemsUsados is EqualUnmodifiableListView) return _itemsUsados;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_itemsUsados);
  }

  final List<String> _comprobantesUrls;
  @override
  @JsonKey()
  List<String> get comprobantesUrls {
    if (_comprobantesUrls is EqualUnmodifiableListView)
      return _comprobantesUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comprobantesUrls);
  }

  @override
  final String? cityId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of MaintenanceFinishedEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MaintenanceFinishedEntityCopyWith<_MaintenanceFinishedEntity>
      get copyWith =>
          __$MaintenanceFinishedEntityCopyWithImpl<_MaintenanceFinishedEntity>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MaintenanceFinishedEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MaintenanceFinishedEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.fechaFin, fechaFin) ||
                other.fechaFin == fechaFin) &&
            (identical(other.costoTotal, costoTotal) ||
                other.costoTotal == costoTotal) &&
            const DeepCollectionEquality()
                .equals(other._itemsUsados, _itemsUsados) &&
            const DeepCollectionEquality()
                .equals(other._comprobantesUrls, _comprobantesUrls) &&
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
      fechaFin,
      costoTotal,
      const DeepCollectionEquality().hash(_itemsUsados),
      const DeepCollectionEquality().hash(_comprobantesUrls),
      cityId,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'MaintenanceFinishedEntity(id: $id, orgId: $orgId, assetId: $assetId, descripcion: $descripcion, fechaFin: $fechaFin, costoTotal: $costoTotal, itemsUsados: $itemsUsados, comprobantesUrls: $comprobantesUrls, cityId: $cityId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$MaintenanceFinishedEntityCopyWith<$Res>
    implements $MaintenanceFinishedEntityCopyWith<$Res> {
  factory _$MaintenanceFinishedEntityCopyWith(_MaintenanceFinishedEntity value,
          $Res Function(_MaintenanceFinishedEntity) _then) =
      __$MaintenanceFinishedEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String assetId,
      String descripcion,
      DateTime fechaFin,
      double costoTotal,
      List<String> itemsUsados,
      List<String> comprobantesUrls,
      String? cityId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$MaintenanceFinishedEntityCopyWithImpl<$Res>
    implements _$MaintenanceFinishedEntityCopyWith<$Res> {
  __$MaintenanceFinishedEntityCopyWithImpl(this._self, this._then);

  final _MaintenanceFinishedEntity _self;
  final $Res Function(_MaintenanceFinishedEntity) _then;

  /// Create a copy of MaintenanceFinishedEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetId = null,
    Object? descripcion = null,
    Object? fechaFin = null,
    Object? costoTotal = null,
    Object? itemsUsados = null,
    Object? comprobantesUrls = null,
    Object? cityId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_MaintenanceFinishedEntity(
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
      fechaFin: null == fechaFin
          ? _self.fechaFin
          : fechaFin // ignore: cast_nullable_to_non_nullable
              as DateTime,
      costoTotal: null == costoTotal
          ? _self.costoTotal
          : costoTotal // ignore: cast_nullable_to_non_nullable
              as double,
      itemsUsados: null == itemsUsados
          ? _self._itemsUsados
          : itemsUsados // ignore: cast_nullable_to_non_nullable
              as List<String>,
      comprobantesUrls: null == comprobantesUrls
          ? _self._comprobantesUrls
          : comprobantesUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
