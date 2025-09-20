// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfileEntity {
  String get uid;
  String get phone;
  String? get username;
  String? get email;
  String? get countryId;
  String? get regionId;
  String? get cityId;
  List<String> get roles;
  List<String> get orgIds;
  String? get docType;
  String? get docNumber;
  String? get identityRaw;
  String? get termsVersion;
  @DateTimeTimestampConverter()
  DateTime? get termsAcceptedAt;
  String get status;
  @DateTimeTimestampConverter()
  DateTime? get createdAt;
  @DateTimeTimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of UserProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserProfileEntityCopyWith<UserProfileEntity> get copyWith =>
      _$UserProfileEntityCopyWithImpl<UserProfileEntity>(
          this as UserProfileEntity, _$identity);

  /// Serializes this UserProfileEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserProfileEntity &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            const DeepCollectionEquality().equals(other.roles, roles) &&
            const DeepCollectionEquality().equals(other.orgIds, orgIds) &&
            (identical(other.docType, docType) || other.docType == docType) &&
            (identical(other.docNumber, docNumber) ||
                other.docNumber == docNumber) &&
            (identical(other.identityRaw, identityRaw) ||
                other.identityRaw == identityRaw) &&
            (identical(other.termsVersion, termsVersion) ||
                other.termsVersion == termsVersion) &&
            (identical(other.termsAcceptedAt, termsAcceptedAt) ||
                other.termsAcceptedAt == termsAcceptedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      phone,
      username,
      email,
      countryId,
      regionId,
      cityId,
      const DeepCollectionEquality().hash(roles),
      const DeepCollectionEquality().hash(orgIds),
      docType,
      docNumber,
      identityRaw,
      termsVersion,
      termsAcceptedAt,
      status,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'UserProfileEntity(uid: $uid, phone: $phone, username: $username, email: $email, countryId: $countryId, regionId: $regionId, cityId: $cityId, roles: $roles, orgIds: $orgIds, docType: $docType, docNumber: $docNumber, identityRaw: $identityRaw, termsVersion: $termsVersion, termsAcceptedAt: $termsAcceptedAt, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $UserProfileEntityCopyWith<$Res> {
  factory $UserProfileEntityCopyWith(
          UserProfileEntity value, $Res Function(UserProfileEntity) _then) =
      _$UserProfileEntityCopyWithImpl;
  @useResult
  $Res call(
      {String uid,
      String phone,
      String? username,
      String? email,
      String? countryId,
      String? regionId,
      String? cityId,
      List<String> roles,
      List<String> orgIds,
      String? docType,
      String? docNumber,
      String? identityRaw,
      String? termsVersion,
      @DateTimeTimestampConverter() DateTime? termsAcceptedAt,
      String status,
      @DateTimeTimestampConverter() DateTime? createdAt,
      @DateTimeTimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class _$UserProfileEntityCopyWithImpl<$Res>
    implements $UserProfileEntityCopyWith<$Res> {
  _$UserProfileEntityCopyWithImpl(this._self, this._then);

  final UserProfileEntity _self;
  final $Res Function(UserProfileEntity) _then;

  /// Create a copy of UserProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? phone = null,
    Object? username = freezed,
    Object? email = freezed,
    Object? countryId = freezed,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? roles = null,
    Object? orgIds = null,
    Object? docType = freezed,
    Object? docNumber = freezed,
    Object? identityRaw = freezed,
    Object? termsVersion = freezed,
    Object? termsAcceptedAt = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      countryId: freezed == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String?,
      regionId: freezed == regionId
          ? _self.regionId
          : regionId // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _self.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      orgIds: null == orgIds
          ? _self.orgIds
          : orgIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      docType: freezed == docType
          ? _self.docType
          : docType // ignore: cast_nullable_to_non_nullable
              as String?,
      docNumber: freezed == docNumber
          ? _self.docNumber
          : docNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      identityRaw: freezed == identityRaw
          ? _self.identityRaw
          : identityRaw // ignore: cast_nullable_to_non_nullable
              as String?,
      termsVersion: freezed == termsVersion
          ? _self.termsVersion
          : termsVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      termsAcceptedAt: freezed == termsAcceptedAt
          ? _self.termsAcceptedAt
          : termsAcceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [UserProfileEntity].
extension UserProfileEntityPatterns on UserProfileEntity {
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
    TResult Function(_UserProfileEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserProfileEntity() when $default != null:
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
    TResult Function(_UserProfileEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfileEntity():
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
    TResult? Function(_UserProfileEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfileEntity() when $default != null:
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
            String uid,
            String phone,
            String? username,
            String? email,
            String? countryId,
            String? regionId,
            String? cityId,
            List<String> roles,
            List<String> orgIds,
            String? docType,
            String? docNumber,
            String? identityRaw,
            String? termsVersion,
            @DateTimeTimestampConverter() DateTime? termsAcceptedAt,
            String status,
            @DateTimeTimestampConverter() DateTime? createdAt,
            @DateTimeTimestampConverter() DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserProfileEntity() when $default != null:
        return $default(
            _that.uid,
            _that.phone,
            _that.username,
            _that.email,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.roles,
            _that.orgIds,
            _that.docType,
            _that.docNumber,
            _that.identityRaw,
            _that.termsVersion,
            _that.termsAcceptedAt,
            _that.status,
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
            String uid,
            String phone,
            String? username,
            String? email,
            String? countryId,
            String? regionId,
            String? cityId,
            List<String> roles,
            List<String> orgIds,
            String? docType,
            String? docNumber,
            String? identityRaw,
            String? termsVersion,
            @DateTimeTimestampConverter() DateTime? termsAcceptedAt,
            String status,
            @DateTimeTimestampConverter() DateTime? createdAt,
            @DateTimeTimestampConverter() DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfileEntity():
        return $default(
            _that.uid,
            _that.phone,
            _that.username,
            _that.email,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.roles,
            _that.orgIds,
            _that.docType,
            _that.docNumber,
            _that.identityRaw,
            _that.termsVersion,
            _that.termsAcceptedAt,
            _that.status,
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
            String uid,
            String phone,
            String? username,
            String? email,
            String? countryId,
            String? regionId,
            String? cityId,
            List<String> roles,
            List<String> orgIds,
            String? docType,
            String? docNumber,
            String? identityRaw,
            String? termsVersion,
            @DateTimeTimestampConverter() DateTime? termsAcceptedAt,
            String status,
            @DateTimeTimestampConverter() DateTime? createdAt,
            @DateTimeTimestampConverter() DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfileEntity() when $default != null:
        return $default(
            _that.uid,
            _that.phone,
            _that.username,
            _that.email,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.roles,
            _that.orgIds,
            _that.docType,
            _that.docNumber,
            _that.identityRaw,
            _that.termsVersion,
            _that.termsAcceptedAt,
            _that.status,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserProfileEntity implements UserProfileEntity {
  const _UserProfileEntity(
      {required this.uid,
      required this.phone,
      this.username,
      this.email,
      this.countryId,
      this.regionId,
      this.cityId,
      final List<String> roles = const <String>[],
      final List<String> orgIds = const <String>[],
      this.docType,
      this.docNumber,
      this.identityRaw,
      this.termsVersion,
      @DateTimeTimestampConverter() this.termsAcceptedAt,
      this.status = 'active',
      @DateTimeTimestampConverter() this.createdAt,
      @DateTimeTimestampConverter() this.updatedAt})
      : _roles = roles,
        _orgIds = orgIds;
  factory _UserProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$UserProfileEntityFromJson(json);

  @override
  final String uid;
  @override
  final String phone;
  @override
  final String? username;
  @override
  final String? email;
  @override
  final String? countryId;
  @override
  final String? regionId;
  @override
  final String? cityId;
  final List<String> _roles;
  @override
  @JsonKey()
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  final List<String> _orgIds;
  @override
  @JsonKey()
  List<String> get orgIds {
    if (_orgIds is EqualUnmodifiableListView) return _orgIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orgIds);
  }

  @override
  final String? docType;
  @override
  final String? docNumber;
  @override
  final String? identityRaw;
  @override
  final String? termsVersion;
  @override
  @DateTimeTimestampConverter()
  final DateTime? termsAcceptedAt;
  @override
  @JsonKey()
  final String status;
  @override
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @override
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  /// Create a copy of UserProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserProfileEntityCopyWith<_UserProfileEntity> get copyWith =>
      __$UserProfileEntityCopyWithImpl<_UserProfileEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserProfileEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserProfileEntity &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            const DeepCollectionEquality().equals(other._orgIds, _orgIds) &&
            (identical(other.docType, docType) || other.docType == docType) &&
            (identical(other.docNumber, docNumber) ||
                other.docNumber == docNumber) &&
            (identical(other.identityRaw, identityRaw) ||
                other.identityRaw == identityRaw) &&
            (identical(other.termsVersion, termsVersion) ||
                other.termsVersion == termsVersion) &&
            (identical(other.termsAcceptedAt, termsAcceptedAt) ||
                other.termsAcceptedAt == termsAcceptedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      phone,
      username,
      email,
      countryId,
      regionId,
      cityId,
      const DeepCollectionEquality().hash(_roles),
      const DeepCollectionEquality().hash(_orgIds),
      docType,
      docNumber,
      identityRaw,
      termsVersion,
      termsAcceptedAt,
      status,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'UserProfileEntity(uid: $uid, phone: $phone, username: $username, email: $email, countryId: $countryId, regionId: $regionId, cityId: $cityId, roles: $roles, orgIds: $orgIds, docType: $docType, docNumber: $docNumber, identityRaw: $identityRaw, termsVersion: $termsVersion, termsAcceptedAt: $termsAcceptedAt, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$UserProfileEntityCopyWith<$Res>
    implements $UserProfileEntityCopyWith<$Res> {
  factory _$UserProfileEntityCopyWith(
          _UserProfileEntity value, $Res Function(_UserProfileEntity) _then) =
      __$UserProfileEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uid,
      String phone,
      String? username,
      String? email,
      String? countryId,
      String? regionId,
      String? cityId,
      List<String> roles,
      List<String> orgIds,
      String? docType,
      String? docNumber,
      String? identityRaw,
      String? termsVersion,
      @DateTimeTimestampConverter() DateTime? termsAcceptedAt,
      String status,
      @DateTimeTimestampConverter() DateTime? createdAt,
      @DateTimeTimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class __$UserProfileEntityCopyWithImpl<$Res>
    implements _$UserProfileEntityCopyWith<$Res> {
  __$UserProfileEntityCopyWithImpl(this._self, this._then);

  final _UserProfileEntity _self;
  final $Res Function(_UserProfileEntity) _then;

  /// Create a copy of UserProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? phone = null,
    Object? username = freezed,
    Object? email = freezed,
    Object? countryId = freezed,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? roles = null,
    Object? orgIds = null,
    Object? docType = freezed,
    Object? docNumber = freezed,
    Object? identityRaw = freezed,
    Object? termsVersion = freezed,
    Object? termsAcceptedAt = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_UserProfileEntity(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      countryId: freezed == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String?,
      regionId: freezed == regionId
          ? _self.regionId
          : regionId // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _self._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      orgIds: null == orgIds
          ? _self._orgIds
          : orgIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      docType: freezed == docType
          ? _self.docType
          : docType // ignore: cast_nullable_to_non_nullable
              as String?,
      docNumber: freezed == docNumber
          ? _self.docNumber
          : docNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      identityRaw: freezed == identityRaw
          ? _self.identityRaw
          : identityRaw // ignore: cast_nullable_to_non_nullable
              as String?,
      termsVersion: freezed == termsVersion
          ? _self.termsVersion
          : termsVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      termsAcceptedAt: freezed == termsAcceptedAt
          ? _self.termsAcceptedAt
          : termsAcceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
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
