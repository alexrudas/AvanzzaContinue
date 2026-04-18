// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_candidate_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MatchCandidateEntity {
  String get id;

  /// Workspace dueño del registro local involucrado.
  /// Derivable pero incluido para filtrado eficiente en cliente.
  String get sourceWorkspaceId;

  /// Tipo del registro local implicado.
  TargetLocalKind get localKind;

  /// FK polimórfica al registro local (LocalOrganization.id o LocalContact.id).
  String get localId;

  /// FK al PlatformActor candidato.
  String get platformActorId;

  /// Tipo de llave que generó el match.
  VerifiedKeyType get matchedKeyType;

  /// Valor de la llave que generó el match (normalizado).
  String get matchedKeyValue;

  /// Nivel de confianza asignado por el matcher.
  MatchTrustLevel get trustLevel;

  /// Estado del candidato (detección interna → exposición → resolución).
  MatchCandidateState get state;
  DateTime get detectedAt;
  DateTime get updatedAt;
  DateTime? get exposedAt;
  DateTime? get dismissedAt;
  DateTime? get confirmedAt;

  /// Si el candidato se promovió a una Relación Operativa.
  String? get resultingRelationshipId;

  /// Hook D8: colisiones detectadas sobre este candidato. Vacío en el caso feliz.
  List<CollisionKind> get collisionKinds;

  /// Hook D8: true cuando existe alguna colisión marcada (aunque no sea crítica).
  /// Permite filtrar candidatos con conflicto sin recorrer la lista.
  bool get isConflictMarked;

  /// Hook D8: true cuando la colisión afecta routing/identidad activa.
  /// Disparador de la suspensión automática (ver
  /// RelationshipSuspensionReason.platformKeyReassignedCritical).
  bool get isCriticalConflict;

  /// Create a copy of MatchCandidateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MatchCandidateEntityCopyWith<MatchCandidateEntity> get copyWith =>
      _$MatchCandidateEntityCopyWithImpl<MatchCandidateEntity>(
          this as MatchCandidateEntity, _$identity);

  /// Serializes this MatchCandidateEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MatchCandidateEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceWorkspaceId, sourceWorkspaceId) ||
                other.sourceWorkspaceId == sourceWorkspaceId) &&
            (identical(other.localKind, localKind) ||
                other.localKind == localKind) &&
            (identical(other.localId, localId) || other.localId == localId) &&
            (identical(other.platformActorId, platformActorId) ||
                other.platformActorId == platformActorId) &&
            (identical(other.matchedKeyType, matchedKeyType) ||
                other.matchedKeyType == matchedKeyType) &&
            (identical(other.matchedKeyValue, matchedKeyValue) ||
                other.matchedKeyValue == matchedKeyValue) &&
            (identical(other.trustLevel, trustLevel) ||
                other.trustLevel == trustLevel) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.detectedAt, detectedAt) ||
                other.detectedAt == detectedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.exposedAt, exposedAt) ||
                other.exposedAt == exposedAt) &&
            (identical(other.dismissedAt, dismissedAt) ||
                other.dismissedAt == dismissedAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(
                    other.resultingRelationshipId, resultingRelationshipId) ||
                other.resultingRelationshipId == resultingRelationshipId) &&
            const DeepCollectionEquality()
                .equals(other.collisionKinds, collisionKinds) &&
            (identical(other.isConflictMarked, isConflictMarked) ||
                other.isConflictMarked == isConflictMarked) &&
            (identical(other.isCriticalConflict, isCriticalConflict) ||
                other.isCriticalConflict == isCriticalConflict));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sourceWorkspaceId,
      localKind,
      localId,
      platformActorId,
      matchedKeyType,
      matchedKeyValue,
      trustLevel,
      state,
      detectedAt,
      updatedAt,
      exposedAt,
      dismissedAt,
      confirmedAt,
      resultingRelationshipId,
      const DeepCollectionEquality().hash(collisionKinds),
      isConflictMarked,
      isCriticalConflict);

  @override
  String toString() {
    return 'MatchCandidateEntity(id: $id, sourceWorkspaceId: $sourceWorkspaceId, localKind: $localKind, localId: $localId, platformActorId: $platformActorId, matchedKeyType: $matchedKeyType, matchedKeyValue: $matchedKeyValue, trustLevel: $trustLevel, state: $state, detectedAt: $detectedAt, updatedAt: $updatedAt, exposedAt: $exposedAt, dismissedAt: $dismissedAt, confirmedAt: $confirmedAt, resultingRelationshipId: $resultingRelationshipId, collisionKinds: $collisionKinds, isConflictMarked: $isConflictMarked, isCriticalConflict: $isCriticalConflict)';
  }
}

