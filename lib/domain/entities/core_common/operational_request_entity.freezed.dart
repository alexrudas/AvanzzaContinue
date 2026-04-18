// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operational_request_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OperationalRequestEntity {
  String get id;

  /// Workspace emisor. ≡ orgId del tenant.
  String get sourceWorkspaceId;

  /// FK obligatoria a la Relación a la que pertenece la Solicitud.
  /// Obligatorio incluso si la Relación está en 'referenciada'.
  String get relationshipId;

  /// Tipología semántica. En v1 siempre 'generic'.
  RequestKind get requestKind;

  /// Estado actual de la Solicitud. Gobierno por F2.b, ortogonal a la Relación.
  RequestState get state;

  /// Título de la solicitud. Campo mínimo obligatorio (ajuste del usuario).
  String get title;

  /// userId del miembro del workspace que creó la Solicitud.
  String get createdBy;

  /// Canal con el que se originó la Solicitud (no confundir con transporte).
  RequestOriginChannel get originChannel;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Timestamp de la última transición de estado.
  DateTime get stateUpdatedAt;

  /// Resumen breve adicional al título. Opcional.
  String? get summary;

  /// Payload JSON opaco. Extensible por requestKind en fases posteriores.
  /// Su contenido NO se interpreta en Core Common v1.
  String? get payloadJson;

  /// Nota libre del emisor incluida con la emisión. Opcional.
  String? get notesSource;

  /// Timestamps de transiciones clave para trazabilidad.
  DateTime? get sentAt;
  DateTime? get respondedAt;
  DateTime? get closedAt;

  /// Expiración configurada en el momento de envío (política futura).
  DateTime? get expiresAt;

  /// Create a copy of OperationalRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OperationalRequestEntityCopyWith<OperationalRequestEntity> get copyWith =>
      _$OperationalRequestEntityCopyWithImpl<OperationalRequestEntity>(
          this as OperationalRequestEntity, _$identity);

  /// Serializes this OperationalRequestEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OperationalRequestEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceWorkspaceId, sourceWorkspaceId) ||
                other.sourceWorkspaceId == sourceWorkspaceId) &&
            (identical(other.relationshipId, relationshipId) ||
                other.relationshipId == relationshipId) &&
            (identical(other.requestKind, requestKind) ||
                other.requestKind == requestKind) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.originChannel, originChannel) ||
                other.originChannel == originChannel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.stateUpdatedAt, stateUpdatedAt) ||
                other.stateUpdatedAt == stateUpdatedAt) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.payloadJson, payloadJson) ||
                other.payloadJson == payloadJson) &&
            (identical(other.notesSource, notesSource) ||
                other.notesSource == notesSource) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sourceWorkspaceId,
      relationshipId,
      requestKind,
      state,
      title,
      createdBy,
      originChannel,
      createdAt,
      updatedAt,
      stateUpdatedAt,
      summary,
      payloadJson,
      notesSource,
      sentAt,
      respondedAt,
      closedAt,
      expiresAt);

  @override
  String toString() {
    return 'OperationalRequestEntity(id: $id, sourceWorkspaceId: $sourceWorkspaceId, relationshipId: $relationshipId, requestKind: $requestKind, state: $state, title: $title, createdBy: $createdBy, originChannel: $originChannel, createdAt: $createdAt, updatedAt: $updatedAt, stateUpdatedAt: $stateUpdatedAt, summary: $summary, payloadJson: $payloadJson, notesSource: $notesSource, sentAt: $sentAt, respondedAt: $respondedAt, closedAt: $closedAt, expiresAt: $expiresAt)';
  }
}

/// @nodoc
abstract mixin class $OperationalRequestEntityCopyWith<$Res> {
  factory $OperationalRequestEntityCopyWith(OperationalRequestEntity value,
          $Res Function(OperationalRequestEntity) _then) =
      _$OperationalRequestEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String sourceWorkspaceId,
      String relationshipId,
      RequestKind requestKind,
      RequestState state,
      String title,
      String createdBy,
      RequestOriginChannel originChannel,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime stateUpdatedAt,
      String? summary,
      String? payloadJson,
      String? notesSource,
      DateTime? sentAt,
      DateTime? respondedAt,
      DateTime? closedAt,
      DateTime? expiresAt});
}

