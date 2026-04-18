// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operational_relationship_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OperationalRelationshipEntity {
  String get id;

  /// Workspace dueño de la relación. ≡ orgId del tenant SaaS.
  String get sourceWorkspaceId;

  /// Discriminador del target local.
  TargetLocalKind get targetLocalKind;

  /// FK polimórfica al registro local (LocalOrganization.id o LocalContact.id
  /// según targetLocalKind).
  String get targetLocalId;

  /// Estado actual de la Relación. Gobierno por F2.a.
  RelationshipState get state;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Timestamp de la última transición de estado.
  DateTime get stateUpdatedAt;

  /// Tipología semántica. En v1 siempre 'generic'.
  RelationshipKind get relationshipKind;

  /// FK al PlatformActor confirmado. Null hasta que haya match alto + exposición.
  String? get targetPlatformActorId;

  /// Nivel de confianza del match que ancló al PlatformActor. En v1 solo 'alto'
  /// debería aparecer aquí (otros niveles no promueven a detectable).
  MatchTrustLevel? get matchTrustLevel;

  /// Razón codificada de suspensión. Poblada solo cuando state = suspendida.
  RelationshipSuspensionReason? get suspensionReason;

  /// Timestamps de transiciones clave (trazabilidad).
  DateTime? get activatedUnilaterallyAt;
  DateTime? get linkedAt;
  DateTime? get suspendedAt;
  DateTime? get closedAt;

  /// Placeholder a la futura entidad de invitación (v1.1).
  String? get lastInvitationId;

  /// Create a copy of OperationalRelationshipEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OperationalRelationshipEntityCopyWith<OperationalRelationshipEntity>
      get copyWith => _$OperationalRelationshipEntityCopyWithImpl<
              OperationalRelationshipEntity>(
          this as OperationalRelationshipEntity, _$identity);

  /// Serializes this OperationalRelationshipEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OperationalRelationshipEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceWorkspaceId, sourceWorkspaceId) ||
                other.sourceWorkspaceId == sourceWorkspaceId) &&
            (identical(other.targetLocalKind, targetLocalKind) ||
                other.targetLocalKind == targetLocalKind) &&
            (identical(other.targetLocalId, targetLocalId) ||
                other.targetLocalId == targetLocalId) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.stateUpdatedAt, stateUpdatedAt) ||
                other.stateUpdatedAt == stateUpdatedAt) &&
            (identical(other.relationshipKind, relationshipKind) ||
                other.relationshipKind == relationshipKind) &&
            (identical(other.targetPlatformActorId, targetPlatformActorId) ||
                other.targetPlatformActorId == targetPlatformActorId) &&
            (identical(other.matchTrustLevel, matchTrustLevel) ||
                other.matchTrustLevel == matchTrustLevel) &&
            (identical(other.suspensionReason, suspensionReason) ||
                other.suspensionReason == suspensionReason) &&
            (identical(
                    other.activatedUnilaterallyAt, activatedUnilaterallyAt) ||
                other.activatedUnilaterallyAt == activatedUnilaterallyAt) &&
            (identical(other.linkedAt, linkedAt) ||
                other.linkedAt == linkedAt) &&
            (identical(other.suspendedAt, suspendedAt) ||
                other.suspendedAt == suspendedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.lastInvitationId, lastInvitationId) ||
                other.lastInvitationId == lastInvitationId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sourceWorkspaceId,
      targetLocalKind,
      targetLocalId,
      state,
      createdAt,
      updatedAt,
      stateUpdatedAt,
      relationshipKind,
      targetPlatformActorId,
      matchTrustLevel,
      suspensionReason,
      activatedUnilaterallyAt,
      linkedAt,
      suspendedAt,
      closedAt,
      lastInvitationId);

  @override
  String toString() {
    return 'OperationalRelationshipEntity(id: $id, sourceWorkspaceId: $sourceWorkspaceId, targetLocalKind: $targetLocalKind, targetLocalId: $targetLocalId, state: $state, createdAt: $createdAt, updatedAt: $updatedAt, stateUpdatedAt: $stateUpdatedAt, relationshipKind: $relationshipKind, targetPlatformActorId: $targetPlatformActorId, matchTrustLevel: $matchTrustLevel, suspensionReason: $suspensionReason, activatedUnilaterallyAt: $activatedUnilaterallyAt, linkedAt: $linkedAt, suspendedAt: $suspendedAt, closedAt: $closedAt, lastInvitationId: $lastInvitationId)';
  }
}

