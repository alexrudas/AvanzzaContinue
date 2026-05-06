// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_actor_link_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetActorLinkEntity {
  String get id;

  /// Tenancy. orgId del workspace dueño del vínculo.
  String get orgId;

  /// ID del activo. String sin FK mientras no exista modelo Asset en core-api.
  String get assetId;

  /// Rol operativo (enum fuerte del ADR).
  AssetActorRole get role;

  /// Discriminator del ActorRef persistido.
  ActorRefKindValue get actorRefKind;

  /// Fuente del vínculo declarada: user_declared | runt | contract | import.
  String get source;

  /// Estado de verificación del vínculo: verified | pending | unresolved | rejected.
  String get verificationStatus;

  /// Ciclo de vida del vínculo en sí: active | ended.
  String get status;
  DateTime get startedAt;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// FK opcional a PlatformActor (variante platform o enriquecimiento).
  String? get platformActorId;

  /// Tipo de registro local del workspace (variante local).
  TargetLocalKind? get localKind;

  /// ID del registro local (LocalContact.id / LocalOrganization.id).
  String? get localId;

  /// Timestamp de fin del vínculo cuando status='ended'.
  DateTime? get endedAt;

  /// Create a copy of AssetActorLinkEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetActorLinkEntityCopyWith<AssetActorLinkEntity> get copyWith =>
      _$AssetActorLinkEntityCopyWithImpl<AssetActorLinkEntity>(
          this as AssetActorLinkEntity, _$identity);

  /// Serializes this AssetActorLinkEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetActorLinkEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.actorRefKind, actorRefKind) ||
                other.actorRefKind == actorRefKind) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.platformActorId, platformActorId) ||
                other.platformActorId == platformActorId) &&
            (identical(other.localKind, localKind) ||
                other.localKind == localKind) &&
            (identical(other.localId, localId) || other.localId == localId) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orgId,
      assetId,
      role,
      actorRefKind,
      source,
      verificationStatus,
      status,
      startedAt,
      createdAt,
      updatedAt,
      platformActorId,
      localKind,
      localId,
      endedAt);

  @override
  String toString() {
    return 'AssetActorLinkEntity(id: $id, orgId: $orgId, assetId: $assetId, role: $role, actorRefKind: $actorRefKind, source: $source, verificationStatus: $verificationStatus, status: $status, startedAt: $startedAt, createdAt: $createdAt, updatedAt: $updatedAt, platformActorId: $platformActorId, localKind: $localKind, localId: $localId, endedAt: $endedAt)';
  }
}

/// @nodoc
abstract mixin class $AssetActorLinkEntityCopyWith<$Res> {
  factory $AssetActorLinkEntityCopyWith(AssetActorLinkEntity value,
          $Res Function(AssetActorLinkEntity) _then) =
      _$AssetActorLinkEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String assetId,
      AssetActorRole role,
      ActorRefKindValue actorRefKind,
      String source,
      String verificationStatus,
      String status,
      DateTime startedAt,
      DateTime createdAt,
      DateTime updatedAt,
      String? platformActorId,
      TargetLocalKind? localKind,
      String? localId,
      DateTime? endedAt});
}

/// @nodoc
class _$AssetActorLinkEntityCopyWithImpl<$Res>
    implements $AssetActorLinkEntityCopyWith<$Res> {
  _$AssetActorLinkEntityCopyWithImpl(this._self, this._then);

  final AssetActorLinkEntity _self;
  final $Res Function(AssetActorLinkEntity) _then;

  /// Create a copy of AssetActorLinkEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetId = null,
    Object? role = null,
    Object? actorRefKind = null,
    Object? source = null,
    Object? verificationStatus = null,
    Object? status = null,
    Object? startedAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? platformActorId = freezed,
    Object? localKind = freezed,
    Object? localId = freezed,
    Object? endedAt = freezed,
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
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as AssetActorRole,
      actorRefKind: null == actorRefKind
          ? _self.actorRefKind
          : actorRefKind // ignore: cast_nullable_to_non_nullable
              as ActorRefKindValue,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      verificationStatus: null == verificationStatus
          ? _self.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      platformActorId: freezed == platformActorId
          ? _self.platformActorId
          : platformActorId // ignore: cast_nullable_to_non_nullable
              as String?,
      localKind: freezed == localKind
          ? _self.localKind
          : localKind // ignore: cast_nullable_to_non_nullable
              as TargetLocalKind?,
      localId: freezed == localId
          ? _self.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as String?,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AssetActorLinkEntity].
