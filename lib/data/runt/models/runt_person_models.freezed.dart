// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'runt_person_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RuntPersonResponse {
  bool get ok;
  String get source;
  RuntPersonData get data;
  RuntPersonMeta? get meta;

  /// Create a copy of RuntPersonResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntPersonResponseCopyWith<RuntPersonResponse> get copyWith =>
      _$RuntPersonResponseCopyWithImpl<RuntPersonResponse>(
          this as RuntPersonResponse, _$identity);

  /// Serializes this RuntPersonResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntPersonResponse &&
            (identical(other.ok, ok) || other.ok == ok) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ok, source, data, meta);

  @override
  String toString() {
    return 'RuntPersonResponse(ok: $ok, source: $source, data: $data, meta: $meta)';
  }
}

/// @nodoc
abstract mixin class $RuntPersonResponseCopyWith<$Res> {
  factory $RuntPersonResponseCopyWith(
          RuntPersonResponse value, $Res Function(RuntPersonResponse) _then) =
      _$RuntPersonResponseCopyWithImpl;
  @useResult
  $Res call(
      {bool ok, String source, RuntPersonData data, RuntPersonMeta? meta});

  $RuntPersonDataCopyWith<$Res> get data;
  $RuntPersonMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class _$RuntPersonResponseCopyWithImpl<$Res>
    implements $RuntPersonResponseCopyWith<$Res> {
  _$RuntPersonResponseCopyWithImpl(this._self, this._then);

  final RuntPersonResponse _self;
  final $Res Function(RuntPersonResponse) _then;

  /// Create a copy of RuntPersonResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ok = null,
    Object? source = null,
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_self.copyWith(
      ok: null == ok
          ? _self.ok
          : ok // ignore: cast_nullable_to_non_nullable
              as bool,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as RuntPersonData,
      meta: freezed == meta
          ? _self.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as RuntPersonMeta?,
    ));
  }

  /// Create a copy of RuntPersonResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntPersonDataCopyWith<$Res> get data {
    return $RuntPersonDataCopyWith<$Res>(_self.data, (value) {
      return _then(_self.copyWith(data: value));
    });
  }

  /// Create a copy of RuntPersonResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntPersonMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
      return null;
    }

    return $RuntPersonMetaCopyWith<$Res>(_self.meta!, (value) {
      return _then(_self.copyWith(meta: value));
    });
  }
}

/// Adds pattern-matching-related methods to [RuntPersonResponse].
extension RuntPersonResponsePatterns on RuntPersonResponse {
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
    TResult Function(_RuntPersonResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntPersonResponse() when $default != null:
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
    TResult Function(_RuntPersonResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonResponse():
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
    TResult? Function(_RuntPersonResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonResponse() when $default != null:
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
            bool ok, String source, RuntPersonData data, RuntPersonMeta? meta)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntPersonResponse() when $default != null:
        return $default(_that.ok, _that.source, _that.data, _that.meta);
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
            bool ok, String source, RuntPersonData data, RuntPersonMeta? meta)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonResponse():
        return $default(_that.ok, _that.source, _that.data, _that.meta);
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
            bool ok, String source, RuntPersonData data, RuntPersonMeta? meta)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonResponse() when $default != null:
        return $default(_that.ok, _that.source, _that.data, _that.meta);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntPersonResponse implements RuntPersonResponse {
  const _RuntPersonResponse(
      {required this.ok, required this.source, required this.data, this.meta});
  factory _RuntPersonResponse.fromJson(Map<String, dynamic> json) =>
      _$RuntPersonResponseFromJson(json);

  @override
  final bool ok;
  @override
  final String source;
  @override
  final RuntPersonData data;
  @override
  final RuntPersonMeta? meta;

  /// Create a copy of RuntPersonResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntPersonResponseCopyWith<_RuntPersonResponse> get copyWith =>
      __$RuntPersonResponseCopyWithImpl<_RuntPersonResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntPersonResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntPersonResponse &&
            (identical(other.ok, ok) || other.ok == ok) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ok, source, data, meta);

  @override
  String toString() {
    return 'RuntPersonResponse(ok: $ok, source: $source, data: $data, meta: $meta)';
  }
}

/// @nodoc
abstract mixin class _$RuntPersonResponseCopyWith<$Res>
    implements $RuntPersonResponseCopyWith<$Res> {
  factory _$RuntPersonResponseCopyWith(
          _RuntPersonResponse value, $Res Function(_RuntPersonResponse) _then) =
      __$RuntPersonResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool ok, String source, RuntPersonData data, RuntPersonMeta? meta});

  @override
  $RuntPersonDataCopyWith<$Res> get data;
  @override
  $RuntPersonMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class __$RuntPersonResponseCopyWithImpl<$Res>
    implements _$RuntPersonResponseCopyWith<$Res> {
  __$RuntPersonResponseCopyWithImpl(this._self, this._then);

  final _RuntPersonResponse _self;
  final $Res Function(_RuntPersonResponse) _then;

  /// Create a copy of RuntPersonResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ok = null,
    Object? source = null,
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_RuntPersonResponse(
      ok: null == ok
          ? _self.ok
          : ok // ignore: cast_nullable_to_non_nullable
              as bool,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as RuntPersonData,
      meta: freezed == meta
          ? _self.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as RuntPersonMeta?,
    ));
  }

  /// Create a copy of RuntPersonResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntPersonDataCopyWith<$Res> get data {
    return $RuntPersonDataCopyWith<$Res>(_self.data, (value) {
      return _then(_self.copyWith(data: value));
    });
  }

  /// Create a copy of RuntPersonResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntPersonMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
      return null;
    }

    return $RuntPersonMetaCopyWith<$Res>(_self.meta!, (value) {
      return _then(_self.copyWith(meta: value));
    });
  }
}

/// @nodoc
mixin _$RuntPersonMeta {
  /// Timestamp ISO de cuando se realizó el fetch
  DateTime? get fetchedAt;

  /// Estrategia de scraping: "puppeteer" o similar
  String? get strategy;

  /// Si se ejecutó en modo headless (sin GUI)
  bool? get headless;

  /// ID único del request para trazabilidad
  String? get requestId;

  /// Duración total de la operación en milisegundos
  int? get durationMs;

  /// Create a copy of RuntPersonMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntPersonMetaCopyWith<RuntPersonMeta> get copyWith =>
      _$RuntPersonMetaCopyWithImpl<RuntPersonMeta>(
          this as RuntPersonMeta, _$identity);

  /// Serializes this RuntPersonMeta to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntPersonMeta &&
            (identical(other.fetchedAt, fetchedAt) ||
                other.fetchedAt == fetchedAt) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.headless, headless) ||
                other.headless == headless) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, fetchedAt, strategy, headless, requestId, durationMs);

  @override
  String toString() {
    return 'RuntPersonMeta(fetchedAt: $fetchedAt, strategy: $strategy, headless: $headless, requestId: $requestId, durationMs: $durationMs)';
  }
}