/// @nodoc
abstract mixin class $OperationalRelationshipEntityCopyWith<$Res> {
  factory $OperationalRelationshipEntityCopyWith(
          OperationalRelationshipEntity value,
          $Res Function(OperationalRelationshipEntity) _then) =
      _$OperationalRelationshipEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String sourceWorkspaceId,
      TargetLocalKind targetLocalKind,
      String targetLocalId,
      RelationshipState state,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime stateUpdatedAt,
      RelationshipKind relationshipKind,
      String? targetPlatformActorId,
      MatchTrustLevel? matchTrustLevel,
      RelationshipSuspensionReason? suspensionReason,
      DateTime? activatedUnilaterallyAt,
      DateTime? linkedAt,
      DateTime? suspendedAt,
      DateTime? closedAt,
      String? lastInvitationId});
}

/// @nodoc
class _$OperationalRelationshipEntityCopyWithImpl<$Res>
    implements $OperationalRelationshipEntityCopyWith<$Res> {
  _$OperationalRelationshipEntityCopyWithImpl(this._self, this._then);

  final OperationalRelationshipEntity _self;
  final $Res Function(OperationalRelationshipEntity) _then;

  /// Create a copy of OperationalRelationshipEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceWorkspaceId = null,
    Object? targetLocalKind = null,
    Object? targetLocalId = null,
    Object? state = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? stateUpdatedAt = null,
    Object? relationshipKind = null,
    Object? targetPlatformActorId = freezed,
    Object? matchTrustLevel = freezed,
    Object? suspensionReason = freezed,
    Object? activatedUnilaterallyAt = freezed,
    Object? linkedAt = freezed,
    Object? suspendedAt = freezed,
    Object? closedAt = freezed,
    Object? lastInvitationId = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWorkspaceId: null == sourceWorkspaceId
          ? _self.sourceWorkspaceId
          : sourceWorkspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      targetLocalKind: null == targetLocalKind
          ? _self.targetLocalKind
          : targetLocalKind // ignore: cast_nullable_to_non_nullable
              as TargetLocalKind,
      targetLocalId: null == targetLocalId
          ? _self.targetLocalId
          : targetLocalId // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as RelationshipState,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      stateUpdatedAt: null == stateUpdatedAt
          ? _self.stateUpdatedAt
          : stateUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      relationshipKind: null == relationshipKind
          ? _self.relationshipKind
          : relationshipKind // ignore: cast_nullable_to_non_nullable
              as RelationshipKind,
      targetPlatformActorId: freezed == targetPlatformActorId
          ? _self.targetPlatformActorId
          : targetPlatformActorId // ignore: cast_nullable_to_non_nullable
              as String?,
      matchTrustLevel: freezed == matchTrustLevel
          ? _self.matchTrustLevel
          : matchTrustLevel // ignore: cast_nullable_to_non_nullable
              as MatchTrustLevel?,
      suspensionReason: freezed == suspensionReason
          ? _self.suspensionReason
          : suspensionReason // ignore: cast_nullable_to_non_nullable
              as RelationshipSuspensionReason?,
      activatedUnilaterallyAt: freezed == activatedUnilaterallyAt
          ? _self.activatedUnilaterallyAt
          : activatedUnilaterallyAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      linkedAt: freezed == linkedAt
          ? _self.linkedAt
          : linkedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      suspendedAt: freezed == suspendedAt
          ? _self.suspendedAt
          : suspendedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastInvitationId: freezed == lastInvitationId
          ? _self.lastInvitationId
          : lastInvitationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [OperationalRelationshipEntity].
extension OperationalRelationshipEntityPatterns
    on OperationalRelationshipEntity {
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
    TResult Function(_OperationalRelationshipEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OperationalRelationshipEntity() when $default != null:
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
    TResult Function(_OperationalRelationshipEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OperationalRelationshipEntity():
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
    TResult? Function(_OperationalRelationshipEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OperationalRelationshipEntity() when $default != null:
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
            String sourceWorkspaceId,
            TargetLocalKind targetLocalKind,
            String targetLocalId,
            RelationshipState state,
            DateTime createdAt,
            DateTime updatedAt,
            DateTime stateUpdatedAt,
            RelationshipKind relationshipKind,
            String? targetPlatformActorId,
            MatchTrustLevel? matchTrustLevel,
            RelationshipSuspensionReason? suspensionReason,
            DateTime? activatedUnilaterallyAt,
            DateTime? linkedAt,
            DateTime? suspendedAt,
            DateTime? closedAt,
            String? lastInvitationId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OperationalRelationshipEntity() when $default != null:
        return $default(
            _that.id,
            _that.sourceWorkspaceId,
            _that.targetLocalKind,
            _that.targetLocalId,
            _that.state,
            _that.createdAt,
            _that.updatedAt,
            _that.stateUpdatedAt,
            _that.relationshipKind,
            _that.targetPlatformActorId,
            _that.matchTrustLevel,
            _that.suspensionReason,
            _that.activatedUnilaterallyAt,
            _that.linkedAt,
            _that.suspendedAt,
            _that.closedAt,
            _that.lastInvitationId);
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
            String sourceWorkspaceId,
            TargetLocalKind targetLocalKind,
            String targetLocalId,
            RelationshipState state,
            DateTime createdAt,
            DateTime updatedAt,
            DateTime stateUpdatedAt,
            RelationshipKind relationshipKind,
            String? targetPlatformActorId,
            MatchTrustLevel? matchTrustLevel,
            RelationshipSuspensionReason? suspensionReason,
            DateTime? activatedUnilaterallyAt,
            DateTime? linkedAt,
            DateTime? suspendedAt,
            DateTime? closedAt,
            String? lastInvitationId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OperationalRelationshipEntity():
        return $default(
            _that.id,
            _that.sourceWorkspaceId,
            _that.targetLocalKind,
            _that.targetLocalId,
            _that.state,
            _that.createdAt,
            _that.updatedAt,
            _that.stateUpdatedAt,
            _that.relationshipKind,
            _that.targetPlatformActorId,
            _that.matchTrustLevel,
            _that.suspensionReason,
            _that.activatedUnilaterallyAt,
            _that.linkedAt,
            _that.suspendedAt,
            _that.closedAt,
            _that.lastInvitationId);
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
            String sourceWorkspaceId,
            TargetLocalKind targetLocalKind,
            String targetLocalId,
            RelationshipState state,
            DateTime createdAt,
            DateTime updatedAt,
            DateTime stateUpdatedAt,
            RelationshipKind relationshipKind,
            String? targetPlatformActorId,
            MatchTrustLevel? matchTrustLevel,
            RelationshipSuspensionReason? suspensionReason,
            DateTime? activatedUnilaterallyAt,
            DateTime? linkedAt,
            DateTime? suspendedAt,
            DateTime? closedAt,
            String? lastInvitationId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OperationalRelationshipEntity() when $default != null:
        return $default(
            _that.id,
            _that.sourceWorkspaceId,
            _that.targetLocalKind,
            _that.targetLocalId,
            _that.state,
            _that.createdAt,
            _that.updatedAt,
            _that.stateUpdatedAt,
            _that.relationshipKind,
            _that.targetPlatformActorId,
            _that.matchTrustLevel,
            _that.suspensionReason,
            _that.activatedUnilaterallyAt,
            _that.linkedAt,
            _that.suspendedAt,
            _that.closedAt,
            _that.lastInvitationId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OperationalRelationshipEntity implements OperationalRelationshipEntity {
  const _OperationalRelationshipEntity(
      {required this.id,
      required this.sourceWorkspaceId,
      required this.targetLocalKind,
      required this.targetLocalId,
      required this.state,
      required this.createdAt,
      required this.updatedAt,
      required this.stateUpdatedAt,
      this.relationshipKind = RelationshipKind.generic,
      this.targetPlatformActorId,
      this.matchTrustLevel,
      this.suspensionReason,
      this.activatedUnilaterallyAt,
      this.linkedAt,
      this.suspendedAt,
      this.closedAt,
      this.lastInvitationId});
  factory _OperationalRelationshipEntity.fromJson(Map<String, dynamic> json) =>
      _$OperationalRelationshipEntityFromJson(json);

  @override
  final String id;

  /// Workspace dueño de la relación. ≡ orgId del tenant SaaS.
  @override
  final String sourceWorkspaceId;

  /// Discriminador del target local.
  @override
  final TargetLocalKind targetLocalKind;

  /// FK polimórfica al registro local (LocalOrganization.id o LocalContact.id
  /// según targetLocalKind).
  @override
  final String targetLocalId;

  /// Estado actual de la Relación. Gobierno por F2.a.
  @override
  final RelationshipState state;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Timestamp de la última transición de estado.
  @override
  final DateTime stateUpdatedAt;

  /// Tipología semántica. En v1 siempre 'generic'.
  @override
  @JsonKey()
  final RelationshipKind relationshipKind;

  /// FK al PlatformActor confirmado. Null hasta que haya match alto + exposición.
  @override
  final String? targetPlatformActorId;

  /// Nivel de confianza del match que ancló al PlatformActor. En v1 solo 'alto'
  /// debería aparecer aquí (otros niveles no promueven a detectable).
  @override
  final MatchTrustLevel? matchTrustLevel;

  /// Razón codificada de suspensión. Poblada solo cuando state = suspendida.
  @override
  final RelationshipSuspensionReason? suspensionReason;

  /// Timestamps de transiciones clave (trazabilidad).
  @override
  final DateTime? activatedUnilaterallyAt;
  @override
  final DateTime? linkedAt;
  @override
  final DateTime? suspendedAt;
  @override
  final DateTime? closedAt;

  /// Placeholder a la futura entidad de invitación (v1.1).
  @override
  final String? lastInvitationId;

  /// Create a copy of OperationalRelationshipEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OperationalRelationshipEntityCopyWith<_OperationalRelationshipEntity>
      get copyWith => __$OperationalRelationshipEntityCopyWithImpl<
          _OperationalRelationshipEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OperationalRelationshipEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OperationalRelationshipEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceWorkspaceId, sourceWorkspaceId) ||
                other.sourceWorkspaceId == sourceWorkspaceId) &&
            (identical(other.targetLocalKind, targetLocalKind) ||
                other.targetLocalKind == targetLocalKind) &&
            (identical(other.targetLocalId, targetLocalId) ||
                other.targetLocalId == targetLocalId) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.stateUpdatedAt, stateUpdatedAt) ||
                other.stateUpdatedAt == stateUpdatedAt) &&
            (identical(other.relationshipKind, relationshipKind) ||
                other.relationshipKind == relationshipKind) &&
            (identical(other.targetPlatformActorId, targetPlatformActorId) ||
                other.targetPlatformActorId == targetPlatformActorId) &&
            (identical(other.matchTrustLevel, matchTrustLevel) ||
                other.matchTrustLevel == matchTrustLevel) &&
            (identical(other.suspensionReason, suspensionReason) ||
                other.suspensionReason == suspensionReason) &&
            (identical(
                    other.activatedUnilaterallyAt, activatedUnilaterallyAt) ||
                other.activatedUnilaterallyAt == activatedUnilaterallyAt) &&
            (identical(other.linkedAt, linkedAt) ||
                other.linkedAt == linkedAt) &&
            (identical(other.suspendedAt, suspendedAt) ||
                other.suspendedAt == suspendedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.lastInvitationId, lastInvitationId) ||
                other.lastInvitationId == lastInvitationId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sourceWorkspaceId,
      targetLocalKind,
      targetLocalId,
      state,
      createdAt,
      updatedAt,
      stateUpdatedAt,
      relationshipKind,
      targetPlatformActorId,
      matchTrustLevel,
      suspensionReason,
      activatedUnilaterallyAt,
      linkedAt,
      suspendedAt,
      closedAt,
      lastInvitationId);

  @override
  String toString() {
    return 'OperationalRelationshipEntity(id: $id, sourceWorkspaceId: $sourceWorkspaceId, targetLocalKind: $targetLocalKind, targetLocalId: $targetLocalId, state: $state, createdAt: $createdAt, updatedAt: $updatedAt, stateUpdatedAt: $stateUpdatedAt, relationshipKind: $relationshipKind, targetPlatformActorId: $targetPlatformActorId, matchTrustLevel: $matchTrustLevel, suspensionReason: $suspensionReason, activatedUnilaterallyAt: $activatedUnilaterallyAt, linkedAt: $linkedAt, suspendedAt: $suspendedAt, closedAt: $closedAt, lastInvitationId: $lastInvitationId)';
  }
}

/// @nodoc
abstract mixin class _$OperationalRelationshipEntityCopyWith<$Res>
    implements $OperationalRelationshipEntityCopyWith<$Res> {
  factory _$OperationalRelationshipEntityCopyWith(
          _OperationalRelationshipEntity value,
          $Res Function(_OperationalRelationshipEntity) _then) =
      __$OperationalRelationshipEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String sourceWorkspaceId,
      TargetLocalKind targetLocalKind,
      String targetLocalId,
      RelationshipState state,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime stateUpdatedAt,
      RelationshipKind relationshipKind,
      String? targetPlatformActorId,
      MatchTrustLevel? matchTrustLevel,
      RelationshipSuspensionReason? suspensionReason,
      DateTime? activatedUnilaterallyAt,
      DateTime? linkedAt,
      DateTime? suspendedAt,
      DateTime? closedAt,
      String? lastInvitationId});
}