extension AssetActorLinkEntityPatterns on AssetActorLinkEntity {
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
    TResult Function(_AssetActorLinkEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetActorLinkEntity() when $default != null:
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
    TResult Function(_AssetActorLinkEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetActorLinkEntity():
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
    TResult? Function(_AssetActorLinkEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetActorLinkEntity() when $default != null:
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
            String assetId,
            AssetActorRole role,
            ActorRefKindValue actorRefKind,
            String source,
            String verificationStatus,
            String status,
            DateTime startedAt,
            DateTime createdAt,
            DateTime updatedAt,
            String? platformActorId,
            TargetLocalKind? localKind,
            String? localId,
            DateTime? endedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetActorLinkEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.role,
            _that.actorRefKind,
            _that.source,
            _that.verificationStatus,
            _that.status,
            _that.startedAt,
            _that.createdAt,
            _that.updatedAt,
            _that.platformActorId,
            _that.localKind,
            _that.localId,
            _that.endedAt);
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
            String assetId,
            AssetActorRole role,
            ActorRefKindValue actorRefKind,
            String source,
            String verificationStatus,
            String status,
            DateTime startedAt,
            DateTime createdAt,
            DateTime updatedAt,
            String? platformActorId,
            TargetLocalKind? localKind,
            String? localId,
            DateTime? endedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetActorLinkEntity():
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.role,
            _that.actorRefKind,
            _that.source,
            _that.verificationStatus,
            _that.status,
            _that.startedAt,
            _that.createdAt,
            _that.updatedAt,
            _that.platformActorId,
            _that.localKind,
            _that.localId,
            _that.endedAt);
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
            String assetId,
            AssetActorRole role,
            ActorRefKindValue actorRefKind,
            String source,
            String verificationStatus,
            String status,
            DateTime startedAt,
            DateTime createdAt,
            DateTime updatedAt,
            String? platformActorId,
            TargetLocalKind? localKind,
            String? localId,
            DateTime? endedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetActorLinkEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.role,
            _that.actorRefKind,
            _that.source,
            _that.verificationStatus,
            _that.status,
            _that.startedAt,
            _that.createdAt,
            _that.updatedAt,
            _that.platformActorId,
            _that.localKind,
            _that.localId,
            _that.endedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssetActorLinkEntity implements AssetActorLinkEntity {
  const _AssetActorLinkEntity(
      {required this.id,
      required this.orgId,
      required this.assetId,
      required this.role,
      required this.actorRefKind,
      required this.source,
      required this.verificationStatus,
      required this.status,
      required this.startedAt,
      required this.createdAt,
      required this.updatedAt,
      this.platformActorId,
      this.localKind,
      this.localId,
      this.endedAt});
  factory _AssetActorLinkEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetActorLinkEntityFromJson(json);

  @override
  final String id;

  /// Tenancy. orgId del workspace dueño del vínculo.
  @override
  final String orgId;

  /// ID del activo. String sin FK mientras no exista modelo Asset en core-api.
  @override
  final String assetId;

  /// Rol operativo (enum fuerte del ADR).
  @override
  final AssetActorRole role;

  /// Discriminator del ActorRef persistido.
  @override
  final ActorRefKindValue actorRefKind;

  /// Fuente del vínculo declarada: user_declared | runt | contract | import.
  @override
  final String source;

  /// Estado de verificación del vínculo: verified | pending | unresolved | rejected.
  @override
  final String verificationStatus;

  /// Ciclo de vida del vínculo en sí: active | ended.
  @override
  final String status;
  @override
  final DateTime startedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// FK opcional a PlatformActor (variante platform o enriquecimiento).
  @override
  final String? platformActorId;

  /// Tipo de registro local del workspace (variante local).
  @override
  final TargetLocalKind? localKind;

  /// ID del registro local (LocalContact.id / LocalOrganization.id).
  @override
  final String? localId;

  /// Timestamp de fin del vínculo cuando status='ended'.
  @override
  final DateTime? endedAt;

  /// Create a copy of AssetActorLinkEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetActorLinkEntityCopyWith<_AssetActorLinkEntity> get copyWith =>
      __$AssetActorLinkEntityCopyWithImpl<_AssetActorLinkEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetActorLinkEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetActorLinkEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.actorRefKind, actorRefKind) ||
                other.actorRefKind == actorRefKind) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.platformActorId, platformActorId) ||
                other.platformActorId == platformActorId) &&
            (identical(other.localKind, localKind) ||
                other.localKind == localKind) &&
            (identical(other.localId, localId) || other.localId == localId) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orgId,
      assetId,
      role,
      actorRefKind,
      source,
      verificationStatus,
      status,
      startedAt,
      createdAt,
      updatedAt,
      platformActorId,
      localKind,
      localId,
      endedAt);

  @override
  String toString() {
    return 'AssetActorLinkEntity(id: $id, orgId: $orgId, assetId: $assetId, role: $role, actorRefKind: $actorRefKind, source: $source, verificationStatus: $verificationStatus, status: $status, startedAt: $startedAt, createdAt: $createdAt, updatedAt: $updatedAt, platformActorId: $platformActorId, localKind: $localKind, localId: $localId, endedAt: $endedAt)';
  }
}

