// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_session_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSessionEntity {
  String get uid;
  String? get idToken;
  String? get refreshToken;
  String? get deviceId;
  @DateTimeTimestampConverter()
  DateTime? get lastLoginAt;
  Map<String, dynamic>? get activeContext; // {orgId, role, cityId}
  Map<String, dynamic>? get featureFlags;

  /// Create a copy of UserSessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserSessionEntityCopyWith<UserSessionEntity> get copyWith =>
      _$UserSessionEntityCopyWithImpl<UserSessionEntity>(
          this as UserSessionEntity, _$identity);

  /// Serializes this UserSessionEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserSessionEntity &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.idToken, idToken) || other.idToken == idToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            const DeepCollectionEquality()
                .equals(other.activeContext, activeContext) &&
            const DeepCollectionEquality()
                .equals(other.featureFlags, featureFlags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      idToken,
      refreshToken,
      deviceId,
      lastLoginAt,
      const DeepCollectionEquality().hash(activeContext),
      const DeepCollectionEquality().hash(featureFlags));

  @override
  String toString() {
    return 'UserSessionEntity(uid: $uid, idToken: $idToken, refreshToken: $refreshToken, deviceId: $deviceId, lastLoginAt: $lastLoginAt, activeContext: $activeContext, featureFlags: $featureFlags)';
  }
}

/// @nodoc
abstract mixin class $UserSessionEntityCopyWith<$Res> {
  factory $UserSessionEntityCopyWith(
          UserSessionEntity value, $Res Function(UserSessionEntity) _then) =
      _$UserSessionEntityCopyWithImpl;
  @useResult
  $Res call(
      {String uid,
      String? idToken,
      String? refreshToken,
      String? deviceId,
      @DateTimeTimestampConverter() DateTime? lastLoginAt,
      Map<String, dynamic>? activeContext,
      Map<String, dynamic>? featureFlags});
}