/// @nodoc
abstract mixin class $RuntPersonMetaCopyWith<$Res> {
  factory $RuntPersonMetaCopyWith(
          RuntPersonMeta value, $Res Function(RuntPersonMeta) _then) =
      _$RuntPersonMetaCopyWithImpl;
  @useResult
  $Res call(
      {DateTime? fetchedAt,
      String? strategy,
      bool? headless,
      String? requestId,
      int? durationMs});
}

/// @nodoc
class _$RuntPersonMetaCopyWithImpl<$Res>
    implements $RuntPersonMetaCopyWith<$Res> {
  _$RuntPersonMetaCopyWithImpl(this._self, this._then);

  final RuntPersonMeta _self;
  final $Res Function(RuntPersonMeta) _then;

  /// Create a copy of RuntPersonMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fetchedAt = freezed,
    Object? strategy = freezed,
    Object? headless = freezed,
    Object? requestId = freezed,
    Object? durationMs = freezed,
  }) {
    return _then(_self.copyWith(
      fetchedAt: freezed == fetchedAt
          ? _self.fetchedAt
          : fetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      strategy: freezed == strategy
          ? _self.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as String?,
      headless: freezed == headless
          ? _self.headless
          : headless // ignore: cast_nullable_to_non_nullable
              as bool?,
      requestId: freezed == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMs: freezed == durationMs
          ? _self.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntPersonMeta].
extension RuntPersonMetaPatterns on RuntPersonMeta {
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
    TResult Function(_RuntPersonMeta value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntPersonMeta() when $default != null:
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
    TResult Function(_RuntPersonMeta value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonMeta():
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
    TResult? Function(_RuntPersonMeta value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonMeta() when $default != null:
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
    TResult Function(DateTime? fetchedAt, String? strategy, bool? headless,
            String? requestId, int? durationMs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntPersonMeta() when $default != null:
        return $default(_that.fetchedAt, _that.strategy, _that.headless,
            _that.requestId, _that.durationMs);
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
    TResult Function(DateTime? fetchedAt, String? strategy, bool? headless,
            String? requestId, int? durationMs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonMeta():
        return $default(_that.fetchedAt, _that.strategy, _that.headless,
            _that.requestId, _that.durationMs);
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
    TResult? Function(DateTime? fetchedAt, String? strategy, bool? headless,
            String? requestId, int? durationMs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonMeta() when $default != null:
        return $default(_that.fetchedAt, _that.strategy, _that.headless,
            _that.requestId, _that.durationMs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntPersonMeta implements RuntPersonMeta {
  const _RuntPersonMeta(
      {this.fetchedAt,
      this.strategy,
      this.headless,
      this.requestId,
      this.durationMs});
  factory _RuntPersonMeta.fromJson(Map<String, dynamic> json) =>
      _$RuntPersonMetaFromJson(json);

  /// Timestamp ISO de cuando se realizó el fetch
  @override
  final DateTime? fetchedAt;

  /// Estrategia de scraping: "puppeteer" o similar
  @override
  final String? strategy;

  /// Si se ejecutó en modo headless (sin GUI)
  @override
  final bool? headless;

  /// ID único del request para trazabilidad
  @override
  final String? requestId;

  /// Duración total de la operación en milisegundos
  @override
  final int? durationMs;

  /// Create a copy of RuntPersonMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntPersonMetaCopyWith<_RuntPersonMeta> get copyWith =>
      __$RuntPersonMetaCopyWithImpl<_RuntPersonMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntPersonMetaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntPersonMeta &&
            (identical(other.fetchedAt, fetchedAt) ||
                other.fetchedAt == fetchedAt) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.headless, headless) ||
                other.headless == headless) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, fetchedAt, strategy, headless, requestId, durationMs);

  @override
  String toString() {
    return 'RuntPersonMeta(fetchedAt: $fetchedAt, strategy: $strategy, headless: $headless, requestId: $requestId, durationMs: $durationMs)';
  }
}

/// @nodoc
abstract mixin class _$RuntPersonMetaCopyWith<$Res>
    implements $RuntPersonMetaCopyWith<$Res> {
  factory _$RuntPersonMetaCopyWith(
          _RuntPersonMeta value, $Res Function(_RuntPersonMeta) _then) =
      __$RuntPersonMetaCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DateTime? fetchedAt,
      String? strategy,
      bool? headless,
      String? requestId,
      int? durationMs});
}

/// @nodoc
class __$RuntPersonMetaCopyWithImpl<$Res>
    implements _$RuntPersonMetaCopyWith<$Res> {
  __$RuntPersonMetaCopyWithImpl(this._self, this._then);

  final _RuntPersonMeta _self;
  final $Res Function(_RuntPersonMeta) _then;

  /// Create a copy of RuntPersonMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fetchedAt = freezed,
    Object? strategy = freezed,
    Object? headless = freezed,
    Object? requestId = freezed,
    Object? durationMs = freezed,
  }) {
    return _then(_RuntPersonMeta(
      fetchedAt: freezed == fetchedAt
          ? _self.fetchedAt
          : fetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      strategy: freezed == strategy
          ? _self.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as String?,
      headless: freezed == headless
          ? _self.headless
          : headless // ignore: cast_nullable_to_non_nullable
              as bool?,
      requestId: freezed == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMs: freezed == durationMs
          ? _self.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$RuntPersonData {
  /// Nombre completo de la persona
  @JsonKey(name: 'nombre_completo')
  String get fullName;

  /// Número de documento (cédula, pasaporte, etc.)
  @JsonKey(name: 'numero_documento')
  String get documentNumber;

  /// Tipo de documento: "C.C.", "C.E.", "PAS", etc.
  @JsonKey(name: 'tipo_documento')
  String? get documentType;

  /// Estado de la persona en el RUNT: "ACTIVA", "INACTIVA", etc.
  @JsonKey(name: 'estado_persona')
  String? get personStatus;

  /// Estado como conductor: "ACTIVO", "SUSPENDIDO", "INACTIVO", etc.
  @JsonKey(name: 'estado_conductor')
  String? get driverStatus;

  /// Número de inscripción única en el RUNT
  @JsonKey(name: 'numero_inscripcion_runt')
  String? get runtRegistrationNumber;

  /// Fecha de inscripción en el RUNT (formato dd/MM/yyyy)
  @JsonKey(name: 'fecha_inscripcion')
  String? get registrationDate;

  /// Lista de todas las licencias de conducción (históricas y actuales)
  List<RuntLicense> get licencias;

  /// Metadatos internos de la consulta
  @JsonKey(name: '_metadata')
  RuntPersonInternalMetadata? get internalMetadata;

  /// Create a copy of RuntPersonData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntPersonDataCopyWith<RuntPersonData> get copyWith =>
      _$RuntPersonDataCopyWithImpl<RuntPersonData>(
          this as RuntPersonData, _$identity);

  /// Serializes this RuntPersonData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntPersonData &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.documentNumber, documentNumber) ||
                other.documentNumber == documentNumber) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.personStatus, personStatus) ||
                other.personStatus == personStatus) &&
            (identical(other.driverStatus, driverStatus) ||
                other.driverStatus == driverStatus) &&
            (identical(other.runtRegistrationNumber, runtRegistrationNumber) ||
                other.runtRegistrationNumber == runtRegistrationNumber) &&
            (identical(other.registrationDate, registrationDate) ||
                other.registrationDate == registrationDate) &&
            const DeepCollectionEquality().equals(other.licencias, licencias) &&
            (identical(other.internalMetadata, internalMetadata) ||
                other.internalMetadata == internalMetadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fullName,
      documentNumber,
      documentType,
      personStatus,
      driverStatus,
      runtRegistrationNumber,
      registrationDate,
      const DeepCollectionEquality().hash(licencias),
      internalMetadata);

  @override
  String toString() {
    return 'RuntPersonData(fullName: $fullName, documentNumber: $documentNumber, documentType: $documentType, personStatus: $personStatus, driverStatus: $driverStatus, runtRegistrationNumber: $runtRegistrationNumber, registrationDate: $registrationDate, licencias: $licencias, internalMetadata: $internalMetadata)';
  }
}

/// @nodoc
abstract mixin class $RuntPersonDataCopyWith<$Res> {
  factory $RuntPersonDataCopyWith(
          RuntPersonData value, $Res Function(RuntPersonData) _then) =
      _$RuntPersonDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'nombre_completo') String fullName,
      @JsonKey(name: 'numero_documento') String documentNumber,
      @JsonKey(name: 'tipo_documento') String? documentType,
      @JsonKey(name: 'estado_persona') String? personStatus,
      @JsonKey(name: 'estado_conductor') String? driverStatus,
      @JsonKey(name: 'numero_inscripcion_runt') String? runtRegistrationNumber,
      @JsonKey(name: 'fecha_inscripcion') String? registrationDate,
      List<RuntLicense> licencias,
      @JsonKey(name: '_metadata')
      RuntPersonInternalMetadata? internalMetadata});

  $RuntPersonInternalMetadataCopyWith<$Res>? get internalMetadata;
}

/// @nodoc
class _$RuntPersonDataCopyWithImpl<$Res>
    implements $RuntPersonDataCopyWith<$Res> {
  _$RuntPersonDataCopyWithImpl(this._self, this._then);

  final RuntPersonData _self;
  final $Res Function(RuntPersonData) _then;

  /// Create a copy of RuntPersonData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? documentNumber = null,
    Object? documentType = freezed,
    Object? personStatus = freezed,
    Object? driverStatus = freezed,
    Object? runtRegistrationNumber = freezed,
    Object? registrationDate = freezed,
    Object? licencias = null,
    Object? internalMetadata = freezed,
  }) {
    return _then(_self.copyWith(
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      documentNumber: null == documentNumber
          ? _self.documentNumber
          : documentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: freezed == documentType
          ? _self.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String?,
      personStatus: freezed == personStatus
          ? _self.personStatus
          : personStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      driverStatus: freezed == driverStatus
          ? _self.driverStatus
          : driverStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      runtRegistrationNumber: freezed == runtRegistrationNumber
          ? _self.runtRegistrationNumber
          : runtRegistrationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationDate: freezed == registrationDate
          ? _self.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as String?,
      licencias: null == licencias
          ? _self.licencias
          : licencias // ignore: cast_nullable_to_non_nullable
              as List<RuntLicense>,
      internalMetadata: freezed == internalMetadata
          ? _self.internalMetadata
          : internalMetadata // ignore: cast_nullable_to_non_nullable
              as RuntPersonInternalMetadata?,
    ));
  }

  /// Create a copy of RuntPersonData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntPersonInternalMetadataCopyWith<$Res>? get internalMetadata {
    if (_self.internalMetadata == null) {
      return null;
    }

    return $RuntPersonInternalMetadataCopyWith<$Res>(_self.internalMetadata!,
        (value) {
      return _then(_self.copyWith(internalMetadata: value));
    });
  }
}

