// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_outbox_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncOutboxEntry {
  /// ID único de la entrada (UUID v4)
  String get id;

  /// Tipo de operación
  SyncOperationType get operationType;

  /// Tipo de entidad a sincronizar
  SyncEntityType get entityType;

  /// ID de la entidad afectada
  String get entityId;

  /// Ruta Firestore destino (ej: "assets/abc123")
  String get firestorePath;

  /// Payload JSON completo (incluye runtimeType para polimorfismo)
  Map<String, dynamic> get payload;

  /// Estado actual de sincronización
  SyncStatus get status;

  /// Número de intentos de sincronización
  int get retryCount;

  /// Máximo de reintentos antes de dead letter
  int get maxRetries;

  /// Último error (si falló)
  String? get lastError;

  /// Fecha de creación (orden de procesamiento)
  @SafeDateTimeConverter()
  DateTime get createdAt;

  /// Fecha de último intento
  @SafeDateTimeNullableConverter()
  DateTime? get lastAttemptAt;

  /// Fecha de completado (si status == completed)
  @SafeDateTimeNullableConverter()
  DateTime? get completedAt;

  /// Metadatos adicionales (userId, source, correlationId, etc.)
  Map<String, dynamic> get metadata;

  /// Create a copy of SyncOutboxEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SyncOutboxEntryCopyWith<SyncOutboxEntry> get copyWith =>
      _$SyncOutboxEntryCopyWithImpl<SyncOutboxEntry>(
          this as SyncOutboxEntry, _$identity);

  /// Serializes this SyncOutboxEntry to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncOutboxEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.operationType, operationType) ||
                other.operationType == operationType) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.firestorePath, firestorePath) ||
                other.firestorePath == firestorePath) &&
            const DeepCollectionEquality().equals(other.payload, payload) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.maxRetries, maxRetries) ||
                other.maxRetries == maxRetries) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastAttemptAt, lastAttemptAt) ||
                other.lastAttemptAt == lastAttemptAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(other.metadata, metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      operationType,
      entityType,
      entityId,
      firestorePath,
      const DeepCollectionEquality().hash(payload),
      status,
      retryCount,
      maxRetries,
      lastError,
      createdAt,
      lastAttemptAt,
      completedAt,
      const DeepCollectionEquality().hash(metadata));

  @override
  String toString() {
    return 'SyncOutboxEntry(id: $id, operationType: $operationType, entityType: $entityType, entityId: $entityId, firestorePath: $firestorePath, payload: $payload, status: $status, retryCount: $retryCount, maxRetries: $maxRetries, lastError: $lastError, createdAt: $createdAt, lastAttemptAt: $lastAttemptAt, completedAt: $completedAt, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class $SyncOutboxEntryCopyWith<$Res> {
  factory $SyncOutboxEntryCopyWith(
          SyncOutboxEntry value, $Res Function(SyncOutboxEntry) _then) =
      _$SyncOutboxEntryCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      SyncOperationType operationType,
      SyncEntityType entityType,
      String entityId,
      String firestorePath,
      Map<String, dynamic> payload,
      SyncStatus status,
      int retryCount,
      int maxRetries,
      String? lastError,
      @SafeDateTimeConverter() DateTime createdAt,
      @SafeDateTimeNullableConverter() DateTime? lastAttemptAt,
      @SafeDateTimeNullableConverter() DateTime? completedAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$SyncOutboxEntryCopyWithImpl<$Res>
    implements $SyncOutboxEntryCopyWith<$Res> {
  _$SyncOutboxEntryCopyWithImpl(this._self, this._then);

  final SyncOutboxEntry _self;
  final $Res Function(SyncOutboxEntry) _then;

  /// Create a copy of SyncOutboxEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? operationType = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? firestorePath = null,
    Object? payload = null,
    Object? status = null,
    Object? retryCount = null,
    Object? maxRetries = null,
    Object? lastError = freezed,
    Object? createdAt = null,
    Object? lastAttemptAt = freezed,
    Object? completedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      operationType: null == operationType
          ? _self.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as SyncOperationType,
      entityType: null == entityType
          ? _self.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as SyncEntityType,
      entityId: null == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      firestorePath: null == firestorePath
          ? _self.firestorePath
          : firestorePath // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _self.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      retryCount: null == retryCount
          ? _self.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      maxRetries: null == maxRetries
          ? _self.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      lastError: freezed == lastError
          ? _self.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastAttemptAt: freezed == lastAttemptAt
          ? _self.lastAttemptAt
          : lastAttemptAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: null == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SyncOutboxEntry].
extension SyncOutboxEntryPatterns on SyncOutboxEntry {
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
    TResult Function(_SyncOutboxEntry value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SyncOutboxEntry() when $default != null:
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
    TResult Function(_SyncOutboxEntry value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SyncOutboxEntry():
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
    TResult? Function(_SyncOutboxEntry value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SyncOutboxEntry() when $default != null:
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
            SyncOperationType operationType,
            SyncEntityType entityType,
            String entityId,
            String firestorePath,
            Map<String, dynamic> payload,
            SyncStatus status,
            int retryCount,
            int maxRetries,
            String? lastError,
            @SafeDateTimeConverter() DateTime createdAt,
            @SafeDateTimeNullableConverter() DateTime? lastAttemptAt,
            @SafeDateTimeNullableConverter() DateTime? completedAt,
            Map<String, dynamic> metadata)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SyncOutboxEntry() when $default != null:
        return $default(
            _that.id,
            _that.operationType,
            _that.entityType,
            _that.entityId,
            _that.firestorePath,
            _that.payload,
            _that.status,
            _that.retryCount,
            _that.maxRetries,
            _that.lastError,
            _that.createdAt,
            _that.lastAttemptAt,
            _that.completedAt,
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
            SyncOperationType operationType,
            SyncEntityType entityType,
            String entityId,
            String firestorePath,
            Map<String, dynamic> payload,
            SyncStatus status,
            int retryCount,
            int maxRetries,
            String? lastError,
            @SafeDateTimeConverter() DateTime createdAt,
            @SafeDateTimeNullableConverter() DateTime? lastAttemptAt,
            @SafeDateTimeNullableConverter() DateTime? completedAt,
            Map<String, dynamic> metadata)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SyncOutboxEntry():
        return $default(
            _that.id,
            _that.operationType,
            _that.entityType,
            _that.entityId,
            _that.firestorePath,
            _that.payload,
            _that.status,
            _that.retryCount,
            _that.maxRetries,
            _that.lastError,
            _that.createdAt,
            _that.lastAttemptAt,
            _that.completedAt,
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
            SyncOperationType operationType,
            SyncEntityType entityType,
            String entityId,
            String firestorePath,
            Map<String, dynamic> payload,
            SyncStatus status,
            int retryCount,
            int maxRetries,
            String? lastError,
            @SafeDateTimeConverter() DateTime createdAt,
            @SafeDateTimeNullableConverter() DateTime? lastAttemptAt,
            @SafeDateTimeNullableConverter() DateTime? completedAt,
            Map<String, dynamic> metadata)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SyncOutboxEntry() when $default != null:
        return $default(
            _that.id,
            _that.operationType,
            _that.entityType,
            _that.entityId,
            _that.firestorePath,
            _that.payload,
            _that.status,
            _that.retryCount,
            _that.maxRetries,
            _that.lastError,
            _that.createdAt,
            _that.lastAttemptAt,
            _that.completedAt,
            _that.metadata);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SyncOutboxEntry extends SyncOutboxEntry {
  const _SyncOutboxEntry(
      {required this.id,
      required this.operationType,
      required this.entityType,
      required this.entityId,
      required this.firestorePath,
      required final Map<String, dynamic> payload,
      this.status = SyncStatus.pending,
      this.retryCount = 0,
      this.maxRetries = 5,
      this.lastError,
      @SafeDateTimeConverter() required this.createdAt,
      @SafeDateTimeNullableConverter() this.lastAttemptAt,
      @SafeDateTimeNullableConverter() this.completedAt,
      final Map<String, dynamic> metadata = const <String, dynamic>{}})
      : _payload = payload,
        _metadata = metadata,
        super._();
  factory _SyncOutboxEntry.fromJson(Map<String, dynamic> json) =>
      _$SyncOutboxEntryFromJson(json);

  /// ID único de la entrada (UUID v4)
  @override
  final String id;

  /// Tipo de operación
  @override
  final SyncOperationType operationType;

  /// Tipo de entidad a sincronizar
  @override
  final SyncEntityType entityType;

  /// ID de la entidad afectada
  @override
  final String entityId;

  /// Ruta Firestore destino (ej: "assets/abc123")
  @override
  final String firestorePath;

  /// Payload JSON completo (incluye runtimeType para polimorfismo)
  final Map<String, dynamic> _payload;

  /// Payload JSON completo (incluye runtimeType para polimorfismo)
  @override
  Map<String, dynamic> get payload {
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payload);
  }

  /// Estado actual de sincronización
  @override
  @JsonKey()
  final SyncStatus status;

  /// Número de intentos de sincronización
  @override
  @JsonKey()
  final int retryCount;

  /// Máximo de reintentos antes de dead letter
  @override
  @JsonKey()
  final int maxRetries;

  /// Último error (si falló)
  @override
  final String? lastError;

  /// Fecha de creación (orden de procesamiento)
  @override
  @SafeDateTimeConverter()
  final DateTime createdAt;

  /// Fecha de último intento
  @override
  @SafeDateTimeNullableConverter()
  final DateTime? lastAttemptAt;

  /// Fecha de completado (si status == completed)
  @override
  @SafeDateTimeNullableConverter()
  final DateTime? completedAt;

  /// Metadatos adicionales (userId, source, correlationId, etc.)
  final Map<String, dynamic> _metadata;

  /// Metadatos adicionales (userId, source, correlationId, etc.)
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  /// Create a copy of SyncOutboxEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SyncOutboxEntryCopyWith<_SyncOutboxEntry> get copyWith =>
      __$SyncOutboxEntryCopyWithImpl<_SyncOutboxEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SyncOutboxEntryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SyncOutboxEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.operationType, operationType) ||
                other.operationType == operationType) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.firestorePath, firestorePath) ||
                other.firestorePath == firestorePath) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.maxRetries, maxRetries) ||
                other.maxRetries == maxRetries) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastAttemptAt, lastAttemptAt) ||
                other.lastAttemptAt == lastAttemptAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      operationType,
      entityType,
      entityId,
      firestorePath,
      const DeepCollectionEquality().hash(_payload),
      status,
      retryCount,
      maxRetries,
      lastError,
      createdAt,
      lastAttemptAt,
      completedAt,
      const DeepCollectionEquality().hash(_metadata));

  @override
  String toString() {
    return 'SyncOutboxEntry(id: $id, operationType: $operationType, entityType: $entityType, entityId: $entityId, firestorePath: $firestorePath, payload: $payload, status: $status, retryCount: $retryCount, maxRetries: $maxRetries, lastError: $lastError, createdAt: $createdAt, lastAttemptAt: $lastAttemptAt, completedAt: $completedAt, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class _$SyncOutboxEntryCopyWith<$Res>
    implements $SyncOutboxEntryCopyWith<$Res> {
  factory _$SyncOutboxEntryCopyWith(
          _SyncOutboxEntry value, $Res Function(_SyncOutboxEntry) _then) =
      __$SyncOutboxEntryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      SyncOperationType operationType,
      SyncEntityType entityType,
      String entityId,
      String firestorePath,
      Map<String, dynamic> payload,
      SyncStatus status,
      int retryCount,
      int maxRetries,
      String? lastError,
      @SafeDateTimeConverter() DateTime createdAt,
      @SafeDateTimeNullableConverter() DateTime? lastAttemptAt,
      @SafeDateTimeNullableConverter() DateTime? completedAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$SyncOutboxEntryCopyWithImpl<$Res>
    implements _$SyncOutboxEntryCopyWith<$Res> {
  __$SyncOutboxEntryCopyWithImpl(this._self, this._then);

  final _SyncOutboxEntry _self;
  final $Res Function(_SyncOutboxEntry) _then;

  /// Create a copy of SyncOutboxEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? operationType = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? firestorePath = null,
    Object? payload = null,
    Object? status = null,
    Object? retryCount = null,
    Object? maxRetries = null,
    Object? lastError = freezed,
    Object? createdAt = null,
    Object? lastAttemptAt = freezed,
    Object? completedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(_SyncOutboxEntry(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      operationType: null == operationType
          ? _self.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as SyncOperationType,
      entityType: null == entityType
          ? _self.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as SyncEntityType,
      entityId: null == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      firestorePath: null == firestorePath
          ? _self.firestorePath
          : firestorePath // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _self._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      retryCount: null == retryCount
          ? _self.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      maxRetries: null == maxRetries
          ? _self.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      lastError: freezed == lastError
          ? _self.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastAttemptAt: freezed == lastAttemptAt
          ? _self.lastAttemptAt
          : lastAttemptAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: null == metadata
          ? _self._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

// dart format on