/// @nodoc
class _$OperationalRequestEntityCopyWithImpl<$Res>
    implements $OperationalRequestEntityCopyWith<$Res> {
  _$OperationalRequestEntityCopyWithImpl(this._self, this._then);

  final OperationalRequestEntity _self;
  final $Res Function(OperationalRequestEntity) _then;

  /// Create a copy of OperationalRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceWorkspaceId = null,
    Object? relationshipId = null,
    Object? requestKind = null,
    Object? state = null,
    Object? title = null,
    Object? createdBy = null,
    Object? originChannel = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? stateUpdatedAt = null,
    Object? summary = freezed,
    Object? payloadJson = freezed,
    Object? notesSource = freezed,
    Object? sentAt = freezed,
    Object? respondedAt = freezed,
    Object? closedAt = freezed,
    Object? expiresAt = freezed,
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
      relationshipId: null == relationshipId
          ? _self.relationshipId
          : relationshipId // ignore: cast_nullable_to_non_nullable
              as String,
      requestKind: null == requestKind
          ? _self.requestKind
          : requestKind // ignore: cast_nullable_to_non_nullable
              as RequestKind,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as RequestState,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      originChannel: null == originChannel
          ? _self.originChannel
          : originChannel // ignore: cast_nullable_to_non_nullable
              as RequestOriginChannel,
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
      summary: freezed == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      payloadJson: freezed == payloadJson
          ? _self.payloadJson
          : payloadJson // ignore: cast_nullable_to_non_nullable
              as String?,
      notesSource: freezed == notesSource
          ? _self.notesSource
          : notesSource // ignore: cast_nullable_to_non_nullable
              as String?,
      sentAt: freezed == sentAt
          ? _self.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      respondedAt: freezed == respondedAt
          ? _self.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [OperationalRequestEntity].
extension OperationalRequestEntityPatterns on OperationalRequestEntity {
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
    TResult Function(_OperationalRequestEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OperationalRequestEntity() when $default != null:
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
    TResult Function(_OperationalRequestEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OperationalRequestEntity():
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
    TResult? Function(_OperationalRequestEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OperationalRequestEntity() when $default != null:
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
            String relationshipId,
            RequestKind requestKind,
            RequestState state,
            String title,
            String createdBy,
            RequestOriginChannel originChannel,
            DateTime createdAt,
            DateTime updatedAt,
            DateTime stateUpdatedAt,
            String? summary,
            String? payloadJson,
            String? notesSource,
            DateTime? sentAt,
            DateTime? respondedAt,
            DateTime? closedAt,
            DateTime? expiresAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OperationalRequestEntity() when $default != null:
        return $default(
            _that.id,
            _that.sourceWorkspaceId,
            _that.relationshipId,
            _that.requestKind,
            _that.state,
            _that.title,
            _that.createdBy,
            _that.originChannel,
            _that.createdAt,
            _that.updatedAt,
            _that.stateUpdatedAt,
            _that.summary,
            _that.payloadJson,
            _that.notesSource,
            _that.sentAt,
            _that.respondedAt,
            _that.closedAt,
            _that.expiresAt);
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
            String relationshipId,
            RequestKind requestKind,
            RequestState state,
            String title,
            String createdBy,
            RequestOriginChannel originChannel,
            DateTime createdAt,
            DateTime updatedAt,
            DateTime stateUpdatedAt,
            String? summary,
            String? payloadJson,
            String? notesSource,
            DateTime? sentAt,
            DateTime? respondedAt,
            DateTime? closedAt,
            DateTime? expiresAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OperationalRequestEntity():
        return $default(
            _that.id,
            _that.sourceWorkspaceId,
            _that.relationshipId,
            _that.requestKind,
            _that.state,
            _that.title,
            _that.createdBy,
            _that.originChannel,
            _that.createdAt,
            _that.updatedAt,
            _that.stateUpdatedAt,
            _that.summary,
            _that.payloadJson,
            _that.notesSource,
            _that.sentAt,
            _that.respondedAt,
            _that.closedAt,
            _that.expiresAt);
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
            String relationshipId,
            RequestKind requestKind,
            RequestState state,
            String title,
            String createdBy,
            RequestOriginChannel originChannel,
            DateTime createdAt,
            DateTime updatedAt,
            DateTime stateUpdatedAt,
            String? summary,
            String? payloadJson,
            String? notesSource,
            DateTime? sentAt,
            DateTime? respondedAt,
            DateTime? closedAt,
            DateTime? expiresAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OperationalRequestEntity() when $default != null:
        return $default(
            _that.id,
            _that.sourceWorkspaceId,
            _that.relationshipId,
            _that.requestKind,
            _that.state,
            _that.title,
            _that.createdBy,
            _that.originChannel,
            _that.createdAt,
            _that.updatedAt,
            _that.stateUpdatedAt,
            _that.summary,
            _that.payloadJson,
            _that.notesSource,
            _that.sentAt,
            _that.respondedAt,
            _that.closedAt,
            _that.expiresAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OperationalRequestEntity implements OperationalRequestEntity {
  const _OperationalRequestEntity(
      {required this.id,
      required this.sourceWorkspaceId,
      required this.relationshipId,
      this.requestKind = RequestKind.generic,
      required this.state,
      required this.title,
      required this.createdBy,
      required this.originChannel,
      required this.createdAt,
      required this.updatedAt,
      required this.stateUpdatedAt,
      this.summary,
      this.payloadJson,
      this.notesSource,
      this.sentAt,
      this.respondedAt,
      this.closedAt,
      this.expiresAt});
  factory _OperationalRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$OperationalRequestEntityFromJson(json);

  @override
  final String id;

  /// Workspace emisor. ≡ orgId del tenant.
  @override
  final String sourceWorkspaceId;

  /// FK obligatoria a la Relación a la que pertenece la Solicitud.
  /// Obligatorio incluso si la Relación está en 'referenciada'.
  @override
  final String relationshipId;

  /// Tipología semántica. En v1 siempre 'generic'.
  @override
  @JsonKey()
  final RequestKind requestKind;

  /// Estado actual de la Solicitud. Gobierno por F2.b, ortogonal a la Relación.
  @override
  final RequestState state;

  /// Título de la solicitud. Campo mínimo obligatorio (ajuste del usuario).
  @override
  final String title;

  /// userId del miembro del workspace que creó la Solicitud.
  @override
  final String createdBy;

  /// Canal con el que se originó la Solicitud (no confundir con transporte).
  @override
  final RequestOriginChannel originChannel;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Timestamp de la última transición de estado.
  @override
  final DateTime stateUpdatedAt;

  /// Resumen breve adicional al título. Opcional.
  @override
  final String? summary;

  /// Payload JSON opaco. Extensible por requestKind en fases posteriores.
  /// Su contenido NO se interpreta en Core Common v1.
  @override
  final String? payloadJson;

  /// Nota libre del emisor incluida con la emisión. Opcional.
  @override
  final String? notesSource;

  /// Timestamps de transiciones clave para trazabilidad.
  @override
  final DateTime? sentAt;
  @override
  final DateTime? respondedAt;
  @override
  final DateTime? closedAt;

  /// Expiración configurada en el momento de envío (política futura).
  @override
  final DateTime? expiresAt;

  /// Create a copy of OperationalRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OperationalRequestEntityCopyWith<_OperationalRequestEntity> get copyWith =>
      __$OperationalRequestEntityCopyWithImpl<_OperationalRequestEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OperationalRequestEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OperationalRequestEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceWorkspaceId, sourceWorkspaceId) ||
                other.sourceWorkspaceId == sourceWorkspaceId) &&
            (identical(other.relationshipId, relationshipId) ||
                other.relationshipId == relationshipId) &&
            (identical(other.requestKind, requestKind) ||
                other.requestKind == requestKind) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.originChannel, originChannel) ||
                other.originChannel == originChannel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.stateUpdatedAt, stateUpdatedAt) ||
                other.stateUpdatedAt == stateUpdatedAt) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.payloadJson, payloadJson) ||
                other.payloadJson == payloadJson) &&
            (identical(other.notesSource, notesSource) ||
                other.notesSource == notesSource) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sourceWorkspaceId,
      relationshipId,
      requestKind,
      state,
      title,
      createdBy,
      originChannel,
      createdAt,
      updatedAt,
      stateUpdatedAt,
      summary,
      payloadJson,
      notesSource,
      sentAt,
      respondedAt,
      closedAt,
      expiresAt);

  @override
  String toString() {
    return 'OperationalRequestEntity(id: $id, sourceWorkspaceId: $sourceWorkspaceId, relationshipId: $relationshipId, requestKind: $requestKind, state: $state, title: $title, createdBy: $createdBy, originChannel: $originChannel, createdAt: $createdAt, updatedAt: $updatedAt, stateUpdatedAt: $stateUpdatedAt, summary: $summary, payloadJson: $payloadJson, notesSource: $notesSource, sentAt: $sentAt, respondedAt: $respondedAt, closedAt: $closedAt, expiresAt: $expiresAt)';
  }
}

