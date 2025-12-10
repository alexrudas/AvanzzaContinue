// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'simit_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SimitResponse {
  bool get ok;
  String get source;
  SimitData get data;
  SimitMeta? get meta;

  /// Create a copy of SimitResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimitResponseCopyWith<SimitResponse> get copyWith =>
      _$SimitResponseCopyWithImpl<SimitResponse>(
          this as SimitResponse, _$identity);

  /// Serializes this SimitResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimitResponse &&
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
    return 'SimitResponse(ok: $ok, source: $source, data: $data, meta: $meta)';
  }
}

/// @nodoc
abstract mixin class $SimitResponseCopyWith<$Res> {
  factory $SimitResponseCopyWith(
          SimitResponse value, $Res Function(SimitResponse) _then) =
      _$SimitResponseCopyWithImpl;
  @useResult
  $Res call({bool ok, String source, SimitData data, SimitMeta? meta});

  $SimitDataCopyWith<$Res> get data;
  $SimitMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class _$SimitResponseCopyWithImpl<$Res>
    implements $SimitResponseCopyWith<$Res> {
  _$SimitResponseCopyWithImpl(this._self, this._then);

  final SimitResponse _self;
  final $Res Function(SimitResponse) _then;

  /// Create a copy of SimitResponse
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
              as SimitData,
      meta: freezed == meta
          ? _self.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as SimitMeta?,
    ));
  }

  /// Create a copy of SimitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitDataCopyWith<$Res> get data {
    return $SimitDataCopyWith<$Res>(_self.data, (value) {
      return _then(_self.copyWith(data: value));
    });
  }

  /// Create a copy of SimitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
      return null;
    }

    return $SimitMetaCopyWith<$Res>(_self.meta!, (value) {
      return _then(_self.copyWith(meta: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SimitResponse].
extension SimitResponsePatterns on SimitResponse {
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
    TResult Function(_SimitResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitResponse() when $default != null:
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
    TResult Function(_SimitResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitResponse():
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
    TResult? Function(_SimitResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitResponse() when $default != null:
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
    TResult Function(bool ok, String source, SimitData data, SimitMeta? meta)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitResponse() when $default != null:
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
    TResult Function(bool ok, String source, SimitData data, SimitMeta? meta)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitResponse():
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
    TResult? Function(bool ok, String source, SimitData data, SimitMeta? meta)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitResponse() when $default != null:
        return $default(_that.ok, _that.source, _that.data, _that.meta);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimitResponse implements SimitResponse {
  const _SimitResponse(
      {required this.ok, required this.source, required this.data, this.meta});
  factory _SimitResponse.fromJson(Map<String, dynamic> json) =>
      _$SimitResponseFromJson(json);

  @override
  final bool ok;
  @override
  final String source;
  @override
  final SimitData data;
  @override
  final SimitMeta? meta;

  /// Create a copy of SimitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimitResponseCopyWith<_SimitResponse> get copyWith =>
      __$SimitResponseCopyWithImpl<_SimitResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimitResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimitResponse &&
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
    return 'SimitResponse(ok: $ok, source: $source, data: $data, meta: $meta)';
  }
}

/// @nodoc
abstract mixin class _$SimitResponseCopyWith<$Res>
    implements $SimitResponseCopyWith<$Res> {
  factory _$SimitResponseCopyWith(
          _SimitResponse value, $Res Function(_SimitResponse) _then) =
      __$SimitResponseCopyWithImpl;
  @override
  @useResult
  $Res call({bool ok, String source, SimitData data, SimitMeta? meta});

  @override
  $SimitDataCopyWith<$Res> get data;
  @override
  $SimitMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class __$SimitResponseCopyWithImpl<$Res>
    implements _$SimitResponseCopyWith<$Res> {
  __$SimitResponseCopyWithImpl(this._self, this._then);

  final _SimitResponse _self;
  final $Res Function(_SimitResponse) _then;

  /// Create a copy of SimitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ok = null,
    Object? source = null,
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_SimitResponse(
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
              as SimitData,
      meta: freezed == meta
          ? _self.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as SimitMeta?,
    ));
  }

  /// Create a copy of SimitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitDataCopyWith<$Res> get data {
    return $SimitDataCopyWith<$Res>(_self.data, (value) {
      return _then(_self.copyWith(data: value));
    });
  }

  /// Create a copy of SimitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
      return null;
    }

    return $SimitMetaCopyWith<$Res>(_self.meta!, (value) {
      return _then(_self.copyWith(meta: value));
    });
  }
}

/// @nodoc
mixin _$SimitMeta {
  /// Timestamp ISO de cuando se realizó el fetch
  DateTime? get fetchedAt;

  /// Estrategia de scraping: "puppeteer"
  String? get strategy;

  /// Si se ejecutó en modo headless (sin GUI)
  bool? get headless;

  /// ID único del request para trazabilidad
  String? get requestId;

  /// Duración total de la operación en milisegundos
  int? get durationMs;

  /// Create a copy of SimitMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimitMetaCopyWith<SimitMeta> get copyWith =>
      _$SimitMetaCopyWithImpl<SimitMeta>(this as SimitMeta, _$identity);

  /// Serializes this SimitMeta to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimitMeta &&
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
    return 'SimitMeta(fetchedAt: $fetchedAt, strategy: $strategy, headless: $headless, requestId: $requestId, durationMs: $durationMs)';
  }
}

/// @nodoc
abstract mixin class $SimitMetaCopyWith<$Res> {
  factory $SimitMetaCopyWith(SimitMeta value, $Res Function(SimitMeta) _then) =
      _$SimitMetaCopyWithImpl;
  @useResult
  $Res call(
      {DateTime? fetchedAt,
      String? strategy,
      bool? headless,
      String? requestId,
      int? durationMs});
}

/// @nodoc
class _$SimitMetaCopyWithImpl<$Res> implements $SimitMetaCopyWith<$Res> {
  _$SimitMetaCopyWithImpl(this._self, this._then);

  final SimitMeta _self;
  final $Res Function(SimitMeta) _then;

  /// Create a copy of SimitMeta
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

/// Adds pattern-matching-related methods to [SimitMeta].
extension SimitMetaPatterns on SimitMeta {
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
    TResult Function(_SimitMeta value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitMeta() when $default != null:
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
    TResult Function(_SimitMeta value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitMeta():
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
    TResult? Function(_SimitMeta value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitMeta() when $default != null:
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
      case _SimitMeta() when $default != null:
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
      case _SimitMeta():
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
      case _SimitMeta() when $default != null:
        return $default(_that.fetchedAt, _that.strategy, _that.headless,
            _that.requestId, _that.durationMs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimitMeta implements SimitMeta {
  const _SimitMeta(
      {this.fetchedAt,
      this.strategy,
      this.headless,
      this.requestId,
      this.durationMs});
  factory _SimitMeta.fromJson(Map<String, dynamic> json) =>
      _$SimitMetaFromJson(json);

  /// Timestamp ISO de cuando se realizó el fetch
  @override
  final DateTime? fetchedAt;

  /// Estrategia de scraping: "puppeteer"
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

  /// Create a copy of SimitMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimitMetaCopyWith<_SimitMeta> get copyWith =>
      __$SimitMetaCopyWithImpl<_SimitMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimitMetaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimitMeta &&
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
    return 'SimitMeta(fetchedAt: $fetchedAt, strategy: $strategy, headless: $headless, requestId: $requestId, durationMs: $durationMs)';
  }
}

/// @nodoc
abstract mixin class _$SimitMetaCopyWith<$Res>
    implements $SimitMetaCopyWith<$Res> {
  factory _$SimitMetaCopyWith(
          _SimitMeta value, $Res Function(_SimitMeta) _then) =
      __$SimitMetaCopyWithImpl;
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
class __$SimitMetaCopyWithImpl<$Res> implements _$SimitMetaCopyWith<$Res> {
  __$SimitMetaCopyWithImpl(this._self, this._then);

  final _SimitMeta _self;
  final $Res Function(_SimitMeta) _then;

  /// Create a copy of SimitMeta
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
    return _then(_SimitMeta(
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
mixin _$SimitData {
  /// Indica si la persona tiene multas registradas (REQUIRED)
  @JsonKey(name: 'tieneMultas')
  bool get hasFines;

  /// Monto total de todas las multas en pesos colombianos (REQUIRED)
  num get total;

  /// Resumen ejecutivo de multas y comparendos (REQUIRED)
  @JsonKey(name: 'resumen')
  SimitSummary get summary;

  /// Lista detallada de todas las multas
  @JsonKey(name: 'multas')
  List<SimitFine> get fines;

  /// Create a copy of SimitData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimitDataCopyWith<SimitData> get copyWith =>
      _$SimitDataCopyWithImpl<SimitData>(this as SimitData, _$identity);

  /// Serializes this SimitData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimitData &&
            (identical(other.hasFines, hasFines) ||
                other.hasFines == hasFines) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other.fines, fines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hasFines, total, summary,
      const DeepCollectionEquality().hash(fines));

  @override
  String toString() {
    return 'SimitData(hasFines: $hasFines, total: $total, summary: $summary, fines: $fines)';
  }
}

/// @nodoc
abstract mixin class $SimitDataCopyWith<$Res> {
  factory $SimitDataCopyWith(SimitData value, $Res Function(SimitData) _then) =
      _$SimitDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'tieneMultas') bool hasFines,
      num total,
      @JsonKey(name: 'resumen') SimitSummary summary,
      @JsonKey(name: 'multas') List<SimitFine> fines});

  $SimitSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$SimitDataCopyWithImpl<$Res> implements $SimitDataCopyWith<$Res> {
  _$SimitDataCopyWithImpl(this._self, this._then);

  final SimitData _self;
  final $Res Function(SimitData) _then;

  /// Create a copy of SimitData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasFines = null,
    Object? total = null,
    Object? summary = null,
    Object? fines = null,
  }) {
    return _then(_self.copyWith(
      hasFines: null == hasFines
          ? _self.hasFines
          : hasFines // ignore: cast_nullable_to_non_nullable
              as bool,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as num,
      summary: null == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as SimitSummary,
      fines: null == fines
          ? _self.fines
          : fines // ignore: cast_nullable_to_non_nullable
              as List<SimitFine>,
    ));
  }

  /// Create a copy of SimitData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitSummaryCopyWith<$Res> get summary {
    return $SimitSummaryCopyWith<$Res>(_self.summary, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SimitData].
extension SimitDataPatterns on SimitData {
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
    TResult Function(_SimitData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitData() when $default != null:
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
    TResult Function(_SimitData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitData():
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
    TResult? Function(_SimitData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitData() when $default != null:
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
            @JsonKey(name: 'tieneMultas') bool hasFines,
            num total,
            @JsonKey(name: 'resumen') SimitSummary summary,
            @JsonKey(name: 'multas') List<SimitFine> fines)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitData() when $default != null:
        return $default(
            _that.hasFines, _that.total, _that.summary, _that.fines);
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
            @JsonKey(name: 'tieneMultas') bool hasFines,
            num total,
            @JsonKey(name: 'resumen') SimitSummary summary,
            @JsonKey(name: 'multas') List<SimitFine> fines)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitData():
        return $default(
            _that.hasFines, _that.total, _that.summary, _that.fines);
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
            @JsonKey(name: 'tieneMultas') bool hasFines,
            num total,
            @JsonKey(name: 'resumen') SimitSummary summary,
            @JsonKey(name: 'multas') List<SimitFine> fines)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitData() when $default != null:
        return $default(
            _that.hasFines, _that.total, _that.summary, _that.fines);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimitData implements SimitData {
  const _SimitData(
      {@JsonKey(name: 'tieneMultas') required this.hasFines,
      required this.total,
      @JsonKey(name: 'resumen') required this.summary,
      @JsonKey(name: 'multas') final List<SimitFine> fines = const []})
      : _fines = fines;
  factory _SimitData.fromJson(Map<String, dynamic> json) =>
      _$SimitDataFromJson(json);

  /// Indica si la persona tiene multas registradas (REQUIRED)
  @override
  @JsonKey(name: 'tieneMultas')
  final bool hasFines;

  /// Monto total de todas las multas en pesos colombianos (REQUIRED)
  @override
  final num total;

  /// Resumen ejecutivo de multas y comparendos (REQUIRED)
  @override
  @JsonKey(name: 'resumen')
  final SimitSummary summary;

  /// Lista detallada de todas las multas
  final List<SimitFine> _fines;

  /// Lista detallada de todas las multas
  @override
  @JsonKey(name: 'multas')
  List<SimitFine> get fines {
    if (_fines is EqualUnmodifiableListView) return _fines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fines);
  }

  /// Create a copy of SimitData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimitDataCopyWith<_SimitData> get copyWith =>
      __$SimitDataCopyWithImpl<_SimitData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimitDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimitData &&
            (identical(other.hasFines, hasFines) ||
                other.hasFines == hasFines) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._fines, _fines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hasFines, total, summary,
      const DeepCollectionEquality().hash(_fines));

  @override
  String toString() {
    return 'SimitData(hasFines: $hasFines, total: $total, summary: $summary, fines: $fines)';
  }
}

/// @nodoc
abstract mixin class _$SimitDataCopyWith<$Res>
    implements $SimitDataCopyWith<$Res> {
  factory _$SimitDataCopyWith(
          _SimitData value, $Res Function(_SimitData) _then) =
      __$SimitDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'tieneMultas') bool hasFines,
      num total,
      @JsonKey(name: 'resumen') SimitSummary summary,
      @JsonKey(name: 'multas') List<SimitFine> fines});

  @override
  $SimitSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$SimitDataCopyWithImpl<$Res> implements _$SimitDataCopyWith<$Res> {
  __$SimitDataCopyWithImpl(this._self, this._then);

  final _SimitData _self;
  final $Res Function(_SimitData) _then;

  /// Create a copy of SimitData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? hasFines = null,
    Object? total = null,
    Object? summary = null,
    Object? fines = null,
  }) {
    return _then(_SimitData(
      hasFines: null == hasFines
          ? _self.hasFines
          : hasFines // ignore: cast_nullable_to_non_nullable
              as bool,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as num,
      summary: null == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as SimitSummary,
      fines: null == fines
          ? _self._fines
          : fines // ignore: cast_nullable_to_non_nullable
              as List<SimitFine>,
    ));
  }

  /// Create a copy of SimitData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitSummaryCopyWith<$Res> get summary {
    return $SimitSummaryCopyWith<$Res>(_self.summary, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }
}

/// @nodoc
mixin _$SimitSummary {
  /// Cantidad de comparendos (REQUIRED)
  int get comparendos;

  /// Cantidad de multas (puede venir como String "3", parsear a int)
  /// Usa MultasCountConverter para parsing defensivo
  @MultasCountConverter()
  int get multas;

  /// Cantidad de acuerdos de pago activos (REQUIRED)
  @JsonKey(name: 'acuerdosDePago')
  int get paymentAgreementsCount;

  /// Total formateado con símbolo de pesos: "$ 3.227.005"
  @JsonKey(name: 'totalFormateado')
  String? get formattedTotal;

  /// Nombre parcialmente enmascarado: "VIC*** ANT****"
  @JsonKey(name: 'nombre')
  String? get maskedName;

  /// Número de cédula (REQUIRED)
  @JsonKey(name: 'cedula')
  String get document;

  /// Create a copy of SimitSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimitSummaryCopyWith<SimitSummary> get copyWith =>
      _$SimitSummaryCopyWithImpl<SimitSummary>(
          this as SimitSummary, _$identity);

  /// Serializes this SimitSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimitSummary &&
            (identical(other.comparendos, comparendos) ||
                other.comparendos == comparendos) &&
            (identical(other.multas, multas) || other.multas == multas) &&
            (identical(other.paymentAgreementsCount, paymentAgreementsCount) ||
                other.paymentAgreementsCount == paymentAgreementsCount) &&
            (identical(other.formattedTotal, formattedTotal) ||
                other.formattedTotal == formattedTotal) &&
            (identical(other.maskedName, maskedName) ||
                other.maskedName == maskedName) &&
            (identical(other.document, document) ||
                other.document == document));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, comparendos, multas,
      paymentAgreementsCount, formattedTotal, maskedName, document);

  @override
  String toString() {
    return 'SimitSummary(comparendos: $comparendos, multas: $multas, paymentAgreementsCount: $paymentAgreementsCount, formattedTotal: $formattedTotal, maskedName: $maskedName, document: $document)';
  }
}

