// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_organization_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocalOrganizationEntity {
  String get id;

  /// Partition key. Workspace dueño del registro local.
  String get workspaceId;

  /// Nombre usado en la UI del workspace. Puede diferir de legalName.
  String get displayName;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Razón social legal si se conoce.
  String? get legalName;

  /// NIT normalizado sin dígito de verificación ni puntuación. Sin verificación local.
  String? get taxId;

  /// Teléfono normalizado a E.164. Llave candidata principal para matching.
  String? get primaryPhoneE164;

  /// Email de contacto. Llave candidata secundaria.
  String? get primaryEmail;

  /// Sitio web corporativo si aplica.
  String? get website;

  /// Nota privada del workspace. NUNCA se sincroniza ni se expone.
  String? get notesPrivate;

  /// Tags privadas del workspace. NUNCA se sincronizan.
  List<String> get tagsPrivate;

  /// Si existe, indica que uno o más campos fueron adoptados desde un
  /// PlatformActor concreto (referencia trazable, no suscripción).
  String? get snapshotSourcePlatformActorId;

  /// Timestamp del último evento de adopción de campos desde plataforma.
  DateTime? get snapshotAdoptedAt;

  /// Soft delete flag. true = registro archivado.
  /// Las queries operativas del repositorio excluyen isDeleted=true por default.
  bool get isDeleted;

  /// Timestamp del soft-delete. Null mientras isDeleted=false.
  DateTime? get deletedAt;

  /// Create a copy of LocalOrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocalOrganizationEntityCopyWith<LocalOrganizationEntity> get copyWith =>
      _$LocalOrganizationEntityCopyWithImpl<LocalOrganizationEntity>(
          this as LocalOrganizationEntity, _$identity);

  /// Serializes this LocalOrganizationEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocalOrganizationEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.legalName, legalName) ||
                other.legalName == legalName) &&
            (identical(other.taxId, taxId) || other.taxId == taxId) &&
            (identical(other.primaryPhoneE164, primaryPhoneE164) ||
                other.primaryPhoneE164 == primaryPhoneE164) &&
            (identical(other.primaryEmail, primaryEmail) ||
                other.primaryEmail == primaryEmail) &&
            (identical(other.website, website) || other.website == website) &&
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
      legalName,
      taxId,
      primaryPhoneE164,
      primaryEmail,
      website,
      notesPrivate,
      const DeepCollectionEquality().hash(tagsPrivate),
      snapshotSourcePlatformActorId,
      snapshotAdoptedAt,
      isDeleted,
      deletedAt);

  @override
  String toString() {
    return 'LocalOrganizationEntity(id: $id, workspaceId: $workspaceId, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, legalName: $legalName, taxId: $taxId, primaryPhoneE164: $primaryPhoneE164, primaryEmail: $primaryEmail, website: $website, notesPrivate: $notesPrivate, tagsPrivate: $tagsPrivate, snapshotSourcePlatformActorId: $snapshotSourcePlatformActorId, snapshotAdoptedAt: $snapshotAdoptedAt, isDeleted: $isDeleted, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class $LocalOrganizationEntityCopyWith<$Res> {
  factory $LocalOrganizationEntityCopyWith(LocalOrganizationEntity value,
          $Res Function(LocalOrganizationEntity) _then) =
      _$LocalOrganizationEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String displayName,
      DateTime createdAt,
      DateTime updatedAt,
      String? legalName,
      String? taxId,
      String? primaryPhoneE164,
      String? primaryEmail,
      String? website,
      String? notesPrivate,
      List<String> tagsPrivate,
      String? snapshotSourcePlatformActorId,
      DateTime? snapshotAdoptedAt,
      bool isDeleted,
      DateTime? deletedAt});
}