/// @nodoc
abstract mixin class $MatchCandidateEntityCopyWith<$Res> {
  factory $MatchCandidateEntityCopyWith(MatchCandidateEntity value,
          $Res Function(MatchCandidateEntity) _then) =
      _$MatchCandidateEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String sourceWorkspaceId,
      TargetLocalKind localKind,
      String localId,
      String platformActorId,
      VerifiedKeyType matchedKeyType,
      String matchedKeyValue,
      MatchTrustLevel trustLevel,
      MatchCandidateState state,
      DateTime detectedAt,
      DateTime updatedAt,
      DateTime? exposedAt,
      DateTime? dismissedAt,
      DateTime? confirmedAt,
      String? resultingRelationshipId,
      List<CollisionKind> collisionKinds,
      bool isConflictMarked,
      bool isCriticalConflict});
}

/// @nodoc
class _$MatchCandidateEntityCopyWithImpl<$Res>
    implements $MatchCandidateEntityCopyWith<$Res> {
  _$MatchCandidateEntityCopyWithImpl(this._self, this._then);

  final MatchCandidateEntity _self;
  final $Res Function(MatchCandidateEntity) _then;

  /// Create a copy of MatchCandidateEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceWorkspaceId = null,
    Object? localKind = null,
    Object? localId = null,
    Object? platformActorId = null,
    Object? matchedKeyType = null,
    Object? matchedKeyValue = null,
    Object? trustLevel = null,
    Object? state = null,
    Object? detectedAt = null,
    Object? updatedAt = null,
    Object? exposedAt = freezed,
    Object? dismissedAt = freezed,
    Object? confirmedAt = freezed,
    Object? resultingRelationshipId = freezed,
    Object? collisionKinds = null,
    Object? isConflictMarked = null,
    Object? isCriticalConflict = null,
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
      localKind: null == localKind
          ? _self.localKind
          : localKind // ignore: cast_nullable_to_non_nullable
              as TargetLocalKind,
      localId: null == localId
          ? _self.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as String,
      platformActorId: null == platformActorId
          ? _self.platformActorId
          : platformActorId // ignore: cast_nullable_to_non_nullable
              as String,
      matchedKeyType: null == matchedKeyType
          ? _self.matchedKeyType
          : matchedKeyType // ignore: cast_nullable_to_non_nullable
              as VerifiedKeyType,
      matchedKeyValue: null == matchedKeyValue
          ? _self.matchedKeyValue
          : matchedKeyValue // ignore: cast_nullable_to_non_nullable
              as String,
      trustLevel: null == trustLevel
          ? _self.trustLevel
          : trustLevel // ignore: cast_nullable_to_non_nullable
              as MatchTrustLevel,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as MatchCandidateState,
      detectedAt: null == detectedAt
          ? _self.detectedAt
          : detectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      exposedAt: freezed == exposedAt
          ? _self.exposedAt
          : exposedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dismissedAt: freezed == dismissedAt
          ? _self.dismissedAt
          : dismissedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmedAt: freezed == confirmedAt
          ? _self.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resultingRelationshipId: freezed == resultingRelationshipId
          ? _self.resultingRelationshipId
          : resultingRelationshipId // ignore: cast_nullable_to_non_nullable
              as String?,
      collisionKinds: null == collisionKinds
          ? _self.collisionKinds
          : collisionKinds // ignore: cast_nullable_to_non_nullable
              as List<CollisionKind>,
      isConflictMarked: null == isConflictMarked
          ? _self.isConflictMarked
          : isConflictMarked // ignore: cast_nullable_to_non_nullable
              as bool,
      isCriticalConflict: null == isCriticalConflict
          ? _self.isCriticalConflict
          : isCriticalConflict // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MatchCandidateEntity].
extension MatchCandidateEntityPatterns on MatchCandidateEntity {
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
    TResult Function(_MatchCandidateEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MatchCandidateEntity() when $default != null:
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
    TResult Function(_MatchCandidateEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MatchCandidateEntity():
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
    TResult? Function(_MatchCandidateEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MatchCandidateEntity() when $default != null:
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
            TargetLocalKind localKind,
            String localId,
            String platformActorId,
            VerifiedKeyType matchedKeyType,
            String matchedKeyValue,
            MatchTrustLevel trustLevel,
            MatchCandidateState state,
            DateTime detectedAt,
            DateTime updatedAt,
            DateTime? exposedAt,
            DateTime? dismissedAt,
            DateTime? confirmedAt,
            String? resultingRelationshipId,
            List<CollisionKind> collisionKinds,
            bool isConflictMarked,
            bool isCriticalConflict)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MatchCandidateEntity() when $default != null:
        return $default(
            _that.id,
            _that.sourceWorkspaceId,
            _that.localKind,
            _that.localId,
            _that.platformActorId,
            _that.matchedKeyType,
            _that.matchedKeyValue,
            _that.trustLevel,
            _that.state,
            _that.detectedAt,
            _that.updatedAt,
            _that.exposedAt,
            _that.dismissedAt,
            _that.confirmedAt,
            _that.resultingRelationshipId,
            _that.collisionKinds,
            _that.isConflictMarked,
            _that.isCriticalConflict);
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
            TargetLocalKind localKind,
            String localId,
            String platformActorId,
            VerifiedKeyType matchedKeyType,
            String matchedKeyValue,
            MatchTrustLevel trustLevel,
            MatchCandidateState state,
            DateTime detectedAt,
            DateTime updatedAt,
            DateTime? exposedAt,
            DateTime? dismissedAt,
            DateTime? confirmedAt,
            String? resultingRelationshipId,
            List<CollisionKind> collisionKinds,
            bool isConflictMarked,
            bool isCriticalConflict)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MatchCandidateEntity():
        return $default(
            _that.id,
            _that.sourceWorkspaceId,
            _that.localKind,
            _that.localId,
            _that.platformActorId,
            _that.matchedKeyType,
            _that.matchedKeyValue,
            _that.trustLevel,
            _that.state,
            _that.detectedAt,
            _that.updatedAt,
            _that.exposedAt,
            _that.dismissedAt,
            _that.confirmedAt,
            _that.resultingRelationshipId,
            _that.collisionKinds,
            _that.isConflictMarked,
            _that.isCriticalConflict);
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
            TargetLocalKind localKind,
            String localId,
            String platformActorId,
            VerifiedKeyType matchedKeyType,
            String matchedKeyValue,
            MatchTrustLevel trustLevel,
            MatchCandidateState state,
            DateTime detectedAt,
            DateTime updatedAt,
            DateTime? exposedAt,
            DateTime? dismissedAt,
            DateTime? confirmedAt,
            String? resultingRelationshipId,
            List<CollisionKind> collisionKinds,
            bool isConflictMarked,
            bool isCriticalConflict)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MatchCandidateEntity() when $default != null:
        return $default(
            _that.id,
            _that.sourceWorkspaceId,
            _that.localKind,
            _that.localId,
            _that.platformActorId,
            _that.matchedKeyType,
            _that.matchedKeyValue,
            _that.trustLevel,
            _that.state,
            _that.detectedAt,
            _that.updatedAt,
            _that.exposedAt,
            _that.dismissedAt,
            _that.confirmedAt,
            _that.resultingRelationshipId,
            _that.collisionKinds,
            _that.isConflictMarked,
            _that.isCriticalConflict);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MatchCandidateEntity implements MatchCandidateEntity {
  const _MatchCandidateEntity(
      {required this.id,
      required this.sourceWorkspaceId,
      required this.localKind,
      required this.localId,
      required this.platformActorId,
      required this.matchedKeyType,
      required this.matchedKeyValue,
      required this.trustLevel,
      required this.state,
      required this.detectedAt,
      required this.updatedAt,
      this.exposedAt,
      this.dismissedAt,
      this.confirmedAt,
      this.resultingRelationshipId,
      final List<CollisionKind> collisionKinds = const <CollisionKind>[],
      this.isConflictMarked = false,
      this.isCriticalConflict = false})
      : _collisionKinds = collisionKinds;
  factory _MatchCandidateEntity.fromJson(Map<String, dynamic> json) =>
      _$MatchCandidateEntityFromJson(json);

  @override
  final String id;

  /// Workspace dueño del registro local involucrado.
  /// Derivable pero incluido para filtrado eficiente en cliente.
  @override
  final String sourceWorkspaceId;

  /// Tipo del registro local implicado.
  @override
  final TargetLocalKind localKind;

  /// FK polimórfica al registro local (LocalOrganization.id o LocalContact.id).
  @override
  final String localId;

  /// FK al PlatformActor candidato.
  @override
  final String platformActorId;

  /// Tipo de llave que generó el match.
  @override
  final VerifiedKeyType matchedKeyType;

  /// Valor de la llave que generó el match (normalizado).
  @override
  final String matchedKeyValue;

  /// Nivel de confianza asignado por el matcher.
  @override
  final MatchTrustLevel trustLevel;

  /// Estado del candidato (detección interna → exposición → resolución).
  @override
  final MatchCandidateState state;
  @override
  final DateTime detectedAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? exposedAt;
  @override
  final DateTime? dismissedAt;
  @override
  final DateTime? confirmedAt;

  /// Si el candidato se promovió a una Relación Operativa.
  @override
  final String? resultingRelationshipId;

  /// Hook D8: colisiones detectadas sobre este candidato. Vacío en el caso feliz.
  final List<CollisionKind> _collisionKinds;

  /// Hook D8: colisiones detectadas sobre este candidato. Vacío en el caso feliz.
  @override
  @JsonKey()
  List<CollisionKind> get collisionKinds {
    if (_collisionKinds is EqualUnmodifiableListView) return _collisionKinds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_collisionKinds);
  }

  /// Hook D8: true cuando existe alguna colisión marcada (aunque no sea crítica).
  /// Permite filtrar candidatos con conflicto sin recorrer la lista.
  @override
  @JsonKey()
  final bool isConflictMarked;

  /// Hook D8: true cuando la colisión afecta routing/identidad activa.
  /// Disparador de la suspensión automática (ver
  /// RelationshipSuspensionReason.platformKeyReassignedCritical).
  @override
  @JsonKey()
  final bool isCriticalConflict;

  /// Create a copy of MatchCandidateEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MatchCandidateEntityCopyWith<_MatchCandidateEntity> get copyWith =>
      __$MatchCandidateEntityCopyWithImpl<_MatchCandidateEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MatchCandidateEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MatchCandidateEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceWorkspaceId, sourceWorkspaceId) ||
                other.sourceWorkspaceId == sourceWorkspaceId) &&
            (identical(other.localKind, localKind) ||
                other.localKind == localKind) &&
            (identical(other.localId, localId) || other.localId == localId) &&
            (identical(other.platformActorId, platformActorId) ||
                other.platformActorId == platformActorId) &&
            (identical(other.matchedKeyType, matchedKeyType) ||
                other.matchedKeyType == matchedKeyType) &&
            (identical(other.matchedKeyValue, matchedKeyValue) ||
                other.matchedKeyValue == matchedKeyValue) &&
            (identical(other.trustLevel, trustLevel) ||
                other.trustLevel == trustLevel) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.detectedAt, detectedAt) ||
                other.detectedAt == detectedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.exposedAt, exposedAt) ||
                other.exposedAt == exposedAt) &&
            (identical(other.dismissedAt, dismissedAt) ||
                other.dismissedAt == dismissedAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(
                    other.resultingRelationshipId, resultingRelationshipId) ||
                other.resultingRelationshipId == resultingRelationshipId) &&
            const DeepCollectionEquality()
                .equals(other._collisionKinds, _collisionKinds) &&
            (identical(other.isConflictMarked, isConflictMarked) ||
                other.isConflictMarked == isConflictMarked) &&
            (identical(other.isCriticalConflict, isCriticalConflict) ||
                other.isCriticalConflict == isCriticalConflict));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sourceWorkspaceId,
      localKind,
      localId,
      platformActorId,
      matchedKeyType,
      matchedKeyValue,
      trustLevel,
      state,
      detectedAt,
      updatedAt,
      exposedAt,
      dismissedAt,
      confirmedAt,
      resultingRelationshipId,
      const DeepCollectionEquality().hash(_collisionKinds),
      isConflictMarked,
      isCriticalConflict);

  @override
  String toString() {
    return 'MatchCandidateEntity(id: $id, sourceWorkspaceId: $sourceWorkspaceId, localKind: $localKind, localId: $localId, platformActorId: $platformActorId, matchedKeyType: $matchedKeyType, matchedKeyValue: $matchedKeyValue, trustLevel: $trustLevel, state: $state, detectedAt: $detectedAt, updatedAt: $updatedAt, exposedAt: $exposedAt, dismissedAt: $dismissedAt, confirmedAt: $confirmedAt, resultingRelationshipId: $resultingRelationshipId, collisionKinds: $collisionKinds, isConflictMarked: $isConflictMarked, isCriticalConflict: $isCriticalConflict)';
  }
}

