// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetDraft {
  /// ID único del draft (UUID v4)
  String get id;

  /// Tipo de activo que se está registrando
  AssetType get assetType;

  /// Estado actual del draft en el wizard
  DraftStatus get status;

  /// Identificador primario ingresado (placa, matrícula, serial)
  /// Normalizado: MAYÚSCULAS, trim
  String? get primaryIdentifier;

  /// Contenido del activo (null hasta capturar datos)
  AssetContent? get content;

  /// Snapshot capturado (datos RAW de fuente oficial)
  AssetSnapshot? get snapshot;

  /// Propietario legal extraído del snapshot
  LegalOwner? get legalOwner;

  /// Propietario beneficiario seleccionado por el usuario
  BeneficialOwner? get beneficialOwner;

  /// Portfolio destino (si se seleccionó)
  String? get targetPortfolioId;

  /// Metadatos del wizard (paso actual, errores, etc.)
  Map<String, dynamic> get metadata;

  /// Fecha de creación del draft
  @SafeDateTimeConverter()
  DateTime get createdAt;

  /// Fecha de última actualización
  @SafeDateTimeConverter()
  DateTime get updatedAt;

  /// Usuario que inició el registro
  String get createdBy;

  /// Create a copy of AssetDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetDraftCopyWith<AssetDraft> get copyWith =>
      _$AssetDraftCopyWithImpl<AssetDraft>(this as AssetDraft, _$identity);

  /// Serializes this AssetDraft to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetDraft &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetType, assetType) ||
                other.assetType == assetType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.primaryIdentifier, primaryIdentifier) ||
                other.primaryIdentifier == primaryIdentifier) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.snapshot, snapshot) ||
                other.snapshot == snapshot) &&
            (identical(other.legalOwner, legalOwner) ||
                other.legalOwner == legalOwner) &&
            (identical(other.beneficialOwner, beneficialOwner) ||
                other.beneficialOwner == beneficialOwner) &&
            (identical(other.targetPortfolioId, targetPortfolioId) ||
                other.targetPortfolioId == targetPortfolioId) &&
            const DeepCollectionEquality().equals(other.metadata, metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      assetType,
      status,
      primaryIdentifier,
      content,
      snapshot,
      legalOwner,
      beneficialOwner,
      targetPortfolioId,
      const DeepCollectionEquality().hash(metadata),
      createdAt,
      updatedAt,
      createdBy);

  @override
  String toString() {
    return 'AssetDraft(id: $id, assetType: $assetType, status: $status, primaryIdentifier: $primaryIdentifier, content: $content, snapshot: $snapshot, legalOwner: $legalOwner, beneficialOwner: $beneficialOwner, targetPortfolioId: $targetPortfolioId, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy)';
  }
}

/// @nodoc
abstract mixin class $AssetDraftCopyWith<$Res> {
  factory $AssetDraftCopyWith(
          AssetDraft value, $Res Function(AssetDraft) _then) =
      _$AssetDraftCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      AssetType assetType,
      DraftStatus status,
      String? primaryIdentifier,
      AssetContent? content,
      AssetSnapshot? snapshot,
      LegalOwner? legalOwner,
      BeneficialOwner? beneficialOwner,
      String? targetPortfolioId,
      Map<String, dynamic> metadata,
      @SafeDateTimeConverter() DateTime createdAt,
      @SafeDateTimeConverter() DateTime updatedAt,
      String createdBy});

  $AssetContentCopyWith<$Res>? get content;
  $AssetSnapshotCopyWith<$Res>? get snapshot;
  $LegalOwnerCopyWith<$Res>? get legalOwner;
  $BeneficialOwnerCopyWith<$Res>? get beneficialOwner;
}

/// @nodoc
class _$AssetDraftCopyWithImpl<$Res> implements $AssetDraftCopyWith<$Res> {
  _$AssetDraftCopyWithImpl(this._self, this._then);

  final AssetDraft _self;
  final $Res Function(AssetDraft) _then;