/// Adds pattern-matching-related methods to [RuntPersonData].
extension RuntPersonDataPatterns on RuntPersonData {
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
    TResult Function(_RuntPersonData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntPersonData() when $default != null:
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
    TResult Function(_RuntPersonData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonData():
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
    TResult? Function(_RuntPersonData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonData() when $default != null:
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
            @JsonKey(name: 'nombre_completo') String fullName,
            @JsonKey(name: 'numero_documento') String documentNumber,
            @JsonKey(name: 'tipo_documento') String? documentType,
            @JsonKey(name: 'estado_persona') String? personStatus,
            @JsonKey(name: 'estado_conductor') String? driverStatus,
            @JsonKey(name: 'numero_inscripcion_runt')
            String? runtRegistrationNumber,
            @JsonKey(name: 'fecha_inscripcion') String? registrationDate,
            List<RuntLicense> licencias,
            @JsonKey(name: '_metadata')
            RuntPersonInternalMetadata? internalMetadata)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntPersonData() when $default != null:
        return $default(
            _that.fullName,
            _that.documentNumber,
            _that.documentType,
            _that.personStatus,
            _that.driverStatus,
            _that.runtRegistrationNumber,
            _that.registrationDate,
            _that.licencias,
            _that.internalMetadata);
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
            @JsonKey(name: 'nombre_completo') String fullName,
            @JsonKey(name: 'numero_documento') String documentNumber,
            @JsonKey(name: 'tipo_documento') String? documentType,
            @JsonKey(name: 'estado_persona') String? personStatus,
            @JsonKey(name: 'estado_conductor') String? driverStatus,
            @JsonKey(name: 'numero_inscripcion_runt')
            String? runtRegistrationNumber,
            @JsonKey(name: 'fecha_inscripcion') String? registrationDate,
            List<RuntLicense> licencias,
            @JsonKey(name: '_metadata')
            RuntPersonInternalMetadata? internalMetadata)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonData():
        return $default(
            _that.fullName,
            _that.documentNumber,
            _that.documentType,
            _that.personStatus,
            _that.driverStatus,
            _that.runtRegistrationNumber,
            _that.registrationDate,
            _that.licencias,
            _that.internalMetadata);
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
            @JsonKey(name: 'nombre_completo') String fullName,
            @JsonKey(name: 'numero_documento') String documentNumber,
            @JsonKey(name: 'tipo_documento') String? documentType,
            @JsonKey(name: 'estado_persona') String? personStatus,
            @JsonKey(name: 'estado_conductor') String? driverStatus,
            @JsonKey(name: 'numero_inscripcion_runt')
            String? runtRegistrationNumber,
            @JsonKey(name: 'fecha_inscripcion') String? registrationDate,
            List<RuntLicense> licencias,
            @JsonKey(name: '_metadata')
            RuntPersonInternalMetadata? internalMetadata)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonData() when $default != null:
        return $default(
            _that.fullName,
            _that.documentNumber,
            _that.documentType,
            _that.personStatus,
            _that.driverStatus,
            _that.runtRegistrationNumber,
            _that.registrationDate,
            _that.licencias,
            _that.internalMetadata);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntPersonData implements RuntPersonData {
  const _RuntPersonData(
      {@JsonKey(name: 'nombre_completo') required this.fullName,
      @JsonKey(name: 'numero_documento') required this.documentNumber,
      @JsonKey(name: 'tipo_documento') this.documentType,
      @JsonKey(name: 'estado_persona') this.personStatus,
      @JsonKey(name: 'estado_conductor') this.driverStatus,
      @JsonKey(name: 'numero_inscripcion_runt') this.runtRegistrationNumber,
      @JsonKey(name: 'fecha_inscripcion') this.registrationDate,
      final List<RuntLicense> licencias = const [],
      @JsonKey(name: '_metadata') this.internalMetadata})
      : _licencias = licencias;
  factory _RuntPersonData.fromJson(Map<String, dynamic> json) =>
      _$RuntPersonDataFromJson(json);

  /// Nombre completo de la persona
  @override
  @JsonKey(name: 'nombre_completo')
  final String fullName;

  /// Número de documento (cédula, pasaporte, etc.)
  @override
  @JsonKey(name: 'numero_documento')
  final String documentNumber;

  /// Tipo de documento: "C.C.", "C.E.", "PAS", etc.
  @override
  @JsonKey(name: 'tipo_documento')
  final String? documentType;

  /// Estado de la persona en el RUNT: "ACTIVA", "INACTIVA", etc.
  @override
  @JsonKey(name: 'estado_persona')
  final String? personStatus;

  /// Estado como conductor: "ACTIVO", "SUSPENDIDO", "INACTIVO", etc.
  @override
  @JsonKey(name: 'estado_conductor')
  final String? driverStatus;

  /// Número de inscripción única en el RUNT
  @override
  @JsonKey(name: 'numero_inscripcion_runt')
  final String? runtRegistrationNumber;

  /// Fecha de inscripción en el RUNT (formato dd/MM/yyyy)
  @override
  @JsonKey(name: 'fecha_inscripcion')
  final String? registrationDate;

  /// Lista de todas las licencias de conducción (históricas y actuales)
  final List<RuntLicense> _licencias;

  /// Lista de todas las licencias de conducción (históricas y actuales)
  @override
  @JsonKey()
  List<RuntLicense> get licencias {
    if (_licencias is EqualUnmodifiableListView) return _licencias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_licencias);
  }