/// @nodoc
class _$LocalOrganizationEntityCopyWithImpl<$Res>
    implements $LocalOrganizationEntityCopyWith<$Res> {
  _$LocalOrganizationEntityCopyWithImpl(this._self, this._then);

  final LocalOrganizationEntity _self;
  final $Res Function(LocalOrganizationEntity) _then;

  /// Create a copy of LocalOrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? displayName = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? legalName = freezed,
    Object? taxId = freezed,
    Object? primaryPhoneE164 = freezed,
    Object? primaryEmail = freezed,
    Object? website = freezed,
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
      legalName: freezed == legalName
          ? _self.legalName
          : legalName // ignore: cast_nullable_to_non_nullable
              as String?,
      taxId: freezed == taxId
          ? _self.taxId
          : taxId // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryPhoneE164: freezed == primaryPhoneE164
          ? _self.primaryPhoneE164
          : primaryPhoneE164 // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryEmail: freezed == primaryEmail
          ? _self.primaryEmail
          : primaryEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _self.website
          : website // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [LocalOrganizationEntity].
extension LocalOrganizationEntityPatterns on LocalOrganizationEntity {
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
    TResult Function(_LocalOrganizationEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocalOrganizationEntity() when $default != null:
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
    TResult Function(_LocalOrganizationEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalOrganizationEntity():
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
    TResult? Function(_LocalOrganizationEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalOrganizationEntity() when $default != null:
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
            String? legalName,
            String? taxId,
            String? primaryPhoneE164,
            String? primaryEmail,
            String? website,
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
      case _LocalOrganizationEntity() when $default != null:
        return $default(
            _that.id,
            _that.workspaceId,
            _that.displayName,
            _that.createdAt,
            _that.updatedAt,
            _that.legalName,
            _that.taxId,
            _that.primaryPhoneE164,
            _that.primaryEmail,
            _that.website,
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
            String? legalName,
            String? taxId,
            String? primaryPhoneE164,
            String? primaryEmail,
            String? website,
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
      case _LocalOrganizationEntity():
        return $default(
            _that.id,
            _that.workspaceId,
            _that.displayName,
            _that.createdAt,
            _that.updatedAt,
            _that.legalName,
            _that.taxId,
            _that.primaryPhoneE164,
            _that.primaryEmail,
            _that.website,
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
            String? legalName,
            String? taxId,
            String? primaryPhoneE164,
            String? primaryEmail,
            String? website,
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
      case _LocalOrganizationEntity() when $default != null:
        return $default(
            _that.id,
            _that.workspaceId,
            _that.displayName,
            _that.createdAt,
            _that.updatedAt,
            _that.legalName,
            _that.taxId,
            _that.primaryPhoneE164,
            _that.primaryEmail,
            _that.website,
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
class _LocalOrganizationEntity implements LocalOrganizationEntity {
  const _LocalOrganizationEntity(
      {required this.id,
      required this.workspaceId,
      required this.displayName,
      required this.createdAt,
      required this.updatedAt,
      this.legalName,
      this.taxId,
      this.primaryPhoneE164,
      this.primaryEmail,
      this.website,
      this.notesPrivate,
      final List<String> tagsPrivate = const <String>[],
      this.snapshotSourcePlatformActorId,
      this.snapshotAdoptedAt,
      this.isDeleted = false,
      this.deletedAt})
      : _tagsPrivate = tagsPrivate;
  factory _LocalOrganizationEntity.fromJson(Map<String, dynamic> json) =>
      _$LocalOrganizationEntityFromJson(json);

  @override
  final String id;

  /// Partition key. Workspace dueño del registro local.
  @override
  final String workspaceId;

  /// Nombre usado en la UI del workspace. Puede diferir de legalName.
  @override
  final String displayName;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Razón social legal si se conoce.
  @override
  final String? legalName;

  /// NIT normalizado sin dígito de verificación ni puntuación. Sin verificación local.
  @override
  final String? taxId;

  /// Teléfono normalizado a E.164. Llave candidata principal para matching.
  @override
  final String? primaryPhoneE164;

  /// Email de contacto. Llave candidata secundaria.
  @override
  final String? primaryEmail;

  /// Sitio web corporativo si aplica.
  @override
  final String? website;

  /// Nota privada del workspace. NUNCA se sincroniza ni se expone.
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

  /// Si existe, indica que uno o más campos fueron adoptados desde un
  /// PlatformActor concreto (referencia trazable, no suscripción).
  @override
  final String? snapshotSourcePlatformActorId;

  /// Timestamp del último evento de adopción de campos desde plataforma.
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

  /// Create a copy of LocalOrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LocalOrganizationEntityCopyWith<_LocalOrganizationEntity> get copyWith =>
      __$LocalOrganizationEntityCopyWithImpl<_LocalOrganizationEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LocalOrganizationEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalOrganizationEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.legalName, legalName) ||
                other.legalName == legalName) &&
            (identical(other.taxId, taxId) || other.taxId == taxId) &&
            (identical(other.primaryPhoneE164, primaryPhoneE164) ||
                other.primaryPhoneE164 == primaryPhoneE164) &&
            (identical(other.primaryEmail, primaryEmail) ||
                other.primaryEmail == primaryEmail) &&
            (identical(other.website, website) || other.website == website) &&
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
      legalName,
      taxId,
      primaryPhoneE164,
      primaryEmail,
      website,
      notesPrivate,
      const DeepCollectionEquality().hash(_tagsPrivate),
      snapshotSourcePlatformActorId,
      snapshotAdoptedAt,
      isDeleted,
      deletedAt);

  @override
  String toString() {
    return 'LocalOrganizationEntity(id: $id, workspaceId: $workspaceId, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, legalName: $legalName, taxId: $taxId, primaryPhoneE164: $primaryPhoneE164, primaryEmail: $primaryEmail, website: $website, notesPrivate: $notesPrivate, tagsPrivate: $tagsPrivate, snapshotSourcePlatformActorId: $snapshotSourcePlatformActorId, snapshotAdoptedAt: $snapshotAdoptedAt, isDeleted: $isDeleted, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class _$LocalOrganizationEntityCopyWith<$Res>
    implements $LocalOrganizationEntityCopyWith<$Res> {
  factory _$LocalOrganizationEntityCopyWith(_LocalOrganizationEntity value,
          $Res Function(_LocalOrganizationEntity) _then) =
      __$LocalOrganizationEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String displayName,
      DateTime createdAt,
      DateTime updatedAt,
      String? legalName,
      String? taxId,
      String? primaryPhoneE164,
      String? primaryEmail,
      String? website,
      String? notesPrivate,
      List<String> tagsPrivate,
      String? snapshotSourcePlatformActorId,
      DateTime? snapshotAdoptedAt,
      bool isDeleted,
      DateTime? deletedAt});
}

/// @nodoc
class __$LocalOrganizationEntityCopyWithImpl<$Res>
    implements _$LocalOrganizationEntityCopyWith<$Res> {
  __$LocalOrganizationEntityCopyWithImpl(this._self, this._then);

  final _LocalOrganizationEntity _self;
  final $Res Function(_LocalOrganizationEntity) _then;

  /// Create a copy of LocalOrganizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? displayName = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? legalName = freezed,
    Object? taxId = freezed,
    Object? primaryPhoneE164 = freezed,
    Object? primaryEmail = freezed,
    Object? website = freezed,
    Object? notesPrivate = freezed,
    Object? tagsPrivate = null,
    Object? snapshotSourcePlatformActorId = freezed,
    Object? snapshotAdoptedAt = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_LocalOrganizationEntity(
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
      legalName: freezed == legalName
          ? _self.legalName
          : legalName // ignore: cast_nullable_to_non_nullable
              as String?,
      taxId: freezed == taxId
          ? _self.taxId
          : taxId // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryPhoneE164: freezed == primaryPhoneE164
          ? _self.primaryPhoneE164
          : primaryPhoneE164 // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryEmail: freezed == primaryEmail
          ? _self.primaryEmail
          : primaryEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _self.website
          : website // ignore: cast_nullable_to_non_nullable
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