/// @nodoc
class _$UserSessionEntityCopyWithImpl<$Res>
    implements $UserSessionEntityCopyWith<$Res> {
  _$UserSessionEntityCopyWithImpl(this._self, this._then);

  final UserSessionEntity _self;
  final $Res Function(UserSessionEntity) _then;

  /// Create a copy of UserSessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? idToken = freezed,
    Object? refreshToken = freezed,
    Object? deviceId = freezed,
    Object? lastLoginAt = freezed,
    Object? activeContext = freezed,
    Object? featureFlags = freezed,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      idToken: freezed == idToken
          ? _self.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLoginAt: freezed == lastLoginAt
          ? _self.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      activeContext: freezed == activeContext
          ? _self.activeContext
          : activeContext // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      featureFlags: freezed == featureFlags
          ? _self.featureFlags
          : featureFlags // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserSessionEntity].
extension UserSessionEntityPatterns on UserSessionEntity {
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
    TResult Function(_UserSessionEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserSessionEntity() when $default != null:
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
    TResult Function(_UserSessionEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSessionEntity():
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
    TResult? Function(_UserSessionEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSessionEntity() when $default != null:
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
            String? idToken,
            String? refreshToken,
            String? deviceId,
            @DateTimeTimestampConverter() DateTime? lastLoginAt,
            Map<String, dynamic>? activeContext,
            Map<String, dynamic>? featureFlags)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserSessionEntity() when $default != null:
        return $default(
            _that.uid,
            _that.idToken,
            _that.refreshToken,
            _that.deviceId,
            _that.lastLoginAt,
            _that.activeContext,
            _that.featureFlags);
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
            String? idToken,
            String? refreshToken,
            String? deviceId,
            @DateTimeTimestampConverter() DateTime? lastLoginAt,
            Map<String, dynamic>? activeContext,
            Map<String, dynamic>? featureFlags)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSessionEntity():
        return $default(
            _that.uid,
            _that.idToken,
            _that.refreshToken,
            _that.deviceId,
            _that.lastLoginAt,
            _that.activeContext,
            _that.featureFlags);
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
            String? idToken,
            String? refreshToken,
            String? deviceId,
            @DateTimeTimestampConverter() DateTime? lastLoginAt,
            Map<String, dynamic>? activeContext,
            Map<String, dynamic>? featureFlags)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSessionEntity() when $default != null:
        return $default(
            _that.uid,
            _that.idToken,
            _that.refreshToken,
            _that.deviceId,
            _that.lastLoginAt,
            _that.activeContext,
            _that.featureFlags);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserSessionEntity implements UserSessionEntity {
  const _UserSessionEntity(
      {required this.uid,
      this.idToken,
      this.refreshToken,
      this.deviceId,
      @DateTimeTimestampConverter() this.lastLoginAt,
      final Map<String, dynamic>? activeContext,
      final Map<String, dynamic>? featureFlags})
      : _activeContext = activeContext,
        _featureFlags = featureFlags;
  factory _UserSessionEntity.fromJson(Map<String, dynamic> json) =>
      _$UserSessionEntityFromJson(json);

  @override
  final String uid;
  @override
  final String? idToken;
  @override
  final String? refreshToken;
  @override
  final String? deviceId;
  @override
  @DateTimeTimestampConverter()
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? _activeContext;
  @override
  Map<String, dynamic>? get activeContext {
    final value = _activeContext;
    if (value == null) return null;
    if (_activeContext is EqualUnmodifiableMapView) return _activeContext;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// {orgId, role, cityId}
  final Map<String, dynamic>? _featureFlags;
// {orgId, role, cityId}
  @override
  Map<String, dynamic>? get featureFlags {
    final value = _featureFlags;
    if (value == null) return null;
    if (_featureFlags is EqualUnmodifiableMapView) return _featureFlags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of UserSessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserSessionEntityCopyWith<_UserSessionEntity> get copyWith =>
      __$UserSessionEntityCopyWithImpl<_UserSessionEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserSessionEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserSessionEntity &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.idToken, idToken) || other.idToken == idToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            const DeepCollectionEquality()
                .equals(other._activeContext, _activeContext) &&
            const DeepCollectionEquality()
                .equals(other._featureFlags, _featureFlags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      idToken,
      refreshToken,
      deviceId,
      lastLoginAt,
      const DeepCollectionEquality().hash(_activeContext),
      const DeepCollectionEquality().hash(_featureFlags));

  @override
  String toString() {
    return 'UserSessionEntity(uid: $uid, idToken: $idToken, refreshToken: $refreshToken, deviceId: $deviceId, lastLoginAt: $lastLoginAt, activeContext: $activeContext, featureFlags: $featureFlags)';
  }
}

/// @nodoc
abstract mixin class _$UserSessionEntityCopyWith<$Res>
    implements $UserSessionEntityCopyWith<$Res> {
  factory _$UserSessionEntityCopyWith(
          _UserSessionEntity value, $Res Function(_UserSessionEntity) _then) =
      __$UserSessionEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uid,
      String? idToken,
      String? refreshToken,
      String? deviceId,
      @DateTimeTimestampConverter() DateTime? lastLoginAt,
      Map<String, dynamic>? activeContext,
      Map<String, dynamic>? featureFlags});
}

/// @nodoc
class __$UserSessionEntityCopyWithImpl<$Res>
    implements _$UserSessionEntityCopyWith<$Res> {
  __$UserSessionEntityCopyWithImpl(this._self, this._then);

  final _UserSessionEntity _self;
  final $Res Function(_UserSessionEntity) _then;

  /// Create a copy of UserSessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? idToken = freezed,
    Object? refreshToken = freezed,
    Object? deviceId = freezed,
    Object? lastLoginAt = freezed,
    Object? activeContext = freezed,
    Object? featureFlags = freezed,
  }) {
    return _then(_UserSessionEntity(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      idToken: freezed == idToken
          ? _self.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLoginAt: freezed == lastLoginAt
          ? _self.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      activeContext: freezed == activeContext
          ? _self._activeContext
          : activeContext // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      featureFlags: freezed == featureFlags
          ? _self._featureFlags
          : featureFlags // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

// dart format on