  /// Metadatos internos de la consulta
  @override
  @JsonKey(name: '_metadata')
  final RuntPersonInternalMetadata? internalMetadata;

  /// Create a copy of RuntPersonData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntPersonDataCopyWith<_RuntPersonData> get copyWith =>
      __$RuntPersonDataCopyWithImpl<_RuntPersonData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntPersonDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntPersonData &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.documentNumber, documentNumber) ||
                other.documentNumber == documentNumber) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.personStatus, personStatus) ||
                other.personStatus == personStatus) &&
            (identical(other.driverStatus, driverStatus) ||
                other.driverStatus == driverStatus) &&
            (identical(other.runtRegistrationNumber, runtRegistrationNumber) ||
                other.runtRegistrationNumber == runtRegistrationNumber) &&
            (identical(other.registrationDate, registrationDate) ||
                other.registrationDate == registrationDate) &&
            const DeepCollectionEquality()
                .equals(other._licencias, _licencias) &&
            (identical(other.internalMetadata, internalMetadata) ||
                other.internalMetadata == internalMetadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fullName,
      documentNumber,
      documentType,
      personStatus,
      driverStatus,
      runtRegistrationNumber,
      registrationDate,
      const DeepCollectionEquality().hash(_licencias),
      internalMetadata);

  @override
  String toString() {
    return 'RuntPersonData(fullName: $fullName, documentNumber: $documentNumber, documentType: $documentType, personStatus: $personStatus, driverStatus: $driverStatus, runtRegistrationNumber: $runtRegistrationNumber, registrationDate: $registrationDate, licencias: $licencias, internalMetadata: $internalMetadata)';
  }
}

/// @nodoc
abstract mixin class _$RuntPersonDataCopyWith<$Res>
    implements $RuntPersonDataCopyWith<$Res> {
  factory _$RuntPersonDataCopyWith(
          _RuntPersonData value, $Res Function(_RuntPersonData) _then) =
      __$RuntPersonDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'nombre_completo') String fullName,
      @JsonKey(name: 'numero_documento') String documentNumber,
      @JsonKey(name: 'tipo_documento') String? documentType,
      @JsonKey(name: 'estado_persona') String? personStatus,
      @JsonKey(name: 'estado_conductor') String? driverStatus,
      @JsonKey(name: 'numero_inscripcion_runt') String? runtRegistrationNumber,
      @JsonKey(name: 'fecha_inscripcion') String? registrationDate,
      List<RuntLicense> licencias,
      @JsonKey(name: '_metadata')
      RuntPersonInternalMetadata? internalMetadata});

  @override
  $RuntPersonInternalMetadataCopyWith<$Res>? get internalMetadata;
}

