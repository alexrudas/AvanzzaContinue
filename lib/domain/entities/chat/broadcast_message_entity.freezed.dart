// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'broadcast_message_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BroadcastMessageEntity {
  String get id;
  String get adminId;
  String get orgId;
  String? get rolObjetivo;
  String get message;
  DateTime get timestamp;
  String? get countryId;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of BroadcastMessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BroadcastMessageEntityCopyWith<BroadcastMessageEntity> get copyWith =>
      _$BroadcastMessageEntityCopyWithImpl<BroadcastMessageEntity>(
          this as BroadcastMessageEntity, _$identity);

  /// Serializes this BroadcastMessageEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BroadcastMessageEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.adminId, adminId) || other.adminId == adminId) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.rolObjetivo, rolObjetivo) ||
                other.rolObjetivo == rolObjetivo) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, adminId, orgId, rolObjetivo,
      message, timestamp, countryId, createdAt, updatedAt);

  @override
  String toString() {
    return 'BroadcastMessageEntity(id: $id, adminId: $adminId, orgId: $orgId, rolObjetivo: $rolObjetivo, message: $message, timestamp: $timestamp, countryId: $countryId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $BroadcastMessageEntityCopyWith<$Res> {
  factory $BroadcastMessageEntityCopyWith(BroadcastMessageEntity value,
          $Res Function(BroadcastMessageEntity) _then) =
      _$BroadcastMessageEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String adminId,
      String orgId,
      String? rolObjetivo,
      String message,
      DateTime timestamp,
      String? countryId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$BroadcastMessageEntityCopyWithImpl<$Res>
    implements $BroadcastMessageEntityCopyWith<$Res> {
  _$BroadcastMessageEntityCopyWithImpl(this._self, this._then);

  final BroadcastMessageEntity _self;
  final $Res Function(BroadcastMessageEntity) _then;

  /// Create a copy of BroadcastMessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? adminId = null,
    Object? orgId = null,
    Object? rolObjetivo = freezed,
    Object? message = null,
    Object? timestamp = null,
    Object? countryId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      adminId: null == adminId
          ? _self.adminId
          : adminId // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      rolObjetivo: freezed == rolObjetivo
          ? _self.rolObjetivo
          : rolObjetivo // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      countryId: freezed == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [BroadcastMessageEntity].
extension BroadcastMessageEntityPatterns on BroadcastMessageEntity {
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
    TResult Function(_BroadcastMessageEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BroadcastMessageEntity() when $default != null:
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
    TResult Function(_BroadcastMessageEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BroadcastMessageEntity():
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
    TResult? Function(_BroadcastMessageEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BroadcastMessageEntity() when $default != null:
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
            String adminId,
            String orgId,
            String? rolObjetivo,
            String message,
            DateTime timestamp,
            String? countryId,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BroadcastMessageEntity() when $default != null:
        return $default(
            _that.id,
            _that.adminId,
            _that.orgId,
            _that.rolObjetivo,
            _that.message,
            _that.timestamp,
            _that.countryId,
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
            String adminId,
            String orgId,
            String? rolObjetivo,
            String message,
            DateTime timestamp,
            String? countryId,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BroadcastMessageEntity():
        return $default(
            _that.id,
            _that.adminId,
            _that.orgId,
            _that.rolObjetivo,
            _that.message,
            _that.timestamp,
            _that.countryId,
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
            String adminId,
            String orgId,
            String? rolObjetivo,
            String message,
            DateTime timestamp,
            String? countryId,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BroadcastMessageEntity() when $default != null:
        return $default(
            _that.id,
            _that.adminId,
            _that.orgId,
            _that.rolObjetivo,
            _that.message,
            _that.timestamp,
            _that.countryId,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BroadcastMessageEntity implements BroadcastMessageEntity {
  const _BroadcastMessageEntity(
      {required this.id,
      required this.adminId,
      required this.orgId,
      this.rolObjetivo,
      required this.message,
      required this.timestamp,
      this.countryId,
      this.createdAt,
      this.updatedAt});
  factory _BroadcastMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$BroadcastMessageEntityFromJson(json);

  @override
  final String id;
  @override
  final String adminId;
  @override
  final String orgId;
  @override
  final String? rolObjetivo;
  @override
  final String message;
  @override
  final DateTime timestamp;
  @override
  final String? countryId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of BroadcastMessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BroadcastMessageEntityCopyWith<_BroadcastMessageEntity> get copyWith =>
      __$BroadcastMessageEntityCopyWithImpl<_BroadcastMessageEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BroadcastMessageEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BroadcastMessageEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.adminId, adminId) || other.adminId == adminId) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.rolObjetivo, rolObjetivo) ||
                other.rolObjetivo == rolObjetivo) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, adminId, orgId, rolObjetivo,
      message, timestamp, countryId, createdAt, updatedAt);

  @override
  String toString() {
    return 'BroadcastMessageEntity(id: $id, adminId: $adminId, orgId: $orgId, rolObjetivo: $rolObjetivo, message: $message, timestamp: $timestamp, countryId: $countryId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$BroadcastMessageEntityCopyWith<$Res>
    implements $BroadcastMessageEntityCopyWith<$Res> {
  factory _$BroadcastMessageEntityCopyWith(_BroadcastMessageEntity value,
          $Res Function(_BroadcastMessageEntity) _then) =
      __$BroadcastMessageEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String adminId,
      String orgId,
      String? rolObjetivo,
      String message,
      DateTime timestamp,
      String? countryId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$BroadcastMessageEntityCopyWithImpl<$Res>
    implements _$BroadcastMessageEntityCopyWith<$Res> {
  __$BroadcastMessageEntityCopyWithImpl(this._self, this._then);

  final _BroadcastMessageEntity _self;
  final $Res Function(_BroadcastMessageEntity) _then;

  /// Create a copy of BroadcastMessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? adminId = null,
    Object? orgId = null,
    Object? rolObjetivo = freezed,
    Object? message = null,
    Object? timestamp = null,
    Object? countryId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_BroadcastMessageEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      adminId: null == adminId
          ? _self.adminId
          : adminId // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      rolObjetivo: freezed == rolObjetivo
          ? _self.rolObjetivo
          : rolObjetivo // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      countryId: freezed == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
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
