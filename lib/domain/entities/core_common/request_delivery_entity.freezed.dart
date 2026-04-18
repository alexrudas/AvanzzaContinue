// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_delivery_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestDeliveryEntity {
  String get id;

  /// FK obligatoria a la Request transportada.
  String get requestId;

  /// Canal del intento (inApp / whatsappExternal / emailExternal / manual).
  DeliveryChannel get channel;

  /// Dirección del delivery (envío saliente o acuse entrante).
  DeliveryDirection get direction;

  /// Estado del delivery.
  DeliveryStatus get status;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Referencia externa (URL de wa.me, threadId de email, id manual libre).
  String? get externalRef;

  /// Valor concreto de llave usada para el envío externo (teléfono/email).
  /// Trazabilidad fina sin exponer otras llaves del destinatario.
  String? get targetKeyValueUsed;
  DateTime? get dispatchedAt;
  DateTime? get deliveredAt;

  /// Motivo de fallo en texto humano-legible. Solo si status = failed.
  String? get failedReason;

  /// Create a copy of RequestDeliveryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RequestDeliveryEntityCopyWith<RequestDeliveryEntity> get copyWith =>
      _$RequestDeliveryEntityCopyWithImpl<RequestDeliveryEntity>(
          this as RequestDeliveryEntity, _$identity);

  /// Serializes this RequestDeliveryEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RequestDeliveryEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.externalRef, externalRef) ||
                other.externalRef == externalRef) &&
            (identical(other.targetKeyValueUsed, targetKeyValueUsed) ||
                other.targetKeyValueUsed == targetKeyValueUsed) &&
            (identical(other.dispatchedAt, dispatchedAt) ||
                other.dispatchedAt == dispatchedAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.failedReason, failedReason) ||
                other.failedReason == failedReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      requestId,
      channel,
      direction,
      status,
      createdAt,
      updatedAt,
      externalRef,
      targetKeyValueUsed,
      dispatchedAt,
      deliveredAt,
      failedReason);

  @override
  String toString() {
    return 'RequestDeliveryEntity(id: $id, requestId: $requestId, channel: $channel, direction: $direction, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, externalRef: $externalRef, targetKeyValueUsed: $targetKeyValueUsed, dispatchedAt: $dispatchedAt, deliveredAt: $deliveredAt, failedReason: $failedReason)';
  }
}

/// @nodoc
abstract mixin class $RequestDeliveryEntityCopyWith<$Res> {
  factory $RequestDeliveryEntityCopyWith(RequestDeliveryEntity value,
          $Res Function(RequestDeliveryEntity) _then) =
      _$RequestDeliveryEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String requestId,
      DeliveryChannel channel,
      DeliveryDirection direction,
      DeliveryStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      String? externalRef,
      String? targetKeyValueUsed,
      DateTime? dispatchedAt,
      DateTime? deliveredAt,
      String? failedReason});
}

/// @nodoc
class _$RequestDeliveryEntityCopyWithImpl<$Res>
    implements $RequestDeliveryEntityCopyWith<$Res> {
  _$RequestDeliveryEntityCopyWithImpl(this._self, this._then);

  final RequestDeliveryEntity _self;
  final $Res Function(RequestDeliveryEntity) _then;

  /// Create a copy of RequestDeliveryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? channel = null,
    Object? direction = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? externalRef = freezed,
    Object? targetKeyValueUsed = freezed,
    Object? dispatchedAt = freezed,
    Object? deliveredAt = freezed,
    Object? failedReason = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _self.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as DeliveryChannel,
      direction: null == direction
          ? _self.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as DeliveryDirection,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as DeliveryStatus,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      externalRef: freezed == externalRef
          ? _self.externalRef
          : externalRef // ignore: cast_nullable_to_non_nullable
              as String?,
      targetKeyValueUsed: freezed == targetKeyValueUsed
          ? _self.targetKeyValueUsed
          : targetKeyValueUsed // ignore: cast_nullable_to_non_nullable
              as String?,
      dispatchedAt: freezed == dispatchedAt
          ? _self.dispatchedAt
          : dispatchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _self.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failedReason: freezed == failedReason
          ? _self.failedReason
          : failedReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RequestDeliveryEntity].