/// @nodoc
class __$RuntPersonDataCopyWithImpl<$Res>
    implements _$RuntPersonDataCopyWith<$Res> {
  __$RuntPersonDataCopyWithImpl(this._self, this._then);

  final _RuntPersonData _self;
  final $Res Function(_RuntPersonData) _then;

  /// Create a copy of RuntPersonData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fullName = null,
    Object? documentNumber = null,
    Object? documentType = freezed,
    Object? personStatus = freezed,
    Object? driverStatus = freezed,
    Object? runtRegistrationNumber = freezed,
    Object? registrationDate = freezed,
    Object? licencias = null,
    Object? internalMetadata = freezed,
  }) {
    return _then(_RuntPersonData(
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      documentNumber: null == documentNumber
          ? _self.documentNumber
          : documentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: freezed == documentType
          ? _self.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String?,
      personStatus: freezed == personStatus
          ? _self.personStatus
          : personStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      driverStatus: freezed == driverStatus
          ? _self.driverStatus
          : driverStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      runtRegistrationNumber: freezed == runtRegistrationNumber
          ? _self.runtRegistrationNumber
          : runtRegistrationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationDate: freezed == registrationDate
          ? _self.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as String?,
      licencias: null == licencias
          ? _self._licencias
          : licencias // ignore: cast_nullable_to_non_nullable
              as List<RuntLicense>,
      internalMetadata: freezed == internalMetadata
          ? _self.internalMetadata
          : internalMetadata // ignore: cast_nullable_to_non_nullable
              as RuntPersonInternalMetadata?,
    ));
  }

  /// Create a copy of RuntPersonData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntPersonInternalMetadataCopyWith<$Res>? get internalMetadata {
    if (_self.internalMetadata == null) {
      return null;
    }

    return $RuntPersonInternalMetadataCopyWith<$Res>(_self.internalMetadata!,
        (value) {
      return _then(_self.copyWith(internalMetadata: value));
    });
  }
}

/// @nodoc
mixin _$RuntPersonInternalMetadata {
  /// Total de licencias encontradas para esta persona
  @JsonKey(name: 'total_licencias')
  int? get totalLicenses;

  /// Timestamp ISO de cuando se realizó la consulta
  @JsonKey(name: 'fecha_consulta')
  DateTime? get queryDate;

  /// Create a copy of RuntPersonInternalMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntPersonInternalMetadataCopyWith<RuntPersonInternalMetadata>
      get copyWith =>
          _$RuntPersonInternalMetadataCopyWithImpl<RuntPersonInternalMetadata>(
              this as RuntPersonInternalMetadata, _$identity);

  /// Serializes this RuntPersonInternalMetadata to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntPersonInternalMetadata &&
            (identical(other.totalLicenses, totalLicenses) ||
                other.totalLicenses == totalLicenses) &&
            (identical(other.queryDate, queryDate) ||
                other.queryDate == queryDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalLicenses, queryDate);

  @override
  String toString() {
    return 'RuntPersonInternalMetadata(totalLicenses: $totalLicenses, queryDate: $queryDate)';
  }
}

/// @nodoc
abstract mixin class $RuntPersonInternalMetadataCopyWith<$Res> {
  factory $RuntPersonInternalMetadataCopyWith(RuntPersonInternalMetadata value,
          $Res Function(RuntPersonInternalMetadata) _then) =
      _$RuntPersonInternalMetadataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_licencias') int? totalLicenses,
      @JsonKey(name: 'fecha_consulta') DateTime? queryDate});
}