/// @nodoc
abstract mixin class _$AssetActorLinkEntityCopyWith<$Res>
    implements $AssetActorLinkEntityCopyWith<$Res> {
  factory _$AssetActorLinkEntityCopyWith(_AssetActorLinkEntity value,
          $Res Function(_AssetActorLinkEntity) _then) =
      __$AssetActorLinkEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String assetId,
      AssetActorRole role,
      ActorRefKindValue actorRefKind,
      String source,
      String verificationStatus,
      String status,
      DateTime startedAt,
      DateTime createdAt,
      DateTime updatedAt,
      String? platformActorId,
      TargetLocalKind? localKind,
      String? localId,
      DateTime? endedAt});
}

/// @nodoc
class __$AssetActorLinkEntityCopyWithImpl<$Res>
    implements _$AssetActorLinkEntityCopyWith<$Res> {
  __$AssetActorLinkEntityCopyWithImpl(this._self, this._then);

  final _AssetActorLinkEntity _self;
  final $Res Function(_AssetActorLinkEntity) _then;

  /// Create a copy of AssetActorLinkEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetId = null,
    Object? role = null,
    Object? actorRefKind = null,
    Object? source = null,
    Object? verificationStatus = null,
    Object? status = null,
    Object? startedAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? platformActorId = freezed,
    Object? localKind = freezed,
    Object? localId = freezed,
    Object? endedAt = freezed,
  }) {
    return _then(_AssetActorLinkEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as AssetActorRole,
      actorRefKind: null == actorRefKind
          ? _self.actorRefKind
          : actorRefKind // ignore: cast_nullable_to_non_nullable
              as ActorRefKindValue,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      verificationStatus: null == verificationStatus
          ? _self.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      platformActorId: freezed == platformActorId
          ? _self.platformActorId
          : platformActorId // ignore: cast_nullable_to_non_nullable
              as String?,
      localKind: freezed == localKind
          ? _self.localKind
          : localKind // ignore: cast_nullable_to_non_nullable
              as TargetLocalKind?,
      localId: freezed == localId
          ? _self.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as String?,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
