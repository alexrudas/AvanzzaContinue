// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_actor_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlatformActorEntity {
  String get id;

  /// Discriminador: organización o persona.
  ActorKind get actorKind;

  /// Nombre mostrado en plataforma.
  String get displayName;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Razón social cuando actorKind=organization. Null si person.
  String? get legalName;

  /// Nombre legal completo cuando actorKind=person. Null si organization.
  String? get fullLegalName;

  /// Referencia a avatar en almacenamiento (opcional).
  String? get avatarRef;

  /// FK a la VerifiedKey marcada como primary. Debe existir tras la creación.
  String? get primaryVerifiedKeyId;

  /// Vínculo opcional a User (identidad de auth) cuando actorKind=person.
  /// Null cuando actorKind=organization.
  String? get linkedUserId;

  /// Create a copy of PlatformActorEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlatformActorEntityCopyWith<PlatformActorEntity> get copyWith =>
      _$PlatformActorEntityCopyWithImpl<PlatformActorEntity>(
          this as PlatformActorEntity, _$identity);

  /// Serializes this PlatformActorEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlatformActorEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actorKind, actorKind) ||
                other.actorKind == actorKind) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.legalName, legalName) ||
                other.legalName == legalName) &&
            (identical(other.fullLegalName, fullLegalName) ||
                other.fullLegalName == fullLegalName) &&
            (identical(other.avatarRef, avatarRef) ||
                other.avatarRef == avatarRef) &&
            (identical(other.primaryVerifiedKeyId, primaryVerifiedKeyId) ||
                other.primaryVerifiedKeyId == primaryVerifiedKeyId) &&
            (identical(other.linkedUserId, linkedUserId) ||
                other.linkedUserId == linkedUserId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      actorKind,
      displayName,
      createdAt,
      updatedAt,
      legalName,
      fullLegalName,
      avatarRef,
      primaryVerifiedKeyId,
      linkedUserId);

  @override
  String toString() {
    return 'PlatformActorEntity(id: $id, actorKind: $actorKind, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, legalName: $legalName, fullLegalName: $fullLegalName, avatarRef: $avatarRef, primaryVerifiedKeyId: $primaryVerifiedKeyId, linkedUserId: $linkedUserId)';
  }
}

/// @nodoc
abstract mixin class $PlatformActorEntityCopyWith<$Res> {
  factory $PlatformActorEntityCopyWith(
          PlatformActorEntity value, $Res Function(PlatformActorEntity) _then) =
      _$PlatformActorEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      ActorKind actorKind,
      String displayName,
      DateTime createdAt,
      DateTime updatedAt,
      String? legalName,
      String? fullLegalName,
      String? avatarRef,
      String? primaryVerifiedKeyId,
      String? linkedUserId});
}

/// @nodoc
class _$PlatformActorEntityCopyWithImpl<$Res>
    implements $PlatformActorEntityCopyWith<$Res> {
  _$PlatformActorEntityCopyWithImpl(this._self, this._then);

  final PlatformActorEntity _self;
  final $Res Function(PlatformActorEntity) _then;

  /// Create a copy of PlatformActorEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actorKind = null,
    Object? displayName = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? legalName = freezed,
    Object? fullLegalName = freezed,
    Object? avatarRef = freezed,
    Object? primaryVerifiedKeyId = freezed,
    Object? linkedUserId = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actorKind: null == actorKind
          ? _self.actorKind
          : actorKind // ignore: cast_nullable_to_non_nullable
              as ActorKind,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      legalName: freezed == legalName
          ? _self.legalName
          : legalName // ignore: cast_nullable_to_non_nullable
              as String?,
      fullLegalName: freezed == fullLegalName
          ? _self.fullLegalName
          : fullLegalName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarRef: freezed == avatarRef
          ? _self.avatarRef
          : avatarRef // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryVerifiedKeyId: freezed == primaryVerifiedKeyId
          ? _self.primaryVerifiedKeyId
          : primaryVerifiedKeyId // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedUserId: freezed == linkedUserId
          ? _self.linkedUserId
          : linkedUserId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PlatformActorEntity].