  /// Create a copy of AssetDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assetType = null,
    Object? status = null,
    Object? primaryIdentifier = freezed,
    Object? content = freezed,
    Object? snapshot = freezed,
    Object? legalOwner = freezed,
    Object? beneficialOwner = freezed,
    Object? targetPortfolioId = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assetType: null == assetType
          ? _self.assetType
          : assetType // ignore: cast_nullable_to_non_nullable
              as AssetType,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as DraftStatus,
      primaryIdentifier: freezed == primaryIdentifier
          ? _self.primaryIdentifier
          : primaryIdentifier // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as AssetContent?,
      snapshot: freezed == snapshot
          ? _self.snapshot
          : snapshot // ignore: cast_nullable_to_non_nullable
              as AssetSnapshot?,
      legalOwner: freezed == legalOwner
          ? _self.legalOwner
          : legalOwner // ignore: cast_nullable_to_non_nullable
              as LegalOwner?,
      beneficialOwner: freezed == beneficialOwner
          ? _self.beneficialOwner
          : beneficialOwner // ignore: cast_nullable_to_non_nullable
              as BeneficialOwner?,
      targetPortfolioId: freezed == targetPortfolioId
          ? _self.targetPortfolioId
          : targetPortfolioId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of AssetDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssetContentCopyWith<$Res>? get content {
    if (_self.content == null) {
      return null;
    }

    return $AssetContentCopyWith<$Res>(_self.content!, (value) {
      return _then(_self.copyWith(content: value));
    });
  }

  /// Create a copy of AssetDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssetSnapshotCopyWith<$Res>? get snapshot {
    if (_self.snapshot == null) {
      return null;
    }

