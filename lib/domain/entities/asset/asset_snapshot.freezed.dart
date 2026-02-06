// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetSnapshot {
  /// ID unico del snapshot (UUID v4)
  String get id;

  /// ID del asset asociado (null si es pre-registro)
  String? get assetId;

  /// Fuente de los datos
  SnapshotSource get source;

  /// Payload RAW de la fuente (JSON crudo sin transformar).
  /// JSON-SAFE: solo null, bool, num, String, List, Map.
  Map<String, dynamic> get payloadRaw;

  /// Payload normalizado (listo para crear AssetContent).
  /// JSON-SAFE: solo null, bool, num, String, List, Map.
  Map<String, dynamic> get payloadNormalized;

  /// Version del schema de normalizacion
  String get schemaVersion;

  /// Fecha de obtencion (UTC)
  @SafeDateTimeConverter()
  DateTime get fetchedAt;

  /// Hash SHA-256 del payloadRaw canonicalizado (para deteccion de cambios)
  String get hash;

  /// Metadatos adicionales (requestId, durationMs, etc.)
  Map<String, dynamic> get metadata;

  /// Create a copy of AssetSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetSnapshotCopyWith<AssetSnapshot> get copyWith =>
      _$AssetSnapshotCopyWithImpl<AssetSnapshot>(
          this as AssetSnapshot, _$identity);

  /// Serializes this AssetSnapshot to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetSnapshot &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality()
                .equals(other.payloadRaw, payloadRaw) &&
            const DeepCollectionEquality()
                .equals(other.payloadNormalized, payloadNormalized) &&
            (identical(other.schemaVersion, schemaVersion) ||
                other.schemaVersion == schemaVersion) &&
            (identical(other.fetchedAt, fetchedAt) ||
                other.fetchedAt == fetchedAt) &&
            (identical(other.hash, hash) || other.hash == hash) &&
            const DeepCollectionEquality().equals(other.metadata, metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      assetId,
      source,
      const DeepCollectionEquality().hash(payloadRaw),
      const DeepCollectionEquality().hash(payloadNormalized),
      schemaVersion,
      fetchedAt,
      hash,
      const DeepCollectionEquality().hash(metadata));

  @override
  String toString() {
    return 'AssetSnapshot(id: $id, assetId: $assetId, source: $source, payloadRaw: $payloadRaw, payloadNormalized: $payloadNormalized, schemaVersion: $schemaVersion, fetchedAt: $fetchedAt, hash: $hash, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class $AssetSnapshotCopyWith<$Res> {
  factory $AssetSnapshotCopyWith(
          AssetSnapshot value, $Res Function(AssetSnapshot) _then) =
      _$AssetSnapshotCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? assetId,
      SnapshotSource source,
      Map<String, dynamic> payloadRaw,
      Map<String, dynamic> payloadNormalized,
      String schemaVersion,
      @SafeDateTimeConverter() DateTime fetchedAt,
      String hash,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$AssetSnapshotCopyWithImpl<$Res>
    implements $AssetSnapshotCopyWith<$Res> {
  _$AssetSnapshotCopyWithImpl(this._self, this._then);

  final AssetSnapshot _self;
  final $Res Function(AssetSnapshot) _then;

  /// Create a copy of AssetSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assetId = freezed,
    Object? source = null,
    Object? payloadRaw = null,
    Object? payloadNormalized = null,
    Object? schemaVersion = null,
    Object? fetchedAt = null,
    Object? hash = null,
    Object? metadata = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: freezed == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as SnapshotSource,
      payloadRaw: null == payloadRaw
          ? _self.payloadRaw
          : payloadRaw // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      payloadNormalized: null == payloadNormalized
          ? _self.payloadNormalized
          : payloadNormalized // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      schemaVersion: null == schemaVersion
          ? _self.schemaVersion
          : schemaVersion // ignore: cast_nullable_to_non_nullable
              as String,
      fetchedAt: null == fetchedAt
          ? _self.fetchedAt
          : fetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hash: null == hash
          ? _self.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AssetSnapshot].
extension AssetSnapshotPatterns on AssetSnapshot {
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
    TResult Function(_AssetSnapshot value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetSnapshot() when $default != null:
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
    TResult Function(_AssetSnapshot value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetSnapshot():
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
    TResult? Function(_AssetSnapshot value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetSnapshot() when $default != null:
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
            String? assetId,
            SnapshotSource source,
            Map<String, dynamic> payloadRaw,
            Map<String, dynamic> payloadNormalized,
            String schemaVersion,
            @SafeDateTimeConverter() DateTime fetchedAt,
            String hash,
            Map<String, dynamic> metadata)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetSnapshot() when $default != null:
        return $default(
            _that.id,
            _that.assetId,
            _that.source,
            _that.payloadRaw,
            _that.payloadNormalized,
            _that.schemaVersion,
            _that.fetchedAt,
            _that.hash,
            _that.metadata);
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
            String? assetId,
            SnapshotSource source,
            Map<String, dynamic> payloadRaw,
            Map<String, dynamic> payloadNormalized,
            String schemaVersion,
            @SafeDateTimeConverter() DateTime fetchedAt,
            String hash,
            Map<String, dynamic> metadata)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetSnapshot():
        return $default(
            _that.id,
            _that.assetId,
            _that.source,
            _that.payloadRaw,
            _that.payloadNormalized,
            _that.schemaVersion,
            _that.fetchedAt,
            _that.hash,
            _that.metadata);
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
            String? assetId,
            SnapshotSource source,
            Map<String, dynamic> payloadRaw,
            Map<String, dynamic> payloadNormalized,
            String schemaVersion,
            @SafeDateTimeConverter() DateTime fetchedAt,
            String hash,
            Map<String, dynamic> metadata)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetSnapshot() when $default != null:
        return $default(
            _that.id,
            _that.assetId,
            _that.source,
            _that.payloadRaw,
            _that.payloadNormalized,
            _that.schemaVersion,
            _that.fetchedAt,
            _that.hash,
            _that.metadata);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssetSnapshot extends AssetSnapshot {
  const _AssetSnapshot(
      {required this.id,
      this.assetId,
      required this.source,
      required final Map<String, dynamic> payloadRaw,
      required final Map<String, dynamic> payloadNormalized,
      this.schemaVersion = '1.0',
      @SafeDateTimeConverter() required this.fetchedAt,
      required this.hash,
      final Map<String, dynamic> metadata = const <String, dynamic>{}})
      : _payloadRaw = payloadRaw,
        _payloadNormalized = payloadNormalized,
        _metadata = metadata,
        super._();
  factory _AssetSnapshot.fromJson(Map<String, dynamic> json) =>
      _$AssetSnapshotFromJson(json);

  /// ID unico del snapshot (UUID v4)
  @override
  final String id;

  /// ID del asset asociado (null si es pre-registro)
  @override
  final String? assetId;

  /// Fuente de los datos
  @override
  final SnapshotSource source;

  /// Payload RAW de la fuente (JSON crudo sin transformar).
  /// JSON-SAFE: solo null, bool, num, String, List, Map.
  final Map<String, dynamic> _payloadRaw;

  /// Payload RAW de la fuente (JSON crudo sin transformar).
  /// JSON-SAFE: solo null, bool, num, String, List, Map.
  @override
  Map<String, dynamic> get payloadRaw {
    if (_payloadRaw is EqualUnmodifiableMapView) return _payloadRaw;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payloadRaw);
  }

  /// Payload normalizado (listo para crear AssetContent).
  /// JSON-SAFE: solo null, bool, num, String, List, Map.
  final Map<String, dynamic> _payloadNormalized;

  /// Payload normalizado (listo para crear AssetContent).
  /// JSON-SAFE: solo null, bool, num, String, List, Map.
  @override
  Map<String, dynamic> get payloadNormalized {
    if (_payloadNormalized is EqualUnmodifiableMapView)
      return _payloadNormalized;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payloadNormalized);
  }

  /// Version del schema de normalizacion
  @override
  @JsonKey()
  final String schemaVersion;

  /// Fecha de obtencion (UTC)
  @override
  @SafeDateTimeConverter()
  final DateTime fetchedAt;

  /// Hash SHA-256 del payloadRaw canonicalizado (para deteccion de cambios)
  @override
  final String hash;

  /// Metadatos adicionales (requestId, durationMs, etc.)
  final Map<String, dynamic> _metadata;

  /// Metadatos adicionales (requestId, durationMs, etc.)
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  /// Create a copy of AssetSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetSnapshotCopyWith<_AssetSnapshot> get copyWith =>
      __$AssetSnapshotCopyWithImpl<_AssetSnapshot>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetSnapshotToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetSnapshot &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality()
                .equals(other._payloadRaw, _payloadRaw) &&
            const DeepCollectionEquality()
                .equals(other._payloadNormalized, _payloadNormalized) &&
            (identical(other.schemaVersion, schemaVersion) ||
                other.schemaVersion == schemaVersion) &&
            (identical(other.fetchedAt, fetchedAt) ||
                other.fetchedAt == fetchedAt) &&
            (identical(other.hash, hash) || other.hash == hash) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      assetId,
      source,
      const DeepCollectionEquality().hash(_payloadRaw),
      const DeepCollectionEquality().hash(_payloadNormalized),
      schemaVersion,
      fetchedAt,
      hash,
      const DeepCollectionEquality().hash(_metadata));

  @override
  String toString() {
    return 'AssetSnapshot(id: $id, assetId: $assetId, source: $source, payloadRaw: $payloadRaw, payloadNormalized: $payloadNormalized, schemaVersion: $schemaVersion, fetchedAt: $fetchedAt, hash: $hash, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class _$AssetSnapshotCopyWith<$Res>
    implements $AssetSnapshotCopyWith<$Res> {
  factory _$AssetSnapshotCopyWith(
          _AssetSnapshot value, $Res Function(_AssetSnapshot) _then) =
      __$AssetSnapshotCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? assetId,
      SnapshotSource source,
      Map<String, dynamic> payloadRaw,
      Map<String, dynamic> payloadNormalized,
      String schemaVersion,
      @SafeDateTimeConverter() DateTime fetchedAt,
      String hash,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$AssetSnapshotCopyWithImpl<$Res>
    implements _$AssetSnapshotCopyWith<$Res> {
  __$AssetSnapshotCopyWithImpl(this._self, this._then);

  final _AssetSnapshot _self;
  final $Res Function(_AssetSnapshot) _then;

  /// Create a copy of AssetSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? assetId = freezed,
    Object? source = null,
    Object? payloadRaw = null,
    Object? payloadNormalized = null,
    Object? schemaVersion = null,
    Object? fetchedAt = null,
    Object? hash = null,
    Object? metadata = null,
  }) {
    return _then(_AssetSnapshot(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: freezed == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as SnapshotSource,
      payloadRaw: null == payloadRaw
          ? _self._payloadRaw
          : payloadRaw // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      payloadNormalized: null == payloadNormalized
          ? _self._payloadNormalized
          : payloadNormalized // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      schemaVersion: null == schemaVersion
          ? _self.schemaVersion
          : schemaVersion // ignore: cast_nullable_to_non_nullable
              as String,
      fetchedAt: null == fetchedAt
          ? _self.fetchedAt
          : fetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hash: null == hash
          ? _self.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _self._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

// dart format on
