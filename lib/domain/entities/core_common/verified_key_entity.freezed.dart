// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verified_key_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerifiedKeyEntity {
  String get id;

  /// FK al PlatformActor dueño de la llave.
  String get platformActorId;

  /// Tipo de llave (phoneE164 / email / docId).
  VerifiedKeyType get keyType;

  /// Valor normalizado de la llave (input estable del matcher).
  String get keyValueNormalized;
  DateTime get verifiedAt;

  /// Método con el que se verificó.
  VerificationMethod get verificationMethod;

  /// Flag de llave principal del actor. Exactamente una por actor = true.
  bool get isPrimary;

  /// Timestamp de revocación. Null = llave vigente.
  DateTime? get revokedAt;

  /// Motivo humano-legible de revocación (auditoría).
  String? get revokedReason;

  /// Create a copy of VerifiedKeyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VerifiedKeyEntityCopyWith<VerifiedKeyEntity> get copyWith =>
      _$VerifiedKeyEntityCopyWithImpl<VerifiedKeyEntity>(
          this as VerifiedKeyEntity, _$identity);

  /// Serializes this VerifiedKeyEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VerifiedKeyEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.platformActorId, platformActorId) ||
                other.platformActorId == platformActorId) &&
            (identical(other.keyType, keyType) || other.keyType == keyType) &&
            (identical(other.keyValueNormalized, keyValueNormalized) ||
                other.keyValueNormalized == keyValueNormalized) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.verificationMethod, verificationMethod) ||
                other.verificationMethod == verificationMethod) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.revokedAt, revokedAt) ||
                other.revokedAt == revokedAt) &&
            (identical(other.revokedReason, revokedReason) ||
                other.revokedReason == revokedReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      platformActorId,
      keyType,
      keyValueNormalized,
      verifiedAt,
      verificationMethod,
      isPrimary,
      revokedAt,
      revokedReason);

  @override
  String toString() {
    return 'VerifiedKeyEntity(id: $id, platformActorId: $platformActorId, keyType: $keyType, keyValueNormalized: $keyValueNormalized, verifiedAt: $verifiedAt, verificationMethod: $verificationMethod, isPrimary: $isPrimary, revokedAt: $revokedAt, revokedReason: $revokedReason)';
  }
}

/// @nodoc
abstract mixin class $VerifiedKeyEntityCopyWith<$Res> {
  factory $VerifiedKeyEntityCopyWith(
          VerifiedKeyEntity value, $Res Function(VerifiedKeyEntity) _then) =
      _$VerifiedKeyEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String platformActorId,
      VerifiedKeyType keyType,
      String keyValueNormalized,
      DateTime verifiedAt,
      VerificationMethod verificationMethod,
      bool isPrimary,
      DateTime? revokedAt,
      String? revokedReason});
}