/// @nodoc
abstract mixin class _$MatchCandidateEntityCopyWith<$Res>
    implements $MatchCandidateEntityCopyWith<$Res> {
  factory _$MatchCandidateEntityCopyWith(_MatchCandidateEntity value,
          $Res Function(_MatchCandidateEntity) _then) =
      __$MatchCandidateEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String sourceWorkspaceId,
      TargetLocalKind localKind,
      String localId,
      String platformActorId,
      VerifiedKeyType matchedKeyType,
      String matchedKeyValue,
      MatchTrustLevel trustLevel,
      MatchCandidateState state,
      DateTime detectedAt,
      DateTime updatedAt,
      DateTime? exposedAt,
      DateTime? dismissedAt,
      DateTime? confirmedAt,
      String? resultingRelationshipId,
      List<CollisionKind> collisionKinds,
      bool isConflictMarked,
      bool isCriticalConflict});
}

/// @nodoc
class __$MatchCandidateEntityCopyWithImpl<$Res>
    implements _$MatchCandidateEntityCopyWith<$Res> {
  __$MatchCandidateEntityCopyWithImpl(this._self, this._then);

  final _MatchCandidateEntity _self;
  final $Res Function(_MatchCandidateEntity) _then;

  /// Create a copy of MatchCandidateEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sourceWorkspaceId = null,
    Object? localKind = null,
    Object? localId = null,
    Object? platformActorId = null,
    Object? matchedKeyType = null,
    Object? matchedKeyValue = null,
    Object? trustLevel = null,
    Object? state = null,
    Object? detectedAt = null,
    Object? updatedAt = null,
    Object? exposedAt = freezed,
    Object? dismissedAt = freezed,
    Object? confirmedAt = freezed,
    Object? resultingRelationshipId = freezed,
    Object? collisionKinds = null,
    Object? isConflictMarked = null,
    Object? isCriticalConflict = null,
  }) {
    return _then(_MatchCandidateEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWorkspaceId: null == sourceWorkspaceId
          ? _self.sourceWorkspaceId
          : sourceWorkspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      localKind: null == localKind
          ? _self.localKind
          : localKind // ignore: cast_nullable_to_non_nullable
              as TargetLocalKind,
      localId: null == localId
          ? _self.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as String,
      platformActorId: null == platformActorId
          ? _self.platformActorId
          : platformActorId // ignore: cast_nullable_to_non_nullable
              as String,
      matchedKeyType: null == matchedKeyType
          ? _self.matchedKeyType
          : matchedKeyType // ignore: cast_nullable_to_non_nullable
              as VerifiedKeyType,
      matchedKeyValue: null == matchedKeyValue
          ? _self.matchedKeyValue
          : matchedKeyValue // ignore: cast_nullable_to_non_nullable
              as String,
      trustLevel: null == trustLevel
          ? _self.trustLevel
          : trustLevel // ignore: cast_nullable_to_non_nullable
              as MatchTrustLevel,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as MatchCandidateState,
      detectedAt: null == detectedAt
          ? _self.detectedAt
          : detectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      exposedAt: freezed == exposedAt
          ? _self.exposedAt
          : exposedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dismissedAt: freezed == dismissedAt
          ? _self.dismissedAt
          : dismissedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmedAt: freezed == confirmedAt
          ? _self.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resultingRelationshipId: freezed == resultingRelationshipId
          ? _self.resultingRelationshipId
          : resultingRelationshipId // ignore: cast_nullable_to_non_nullable
              as String?,
      collisionKinds: null == collisionKinds
          ? _self._collisionKinds
          : collisionKinds // ignore: cast_nullable_to_non_nullable
              as List<CollisionKind>,
      isConflictMarked: null == isConflictMarked
          ? _self.isConflictMarked
          : isConflictMarked // ignore: cast_nullable_to_non_nullable
              as bool,
      isCriticalConflict: null == isCriticalConflict
          ? _self.isCriticalConflict
          : isCriticalConflict // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