/// @nodoc
abstract mixin class _$OperationalRequestEntityCopyWith<$Res>
    implements $OperationalRequestEntityCopyWith<$Res> {
  factory _$OperationalRequestEntityCopyWith(_OperationalRequestEntity value,
          $Res Function(_OperationalRequestEntity) _then) =
      __$OperationalRequestEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String sourceWorkspaceId,
      String relationshipId,
      RequestKind requestKind,
      RequestState state,
      String title,
      String createdBy,
      RequestOriginChannel originChannel,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime stateUpdatedAt,
      String? summary,
      String? payloadJson,
      String? notesSource,
      DateTime? sentAt,
      DateTime? respondedAt,
      DateTime? closedAt,
      DateTime? expiresAt});
}

/// @nodoc
class __$OperationalRequestEntityCopyWithImpl<$Res>
    implements _$OperationalRequestEntityCopyWith<$Res> {
  __$OperationalRequestEntityCopyWithImpl(this._self, this._then);

  final _OperationalRequestEntity _self;
  final $Res Function(_OperationalRequestEntity) _then;

  /// Create a copy of OperationalRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sourceWorkspaceId = null,
    Object? relationshipId = null,
    Object? requestKind = null,
    Object? state = null,
    Object? title = null,
    Object? createdBy = null,
    Object? originChannel = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? stateUpdatedAt = null,
    Object? summary = freezed,
    Object? payloadJson = freezed,
    Object? notesSource = freezed,
    Object? sentAt = freezed,
    Object? respondedAt = freezed,
    Object? closedAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_OperationalRequestEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWorkspaceId: null == sourceWorkspaceId
          ? _self.sourceWorkspaceId
          : sourceWorkspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      relationshipId: null == relationshipId
          ? _self.relationshipId
          : relationshipId // ignore: cast_nullable_to_non_nullable
              as String,
      requestKind: null == requestKind
          ? _self.requestKind
          : requestKind // ignore: cast_nullable_to_non_nullable
              as RequestKind,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as RequestState,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      originChannel: null == originChannel
          ? _self.originChannel
          : originChannel // ignore: cast_nullable_to_non_nullable
              as RequestOriginChannel,
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
      summary: freezed == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      payloadJson: freezed == payloadJson
          ? _self.payloadJson
          : payloadJson // ignore: cast_nullable_to_non_nullable
              as String?,
      notesSource: freezed == notesSource
          ? _self.notesSource
          : notesSource // ignore: cast_nullable_to_non_nullable
              as String?,
      sentAt: freezed == sentAt
          ? _self.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      respondedAt: freezed == respondedAt
          ? _self.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
