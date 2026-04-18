// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_contact_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocalContactEntity {
  String get id;

  /// Partition key. Workspace dueño del registro local.
  String get workspaceId;

  /// Nombre mostrado en la UI del workspace.
  String get displayName;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// FK opcional a LocalOrganization del mismo workspace.
  /// Null = contacto suelto (ej. conductor persona, técnico freelance).
  String? get organizationId;

  /// Etiqueta libre del rol en el workspace ("vendedor", "conductor",
  /// "técnico"). Sin semántica vertical: solo anotación local.
  String? get roleLabel;

  /// Teléfono normalizado a E.164. Llave candidata principal.
  String? get primaryPhoneE164;

  /// Email de contacto. Llave candidata secundaria.
  String? get primaryEmail;

  /// Documento de identidad normalizado. Llave candidata secundaria.
  String? get docId;

  /// Nota privada del workspace. NUNCA se sincroniza.
  String? get notesPrivate;

  /// Tags privadas del workspace. NUNCA se sincronizan.
  List<String> get tagsPrivate;

  /// PlatformActor origen de adopciones manuales de campo (si aplica).
  String? get snapshotSourcePlatformActorId;

  /// Timestamp de la última adopción.
  DateTime? get snapshotAdoptedAt;

  /// Soft delete flag. true = registro archivado.
  /// Las queries operativas del repositorio excluyen isDeleted=true por default.
  bool get isDeleted;

  /// Timestamp del soft-delete. Null mientras isDeleted=false.
  DateTime? get deletedAt;

  /// Create a copy of LocalContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocalContactEntityCopyWith<LocalContactEntity> get copyWith =>
      _$LocalContactEntityCopyWithImpl<LocalContactEntity>(
          this as LocalContactEntity, _$identity);

  /// Serializes this LocalContactEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocalContactEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.roleLabel, roleLabel) ||
                other.roleLabel == roleLabel) &&
            (identical(other.primaryPhoneE164, primaryPhoneE164) ||
                other.primaryPhoneE164 == primaryPhoneE164) &&
            (identical(other.primaryEmail, primaryEmail) ||
                other.primaryEmail == primaryEmail) &&
            (identical(other.docId, docId) || other.docId == docId) &&
            (identical(other.notesPrivate, notesPrivate) ||
                other.notesPrivate == notesPrivate) &&
            const DeepCollectionEquality()
                .equals(other.tagsPrivate, tagsPrivate) &&
            (identical(other.snapshotSourcePlatformActorId,
                    snapshotSourcePlatformActorId) ||
                other.snapshotSourcePlatformActorId ==
                    snapshotSourcePlatformActorId) &&
            (identical(other.snapshotAdoptedAt, snapshotAdoptedAt) ||
                other.snapshotAdoptedAt == snapshotAdoptedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      workspaceId,
      displayName,
      createdAt,
      updatedAt,
      organizationId,
      roleLabel,
      primaryPhoneE164,
      primaryEmail,
      docId,
      notesPrivate,
      const DeepCollectionEquality().hash(tagsPrivate),
      snapshotSourcePlatformActorId,
      snapshotAdoptedAt,
      isDeleted,
      deletedAt);

  @override
  String toString() {
    return 'LocalContactEntity(id: $id, workspaceId: $workspaceId, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, organizationId: $organizationId, roleLabel: $roleLabel, primaryPhoneE164: $primaryPhoneE164, primaryEmail: $primaryEmail, docId: $docId, notesPrivate: $notesPrivate, tagsPrivate: $tagsPrivate, snapshotSourcePlatformActorId: $snapshotSourcePlatformActorId, snapshotAdoptedAt: $snapshotAdoptedAt, isDeleted: $isDeleted, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class $LocalContactEntityCopyWith<$Res> {
  factory $LocalContactEntityCopyWith(
          LocalContactEntity value, $Res Function(LocalContactEntity) _then) =
      _$LocalContactEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String displayName,
      DateTime createdAt,
      DateTime updatedAt,
      String? organizationId,
      String? roleLabel,
      String? primaryPhoneE164,
      String? primaryEmail,
      String? docId,
      String? notesPrivate,
      List<String> tagsPrivate,
      String? snapshotSourcePlatformActorId,
      DateTime? snapshotAdoptedAt,
      bool isDeleted,
      DateTime? deletedAt});
}