/// @nodoc
abstract mixin class $SimitSummaryCopyWith<$Res> {
  factory $SimitSummaryCopyWith(
          SimitSummary value, $Res Function(SimitSummary) _then) =
      _$SimitSummaryCopyWithImpl;
  @useResult
  $Res call(
      {int comparendos,
      @MultasCountConverter() int multas,
      @JsonKey(name: 'acuerdosDePago') int paymentAgreementsCount,
      @JsonKey(name: 'totalFormateado') String? formattedTotal,
      @JsonKey(name: 'nombre') String? maskedName,
      @JsonKey(name: 'cedula') String document});
}

/// @nodoc
class _$SimitSummaryCopyWithImpl<$Res> implements $SimitSummaryCopyWith<$Res> {
  _$SimitSummaryCopyWithImpl(this._self, this._then);

  final SimitSummary _self;
  final $Res Function(SimitSummary) _then;

  /// Create a copy of SimitSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comparendos = null,
    Object? multas = null,
    Object? paymentAgreementsCount = null,
    Object? formattedTotal = freezed,
    Object? maskedName = freezed,
    Object? document = null,
  }) {
    return _then(_self.copyWith(
      comparendos: null == comparendos
          ? _self.comparendos
          : comparendos // ignore: cast_nullable_to_non_nullable
              as int,
      multas: null == multas
          ? _self.multas
          : multas // ignore: cast_nullable_to_non_nullable
              as int,
      paymentAgreementsCount: null == paymentAgreementsCount
          ? _self.paymentAgreementsCount
          : paymentAgreementsCount // ignore: cast_nullable_to_non_nullable
              as int,
      formattedTotal: freezed == formattedTotal
          ? _self.formattedTotal
          : formattedTotal // ignore: cast_nullable_to_non_nullable
              as String?,
      maskedName: freezed == maskedName
          ? _self.maskedName
          : maskedName // ignore: cast_nullable_to_non_nullable
              as String?,
      document: null == document
          ? _self.document
          : document // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [SimitSummary].
extension SimitSummaryPatterns on SimitSummary {
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
    TResult Function(_SimitSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitSummary() when $default != null:
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
    TResult Function(_SimitSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitSummary():
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
    TResult? Function(_SimitSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitSummary() when $default != null:
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
            int comparendos,
            @MultasCountConverter() int multas,
            @JsonKey(name: 'acuerdosDePago') int paymentAgreementsCount,
            @JsonKey(name: 'totalFormateado') String? formattedTotal,
            @JsonKey(name: 'nombre') String? maskedName,
            @JsonKey(name: 'cedula') String document)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitSummary() when $default != null:
        return $default(
            _that.comparendos,
            _that.multas,
            _that.paymentAgreementsCount,
            _that.formattedTotal,
            _that.maskedName,
            _that.document);
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
            int comparendos,
            @MultasCountConverter() int multas,
            @JsonKey(name: 'acuerdosDePago') int paymentAgreementsCount,
            @JsonKey(name: 'totalFormateado') String? formattedTotal,
            @JsonKey(name: 'nombre') String? maskedName,
            @JsonKey(name: 'cedula') String document)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitSummary():
        return $default(
            _that.comparendos,
            _that.multas,
            _that.paymentAgreementsCount,
            _that.formattedTotal,
            _that.maskedName,
            _that.document);
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
            int comparendos,
            @MultasCountConverter() int multas,
            @JsonKey(name: 'acuerdosDePago') int paymentAgreementsCount,
            @JsonKey(name: 'totalFormateado') String? formattedTotal,
            @JsonKey(name: 'nombre') String? maskedName,
            @JsonKey(name: 'cedula') String document)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitSummary() when $default != null:
        return $default(
            _that.comparendos,
            _that.multas,
            _that.paymentAgreementsCount,
            _that.formattedTotal,
            _that.maskedName,
            _that.document);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimitSummary implements SimitSummary {
  const _SimitSummary(
      {required this.comparendos,
      @MultasCountConverter() required this.multas,
      @JsonKey(name: 'acuerdosDePago') required this.paymentAgreementsCount,
      @JsonKey(name: 'totalFormateado') this.formattedTotal,
      @JsonKey(name: 'nombre') this.maskedName,
      @JsonKey(name: 'cedula') required this.document});
  factory _SimitSummary.fromJson(Map<String, dynamic> json) =>
      _$SimitSummaryFromJson(json);

  /// Cantidad de comparendos (REQUIRED)
  @override
  final int comparendos;

  /// Cantidad de multas (puede venir como String "3", parsear a int)
  /// Usa MultasCountConverter para parsing defensivo
  @override
  @MultasCountConverter()
  final int multas;

  /// Cantidad de acuerdos de pago activos (REQUIRED)
  @override
  @JsonKey(name: 'acuerdosDePago')
  final int paymentAgreementsCount;

  /// Total formateado con símbolo de pesos: "$ 3.227.005"
  @override
  @JsonKey(name: 'totalFormateado')
  final String? formattedTotal;

  /// Nombre parcialmente enmascarado: "VIC*** ANT****"
  @override
  @JsonKey(name: 'nombre')
  final String? maskedName;

  /// Número de cédula (REQUIRED)
  @override
  @JsonKey(name: 'cedula')
  final String document;

  /// Create a copy of SimitSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimitSummaryCopyWith<_SimitSummary> get copyWith =>
      __$SimitSummaryCopyWithImpl<_SimitSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimitSummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimitSummary &&
            (identical(other.comparendos, comparendos) ||
                other.comparendos == comparendos) &&
            (identical(other.multas, multas) || other.multas == multas) &&
            (identical(other.paymentAgreementsCount, paymentAgreementsCount) ||
                other.paymentAgreementsCount == paymentAgreementsCount) &&
            (identical(other.formattedTotal, formattedTotal) ||
                other.formattedTotal == formattedTotal) &&
            (identical(other.maskedName, maskedName) ||
                other.maskedName == maskedName) &&
            (identical(other.document, document) ||
                other.document == document));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, comparendos, multas,
      paymentAgreementsCount, formattedTotal, maskedName, document);

  @override
  String toString() {
    return 'SimitSummary(comparendos: $comparendos, multas: $multas, paymentAgreementsCount: $paymentAgreementsCount, formattedTotal: $formattedTotal, maskedName: $maskedName, document: $document)';
  }
}

/// @nodoc
abstract mixin class _$SimitSummaryCopyWith<$Res>
    implements $SimitSummaryCopyWith<$Res> {
  factory _$SimitSummaryCopyWith(
          _SimitSummary value, $Res Function(_SimitSummary) _then) =
      __$SimitSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int comparendos,
      @MultasCountConverter() int multas,
      @JsonKey(name: 'acuerdosDePago') int paymentAgreementsCount,
      @JsonKey(name: 'totalFormateado') String? formattedTotal,
      @JsonKey(name: 'nombre') String? maskedName,
      @JsonKey(name: 'cedula') String document});
}

/// @nodoc
class __$SimitSummaryCopyWithImpl<$Res>
    implements _$SimitSummaryCopyWith<$Res> {
  __$SimitSummaryCopyWithImpl(this._self, this._then);

  final _SimitSummary _self;
  final $Res Function(_SimitSummary) _then;

  /// Create a copy of SimitSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? comparendos = null,
    Object? multas = null,
    Object? paymentAgreementsCount = null,
    Object? formattedTotal = freezed,
    Object? maskedName = freezed,
    Object? document = null,
  }) {
    return _then(_SimitSummary(
      comparendos: null == comparendos
          ? _self.comparendos
          : comparendos // ignore: cast_nullable_to_non_nullable
              as int,
      multas: null == multas
          ? _self.multas
          : multas // ignore: cast_nullable_to_non_nullable
              as int,
      paymentAgreementsCount: null == paymentAgreementsCount
          ? _self.paymentAgreementsCount
          : paymentAgreementsCount // ignore: cast_nullable_to_non_nullable
              as int,
      formattedTotal: freezed == formattedTotal
          ? _self.formattedTotal
          : formattedTotal // ignore: cast_nullable_to_non_nullable
              as String?,
      maskedName: freezed == maskedName
          ? _self.maskedName
          : maskedName // ignore: cast_nullable_to_non_nullable
              as String?,
      document: null == document
          ? _self.document
          : document // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$SimitFine {
  /// ID único de la multa (REQUIRED)
  String get id;

  /// Fecha de la multa (formato dd/MM/yyyy)
  String? get fecha;

  /// Ciudad donde se impuso la multa
  String? get ciudad;

  /// Valor original de la multa en pesos
  int? get valor;

  /// Valor a pagar actualizado (incluye intereses/descuentos) (REQUIRED)
  @JsonKey(name: 'valorAPagar')
  num get amountToPay;

  /// Estado actual: "Cobro coactivo", "Pendiente de pago", etc. (REQUIRED)
  String get estado;

  /// Placa del vehículo involucrado (REQUIRED)
  String get placa;

  /// Código corto de infracción: "D02...", "C24...", etc.
  @JsonKey(name: 'infraccion')
  String? get infractionCodeShort;

  /// Detalle completo del comparendo (nullable para degradación elegante)
  SimitFineDetail? get detalle;

  /// Create a copy of SimitFine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimitFineCopyWith<SimitFine> get copyWith =>
      _$SimitFineCopyWithImpl<SimitFine>(this as SimitFine, _$identity);

  /// Serializes this SimitFine to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimitFine &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.ciudad, ciudad) || other.ciudad == ciudad) &&
            (identical(other.valor, valor) || other.valor == valor) &&
            (identical(other.amountToPay, amountToPay) ||
                other.amountToPay == amountToPay) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.placa, placa) || other.placa == placa) &&
            (identical(other.infractionCodeShort, infractionCodeShort) ||
                other.infractionCodeShort == infractionCodeShort) &&
            (identical(other.detalle, detalle) || other.detalle == detalle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, fecha, ciudad, valor,
      amountToPay, estado, placa, infractionCodeShort, detalle);

  @override
  String toString() {
    return 'SimitFine(id: $id, fecha: $fecha, ciudad: $ciudad, valor: $valor, amountToPay: $amountToPay, estado: $estado, placa: $placa, infractionCodeShort: $infractionCodeShort, detalle: $detalle)';
  }
}