    return $AssetSnapshotCopyWith<$Res>(_self.snapshot!, (value) {
      return _then(_self.copyWith(snapshot: value));
    });
  }

  /// Create a copy of AssetDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LegalOwnerCopyWith<$Res>? get legalOwner {
    if (_self.legalOwner == null) {
      return null;
    }

    return $LegalOwnerCopyWith<$Res>(_self.legalOwner!, (value) {
      return _then(_self.copyWith(legalOwner: value));
    });
  }

  /// Create a copy of AssetDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BeneficialOwnerCopyWith<$Res>? get beneficialOwner {
    if (_self.beneficialOwner == null) {
      return null;
    }

    return $BeneficialOwnerCopyWith<$Res>(_self.beneficialOwner!, (value) {
      return _then(_self.copyWith(beneficialOwner: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AssetDraft].
extension AssetDraftPatterns on AssetDraft {
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
    TResult Function(_AssetDraft value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetDraft() when $default != null:
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
    TResult Function(_AssetDraft value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetDraft():
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
    TResult? Function(_AssetDraft value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetDraft() when $default != null:
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
            AssetType assetType,
            DraftStatus status,
            String? primaryIdentifier,
            AssetContent? content,
            AssetSnapshot? snapshot,
            LegalOwner? legalOwner,
            BeneficialOwner? beneficialOwner,
            String? targetPortfolioId,
            Map<String, dynamic> metadata,
            @SafeDateTimeConverter() DateTime createdAt,
            @SafeDateTimeConverter() DateTime updatedAt,
            String createdBy)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetDraft() when $default != null:
        return $default(
            _that.id,
            _that.assetType,
            _that.status,
            _that.primaryIdentifier,
            _that.content,
            _that.snapshot,
            _that.legalOwner,
            _that.beneficialOwner,
            _that.targetPortfolioId,
            _that.metadata,
            _that.createdAt,
            _that.updatedAt,
            _that.createdBy);
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
            AssetType assetType,
            DraftStatus status,
            String? primaryIdentifier,
            AssetContent? content,
            AssetSnapshot? snapshot,
            LegalOwner? legalOwner,
            BeneficialOwner? beneficialOwner,
            String? targetPortfolioId,
            Map<String, dynamic> metadata,
            @SafeDateTimeConverter() DateTime createdAt,
            @SafeDateTimeConverter() DateTime updatedAt,
            String createdBy)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetDraft():
        return $default(
            _that.id,
            _that.assetType,
            _that.status,
            _that.primaryIdentifier,
            _that.content,
            _that.snapshot,
            _that.legalOwner,
            _that.beneficialOwner,
            _that.targetPortfolioId,
            _that.metadata,
            _that.createdAt,
            _that.updatedAt,
            _that.createdBy);
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
            AssetType assetType,
            DraftStatus status,
            String? primaryIdentifier,
            AssetContent? content,
            AssetSnapshot? snapshot,
            LegalOwner? legalOwner,
            BeneficialOwner? beneficialOwner,
            String? targetPortfolioId,
            Map<String, dynamic> metadata,
            @SafeDateTimeConverter() DateTime createdAt,
            @SafeDateTimeConverter() DateTime updatedAt,
            String createdBy)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetDraft() when $default != null:
        return $default(
            _that.id,
            _that.assetType,
            _that.status,
            _that.primaryIdentifier,
            _that.content,
            _that.snapshot,
            _that.legalOwner,
            _that.beneficialOwner,
            _that.targetPortfolioId,
            _that.metadata,
            _that.createdAt,
            _that.updatedAt,
            _that.createdBy);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssetDraft extends AssetDraft {
  const _AssetDraft(
      {required this.id,
      required this.assetType,
      this.status = DraftStatus.identification,
      this.primaryIdentifier,
      this.content,
      this.snapshot,
      this.legalOwner,
      this.beneficialOwner,
      this.targetPortfolioId,
      final Map<String, dynamic> metadata = const <String, dynamic>{},
      @SafeDateTimeConverter() required this.createdAt,
      @SafeDateTimeConverter() required this.updatedAt,
      required this.createdBy})
      : _metadata = metadata,
        super._();
  factory _AssetDraft.fromJson(Map<String, dynamic> json) =>
      _$AssetDraftFromJson(json);

  /// ID único del draft (UUID v4)
  @override
  final String id;

  /// Tipo de activo que se está registrando
  @override
  final AssetType assetType;

  /// Estado actual del draft en el wizard
  @override
  @JsonKey()
  final DraftStatus status;

  /// Identificador primario ingresado (placa, matrícula, serial)
  /// Normalizado: MAYÚSCULAS, trim
  @override
  final String? primaryIdentifier;

  /// Contenido del activo (null hasta capturar datos)
  @override
  final AssetContent? content;

  /// Snapshot capturado (datos RAW de fuente oficial)
  @override
  final AssetSnapshot? snapshot;

  /// Propietario legal extraído del snapshot
  @override
  final LegalOwner? legalOwner;

  /// Propietario beneficiario seleccionado por el usuario
  @override
  final BeneficialOwner? beneficialOwner;

  /// Portfolio destino (si se seleccionó)
  @override
  final String? targetPortfolioId;

  /// Metadatos del wizard (paso actual, errores, etc.)
  final Map<String, dynamic> _metadata;

  /// Metadatos del wizard (paso actual, errores, etc.)
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  /// Fecha de creación del draft
  @override
  @SafeDateTimeConverter()
  final DateTime createdAt;

  /// Fecha de última actualización
  @override
  @SafeDateTimeConverter()
  final DateTime updatedAt;

  /// Usuario que inició el registro
  @override
  final String createdBy;

  /// Create a copy of AssetDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetDraftCopyWith<_AssetDraft> get copyWith =>
      __$AssetDraftCopyWithImpl<_AssetDraft>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetDraftToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetDraft &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetType, assetType) ||
                other.assetType == assetType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.primaryIdentifier, primaryIdentifier) ||
                other.primaryIdentifier == primaryIdentifier) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.snapshot, snapshot) ||
                other.snapshot == snapshot) &&
            (identical(other.legalOwner, legalOwner) ||
                other.legalOwner == legalOwner) &&
            (identical(other.beneficialOwner, beneficialOwner) ||
                other.beneficialOwner == beneficialOwner) &&
            (identical(other.targetPortfolioId, targetPortfolioId) ||
                other.targetPortfolioId == targetPortfolioId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      assetType,
      status,
      primaryIdentifier,
      content,
      snapshot,
      legalOwner,
      beneficialOwner,
      targetPortfolioId,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      updatedAt,
      createdBy);

  @override
  String toString() {
    return 'AssetDraft(id: $id, assetType: $assetType, status: $status, primaryIdentifier: $primaryIdentifier, content: $content, snapshot: $snapshot, legalOwner: $legalOwner, beneficialOwner: $beneficialOwner, targetPortfolioId: $targetPortfolioId, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy)';
  }
}