extension RequestDeliveryEntityPatterns on RequestDeliveryEntity {
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
    TResult Function(_RequestDeliveryEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RequestDeliveryEntity() when $default != null:
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
    TResult Function(_RequestDeliveryEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestDeliveryEntity():
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
    TResult? Function(_RequestDeliveryEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestDeliveryEntity() when $default != null:
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
            String requestId,
            DeliveryChannel channel,
            DeliveryDirection direction,
            DeliveryStatus status,
            DateTime createdAt,
            DateTime updatedAt,
            String? externalRef,
            String? targetKeyValueUsed,
            DateTime? dispatchedAt,
            DateTime? deliveredAt,
            String? failedReason)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RequestDeliveryEntity() when $default != null:
        return $default(
            _that.id,
            _that.requestId,
            _that.channel,
            _that.direction,
            _that.status,
            _that.createdAt,
            _that.updatedAt,
            _that.externalRef,
            _that.targetKeyValueUsed,
            _that.dispatchedAt,
            _that.deliveredAt,
            _that.failedReason);
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
            String requestId,
            DeliveryChannel channel,
            DeliveryDirection direction,
            DeliveryStatus status,
            DateTime createdAt,
            DateTime updatedAt,
            String? externalRef,
            String? targetKeyValueUsed,
            DateTime? dispatchedAt,
            DateTime? deliveredAt,
            String? failedReason)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestDeliveryEntity():
        return $default(
            _that.id,
            _that.requestId,
            _that.channel,
            _that.direction,
            _that.status,
            _that.createdAt,
            _that.updatedAt,
            _that.externalRef,
            _that.targetKeyValueUsed,
            _that.dispatchedAt,
            _that.deliveredAt,
            _that.failedReason);
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
            String requestId,
            DeliveryChannel channel,
            DeliveryDirection direction,
            DeliveryStatus status,
            DateTime createdAt,
            DateTime updatedAt,
            String? externalRef,
            String? targetKeyValueUsed,
            DateTime? dispatchedAt,
            DateTime? deliveredAt,
            String? failedReason)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestDeliveryEntity() when $default != null:
        return $default(
            _that.id,
            _that.requestId,
            _that.channel,
            _that.direction,
            _that.status,
            _that.createdAt,
            _that.updatedAt,
            _that.externalRef,
            _that.targetKeyValueUsed,
            _that.dispatchedAt,
            _that.deliveredAt,
            _that.failedReason);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RequestDeliveryEntity implements RequestDeliveryEntity {
  const _RequestDeliveryEntity(
      {required this.id,
      required this.requestId,
      required this.channel,
      required this.direction,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.externalRef,
      this.targetKeyValueUsed,
      this.dispatchedAt,
      this.deliveredAt,
      this.failedReason});
  factory _RequestDeliveryEntity.fromJson(Map<String, dynamic> json) =>
      _$RequestDeliveryEntityFromJson(json);

  @override
  final String id;

  /// FK obligatoria a la Request transportada.
  @override
  final String requestId;

  /// Canal del intento (inApp / whatsappExternal / emailExternal / manual).
  @override
  final DeliveryChannel channel;

  /// Dirección del delivery (envío saliente o acuse entrante).
  @override
  final DeliveryDirection direction;

  /// Estado del delivery.
  @override
  final DeliveryStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Referencia externa (URL de wa.me, threadId de email, id manual libre).
  @override
  final String? externalRef;

  /// Valor concreto de llave usada para el envío externo (teléfono/email).
  /// Trazabilidad fina sin exponer otras llaves del destinatario.
  @override
  final String? targetKeyValueUsed;
  @override
  final DateTime? dispatchedAt;
  @override
  final DateTime? deliveredAt;

  /// Motivo de fallo en texto humano-legible. Solo si status = failed.
  @override
  final String? failedReason;

  /// Create a copy of RequestDeliveryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RequestDeliveryEntityCopyWith<_RequestDeliveryEntity> get copyWith =>
      __$RequestDeliveryEntityCopyWithImpl<_RequestDeliveryEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RequestDeliveryEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RequestDeliveryEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.externalRef, externalRef) ||
                other.externalRef == externalRef) &&
            (identical(other.targetKeyValueUsed, targetKeyValueUsed) ||
                other.targetKeyValueUsed == targetKeyValueUsed) &&
            (identical(other.dispatchedAt, dispatchedAt) ||
                other.dispatchedAt == dispatchedAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.failedReason, failedReason) ||
                other.failedReason == failedReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      requestId,
      channel,
      direction,
      status,
      createdAt,
      updatedAt,
      externalRef,
      targetKeyValueUsed,
      dispatchedAt,
      deliveredAt,
      failedReason);

  @override
  String toString() {
    return 'RequestDeliveryEntity(id: $id, requestId: $requestId, channel: $channel, direction: $direction, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, externalRef: $externalRef, targetKeyValueUsed: $targetKeyValueUsed, dispatchedAt: $dispatchedAt, deliveredAt: $deliveredAt, failedReason: $failedReason)';
  }
}

/// @nodoc
abstract mixin class _$RequestDeliveryEntityCopyWith<$Res>
    implements $RequestDeliveryEntityCopyWith<$Res> {
  factory _$RequestDeliveryEntityCopyWith(_RequestDeliveryEntity value,
          $Res Function(_RequestDeliveryEntity) _then) =
      __$RequestDeliveryEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String requestId,
      DeliveryChannel channel,
      DeliveryDirection direction,
      DeliveryStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      String? externalRef,
      String? targetKeyValueUsed,
      DateTime? dispatchedAt,
      DateTime? deliveredAt,
      String? failedReason});
}

/// @nodoc
class __$RequestDeliveryEntityCopyWithImpl<$Res>
    implements _$RequestDeliveryEntityCopyWith<$Res> {
  __$RequestDeliveryEntityCopyWithImpl(this._self, this._then);

  final _RequestDeliveryEntity _self;
  final $Res Function(_RequestDeliveryEntity) _then;

  /// Create a copy of RequestDeliveryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? channel = null,
    Object? direction = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? externalRef = freezed,
    Object? targetKeyValueUsed = freezed,
    Object? dispatchedAt = freezed,
    Object? deliveredAt = freezed,
    Object? failedReason = freezed,
  }) {
    return _then(_RequestDeliveryEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _self.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as DeliveryChannel,
      direction: null == direction
          ? _self.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as DeliveryDirection,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as DeliveryStatus,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      externalRef: freezed == externalRef
          ? _self.externalRef
          : externalRef // ignore: cast_nullable_to_non_nullable
              as String?,
      targetKeyValueUsed: freezed == targetKeyValueUsed
          ? _self.targetKeyValueUsed
          : targetKeyValueUsed // ignore: cast_nullable_to_non_nullable
              as String?,
      dispatchedAt: freezed == dispatchedAt
          ? _self.dispatchedAt
          : dispatchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _self.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failedReason: freezed == failedReason
          ? _self.failedReason
          : failedReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