/// @nodoc
abstract mixin class $SimitFineCopyWith<$Res> {
  factory $SimitFineCopyWith(SimitFine value, $Res Function(SimitFine) _then) =
      _$SimitFineCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? fecha,
      String? ciudad,
      int? valor,
      @JsonKey(name: 'valorAPagar') num amountToPay,
      String estado,
      String placa,
      @JsonKey(name: 'infraccion') String? infractionCodeShort,
      SimitFineDetail? detalle});

  $SimitFineDetailCopyWith<$Res>? get detalle;
}

/// @nodoc
class _$SimitFineCopyWithImpl<$Res> implements $SimitFineCopyWith<$Res> {
  _$SimitFineCopyWithImpl(this._self, this._then);

  final SimitFine _self;
  final $Res Function(SimitFine) _then;

  /// Create a copy of SimitFine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = freezed,
    Object? ciudad = freezed,
    Object? valor = freezed,
    Object? amountToPay = null,
    Object? estado = null,
    Object? placa = null,
    Object? infractionCodeShort = freezed,
    Object? detalle = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fecha: freezed == fecha
          ? _self.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as String?,
      ciudad: freezed == ciudad
          ? _self.ciudad
          : ciudad // ignore: cast_nullable_to_non_nullable
              as String?,
      valor: freezed == valor
          ? _self.valor
          : valor // ignore: cast_nullable_to_non_nullable
              as int?,
      amountToPay: null == amountToPay
          ? _self.amountToPay
          : amountToPay // ignore: cast_nullable_to_non_nullable
              as num,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      placa: null == placa
          ? _self.placa
          : placa // ignore: cast_nullable_to_non_nullable
              as String,
      infractionCodeShort: freezed == infractionCodeShort
          ? _self.infractionCodeShort
          : infractionCodeShort // ignore: cast_nullable_to_non_nullable
              as String?,
      detalle: freezed == detalle
          ? _self.detalle
          : detalle // ignore: cast_nullable_to_non_nullable
              as SimitFineDetail?,
    ));
  }

  /// Create a copy of SimitFine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitFineDetailCopyWith<$Res>? get detalle {
    if (_self.detalle == null) {
      return null;
    }

    return $SimitFineDetailCopyWith<$Res>(_self.detalle!, (value) {
      return _then(_self.copyWith(detalle: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SimitFine].
extension SimitFinePatterns on SimitFine {
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
    TResult Function(_SimitFine value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitFine() when $default != null:
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
    TResult Function(_SimitFine value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitFine():
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
    TResult? Function(_SimitFine value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitFine() when $default != null:
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
            String? fecha,
            String? ciudad,
            int? valor,
            @JsonKey(name: 'valorAPagar') num amountToPay,
            String estado,
            String placa,
            @JsonKey(name: 'infraccion') String? infractionCodeShort,
            SimitFineDetail? detalle)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitFine() when $default != null:
        return $default(
            _that.id,
            _that.fecha,
            _that.ciudad,
            _that.valor,
            _that.amountToPay,
            _that.estado,
            _that.placa,
            _that.infractionCodeShort,
            _that.detalle);
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
            String? fecha,
            String? ciudad,
            int? valor,
            @JsonKey(name: 'valorAPagar') num amountToPay,
            String estado,
            String placa,
            @JsonKey(name: 'infraccion') String? infractionCodeShort,
            SimitFineDetail? detalle)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitFine():
        return $default(
            _that.id,
            _that.fecha,
            _that.ciudad,
            _that.valor,
            _that.amountToPay,
            _that.estado,
            _that.placa,
            _that.infractionCodeShort,
            _that.detalle);
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
            String? fecha,
            String? ciudad,
            int? valor,
            @JsonKey(name: 'valorAPagar') num amountToPay,
            String estado,
            String placa,
            @JsonKey(name: 'infraccion') String? infractionCodeShort,
            SimitFineDetail? detalle)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitFine() when $default != null:
        return $default(
            _that.id,
            _that.fecha,
            _that.ciudad,
            _that.valor,
            _that.amountToPay,
            _that.estado,
            _that.placa,
            _that.infractionCodeShort,
            _that.detalle);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimitFine implements SimitFine {
  const _SimitFine(
      {required this.id,
      this.fecha,
      this.ciudad,
      this.valor,
      @JsonKey(name: 'valorAPagar') required this.amountToPay,
      required this.estado,
      required this.placa,
      @JsonKey(name: 'infraccion') this.infractionCodeShort,
      this.detalle});
  factory _SimitFine.fromJson(Map<String, dynamic> json) =>
      _$SimitFineFromJson(json);

  /// ID único de la multa (REQUIRED)
  @override
  final String id;

  /// Fecha de la multa (formato dd/MM/yyyy)
  @override
  final String? fecha;

  /// Ciudad donde se impuso la multa
  @override
  final String? ciudad;

  /// Valor original de la multa en pesos
  @override
  final int? valor;

  /// Valor a pagar actualizado (incluye intereses/descuentos) (REQUIRED)
  @override
  @JsonKey(name: 'valorAPagar')
  final num amountToPay;

  /// Estado actual: "Cobro coactivo", "Pendiente de pago", etc. (REQUIRED)
  @override
  final String estado;

  /// Placa del vehículo involucrado (REQUIRED)
  @override
  final String placa;

  /// Código corto de infracción: "D02...", "C24...", etc.
  @override
  @JsonKey(name: 'infraccion')
  final String? infractionCodeShort;

  /// Detalle completo del comparendo (nullable para degradación elegante)
  @override
  final SimitFineDetail? detalle;

  /// Create a copy of SimitFine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimitFineCopyWith<_SimitFine> get copyWith =>
      __$SimitFineCopyWithImpl<_SimitFine>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimitFineToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimitFine &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.ciudad, ciudad) || other.ciudad == ciudad) &&
            (identical(other.valor, valor) || other.valor == valor) &&
            (identical(other.amountToPay, amountToPay) ||
                other.amountToPay == amountToPay) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.placa, placa) || other.placa == placa) &&
            (identical(other.infractionCodeShort, infractionCodeShort) ||
                other.infractionCodeShort == infractionCodeShort) &&
            (identical(other.detalle, detalle) || other.detalle == detalle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, fecha, ciudad, valor,
      amountToPay, estado, placa, infractionCodeShort, detalle);

  @override
  String toString() {
    return 'SimitFine(id: $id, fecha: $fecha, ciudad: $ciudad, valor: $valor, amountToPay: $amountToPay, estado: $estado, placa: $placa, infractionCodeShort: $infractionCodeShort, detalle: $detalle)';
  }
}

/// @nodoc
abstract mixin class _$SimitFineCopyWith<$Res>
    implements $SimitFineCopyWith<$Res> {
  factory _$SimitFineCopyWith(
          _SimitFine value, $Res Function(_SimitFine) _then) =
      __$SimitFineCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? fecha,
      String? ciudad,
      int? valor,
      @JsonKey(name: 'valorAPagar') num amountToPay,
      String estado,
      String placa,
      @JsonKey(name: 'infraccion') String? infractionCodeShort,
      SimitFineDetail? detalle});

  @override
  $SimitFineDetailCopyWith<$Res>? get detalle;
}

/// @nodoc
class __$SimitFineCopyWithImpl<$Res> implements _$SimitFineCopyWith<$Res> {
  __$SimitFineCopyWithImpl(this._self, this._then);

  final _SimitFine _self;
  final $Res Function(_SimitFine) _then;

  /// Create a copy of SimitFine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? fecha = freezed,
    Object? ciudad = freezed,
    Object? valor = freezed,
    Object? amountToPay = null,
    Object? estado = null,
    Object? placa = null,
    Object? infractionCodeShort = freezed,
    Object? detalle = freezed,
  }) {
    return _then(_SimitFine(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fecha: freezed == fecha
          ? _self.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as String?,
      ciudad: freezed == ciudad
          ? _self.ciudad
          : ciudad // ignore: cast_nullable_to_non_nullable
              as String?,
      valor: freezed == valor
          ? _self.valor
          : valor // ignore: cast_nullable_to_non_nullable
              as int?,
      amountToPay: null == amountToPay
          ? _self.amountToPay
          : amountToPay // ignore: cast_nullable_to_non_nullable
              as num,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      placa: null == placa
          ? _self.placa
          : placa // ignore: cast_nullable_to_non_nullable
              as String,
      infractionCodeShort: freezed == infractionCodeShort
          ? _self.infractionCodeShort
          : infractionCodeShort // ignore: cast_nullable_to_non_nullable
              as String?,
      detalle: freezed == detalle
          ? _self.detalle
          : detalle // ignore: cast_nullable_to_non_nullable
              as SimitFineDetail?,
    ));
  }

  /// Create a copy of SimitFine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitFineDetailCopyWith<$Res>? get detalle {
    if (_self.detalle == null) {
      return null;
    }

    return $SimitFineDetailCopyWith<$Res>(_self.detalle!, (value) {
      return _then(_self.copyWith(detalle: value));
    });
  }
}

/// @nodoc
mixin _$SimitFineDetail {
  /// Información del comparendo
  @JsonKey(name: 'informacion_comparendo')
  SimitTicketInfo? get ticketInfo;

  /// Información de la infracción cometida
  @JsonKey(name: 'infraccion')
  SimitInfractionInfo? get infraction;

  /// Datos del conductor infractor
  @JsonKey(name: 'datos_conductor')
  SimitDriverInfo? get driver;

  /// Información del vehículo involucrado
  @JsonKey(name: 'informacion_vehiculo')
  SimitVehicleInfo? get vehicle;

  /// Información del servicio y licencia
  @JsonKey(name: 'servicio')
  SimitServiceInfo? get service;

  /// Información adicional del comparendo
  @JsonKey(name: 'informacion_adicional')
  SimitExtraInfo? get extraInfo;

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimitFineDetailCopyWith<SimitFineDetail> get copyWith =>
      _$SimitFineDetailCopyWithImpl<SimitFineDetail>(
          this as SimitFineDetail, _$identity);

  /// Serializes this SimitFineDetail to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimitFineDetail &&
            (identical(other.ticketInfo, ticketInfo) ||
                other.ticketInfo == ticketInfo) &&
            (identical(other.infraction, infraction) ||
                other.infraction == infraction) &&
            (identical(other.driver, driver) || other.driver == driver) &&
            (identical(other.vehicle, vehicle) || other.vehicle == vehicle) &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.extraInfo, extraInfo) ||
                other.extraInfo == extraInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, ticketInfo, infraction, driver, vehicle, service, extraInfo);

  @override
  String toString() {
    return 'SimitFineDetail(ticketInfo: $ticketInfo, infraction: $infraction, driver: $driver, vehicle: $vehicle, service: $service, extraInfo: $extraInfo)';
  }
}

/// @nodoc
abstract mixin class $SimitFineDetailCopyWith<$Res> {
  factory $SimitFineDetailCopyWith(
          SimitFineDetail value, $Res Function(SimitFineDetail) _then) =
      _$SimitFineDetailCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'informacion_comparendo') SimitTicketInfo? ticketInfo,
      @JsonKey(name: 'infraccion') SimitInfractionInfo? infraction,
      @JsonKey(name: 'datos_conductor') SimitDriverInfo? driver,
      @JsonKey(name: 'informacion_vehiculo') SimitVehicleInfo? vehicle,
      @JsonKey(name: 'servicio') SimitServiceInfo? service,
      @JsonKey(name: 'informacion_adicional') SimitExtraInfo? extraInfo});

  $SimitTicketInfoCopyWith<$Res>? get ticketInfo;
  $SimitInfractionInfoCopyWith<$Res>? get infraction;
  $SimitDriverInfoCopyWith<$Res>? get driver;
  $SimitVehicleInfoCopyWith<$Res>? get vehicle;
  $SimitServiceInfoCopyWith<$Res>? get service;
  $SimitExtraInfoCopyWith<$Res>? get extraInfo;
}

