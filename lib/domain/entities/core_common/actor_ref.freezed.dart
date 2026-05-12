// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'actor_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ActorRef _$ActorRefFromJson(Map<String, dynamic> json) {
  switch (json['kind']) {
    case 'platform':
      return ActorRefPlatform.fromJson(json);
    case 'local':
      return ActorRefLocal.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json, 'kind', 'ActorRef', 'Invalid union type "${json['kind']}"!');
  }
}

/// @nodoc
mixin _$ActorRef {
  /// Serializes this ActorRef to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ActorRef);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ActorRef()';
  }
}

/// @nodoc
class $ActorRefCopyWith<$Res> {
  $ActorRefCopyWith(ActorRef _, $Res Function(ActorRef) __);
}

/// Adds pattern-matching-related methods to [ActorRef].
extension ActorRefPatterns on ActorRef {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActorRefPlatform value)? platform,
    TResult Function(ActorRefLocal value)? local,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ActorRefPlatform() when platform != null:
        return platform(_that);
      case ActorRefLocal() when local != null:
        return local(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(ActorRefPlatform value) platform,
    required TResult Function(ActorRefLocal value) local,
  }) {
    final _that = this;
    switch (_that) {
      case ActorRefPlatform():
        return platform(_that);
      case ActorRefLocal():
        return local(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActorRefPlatform value)? platform,
    TResult? Function(ActorRefLocal value)? local,
  }) {
    final _that = this;
    switch (_that) {
      case ActorRefPlatform() when platform != null:
        return platform(_that);
      case ActorRefLocal() when local != null:
        return local(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String platformActorId)? platform,
    TResult Function(LocalKind localKind, String localId)? local,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ActorRefPlatform() when platform != null:
        return platform(_that.platformActorId);
      case ActorRefLocal() when local != null:
        return local(_that.localKind, _that.localId);
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
  TResult when<TResult extends Object?>({
    required TResult Function(String platformActorId) platform,
    required TResult Function(LocalKind localKind, String localId) local,
  }) {
    final _that = this;
    switch (_that) {
      case ActorRefPlatform():
        return platform(_that.platformActorId);
      case ActorRefLocal():
        return local(_that.localKind, _that.localId);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String platformActorId)? platform,
    TResult? Function(LocalKind localKind, String localId)? local,
  }) {
    final _that = this;
    switch (_that) {
      case ActorRefPlatform() when platform != null:
        return platform(_that.platformActorId);
      case ActorRefLocal() when local != null:
        return local(_that.localKind, _that.localId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class ActorRefPlatform implements ActorRef {
  const ActorRefPlatform({required this.platformActorId, final String? $type})
      : $type = $type ?? 'platform';
  factory ActorRefPlatform.fromJson(Map<String, dynamic> json) =>
      _$ActorRefPlatformFromJson(json);

  final String platformActorId;

  @JsonKey(name: 'kind')
  final String $type;

  /// Create a copy of ActorRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActorRefPlatformCopyWith<ActorRefPlatform> get copyWith =>
      _$ActorRefPlatformCopyWithImpl<ActorRefPlatform>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActorRefPlatformToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActorRefPlatform &&
            (identical(other.platformActorId, platformActorId) ||
                other.platformActorId == platformActorId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, platformActorId);

  @override
  String toString() {
    return 'ActorRef.platform(platformActorId: $platformActorId)';
  }
}

/// @nodoc
abstract mixin class $ActorRefPlatformCopyWith<$Res>
    implements $ActorRefCopyWith<$Res> {
  factory $ActorRefPlatformCopyWith(
          ActorRefPlatform value, $Res Function(ActorRefPlatform) _then) =
      _$ActorRefPlatformCopyWithImpl;
  @useResult
  $Res call({String platformActorId});
}

/// @nodoc
class _$ActorRefPlatformCopyWithImpl<$Res>
    implements $ActorRefPlatformCopyWith<$Res> {
  _$ActorRefPlatformCopyWithImpl(this._self, this._then);

  final ActorRefPlatform _self;
  final $Res Function(ActorRefPlatform) _then;

  /// Create a copy of ActorRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? platformActorId = null,
  }) {
    return _then(ActorRefPlatform(
      platformActorId: null == platformActorId
          ? _self.platformActorId
          : platformActorId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class ActorRefLocal implements ActorRef {
  const ActorRefLocal(
      {required this.localKind, required this.localId, final String? $type})
      : $type = $type ?? 'local';
  factory ActorRefLocal.fromJson(Map<String, dynamic> json) =>
      _$ActorRefLocalFromJson(json);

  final LocalKind localKind;
  final String localId;

  @JsonKey(name: 'kind')
  final String $type;

  /// Create a copy of ActorRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActorRefLocalCopyWith<ActorRefLocal> get copyWith =>
      _$ActorRefLocalCopyWithImpl<ActorRefLocal>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActorRefLocalToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActorRefLocal &&
            (identical(other.localKind, localKind) ||
                other.localKind == localKind) &&
            (identical(other.localId, localId) || other.localId == localId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, localKind, localId);

  @override
  String toString() {
    return 'ActorRef.local(localKind: $localKind, localId: $localId)';
  }
}

/// @nodoc
abstract mixin class $ActorRefLocalCopyWith<$Res>
    implements $ActorRefCopyWith<$Res> {
  factory $ActorRefLocalCopyWith(
          ActorRefLocal value, $Res Function(ActorRefLocal) _then) =
      _$ActorRefLocalCopyWithImpl;
  @useResult
  $Res call({LocalKind localKind, String localId});
}

/// @nodoc
class _$ActorRefLocalCopyWithImpl<$Res>
    implements $ActorRefLocalCopyWith<$Res> {
  _$ActorRefLocalCopyWithImpl(this._self, this._then);

  final ActorRefLocal _self;
  final $Res Function(ActorRefLocal) _then;

  /// Create a copy of ActorRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? localKind = null,
    Object? localId = null,
  }) {
    return _then(ActorRefLocal(
      localKind: null == localKind
          ? _self.localKind
          : localKind // ignore: cast_nullable_to_non_nullable
              as LocalKind,
      localId: null == localId
          ? _self.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