/// @nodoc
class _$VerifiedKeyEntityCopyWithImpl<$Res>
    implements $VerifiedKeyEntityCopyWith<$Res> {
  _$VerifiedKeyEntityCopyWithImpl(this._self, this._then);

  final VerifiedKeyEntity _self;
  final $Res Function(VerifiedKeyEntity) _then;

  /// Create a copy of VerifiedKeyEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? platformActorId = null,
    Object? keyType = null,
    Object? keyValueNormalized = null,
    Object? verifiedAt = null,
    Object? verificationMethod = null,
    Object? isPrimary = null,
    Object? revokedAt = freezed,
    Object? revokedReason = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      platformActorId: null == platformActorId
          ? _self.platformActorId
          : platformActorId // ignore: cast_nullable_to_non_nullable
              as String,
      keyType: null == keyType
          ? _self.keyType
          : keyType // ignore: cast_nullable_to_non_nullable
              as VerifiedKeyType,
      keyValueNormalized: null == keyValueNormalized
          ? _self.keyValueNormalized
          : keyValueNormalized // ignore: cast_nullable_to_non_nullable
              as String,
      verifiedAt: null == verifiedAt
          ? _self.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      verificationMethod: null == verificationMethod
          ? _self.verificationMethod
          : verificationMethod // ignore: cast_nullable_to_non_nullable
              as VerificationMethod,
      isPrimary: null == isPrimary
          ? _self.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      revokedAt: freezed == revokedAt
          ? _self.revokedAt
          : revokedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      revokedReason: freezed == revokedReason
          ? _self.revokedReason
          : revokedReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [VerifiedKeyEntity].
extension VerifiedKeyEntityPatterns on VerifiedKeyEntity {
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
    TResult Function(_VerifiedKeyEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerifiedKeyEntity() when $default != null:
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
    TResult Function(_VerifiedKeyEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerifiedKeyEntity():
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
    TResult? Function(_VerifiedKeyEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerifiedKeyEntity() when $default != null:
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
            String platformActorId,
            VerifiedKeyType keyType,
            String keyValueNormalized,
            DateTime verifiedAt,
            VerificationMethod verificationMethod,
            bool isPrimary,
            DateTime? revokedAt,
            String? revokedReason)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerifiedKeyEntity() when $default != null:
        return $default(
            _that.id,
            _that.platformActorId,
            _that.keyType,
            _that.keyValueNormalized,
            _that.verifiedAt,
            _that.verificationMethod,
            _that.isPrimary,
            _that.revokedAt,
            _that.revokedReason);
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
            String platformActorId,
            VerifiedKeyType keyType,
            String keyValueNormalized,
            DateTime verifiedAt,
            VerificationMethod verificationMethod,
            bool isPrimary,
            DateTime? revokedAt,
            String? revokedReason)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerifiedKeyEntity():
        return $default(
            _that.id,
            _that.platformActorId,
            _that.keyType,
            _that.keyValueNormalized,
            _that.verifiedAt,
            _that.verificationMethod,
            _that.isPrimary,
            _that.revokedAt,
            _that.revokedReason);
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
            String platformActorId,
            VerifiedKeyType keyType,
            String keyValueNormalized,
            DateTime verifiedAt,
            VerificationMethod verificationMethod,
            bool isPrimary,
            DateTime? revokedAt,
            String? revokedReason)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerifiedKeyEntity() when $default != null:
        return $default(
            _that.id,
            _that.platformActorId,
            _that.keyType,
            _that.keyValueNormalized,
            _that.verifiedAt,
            _that.verificationMethod,
            _that.isPrimary,
            _that.revokedAt,
            _that.revokedReason);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VerifiedKeyEntity implements VerifiedKeyEntity {
  const _VerifiedKeyEntity(
      {required this.id,
      required this.platformActorId,
      required this.keyType,
      required this.keyValueNormalized,
      required this.verifiedAt,
      required this.verificationMethod,
      required this.isPrimary,
      this.revokedAt,
      this.revokedReason});
  factory _VerifiedKeyEntity.fromJson(Map<String, dynamic> json) =>
      _$VerifiedKeyEntityFromJson(json);

  @override
  final String id;

  /// FK al PlatformActor dueño de la llave.
  @override
  final String platformActorId;

  /// Tipo de llave (phoneE164 / email / docId).
  @override
  final VerifiedKeyType keyType;

  /// Valor normalizado de la llave (input estable del matcher).
  @override
  final String keyValueNormalized;
  @override
  final DateTime verifiedAt;

  /// Método con el que se verificó.
  @override
  final VerificationMethod verificationMethod;

  /// Flag de llave principal del actor. Exactamente una por actor = true.
  @override
  final bool isPrimary;

  /// Timestamp de revocación. Null = llave vigente.
  @override
  final DateTime? revokedAt;

  /// Motivo humano-legible de revocación (auditoría).
  @override
  final String? revokedReason;

  /// Create a copy of VerifiedKeyEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VerifiedKeyEntityCopyWith<_VerifiedKeyEntity> get copyWith =>
      __$VerifiedKeyEntityCopyWithImpl<_VerifiedKeyEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VerifiedKeyEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VerifiedKeyEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.platformActorId, platformActorId) ||
                other.platformActorId == platformActorId) &&
            (identical(other.keyType, keyType) || other.keyType == keyType) &&
            (identical(other.keyValueNormalized, keyValueNormalized) ||
                other.keyValueNormalized == keyValueNormalized) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.verificationMethod, verificationMethod) ||
                other.verificationMethod == verificationMethod) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.revokedAt, revokedAt) ||
                other.revokedAt == revokedAt) &&
            (identical(other.revokedReason, revokedReason) ||
                other.revokedReason == revokedReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      platformActorId,
      keyType,
      keyValueNormalized,
      verifiedAt,
      verificationMethod,
      isPrimary,
      revokedAt,
      revokedReason);

  @override
  String toString() {
    return 'VerifiedKeyEntity(id: $id, platformActorId: $platformActorId, keyType: $keyType, keyValueNormalized: $keyValueNormalized, verifiedAt: $verifiedAt, verificationMethod: $verificationMethod, isPrimary: $isPrimary, revokedAt: $revokedAt, revokedReason: $revokedReason)';
  }
}

/// @nodoc
abstract mixin class _$VerifiedKeyEntityCopyWith<$Res>
    implements $VerifiedKeyEntityCopyWith<$Res> {
  factory _$VerifiedKeyEntityCopyWith(
          _VerifiedKeyEntity value, $Res Function(_VerifiedKeyEntity) _then) =
      __$VerifiedKeyEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String platformActorId,
      VerifiedKeyType keyType,
      String keyValueNormalized,
      DateTime verifiedAt,
      VerificationMethod verificationMethod,
      bool isPrimary,
      DateTime? revokedAt,
      String? revokedReason});
}

/// @nodoc
class __$VerifiedKeyEntityCopyWithImpl<$Res>
    implements _$VerifiedKeyEntityCopyWith<$Res> {
  __$VerifiedKeyEntityCopyWithImpl(this._self, this._then);

  final _VerifiedKeyEntity _self;
  final $Res Function(_VerifiedKeyEntity) _then;

  /// Create a copy of VerifiedKeyEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? platformActorId = null,
    Object? keyType = null,
    Object? keyValueNormalized = null,
    Object? verifiedAt = null,
    Object? verificationMethod = null,
    Object? isPrimary = null,
    Object? revokedAt = freezed,
    Object? revokedReason = freezed,
  }) {
    return _then(_VerifiedKeyEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      platformActorId: null == platformActorId
          ? _self.platformActorId
          : platformActorId // ignore: cast_nullable_to_non_nullable
              as String,
      keyType: null == keyType
          ? _self.keyType
          : keyType // ignore: cast_nullable_to_non_nullable
              as VerifiedKeyType,
      keyValueNormalized: null == keyValueNormalized
          ? _self.keyValueNormalized
          : keyValueNormalized // ignore: cast_nullable_to_non_nullable
              as String,
      verifiedAt: null == verifiedAt
          ? _self.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      verificationMethod: null == verificationMethod
          ? _self.verificationMethod
          : verificationMethod // ignore: cast_nullable_to_non_nullable
              as VerificationMethod,
      isPrimary: null == isPrimary
          ? _self.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      revokedAt: freezed == revokedAt
          ? _self.revokedAt
          : revokedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      revokedReason: freezed == revokedReason
          ? _self.revokedReason
          : revokedReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