/// @nodoc
class _$SimitFineDetailCopyWithImpl<$Res>
    implements $SimitFineDetailCopyWith<$Res> {
  _$SimitFineDetailCopyWithImpl(this._self, this._then);

  final SimitFineDetail _self;
  final $Res Function(SimitFineDetail) _then;

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketInfo = freezed,
    Object? infraction = freezed,
    Object? driver = freezed,
    Object? vehicle = freezed,
    Object? service = freezed,
    Object? extraInfo = freezed,
  }) {
    return _then(_self.copyWith(
      ticketInfo: freezed == ticketInfo
          ? _self.ticketInfo
          : ticketInfo // ignore: cast_nullable_to_non_nullable
              as SimitTicketInfo?,
      infraction: freezed == infraction
          ? _self.infraction
          : infraction // ignore: cast_nullable_to_non_nullable
              as SimitInfractionInfo?,
      driver: freezed == driver
          ? _self.driver
          : driver // ignore: cast_nullable_to_non_nullable
              as SimitDriverInfo?,
      vehicle: freezed == vehicle
          ? _self.vehicle
          : vehicle // ignore: cast_nullable_to_non_nullable
              as SimitVehicleInfo?,
      service: freezed == service
          ? _self.service
          : service // ignore: cast_nullable_to_non_nullable
              as SimitServiceInfo?,
      extraInfo: freezed == extraInfo
          ? _self.extraInfo
          : extraInfo // ignore: cast_nullable_to_non_nullable
              as SimitExtraInfo?,
    ));
  }

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitTicketInfoCopyWith<$Res>? get ticketInfo {
    if (_self.ticketInfo == null) {
      return null;
    }

    return $SimitTicketInfoCopyWith<$Res>(_self.ticketInfo!, (value) {
      return _then(_self.copyWith(ticketInfo: value));
    });
  }

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitInfractionInfoCopyWith<$Res>? get infraction {
    if (_self.infraction == null) {
      return null;
    }

    return $SimitInfractionInfoCopyWith<$Res>(_self.infraction!, (value) {
      return _then(_self.copyWith(infraction: value));
    });
  }

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitDriverInfoCopyWith<$Res>? get driver {
    if (_self.driver == null) {
      return null;
    }

    return $SimitDriverInfoCopyWith<$Res>(_self.driver!, (value) {
      return _then(_self.copyWith(driver: value));
    });
  }

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitVehicleInfoCopyWith<$Res>? get vehicle {
    if (_self.vehicle == null) {
      return null;
    }

    return $SimitVehicleInfoCopyWith<$Res>(_self.vehicle!, (value) {
      return _then(_self.copyWith(vehicle: value));
    });
  }

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitServiceInfoCopyWith<$Res>? get service {
    if (_self.service == null) {
      return null;
    }

    return $SimitServiceInfoCopyWith<$Res>(_self.service!, (value) {
      return _then(_self.copyWith(service: value));
    });
  }

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitExtraInfoCopyWith<$Res>? get extraInfo {
    if (_self.extraInfo == null) {
      return null;
    }

    return $SimitExtraInfoCopyWith<$Res>(_self.extraInfo!, (value) {
      return _then(_self.copyWith(extraInfo: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SimitFineDetail].
extension SimitFineDetailPatterns on SimitFineDetail {
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
    TResult Function(_SimitFineDetail value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitFineDetail() when $default != null:
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
    TResult Function(_SimitFineDetail value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitFineDetail():
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
    TResult? Function(_SimitFineDetail value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitFineDetail() when $default != null:
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
            @JsonKey(name: 'informacion_comparendo')
            SimitTicketInfo? ticketInfo,
            @JsonKey(name: 'infraccion') SimitInfractionInfo? infraction,
            @JsonKey(name: 'datos_conductor') SimitDriverInfo? driver,
            @JsonKey(name: 'informacion_vehiculo') SimitVehicleInfo? vehicle,
            @JsonKey(name: 'servicio') SimitServiceInfo? service,
            @JsonKey(name: 'informacion_adicional') SimitExtraInfo? extraInfo)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitFineDetail() when $default != null:
        return $default(_that.ticketInfo, _that.infraction, _that.driver,
            _that.vehicle, _that.service, _that.extraInfo);
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
            @JsonKey(name: 'informacion_comparendo')
            SimitTicketInfo? ticketInfo,
            @JsonKey(name: 'infraccion') SimitInfractionInfo? infraction,
            @JsonKey(name: 'datos_conductor') SimitDriverInfo? driver,
            @JsonKey(name: 'informacion_vehiculo') SimitVehicleInfo? vehicle,
            @JsonKey(name: 'servicio') SimitServiceInfo? service,
            @JsonKey(name: 'informacion_adicional') SimitExtraInfo? extraInfo)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitFineDetail():
        return $default(_that.ticketInfo, _that.infraction, _that.driver,
            _that.vehicle, _that.service, _that.extraInfo);
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
            @JsonKey(name: 'informacion_comparendo')
            SimitTicketInfo? ticketInfo,
            @JsonKey(name: 'infraccion') SimitInfractionInfo? infraction,
            @JsonKey(name: 'datos_conductor') SimitDriverInfo? driver,
            @JsonKey(name: 'informacion_vehiculo') SimitVehicleInfo? vehicle,
            @JsonKey(name: 'servicio') SimitServiceInfo? service,
            @JsonKey(name: 'informacion_adicional') SimitExtraInfo? extraInfo)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitFineDetail() when $default != null:
        return $default(_that.ticketInfo, _that.infraction, _that.driver,
            _that.vehicle, _that.service, _that.extraInfo);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimitFineDetail implements SimitFineDetail {
  const _SimitFineDetail(
      {@JsonKey(name: 'informacion_comparendo') this.ticketInfo,
      @JsonKey(name: 'infraccion') this.infraction,
      @JsonKey(name: 'datos_conductor') this.driver,
      @JsonKey(name: 'informacion_vehiculo') this.vehicle,
      @JsonKey(name: 'servicio') this.service,
      @JsonKey(name: 'informacion_adicional') this.extraInfo});
  factory _SimitFineDetail.fromJson(Map<String, dynamic> json) =>
      _$SimitFineDetailFromJson(json);

  /// Información del comparendo
  @override
  @JsonKey(name: 'informacion_comparendo')
  final SimitTicketInfo? ticketInfo;

  /// Información de la infracción cometida
  @override
  @JsonKey(name: 'infraccion')
  final SimitInfractionInfo? infraction;

  /// Datos del conductor infractor
  @override
  @JsonKey(name: 'datos_conductor')
  final SimitDriverInfo? driver;

  /// Información del vehículo involucrado
  @override
  @JsonKey(name: 'informacion_vehiculo')
  final SimitVehicleInfo? vehicle;

  /// Información del servicio y licencia
  @override
  @JsonKey(name: 'servicio')
  final SimitServiceInfo? service;

  /// Información adicional del comparendo
  @override
  @JsonKey(name: 'informacion_adicional')
  final SimitExtraInfo? extraInfo;

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimitFineDetailCopyWith<_SimitFineDetail> get copyWith =>
      __$SimitFineDetailCopyWithImpl<_SimitFineDetail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimitFineDetailToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimitFineDetail &&
            (identical(other.ticketInfo, ticketInfo) ||
                other.ticketInfo == ticketInfo) &&
            (identical(other.infraction, infraction) ||
                other.infraction == infraction) &&
            (identical(other.driver, driver) || other.driver == driver) &&
            (identical(other.vehicle, vehicle) || other.vehicle == vehicle) &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.extraInfo, extraInfo) ||
                other.extraInfo == extraInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, ticketInfo, infraction, driver, vehicle, service, extraInfo);

  @override
  String toString() {
    return 'SimitFineDetail(ticketInfo: $ticketInfo, infraction: $infraction, driver: $driver, vehicle: $vehicle, service: $service, extraInfo: $extraInfo)';
  }
}

/// @nodoc
abstract mixin class _$SimitFineDetailCopyWith<$Res>
    implements $SimitFineDetailCopyWith<$Res> {
  factory _$SimitFineDetailCopyWith(
          _SimitFineDetail value, $Res Function(_SimitFineDetail) _then) =
      __$SimitFineDetailCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'informacion_comparendo') SimitTicketInfo? ticketInfo,
      @JsonKey(name: 'infraccion') SimitInfractionInfo? infraction,
      @JsonKey(name: 'datos_conductor') SimitDriverInfo? driver,
      @JsonKey(name: 'informacion_vehiculo') SimitVehicleInfo? vehicle,
      @JsonKey(name: 'servicio') SimitServiceInfo? service,
      @JsonKey(name: 'informacion_adicional') SimitExtraInfo? extraInfo});

  @override
  $SimitTicketInfoCopyWith<$Res>? get ticketInfo;
  @override
  $SimitInfractionInfoCopyWith<$Res>? get infraction;
  @override
  $SimitDriverInfoCopyWith<$Res>? get driver;
  @override
  $SimitVehicleInfoCopyWith<$Res>? get vehicle;
  @override
  $SimitServiceInfoCopyWith<$Res>? get service;
  @override
  $SimitExtraInfoCopyWith<$Res>? get extraInfo;
}

/// @nodoc
class __$SimitFineDetailCopyWithImpl<$Res>
    implements _$SimitFineDetailCopyWith<$Res> {
  __$SimitFineDetailCopyWithImpl(this._self, this._then);

  final _SimitFineDetail _self;
  final $Res Function(_SimitFineDetail) _then;

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ticketInfo = freezed,
    Object? infraction = freezed,
    Object? driver = freezed,
    Object? vehicle = freezed,
    Object? service = freezed,
    Object? extraInfo = freezed,
  }) {
    return _then(_SimitFineDetail(
      ticketInfo: freezed == ticketInfo
          ? _self.ticketInfo
          : ticketInfo // ignore: cast_nullable_to_non_nullable
              as SimitTicketInfo?,
      infraction: freezed == infraction
          ? _self.infraction
          : infraction // ignore: cast_nullable_to_non_nullable
              as SimitInfractionInfo?,
      driver: freezed == driver
          ? _self.driver
          : driver // ignore: cast_nullable_to_non_nullable
              as SimitDriverInfo?,
      vehicle: freezed == vehicle
          ? _self.vehicle
          : vehicle // ignore: cast_nullable_to_non_nullable
              as SimitVehicleInfo?,
      service: freezed == service
          ? _self.service
          : service // ignore: cast_nullable_to_non_nullable
              as SimitServiceInfo?,
      extraInfo: freezed == extraInfo
          ? _self.extraInfo
          : extraInfo // ignore: cast_nullable_to_non_nullable
              as SimitExtraInfo?,
    ));
  }

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitTicketInfoCopyWith<$Res>? get ticketInfo {
    if (_self.ticketInfo == null) {
      return null;
    }

    return $SimitTicketInfoCopyWith<$Res>(_self.ticketInfo!, (value) {
      return _then(_self.copyWith(ticketInfo: value));
    });
  }

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitInfractionInfoCopyWith<$Res>? get infraction {
    if (_self.infraction == null) {
      return null;
    }

    return $SimitInfractionInfoCopyWith<$Res>(_self.infraction!, (value) {
      return _then(_self.copyWith(infraction: value));
    });
  }

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitDriverInfoCopyWith<$Res>? get driver {
    if (_self.driver == null) {
      return null;
    }

    return $SimitDriverInfoCopyWith<$Res>(_self.driver!, (value) {
      return _then(_self.copyWith(driver: value));
    });
  }

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitVehicleInfoCopyWith<$Res>? get vehicle {
    if (_self.vehicle == null) {
      return null;
    }

    return $SimitVehicleInfoCopyWith<$Res>(_self.vehicle!, (value) {
      return _then(_self.copyWith(vehicle: value));
    });
  }

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitServiceInfoCopyWith<$Res>? get service {
    if (_self.service == null) {
      return null;
    }

    return $SimitServiceInfoCopyWith<$Res>(_self.service!, (value) {
      return _then(_self.copyWith(service: value));
    });
  }

  /// Create a copy of SimitFineDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SimitExtraInfoCopyWith<$Res>? get extraInfo {
    if (_self.extraInfo == null) {
      return null;
    }

    return $SimitExtraInfoCopyWith<$Res>(_self.extraInfo!, (value) {
      return _then(_self.copyWith(extraInfo: value));
    });
  }
}