/// @nodoc
abstract mixin class _$AssetDraftCopyWith<$Res>
    implements $AssetDraftCopyWith<$Res> {
  factory _$AssetDraftCopyWith(
          _AssetDraft value, $Res Function(_AssetDraft) _then) =
      __$AssetDraftCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      AssetType assetType,
      DraftStatus status,
      String? primaryIdentifier,
      AssetContent? content,
      AssetSnapshot? snapshot,
      LegalOwner? legalOwner,
      BeneficialOwner? beneficialOwner,
      String? targetPortfolioId,
      Map<String, dynamic> metadata,
      @SafeDateTimeConverter() DateTime createdAt,
      @SafeDateTimeConverter() DateTime updatedAt,
      String createdBy});

  @override
  $AssetContentCopyWith<$Res>? get content;
  @override
  $AssetSnapshotCopyWith<$Res>? get snapshot;
  @override
  $LegalOwnerCopyWith<$Res>? get legalOwner;
  @override
  $BeneficialOwnerCopyWith<$Res>? get beneficialOwner;
}

/// @nodoc
class __$AssetDraftCopyWithImpl<$Res> implements _$AssetDraftCopyWith<$Res> {
  __$AssetDraftCopyWithImpl(this._self, this._then);

  final _AssetDraft _self;
  final $Res Function(_AssetDraft) _then;

  /// Create a copy of AssetDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? assetType = null,
    Object? status = null,
    Object? primaryIdentifier = freezed,
    Object? content = freezed,
    Object? snapshot = freezed,
    Object? legalOwner = freezed,
    Object? beneficialOwner = freezed,
    Object? targetPortfolioId = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = null,
  }) {
    return _then(_AssetDraft(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assetType: null == assetType
          ? _self.assetType
          : assetType // ignore: cast_nullable_to_non_nullable
              as AssetType,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as DraftStatus,
      primaryIdentifier: freezed == primaryIdentifier
          ? _self.primaryIdentifier
          : primaryIdentifier // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as AssetContent?,
      snapshot: freezed == snapshot
          ? _self.snapshot
          : snapshot // ignore: cast_nullable_to_non_nullable
              as AssetSnapshot?,
      legalOwner: freezed == legalOwner
          ? _self.legalOwner
          : legalOwner // ignore: cast_nullable_to_non_nullable
              as LegalOwner?,
      beneficialOwner: freezed == beneficialOwner
          ? _self.beneficialOwner
          : beneficialOwner // ignore: cast_nullable_to_non_nullable
              as BeneficialOwner?,
      targetPortfolioId: freezed == targetPortfolioId
          ? _self.targetPortfolioId
          : targetPortfolioId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _self._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of AssetDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssetContentCopyWith<$Res>? get content {
    if (_self.content == null) {
      return null;
    }

    return $AssetContentCopyWith<$Res>(_self.content!, (value) {
      return _then(_self.copyWith(content: value));
    });
  }

  /// Create a copy of AssetDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssetSnapshotCopyWith<$Res>? get snapshot {
    if (_self.snapshot == null) {
      return null;
    }

    return $AssetSnapshotCopyWith<$Res>(_self.snapshot!, (value) {
      return _then(_self.copyWith(snapshot: value));
    });
  }

  /// Create a copy of AssetDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LegalOwnerCopyWith<$Res>? get legalOwner {
    if (_self.legalOwner == null) {
      return null;
    }

    return $LegalOwnerCopyWith<$Res>(_self.legalOwner!, (value) {
      return _then(_self.copyWith(legalOwner: value));
    });
  }

  /// Create a copy of AssetDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BeneficialOwnerCopyWith<$Res>? get beneficialOwner {
    if (_self.beneficialOwner == null) {
      return null;
    }

    return $BeneficialOwnerCopyWith<$Res>(_self.beneficialOwner!, (value) {
      return _then(_self.copyWith(beneficialOwner: value));
    });
  }
}

// dart format on
