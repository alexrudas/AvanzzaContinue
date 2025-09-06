// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrganizationEntity {
  String get id;
  String get nombre;
  String get tipo; // empresa | personal
  String get countryId;
  String? get regionId;
  String? get cityId;
  String? get ownerUid;
  String? get logoUrl;
  Map<String, dynamic>? get metadata;
  bool get isActive;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of OrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrganizationEntityCopyWith<OrganizationEntity> get copyWith =>
      _$OrganizationEntityCopyWithImpl<OrganizationEntity>(
          this as OrganizationEntity, _$identity);

  /// Serializes this OrganizationEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrganizationEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.ownerUid, ownerUid) ||
                other.ownerUid == ownerUid) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            const DeepCollectionEquality().equals(other.metadata, metadata) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
      nombre,
      tipo,
      countryId,
      regionId,
      cityId,
      ownerUid,
      logoUrl,
      const DeepCollectionEquality().hash(metadata),
      isActive,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'OrganizationEntity(id: $id, nombre: $nombre, tipo: $tipo, countryId: $countryId, regionId: $regionId, cityId: $cityId, ownerUid: $ownerUid, logoUrl: $logoUrl, metadata: $metadata, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $OrganizationEntityCopyWith<$Res> {
  factory $OrganizationEntityCopyWith(
          OrganizationEntity value, $Res Function(OrganizationEntity) _then) =
      _$OrganizationEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String nombre,
      String tipo,
      String countryId,
      String? regionId,
      String? cityId,
      String? ownerUid,
      String? logoUrl,
      Map<String, dynamic>? metadata,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$OrganizationEntityCopyWithImpl<$Res>
    implements $OrganizationEntityCopyWith<$Res> {
  _$OrganizationEntityCopyWithImpl(this._self, this._then);

  final OrganizationEntity _self;
  final $Res Function(OrganizationEntity) _then;

  /// Create a copy of OrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? tipo = null,
    Object? countryId = null,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? ownerUid = freezed,
    Object? logoUrl = freezed,
    Object? metadata = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nombre: null == nombre
          ? _self.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _self.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      regionId: freezed == regionId
          ? _self.regionId
          : regionId // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerUid: freezed == ownerUid
          ? _self.ownerUid
          : ownerUid // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _self.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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

/// Adds pattern-matching-related methods to [OrganizationEntity].
extension OrganizationEntityPatterns on OrganizationEntity {
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
    TResult Function(_OrganizationEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrganizationEntity() when $default != null:
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
    TResult Function(_OrganizationEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrganizationEntity():
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
    TResult? Function(_OrganizationEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrganizationEntity() when $default != null:
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
            String nombre,
            String tipo,
            String countryId,
            String? regionId,
            String? cityId,
            String? ownerUid,
            String? logoUrl,
            Map<String, dynamic>? metadata,
            bool isActive,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrganizationEntity() when $default != null:
        return $default(
            _that.id,
            _that.nombre,
            _that.tipo,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.ownerUid,
            _that.logoUrl,
            _that.metadata,
            _that.isActive,
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
            String nombre,
            String tipo,
            String countryId,
            String? regionId,
            String? cityId,
            String? ownerUid,
            String? logoUrl,
            Map<String, dynamic>? metadata,
            bool isActive,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrganizationEntity():
        return $default(
            _that.id,
            _that.nombre,
            _that.tipo,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.ownerUid,
            _that.logoUrl,
            _that.metadata,
            _that.isActive,
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
            String nombre,
            String tipo,
            String countryId,
            String? regionId,
            String? cityId,
            String? ownerUid,
            String? logoUrl,
            Map<String, dynamic>? metadata,
            bool isActive,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrganizationEntity() when $default != null:
        return $default(
            _that.id,
            _that.nombre,
            _that.tipo,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.ownerUid,
            _that.logoUrl,
            _that.metadata,
            _that.isActive,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OrganizationEntity implements OrganizationEntity {
  const _OrganizationEntity(
      {required this.id,
      required this.nombre,
      required this.tipo,
      required this.countryId,
      this.regionId,
      this.cityId,
      this.ownerUid,
      this.logoUrl,
      final Map<String, dynamic>? metadata,
      this.isActive = true,
      this.createdAt,
      this.updatedAt})
      : _metadata = metadata;
  factory _OrganizationEntity.fromJson(Map<String, dynamic> json) =>
      _$OrganizationEntityFromJson(json);

  @override
  final String id;
  @override
  final String nombre;
  @override
  final String tipo;
// empresa | personal
  @override
  final String countryId;
  @override
  final String? regionId;
  @override
  final String? cityId;
  @override
  final String? ownerUid;
  @override
  final String? logoUrl;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of OrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrganizationEntityCopyWith<_OrganizationEntity> get copyWith =>
      __$OrganizationEntityCopyWithImpl<_OrganizationEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrganizationEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrganizationEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.ownerUid, ownerUid) ||
                other.ownerUid == ownerUid) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
      nombre,
      tipo,
      countryId,
      regionId,
      cityId,
      ownerUid,
      logoUrl,
      const DeepCollectionEquality().hash(_metadata),
      isActive,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'OrganizationEntity(id: $id, nombre: $nombre, tipo: $tipo, countryId: $countryId, regionId: $regionId, cityId: $cityId, ownerUid: $ownerUid, logoUrl: $logoUrl, metadata: $metadata, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$OrganizationEntityCopyWith<$Res>
    implements $OrganizationEntityCopyWith<$Res> {
  factory _$OrganizationEntityCopyWith(
          _OrganizationEntity value, $Res Function(_OrganizationEntity) _then) =
      __$OrganizationEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String nombre,
      String tipo,
      String countryId,
      String? regionId,
      String? cityId,
      String? ownerUid,
      String? logoUrl,
      Map<String, dynamic>? metadata,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$OrganizationEntityCopyWithImpl<$Res>
    implements _$OrganizationEntityCopyWith<$Res> {
  __$OrganizationEntityCopyWithImpl(this._self, this._then);

  final _OrganizationEntity _self;
  final $Res Function(_OrganizationEntity) _then;

  /// Create a copy of OrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? tipo = null,
    Object? countryId = null,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? ownerUid = freezed,
    Object? logoUrl = freezed,
    Object? metadata = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_OrganizationEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nombre: null == nombre
          ? _self.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _self.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      regionId: freezed == regionId
          ? _self.regionId
          : regionId // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerUid: freezed == ownerUid
          ? _self.ownerUid
          : ownerUid // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _self.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _self._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