/// @nodoc
class __$OperationalRelationshipEntityCopyWithImpl<$Res>
    implements _$OperationalRelationshipEntityCopyWith<$Res> {
  __$OperationalRelationshipEntityCopyWithImpl(this._self, this._then);

  final _OperationalRelationshipEntity _self;
  final $Res Function(_OperationalRelationshipEntity) _then;

  /// Create a copy of OperationalRelationshipEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sourceWorkspaceId = null,
    Object? targetLocalKind = null,
    Object? targetLocalId = null,
    Object? state = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? stateUpdatedAt = null,
    Object? relationshipKind = null,
    Object? targetPlatformActorId = freezed,
    Object? matchTrustLevel = freezed,
    Object? suspensionReason = freezed,
    Object? activatedUnilaterallyAt = freezed,
    Object? linkedAt = freezed,
    Object? suspendedAt = freezed,
    Object? closedAt = freezed,
    Object? lastInvitationId = freezed,
  }) {
    return _then(_OperationalRelationshipEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWorkspaceId: null == sourceWorkspaceId
          ? _self.sourceWorkspaceId
          : sourceWorkspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      targetLocalKind: null == targetLocalKind
          ? _self.targetLocalKind
          : targetLocalKind // ignore: cast_nullable_to_non_nullable
              as TargetLocalKind,
      targetLocalId: null == targetLocalId
          ? _self.targetLocalId
          : targetLocalId // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as RelationshipState,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      stateUpdatedAt: null == stateUpdatedAt
          ? _self.stateUpdatedAt
          : stateUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      relationshipKind: null == relationshipKind
          ? _self.relationshipKind
          : relationshipKind // ignore: cast_nullable_to_non_nullable
              as RelationshipKind,
      targetPlatformActorId: freezed == targetPlatformActorId
          ? _self.targetPlatformActorId
          : targetPlatformActorId // ignore: cast_nullable_to_non_nullable
              as String?,
      matchTrustLevel: freezed == matchTrustLevel
          ? _self.matchTrustLevel
          : matchTrustLevel // ignore: cast_nullable_to_non_nullable
              as MatchTrustLevel?,
      suspensionReason: freezed == suspensionReason
          ? _self.suspensionReason
          : suspensionReason // ignore: cast_nullable_to_non_nullable
              as RelationshipSuspensionReason?,
      activatedUnilaterallyAt: freezed == activatedUnilaterallyAt
          ? _self.activatedUnilaterallyAt
          : activatedUnilaterallyAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      linkedAt: freezed == linkedAt
          ? _self.linkedAt
          : linkedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      suspendedAt: freezed == suspendedAt
          ? _self.suspendedAt
          : suspendedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastInvitationId: freezed == lastInvitationId
          ? _self.lastInvitationId
          : lastInvitationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