/// @nodoc
mixin _$SimitTicketInfo {
  /// Número único del comparendo
  @JsonKey(name: 'No. comparendo')
  String? get ticketNumber;

  /// Fecha del comparendo (formato dd/MM/yyyy)
  @JsonKey(name: 'Fecha')
  String? get date;

  /// Hora del comparendo (formato HH:mm:ss)
  @JsonKey(name: 'Hora')
  String? get time;

  /// Dirección donde se impuso el comparendo
  @JsonKey(name: 'Dirección')
  String? get address;

  /// Indica si es comparendo electrónico: "S" o "N"
  @JsonKey(name: 'Comparendo electrónico')
  String? get isElectronic;

  /// Fuente del comparendo: "Comparenderas electrónicas SIMIT", etc.
  @JsonKey(name: 'Fuente comparendo')
  String? get source;

  /// Secretaría de tránsito que impuso el comparendo
  @JsonKey(name: 'Secretaría')
  String? get secretary;

  /// Agente de tránsito que impuso el comparendo
  @JsonKey(name: 'Agente')
  String? get agent;

  /// Create a copy of SimitTicketInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimitTicketInfoCopyWith<SimitTicketInfo> get copyWith =>
      _$SimitTicketInfoCopyWithImpl<SimitTicketInfo>(
          this as SimitTicketInfo, _$identity);

  /// Serializes this SimitTicketInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimitTicketInfo &&
            (identical(other.ticketNumber, ticketNumber) ||
                other.ticketNumber == ticketNumber) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.isElectronic, isElectronic) ||
                other.isElectronic == isElectronic) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.secretary, secretary) ||
                other.secretary == secretary) &&
            (identical(other.agent, agent) || other.agent == agent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ticketNumber, date, time,
      address, isElectronic, source, secretary, agent);

  @override
  String toString() {
    return 'SimitTicketInfo(ticketNumber: $ticketNumber, date: $date, time: $time, address: $address, isElectronic: $isElectronic, source: $source, secretary: $secretary, agent: $agent)';
  }
}

/// @nodoc
abstract mixin class $SimitTicketInfoCopyWith<$Res> {
  factory $SimitTicketInfoCopyWith(
          SimitTicketInfo value, $Res Function(SimitTicketInfo) _then) =
      _$SimitTicketInfoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'No. comparendo') String? ticketNumber,
      @JsonKey(name: 'Fecha') String? date,
      @JsonKey(name: 'Hora') String? time,
      @JsonKey(name: 'Dirección') String? address,
      @JsonKey(name: 'Comparendo electrónico') String? isElectronic,
      @JsonKey(name: 'Fuente comparendo') String? source,
      @JsonKey(name: 'Secretaría') String? secretary,
      @JsonKey(name: 'Agente') String? agent});
}

/// @nodoc
class _$SimitTicketInfoCopyWithImpl<$Res>
    implements $SimitTicketInfoCopyWith<$Res> {
  _$SimitTicketInfoCopyWithImpl(this._self, this._then);

  final SimitTicketInfo _self;
  final $Res Function(SimitTicketInfo) _then;

  /// Create a copy of SimitTicketInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketNumber = freezed,
    Object? date = freezed,
    Object? time = freezed,
    Object? address = freezed,
    Object? isElectronic = freezed,
    Object? source = freezed,
    Object? secretary = freezed,
    Object? agent = freezed,
  }) {
    return _then(_self.copyWith(
      ticketNumber: freezed == ticketNumber
          ? _self.ticketNumber
          : ticketNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      time: freezed == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      isElectronic: freezed == isElectronic
          ? _self.isElectronic
          : isElectronic // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      secretary: freezed == secretary
          ? _self.secretary
          : secretary // ignore: cast_nullable_to_non_nullable
              as String?,
      agent: freezed == agent
          ? _self.agent
          : agent // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SimitTicketInfo].
extension SimitTicketInfoPatterns on SimitTicketInfo {
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
    TResult Function(_SimitTicketInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitTicketInfo() when $default != null:
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
    TResult Function(_SimitTicketInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitTicketInfo():
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
    TResult? Function(_SimitTicketInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitTicketInfo() when $default != null:
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
            @JsonKey(name: 'No. comparendo') String? ticketNumber,
            @JsonKey(name: 'Fecha') String? date,
            @JsonKey(name: 'Hora') String? time,
            @JsonKey(name: 'Dirección') String? address,
            @JsonKey(name: 'Comparendo electrónico') String? isElectronic,
            @JsonKey(name: 'Fuente comparendo') String? source,
            @JsonKey(name: 'Secretaría') String? secretary,
            @JsonKey(name: 'Agente') String? agent)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitTicketInfo() when $default != null:
        return $default(
            _that.ticketNumber,
            _that.date,
            _that.time,
            _that.address,
            _that.isElectronic,
            _that.source,
            _that.secretary,
            _that.agent);
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
            @JsonKey(name: 'No. comparendo') String? ticketNumber,
            @JsonKey(name: 'Fecha') String? date,
            @JsonKey(name: 'Hora') String? time,
            @JsonKey(name: 'Dirección') String? address,
            @JsonKey(name: 'Comparendo electrónico') String? isElectronic,
            @JsonKey(name: 'Fuente comparendo') String? source,
            @JsonKey(name: 'Secretaría') String? secretary,
            @JsonKey(name: 'Agente') String? agent)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitTicketInfo():
        return $default(
            _that.ticketNumber,
            _that.date,
            _that.time,
            _that.address,
            _that.isElectronic,
            _that.source,
            _that.secretary,
            _that.agent);
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
            @JsonKey(name: 'No. comparendo') String? ticketNumber,
            @JsonKey(name: 'Fecha') String? date,
            @JsonKey(name: 'Hora') String? time,
            @JsonKey(name: 'Dirección') String? address,
            @JsonKey(name: 'Comparendo electrónico') String? isElectronic,
            @JsonKey(name: 'Fuente comparendo') String? source,
            @JsonKey(name: 'Secretaría') String? secretary,
            @JsonKey(name: 'Agente') String? agent)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitTicketInfo() when $default != null:
        return $default(
            _that.ticketNumber,
            _that.date,
            _that.time,
            _that.address,
            _that.isElectronic,
            _that.source,
            _that.secretary,
            _that.agent);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimitTicketInfo implements SimitTicketInfo {
  const _SimitTicketInfo(
      {@JsonKey(name: 'No. comparendo') this.ticketNumber,
      @JsonKey(name: 'Fecha') this.date,
      @JsonKey(name: 'Hora') this.time,
      @JsonKey(name: 'Dirección') this.address,
      @JsonKey(name: 'Comparendo electrónico') this.isElectronic,
      @JsonKey(name: 'Fuente comparendo') this.source,
      @JsonKey(name: 'Secretaría') this.secretary,
      @JsonKey(name: 'Agente') this.agent});
  factory _SimitTicketInfo.fromJson(Map<String, dynamic> json) =>
      _$SimitTicketInfoFromJson(json);

  /// Número único del comparendo
  @override
  @JsonKey(name: 'No. comparendo')
  final String? ticketNumber;

  /// Fecha del comparendo (formato dd/MM/yyyy)
  @override
  @JsonKey(name: 'Fecha')
  final String? date;

  /// Hora del comparendo (formato HH:mm:ss)
  @override
  @JsonKey(name: 'Hora')
  final String? time;

  /// Dirección donde se impuso el comparendo
  @override
  @JsonKey(name: 'Dirección')
  final String? address;

  /// Indica si es comparendo electrónico: "S" o "N"
  @override
  @JsonKey(name: 'Comparendo electrónico')
  final String? isElectronic;

  /// Fuente del comparendo: "Comparenderas electrónicas SIMIT", etc.
  @override
  @JsonKey(name: 'Fuente comparendo')
  final String? source;

  /// Secretaría de tránsito que impuso el comparendo
  @override
  @JsonKey(name: 'Secretaría')
  final String? secretary;

  /// Agente de tránsito que impuso el comparendo
  @override
  @JsonKey(name: 'Agente')
  final String? agent;

  /// Create a copy of SimitTicketInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimitTicketInfoCopyWith<_SimitTicketInfo> get copyWith =>
      __$SimitTicketInfoCopyWithImpl<_SimitTicketInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimitTicketInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimitTicketInfo &&
            (identical(other.ticketNumber, ticketNumber) ||
                other.ticketNumber == ticketNumber) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.isElectronic, isElectronic) ||
                other.isElectronic == isElectronic) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.secretary, secretary) ||
                other.secretary == secretary) &&
            (identical(other.agent, agent) || other.agent == agent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ticketNumber, date, time,
      address, isElectronic, source, secretary, agent);

  @override
  String toString() {
    return 'SimitTicketInfo(ticketNumber: $ticketNumber, date: $date, time: $time, address: $address, isElectronic: $isElectronic, source: $source, secretary: $secretary, agent: $agent)';
  }
}

/// @nodoc
abstract mixin class _$SimitTicketInfoCopyWith<$Res>
    implements $SimitTicketInfoCopyWith<$Res> {
  factory _$SimitTicketInfoCopyWith(
          _SimitTicketInfo value, $Res Function(_SimitTicketInfo) _then) =
      __$SimitTicketInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'No. comparendo') String? ticketNumber,
      @JsonKey(name: 'Fecha') String? date,
      @JsonKey(name: 'Hora') String? time,
      @JsonKey(name: 'Dirección') String? address,
      @JsonKey(name: 'Comparendo electrónico') String? isElectronic,
      @JsonKey(name: 'Fuente comparendo') String? source,
      @JsonKey(name: 'Secretaría') String? secretary,
      @JsonKey(name: 'Agente') String? agent});
}

/// @nodoc
class __$SimitTicketInfoCopyWithImpl<$Res>
    implements _$SimitTicketInfoCopyWith<$Res> {
  __$SimitTicketInfoCopyWithImpl(this._self, this._then);

  final _SimitTicketInfo _self;
  final $Res Function(_SimitTicketInfo) _then;

  /// Create a copy of SimitTicketInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ticketNumber = freezed,
    Object? date = freezed,
    Object? time = freezed,
    Object? address = freezed,
    Object? isElectronic = freezed,
    Object? source = freezed,
    Object? secretary = freezed,
    Object? agent = freezed,
  }) {
    return _then(_SimitTicketInfo(
      ticketNumber: freezed == ticketNumber
          ? _self.ticketNumber
          : ticketNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      time: freezed == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      isElectronic: freezed == isElectronic
          ? _self.isElectronic
          : isElectronic // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      secretary: freezed == secretary
          ? _self.secretary
          : secretary // ignore: cast_nullable_to_non_nullable
              as String?,
      agent: freezed == agent
          ? _self.agent
          : agent // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SimitInfractionInfo {
  /// Código de la infracción: "D02", "C24", "C35", etc.
  @JsonKey(name: 'Código')
  String? get code;

  /// Descripción completa de la infracción
  @JsonKey(name: 'Descripción')
  String? get description;

  /// Create a copy of SimitInfractionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimitInfractionInfoCopyWith<SimitInfractionInfo> get copyWith =>
      _$SimitInfractionInfoCopyWithImpl<SimitInfractionInfo>(
          this as SimitInfractionInfo, _$identity);

  /// Serializes this SimitInfractionInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimitInfractionInfo &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, description);

  @override
  String toString() {
    return 'SimitInfractionInfo(code: $code, description: $description)';
  }
}

/// @nodoc
abstract mixin class $SimitInfractionInfoCopyWith<$Res> {
  factory $SimitInfractionInfoCopyWith(
          SimitInfractionInfo value, $Res Function(SimitInfractionInfo) _then) =
      _$SimitInfractionInfoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'Código') String? code,
      @JsonKey(name: 'Descripción') String? description});
}