/// @nodoc
class _$RuntPersonInternalMetadataCopyWithImpl<$Res>
    implements $RuntPersonInternalMetadataCopyWith<$Res> {
  _$RuntPersonInternalMetadataCopyWithImpl(this._self, this._then);

  final RuntPersonInternalMetadata _self;
  final $Res Function(RuntPersonInternalMetadata) _then;

  /// Create a copy of RuntPersonInternalMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalLicenses = freezed,
    Object? queryDate = freezed,
  }) {
    return _then(_self.copyWith(
      totalLicenses: freezed == totalLicenses
          ? _self.totalLicenses
          : totalLicenses // ignore: cast_nullable_to_non_nullable
              as int?,
      queryDate: freezed == queryDate
          ? _self.queryDate
          : queryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntPersonInternalMetadata].
extension RuntPersonInternalMetadataPatterns on RuntPersonInternalMetadata {
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
    TResult Function(_RuntPersonInternalMetadata value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntPersonInternalMetadata() when $default != null:
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
    TResult Function(_RuntPersonInternalMetadata value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonInternalMetadata():
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
    TResult? Function(_RuntPersonInternalMetadata value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonInternalMetadata() when $default != null:
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
    TResult Function(@JsonKey(name: 'total_licencias') int? totalLicenses,
            @JsonKey(name: 'fecha_consulta') DateTime? queryDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntPersonInternalMetadata() when $default != null:
        return $default(_that.totalLicenses, _that.queryDate);
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
    TResult Function(@JsonKey(name: 'total_licencias') int? totalLicenses,
            @JsonKey(name: 'fecha_consulta') DateTime? queryDate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonInternalMetadata():
        return $default(_that.totalLicenses, _that.queryDate);
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
    TResult? Function(@JsonKey(name: 'total_licencias') int? totalLicenses,
            @JsonKey(name: 'fecha_consulta') DateTime? queryDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntPersonInternalMetadata() when $default != null:
        return $default(_that.totalLicenses, _that.queryDate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntPersonInternalMetadata implements RuntPersonInternalMetadata {
  const _RuntPersonInternalMetadata(
      {@JsonKey(name: 'total_licencias') this.totalLicenses,
      @JsonKey(name: 'fecha_consulta') this.queryDate});
  factory _RuntPersonInternalMetadata.fromJson(Map<String, dynamic> json) =>
      _$RuntPersonInternalMetadataFromJson(json);

  /// Total de licencias encontradas para esta persona
  @override
  @JsonKey(name: 'total_licencias')
  final int? totalLicenses;

  /// Timestamp ISO de cuando se realizó la consulta
  @override
  @JsonKey(name: 'fecha_consulta')
  final DateTime? queryDate;

  /// Create a copy of RuntPersonInternalMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntPersonInternalMetadataCopyWith<_RuntPersonInternalMetadata>
      get copyWith => __$RuntPersonInternalMetadataCopyWithImpl<
          _RuntPersonInternalMetadata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntPersonInternalMetadataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntPersonInternalMetadata &&
            (identical(other.totalLicenses, totalLicenses) ||
                other.totalLicenses == totalLicenses) &&
            (identical(other.queryDate, queryDate) ||
                other.queryDate == queryDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalLicenses, queryDate);

  @override
  String toString() {
    return 'RuntPersonInternalMetadata(totalLicenses: $totalLicenses, queryDate: $queryDate)';
  }
}

/// @nodoc
abstract mixin class _$RuntPersonInternalMetadataCopyWith<$Res>
    implements $RuntPersonInternalMetadataCopyWith<$Res> {
  factory _$RuntPersonInternalMetadataCopyWith(
          _RuntPersonInternalMetadata value,
          $Res Function(_RuntPersonInternalMetadata) _then) =
      __$RuntPersonInternalMetadataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_licencias') int? totalLicenses,
      @JsonKey(name: 'fecha_consulta') DateTime? queryDate});
}

/// @nodoc
class __$RuntPersonInternalMetadataCopyWithImpl<$Res>
    implements _$RuntPersonInternalMetadataCopyWith<$Res> {
  __$RuntPersonInternalMetadataCopyWithImpl(this._self, this._then);

  final _RuntPersonInternalMetadata _self;
  final $Res Function(_RuntPersonInternalMetadata) _then;

  /// Create a copy of RuntPersonInternalMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalLicenses = freezed,
    Object? queryDate = freezed,
  }) {
    return _then(_RuntPersonInternalMetadata(
      totalLicenses: freezed == totalLicenses
          ? _self.totalLicenses
          : totalLicenses // ignore: cast_nullable_to_non_nullable
              as int?,
      queryDate: freezed == queryDate
          ? _self.queryDate
          : queryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$RuntLicense {
  /// Número único de la licencia de conducción
  @JsonKey(name: 'numero_licencia')
  String? get licenseNumber;

  /// Organismo de tránsito que expidió la licencia
  @JsonKey(name: 'ot_expide')
  String? get issuingAuthority;

  /// Fecha de expedición (formato dd/MM/yyyy)
  @JsonKey(name: 'fecha_expedicion')
  String? get issueDate;

  /// Estado actual: "ACTIVA", "INACTIVA", "SUSPENDIDA", etc.
  String? get estado;

  /// Restricciones especiales (ej: uso de lentes, audífonos)
  String? get restricciones;

  /// Indica si la licencia está retenida: "SI" o "NO"
  @JsonKey(name: 'retencion')
  String? get retention;

  /// Organismo que canceló o suspendió (si aplica)
  @JsonKey(name: 'ot_cancela_suspende')
  String? get cancelingAuthority;

  /// Detalles de categorías de esta licencia
  List<RuntLicenseDetail> get detalles;

  /// Create a copy of RuntLicense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntLicenseCopyWith<RuntLicense> get copyWith =>
      _$RuntLicenseCopyWithImpl<RuntLicense>(this as RuntLicense, _$identity);

  /// Serializes this RuntLicense to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntLicense &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.issuingAuthority, issuingAuthority) ||
                other.issuingAuthority == issuingAuthority) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.restricciones, restricciones) ||
                other.restricciones == restricciones) &&
            (identical(other.retention, retention) ||
                other.retention == retention) &&
            (identical(other.cancelingAuthority, cancelingAuthority) ||
                other.cancelingAuthority == cancelingAuthority) &&
            const DeepCollectionEquality().equals(other.detalles, detalles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      licenseNumber,
      issuingAuthority,
      issueDate,
      estado,
      restricciones,
      retention,
      cancelingAuthority,
      const DeepCollectionEquality().hash(detalles));

  @override
  String toString() {
    return 'RuntLicense(licenseNumber: $licenseNumber, issuingAuthority: $issuingAuthority, issueDate: $issueDate, estado: $estado, restricciones: $restricciones, retention: $retention, cancelingAuthority: $cancelingAuthority, detalles: $detalles)';
  }
}

/// @nodoc
abstract mixin class $RuntLicenseCopyWith<$Res> {
  factory $RuntLicenseCopyWith(
          RuntLicense value, $Res Function(RuntLicense) _then) =
      _$RuntLicenseCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'numero_licencia') String? licenseNumber,
      @JsonKey(name: 'ot_expide') String? issuingAuthority,
      @JsonKey(name: 'fecha_expedicion') String? issueDate,
      String? estado,
      String? restricciones,
      @JsonKey(name: 'retencion') String? retention,
      @JsonKey(name: 'ot_cancela_suspende') String? cancelingAuthority,
      List<RuntLicenseDetail> detalles});
}

/// @nodoc
class _$RuntLicenseCopyWithImpl<$Res> implements $RuntLicenseCopyWith<$Res> {
  _$RuntLicenseCopyWithImpl(this._self, this._then);

  final RuntLicense _self;
  final $Res Function(RuntLicense) _then;

  /// Create a copy of RuntLicense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? licenseNumber = freezed,
    Object? issuingAuthority = freezed,
    Object? issueDate = freezed,
    Object? estado = freezed,
    Object? restricciones = freezed,
    Object? retention = freezed,
    Object? cancelingAuthority = freezed,
    Object? detalles = null,
  }) {
    return _then(_self.copyWith(
      licenseNumber: freezed == licenseNumber
          ? _self.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      issuingAuthority: freezed == issuingAuthority
          ? _self.issuingAuthority
          : issuingAuthority // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      estado: freezed == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String?,
      restricciones: freezed == restricciones
          ? _self.restricciones
          : restricciones // ignore: cast_nullable_to_non_nullable
              as String?,
      retention: freezed == retention
          ? _self.retention
          : retention // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelingAuthority: freezed == cancelingAuthority
          ? _self.cancelingAuthority
          : cancelingAuthority // ignore: cast_nullable_to_non_nullable
              as String?,
      detalles: null == detalles
          ? _self.detalles
          : detalles // ignore: cast_nullable_to_non_nullable
              as List<RuntLicenseDetail>,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntLicense].
extension RuntLicensePatterns on RuntLicense {
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
    TResult Function(_RuntLicense value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntLicense() when $default != null:
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
    TResult Function(_RuntLicense value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntLicense():
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
    TResult? Function(_RuntLicense value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntLicense() when $default != null:
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
            @JsonKey(name: 'numero_licencia') String? licenseNumber,
            @JsonKey(name: 'ot_expide') String? issuingAuthority,
            @JsonKey(name: 'fecha_expedicion') String? issueDate,
            String? estado,
            String? restricciones,
            @JsonKey(name: 'retencion') String? retention,
            @JsonKey(name: 'ot_cancela_suspende') String? cancelingAuthority,
            List<RuntLicenseDetail> detalles)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntLicense() when $default != null:
        return $default(
            _that.licenseNumber,
            _that.issuingAuthority,
            _that.issueDate,
            _that.estado,
            _that.restricciones,
            _that.retention,
            _that.cancelingAuthority,
            _that.detalles);
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
            @JsonKey(name: 'numero_licencia') String? licenseNumber,
            @JsonKey(name: 'ot_expide') String? issuingAuthority,
            @JsonKey(name: 'fecha_expedicion') String? issueDate,
            String? estado,
            String? restricciones,
            @JsonKey(name: 'retencion') String? retention,
            @JsonKey(name: 'ot_cancela_suspende') String? cancelingAuthority,
            List<RuntLicenseDetail> detalles)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntLicense():
        return $default(
            _that.licenseNumber,
            _that.issuingAuthority,
            _that.issueDate,
            _that.estado,
            _that.restricciones,
            _that.retention,
            _that.cancelingAuthority,
            _that.detalles);
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
            @JsonKey(name: 'numero_licencia') String? licenseNumber,
            @JsonKey(name: 'ot_expide') String? issuingAuthority,
            @JsonKey(name: 'fecha_expedicion') String? issueDate,
            String? estado,
            String? restricciones,
            @JsonKey(name: 'retencion') String? retention,
            @JsonKey(name: 'ot_cancela_suspende') String? cancelingAuthority,
            List<RuntLicenseDetail> detalles)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntLicense() when $default != null:
        return $default(
            _that.licenseNumber,
            _that.issuingAuthority,
            _that.issueDate,
            _that.estado,
            _that.restricciones,
            _that.retention,
            _that.cancelingAuthority,
            _that.detalles);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntLicense implements RuntLicense {
  const _RuntLicense(
      {@JsonKey(name: 'numero_licencia') this.licenseNumber,
      @JsonKey(name: 'ot_expide') this.issuingAuthority,
      @JsonKey(name: 'fecha_expedicion') this.issueDate,
      this.estado,
      this.restricciones,
      @JsonKey(name: 'retencion') this.retention,
      @JsonKey(name: 'ot_cancela_suspende') this.cancelingAuthority,
      final List<RuntLicenseDetail> detalles = const []})
      : _detalles = detalles;
  factory _RuntLicense.fromJson(Map<String, dynamic> json) =>
      _$RuntLicenseFromJson(json);

  /// Número único de la licencia de conducción
  @override
  @JsonKey(name: 'numero_licencia')
  final String? licenseNumber;

  /// Organismo de tránsito que expidió la licencia
  @override
  @JsonKey(name: 'ot_expide')
  final String? issuingAuthority;

  /// Fecha de expedición (formato dd/MM/yyyy)
  @override
  @JsonKey(name: 'fecha_expedicion')
  final String? issueDate;

  /// Estado actual: "ACTIVA", "INACTIVA", "SUSPENDIDA", etc.
  @override
  final String? estado;

  /// Restricciones especiales (ej: uso de lentes, audífonos)
  @override
  final String? restricciones;

  /// Indica si la licencia está retenida: "SI" o "NO"
  @override
  @JsonKey(name: 'retencion')
  final String? retention;

  /// Organismo que canceló o suspendió (si aplica)
  @override
  @JsonKey(name: 'ot_cancela_suspende')
  final String? cancelingAuthority;

  /// Detalles de categorías de esta licencia
  final List<RuntLicenseDetail> _detalles;

  /// Detalles de categorías de esta licencia
  @override
  @JsonKey()
  List<RuntLicenseDetail> get detalles {
    if (_detalles is EqualUnmodifiableListView) return _detalles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_detalles);
  }

  /// Create a copy of RuntLicense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntLicenseCopyWith<_RuntLicense> get copyWith =>
      __$RuntLicenseCopyWithImpl<_RuntLicense>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntLicenseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntLicense &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.issuingAuthority, issuingAuthority) ||
                other.issuingAuthority == issuingAuthority) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.restricciones, restricciones) ||
                other.restricciones == restricciones) &&
            (identical(other.retention, retention) ||
                other.retention == retention) &&
            (identical(other.cancelingAuthority, cancelingAuthority) ||
                other.cancelingAuthority == cancelingAuthority) &&
            const DeepCollectionEquality().equals(other._detalles, _detalles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      licenseNumber,
      issuingAuthority,
      issueDate,
      estado,
      restricciones,
      retention,
      cancelingAuthority,
      const DeepCollectionEquality().hash(_detalles));

  @override
  String toString() {
    return 'RuntLicense(licenseNumber: $licenseNumber, issuingAuthority: $issuingAuthority, issueDate: $issueDate, estado: $estado, restricciones: $restricciones, retention: $retention, cancelingAuthority: $cancelingAuthority, detalles: $detalles)';
  }
}

/// @nodoc
abstract mixin class _$RuntLicenseCopyWith<$Res>
    implements $RuntLicenseCopyWith<$Res> {
  factory _$RuntLicenseCopyWith(
          _RuntLicense value, $Res Function(_RuntLicense) _then) =
      __$RuntLicenseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'numero_licencia') String? licenseNumber,
      @JsonKey(name: 'ot_expide') String? issuingAuthority,
      @JsonKey(name: 'fecha_expedicion') String? issueDate,
      String? estado,
      String? restricciones,
      @JsonKey(name: 'retencion') String? retention,
      @JsonKey(name: 'ot_cancela_suspende') String? cancelingAuthority,
      List<RuntLicenseDetail> detalles});
}

