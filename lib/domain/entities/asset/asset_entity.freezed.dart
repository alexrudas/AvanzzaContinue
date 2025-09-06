// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetEntity {
  String get id;
  String get orgId;
  String get assetType; // vehiculo | inmueble | maquinaria | otro
  String get countryId;
  String? get regionId;
  String? get cityId;
  String get ownerType; // org | user
  String get ownerId;
  String get estado; // activo | inactivo
  List<String> get etiquetas;
  List<String> get fotosUrls;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetEntityCopyWith<AssetEntity> get copyWith =>
      _$AssetEntityCopyWithImpl<AssetEntity>(this as AssetEntity, _$identity);

  /// Serializes this AssetEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetType, assetType) ||
                other.assetType == assetType) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.ownerType, ownerType) ||
                other.ownerType == ownerType) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            const DeepCollectionEquality().equals(other.etiquetas, etiquetas) &&
            const DeepCollectionEquality().equals(other.fotosUrls, fotosUrls) &&
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
      assetType,
      countryId,
      regionId,
      cityId,
      ownerType,
      ownerId,
      estado,
      const DeepCollectionEquality().hash(etiquetas),
      const DeepCollectionEquality().hash(fotosUrls),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AssetEntity(id: $id, orgId: $orgId, assetType: $assetType, countryId: $countryId, regionId: $regionId, cityId: $cityId, ownerType: $ownerType, ownerId: $ownerId, estado: $estado, etiquetas: $etiquetas, fotosUrls: $fotosUrls, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AssetEntityCopyWith<$Res> {
  factory $AssetEntityCopyWith(
          AssetEntity value, $Res Function(AssetEntity) _then) =
      _$AssetEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String assetType,
      String countryId,
      String? regionId,
      String? cityId,
      String ownerType,
      String ownerId,
      String estado,
      List<String> etiquetas,
      List<String> fotosUrls,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AssetEntityCopyWithImpl<$Res> implements $AssetEntityCopyWith<$Res> {
  _$AssetEntityCopyWithImpl(this._self, this._then);

  final AssetEntity _self;
  final $Res Function(AssetEntity) _then;

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetType = null,
    Object? countryId = null,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? ownerType = null,
    Object? ownerId = null,
    Object? estado = null,
    Object? etiquetas = null,
    Object? fotosUrls = null,
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
      assetType: null == assetType
          ? _self.assetType
          : assetType // ignore: cast_nullable_to_non_nullable
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
      ownerType: null == ownerType
          ? _self.ownerType
          : ownerType // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      etiquetas: null == etiquetas
          ? _self.etiquetas
          : etiquetas // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fotosUrls: null == fotosUrls
          ? _self.fotosUrls
          : fotosUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
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

/// Adds pattern-matching-related methods to [AssetEntity].
extension AssetEntityPatterns on AssetEntity {
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
    TResult Function(_AssetEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetEntity() when $default != null:
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
    TResult Function(_AssetEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetEntity():
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
    TResult? Function(_AssetEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetEntity() when $default != null:
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
            String assetType,
            String countryId,
            String? regionId,
            String? cityId,
            String ownerType,
            String ownerId,
            String estado,
            List<String> etiquetas,
            List<String> fotosUrls,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetType,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.ownerType,
            _that.ownerId,
            _that.estado,
            _that.etiquetas,
            _that.fotosUrls,
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
            String assetType,
            String countryId,
            String? regionId,
            String? cityId,
            String ownerType,
            String ownerId,
            String estado,
            List<String> etiquetas,
            List<String> fotosUrls,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetEntity():
        return $default(
            _that.id,
            _that.orgId,
            _that.assetType,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.ownerType,
            _that.ownerId,
            _that.estado,
            _that.etiquetas,
            _that.fotosUrls,
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
            String assetType,
            String countryId,
            String? regionId,
            String? cityId,
            String ownerType,
            String ownerId,
            String estado,
            List<String> etiquetas,
            List<String> fotosUrls,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetType,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.ownerType,
            _that.ownerId,
            _that.estado,
            _that.etiquetas,
            _that.fotosUrls,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssetEntity implements AssetEntity {
  const _AssetEntity(
      {required this.id,
      required this.orgId,
      required this.assetType,
      required this.countryId,
      this.regionId,
      this.cityId,
      required this.ownerType,
      required this.ownerId,
      required this.estado,
      final List<String> etiquetas = const <String>[],
      final List<String> fotosUrls = const <String>[],
      this.createdAt,
      this.updatedAt})
      : _etiquetas = etiquetas,
        _fotosUrls = fotosUrls;
  factory _AssetEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetEntityFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String assetType;
// vehiculo | inmueble | maquinaria | otro
  @override
  final String countryId;
  @override
  final String? regionId;
  @override
  final String? cityId;
  @override
  final String ownerType;
// org | user
  @override
  final String ownerId;
  @override
  final String estado;
// activo | inactivo
  final List<String> _etiquetas;
// activo | inactivo
  @override
  @JsonKey()
  List<String> get etiquetas {
    if (_etiquetas is EqualUnmodifiableListView) return _etiquetas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_etiquetas);
  }

  final List<String> _fotosUrls;
  @override
  @JsonKey()
  List<String> get fotosUrls {
    if (_fotosUrls is EqualUnmodifiableListView) return _fotosUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fotosUrls);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetEntityCopyWith<_AssetEntity> get copyWith =>
      __$AssetEntityCopyWithImpl<_AssetEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetType, assetType) ||
                other.assetType == assetType) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.ownerType, ownerType) ||
                other.ownerType == ownerType) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            const DeepCollectionEquality()
                .equals(other._etiquetas, _etiquetas) &&
            const DeepCollectionEquality()
                .equals(other._fotosUrls, _fotosUrls) &&
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
      assetType,
      countryId,
      regionId,
      cityId,
      ownerType,
      ownerId,
      estado,
      const DeepCollectionEquality().hash(_etiquetas),
      const DeepCollectionEquality().hash(_fotosUrls),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AssetEntity(id: $id, orgId: $orgId, assetType: $assetType, countryId: $countryId, regionId: $regionId, cityId: $cityId, ownerType: $ownerType, ownerId: $ownerId, estado: $estado, etiquetas: $etiquetas, fotosUrls: $fotosUrls, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AssetEntityCopyWith<$Res>
    implements $AssetEntityCopyWith<$Res> {
  factory _$AssetEntityCopyWith(
          _AssetEntity value, $Res Function(_AssetEntity) _then) =
      __$AssetEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String assetType,
      String countryId,
      String? regionId,
      String? cityId,
      String ownerType,
      String ownerId,
      String estado,
      List<String> etiquetas,
      List<String> fotosUrls,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$AssetEntityCopyWithImpl<$Res> implements _$AssetEntityCopyWith<$Res> {
  __$AssetEntityCopyWithImpl(this._self, this._then);

  final _AssetEntity _self;
  final $Res Function(_AssetEntity) _then;

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetType = null,
    Object? countryId = null,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? ownerType = null,
    Object? ownerId = null,
    Object? estado = null,
    Object? etiquetas = null,
    Object? fotosUrls = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_AssetEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      assetType: null == assetType
          ? _self.assetType
          : assetType // ignore: cast_nullable_to_non_nullable
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
      ownerType: null == ownerType
          ? _self.ownerType
          : ownerType // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      etiquetas: null == etiquetas
          ? _self._etiquetas
          : etiquetas // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fotosUrls: null == fotosUrls
          ? _self._fotosUrls
          : fotosUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