/// @nodoc
class _$LocalContactEntityCopyWithImpl<$Res>
    implements $LocalContactEntityCopyWith<$Res> {
  _$LocalContactEntityCopyWithImpl(this._self, this._then);

  final LocalContactEntity _self;
  final $Res Function(LocalContactEntity) _then;

  /// Create a copy of LocalContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? displayName = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? organizationId = freezed,
    Object? roleLabel = freezed,
    Object? primaryPhoneE164 = freezed,
    Object? primaryEmail = freezed,
    Object? docId = freezed,
    Object? notesPrivate = freezed,
    Object? tagsPrivate = null,
    Object? snapshotSourcePlatformActorId = freezed,
    Object? snapshotAdoptedAt = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _self.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
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
      organizationId: freezed == organizationId
          ? _self.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
      roleLabel: freezed == roleLabel
          ? _self.roleLabel
          : roleLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryPhoneE164: freezed == primaryPhoneE164
          ? _self.primaryPhoneE164
          : primaryPhoneE164 // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryEmail: freezed == primaryEmail
          ? _self.primaryEmail
          : primaryEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      docId: freezed == docId
          ? _self.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String?,
      notesPrivate: freezed == notesPrivate
          ? _self.notesPrivate
          : notesPrivate // ignore: cast_nullable_to_non_nullable
              as String?,
      tagsPrivate: null == tagsPrivate
          ? _self.tagsPrivate
          : tagsPrivate // ignore: cast_nullable_to_non_nullable
              as List<String>,
      snapshotSourcePlatformActorId: freezed == snapshotSourcePlatformActorId
          ? _self.snapshotSourcePlatformActorId
          : snapshotSourcePlatformActorId // ignore: cast_nullable_to_non_nullable
              as String?,
      snapshotAdoptedAt: freezed == snapshotAdoptedAt
          ? _self.snapshotAdoptedAt
          : snapshotAdoptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [LocalContactEntity].
extension LocalContactEntityPatterns on LocalContactEntity {
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
    TResult Function(_LocalContactEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocalContactEntity() when $default != null:
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
    TResult Function(_LocalContactEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalContactEntity():
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
    TResult? Function(_LocalContactEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalContactEntity() when $default != null:
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
            String workspaceId,
            String displayName,
            DateTime createdAt,
            DateTime updatedAt,
            String? organizationId,
            String? roleLabel,
            String? primaryPhoneE164,
            String? primaryEmail,
            String? docId,
            String? notesPrivate,
            List<String> tagsPrivate,
            String? snapshotSourcePlatformActorId,
            DateTime? snapshotAdoptedAt,
            bool isDeleted,
            DateTime? deletedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocalContactEntity() when $default != null:
        return $default(
            _that.id,
            _that.workspaceId,
            _that.displayName,
            _that.createdAt,
            _that.updatedAt,
            _that.organizationId,
            _that.roleLabel,
            _that.primaryPhoneE164,
            _that.primaryEmail,
            _that.docId,
            _that.notesPrivate,
            _that.tagsPrivate,
            _that.snapshotSourcePlatformActorId,
            _that.snapshotAdoptedAt,
            _that.isDeleted,
            _that.deletedAt);
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
            String workspaceId,
            String displayName,
            DateTime createdAt,
            DateTime updatedAt,
            String? organizationId,
            String? roleLabel,
            String? primaryPhoneE164,
            String? primaryEmail,
            String? docId,
            String? notesPrivate,
            List<String> tagsPrivate,
            String? snapshotSourcePlatformActorId,
            DateTime? snapshotAdoptedAt,
            bool isDeleted,
            DateTime? deletedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalContactEntity():
        return $default(
            _that.id,
            _that.workspaceId,
            _that.displayName,
            _that.createdAt,
            _that.updatedAt,
            _that.organizationId,
            _that.roleLabel,
            _that.primaryPhoneE164,
            _that.primaryEmail,
            _that.docId,
            _that.notesPrivate,
            _that.tagsPrivate,
            _that.snapshotSourcePlatformActorId,
            _that.snapshotAdoptedAt,
            _that.isDeleted,
            _that.deletedAt);
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
            String workspaceId,
            String displayName,
            DateTime createdAt,
            DateTime updatedAt,
            String? organizationId,
            String? roleLabel,
            String? primaryPhoneE164,
            String? primaryEmail,
            String? docId,
            String? notesPrivate,
            List<String> tagsPrivate,
            String? snapshotSourcePlatformActorId,
            DateTime? snapshotAdoptedAt,
            bool isDeleted,
            DateTime? deletedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalContactEntity() when $default != null:
        return $default(
            _that.id,
            _that.workspaceId,
            _that.displayName,
            _that.createdAt,
            _that.updatedAt,
            _that.organizationId,
            _that.roleLabel,
            _that.primaryPhoneE164,
            _that.primaryEmail,
            _that.docId,
            _that.notesPrivate,
            _that.tagsPrivate,
            _that.snapshotSourcePlatformActorId,
            _that.snapshotAdoptedAt,
            _that.isDeleted,
            _that.deletedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LocalContactEntity implements LocalContactEntity {
  const _LocalContactEntity(
      {required this.id,
      required this.workspaceId,
      required this.displayName,
      required this.createdAt,
      required this.updatedAt,
      this.organizationId,
      this.roleLabel,
      this.primaryPhoneE164,
      this.primaryEmail,
      this.docId,
      this.notesPrivate,
      final List<String> tagsPrivate = const <String>[],
      this.snapshotSourcePlatformActorId,
      this.snapshotAdoptedAt,
      this.isDeleted = false,
      this.deletedAt})
      : _tagsPrivate = tagsPrivate;
  factory _LocalContactEntity.fromJson(Map<String, dynamic> json) =>
      _$LocalContactEntityFromJson(json);

  @override
  final String id;

  /// Partition key. Workspace dueño del registro local.
  @override
  final String workspaceId;

  /// Nombre mostrado en la UI del workspace.
  @override
  final String displayName;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// FK opcional a LocalOrganization del mismo workspace.
  /// Null = contacto suelto (ej. conductor persona, técnico freelance).
  @override
  final String? organizationId;

  /// Etiqueta libre del rol en el workspace ("vendedor", "conductor",
  /// "técnico"). Sin semántica vertical: solo anotación local.
  @override
  final String? roleLabel;

  /// Teléfono normalizado a E.164. Llave candidata principal.
  @override
  final String? primaryPhoneE164;

  /// Email de contacto. Llave candidata secundaria.
  @override
  final String? primaryEmail;

  /// Documento de identidad normalizado. Llave candidata secundaria.
  @override
  final String? docId;

  /// Nota privada del workspace. NUNCA se sincroniza.
  @override
  final String? notesPrivate;

  /// Tags privadas del workspace. NUNCA se sincronizan.
  final List<String> _tagsPrivate;

  /// Tags privadas del workspace. NUNCA se sincronizan.
  @override
  @JsonKey()
  List<String> get tagsPrivate {
    if (_tagsPrivate is EqualUnmodifiableListView) return _tagsPrivate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagsPrivate);
  }

  /// PlatformActor origen de adopciones manuales de campo (si aplica).
  @override
  final String? snapshotSourcePlatformActorId;

  /// Timestamp de la última adopción.
  @override
  final DateTime? snapshotAdoptedAt;

  /// Soft delete flag. true = registro archivado.
  /// Las queries operativas del repositorio excluyen isDeleted=true por default.
  @override
  @JsonKey()
  final bool isDeleted;

  /// Timestamp del soft-delete. Null mientras isDeleted=false.
  @override
  final DateTime? deletedAt;

  /// Create a copy of LocalContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LocalContactEntityCopyWith<_LocalContactEntity> get copyWith =>
      __$LocalContactEntityCopyWithImpl<_LocalContactEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LocalContactEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalContactEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.roleLabel, roleLabel) ||
                other.roleLabel == roleLabel) &&
            (identical(other.primaryPhoneE164, primaryPhoneE164) ||
                other.primaryPhoneE164 == primaryPhoneE164) &&
            (identical(other.primaryEmail, primaryEmail) ||
                other.primaryEmail == primaryEmail) &&
            (identical(other.docId, docId) || other.docId == docId) &&
            (identical(other.notesPrivate, notesPrivate) ||
                other.notesPrivate == notesPrivate) &&
            const DeepCollectionEquality()
                .equals(other._tagsPrivate, _tagsPrivate) &&
            (identical(other.snapshotSourcePlatformActorId,
                    snapshotSourcePlatformActorId) ||
                other.snapshotSourcePlatformActorId ==
                    snapshotSourcePlatformActorId) &&
            (identical(other.snapshotAdoptedAt, snapshotAdoptedAt) ||
                other.snapshotAdoptedAt == snapshotAdoptedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      workspaceId,
      displayName,
      createdAt,
      updatedAt,
      organizationId,
      roleLabel,
      primaryPhoneE164,
      primaryEmail,
      docId,
      notesPrivate,
      const DeepCollectionEquality().hash(_tagsPrivate),
      snapshotSourcePlatformActorId,
      snapshotAdoptedAt,
      isDeleted,
      deletedAt);

  @override
  String toString() {
    return 'LocalContactEntity(id: $id, workspaceId: $workspaceId, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, organizationId: $organizationId, roleLabel: $roleLabel, primaryPhoneE164: $primaryPhoneE164, primaryEmail: $primaryEmail, docId: $docId, notesPrivate: $notesPrivate, tagsPrivate: $tagsPrivate, snapshotSourcePlatformActorId: $snapshotSourcePlatformActorId, snapshotAdoptedAt: $snapshotAdoptedAt, isDeleted: $isDeleted, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class _$LocalContactEntityCopyWith<$Res>
    implements $LocalContactEntityCopyWith<$Res> {
  factory _$LocalContactEntityCopyWith(
          _LocalContactEntity value, $Res Function(_LocalContactEntity) _then) =
      __$LocalContactEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String displayName,
      DateTime createdAt,
      DateTime updatedAt,
      String? organizationId,
      String? roleLabel,
      String? primaryPhoneE164,
      String? primaryEmail,
      String? docId,
      String? notesPrivate,
      List<String> tagsPrivate,
      String? snapshotSourcePlatformActorId,
      DateTime? snapshotAdoptedAt,
      bool isDeleted,
      DateTime? deletedAt});
}

/// @nodoc
class __$LocalContactEntityCopyWithImpl<$Res>
    implements _$LocalContactEntityCopyWith<$Res> {
  __$LocalContactEntityCopyWithImpl(this._self, this._then);

  final _LocalContactEntity _self;
  final $Res Function(_LocalContactEntity) _then;

  /// Create a copy of LocalContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? displayName = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? organizationId = freezed,
    Object? roleLabel = freezed,
    Object? primaryPhoneE164 = freezed,
    Object? primaryEmail = freezed,
    Object? docId = freezed,
    Object? notesPrivate = freezed,
    Object? tagsPrivate = null,
    Object? snapshotSourcePlatformActorId = freezed,
    Object? snapshotAdoptedAt = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_LocalContactEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _self.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
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
      organizationId: freezed == organizationId
          ? _self.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
      roleLabel: freezed == roleLabel
          ? _self.roleLabel
          : roleLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryPhoneE164: freezed == primaryPhoneE164
          ? _self.primaryPhoneE164
          : primaryPhoneE164 // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryEmail: freezed == primaryEmail
          ? _self.primaryEmail
          : primaryEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      docId: freezed == docId
          ? _self.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String?,
      notesPrivate: freezed == notesPrivate
          ? _self.notesPrivate
          : notesPrivate // ignore: cast_nullable_to_non_nullable
              as String?,
      tagsPrivate: null == tagsPrivate
          ? _self._tagsPrivate
          : tagsPrivate // ignore: cast_nullable_to_non_nullable
              as List<String>,
      snapshotSourcePlatformActorId: freezed == snapshotSourcePlatformActorId
          ? _self.snapshotSourcePlatformActorId
          : snapshotSourcePlatformActorId // ignore: cast_nullable_to_non_nullable
              as String?,
      snapshotAdoptedAt: freezed == snapshotAdoptedAt
          ? _self.snapshotAdoptedAt
          : snapshotAdoptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
