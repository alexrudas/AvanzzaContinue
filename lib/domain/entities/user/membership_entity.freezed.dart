// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MembershipEntity {
  String get userId;
  String get orgId;
  String get orgName;
  List<String> get roles;
  String get estatus; // activo | inactivo
  Map<String, String> get primaryLocation; // { countryId, regionId?, cityId? }
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of MembershipEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MembershipEntityCopyWith<MembershipEntity> get copyWith =>
      _$MembershipEntityCopyWithImpl<MembershipEntity>(
          this as MembershipEntity, _$identity);

  /// Serializes this MembershipEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MembershipEntity &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.orgName, orgName) || other.orgName == orgName) &&
            const DeepCollectionEquality().equals(other.roles, roles) &&
            (identical(other.estatus, estatus) || other.estatus == estatus) &&
            const DeepCollectionEquality()
                .equals(other.primaryLocation, primaryLocation) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      orgId,
      orgName,
      const DeepCollectionEquality().hash(roles),
      estatus,
      const DeepCollectionEquality().hash(primaryLocation),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'MembershipEntity(userId: $userId, orgId: $orgId, orgName: $orgName, roles: $roles, estatus: $estatus, primaryLocation: $primaryLocation, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $MembershipEntityCopyWith<$Res> {
  factory $MembershipEntityCopyWith(
          MembershipEntity value, $Res Function(MembershipEntity) _then) =
      _$MembershipEntityCopyWithImpl;
  @useResult
  $Res call(
      {String userId,
      String orgId,
      String orgName,
      List<String> roles,
      String estatus,
      Map<String, String> primaryLocation,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$MembershipEntityCopyWithImpl<$Res>
    implements $MembershipEntityCopyWith<$Res> {
  _$MembershipEntityCopyWithImpl(this._self, this._then);

  final MembershipEntity _self;
  final $Res Function(MembershipEntity) _then;

  /// Create a copy of MembershipEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? orgId = null,
    Object? orgName = null,
    Object? roles = null,
    Object? estatus = null,
    Object? primaryLocation = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      orgName: null == orgName
          ? _self.orgName
          : orgName // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _self.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      estatus: null == estatus
          ? _self.estatus
          : estatus // ignore: cast_nullable_to_non_nullable
              as String,
      primaryLocation: null == primaryLocation
          ? _self.primaryLocation
          : primaryLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
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

/// Adds pattern-matching-related methods to [MembershipEntity].
extension MembershipEntityPatterns on MembershipEntity {
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
    TResult Function(_MembershipEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MembershipEntity() when $default != null:
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
    TResult Function(_MembershipEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MembershipEntity():
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
    TResult? Function(_MembershipEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MembershipEntity() when $default != null:
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
            String userId,
            String orgId,
            String orgName,
            List<String> roles,
            String estatus,
            Map<String, String> primaryLocation,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MembershipEntity() when $default != null:
        return $default(
            _that.userId,
            _that.orgId,
            _that.orgName,
            _that.roles,
            _that.estatus,
            _that.primaryLocation,
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
            String userId,
            String orgId,
            String orgName,
            List<String> roles,
            String estatus,
            Map<String, String> primaryLocation,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MembershipEntity():
        return $default(
            _that.userId,
            _that.orgId,
            _that.orgName,
            _that.roles,
            _that.estatus,
            _that.primaryLocation,
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
            String userId,
            String orgId,
            String orgName,
            List<String> roles,
            String estatus,
            Map<String, String> primaryLocation,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MembershipEntity() when $default != null:
        return $default(
            _that.userId,
            _that.orgId,
            _that.orgName,
            _that.roles,
            _that.estatus,
            _that.primaryLocation,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MembershipEntity implements MembershipEntity {
  const _MembershipEntity(
      {required this.userId,
      required this.orgId,
      required this.orgName,
      final List<String> roles = const <String>[],
      required this.estatus,
      required final Map<String, String> primaryLocation,
      this.createdAt,
      this.updatedAt})
      : _roles = roles,
        _primaryLocation = primaryLocation;
  factory _MembershipEntity.fromJson(Map<String, dynamic> json) =>
      _$MembershipEntityFromJson(json);

  @override
  final String userId;
  @override
  final String orgId;
  @override
  final String orgName;
  final List<String> _roles;
  @override
  @JsonKey()
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  final String estatus;
// activo | inactivo
  final Map<String, String> _primaryLocation;
// activo | inactivo
  @override
  Map<String, String> get primaryLocation {
    if (_primaryLocation is EqualUnmodifiableMapView) return _primaryLocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_primaryLocation);
  }

// { countryId, regionId?, cityId? }
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of MembershipEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MembershipEntityCopyWith<_MembershipEntity> get copyWith =>
      __$MembershipEntityCopyWithImpl<_MembershipEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MembershipEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MembershipEntity &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.orgName, orgName) || other.orgName == orgName) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.estatus, estatus) || other.estatus == estatus) &&
            const DeepCollectionEquality()
                .equals(other._primaryLocation, _primaryLocation) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      orgId,
      orgName,
      const DeepCollectionEquality().hash(_roles),
      estatus,
      const DeepCollectionEquality().hash(_primaryLocation),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'MembershipEntity(userId: $userId, orgId: $orgId, orgName: $orgName, roles: $roles, estatus: $estatus, primaryLocation: $primaryLocation, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$MembershipEntityCopyWith<$Res>
    implements $MembershipEntityCopyWith<$Res> {
  factory _$MembershipEntityCopyWith(
          _MembershipEntity value, $Res Function(_MembershipEntity) _then) =
      __$MembershipEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userId,
      String orgId,
      String orgName,
      List<String> roles,
      String estatus,
      Map<String, String> primaryLocation,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$MembershipEntityCopyWithImpl<$Res>
    implements _$MembershipEntityCopyWith<$Res> {
  __$MembershipEntityCopyWithImpl(this._self, this._then);

  final _MembershipEntity _self;
  final $Res Function(_MembershipEntity) _then;

  /// Create a copy of MembershipEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? orgId = null,
    Object? orgName = null,
    Object? roles = null,
    Object? estatus = null,
    Object? primaryLocation = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_MembershipEntity(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      orgName: null == orgName
          ? _self.orgName
          : orgName // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _self._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      estatus: null == estatus
          ? _self.estatus
          : estatus // ignore: cast_nullable_to_non_nullable
              as String,
      primaryLocation: null == primaryLocation
          ? _self._primaryLocation
          : primaryLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
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
