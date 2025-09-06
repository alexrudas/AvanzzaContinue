// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserEntity {
  String get uid;
  String get name;
  String get email;
  String? get phone;
  String? get tipoDoc;
  String? get numDoc;
  String? get countryId;
  String? get preferredLanguage;
  ActiveContext? get activeContext;
  List<AddressEntity>? get addresses;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserEntityCopyWith<UserEntity> get copyWith =>
      _$UserEntityCopyWithImpl<UserEntity>(this as UserEntity, _$identity);

  /// Serializes this UserEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserEntity &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.tipoDoc, tipoDoc) || other.tipoDoc == tipoDoc) &&
            (identical(other.numDoc, numDoc) || other.numDoc == numDoc) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.preferredLanguage, preferredLanguage) ||
                other.preferredLanguage == preferredLanguage) &&
            (identical(other.activeContext, activeContext) ||
                other.activeContext == activeContext) &&
            const DeepCollectionEquality().equals(other.addresses, addresses) &&
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
      name,
      email,
      phone,
      tipoDoc,
      numDoc,
      countryId,
      preferredLanguage,
      activeContext,
      const DeepCollectionEquality().hash(addresses),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'UserEntity(uid: $uid, name: $name, email: $email, phone: $phone, tipoDoc: $tipoDoc, numDoc: $numDoc, countryId: $countryId, preferredLanguage: $preferredLanguage, activeContext: $activeContext, addresses: $addresses, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $UserEntityCopyWith<$Res> {
  factory $UserEntityCopyWith(
          UserEntity value, $Res Function(UserEntity) _then) =
      _$UserEntityCopyWithImpl;
  @useResult
  $Res call(
      {String uid,
      String name,
      String email,
      String? phone,
      String? tipoDoc,
      String? numDoc,
      String? countryId,
      String? preferredLanguage,
      ActiveContext? activeContext,
      List<AddressEntity>? addresses,
      DateTime? createdAt,
      DateTime? updatedAt});

  $ActiveContextCopyWith<$Res>? get activeContext;
}

/// @nodoc
class _$UserEntityCopyWithImpl<$Res> implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._self, this._then);

  final UserEntity _self;
  final $Res Function(UserEntity) _then;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? email = null,
    Object? phone = freezed,
    Object? tipoDoc = freezed,
    Object? numDoc = freezed,
    Object? countryId = freezed,
    Object? preferredLanguage = freezed,
    Object? activeContext = freezed,
    Object? addresses = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      tipoDoc: freezed == tipoDoc
          ? _self.tipoDoc
          : tipoDoc // ignore: cast_nullable_to_non_nullable
              as String?,
      numDoc: freezed == numDoc
          ? _self.numDoc
          : numDoc // ignore: cast_nullable_to_non_nullable
              as String?,
      countryId: freezed == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredLanguage: freezed == preferredLanguage
          ? _self.preferredLanguage
          : preferredLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      activeContext: freezed == activeContext
          ? _self.activeContext
          : activeContext // ignore: cast_nullable_to_non_nullable
              as ActiveContext?,
      addresses: freezed == addresses
          ? _self.addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<AddressEntity>?,
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

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActiveContextCopyWith<$Res>? get activeContext {
    if (_self.activeContext == null) {
      return null;
    }

    return $ActiveContextCopyWith<$Res>(_self.activeContext!, (value) {
      return _then(_self.copyWith(activeContext: value));
    });
  }
}