/// @nodoc
class _$SimitInfractionInfoCopyWithImpl<$Res>
    implements $SimitInfractionInfoCopyWith<$Res> {
  _$SimitInfractionInfoCopyWithImpl(this._self, this._then);

  final SimitInfractionInfo _self;
  final $Res Function(SimitInfractionInfo) _then;

  /// Create a copy of SimitInfractionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? description = freezed,
  }) {
    return _then(_self.copyWith(
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SimitInfractionInfo].
extension SimitInfractionInfoPatterns on SimitInfractionInfo {
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
    TResult Function(_SimitInfractionInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitInfractionInfo() when $default != null:
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
    TResult Function(_SimitInfractionInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitInfractionInfo():
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
    TResult? Function(_SimitInfractionInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitInfractionInfo() when $default != null:
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
    TResult Function(@JsonKey(name: 'Código') String? code,
            @JsonKey(name: 'Descripción') String? description)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitInfractionInfo() when $default != null:
        return $default(_that.code, _that.description);
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
    TResult Function(@JsonKey(name: 'Código') String? code,
            @JsonKey(name: 'Descripción') String? description)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitInfractionInfo():
        return $default(_that.code, _that.description);
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
    TResult? Function(@JsonKey(name: 'Código') String? code,
            @JsonKey(name: 'Descripción') String? description)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitInfractionInfo() when $default != null:
        return $default(_that.code, _that.description);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimitInfractionInfo implements SimitInfractionInfo {
  const _SimitInfractionInfo(
      {@JsonKey(name: 'Código') this.code,
      @JsonKey(name: 'Descripción') this.description});
  factory _SimitInfractionInfo.fromJson(Map<String, dynamic> json) =>
      _$SimitInfractionInfoFromJson(json);

  /// Código de la infracción: "D02", "C24", "C35", etc.
  @override
  @JsonKey(name: 'Código')
  final String? code;

  /// Descripción completa de la infracción
  @override
  @JsonKey(name: 'Descripción')
  final String? description;

  /// Create a copy of SimitInfractionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimitInfractionInfoCopyWith<_SimitInfractionInfo> get copyWith =>
      __$SimitInfractionInfoCopyWithImpl<_SimitInfractionInfo>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimitInfractionInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimitInfractionInfo &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, description);

  @override
  String toString() {
    return 'SimitInfractionInfo(code: $code, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$SimitInfractionInfoCopyWith<$Res>
    implements $SimitInfractionInfoCopyWith<$Res> {
  factory _$SimitInfractionInfoCopyWith(_SimitInfractionInfo value,
          $Res Function(_SimitInfractionInfo) _then) =
      __$SimitInfractionInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Código') String? code,
      @JsonKey(name: 'Descripción') String? description});
}

/// @nodoc
class __$SimitInfractionInfoCopyWithImpl<$Res>
    implements _$SimitInfractionInfoCopyWith<$Res> {
  __$SimitInfractionInfoCopyWithImpl(this._self, this._then);

  final _SimitInfractionInfo _self;
  final $Res Function(_SimitInfractionInfo) _then;

  /// Create a copy of SimitInfractionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = freezed,
    Object? description = freezed,
  }) {
    return _then(_SimitInfractionInfo(
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SimitDriverInfo {
  /// Tipo de documento: "Cédula", "C.E.", "Pasaporte", etc.
  @JsonKey(name: 'Tipo documento')
  String? get documentType;

  /// Número de documento (puede estar parcialmente enmascarado)
  @JsonKey(name: 'Número documento')
  String? get documentNumber;

  /// Nombres del infractor
  @JsonKey(name: 'Nombres')
  String? get firstNames;

  /// Apellidos del infractor
  @JsonKey(name: 'Apellidos')
  String? get lastNames;

  /// Tipo de infractor: "Motociclista", "Conductor", "Peatón", etc.
  @JsonKey(name: 'Tipo de infractor')
  String? get infractorType;

  /// Create a copy of SimitDriverInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimitDriverInfoCopyWith<SimitDriverInfo> get copyWith =>
      _$SimitDriverInfoCopyWithImpl<SimitDriverInfo>(
          this as SimitDriverInfo, _$identity);

  /// Serializes this SimitDriverInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimitDriverInfo &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.documentNumber, documentNumber) ||
                other.documentNumber == documentNumber) &&
            (identical(other.firstNames, firstNames) ||
                other.firstNames == firstNames) &&
            (identical(other.lastNames, lastNames) ||
                other.lastNames == lastNames) &&
            (identical(other.infractorType, infractorType) ||
                other.infractorType == infractorType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, documentType, documentNumber,
      firstNames, lastNames, infractorType);

  @override
  String toString() {
    return 'SimitDriverInfo(documentType: $documentType, documentNumber: $documentNumber, firstNames: $firstNames, lastNames: $lastNames, infractorType: $infractorType)';
  }
}

/// @nodoc
abstract mixin class $SimitDriverInfoCopyWith<$Res> {
  factory $SimitDriverInfoCopyWith(
          SimitDriverInfo value, $Res Function(SimitDriverInfo) _then) =
      _$SimitDriverInfoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'Tipo documento') String? documentType,
      @JsonKey(name: 'Número documento') String? documentNumber,
      @JsonKey(name: 'Nombres') String? firstNames,
      @JsonKey(name: 'Apellidos') String? lastNames,
      @JsonKey(name: 'Tipo de infractor') String? infractorType});
}

/// @nodoc
class _$SimitDriverInfoCopyWithImpl<$Res>
    implements $SimitDriverInfoCopyWith<$Res> {
  _$SimitDriverInfoCopyWithImpl(this._self, this._then);

  final SimitDriverInfo _self;
  final $Res Function(SimitDriverInfo) _then;

  /// Create a copy of SimitDriverInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = freezed,
    Object? documentNumber = freezed,
    Object? firstNames = freezed,
    Object? lastNames = freezed,
    Object? infractorType = freezed,
  }) {
    return _then(_self.copyWith(
      documentType: freezed == documentType
          ? _self.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String?,
      documentNumber: freezed == documentNumber
          ? _self.documentNumber
          : documentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      firstNames: freezed == firstNames
          ? _self.firstNames
          : firstNames // ignore: cast_nullable_to_non_nullable
              as String?,
      lastNames: freezed == lastNames
          ? _self.lastNames
          : lastNames // ignore: cast_nullable_to_non_nullable
              as String?,
      infractorType: freezed == infractorType
          ? _self.infractorType
          : infractorType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SimitDriverInfo].
extension SimitDriverInfoPatterns on SimitDriverInfo {
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
    TResult Function(_SimitDriverInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitDriverInfo() when $default != null:
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
    TResult Function(_SimitDriverInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitDriverInfo():
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
    TResult? Function(_SimitDriverInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitDriverInfo() when $default != null:
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
            @JsonKey(name: 'Tipo documento') String? documentType,
            @JsonKey(name: 'Número documento') String? documentNumber,
            @JsonKey(name: 'Nombres') String? firstNames,
            @JsonKey(name: 'Apellidos') String? lastNames,
            @JsonKey(name: 'Tipo de infractor') String? infractorType)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitDriverInfo() when $default != null:
        return $default(_that.documentType, _that.documentNumber,
            _that.firstNames, _that.lastNames, _that.infractorType);
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
            @JsonKey(name: 'Tipo documento') String? documentType,
            @JsonKey(name: 'Número documento') String? documentNumber,
            @JsonKey(name: 'Nombres') String? firstNames,
            @JsonKey(name: 'Apellidos') String? lastNames,
            @JsonKey(name: 'Tipo de infractor') String? infractorType)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitDriverInfo():
        return $default(_that.documentType, _that.documentNumber,
            _that.firstNames, _that.lastNames, _that.infractorType);
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
            @JsonKey(name: 'Tipo documento') String? documentType,
            @JsonKey(name: 'Número documento') String? documentNumber,
            @JsonKey(name: 'Nombres') String? firstNames,
            @JsonKey(name: 'Apellidos') String? lastNames,
            @JsonKey(name: 'Tipo de infractor') String? infractorType)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitDriverInfo() when $default != null:
        return $default(_that.documentType, _that.documentNumber,
            _that.firstNames, _that.lastNames, _that.infractorType);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimitDriverInfo implements SimitDriverInfo {
  const _SimitDriverInfo(
      {@JsonKey(name: 'Tipo documento') this.documentType,
      @JsonKey(name: 'Número documento') this.documentNumber,
      @JsonKey(name: 'Nombres') this.firstNames,
      @JsonKey(name: 'Apellidos') this.lastNames,
      @JsonKey(name: 'Tipo de infractor') this.infractorType});
  factory _SimitDriverInfo.fromJson(Map<String, dynamic> json) =>
      _$SimitDriverInfoFromJson(json);

  /// Tipo de documento: "Cédula", "C.E.", "Pasaporte", etc.
  @override
  @JsonKey(name: 'Tipo documento')
  final String? documentType;

  /// Número de documento (puede estar parcialmente enmascarado)
  @override
  @JsonKey(name: 'Número documento')
  final String? documentNumber;

  /// Nombres del infractor
  @override
  @JsonKey(name: 'Nombres')
  final String? firstNames;

  /// Apellidos del infractor
  @override
  @JsonKey(name: 'Apellidos')
  final String? lastNames;

  /// Tipo de infractor: "Motociclista", "Conductor", "Peatón", etc.
  @override
  @JsonKey(name: 'Tipo de infractor')
  final String? infractorType;

  /// Create a copy of SimitDriverInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimitDriverInfoCopyWith<_SimitDriverInfo> get copyWith =>
      __$SimitDriverInfoCopyWithImpl<_SimitDriverInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimitDriverInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimitDriverInfo &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.documentNumber, documentNumber) ||
                other.documentNumber == documentNumber) &&
            (identical(other.firstNames, firstNames) ||
                other.firstNames == firstNames) &&
            (identical(other.lastNames, lastNames) ||
                other.lastNames == lastNames) &&
            (identical(other.infractorType, infractorType) ||
                other.infractorType == infractorType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, documentType, documentNumber,
      firstNames, lastNames, infractorType);

  @override
  String toString() {
    return 'SimitDriverInfo(documentType: $documentType, documentNumber: $documentNumber, firstNames: $firstNames, lastNames: $lastNames, infractorType: $infractorType)';
  }
}

/// @nodoc
abstract mixin class _$SimitDriverInfoCopyWith<$Res>
    implements $SimitDriverInfoCopyWith<$Res> {
  factory _$SimitDriverInfoCopyWith(
          _SimitDriverInfo value, $Res Function(_SimitDriverInfo) _then) =
      __$SimitDriverInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Tipo documento') String? documentType,
      @JsonKey(name: 'Número documento') String? documentNumber,
      @JsonKey(name: 'Nombres') String? firstNames,
      @JsonKey(name: 'Apellidos') String? lastNames,
      @JsonKey(name: 'Tipo de infractor') String? infractorType});
}

/// @nodoc
class __$SimitDriverInfoCopyWithImpl<$Res>
    implements _$SimitDriverInfoCopyWith<$Res> {
  __$SimitDriverInfoCopyWithImpl(this._self, this._then);

  final _SimitDriverInfo _self;
  final $Res Function(_SimitDriverInfo) _then;

  /// Create a copy of SimitDriverInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? documentType = freezed,
    Object? documentNumber = freezed,
    Object? firstNames = freezed,
    Object? lastNames = freezed,
    Object? infractorType = freezed,
  }) {
    return _then(_SimitDriverInfo(
      documentType: freezed == documentType
          ? _self.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String?,
      documentNumber: freezed == documentNumber
          ? _self.documentNumber
          : documentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      firstNames: freezed == firstNames
          ? _self.firstNames
          : firstNames // ignore: cast_nullable_to_non_nullable
              as String?,
      lastNames: freezed == lastNames
          ? _self.lastNames
          : lastNames // ignore: cast_nullable_to_non_nullable
              as String?,
      infractorType: freezed == infractorType
          ? _self.infractorType
          : infractorType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SimitVehicleInfo {
  /// Placa del vehículo
  @JsonKey(name: 'Placa')
  String? get plate;

  /// Número de licencia de tránsito del vehículo
  @JsonKey(name: 'No. Licencia del vehículo')
  String? get vehicleLicenseNumber;

  /// Tipo de vehículo: "MOTOCICLETA", "AUTOMOVIL", etc.
  @JsonKey(name: 'Tipo')
  String? get type;

  /// Tipo de servicio: "Particular", "Público", "Oficial"
  @JsonKey(name: 'Servicio')
  String? get service;

  /// Indica si fue inmovilizado: "S" o "N"
  @JsonKey(name: 'Inmovilización')
  String? get immobilized;

  /// Create a copy of SimitVehicleInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimitVehicleInfoCopyWith<SimitVehicleInfo> get copyWith =>
      _$SimitVehicleInfoCopyWithImpl<SimitVehicleInfo>(
          this as SimitVehicleInfo, _$identity);

  /// Serializes this SimitVehicleInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimitVehicleInfo &&
            (identical(other.plate, plate) || other.plate == plate) &&
            (identical(other.vehicleLicenseNumber, vehicleLicenseNumber) ||
                other.vehicleLicenseNumber == vehicleLicenseNumber) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.immobilized, immobilized) ||
                other.immobilized == immobilized));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, plate, vehicleLicenseNumber, type, service, immobilized);

  @override
  String toString() {
    return 'SimitVehicleInfo(plate: $plate, vehicleLicenseNumber: $vehicleLicenseNumber, type: $type, service: $service, immobilized: $immobilized)';
  }
}

/// @nodoc
abstract mixin class $SimitVehicleInfoCopyWith<$Res> {
  factory $SimitVehicleInfoCopyWith(
          SimitVehicleInfo value, $Res Function(SimitVehicleInfo) _then) =
      _$SimitVehicleInfoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'Placa') String? plate,
      @JsonKey(name: 'No. Licencia del vehículo') String? vehicleLicenseNumber,
      @JsonKey(name: 'Tipo') String? type,
      @JsonKey(name: 'Servicio') String? service,
      @JsonKey(name: 'Inmovilización') String? immobilized});
}