/// @nodoc
class __$RuntLicenseCopyWithImpl<$Res> implements _$RuntLicenseCopyWith<$Res> {
  __$RuntLicenseCopyWithImpl(this._self, this._then);

  final _RuntLicense _self;
  final $Res Function(_RuntLicense) _then;

  /// Create a copy of RuntLicense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? licenseNumber = freezed,
    Object? issuingAuthority = freezed,
    Object? issueDate = freezed,
    Object? estado = freezed,
    Object? restricciones = freezed,
    Object? retention = freezed,
    Object? cancelingAuthority = freezed,
    Object? detalles = null,
  }) {
    return _then(_RuntLicense(
      licenseNumber: freezed == licenseNumber
          ? _self.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      issuingAuthority: freezed == issuingAuthority
          ? _self.issuingAuthority
          : issuingAuthority // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      estado: freezed == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String?,
      restricciones: freezed == restricciones
          ? _self.restricciones
          : restricciones // ignore: cast_nullable_to_non_nullable
              as String?,
      retention: freezed == retention
          ? _self.retention
          : retention // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelingAuthority: freezed == cancelingAuthority
          ? _self.cancelingAuthority
          : cancelingAuthority // ignore: cast_nullable_to_non_nullable
              as String?,
      detalles: null == detalles
          ? _self._detalles
          : detalles // ignore: cast_nullable_to_non_nullable
              as List<RuntLicenseDetail>,
    ));
  }
}