extension PlatformActorEntityPatterns on PlatformActorEntity {
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
    TResult Function(_PlatformActorEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlatformActorEntity() when $default != null:
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
    TResult Function(_PlatformActorEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlatformActorEntity():
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
    TResult? Function(_PlatformActorEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlatformActorEntity() when $default != null:
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
            ActorKind actorKind,
            String displayName,
            DateTime createdAt,
            DateTime updatedAt,
            String? legalName,
            String? fullLegalName,
            String? avatarRef,
            String? primaryVerifiedKeyId,
            String? linkedUserId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlatformActorEntity() when $default != null:
        return $default(
            _that.id,
            _that.actorKind,
            _that.displayName,
            _that.createdAt,
            _that.updatedAt,
            _that.legalName,
            _that.fullLegalName,
            _that.avatarRef,
            _that.primaryVerifiedKeyId,
            _that.linkedUserId);
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
            ActorKind actorKind,
            String displayName,
            DateTime createdAt,
            DateTime updatedAt,
            String? legalName,
            String? fullLegalName,
            String? avatarRef,
            String? primaryVerifiedKeyId,
            String? linkedUserId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlatformActorEntity():
        return $default(
            _that.id,
            _that.actorKind,
            _that.displayName,
            _that.createdAt,
            _that.updatedAt,
            _that.legalName,
            _that.fullLegalName,
            _that.avatarRef,
            _that.primaryVerifiedKeyId,
            _that.linkedUserId);
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
            ActorKind actorKind,
            String displayName,
            DateTime createdAt,
            DateTime updatedAt,
            String? legalName,
            String? fullLegalName,
            String? avatarRef,
            String? primaryVerifiedKeyId,
            String? linkedUserId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlatformActorEntity() when $default != null:
        return $default(
            _that.id,
            _that.actorKind,
            _that.displayName,
            _that.createdAt,
            _that.updatedAt,
            _that.legalName,
            _that.fullLegalName,
            _that.avatarRef,
            _that.primaryVerifiedKeyId,
            _that.linkedUserId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PlatformActorEntity implements PlatformActorEntity {
  const _PlatformActorEntity(
      {required this.id,
      required this.actorKind,
      required this.displayName,
      required this.createdAt,
      required this.updatedAt,
      this.legalName,
      this.fullLegalName,
      this.avatarRef,
      this.primaryVerifiedKeyId,
      this.linkedUserId});
  factory _PlatformActorEntity.fromJson(Map<String, dynamic> json) =>
      _$PlatformActorEntityFromJson(json);

  @override
  final String id;

  /// Discriminador: organización o persona.
  @override
  final ActorKind actorKind;

  /// Nombre mostrado en plataforma.
  @override
  final String displayName;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Razón social cuando actorKind=organization. Null si person.
  @override
  final String? legalName;

  /// Nombre legal completo cuando actorKind=person. Null si organization.
  @override
  final String? fullLegalName;

  /// Referencia a avatar en almacenamiento (opcional).
  @override
  final String? avatarRef;

  /// FK a la VerifiedKey marcada como primary. Debe existir tras la creación.
  @override
  final String? primaryVerifiedKeyId;

  /// Vínculo opcional a User (identidad de auth) cuando actorKind=person.
  /// Null cuando actorKind=organization.
  @override
  final String? linkedUserId;

  /// Create a copy of PlatformActorEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlatformActorEntityCopyWith<_PlatformActorEntity> get copyWith =>
      __$PlatformActorEntityCopyWithImpl<_PlatformActorEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PlatformActorEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlatformActorEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actorKind, actorKind) ||
                other.actorKind == actorKind) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.legalName, legalName) ||
                other.legalName == legalName) &&
            (identical(other.fullLegalName, fullLegalName) ||
                other.fullLegalName == fullLegalName) &&
            (identical(other.avatarRef, avatarRef) ||
                other.avatarRef == avatarRef) &&
            (identical(other.primaryVerifiedKeyId, primaryVerifiedKeyId) ||
                other.primaryVerifiedKeyId == primaryVerifiedKeyId) &&
            (identical(other.linkedUserId, linkedUserId) ||
                other.linkedUserId == linkedUserId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      actorKind,
      displayName,
      createdAt,
      updatedAt,
      legalName,
      fullLegalName,
      avatarRef,
      primaryVerifiedKeyId,
      linkedUserId);

  @override
  String toString() {
    return 'PlatformActorEntity(id: $id, actorKind: $actorKind, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, legalName: $legalName, fullLegalName: $fullLegalName, avatarRef: $avatarRef, primaryVerifiedKeyId: $primaryVerifiedKeyId, linkedUserId: $linkedUserId)';
  }
}

/// @nodoc
abstract mixin class _$PlatformActorEntityCopyWith<$Res>
    implements $PlatformActorEntityCopyWith<$Res> {
  factory _$PlatformActorEntityCopyWith(_PlatformActorEntity value,
          $Res Function(_PlatformActorEntity) _then) =
      __$PlatformActorEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      ActorKind actorKind,
      String displayName,
      DateTime createdAt,
      DateTime updatedAt,
      String? legalName,
      String? fullLegalName,
      String? avatarRef,
      String? primaryVerifiedKeyId,
      String? linkedUserId});
}

/// @nodoc
class __$PlatformActorEntityCopyWithImpl<$Res>
    implements _$PlatformActorEntityCopyWith<$Res> {
  __$PlatformActorEntityCopyWithImpl(this._self, this._then);

  final _PlatformActorEntity _self;
  final $Res Function(_PlatformActorEntity) _then;

  /// Create a copy of PlatformActorEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? actorKind = null,
    Object? displayName = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? legalName = freezed,
    Object? fullLegalName = freezed,
    Object? avatarRef = freezed,
    Object? primaryVerifiedKeyId = freezed,
    Object? linkedUserId = freezed,
  }) {
    return _then(_PlatformActorEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actorKind: null == actorKind
          ? _self.actorKind
          : actorKind // ignore: cast_nullable_to_non_nullable
              as ActorKind,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      legalName: freezed == legalName
          ? _self.legalName
          : legalName // ignore: cast_nullable_to_non_nullable
              as String?,
      fullLegalName: freezed == fullLegalName
          ? _self.fullLegalName
          : fullLegalName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarRef: freezed == avatarRef
          ? _self.avatarRef
          : avatarRef // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryVerifiedKeyId: freezed == primaryVerifiedKeyId
          ? _self.primaryVerifiedKeyId
          : primaryVerifiedKeyId // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedUserId: freezed == linkedUserId
          ? _self.linkedUserId
          : linkedUserId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