/// Adds pattern-matching-related methods to [UserEntity].
extension UserEntityPatterns on UserEntity {
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
    TResult Function(_UserEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserEntity() when $default != null:
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
    TResult Function(_UserEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserEntity():
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
    TResult? Function(_UserEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserEntity() when $default != null:
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
            String name,
            String email,
            String? phone,
            String? tipoDoc,
            String? numDoc,
            String? countryId,
            String? preferredLanguage,
            ActiveContext? activeContext,
            List<AddressEntity>? addresses,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserEntity() when $default != null:
        return $default(
            _that.uid,
            _that.name,
            _that.email,
            _that.phone,
            _that.tipoDoc,
            _that.numDoc,
            _that.countryId,
            _that.preferredLanguage,
            _that.activeContext,
            _that.addresses,
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
            String name,
            String email,
            String? phone,
            String? tipoDoc,
            String? numDoc,
            String? countryId,
            String? preferredLanguage,
            ActiveContext? activeContext,
            List<AddressEntity>? addresses,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserEntity():
        return $default(
            _that.uid,
            _that.name,
            _that.email,
            _that.phone,
            _that.tipoDoc,
            _that.numDoc,
            _that.countryId,
            _that.preferredLanguage,
            _that.activeContext,
            _that.addresses,
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
            String name,
            String email,
            String? phone,
            String? tipoDoc,
            String? numDoc,
            String? countryId,
            String? preferredLanguage,
            ActiveContext? activeContext,
            List<AddressEntity>? addresses,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserEntity() when $default != null:
        return $default(
            _that.uid,
            _that.name,
            _that.email,
            _that.phone,
            _that.tipoDoc,
            _that.numDoc,
            _that.countryId,
            _that.preferredLanguage,
            _that.activeContext,
            _that.addresses,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserEntity implements UserEntity {
  const _UserEntity(
      {required this.uid,
      required this.name,
      required this.email,
      this.phone,
      this.tipoDoc,
      this.numDoc,
      this.countryId,
      this.preferredLanguage,
      this.activeContext,
      final List<AddressEntity>? addresses,
      this.createdAt,
      this.updatedAt})
      : _addresses = addresses;
  factory _UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  @override
  final String email;
  @override
  final String? phone;
  @override
  final String? tipoDoc;
  @override
  final String? numDoc;
  @override
  final String? countryId;
  @override
  final String? preferredLanguage;
  @override
  final ActiveContext? activeContext;
  final List<AddressEntity>? _addresses;
  @override
  List<AddressEntity>? get addresses {
    final value = _addresses;
    if (value == null) return null;
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserEntityCopyWith<_UserEntity> get copyWith =>
      __$UserEntityCopyWithImpl<_UserEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserEntity &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.tipoDoc, tipoDoc) || other.tipoDoc == tipoDoc) &&
            (identical(other.numDoc, numDoc) || other.numDoc == numDoc) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.preferredLanguage, preferredLanguage) ||
                other.preferredLanguage == preferredLanguage) &&
            (identical(other.activeContext, activeContext) ||
                other.activeContext == activeContext) &&
            const DeepCollectionEquality()
                .equals(other._addresses, _addresses) &&
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
      name,
      email,
      phone,
      tipoDoc,
      numDoc,
      countryId,
      preferredLanguage,
      activeContext,
      const DeepCollectionEquality().hash(_addresses),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'UserEntity(uid: $uid, name: $name, email: $email, phone: $phone, tipoDoc: $tipoDoc, numDoc: $numDoc, countryId: $countryId, preferredLanguage: $preferredLanguage, activeContext: $activeContext, addresses: $addresses, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$UserEntityCopyWith<$Res>
    implements $UserEntityCopyWith<$Res> {
  factory _$UserEntityCopyWith(
          _UserEntity value, $Res Function(_UserEntity) _then) =
      __$UserEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      String email,
      String? phone,
      String? tipoDoc,
      String? numDoc,
      String? countryId,
      String? preferredLanguage,
      ActiveContext? activeContext,
      List<AddressEntity>? addresses,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $ActiveContextCopyWith<$Res>? get activeContext;
}

/// @nodoc
class __$UserEntityCopyWithImpl<$Res> implements _$UserEntityCopyWith<$Res> {
  __$UserEntityCopyWithImpl(this._self, this._then);

  final _UserEntity _self;
  final $Res Function(_UserEntity) _then;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? email = null,
    Object? phone = freezed,
    Object? tipoDoc = freezed,
    Object? numDoc = freezed,
    Object? countryId = freezed,
    Object? preferredLanguage = freezed,
    Object? activeContext = freezed,
    Object? addresses = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_UserEntity(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      tipoDoc: freezed == tipoDoc
          ? _self.tipoDoc
          : tipoDoc // ignore: cast_nullable_to_non_nullable
              as String?,
      numDoc: freezed == numDoc
          ? _self.numDoc
          : numDoc // ignore: cast_nullable_to_non_nullable
              as String?,
      countryId: freezed == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredLanguage: freezed == preferredLanguage
          ? _self.preferredLanguage
          : preferredLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      activeContext: freezed == activeContext
          ? _self.activeContext
          : activeContext // ignore: cast_nullable_to_non_nullable
              as ActiveContext?,
      addresses: freezed == addresses
          ? _self._addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<AddressEntity>?,
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

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActiveContextCopyWith<$Res>? get activeContext {
    if (_self.activeContext == null) {
      return null;
    }

    return $ActiveContextCopyWith<$Res>(_self.activeContext!, (value) {
      return _then(_self.copyWith(activeContext: value));
    });
  }
}

// dart format on