/// @nodoc
mixin _$RuntLicenseDetail {
  /// Categoría de la licencia: "A1", "A2", "B1", "B2", "C1", etc.
  @JsonKey(name: 'categoria')
  String? get category;

  /// Fecha de expedición de esta categoría (formato dd/MM/yyyy)
  @JsonKey(name: 'fecha_expedicion')
  String? get issueDate;

  /// Fecha de vencimiento de esta categoría (formato dd/MM/yyyy)
  @JsonKey(name: 'fecha_vencimiento')
  String? get expiryDate;

  /// Categoría antigua (antes del cambio normativo), si aplica
  @JsonKey(name: 'categoria_antigua')
  String? get previousCategory;

  /// Create a copy of RuntLicenseDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntLicenseDetailCopyWith<RuntLicenseDetail> get copyWith =>
      _$RuntLicenseDetailCopyWithImpl<RuntLicenseDetail>(
          this as RuntLicenseDetail, _$identity);

  /// Serializes this RuntLicenseDetail to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntLicenseDetail &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.previousCategory, previousCategory) ||
                other.previousCategory == previousCategory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, category, issueDate, expiryDate, previousCategory);

  @override
  String toString() {
    return 'RuntLicenseDetail(category: $category, issueDate: $issueDate, expiryDate: $expiryDate, previousCategory: $previousCategory)';
  }
}

/// @nodoc
abstract mixin class $RuntLicenseDetailCopyWith<$Res> {
  factory $RuntLicenseDetailCopyWith(
          RuntLicenseDetail value, $Res Function(RuntLicenseDetail) _then) =
      _$RuntLicenseDetailCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'categoria') String? category,
      @JsonKey(name: 'fecha_expedicion') String? issueDate,
      @JsonKey(name: 'fecha_vencimiento') String? expiryDate,
      @JsonKey(name: 'categoria_antigua') String? previousCategory});
}

/// @nodoc
class _$RuntLicenseDetailCopyWithImpl<$Res>
    implements $RuntLicenseDetailCopyWith<$Res> {
  _$RuntLicenseDetailCopyWithImpl(this._self, this._then);

  final RuntLicenseDetail _self;
  final $Res Function(RuntLicenseDetail) _then;

  /// Create a copy of RuntLicenseDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = freezed,
    Object? issueDate = freezed,
    Object? expiryDate = freezed,
    Object? previousCategory = freezed,
  }) {
    return _then(_self.copyWith(
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDate: freezed == expiryDate
          ? _self.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String?,
      previousCategory: freezed == previousCategory
          ? _self.previousCategory
          : previousCategory // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntLicenseDetail].
extension RuntLicenseDetailPatterns on RuntLicenseDetail {
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
    TResult Function(_RuntLicenseDetail value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntLicenseDetail() when $default != null:
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
    TResult Function(_RuntLicenseDetail value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntLicenseDetail():
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
    TResult? Function(_RuntLicenseDetail value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntLicenseDetail() when $default != null:
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
            @JsonKey(name: 'categoria') String? category,
            @JsonKey(name: 'fecha_expedicion') String? issueDate,
            @JsonKey(name: 'fecha_vencimiento') String? expiryDate,
            @JsonKey(name: 'categoria_antigua') String? previousCategory)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntLicenseDetail() when $default != null:
        return $default(_that.category, _that.issueDate, _that.expiryDate,
            _that.previousCategory);
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
            @JsonKey(name: 'categoria') String? category,
            @JsonKey(name: 'fecha_expedicion') String? issueDate,
            @JsonKey(name: 'fecha_vencimiento') String? expiryDate,
            @JsonKey(name: 'categoria_antigua') String? previousCategory)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntLicenseDetail():
        return $default(_that.category, _that.issueDate, _that.expiryDate,
            _that.previousCategory);
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
            @JsonKey(name: 'categoria') String? category,
            @JsonKey(name: 'fecha_expedicion') String? issueDate,
            @JsonKey(name: 'fecha_vencimiento') String? expiryDate,
            @JsonKey(name: 'categoria_antigua') String? previousCategory)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntLicenseDetail() when $default != null:
        return $default(_that.category, _that.issueDate, _that.expiryDate,
            _that.previousCategory);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntLicenseDetail implements RuntLicenseDetail {
  const _RuntLicenseDetail(
      {@JsonKey(name: 'categoria') this.category,
      @JsonKey(name: 'fecha_expedicion') this.issueDate,
      @JsonKey(name: 'fecha_vencimiento') this.expiryDate,
      @JsonKey(name: 'categoria_antigua') this.previousCategory});
  factory _RuntLicenseDetail.fromJson(Map<String, dynamic> json) =>
      _$RuntLicenseDetailFromJson(json);

  /// Categoría de la licencia: "A1", "A2", "B1", "B2", "C1", etc.
  @override
  @JsonKey(name: 'categoria')
  final String? category;

  /// Fecha de expedición de esta categoría (formato dd/MM/yyyy)
  @override
  @JsonKey(name: 'fecha_expedicion')
  final String? issueDate;

  /// Fecha de vencimiento de esta categoría (formato dd/MM/yyyy)
  @override
  @JsonKey(name: 'fecha_vencimiento')
  final String? expiryDate;

  /// Categoría antigua (antes del cambio normativo), si aplica
  @override
  @JsonKey(name: 'categoria_antigua')
  final String? previousCategory;

  /// Create a copy of RuntLicenseDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntLicenseDetailCopyWith<_RuntLicenseDetail> get copyWith =>
      __$RuntLicenseDetailCopyWithImpl<_RuntLicenseDetail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntLicenseDetailToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntLicenseDetail &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.previousCategory, previousCategory) ||
                other.previousCategory == previousCategory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, category, issueDate, expiryDate, previousCategory);

  @override
  String toString() {
    return 'RuntLicenseDetail(category: $category, issueDate: $issueDate, expiryDate: $expiryDate, previousCategory: $previousCategory)';
  }
}

/// @nodoc
abstract mixin class _$RuntLicenseDetailCopyWith<$Res>
    implements $RuntLicenseDetailCopyWith<$Res> {
  factory _$RuntLicenseDetailCopyWith(
          _RuntLicenseDetail value, $Res Function(_RuntLicenseDetail) _then) =
      __$RuntLicenseDetailCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'categoria') String? category,
      @JsonKey(name: 'fecha_expedicion') String? issueDate,
      @JsonKey(name: 'fecha_vencimiento') String? expiryDate,
      @JsonKey(name: 'categoria_antigua') String? previousCategory});
}

/// @nodoc
class __$RuntLicenseDetailCopyWithImpl<$Res>
    implements _$RuntLicenseDetailCopyWith<$Res> {
  __$RuntLicenseDetailCopyWithImpl(this._self, this._then);

  final _RuntLicenseDetail _self;
  final $Res Function(_RuntLicenseDetail) _then;

  /// Create a copy of RuntLicenseDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? category = freezed,
    Object? issueDate = freezed,
    Object? expiryDate = freezed,
    Object? previousCategory = freezed,
  }) {
    return _then(_RuntLicenseDetail(
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDate: freezed == expiryDate
          ? _self.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String?,
      previousCategory: freezed == previousCategory
          ? _self.previousCategory
          : previousCategory // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
