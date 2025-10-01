// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BranchEntity {
  String get id;
  String get orgId;
  String get name;
  String? get address;
  String get countryId;
  String? get regionId;
  String? get cityId;
  List<String> get coverageCities; // 'PAIS/REGION/CIUDAD'
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BranchEntityCopyWith<BranchEntity> get copyWith =>
      _$BranchEntityCopyWithImpl<BranchEntity>(
          this as BranchEntity, _$identity);

  /// Serializes this BranchEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BranchEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            const DeepCollectionEquality()
                .equals(other.coverageCities, coverageCities) &&
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
      name,
      address,
      countryId,
      regionId,
      cityId,
      const DeepCollectionEquality().hash(coverageCities),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'BranchEntity(id: $id, orgId: $orgId, name: $name, address: $address, countryId: $countryId, regionId: $regionId, cityId: $cityId, coverageCities: $coverageCities, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $BranchEntityCopyWith<$Res> {
  factory $BranchEntityCopyWith(
          BranchEntity value, $Res Function(BranchEntity) _then) =
      _$BranchEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String name,
      String? address,
      String countryId,
      String? regionId,
      String? cityId,
      List<String> coverageCities,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$BranchEntityCopyWithImpl<$Res> implements $BranchEntityCopyWith<$Res> {
  _$BranchEntityCopyWithImpl(this._self, this._then);

  final BranchEntity _self;
  final $Res Function(BranchEntity) _then;

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? name = null,
    Object? address = freezed,
    Object? countryId = null,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? coverageCities = null,
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
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
      coverageCities: null == coverageCities
          ? _self.coverageCities
          : coverageCities // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [BranchEntity].
extension BranchEntityPatterns on BranchEntity {
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
    TResult Function(_BranchEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BranchEntity() when $default != null:
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
    TResult Function(_BranchEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BranchEntity():
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
    TResult? Function(_BranchEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BranchEntity() when $default != null:
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
            String name,
            String? address,
            String countryId,
            String? regionId,
            String? cityId,
            List<String> coverageCities,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BranchEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.name,
            _that.address,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.coverageCities,
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
            String name,
            String? address,
            String countryId,
            String? regionId,
            String? cityId,
            List<String> coverageCities,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BranchEntity():
        return $default(
            _that.id,
            _that.orgId,
            _that.name,
            _that.address,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.coverageCities,
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
            String name,
            String? address,
            String countryId,
            String? regionId,
            String? cityId,
            List<String> coverageCities,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BranchEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.name,
            _that.address,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.coverageCities,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BranchEntity implements BranchEntity {
  const _BranchEntity(
      {required this.id,
      required this.orgId,
      required this.name,
      this.address,
      required this.countryId,
      this.regionId,
      this.cityId,
      final List<String> coverageCities = const <String>[],
      this.createdAt,
      this.updatedAt})
      : _coverageCities = coverageCities;
  factory _BranchEntity.fromJson(Map<String, dynamic> json) =>
      _$BranchEntityFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String name;
  @override
  final String? address;
  @override
  final String countryId;
  @override
  final String? regionId;
  @override
  final String? cityId;
  final List<String> _coverageCities;
  @override
  @JsonKey()
  List<String> get coverageCities {
    if (_coverageCities is EqualUnmodifiableListView) return _coverageCities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coverageCities);
  }

// 'PAIS/REGION/CIUDAD'
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BranchEntityCopyWith<_BranchEntity> get copyWith =>
      __$BranchEntityCopyWithImpl<_BranchEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BranchEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BranchEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            const DeepCollectionEquality()
                .equals(other._coverageCities, _coverageCities) &&
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
      name,
      address,
      countryId,
      regionId,
      cityId,
      const DeepCollectionEquality().hash(_coverageCities),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'BranchEntity(id: $id, orgId: $orgId, name: $name, address: $address, countryId: $countryId, regionId: $regionId, cityId: $cityId, coverageCities: $coverageCities, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$BranchEntityCopyWith<$Res>
    implements $BranchEntityCopyWith<$Res> {
  factory _$BranchEntityCopyWith(
          _BranchEntity value, $Res Function(_BranchEntity) _then) =
      __$BranchEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String name,
      String? address,
      String countryId,
      String? regionId,
      String? cityId,
      List<String> coverageCities,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$BranchEntityCopyWithImpl<$Res>
    implements _$BranchEntityCopyWith<$Res> {
  __$BranchEntityCopyWithImpl(this._self, this._then);

  final _BranchEntity _self;
  final $Res Function(_BranchEntity) _then;

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? name = null,
    Object? address = freezed,
    Object? countryId = null,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? coverageCities = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_BranchEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
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
      coverageCities: null == coverageCities
          ? _self._coverageCities
          : coverageCities // ignore: cast_nullable_to_non_nullable
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