/// @nodoc
class _$SimitVehicleInfoCopyWithImpl<$Res>
    implements $SimitVehicleInfoCopyWith<$Res> {
  _$SimitVehicleInfoCopyWithImpl(this._self, this._then);

  final SimitVehicleInfo _self;
  final $Res Function(SimitVehicleInfo) _then;

  /// Create a copy of SimitVehicleInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plate = freezed,
    Object? vehicleLicenseNumber = freezed,
    Object? type = freezed,
    Object? service = freezed,
    Object? immobilized = freezed,
  }) {
    return _then(_self.copyWith(
      plate: freezed == plate
          ? _self.plate
          : plate // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleLicenseNumber: freezed == vehicleLicenseNumber
          ? _self.vehicleLicenseNumber
          : vehicleLicenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      service: freezed == service
          ? _self.service
          : service // ignore: cast_nullable_to_non_nullable
              as String?,
      immobilized: freezed == immobilized
          ? _self.immobilized
          : immobilized // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SimitVehicleInfo].
extension SimitVehicleInfoPatterns on SimitVehicleInfo {
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
    TResult Function(_SimitVehicleInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitVehicleInfo() when $default != null:
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
    TResult Function(_SimitVehicleInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitVehicleInfo():
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
    TResult? Function(_SimitVehicleInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitVehicleInfo() when $default != null:
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
            @JsonKey(name: 'Placa') String? plate,
            @JsonKey(name: 'No. Licencia del vehículo')
            String? vehicleLicenseNumber,
            @JsonKey(name: 'Tipo') String? type,
            @JsonKey(name: 'Servicio') String? service,
            @JsonKey(name: 'Inmovilización') String? immobilized)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitVehicleInfo() when $default != null:
        return $default(_that.plate, _that.vehicleLicenseNumber, _that.type,
            _that.service, _that.immobilized);
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
            @JsonKey(name: 'Placa') String? plate,
            @JsonKey(name: 'No. Licencia del vehículo')
            String? vehicleLicenseNumber,
            @JsonKey(name: 'Tipo') String? type,
            @JsonKey(name: 'Servicio') String? service,
            @JsonKey(name: 'Inmovilización') String? immobilized)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitVehicleInfo():
        return $default(_that.plate, _that.vehicleLicenseNumber, _that.type,
            _that.service, _that.immobilized);
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
            @JsonKey(name: 'Placa') String? plate,
            @JsonKey(name: 'No. Licencia del vehículo')
            String? vehicleLicenseNumber,
            @JsonKey(name: 'Tipo') String? type,
            @JsonKey(name: 'Servicio') String? service,
            @JsonKey(name: 'Inmovilización') String? immobilized)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitVehicleInfo() when $default != null:
        return $default(_that.plate, _that.vehicleLicenseNumber, _that.type,
            _that.service, _that.immobilized);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimitVehicleInfo implements SimitVehicleInfo {
  const _SimitVehicleInfo(
      {@JsonKey(name: 'Placa') this.plate,
      @JsonKey(name: 'No. Licencia del vehículo') this.vehicleLicenseNumber,
      @JsonKey(name: 'Tipo') this.type,
      @JsonKey(name: 'Servicio') this.service,
      @JsonKey(name: 'Inmovilización') this.immobilized});
  factory _SimitVehicleInfo.fromJson(Map<String, dynamic> json) =>
      _$SimitVehicleInfoFromJson(json);

  /// Placa del vehículo
  @override
  @JsonKey(name: 'Placa')
  final String? plate;

  /// Número de licencia de tránsito del vehículo
  @override
  @JsonKey(name: 'No. Licencia del vehículo')
  final String? vehicleLicenseNumber;

  /// Tipo de vehículo: "MOTOCICLETA", "AUTOMOVIL", etc.
  @override
  @JsonKey(name: 'Tipo')
  final String? type;

  /// Tipo de servicio: "Particular", "Público", "Oficial"
  @override
  @JsonKey(name: 'Servicio')
  final String? service;

  /// Indica si fue inmovilizado: "S" o "N"
  @override
  @JsonKey(name: 'Inmovilización')
  final String? immobilized;

  /// Create a copy of SimitVehicleInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimitVehicleInfoCopyWith<_SimitVehicleInfo> get copyWith =>
      __$SimitVehicleInfoCopyWithImpl<_SimitVehicleInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimitVehicleInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimitVehicleInfo &&
            (identical(other.plate, plate) || other.plate == plate) &&
            (identical(other.vehicleLicenseNumber, vehicleLicenseNumber) ||
                other.vehicleLicenseNumber == vehicleLicenseNumber) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.immobilized, immobilized) ||
                other.immobilized == immobilized));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, plate, vehicleLicenseNumber, type, service, immobilized);

  @override
  String toString() {
    return 'SimitVehicleInfo(plate: $plate, vehicleLicenseNumber: $vehicleLicenseNumber, type: $type, service: $service, immobilized: $immobilized)';
  }
}

/// @nodoc
abstract mixin class _$SimitVehicleInfoCopyWith<$Res>
    implements $SimitVehicleInfoCopyWith<$Res> {
  factory _$SimitVehicleInfoCopyWith(
          _SimitVehicleInfo value, $Res Function(_SimitVehicleInfo) _then) =
      __$SimitVehicleInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Placa') String? plate,
      @JsonKey(name: 'No. Licencia del vehículo') String? vehicleLicenseNumber,
      @JsonKey(name: 'Tipo') String? type,
      @JsonKey(name: 'Servicio') String? service,
      @JsonKey(name: 'Inmovilización') String? immobilized});
}

/// @nodoc
class __$SimitVehicleInfoCopyWithImpl<$Res>
    implements _$SimitVehicleInfoCopyWith<$Res> {
  __$SimitVehicleInfoCopyWithImpl(this._self, this._then);

  final _SimitVehicleInfo _self;
  final $Res Function(_SimitVehicleInfo) _then;

  /// Create a copy of SimitVehicleInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? plate = freezed,
    Object? vehicleLicenseNumber = freezed,
    Object? type = freezed,
    Object? service = freezed,
    Object? immobilized = freezed,
  }) {
    return _then(_SimitVehicleInfo(
      plate: freezed == plate
          ? _self.plate
          : plate // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleLicenseNumber: freezed == vehicleLicenseNumber
          ? _self.vehicleLicenseNumber
          : vehicleLicenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      service: freezed == service
          ? _self.service
          : service // ignore: cast_nullable_to_non_nullable
              as String?,
      immobilized: freezed == immobilized
          ? _self.immobilized
          : immobilized // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SimitServiceInfo {
  /// Número de la licencia de conducción
  @JsonKey(name: 'No. Licencia')
  String? get licenseNumber;

  /// Fecha de vencimiento de la licencia (formato dd/MM/yyyy)
  @JsonKey(name: 'Fecha vencimiento')
  String? get expiryDate;

  /// Categoría de la licencia: "A1", "A2", "B1", "C1", etc.
  @JsonKey(name: 'Categoría')
  String? get category;

  /// Secretaría que expidió la licencia
  @JsonKey(name: 'Secretaría')
  String? get secretary;

  /// Create a copy of SimitServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimitServiceInfoCopyWith<SimitServiceInfo> get copyWith =>
      _$SimitServiceInfoCopyWithImpl<SimitServiceInfo>(
          this as SimitServiceInfo, _$identity);

  /// Serializes this SimitServiceInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimitServiceInfo &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.secretary, secretary) ||
                other.secretary == secretary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, licenseNumber, expiryDate, category, secretary);

  @override
  String toString() {
    return 'SimitServiceInfo(licenseNumber: $licenseNumber, expiryDate: $expiryDate, category: $category, secretary: $secretary)';
  }
}

/// @nodoc
abstract mixin class $SimitServiceInfoCopyWith<$Res> {
  factory $SimitServiceInfoCopyWith(
          SimitServiceInfo value, $Res Function(SimitServiceInfo) _then) =
      _$SimitServiceInfoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'No. Licencia') String? licenseNumber,
      @JsonKey(name: 'Fecha vencimiento') String? expiryDate,
      @JsonKey(name: 'Categoría') String? category,
      @JsonKey(name: 'Secretaría') String? secretary});
}

/// @nodoc
class _$SimitServiceInfoCopyWithImpl<$Res>
    implements $SimitServiceInfoCopyWith<$Res> {
  _$SimitServiceInfoCopyWithImpl(this._self, this._then);

  final SimitServiceInfo _self;
  final $Res Function(SimitServiceInfo) _then;

  /// Create a copy of SimitServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? licenseNumber = freezed,
    Object? expiryDate = freezed,
    Object? category = freezed,
    Object? secretary = freezed,
  }) {
    return _then(_self.copyWith(
      licenseNumber: freezed == licenseNumber
          ? _self.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDate: freezed == expiryDate
          ? _self.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      secretary: freezed == secretary
          ? _self.secretary
          : secretary // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SimitServiceInfo].
extension SimitServiceInfoPatterns on SimitServiceInfo {
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
    TResult Function(_SimitServiceInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitServiceInfo() when $default != null:
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
    TResult Function(_SimitServiceInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitServiceInfo():
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
    TResult? Function(_SimitServiceInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitServiceInfo() when $default != null:
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
            @JsonKey(name: 'No. Licencia') String? licenseNumber,
            @JsonKey(name: 'Fecha vencimiento') String? expiryDate,
            @JsonKey(name: 'Categoría') String? category,
            @JsonKey(name: 'Secretaría') String? secretary)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitServiceInfo() when $default != null:
        return $default(_that.licenseNumber, _that.expiryDate, _that.category,
            _that.secretary);
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
            @JsonKey(name: 'No. Licencia') String? licenseNumber,
            @JsonKey(name: 'Fecha vencimiento') String? expiryDate,
            @JsonKey(name: 'Categoría') String? category,
            @JsonKey(name: 'Secretaría') String? secretary)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitServiceInfo():
        return $default(_that.licenseNumber, _that.expiryDate, _that.category,
            _that.secretary);
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
            @JsonKey(name: 'No. Licencia') String? licenseNumber,
            @JsonKey(name: 'Fecha vencimiento') String? expiryDate,
            @JsonKey(name: 'Categoría') String? category,
            @JsonKey(name: 'Secretaría') String? secretary)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitServiceInfo() when $default != null:
        return $default(_that.licenseNumber, _that.expiryDate, _that.category,
            _that.secretary);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimitServiceInfo implements SimitServiceInfo {
  const _SimitServiceInfo(
      {@JsonKey(name: 'No. Licencia') this.licenseNumber,
      @JsonKey(name: 'Fecha vencimiento') this.expiryDate,
      @JsonKey(name: 'Categoría') this.category,
      @JsonKey(name: 'Secretaría') this.secretary});
  factory _SimitServiceInfo.fromJson(Map<String, dynamic> json) =>
      _$SimitServiceInfoFromJson(json);

  /// Número de la licencia de conducción
  @override
  @JsonKey(name: 'No. Licencia')
  final String? licenseNumber;

  /// Fecha de vencimiento de la licencia (formato dd/MM/yyyy)
  @override
  @JsonKey(name: 'Fecha vencimiento')
  final String? expiryDate;

  /// Categoría de la licencia: "A1", "A2", "B1", "C1", etc.
  @override
  @JsonKey(name: 'Categoría')
  final String? category;

  /// Secretaría que expidió la licencia
  @override
  @JsonKey(name: 'Secretaría')
  final String? secretary;

  /// Create a copy of SimitServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimitServiceInfoCopyWith<_SimitServiceInfo> get copyWith =>
      __$SimitServiceInfoCopyWithImpl<_SimitServiceInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimitServiceInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimitServiceInfo &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.secretary, secretary) ||
                other.secretary == secretary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, licenseNumber, expiryDate, category, secretary);

  @override
  String toString() {
    return 'SimitServiceInfo(licenseNumber: $licenseNumber, expiryDate: $expiryDate, category: $category, secretary: $secretary)';
  }
}

/// @nodoc
abstract mixin class _$SimitServiceInfoCopyWith<$Res>
    implements $SimitServiceInfoCopyWith<$Res> {
  factory _$SimitServiceInfoCopyWith(
          _SimitServiceInfo value, $Res Function(_SimitServiceInfo) _then) =
      __$SimitServiceInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'No. Licencia') String? licenseNumber,
      @JsonKey(name: 'Fecha vencimiento') String? expiryDate,
      @JsonKey(name: 'Categoría') String? category,
      @JsonKey(name: 'Secretaría') String? secretary});
}

/// @nodoc
class __$SimitServiceInfoCopyWithImpl<$Res>
    implements _$SimitServiceInfoCopyWith<$Res> {
  __$SimitServiceInfoCopyWithImpl(this._self, this._then);

  final _SimitServiceInfo _self;
  final $Res Function(_SimitServiceInfo) _then;

  /// Create a copy of SimitServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? licenseNumber = freezed,
    Object? expiryDate = freezed,
    Object? category = freezed,
    Object? secretary = freezed,
  }) {
    return _then(_SimitServiceInfo(
      licenseNumber: freezed == licenseNumber
          ? _self.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDate: freezed == expiryDate
          ? _self.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      secretary: freezed == secretary
          ? _self.secretary
          : secretary // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SimitExtraInfo {
  /// Municipio donde se impuso el comparendo
  @JsonKey(name: 'Municipio comparendo')
  String? get ticketMunicipality;

  /// Localidad o comuna
  @JsonKey(name: 'Localidad comuna')
  String? get locality;

  /// Municipio de matrícula del vehículo
  @JsonKey(name: 'Municipio matrícula')
  String? get plateMunicipality;

  /// Radio de acción del vehículo
  @JsonKey(name: 'Radio acción')
  String? get operationRadius;

  /// Modalidad de transporte
  @JsonKey(name: 'Modalidad transporte')
  String? get transportMode;

  /// Número de pasajeros
  @JsonKey(name: 'Pasajeros')
  String? get passengers;

  /// Edad del infractor al momento de la infracción
  @JsonKey(name: 'Edad infractor')
  String? get infractorAge;

  /// Create a copy of SimitExtraInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimitExtraInfoCopyWith<SimitExtraInfo> get copyWith =>
      _$SimitExtraInfoCopyWithImpl<SimitExtraInfo>(
          this as SimitExtraInfo, _$identity);

  /// Serializes this SimitExtraInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimitExtraInfo &&
            (identical(other.ticketMunicipality, ticketMunicipality) ||
                other.ticketMunicipality == ticketMunicipality) &&
            (identical(other.locality, locality) ||
                other.locality == locality) &&
            (identical(other.plateMunicipality, plateMunicipality) ||
                other.plateMunicipality == plateMunicipality) &&
            (identical(other.operationRadius, operationRadius) ||
                other.operationRadius == operationRadius) &&
            (identical(other.transportMode, transportMode) ||
                other.transportMode == transportMode) &&
            (identical(other.passengers, passengers) ||
                other.passengers == passengers) &&
            (identical(other.infractorAge, infractorAge) ||
                other.infractorAge == infractorAge));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      ticketMunicipality,
      locality,
      plateMunicipality,
      operationRadius,
      transportMode,
      passengers,
      infractorAge);

  @override
  String toString() {
    return 'SimitExtraInfo(ticketMunicipality: $ticketMunicipality, locality: $locality, plateMunicipality: $plateMunicipality, operationRadius: $operationRadius, transportMode: $transportMode, passengers: $passengers, infractorAge: $infractorAge)';
  }
}

/// @nodoc
abstract mixin class $SimitExtraInfoCopyWith<$Res> {
  factory $SimitExtraInfoCopyWith(
          SimitExtraInfo value, $Res Function(SimitExtraInfo) _then) =
      _$SimitExtraInfoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'Municipio comparendo') String? ticketMunicipality,
      @JsonKey(name: 'Localidad comuna') String? locality,
      @JsonKey(name: 'Municipio matrícula') String? plateMunicipality,
      @JsonKey(name: 'Radio acción') String? operationRadius,
      @JsonKey(name: 'Modalidad transporte') String? transportMode,
      @JsonKey(name: 'Pasajeros') String? passengers,
      @JsonKey(name: 'Edad infractor') String? infractorAge});
}

/// @nodoc
class _$SimitExtraInfoCopyWithImpl<$Res>
    implements $SimitExtraInfoCopyWith<$Res> {
  _$SimitExtraInfoCopyWithImpl(this._self, this._then);

  final SimitExtraInfo _self;
  final $Res Function(SimitExtraInfo) _then;

  /// Create a copy of SimitExtraInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketMunicipality = freezed,
    Object? locality = freezed,
    Object? plateMunicipality = freezed,
    Object? operationRadius = freezed,
    Object? transportMode = freezed,
    Object? passengers = freezed,
    Object? infractorAge = freezed,
  }) {
    return _then(_self.copyWith(
      ticketMunicipality: freezed == ticketMunicipality
          ? _self.ticketMunicipality
          : ticketMunicipality // ignore: cast_nullable_to_non_nullable
              as String?,
      locality: freezed == locality
          ? _self.locality
          : locality // ignore: cast_nullable_to_non_nullable
              as String?,
      plateMunicipality: freezed == plateMunicipality
          ? _self.plateMunicipality
          : plateMunicipality // ignore: cast_nullable_to_non_nullable
              as String?,
      operationRadius: freezed == operationRadius
          ? _self.operationRadius
          : operationRadius // ignore: cast_nullable_to_non_nullable
              as String?,
      transportMode: freezed == transportMode
          ? _self.transportMode
          : transportMode // ignore: cast_nullable_to_non_nullable
              as String?,
      passengers: freezed == passengers
          ? _self.passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as String?,
      infractorAge: freezed == infractorAge
          ? _self.infractorAge
          : infractorAge // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SimitExtraInfo].
extension SimitExtraInfoPatterns on SimitExtraInfo {
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
    TResult Function(_SimitExtraInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitExtraInfo() when $default != null:
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
    TResult Function(_SimitExtraInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitExtraInfo():
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
    TResult? Function(_SimitExtraInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitExtraInfo() when $default != null:
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
            @JsonKey(name: 'Municipio comparendo') String? ticketMunicipality,
            @JsonKey(name: 'Localidad comuna') String? locality,
            @JsonKey(name: 'Municipio matrícula') String? plateMunicipality,
            @JsonKey(name: 'Radio acción') String? operationRadius,
            @JsonKey(name: 'Modalidad transporte') String? transportMode,
            @JsonKey(name: 'Pasajeros') String? passengers,
            @JsonKey(name: 'Edad infractor') String? infractorAge)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SimitExtraInfo() when $default != null:
        return $default(
            _that.ticketMunicipality,
            _that.locality,
            _that.plateMunicipality,
            _that.operationRadius,
            _that.transportMode,
            _that.passengers,
            _that.infractorAge);
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
            @JsonKey(name: 'Municipio comparendo') String? ticketMunicipality,
            @JsonKey(name: 'Localidad comuna') String? locality,
            @JsonKey(name: 'Municipio matrícula') String? plateMunicipality,
            @JsonKey(name: 'Radio acción') String? operationRadius,
            @JsonKey(name: 'Modalidad transporte') String? transportMode,
            @JsonKey(name: 'Pasajeros') String? passengers,
            @JsonKey(name: 'Edad infractor') String? infractorAge)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitExtraInfo():
        return $default(
            _that.ticketMunicipality,
            _that.locality,
            _that.plateMunicipality,
            _that.operationRadius,
            _that.transportMode,
            _that.passengers,
            _that.infractorAge);
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
            @JsonKey(name: 'Municipio comparendo') String? ticketMunicipality,
            @JsonKey(name: 'Localidad comuna') String? locality,
            @JsonKey(name: 'Municipio matrícula') String? plateMunicipality,
            @JsonKey(name: 'Radio acción') String? operationRadius,
            @JsonKey(name: 'Modalidad transporte') String? transportMode,
            @JsonKey(name: 'Pasajeros') String? passengers,
            @JsonKey(name: 'Edad infractor') String? infractorAge)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SimitExtraInfo() when $default != null:
        return $default(
            _that.ticketMunicipality,
            _that.locality,
            _that.plateMunicipality,
            _that.operationRadius,
            _that.transportMode,
            _that.passengers,
            _that.infractorAge);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SimitExtraInfo implements SimitExtraInfo {
  const _SimitExtraInfo(
      {@JsonKey(name: 'Municipio comparendo') this.ticketMunicipality,
      @JsonKey(name: 'Localidad comuna') this.locality,
      @JsonKey(name: 'Municipio matrícula') this.plateMunicipality,
      @JsonKey(name: 'Radio acción') this.operationRadius,
      @JsonKey(name: 'Modalidad transporte') this.transportMode,
      @JsonKey(name: 'Pasajeros') this.passengers,
      @JsonKey(name: 'Edad infractor') this.infractorAge});
  factory _SimitExtraInfo.fromJson(Map<String, dynamic> json) =>
      _$SimitExtraInfoFromJson(json);

  /// Municipio donde se impuso el comparendo
  @override
  @JsonKey(name: 'Municipio comparendo')
  final String? ticketMunicipality;

  /// Localidad o comuna
  @override
  @JsonKey(name: 'Localidad comuna')
  final String? locality;

  /// Municipio de matrícula del vehículo
  @override
  @JsonKey(name: 'Municipio matrícula')
  final String? plateMunicipality;

  /// Radio de acción del vehículo
  @override
  @JsonKey(name: 'Radio acción')
  final String? operationRadius;

  /// Modalidad de transporte
  @override
  @JsonKey(name: 'Modalidad transporte')
  final String? transportMode;

  /// Número de pasajeros
  @override
  @JsonKey(name: 'Pasajeros')
  final String? passengers;

  /// Edad del infractor al momento de la infracción
  @override
  @JsonKey(name: 'Edad infractor')
  final String? infractorAge;

  /// Create a copy of SimitExtraInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SimitExtraInfoCopyWith<_SimitExtraInfo> get copyWith =>
      __$SimitExtraInfoCopyWithImpl<_SimitExtraInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SimitExtraInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SimitExtraInfo &&
            (identical(other.ticketMunicipality, ticketMunicipality) ||
                other.ticketMunicipality == ticketMunicipality) &&
            (identical(other.locality, locality) ||
                other.locality == locality) &&
            (identical(other.plateMunicipality, plateMunicipality) ||
                other.plateMunicipality == plateMunicipality) &&
            (identical(other.operationRadius, operationRadius) ||
                other.operationRadius == operationRadius) &&
            (identical(other.transportMode, transportMode) ||
                other.transportMode == transportMode) &&
            (identical(other.passengers, passengers) ||
                other.passengers == passengers) &&
            (identical(other.infractorAge, infractorAge) ||
                other.infractorAge == infractorAge));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      ticketMunicipality,
      locality,
      plateMunicipality,
      operationRadius,
      transportMode,
      passengers,
      infractorAge);

  @override
  String toString() {
    return 'SimitExtraInfo(ticketMunicipality: $ticketMunicipality, locality: $locality, plateMunicipality: $plateMunicipality, operationRadius: $operationRadius, transportMode: $transportMode, passengers: $passengers, infractorAge: $infractorAge)';
  }
}

/// @nodoc
abstract mixin class _$SimitExtraInfoCopyWith<$Res>
    implements $SimitExtraInfoCopyWith<$Res> {
  factory _$SimitExtraInfoCopyWith(
          _SimitExtraInfo value, $Res Function(_SimitExtraInfo) _then) =
      __$SimitExtraInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Municipio comparendo') String? ticketMunicipality,
      @JsonKey(name: 'Localidad comuna') String? locality,
      @JsonKey(name: 'Municipio matrícula') String? plateMunicipality,
      @JsonKey(name: 'Radio acción') String? operationRadius,
      @JsonKey(name: 'Modalidad transporte') String? transportMode,
      @JsonKey(name: 'Pasajeros') String? passengers,
      @JsonKey(name: 'Edad infractor') String? infractorAge});
}

/// @nodoc
class __$SimitExtraInfoCopyWithImpl<$Res>
    implements _$SimitExtraInfoCopyWith<$Res> {
  __$SimitExtraInfoCopyWithImpl(this._self, this._then);

  final _SimitExtraInfo _self;
  final $Res Function(_SimitExtraInfo) _then;

  /// Create a copy of SimitExtraInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ticketMunicipality = freezed,
    Object? locality = freezed,
    Object? plateMunicipality = freezed,
    Object? operationRadius = freezed,
    Object? transportMode = freezed,
    Object? passengers = freezed,
    Object? infractorAge = freezed,
  }) {
    return _then(_SimitExtraInfo(
      ticketMunicipality: freezed == ticketMunicipality
          ? _self.ticketMunicipality
          : ticketMunicipality // ignore: cast_nullable_to_non_nullable
              as String?,
      locality: freezed == locality
          ? _self.locality
          : locality // ignore: cast_nullable_to_non_nullable
              as String?,
      plateMunicipality: freezed == plateMunicipality
          ? _self.plateMunicipality
          : plateMunicipality // ignore: cast_nullable_to_non_nullable
              as String?,
      operationRadius: freezed == operationRadius
          ? _self.operationRadius
          : operationRadius // ignore: cast_nullable_to_non_nullable
              as String?,
      transportMode: freezed == transportMode
          ? _self.transportMode
          : transportMode // ignore: cast_nullable_to_non_nullable
              as String?,
      passengers: freezed == passengers
          ? _self.passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as String?,
      infractorAge: freezed == infractorAge
          ? _self.infractorAge
          : infractorAge // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
