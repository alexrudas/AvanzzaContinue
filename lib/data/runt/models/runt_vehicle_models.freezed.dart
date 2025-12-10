// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'runt_vehicle_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RuntVehicleResponse {
  bool get ok;
  String get source;
  RuntVehicleData get data;
  RuntVehicleMeta? get meta;

  /// Create a copy of RuntVehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntVehicleResponseCopyWith<RuntVehicleResponse> get copyWith =>
      _$RuntVehicleResponseCopyWithImpl<RuntVehicleResponse>(
          this as RuntVehicleResponse, _$identity);

  /// Serializes this RuntVehicleResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntVehicleResponse &&
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
    return 'RuntVehicleResponse(ok: $ok, source: $source, data: $data, meta: $meta)';
  }
}

/// @nodoc
abstract mixin class $RuntVehicleResponseCopyWith<$Res> {
  factory $RuntVehicleResponseCopyWith(
          RuntVehicleResponse value, $Res Function(RuntVehicleResponse) _then) =
      _$RuntVehicleResponseCopyWithImpl;
  @useResult
  $Res call(
      {bool ok, String source, RuntVehicleData data, RuntVehicleMeta? meta});

  $RuntVehicleDataCopyWith<$Res> get data;
  $RuntVehicleMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class _$RuntVehicleResponseCopyWithImpl<$Res>
    implements $RuntVehicleResponseCopyWith<$Res> {
  _$RuntVehicleResponseCopyWithImpl(this._self, this._then);

  final RuntVehicleResponse _self;
  final $Res Function(RuntVehicleResponse) _then;

  /// Create a copy of RuntVehicleResponse
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
              as RuntVehicleData,
      meta: freezed == meta
          ? _self.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as RuntVehicleMeta?,
    ));
  }

  /// Create a copy of RuntVehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntVehicleDataCopyWith<$Res> get data {
    return $RuntVehicleDataCopyWith<$Res>(_self.data, (value) {
      return _then(_self.copyWith(data: value));
    });
  }

  /// Create a copy of RuntVehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntVehicleMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
      return null;
    }

    return $RuntVehicleMetaCopyWith<$Res>(_self.meta!, (value) {
      return _then(_self.copyWith(meta: value));
    });
  }
}

/// Adds pattern-matching-related methods to [RuntVehicleResponse].
extension RuntVehicleResponsePatterns on RuntVehicleResponse {
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
    TResult Function(_RuntVehicleResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleResponse() when $default != null:
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
    TResult Function(_RuntVehicleResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleResponse():
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
    TResult? Function(_RuntVehicleResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleResponse() when $default != null:
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
    TResult Function(bool ok, String source, RuntVehicleData data,
            RuntVehicleMeta? meta)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleResponse() when $default != null:
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
            bool ok, String source, RuntVehicleData data, RuntVehicleMeta? meta)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleResponse():
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
    TResult? Function(bool ok, String source, RuntVehicleData data,
            RuntVehicleMeta? meta)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleResponse() when $default != null:
        return $default(_that.ok, _that.source, _that.data, _that.meta);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntVehicleResponse implements RuntVehicleResponse {
  const _RuntVehicleResponse(
      {required this.ok, required this.source, required this.data, this.meta});
  factory _RuntVehicleResponse.fromJson(Map<String, dynamic> json) =>
      _$RuntVehicleResponseFromJson(json);

  @override
  final bool ok;
  @override
  final String source;
  @override
  final RuntVehicleData data;
  @override
  final RuntVehicleMeta? meta;

  /// Create a copy of RuntVehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntVehicleResponseCopyWith<_RuntVehicleResponse> get copyWith =>
      __$RuntVehicleResponseCopyWithImpl<_RuntVehicleResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntVehicleResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntVehicleResponse &&
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
    return 'RuntVehicleResponse(ok: $ok, source: $source, data: $data, meta: $meta)';
  }
}

/// @nodoc
abstract mixin class _$RuntVehicleResponseCopyWith<$Res>
    implements $RuntVehicleResponseCopyWith<$Res> {
  factory _$RuntVehicleResponseCopyWith(_RuntVehicleResponse value,
          $Res Function(_RuntVehicleResponse) _then) =
      __$RuntVehicleResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool ok, String source, RuntVehicleData data, RuntVehicleMeta? meta});

  @override
  $RuntVehicleDataCopyWith<$Res> get data;
  @override
  $RuntVehicleMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class __$RuntVehicleResponseCopyWithImpl<$Res>
    implements _$RuntVehicleResponseCopyWith<$Res> {
  __$RuntVehicleResponseCopyWithImpl(this._self, this._then);

  final _RuntVehicleResponse _self;
  final $Res Function(_RuntVehicleResponse) _then;

  /// Create a copy of RuntVehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ok = null,
    Object? source = null,
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_RuntVehicleResponse(
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
              as RuntVehicleData,
      meta: freezed == meta
          ? _self.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as RuntVehicleMeta?,
    ));
  }

  /// Create a copy of RuntVehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntVehicleDataCopyWith<$Res> get data {
    return $RuntVehicleDataCopyWith<$Res>(_self.data, (value) {
      return _then(_self.copyWith(data: value));
    });
  }

  /// Create a copy of RuntVehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntVehicleMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
      return null;
    }

    return $RuntVehicleMetaCopyWith<$Res>(_self.meta!, (value) {
      return _then(_self.copyWith(meta: value));
    });
  }
}

/// @nodoc
mixin _$RuntVehicleMeta {
  DateTime? get fetchedAt;
  String? get strategy;
  bool? get headless;
  String? get requestId;
  int? get durationMs;
  String? get apiUrl;
  String? get schemaVersion;

  /// Create a copy of RuntVehicleMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntVehicleMetaCopyWith<RuntVehicleMeta> get copyWith =>
      _$RuntVehicleMetaCopyWithImpl<RuntVehicleMeta>(
          this as RuntVehicleMeta, _$identity);

  /// Serializes this RuntVehicleMeta to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntVehicleMeta &&
            (identical(other.fetchedAt, fetchedAt) ||
                other.fetchedAt == fetchedAt) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.headless, headless) ||
                other.headless == headless) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.apiUrl, apiUrl) || other.apiUrl == apiUrl) &&
            (identical(other.schemaVersion, schemaVersion) ||
                other.schemaVersion == schemaVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fetchedAt, strategy, headless,
      requestId, durationMs, apiUrl, schemaVersion);

  @override
  String toString() {
    return 'RuntVehicleMeta(fetchedAt: $fetchedAt, strategy: $strategy, headless: $headless, requestId: $requestId, durationMs: $durationMs, apiUrl: $apiUrl, schemaVersion: $schemaVersion)';
  }
}

/// @nodoc
abstract mixin class $RuntVehicleMetaCopyWith<$Res> {
  factory $RuntVehicleMetaCopyWith(
          RuntVehicleMeta value, $Res Function(RuntVehicleMeta) _then) =
      _$RuntVehicleMetaCopyWithImpl;
  @useResult
  $Res call(
      {DateTime? fetchedAt,
      String? strategy,
      bool? headless,
      String? requestId,
      int? durationMs,
      String? apiUrl,
      String? schemaVersion});
}

/// @nodoc
class _$RuntVehicleMetaCopyWithImpl<$Res>
    implements $RuntVehicleMetaCopyWith<$Res> {
  _$RuntVehicleMetaCopyWithImpl(this._self, this._then);

  final RuntVehicleMeta _self;
  final $Res Function(RuntVehicleMeta) _then;

  /// Create a copy of RuntVehicleMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fetchedAt = freezed,
    Object? strategy = freezed,
    Object? headless = freezed,
    Object? requestId = freezed,
    Object? durationMs = freezed,
    Object? apiUrl = freezed,
    Object? schemaVersion = freezed,
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
      apiUrl: freezed == apiUrl
          ? _self.apiUrl
          : apiUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      schemaVersion: freezed == schemaVersion
          ? _self.schemaVersion
          : schemaVersion // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntVehicleMeta].
extension RuntVehicleMetaPatterns on RuntVehicleMeta {
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
    TResult Function(_RuntVehicleMeta value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleMeta() when $default != null:
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
    TResult Function(_RuntVehicleMeta value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleMeta():
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
    TResult? Function(_RuntVehicleMeta value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleMeta() when $default != null:
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
            DateTime? fetchedAt,
            String? strategy,
            bool? headless,
            String? requestId,
            int? durationMs,
            String? apiUrl,
            String? schemaVersion)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleMeta() when $default != null:
        return $default(
            _that.fetchedAt,
            _that.strategy,
            _that.headless,
            _that.requestId,
            _that.durationMs,
            _that.apiUrl,
            _that.schemaVersion);
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
            DateTime? fetchedAt,
            String? strategy,
            bool? headless,
            String? requestId,
            int? durationMs,
            String? apiUrl,
            String? schemaVersion)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleMeta():
        return $default(
            _that.fetchedAt,
            _that.strategy,
            _that.headless,
            _that.requestId,
            _that.durationMs,
            _that.apiUrl,
            _that.schemaVersion);
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
            DateTime? fetchedAt,
            String? strategy,
            bool? headless,
            String? requestId,
            int? durationMs,
            String? apiUrl,
            String? schemaVersion)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleMeta() when $default != null:
        return $default(
            _that.fetchedAt,
            _that.strategy,
            _that.headless,
            _that.requestId,
            _that.durationMs,
            _that.apiUrl,
            _that.schemaVersion);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntVehicleMeta implements RuntVehicleMeta {
  const _RuntVehicleMeta(
      {this.fetchedAt,
      this.strategy,
      this.headless,
      this.requestId,
      this.durationMs,
      this.apiUrl,
      this.schemaVersion});
  factory _RuntVehicleMeta.fromJson(Map<String, dynamic> json) =>
      _$RuntVehicleMetaFromJson(json);

  @override
  final DateTime? fetchedAt;
  @override
  final String? strategy;
  @override
  final bool? headless;
  @override
  final String? requestId;
  @override
  final int? durationMs;
  @override
  final String? apiUrl;
  @override
  final String? schemaVersion;

  /// Create a copy of RuntVehicleMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntVehicleMetaCopyWith<_RuntVehicleMeta> get copyWith =>
      __$RuntVehicleMetaCopyWithImpl<_RuntVehicleMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntVehicleMetaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntVehicleMeta &&
            (identical(other.fetchedAt, fetchedAt) ||
                other.fetchedAt == fetchedAt) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.headless, headless) ||
                other.headless == headless) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.apiUrl, apiUrl) || other.apiUrl == apiUrl) &&
            (identical(other.schemaVersion, schemaVersion) ||
                other.schemaVersion == schemaVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fetchedAt, strategy, headless,
      requestId, durationMs, apiUrl, schemaVersion);

  @override
  String toString() {
    return 'RuntVehicleMeta(fetchedAt: $fetchedAt, strategy: $strategy, headless: $headless, requestId: $requestId, durationMs: $durationMs, apiUrl: $apiUrl, schemaVersion: $schemaVersion)';
  }
}

/// @nodoc
abstract mixin class _$RuntVehicleMetaCopyWith<$Res>
    implements $RuntVehicleMetaCopyWith<$Res> {
  factory _$RuntVehicleMetaCopyWith(
          _RuntVehicleMeta value, $Res Function(_RuntVehicleMeta) _then) =
      __$RuntVehicleMetaCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DateTime? fetchedAt,
      String? strategy,
      bool? headless,
      String? requestId,
      int? durationMs,
      String? apiUrl,
      String? schemaVersion});
}

/// @nodoc
class __$RuntVehicleMetaCopyWithImpl<$Res>
    implements _$RuntVehicleMetaCopyWith<$Res> {
  __$RuntVehicleMetaCopyWithImpl(this._self, this._then);

  final _RuntVehicleMeta _self;
  final $Res Function(_RuntVehicleMeta) _then;

  /// Create a copy of RuntVehicleMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fetchedAt = freezed,
    Object? strategy = freezed,
    Object? headless = freezed,
    Object? requestId = freezed,
    Object? durationMs = freezed,
    Object? apiUrl = freezed,
    Object? schemaVersion = freezed,
  }) {
    return _then(_RuntVehicleMeta(
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
      apiUrl: freezed == apiUrl
          ? _self.apiUrl
          : apiUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      schemaVersion: freezed == schemaVersion
          ? _self.schemaVersion
          : schemaVersion // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$RuntVehicleData {
  @JsonKey(name: 'informacion_basica')
  RuntVehicleBasicInfo get basicInfo;
  @JsonKey(name: 'informacion_general')
  RuntVehicleGeneralInfo? get generalInfo;
  @JsonKey(name: 'datos_tecnicos')
  RuntVehicleTechnicalData? get technicalData;
  List<RuntSoatRecord> get soat;
  @JsonKey(name: 'seguros_rc')
  List<RuntRcInsuranceRecord> get rcInsurances;
  @JsonKey(name: 'revision_tecnica')
  List<RuntRtmRecord> get rtmHistory;
  @JsonKey(name: 'limitaciones_propiedad')
  List<RuntOwnershipLimitation> get ownershipLimitations;
  @JsonKey(name: 'garantias')
  List<RuntWarranty> get warranties;

  /// Create a copy of RuntVehicleData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntVehicleDataCopyWith<RuntVehicleData> get copyWith =>
      _$RuntVehicleDataCopyWithImpl<RuntVehicleData>(
          this as RuntVehicleData, _$identity);

  /// Serializes this RuntVehicleData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntVehicleData &&
            (identical(other.basicInfo, basicInfo) ||
                other.basicInfo == basicInfo) &&
            (identical(other.generalInfo, generalInfo) ||
                other.generalInfo == generalInfo) &&
            (identical(other.technicalData, technicalData) ||
                other.technicalData == technicalData) &&
            const DeepCollectionEquality().equals(other.soat, soat) &&
            const DeepCollectionEquality()
                .equals(other.rcInsurances, rcInsurances) &&
            const DeepCollectionEquality()
                .equals(other.rtmHistory, rtmHistory) &&
            const DeepCollectionEquality()
                .equals(other.ownershipLimitations, ownershipLimitations) &&
            const DeepCollectionEquality()
                .equals(other.warranties, warranties));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      basicInfo,
      generalInfo,
      technicalData,
      const DeepCollectionEquality().hash(soat),
      const DeepCollectionEquality().hash(rcInsurances),
      const DeepCollectionEquality().hash(rtmHistory),
      const DeepCollectionEquality().hash(ownershipLimitations),
      const DeepCollectionEquality().hash(warranties));

  @override
  String toString() {
    return 'RuntVehicleData(basicInfo: $basicInfo, generalInfo: $generalInfo, technicalData: $technicalData, soat: $soat, rcInsurances: $rcInsurances, rtmHistory: $rtmHistory, ownershipLimitations: $ownershipLimitations, warranties: $warranties)';
  }
}

/// @nodoc
abstract mixin class $RuntVehicleDataCopyWith<$Res> {
  factory $RuntVehicleDataCopyWith(
          RuntVehicleData value, $Res Function(RuntVehicleData) _then) =
      _$RuntVehicleDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'informacion_basica') RuntVehicleBasicInfo basicInfo,
      @JsonKey(name: 'informacion_general') RuntVehicleGeneralInfo? generalInfo,
      @JsonKey(name: 'datos_tecnicos') RuntVehicleTechnicalData? technicalData,
      List<RuntSoatRecord> soat,
      @JsonKey(name: 'seguros_rc') List<RuntRcInsuranceRecord> rcInsurances,
      @JsonKey(name: 'revision_tecnica') List<RuntRtmRecord> rtmHistory,
      @JsonKey(name: 'limitaciones_propiedad')
      List<RuntOwnershipLimitation> ownershipLimitations,
      @JsonKey(name: 'garantias') List<RuntWarranty> warranties});

  $RuntVehicleBasicInfoCopyWith<$Res> get basicInfo;
  $RuntVehicleGeneralInfoCopyWith<$Res>? get generalInfo;
  $RuntVehicleTechnicalDataCopyWith<$Res>? get technicalData;
}

/// @nodoc
class _$RuntVehicleDataCopyWithImpl<$Res>
    implements $RuntVehicleDataCopyWith<$Res> {
  _$RuntVehicleDataCopyWithImpl(this._self, this._then);

  final RuntVehicleData _self;
  final $Res Function(RuntVehicleData) _then;

  /// Create a copy of RuntVehicleData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? basicInfo = null,
    Object? generalInfo = freezed,
    Object? technicalData = freezed,
    Object? soat = null,
    Object? rcInsurances = null,
    Object? rtmHistory = null,
    Object? ownershipLimitations = null,
    Object? warranties = null,
  }) {
    return _then(_self.copyWith(
      basicInfo: null == basicInfo
          ? _self.basicInfo
          : basicInfo // ignore: cast_nullable_to_non_nullable
              as RuntVehicleBasicInfo,
      generalInfo: freezed == generalInfo
          ? _self.generalInfo
          : generalInfo // ignore: cast_nullable_to_non_nullable
              as RuntVehicleGeneralInfo?,
      technicalData: freezed == technicalData
          ? _self.technicalData
          : technicalData // ignore: cast_nullable_to_non_nullable
              as RuntVehicleTechnicalData?,
      soat: null == soat
          ? _self.soat
          : soat // ignore: cast_nullable_to_non_nullable
              as List<RuntSoatRecord>,
      rcInsurances: null == rcInsurances
          ? _self.rcInsurances
          : rcInsurances // ignore: cast_nullable_to_non_nullable
              as List<RuntRcInsuranceRecord>,
      rtmHistory: null == rtmHistory
          ? _self.rtmHistory
          : rtmHistory // ignore: cast_nullable_to_non_nullable
              as List<RuntRtmRecord>,
      ownershipLimitations: null == ownershipLimitations
          ? _self.ownershipLimitations
          : ownershipLimitations // ignore: cast_nullable_to_non_nullable
              as List<RuntOwnershipLimitation>,
      warranties: null == warranties
          ? _self.warranties
          : warranties // ignore: cast_nullable_to_non_nullable
              as List<RuntWarranty>,
    ));
  }

  /// Create a copy of RuntVehicleData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntVehicleBasicInfoCopyWith<$Res> get basicInfo {
    return $RuntVehicleBasicInfoCopyWith<$Res>(_self.basicInfo, (value) {
      return _then(_self.copyWith(basicInfo: value));
    });
  }

  /// Create a copy of RuntVehicleData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntVehicleGeneralInfoCopyWith<$Res>? get generalInfo {
    if (_self.generalInfo == null) {
      return null;
    }

    return $RuntVehicleGeneralInfoCopyWith<$Res>(_self.generalInfo!, (value) {
      return _then(_self.copyWith(generalInfo: value));
    });
  }

  /// Create a copy of RuntVehicleData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntVehicleTechnicalDataCopyWith<$Res>? get technicalData {
    if (_self.technicalData == null) {
      return null;
    }

    return $RuntVehicleTechnicalDataCopyWith<$Res>(_self.technicalData!,
        (value) {
      return _then(_self.copyWith(technicalData: value));
    });
  }
}

/// Adds pattern-matching-related methods to [RuntVehicleData].
extension RuntVehicleDataPatterns on RuntVehicleData {
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
    TResult Function(_RuntVehicleData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleData() when $default != null:
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
    TResult Function(_RuntVehicleData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleData():
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
    TResult? Function(_RuntVehicleData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleData() when $default != null:
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
            @JsonKey(name: 'informacion_basica') RuntVehicleBasicInfo basicInfo,
            @JsonKey(name: 'informacion_general')
            RuntVehicleGeneralInfo? generalInfo,
            @JsonKey(name: 'datos_tecnicos')
            RuntVehicleTechnicalData? technicalData,
            List<RuntSoatRecord> soat,
            @JsonKey(name: 'seguros_rc')
            List<RuntRcInsuranceRecord> rcInsurances,
            @JsonKey(name: 'revision_tecnica') List<RuntRtmRecord> rtmHistory,
            @JsonKey(name: 'limitaciones_propiedad')
            List<RuntOwnershipLimitation> ownershipLimitations,
            @JsonKey(name: 'garantias') List<RuntWarranty> warranties)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleData() when $default != null:
        return $default(
            _that.basicInfo,
            _that.generalInfo,
            _that.technicalData,
            _that.soat,
            _that.rcInsurances,
            _that.rtmHistory,
            _that.ownershipLimitations,
            _that.warranties);
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
            @JsonKey(name: 'informacion_basica') RuntVehicleBasicInfo basicInfo,
            @JsonKey(name: 'informacion_general')
            RuntVehicleGeneralInfo? generalInfo,
            @JsonKey(name: 'datos_tecnicos')
            RuntVehicleTechnicalData? technicalData,
            List<RuntSoatRecord> soat,
            @JsonKey(name: 'seguros_rc')
            List<RuntRcInsuranceRecord> rcInsurances,
            @JsonKey(name: 'revision_tecnica') List<RuntRtmRecord> rtmHistory,
            @JsonKey(name: 'limitaciones_propiedad')
            List<RuntOwnershipLimitation> ownershipLimitations,
            @JsonKey(name: 'garantias') List<RuntWarranty> warranties)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleData():
        return $default(
            _that.basicInfo,
            _that.generalInfo,
            _that.technicalData,
            _that.soat,
            _that.rcInsurances,
            _that.rtmHistory,
            _that.ownershipLimitations,
            _that.warranties);
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
            @JsonKey(name: 'informacion_basica') RuntVehicleBasicInfo basicInfo,
            @JsonKey(name: 'informacion_general')
            RuntVehicleGeneralInfo? generalInfo,
            @JsonKey(name: 'datos_tecnicos')
            RuntVehicleTechnicalData? technicalData,
            List<RuntSoatRecord> soat,
            @JsonKey(name: 'seguros_rc')
            List<RuntRcInsuranceRecord> rcInsurances,
            @JsonKey(name: 'revision_tecnica') List<RuntRtmRecord> rtmHistory,
            @JsonKey(name: 'limitaciones_propiedad')
            List<RuntOwnershipLimitation> ownershipLimitations,
            @JsonKey(name: 'garantias') List<RuntWarranty> warranties)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleData() when $default != null:
        return $default(
            _that.basicInfo,
            _that.generalInfo,
            _that.technicalData,
            _that.soat,
            _that.rcInsurances,
            _that.rtmHistory,
            _that.ownershipLimitations,
            _that.warranties);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntVehicleData implements RuntVehicleData {
  const _RuntVehicleData(
      {@JsonKey(name: 'informacion_basica') required this.basicInfo,
      @JsonKey(name: 'informacion_general') this.generalInfo,
      @JsonKey(name: 'datos_tecnicos') this.technicalData,
      final List<RuntSoatRecord> soat = const [],
      @JsonKey(name: 'seguros_rc')
      final List<RuntRcInsuranceRecord> rcInsurances = const [],
      @JsonKey(name: 'revision_tecnica')
      final List<RuntRtmRecord> rtmHistory = const [],
      @JsonKey(name: 'limitaciones_propiedad')
      final List<RuntOwnershipLimitation> ownershipLimitations = const [],
      @JsonKey(name: 'garantias')
      final List<RuntWarranty> warranties = const []})
      : _soat = soat,
        _rcInsurances = rcInsurances,
        _rtmHistory = rtmHistory,
        _ownershipLimitations = ownershipLimitations,
        _warranties = warranties;
  factory _RuntVehicleData.fromJson(Map<String, dynamic> json) =>
      _$RuntVehicleDataFromJson(json);

  @override
  @JsonKey(name: 'informacion_basica')
  final RuntVehicleBasicInfo basicInfo;
  @override
  @JsonKey(name: 'informacion_general')
  final RuntVehicleGeneralInfo? generalInfo;
  @override
  @JsonKey(name: 'datos_tecnicos')
  final RuntVehicleTechnicalData? technicalData;
  final List<RuntSoatRecord> _soat;
  @override
  @JsonKey()
  List<RuntSoatRecord> get soat {
    if (_soat is EqualUnmodifiableListView) return _soat;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_soat);
  }

  final List<RuntRcInsuranceRecord> _rcInsurances;
  @override
  @JsonKey(name: 'seguros_rc')
  List<RuntRcInsuranceRecord> get rcInsurances {
    if (_rcInsurances is EqualUnmodifiableListView) return _rcInsurances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rcInsurances);
  }

  final List<RuntRtmRecord> _rtmHistory;
  @override
  @JsonKey(name: 'revision_tecnica')
  List<RuntRtmRecord> get rtmHistory {
    if (_rtmHistory is EqualUnmodifiableListView) return _rtmHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rtmHistory);
  }

  final List<RuntOwnershipLimitation> _ownershipLimitations;
  @override
  @JsonKey(name: 'limitaciones_propiedad')
  List<RuntOwnershipLimitation> get ownershipLimitations {
    if (_ownershipLimitations is EqualUnmodifiableListView)
      return _ownershipLimitations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ownershipLimitations);
  }

  final List<RuntWarranty> _warranties;
  @override
  @JsonKey(name: 'garantias')
  List<RuntWarranty> get warranties {
    if (_warranties is EqualUnmodifiableListView) return _warranties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warranties);
  }

  /// Create a copy of RuntVehicleData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntVehicleDataCopyWith<_RuntVehicleData> get copyWith =>
      __$RuntVehicleDataCopyWithImpl<_RuntVehicleData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntVehicleDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntVehicleData &&
            (identical(other.basicInfo, basicInfo) ||
                other.basicInfo == basicInfo) &&
            (identical(other.generalInfo, generalInfo) ||
                other.generalInfo == generalInfo) &&
            (identical(other.technicalData, technicalData) ||
                other.technicalData == technicalData) &&
            const DeepCollectionEquality().equals(other._soat, _soat) &&
            const DeepCollectionEquality()
                .equals(other._rcInsurances, _rcInsurances) &&
            const DeepCollectionEquality()
                .equals(other._rtmHistory, _rtmHistory) &&
            const DeepCollectionEquality()
                .equals(other._ownershipLimitations, _ownershipLimitations) &&
            const DeepCollectionEquality()
                .equals(other._warranties, _warranties));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      basicInfo,
      generalInfo,
      technicalData,
      const DeepCollectionEquality().hash(_soat),
      const DeepCollectionEquality().hash(_rcInsurances),
      const DeepCollectionEquality().hash(_rtmHistory),
      const DeepCollectionEquality().hash(_ownershipLimitations),
      const DeepCollectionEquality().hash(_warranties));

  @override
  String toString() {
    return 'RuntVehicleData(basicInfo: $basicInfo, generalInfo: $generalInfo, technicalData: $technicalData, soat: $soat, rcInsurances: $rcInsurances, rtmHistory: $rtmHistory, ownershipLimitations: $ownershipLimitations, warranties: $warranties)';
  }
}

/// @nodoc
abstract mixin class _$RuntVehicleDataCopyWith<$Res>
    implements $RuntVehicleDataCopyWith<$Res> {
  factory _$RuntVehicleDataCopyWith(
          _RuntVehicleData value, $Res Function(_RuntVehicleData) _then) =
      __$RuntVehicleDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'informacion_basica') RuntVehicleBasicInfo basicInfo,
      @JsonKey(name: 'informacion_general') RuntVehicleGeneralInfo? generalInfo,
      @JsonKey(name: 'datos_tecnicos') RuntVehicleTechnicalData? technicalData,
      List<RuntSoatRecord> soat,
      @JsonKey(name: 'seguros_rc') List<RuntRcInsuranceRecord> rcInsurances,
      @JsonKey(name: 'revision_tecnica') List<RuntRtmRecord> rtmHistory,
      @JsonKey(name: 'limitaciones_propiedad')
      List<RuntOwnershipLimitation> ownershipLimitations,
      @JsonKey(name: 'garantias') List<RuntWarranty> warranties});

  @override
  $RuntVehicleBasicInfoCopyWith<$Res> get basicInfo;
  @override
  $RuntVehicleGeneralInfoCopyWith<$Res>? get generalInfo;
  @override
  $RuntVehicleTechnicalDataCopyWith<$Res>? get technicalData;
}

/// @nodoc
class __$RuntVehicleDataCopyWithImpl<$Res>
    implements _$RuntVehicleDataCopyWith<$Res> {
  __$RuntVehicleDataCopyWithImpl(this._self, this._then);

  final _RuntVehicleData _self;
  final $Res Function(_RuntVehicleData) _then;

  /// Create a copy of RuntVehicleData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? basicInfo = null,
    Object? generalInfo = freezed,
    Object? technicalData = freezed,
    Object? soat = null,
    Object? rcInsurances = null,
    Object? rtmHistory = null,
    Object? ownershipLimitations = null,
    Object? warranties = null,
  }) {
    return _then(_RuntVehicleData(
      basicInfo: null == basicInfo
          ? _self.basicInfo
          : basicInfo // ignore: cast_nullable_to_non_nullable
              as RuntVehicleBasicInfo,
      generalInfo: freezed == generalInfo
          ? _self.generalInfo
          : generalInfo // ignore: cast_nullable_to_non_nullable
              as RuntVehicleGeneralInfo?,
      technicalData: freezed == technicalData
          ? _self.technicalData
          : technicalData // ignore: cast_nullable_to_non_nullable
              as RuntVehicleTechnicalData?,
      soat: null == soat
          ? _self._soat
          : soat // ignore: cast_nullable_to_non_nullable
              as List<RuntSoatRecord>,
      rcInsurances: null == rcInsurances
          ? _self._rcInsurances
          : rcInsurances // ignore: cast_nullable_to_non_nullable
              as List<RuntRcInsuranceRecord>,
      rtmHistory: null == rtmHistory
          ? _self._rtmHistory
          : rtmHistory // ignore: cast_nullable_to_non_nullable
              as List<RuntRtmRecord>,
      ownershipLimitations: null == ownershipLimitations
          ? _self._ownershipLimitations
          : ownershipLimitations // ignore: cast_nullable_to_non_nullable
              as List<RuntOwnershipLimitation>,
      warranties: null == warranties
          ? _self._warranties
          : warranties // ignore: cast_nullable_to_non_nullable
              as List<RuntWarranty>,
    ));
  }

  /// Create a copy of RuntVehicleData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntVehicleBasicInfoCopyWith<$Res> get basicInfo {
    return $RuntVehicleBasicInfoCopyWith<$Res>(_self.basicInfo, (value) {
      return _then(_self.copyWith(basicInfo: value));
    });
  }

  /// Create a copy of RuntVehicleData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntVehicleGeneralInfoCopyWith<$Res>? get generalInfo {
    if (_self.generalInfo == null) {
      return null;
    }

    return $RuntVehicleGeneralInfoCopyWith<$Res>(_self.generalInfo!, (value) {
      return _then(_self.copyWith(generalInfo: value));
    });
  }

  /// Create a copy of RuntVehicleData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuntVehicleTechnicalDataCopyWith<$Res>? get technicalData {
    if (_self.technicalData == null) {
      return null;
    }

    return $RuntVehicleTechnicalDataCopyWith<$Res>(_self.technicalData!,
        (value) {
      return _then(_self.copyWith(technicalData: value));
    });
  }
}

/// @nodoc
mixin _$RuntVehicleBasicInfo {
  @JsonKey(name: 'placa_del_veh_culo')
  String get plate;
  @JsonKey(name: 'estado_del_veh_culo')
  String get vehicleStatus;
  @JsonKey(name: 'tipo_de_servicio')
  String get serviceType;
  @JsonKey(name: 'clase_de_veh_culo')
  String
      get vehicleClass; // CAMBIO: Usamos String con convertidor para evitar desbordamientos o errores de tipo
  @JsonKey(name: 'nro_de_licencia_de_tr_nsito')
  @StringFlexibleConverter()
  String? get transitLicenseNumber;

  /// Create a copy of RuntVehicleBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntVehicleBasicInfoCopyWith<RuntVehicleBasicInfo> get copyWith =>
      _$RuntVehicleBasicInfoCopyWithImpl<RuntVehicleBasicInfo>(
          this as RuntVehicleBasicInfo, _$identity);

  /// Serializes this RuntVehicleBasicInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntVehicleBasicInfo &&
            (identical(other.plate, plate) || other.plate == plate) &&
            (identical(other.vehicleStatus, vehicleStatus) ||
                other.vehicleStatus == vehicleStatus) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.vehicleClass, vehicleClass) ||
                other.vehicleClass == vehicleClass) &&
            (identical(other.transitLicenseNumber, transitLicenseNumber) ||
                other.transitLicenseNumber == transitLicenseNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, plate, vehicleStatus,
      serviceType, vehicleClass, transitLicenseNumber);

  @override
  String toString() {
    return 'RuntVehicleBasicInfo(plate: $plate, vehicleStatus: $vehicleStatus, serviceType: $serviceType, vehicleClass: $vehicleClass, transitLicenseNumber: $transitLicenseNumber)';
  }
}

/// @nodoc
abstract mixin class $RuntVehicleBasicInfoCopyWith<$Res> {
  factory $RuntVehicleBasicInfoCopyWith(RuntVehicleBasicInfo value,
          $Res Function(RuntVehicleBasicInfo) _then) =
      _$RuntVehicleBasicInfoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'placa_del_veh_culo') String plate,
      @JsonKey(name: 'estado_del_veh_culo') String vehicleStatus,
      @JsonKey(name: 'tipo_de_servicio') String serviceType,
      @JsonKey(name: 'clase_de_veh_culo') String vehicleClass,
      @JsonKey(name: 'nro_de_licencia_de_tr_nsito')
      @StringFlexibleConverter()
      String? transitLicenseNumber});
}

/// @nodoc
class _$RuntVehicleBasicInfoCopyWithImpl<$Res>
    implements $RuntVehicleBasicInfoCopyWith<$Res> {
  _$RuntVehicleBasicInfoCopyWithImpl(this._self, this._then);

  final RuntVehicleBasicInfo _self;
  final $Res Function(RuntVehicleBasicInfo) _then;

  /// Create a copy of RuntVehicleBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plate = null,
    Object? vehicleStatus = null,
    Object? serviceType = null,
    Object? vehicleClass = null,
    Object? transitLicenseNumber = freezed,
  }) {
    return _then(_self.copyWith(
      plate: null == plate
          ? _self.plate
          : plate // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleStatus: null == vehicleStatus
          ? _self.vehicleStatus
          : vehicleStatus // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _self.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleClass: null == vehicleClass
          ? _self.vehicleClass
          : vehicleClass // ignore: cast_nullable_to_non_nullable
              as String,
      transitLicenseNumber: freezed == transitLicenseNumber
          ? _self.transitLicenseNumber
          : transitLicenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntVehicleBasicInfo].
extension RuntVehicleBasicInfoPatterns on RuntVehicleBasicInfo {
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
    TResult Function(_RuntVehicleBasicInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleBasicInfo() when $default != null:
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
    TResult Function(_RuntVehicleBasicInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleBasicInfo():
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
    TResult? Function(_RuntVehicleBasicInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleBasicInfo() when $default != null:
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
            @JsonKey(name: 'placa_del_veh_culo') String plate,
            @JsonKey(name: 'estado_del_veh_culo') String vehicleStatus,
            @JsonKey(name: 'tipo_de_servicio') String serviceType,
            @JsonKey(name: 'clase_de_veh_culo') String vehicleClass,
            @JsonKey(name: 'nro_de_licencia_de_tr_nsito')
            @StringFlexibleConverter()
            String? transitLicenseNumber)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleBasicInfo() when $default != null:
        return $default(_that.plate, _that.vehicleStatus, _that.serviceType,
            _that.vehicleClass, _that.transitLicenseNumber);
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
            @JsonKey(name: 'placa_del_veh_culo') String plate,
            @JsonKey(name: 'estado_del_veh_culo') String vehicleStatus,
            @JsonKey(name: 'tipo_de_servicio') String serviceType,
            @JsonKey(name: 'clase_de_veh_culo') String vehicleClass,
            @JsonKey(name: 'nro_de_licencia_de_tr_nsito')
            @StringFlexibleConverter()
            String? transitLicenseNumber)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleBasicInfo():
        return $default(_that.plate, _that.vehicleStatus, _that.serviceType,
            _that.vehicleClass, _that.transitLicenseNumber);
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
            @JsonKey(name: 'placa_del_veh_culo') String plate,
            @JsonKey(name: 'estado_del_veh_culo') String vehicleStatus,
            @JsonKey(name: 'tipo_de_servicio') String serviceType,
            @JsonKey(name: 'clase_de_veh_culo') String vehicleClass,
            @JsonKey(name: 'nro_de_licencia_de_tr_nsito')
            @StringFlexibleConverter()
            String? transitLicenseNumber)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleBasicInfo() when $default != null:
        return $default(_that.plate, _that.vehicleStatus, _that.serviceType,
            _that.vehicleClass, _that.transitLicenseNumber);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntVehicleBasicInfo implements RuntVehicleBasicInfo {
  const _RuntVehicleBasicInfo(
      {@JsonKey(name: 'placa_del_veh_culo') required this.plate,
      @JsonKey(name: 'estado_del_veh_culo') required this.vehicleStatus,
      @JsonKey(name: 'tipo_de_servicio') required this.serviceType,
      @JsonKey(name: 'clase_de_veh_culo') required this.vehicleClass,
      @JsonKey(name: 'nro_de_licencia_de_tr_nsito')
      @StringFlexibleConverter()
      this.transitLicenseNumber});
  factory _RuntVehicleBasicInfo.fromJson(Map<String, dynamic> json) =>
      _$RuntVehicleBasicInfoFromJson(json);

  @override
  @JsonKey(name: 'placa_del_veh_culo')
  final String plate;
  @override
  @JsonKey(name: 'estado_del_veh_culo')
  final String vehicleStatus;
  @override
  @JsonKey(name: 'tipo_de_servicio')
  final String serviceType;
  @override
  @JsonKey(name: 'clase_de_veh_culo')
  final String vehicleClass;
// CAMBIO: Usamos String con convertidor para evitar desbordamientos o errores de tipo
  @override
  @JsonKey(name: 'nro_de_licencia_de_tr_nsito')
  @StringFlexibleConverter()
  final String? transitLicenseNumber;

  /// Create a copy of RuntVehicleBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntVehicleBasicInfoCopyWith<_RuntVehicleBasicInfo> get copyWith =>
      __$RuntVehicleBasicInfoCopyWithImpl<_RuntVehicleBasicInfo>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntVehicleBasicInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntVehicleBasicInfo &&
            (identical(other.plate, plate) || other.plate == plate) &&
            (identical(other.vehicleStatus, vehicleStatus) ||
                other.vehicleStatus == vehicleStatus) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.vehicleClass, vehicleClass) ||
                other.vehicleClass == vehicleClass) &&
            (identical(other.transitLicenseNumber, transitLicenseNumber) ||
                other.transitLicenseNumber == transitLicenseNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, plate, vehicleStatus,
      serviceType, vehicleClass, transitLicenseNumber);

  @override
  String toString() {
    return 'RuntVehicleBasicInfo(plate: $plate, vehicleStatus: $vehicleStatus, serviceType: $serviceType, vehicleClass: $vehicleClass, transitLicenseNumber: $transitLicenseNumber)';
  }
}

/// @nodoc
abstract mixin class _$RuntVehicleBasicInfoCopyWith<$Res>
    implements $RuntVehicleBasicInfoCopyWith<$Res> {
  factory _$RuntVehicleBasicInfoCopyWith(_RuntVehicleBasicInfo value,
          $Res Function(_RuntVehicleBasicInfo) _then) =
      __$RuntVehicleBasicInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'placa_del_veh_culo') String plate,
      @JsonKey(name: 'estado_del_veh_culo') String vehicleStatus,
      @JsonKey(name: 'tipo_de_servicio') String serviceType,
      @JsonKey(name: 'clase_de_veh_culo') String vehicleClass,
      @JsonKey(name: 'nro_de_licencia_de_tr_nsito')
      @StringFlexibleConverter()
      String? transitLicenseNumber});
}

/// @nodoc
class __$RuntVehicleBasicInfoCopyWithImpl<$Res>
    implements _$RuntVehicleBasicInfoCopyWith<$Res> {
  __$RuntVehicleBasicInfoCopyWithImpl(this._self, this._then);

  final _RuntVehicleBasicInfo _self;
  final $Res Function(_RuntVehicleBasicInfo) _then;

  /// Create a copy of RuntVehicleBasicInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? plate = null,
    Object? vehicleStatus = null,
    Object? serviceType = null,
    Object? vehicleClass = null,
    Object? transitLicenseNumber = freezed,
  }) {
    return _then(_RuntVehicleBasicInfo(
      plate: null == plate
          ? _self.plate
          : plate // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleStatus: null == vehicleStatus
          ? _self.vehicleStatus
          : vehicleStatus // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _self.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleClass: null == vehicleClass
          ? _self.vehicleClass
          : vehicleClass // ignore: cast_nullable_to_non_nullable
              as String,
      transitLicenseNumber: freezed == transitLicenseNumber
          ? _self.transitLicenseNumber
          : transitLicenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$RuntVehicleGeneralInfo {
  String? get marca;
  @JsonKey(name: 'l_nea')
  String? get line;
  @IntFlexibleConverter()
  int? get modelo;
  String? get color;
  @JsonKey(name: 'n_mero_de_serie')
  String? get serialNumber;
  @JsonKey(name: 'n_mero_de_motor')
  String? get engineNumber;
  @JsonKey(name: 'n_mero_de_chasis')
  String? get chassisNumber;
  @JsonKey(name: 'n_mero_de_vin')
  String? get vin;
  @IntFlexibleConverter()
  int? get cilindraje;
  @JsonKey(name: 'tipo_de_carrocer_a')
  String? get bodyType;
  @JsonKey(name: 'tipo_combustible')
  String? get fuelType;
  @JsonKey(name: 'fecha_de_matricula_inicial_dd_mm_aaaa')
  String? get initialRegistrationDate;
  @JsonKey(name: 'autoridad_de_tr_nsito')
  String? get transitAuthority;
  @JsonKey(name: 'grav_menes_a_la_propiedad')
  String? get propertyLiens;
  @JsonKey(name: 'cl_sico_o_antiguo')
  String? get isClassicOrAntique;
  String? get repotenciado;
  @JsonKey(name: 'regrabaci_n_motor_si_no')
  String? get engineReengraving;
  @JsonKey(name: 'nro_regrabaci_n_motor')
  String? get engineReengravingNumber;
  @JsonKey(name: 'regrabaci_n_chasis_si_no')
  String? get chassisReengraving;
  @JsonKey(name: 'nro_regrabaci_n_chasis')
  String? get chassisReengravingNumber;
  @JsonKey(name: 'regrabaci_n_serie_si_no')
  String? get seriesReengraving;
  @JsonKey(name: 'nro_regrabaci_n_serie')
  String? get seriesReengravingNumber;
  @JsonKey(name: 'regrabaci_n_vin_si_no')
  String? get vinReengraving;
  @JsonKey(name: 'nro_regrabaci_n_vin')
  String? get vinReengravingNumber;
  @JsonKey(name: 'veh_culo_ense_anza_si_no')
  String? get isTeachingVehicle;
  @IntFlexibleConverter()
  int? get puertas;

  /// Create a copy of RuntVehicleGeneralInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntVehicleGeneralInfoCopyWith<RuntVehicleGeneralInfo> get copyWith =>
      _$RuntVehicleGeneralInfoCopyWithImpl<RuntVehicleGeneralInfo>(
          this as RuntVehicleGeneralInfo, _$identity);

  /// Serializes this RuntVehicleGeneralInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntVehicleGeneralInfo &&
            (identical(other.marca, marca) || other.marca == marca) &&
            (identical(other.line, line) || other.line == line) &&
            (identical(other.modelo, modelo) || other.modelo == modelo) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber) &&
            (identical(other.engineNumber, engineNumber) ||
                other.engineNumber == engineNumber) &&
            (identical(other.chassisNumber, chassisNumber) ||
                other.chassisNumber == chassisNumber) &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.cilindraje, cilindraje) ||
                other.cilindraje == cilindraje) &&
            (identical(other.bodyType, bodyType) ||
                other.bodyType == bodyType) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(
                    other.initialRegistrationDate, initialRegistrationDate) ||
                other.initialRegistrationDate == initialRegistrationDate) &&
            (identical(other.transitAuthority, transitAuthority) ||
                other.transitAuthority == transitAuthority) &&
            (identical(other.propertyLiens, propertyLiens) ||
                other.propertyLiens == propertyLiens) &&
            (identical(other.isClassicOrAntique, isClassicOrAntique) ||
                other.isClassicOrAntique == isClassicOrAntique) &&
            (identical(other.repotenciado, repotenciado) ||
                other.repotenciado == repotenciado) &&
            (identical(other.engineReengraving, engineReengraving) ||
                other.engineReengraving == engineReengraving) &&
            (identical(
                    other.engineReengravingNumber, engineReengravingNumber) ||
                other.engineReengravingNumber == engineReengravingNumber) &&
            (identical(other.chassisReengraving, chassisReengraving) ||
                other.chassisReengraving == chassisReengraving) &&
            (identical(
                    other.chassisReengravingNumber, chassisReengravingNumber) ||
                other.chassisReengravingNumber == chassisReengravingNumber) &&
            (identical(other.seriesReengraving, seriesReengraving) ||
                other.seriesReengraving == seriesReengraving) &&
            (identical(
                    other.seriesReengravingNumber, seriesReengravingNumber) ||
                other.seriesReengravingNumber == seriesReengravingNumber) &&
            (identical(other.vinReengraving, vinReengraving) ||
                other.vinReengraving == vinReengraving) &&
            (identical(other.vinReengravingNumber, vinReengravingNumber) ||
                other.vinReengravingNumber == vinReengravingNumber) &&
            (identical(other.isTeachingVehicle, isTeachingVehicle) ||
                other.isTeachingVehicle == isTeachingVehicle) &&
            (identical(other.puertas, puertas) || other.puertas == puertas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        marca,
        line,
        modelo,
        color,
        serialNumber,
        engineNumber,
        chassisNumber,
        vin,
        cilindraje,
        bodyType,
        fuelType,
        initialRegistrationDate,
        transitAuthority,
        propertyLiens,
        isClassicOrAntique,
        repotenciado,
        engineReengraving,
        engineReengravingNumber,
        chassisReengraving,
        chassisReengravingNumber,
        seriesReengraving,
        seriesReengravingNumber,
        vinReengraving,
        vinReengravingNumber,
        isTeachingVehicle,
        puertas
      ]);

  @override
  String toString() {
    return 'RuntVehicleGeneralInfo(marca: $marca, line: $line, modelo: $modelo, color: $color, serialNumber: $serialNumber, engineNumber: $engineNumber, chassisNumber: $chassisNumber, vin: $vin, cilindraje: $cilindraje, bodyType: $bodyType, fuelType: $fuelType, initialRegistrationDate: $initialRegistrationDate, transitAuthority: $transitAuthority, propertyLiens: $propertyLiens, isClassicOrAntique: $isClassicOrAntique, repotenciado: $repotenciado, engineReengraving: $engineReengraving, engineReengravingNumber: $engineReengravingNumber, chassisReengraving: $chassisReengraving, chassisReengravingNumber: $chassisReengravingNumber, seriesReengraving: $seriesReengraving, seriesReengravingNumber: $seriesReengravingNumber, vinReengraving: $vinReengraving, vinReengravingNumber: $vinReengravingNumber, isTeachingVehicle: $isTeachingVehicle, puertas: $puertas)';
  }
}

/// @nodoc
abstract mixin class $RuntVehicleGeneralInfoCopyWith<$Res> {
  factory $RuntVehicleGeneralInfoCopyWith(RuntVehicleGeneralInfo value,
          $Res Function(RuntVehicleGeneralInfo) _then) =
      _$RuntVehicleGeneralInfoCopyWithImpl;
  @useResult
  $Res call(
      {String? marca,
      @JsonKey(name: 'l_nea') String? line,
      @IntFlexibleConverter() int? modelo,
      String? color,
      @JsonKey(name: 'n_mero_de_serie') String? serialNumber,
      @JsonKey(name: 'n_mero_de_motor') String? engineNumber,
      @JsonKey(name: 'n_mero_de_chasis') String? chassisNumber,
      @JsonKey(name: 'n_mero_de_vin') String? vin,
      @IntFlexibleConverter() int? cilindraje,
      @JsonKey(name: 'tipo_de_carrocer_a') String? bodyType,
      @JsonKey(name: 'tipo_combustible') String? fuelType,
      @JsonKey(name: 'fecha_de_matricula_inicial_dd_mm_aaaa')
      String? initialRegistrationDate,
      @JsonKey(name: 'autoridad_de_tr_nsito') String? transitAuthority,
      @JsonKey(name: 'grav_menes_a_la_propiedad') String? propertyLiens,
      @JsonKey(name: 'cl_sico_o_antiguo') String? isClassicOrAntique,
      String? repotenciado,
      @JsonKey(name: 'regrabaci_n_motor_si_no') String? engineReengraving,
      @JsonKey(name: 'nro_regrabaci_n_motor') String? engineReengravingNumber,
      @JsonKey(name: 'regrabaci_n_chasis_si_no') String? chassisReengraving,
      @JsonKey(name: 'nro_regrabaci_n_chasis') String? chassisReengravingNumber,
      @JsonKey(name: 'regrabaci_n_serie_si_no') String? seriesReengraving,
      @JsonKey(name: 'nro_regrabaci_n_serie') String? seriesReengravingNumber,
      @JsonKey(name: 'regrabaci_n_vin_si_no') String? vinReengraving,
      @JsonKey(name: 'nro_regrabaci_n_vin') String? vinReengravingNumber,
      @JsonKey(name: 'veh_culo_ense_anza_si_no') String? isTeachingVehicle,
      @IntFlexibleConverter() int? puertas});
}

/// @nodoc
class _$RuntVehicleGeneralInfoCopyWithImpl<$Res>
    implements $RuntVehicleGeneralInfoCopyWith<$Res> {
  _$RuntVehicleGeneralInfoCopyWithImpl(this._self, this._then);

  final RuntVehicleGeneralInfo _self;
  final $Res Function(RuntVehicleGeneralInfo) _then;

  /// Create a copy of RuntVehicleGeneralInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? marca = freezed,
    Object? line = freezed,
    Object? modelo = freezed,
    Object? color = freezed,
    Object? serialNumber = freezed,
    Object? engineNumber = freezed,
    Object? chassisNumber = freezed,
    Object? vin = freezed,
    Object? cilindraje = freezed,
    Object? bodyType = freezed,
    Object? fuelType = freezed,
    Object? initialRegistrationDate = freezed,
    Object? transitAuthority = freezed,
    Object? propertyLiens = freezed,
    Object? isClassicOrAntique = freezed,
    Object? repotenciado = freezed,
    Object? engineReengraving = freezed,
    Object? engineReengravingNumber = freezed,
    Object? chassisReengraving = freezed,
    Object? chassisReengravingNumber = freezed,
    Object? seriesReengraving = freezed,
    Object? seriesReengravingNumber = freezed,
    Object? vinReengraving = freezed,
    Object? vinReengravingNumber = freezed,
    Object? isTeachingVehicle = freezed,
    Object? puertas = freezed,
  }) {
    return _then(_self.copyWith(
      marca: freezed == marca
          ? _self.marca
          : marca // ignore: cast_nullable_to_non_nullable
              as String?,
      line: freezed == line
          ? _self.line
          : line // ignore: cast_nullable_to_non_nullable
              as String?,
      modelo: freezed == modelo
          ? _self.modelo
          : modelo // ignore: cast_nullable_to_non_nullable
              as int?,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      serialNumber: freezed == serialNumber
          ? _self.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      engineNumber: freezed == engineNumber
          ? _self.engineNumber
          : engineNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      chassisNumber: freezed == chassisNumber
          ? _self.chassisNumber
          : chassisNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _self.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      cilindraje: freezed == cilindraje
          ? _self.cilindraje
          : cilindraje // ignore: cast_nullable_to_non_nullable
              as int?,
      bodyType: freezed == bodyType
          ? _self.bodyType
          : bodyType // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: freezed == fuelType
          ? _self.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      initialRegistrationDate: freezed == initialRegistrationDate
          ? _self.initialRegistrationDate
          : initialRegistrationDate // ignore: cast_nullable_to_non_nullable
              as String?,
      transitAuthority: freezed == transitAuthority
          ? _self.transitAuthority
          : transitAuthority // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyLiens: freezed == propertyLiens
          ? _self.propertyLiens
          : propertyLiens // ignore: cast_nullable_to_non_nullable
              as String?,
      isClassicOrAntique: freezed == isClassicOrAntique
          ? _self.isClassicOrAntique
          : isClassicOrAntique // ignore: cast_nullable_to_non_nullable
              as String?,
      repotenciado: freezed == repotenciado
          ? _self.repotenciado
          : repotenciado // ignore: cast_nullable_to_non_nullable
              as String?,
      engineReengraving: freezed == engineReengraving
          ? _self.engineReengraving
          : engineReengraving // ignore: cast_nullable_to_non_nullable
              as String?,
      engineReengravingNumber: freezed == engineReengravingNumber
          ? _self.engineReengravingNumber
          : engineReengravingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      chassisReengraving: freezed == chassisReengraving
          ? _self.chassisReengraving
          : chassisReengraving // ignore: cast_nullable_to_non_nullable
              as String?,
      chassisReengravingNumber: freezed == chassisReengravingNumber
          ? _self.chassisReengravingNumber
          : chassisReengravingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      seriesReengraving: freezed == seriesReengraving
          ? _self.seriesReengraving
          : seriesReengraving // ignore: cast_nullable_to_non_nullable
              as String?,
      seriesReengravingNumber: freezed == seriesReengravingNumber
          ? _self.seriesReengravingNumber
          : seriesReengravingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      vinReengraving: freezed == vinReengraving
          ? _self.vinReengraving
          : vinReengraving // ignore: cast_nullable_to_non_nullable
              as String?,
      vinReengravingNumber: freezed == vinReengravingNumber
          ? _self.vinReengravingNumber
          : vinReengravingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isTeachingVehicle: freezed == isTeachingVehicle
          ? _self.isTeachingVehicle
          : isTeachingVehicle // ignore: cast_nullable_to_non_nullable
              as String?,
      puertas: freezed == puertas
          ? _self.puertas
          : puertas // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntVehicleGeneralInfo].
extension RuntVehicleGeneralInfoPatterns on RuntVehicleGeneralInfo {
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
    TResult Function(_RuntVehicleGeneralInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleGeneralInfo() when $default != null:
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
    TResult Function(_RuntVehicleGeneralInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleGeneralInfo():
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
    TResult? Function(_RuntVehicleGeneralInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleGeneralInfo() when $default != null:
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
            String? marca,
            @JsonKey(name: 'l_nea') String? line,
            @IntFlexibleConverter() int? modelo,
            String? color,
            @JsonKey(name: 'n_mero_de_serie') String? serialNumber,
            @JsonKey(name: 'n_mero_de_motor') String? engineNumber,
            @JsonKey(name: 'n_mero_de_chasis') String? chassisNumber,
            @JsonKey(name: 'n_mero_de_vin') String? vin,
            @IntFlexibleConverter() int? cilindraje,
            @JsonKey(name: 'tipo_de_carrocer_a') String? bodyType,
            @JsonKey(name: 'tipo_combustible') String? fuelType,
            @JsonKey(name: 'fecha_de_matricula_inicial_dd_mm_aaaa')
            String? initialRegistrationDate,
            @JsonKey(name: 'autoridad_de_tr_nsito') String? transitAuthority,
            @JsonKey(name: 'grav_menes_a_la_propiedad') String? propertyLiens,
            @JsonKey(name: 'cl_sico_o_antiguo') String? isClassicOrAntique,
            String? repotenciado,
            @JsonKey(name: 'regrabaci_n_motor_si_no') String? engineReengraving,
            @JsonKey(name: 'nro_regrabaci_n_motor')
            String? engineReengravingNumber,
            @JsonKey(name: 'regrabaci_n_chasis_si_no')
            String? chassisReengraving,
            @JsonKey(name: 'nro_regrabaci_n_chasis')
            String? chassisReengravingNumber,
            @JsonKey(name: 'regrabaci_n_serie_si_no') String? seriesReengraving,
            @JsonKey(name: 'nro_regrabaci_n_serie')
            String? seriesReengravingNumber,
            @JsonKey(name: 'regrabaci_n_vin_si_no') String? vinReengraving,
            @JsonKey(name: 'nro_regrabaci_n_vin') String? vinReengravingNumber,
            @JsonKey(name: 'veh_culo_ense_anza_si_no')
            String? isTeachingVehicle,
            @IntFlexibleConverter() int? puertas)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleGeneralInfo() when $default != null:
        return $default(
            _that.marca,
            _that.line,
            _that.modelo,
            _that.color,
            _that.serialNumber,
            _that.engineNumber,
            _that.chassisNumber,
            _that.vin,
            _that.cilindraje,
            _that.bodyType,
            _that.fuelType,
            _that.initialRegistrationDate,
            _that.transitAuthority,
            _that.propertyLiens,
            _that.isClassicOrAntique,
            _that.repotenciado,
            _that.engineReengraving,
            _that.engineReengravingNumber,
            _that.chassisReengraving,
            _that.chassisReengravingNumber,
            _that.seriesReengraving,
            _that.seriesReengravingNumber,
            _that.vinReengraving,
            _that.vinReengravingNumber,
            _that.isTeachingVehicle,
            _that.puertas);
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
            String? marca,
            @JsonKey(name: 'l_nea') String? line,
            @IntFlexibleConverter() int? modelo,
            String? color,
            @JsonKey(name: 'n_mero_de_serie') String? serialNumber,
            @JsonKey(name: 'n_mero_de_motor') String? engineNumber,
            @JsonKey(name: 'n_mero_de_chasis') String? chassisNumber,
            @JsonKey(name: 'n_mero_de_vin') String? vin,
            @IntFlexibleConverter() int? cilindraje,
            @JsonKey(name: 'tipo_de_carrocer_a') String? bodyType,
            @JsonKey(name: 'tipo_combustible') String? fuelType,
            @JsonKey(name: 'fecha_de_matricula_inicial_dd_mm_aaaa')
            String? initialRegistrationDate,
            @JsonKey(name: 'autoridad_de_tr_nsito') String? transitAuthority,
            @JsonKey(name: 'grav_menes_a_la_propiedad') String? propertyLiens,
            @JsonKey(name: 'cl_sico_o_antiguo') String? isClassicOrAntique,
            String? repotenciado,
            @JsonKey(name: 'regrabaci_n_motor_si_no') String? engineReengraving,
            @JsonKey(name: 'nro_regrabaci_n_motor')
            String? engineReengravingNumber,
            @JsonKey(name: 'regrabaci_n_chasis_si_no')
            String? chassisReengraving,
            @JsonKey(name: 'nro_regrabaci_n_chasis')
            String? chassisReengravingNumber,
            @JsonKey(name: 'regrabaci_n_serie_si_no') String? seriesReengraving,
            @JsonKey(name: 'nro_regrabaci_n_serie')
            String? seriesReengravingNumber,
            @JsonKey(name: 'regrabaci_n_vin_si_no') String? vinReengraving,
            @JsonKey(name: 'nro_regrabaci_n_vin') String? vinReengravingNumber,
            @JsonKey(name: 'veh_culo_ense_anza_si_no')
            String? isTeachingVehicle,
            @IntFlexibleConverter() int? puertas)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleGeneralInfo():
        return $default(
            _that.marca,
            _that.line,
            _that.modelo,
            _that.color,
            _that.serialNumber,
            _that.engineNumber,
            _that.chassisNumber,
            _that.vin,
            _that.cilindraje,
            _that.bodyType,
            _that.fuelType,
            _that.initialRegistrationDate,
            _that.transitAuthority,
            _that.propertyLiens,
            _that.isClassicOrAntique,
            _that.repotenciado,
            _that.engineReengraving,
            _that.engineReengravingNumber,
            _that.chassisReengraving,
            _that.chassisReengravingNumber,
            _that.seriesReengraving,
            _that.seriesReengravingNumber,
            _that.vinReengraving,
            _that.vinReengravingNumber,
            _that.isTeachingVehicle,
            _that.puertas);
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
            String? marca,
            @JsonKey(name: 'l_nea') String? line,
            @IntFlexibleConverter() int? modelo,
            String? color,
            @JsonKey(name: 'n_mero_de_serie') String? serialNumber,
            @JsonKey(name: 'n_mero_de_motor') String? engineNumber,
            @JsonKey(name: 'n_mero_de_chasis') String? chassisNumber,
            @JsonKey(name: 'n_mero_de_vin') String? vin,
            @IntFlexibleConverter() int? cilindraje,
            @JsonKey(name: 'tipo_de_carrocer_a') String? bodyType,
            @JsonKey(name: 'tipo_combustible') String? fuelType,
            @JsonKey(name: 'fecha_de_matricula_inicial_dd_mm_aaaa')
            String? initialRegistrationDate,
            @JsonKey(name: 'autoridad_de_tr_nsito') String? transitAuthority,
            @JsonKey(name: 'grav_menes_a_la_propiedad') String? propertyLiens,
            @JsonKey(name: 'cl_sico_o_antiguo') String? isClassicOrAntique,
            String? repotenciado,
            @JsonKey(name: 'regrabaci_n_motor_si_no') String? engineReengraving,
            @JsonKey(name: 'nro_regrabaci_n_motor')
            String? engineReengravingNumber,
            @JsonKey(name: 'regrabaci_n_chasis_si_no')
            String? chassisReengraving,
            @JsonKey(name: 'nro_regrabaci_n_chasis')
            String? chassisReengravingNumber,
            @JsonKey(name: 'regrabaci_n_serie_si_no') String? seriesReengraving,
            @JsonKey(name: 'nro_regrabaci_n_serie')
            String? seriesReengravingNumber,
            @JsonKey(name: 'regrabaci_n_vin_si_no') String? vinReengraving,
            @JsonKey(name: 'nro_regrabaci_n_vin') String? vinReengravingNumber,
            @JsonKey(name: 'veh_culo_ense_anza_si_no')
            String? isTeachingVehicle,
            @IntFlexibleConverter() int? puertas)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleGeneralInfo() when $default != null:
        return $default(
            _that.marca,
            _that.line,
            _that.modelo,
            _that.color,
            _that.serialNumber,
            _that.engineNumber,
            _that.chassisNumber,
            _that.vin,
            _that.cilindraje,
            _that.bodyType,
            _that.fuelType,
            _that.initialRegistrationDate,
            _that.transitAuthority,
            _that.propertyLiens,
            _that.isClassicOrAntique,
            _that.repotenciado,
            _that.engineReengraving,
            _that.engineReengravingNumber,
            _that.chassisReengraving,
            _that.chassisReengravingNumber,
            _that.seriesReengraving,
            _that.seriesReengravingNumber,
            _that.vinReengraving,
            _that.vinReengravingNumber,
            _that.isTeachingVehicle,
            _that.puertas);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntVehicleGeneralInfo implements RuntVehicleGeneralInfo {
  const _RuntVehicleGeneralInfo(
      {this.marca,
      @JsonKey(name: 'l_nea') this.line,
      @IntFlexibleConverter() this.modelo,
      this.color,
      @JsonKey(name: 'n_mero_de_serie') this.serialNumber,
      @JsonKey(name: 'n_mero_de_motor') this.engineNumber,
      @JsonKey(name: 'n_mero_de_chasis') this.chassisNumber,
      @JsonKey(name: 'n_mero_de_vin') this.vin,
      @IntFlexibleConverter() this.cilindraje,
      @JsonKey(name: 'tipo_de_carrocer_a') this.bodyType,
      @JsonKey(name: 'tipo_combustible') this.fuelType,
      @JsonKey(name: 'fecha_de_matricula_inicial_dd_mm_aaaa')
      this.initialRegistrationDate,
      @JsonKey(name: 'autoridad_de_tr_nsito') this.transitAuthority,
      @JsonKey(name: 'grav_menes_a_la_propiedad') this.propertyLiens,
      @JsonKey(name: 'cl_sico_o_antiguo') this.isClassicOrAntique,
      this.repotenciado,
      @JsonKey(name: 'regrabaci_n_motor_si_no') this.engineReengraving,
      @JsonKey(name: 'nro_regrabaci_n_motor') this.engineReengravingNumber,
      @JsonKey(name: 'regrabaci_n_chasis_si_no') this.chassisReengraving,
      @JsonKey(name: 'nro_regrabaci_n_chasis') this.chassisReengravingNumber,
      @JsonKey(name: 'regrabaci_n_serie_si_no') this.seriesReengraving,
      @JsonKey(name: 'nro_regrabaci_n_serie') this.seriesReengravingNumber,
      @JsonKey(name: 'regrabaci_n_vin_si_no') this.vinReengraving,
      @JsonKey(name: 'nro_regrabaci_n_vin') this.vinReengravingNumber,
      @JsonKey(name: 'veh_culo_ense_anza_si_no') this.isTeachingVehicle,
      @IntFlexibleConverter() this.puertas});
  factory _RuntVehicleGeneralInfo.fromJson(Map<String, dynamic> json) =>
      _$RuntVehicleGeneralInfoFromJson(json);

  @override
  final String? marca;
  @override
  @JsonKey(name: 'l_nea')
  final String? line;
  @override
  @IntFlexibleConverter()
  final int? modelo;
  @override
  final String? color;
  @override
  @JsonKey(name: 'n_mero_de_serie')
  final String? serialNumber;
  @override
  @JsonKey(name: 'n_mero_de_motor')
  final String? engineNumber;
  @override
  @JsonKey(name: 'n_mero_de_chasis')
  final String? chassisNumber;
  @override
  @JsonKey(name: 'n_mero_de_vin')
  final String? vin;
  @override
  @IntFlexibleConverter()
  final int? cilindraje;
  @override
  @JsonKey(name: 'tipo_de_carrocer_a')
  final String? bodyType;
  @override
  @JsonKey(name: 'tipo_combustible')
  final String? fuelType;
  @override
  @JsonKey(name: 'fecha_de_matricula_inicial_dd_mm_aaaa')
  final String? initialRegistrationDate;
  @override
  @JsonKey(name: 'autoridad_de_tr_nsito')
  final String? transitAuthority;
  @override
  @JsonKey(name: 'grav_menes_a_la_propiedad')
  final String? propertyLiens;
  @override
  @JsonKey(name: 'cl_sico_o_antiguo')
  final String? isClassicOrAntique;
  @override
  final String? repotenciado;
  @override
  @JsonKey(name: 'regrabaci_n_motor_si_no')
  final String? engineReengraving;
  @override
  @JsonKey(name: 'nro_regrabaci_n_motor')
  final String? engineReengravingNumber;
  @override
  @JsonKey(name: 'regrabaci_n_chasis_si_no')
  final String? chassisReengraving;
  @override
  @JsonKey(name: 'nro_regrabaci_n_chasis')
  final String? chassisReengravingNumber;
  @override
  @JsonKey(name: 'regrabaci_n_serie_si_no')
  final String? seriesReengraving;
  @override
  @JsonKey(name: 'nro_regrabaci_n_serie')
  final String? seriesReengravingNumber;
  @override
  @JsonKey(name: 'regrabaci_n_vin_si_no')
  final String? vinReengraving;
  @override
  @JsonKey(name: 'nro_regrabaci_n_vin')
  final String? vinReengravingNumber;
  @override
  @JsonKey(name: 'veh_culo_ense_anza_si_no')
  final String? isTeachingVehicle;
  @override
  @IntFlexibleConverter()
  final int? puertas;

  /// Create a copy of RuntVehicleGeneralInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntVehicleGeneralInfoCopyWith<_RuntVehicleGeneralInfo> get copyWith =>
      __$RuntVehicleGeneralInfoCopyWithImpl<_RuntVehicleGeneralInfo>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntVehicleGeneralInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntVehicleGeneralInfo &&
            (identical(other.marca, marca) || other.marca == marca) &&
            (identical(other.line, line) || other.line == line) &&
            (identical(other.modelo, modelo) || other.modelo == modelo) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber) &&
            (identical(other.engineNumber, engineNumber) ||
                other.engineNumber == engineNumber) &&
            (identical(other.chassisNumber, chassisNumber) ||
                other.chassisNumber == chassisNumber) &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.cilindraje, cilindraje) ||
                other.cilindraje == cilindraje) &&
            (identical(other.bodyType, bodyType) ||
                other.bodyType == bodyType) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(
                    other.initialRegistrationDate, initialRegistrationDate) ||
                other.initialRegistrationDate == initialRegistrationDate) &&
            (identical(other.transitAuthority, transitAuthority) ||
                other.transitAuthority == transitAuthority) &&
            (identical(other.propertyLiens, propertyLiens) ||
                other.propertyLiens == propertyLiens) &&
            (identical(other.isClassicOrAntique, isClassicOrAntique) ||
                other.isClassicOrAntique == isClassicOrAntique) &&
            (identical(other.repotenciado, repotenciado) ||
                other.repotenciado == repotenciado) &&
            (identical(other.engineReengraving, engineReengraving) ||
                other.engineReengraving == engineReengraving) &&
            (identical(
                    other.engineReengravingNumber, engineReengravingNumber) ||
                other.engineReengravingNumber == engineReengravingNumber) &&
            (identical(other.chassisReengraving, chassisReengraving) ||
                other.chassisReengraving == chassisReengraving) &&
            (identical(
                    other.chassisReengravingNumber, chassisReengravingNumber) ||
                other.chassisReengravingNumber == chassisReengravingNumber) &&
            (identical(other.seriesReengraving, seriesReengraving) ||
                other.seriesReengraving == seriesReengraving) &&
            (identical(
                    other.seriesReengravingNumber, seriesReengravingNumber) ||
                other.seriesReengravingNumber == seriesReengravingNumber) &&
            (identical(other.vinReengraving, vinReengraving) ||
                other.vinReengraving == vinReengraving) &&
            (identical(other.vinReengravingNumber, vinReengravingNumber) ||
                other.vinReengravingNumber == vinReengravingNumber) &&
            (identical(other.isTeachingVehicle, isTeachingVehicle) ||
                other.isTeachingVehicle == isTeachingVehicle) &&
            (identical(other.puertas, puertas) || other.puertas == puertas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        marca,
        line,
        modelo,
        color,
        serialNumber,
        engineNumber,
        chassisNumber,
        vin,
        cilindraje,
        bodyType,
        fuelType,
        initialRegistrationDate,
        transitAuthority,
        propertyLiens,
        isClassicOrAntique,
        repotenciado,
        engineReengraving,
        engineReengravingNumber,
        chassisReengraving,
        chassisReengravingNumber,
        seriesReengraving,
        seriesReengravingNumber,
        vinReengraving,
        vinReengravingNumber,
        isTeachingVehicle,
        puertas
      ]);

  @override
  String toString() {
    return 'RuntVehicleGeneralInfo(marca: $marca, line: $line, modelo: $modelo, color: $color, serialNumber: $serialNumber, engineNumber: $engineNumber, chassisNumber: $chassisNumber, vin: $vin, cilindraje: $cilindraje, bodyType: $bodyType, fuelType: $fuelType, initialRegistrationDate: $initialRegistrationDate, transitAuthority: $transitAuthority, propertyLiens: $propertyLiens, isClassicOrAntique: $isClassicOrAntique, repotenciado: $repotenciado, engineReengraving: $engineReengraving, engineReengravingNumber: $engineReengravingNumber, chassisReengraving: $chassisReengraving, chassisReengravingNumber: $chassisReengravingNumber, seriesReengraving: $seriesReengraving, seriesReengravingNumber: $seriesReengravingNumber, vinReengraving: $vinReengraving, vinReengravingNumber: $vinReengravingNumber, isTeachingVehicle: $isTeachingVehicle, puertas: $puertas)';
  }
}

/// @nodoc
abstract mixin class _$RuntVehicleGeneralInfoCopyWith<$Res>
    implements $RuntVehicleGeneralInfoCopyWith<$Res> {
  factory _$RuntVehicleGeneralInfoCopyWith(_RuntVehicleGeneralInfo value,
          $Res Function(_RuntVehicleGeneralInfo) _then) =
      __$RuntVehicleGeneralInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? marca,
      @JsonKey(name: 'l_nea') String? line,
      @IntFlexibleConverter() int? modelo,
      String? color,
      @JsonKey(name: 'n_mero_de_serie') String? serialNumber,
      @JsonKey(name: 'n_mero_de_motor') String? engineNumber,
      @JsonKey(name: 'n_mero_de_chasis') String? chassisNumber,
      @JsonKey(name: 'n_mero_de_vin') String? vin,
      @IntFlexibleConverter() int? cilindraje,
      @JsonKey(name: 'tipo_de_carrocer_a') String? bodyType,
      @JsonKey(name: 'tipo_combustible') String? fuelType,
      @JsonKey(name: 'fecha_de_matricula_inicial_dd_mm_aaaa')
      String? initialRegistrationDate,
      @JsonKey(name: 'autoridad_de_tr_nsito') String? transitAuthority,
      @JsonKey(name: 'grav_menes_a_la_propiedad') String? propertyLiens,
      @JsonKey(name: 'cl_sico_o_antiguo') String? isClassicOrAntique,
      String? repotenciado,
      @JsonKey(name: 'regrabaci_n_motor_si_no') String? engineReengraving,
      @JsonKey(name: 'nro_regrabaci_n_motor') String? engineReengravingNumber,
      @JsonKey(name: 'regrabaci_n_chasis_si_no') String? chassisReengraving,
      @JsonKey(name: 'nro_regrabaci_n_chasis') String? chassisReengravingNumber,
      @JsonKey(name: 'regrabaci_n_serie_si_no') String? seriesReengraving,
      @JsonKey(name: 'nro_regrabaci_n_serie') String? seriesReengravingNumber,
      @JsonKey(name: 'regrabaci_n_vin_si_no') String? vinReengraving,
      @JsonKey(name: 'nro_regrabaci_n_vin') String? vinReengravingNumber,
      @JsonKey(name: 'veh_culo_ense_anza_si_no') String? isTeachingVehicle,
      @IntFlexibleConverter() int? puertas});
}

/// @nodoc
class __$RuntVehicleGeneralInfoCopyWithImpl<$Res>
    implements _$RuntVehicleGeneralInfoCopyWith<$Res> {
  __$RuntVehicleGeneralInfoCopyWithImpl(this._self, this._then);

  final _RuntVehicleGeneralInfo _self;
  final $Res Function(_RuntVehicleGeneralInfo) _then;

  /// Create a copy of RuntVehicleGeneralInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? marca = freezed,
    Object? line = freezed,
    Object? modelo = freezed,
    Object? color = freezed,
    Object? serialNumber = freezed,
    Object? engineNumber = freezed,
    Object? chassisNumber = freezed,
    Object? vin = freezed,
    Object? cilindraje = freezed,
    Object? bodyType = freezed,
    Object? fuelType = freezed,
    Object? initialRegistrationDate = freezed,
    Object? transitAuthority = freezed,
    Object? propertyLiens = freezed,
    Object? isClassicOrAntique = freezed,
    Object? repotenciado = freezed,
    Object? engineReengraving = freezed,
    Object? engineReengravingNumber = freezed,
    Object? chassisReengraving = freezed,
    Object? chassisReengravingNumber = freezed,
    Object? seriesReengraving = freezed,
    Object? seriesReengravingNumber = freezed,
    Object? vinReengraving = freezed,
    Object? vinReengravingNumber = freezed,
    Object? isTeachingVehicle = freezed,
    Object? puertas = freezed,
  }) {
    return _then(_RuntVehicleGeneralInfo(
      marca: freezed == marca
          ? _self.marca
          : marca // ignore: cast_nullable_to_non_nullable
              as String?,
      line: freezed == line
          ? _self.line
          : line // ignore: cast_nullable_to_non_nullable
              as String?,
      modelo: freezed == modelo
          ? _self.modelo
          : modelo // ignore: cast_nullable_to_non_nullable
              as int?,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      serialNumber: freezed == serialNumber
          ? _self.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      engineNumber: freezed == engineNumber
          ? _self.engineNumber
          : engineNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      chassisNumber: freezed == chassisNumber
          ? _self.chassisNumber
          : chassisNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _self.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      cilindraje: freezed == cilindraje
          ? _self.cilindraje
          : cilindraje // ignore: cast_nullable_to_non_nullable
              as int?,
      bodyType: freezed == bodyType
          ? _self.bodyType
          : bodyType // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: freezed == fuelType
          ? _self.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      initialRegistrationDate: freezed == initialRegistrationDate
          ? _self.initialRegistrationDate
          : initialRegistrationDate // ignore: cast_nullable_to_non_nullable
              as String?,
      transitAuthority: freezed == transitAuthority
          ? _self.transitAuthority
          : transitAuthority // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyLiens: freezed == propertyLiens
          ? _self.propertyLiens
          : propertyLiens // ignore: cast_nullable_to_non_nullable
              as String?,
      isClassicOrAntique: freezed == isClassicOrAntique
          ? _self.isClassicOrAntique
          : isClassicOrAntique // ignore: cast_nullable_to_non_nullable
              as String?,
      repotenciado: freezed == repotenciado
          ? _self.repotenciado
          : repotenciado // ignore: cast_nullable_to_non_nullable
              as String?,
      engineReengraving: freezed == engineReengraving
          ? _self.engineReengraving
          : engineReengraving // ignore: cast_nullable_to_non_nullable
              as String?,
      engineReengravingNumber: freezed == engineReengravingNumber
          ? _self.engineReengravingNumber
          : engineReengravingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      chassisReengraving: freezed == chassisReengraving
          ? _self.chassisReengraving
          : chassisReengraving // ignore: cast_nullable_to_non_nullable
              as String?,
      chassisReengravingNumber: freezed == chassisReengravingNumber
          ? _self.chassisReengravingNumber
          : chassisReengravingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      seriesReengraving: freezed == seriesReengraving
          ? _self.seriesReengraving
          : seriesReengraving // ignore: cast_nullable_to_non_nullable
              as String?,
      seriesReengravingNumber: freezed == seriesReengravingNumber
          ? _self.seriesReengravingNumber
          : seriesReengravingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      vinReengraving: freezed == vinReengraving
          ? _self.vinReengraving
          : vinReengraving // ignore: cast_nullable_to_non_nullable
              as String?,
      vinReengravingNumber: freezed == vinReengravingNumber
          ? _self.vinReengravingNumber
          : vinReengravingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isTeachingVehicle: freezed == isTeachingVehicle
          ? _self.isTeachingVehicle
          : isTeachingVehicle // ignore: cast_nullable_to_non_nullable
              as String?,
      puertas: freezed == puertas
          ? _self.puertas
          : puertas // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$RuntVehicleTechnicalData {
  @JsonKey(name: 'capacidad_de_carga')
  @IntFlexibleConverter()
  int? get loadCapacityKg;
  @JsonKey(name: 'peso_bruto_vehicular')
  @IntFlexibleConverter()
  int? get grossWeightKg;
  @JsonKey(name: 'capacidad_de_pasajeros')
  String? get passengersCapacityRaw;
  @JsonKey(name: 'capacidad_pasajeros_sentados')
  @IntFlexibleConverter()
  int? get seatedPassengers;
  @JsonKey(name: 'n_mero_de_ejes')
  @IntFlexibleConverter()
  int? get axles;

  /// Create a copy of RuntVehicleTechnicalData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntVehicleTechnicalDataCopyWith<RuntVehicleTechnicalData> get copyWith =>
      _$RuntVehicleTechnicalDataCopyWithImpl<RuntVehicleTechnicalData>(
          this as RuntVehicleTechnicalData, _$identity);

  /// Serializes this RuntVehicleTechnicalData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntVehicleTechnicalData &&
            (identical(other.loadCapacityKg, loadCapacityKg) ||
                other.loadCapacityKg == loadCapacityKg) &&
            (identical(other.grossWeightKg, grossWeightKg) ||
                other.grossWeightKg == grossWeightKg) &&
            (identical(other.passengersCapacityRaw, passengersCapacityRaw) ||
                other.passengersCapacityRaw == passengersCapacityRaw) &&
            (identical(other.seatedPassengers, seatedPassengers) ||
                other.seatedPassengers == seatedPassengers) &&
            (identical(other.axles, axles) || other.axles == axles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, loadCapacityKg, grossWeightKg,
      passengersCapacityRaw, seatedPassengers, axles);

  @override
  String toString() {
    return 'RuntVehicleTechnicalData(loadCapacityKg: $loadCapacityKg, grossWeightKg: $grossWeightKg, passengersCapacityRaw: $passengersCapacityRaw, seatedPassengers: $seatedPassengers, axles: $axles)';
  }
}

/// @nodoc
abstract mixin class $RuntVehicleTechnicalDataCopyWith<$Res> {
  factory $RuntVehicleTechnicalDataCopyWith(RuntVehicleTechnicalData value,
          $Res Function(RuntVehicleTechnicalData) _then) =
      _$RuntVehicleTechnicalDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'capacidad_de_carga')
      @IntFlexibleConverter()
      int? loadCapacityKg,
      @JsonKey(name: 'peso_bruto_vehicular')
      @IntFlexibleConverter()
      int? grossWeightKg,
      @JsonKey(name: 'capacidad_de_pasajeros') String? passengersCapacityRaw,
      @JsonKey(name: 'capacidad_pasajeros_sentados')
      @IntFlexibleConverter()
      int? seatedPassengers,
      @JsonKey(name: 'n_mero_de_ejes') @IntFlexibleConverter() int? axles});
}

/// @nodoc
class _$RuntVehicleTechnicalDataCopyWithImpl<$Res>
    implements $RuntVehicleTechnicalDataCopyWith<$Res> {
  _$RuntVehicleTechnicalDataCopyWithImpl(this._self, this._then);

  final RuntVehicleTechnicalData _self;
  final $Res Function(RuntVehicleTechnicalData) _then;

  /// Create a copy of RuntVehicleTechnicalData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadCapacityKg = freezed,
    Object? grossWeightKg = freezed,
    Object? passengersCapacityRaw = freezed,
    Object? seatedPassengers = freezed,
    Object? axles = freezed,
  }) {
    return _then(_self.copyWith(
      loadCapacityKg: freezed == loadCapacityKg
          ? _self.loadCapacityKg
          : loadCapacityKg // ignore: cast_nullable_to_non_nullable
              as int?,
      grossWeightKg: freezed == grossWeightKg
          ? _self.grossWeightKg
          : grossWeightKg // ignore: cast_nullable_to_non_nullable
              as int?,
      passengersCapacityRaw: freezed == passengersCapacityRaw
          ? _self.passengersCapacityRaw
          : passengersCapacityRaw // ignore: cast_nullable_to_non_nullable
              as String?,
      seatedPassengers: freezed == seatedPassengers
          ? _self.seatedPassengers
          : seatedPassengers // ignore: cast_nullable_to_non_nullable
              as int?,
      axles: freezed == axles
          ? _self.axles
          : axles // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntVehicleTechnicalData].
extension RuntVehicleTechnicalDataPatterns on RuntVehicleTechnicalData {
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
    TResult Function(_RuntVehicleTechnicalData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleTechnicalData() when $default != null:
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
    TResult Function(_RuntVehicleTechnicalData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleTechnicalData():
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
    TResult? Function(_RuntVehicleTechnicalData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleTechnicalData() when $default != null:
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
            @JsonKey(name: 'capacidad_de_carga')
            @IntFlexibleConverter()
            int? loadCapacityKg,
            @JsonKey(name: 'peso_bruto_vehicular')
            @IntFlexibleConverter()
            int? grossWeightKg,
            @JsonKey(name: 'capacidad_de_pasajeros')
            String? passengersCapacityRaw,
            @JsonKey(name: 'capacidad_pasajeros_sentados')
            @IntFlexibleConverter()
            int? seatedPassengers,
            @JsonKey(name: 'n_mero_de_ejes')
            @IntFlexibleConverter()
            int? axles)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleTechnicalData() when $default != null:
        return $default(_that.loadCapacityKg, _that.grossWeightKg,
            _that.passengersCapacityRaw, _that.seatedPassengers, _that.axles);
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
            @JsonKey(name: 'capacidad_de_carga')
            @IntFlexibleConverter()
            int? loadCapacityKg,
            @JsonKey(name: 'peso_bruto_vehicular')
            @IntFlexibleConverter()
            int? grossWeightKg,
            @JsonKey(name: 'capacidad_de_pasajeros')
            String? passengersCapacityRaw,
            @JsonKey(name: 'capacidad_pasajeros_sentados')
            @IntFlexibleConverter()
            int? seatedPassengers,
            @JsonKey(name: 'n_mero_de_ejes') @IntFlexibleConverter() int? axles)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleTechnicalData():
        return $default(_that.loadCapacityKg, _that.grossWeightKg,
            _that.passengersCapacityRaw, _that.seatedPassengers, _that.axles);
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
            @JsonKey(name: 'capacidad_de_carga')
            @IntFlexibleConverter()
            int? loadCapacityKg,
            @JsonKey(name: 'peso_bruto_vehicular')
            @IntFlexibleConverter()
            int? grossWeightKg,
            @JsonKey(name: 'capacidad_de_pasajeros')
            String? passengersCapacityRaw,
            @JsonKey(name: 'capacidad_pasajeros_sentados')
            @IntFlexibleConverter()
            int? seatedPassengers,
            @JsonKey(name: 'n_mero_de_ejes')
            @IntFlexibleConverter()
            int? axles)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntVehicleTechnicalData() when $default != null:
        return $default(_that.loadCapacityKg, _that.grossWeightKg,
            _that.passengersCapacityRaw, _that.seatedPassengers, _that.axles);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntVehicleTechnicalData implements RuntVehicleTechnicalData {
  const _RuntVehicleTechnicalData(
      {@JsonKey(name: 'capacidad_de_carga')
      @IntFlexibleConverter()
      this.loadCapacityKg,
      @JsonKey(name: 'peso_bruto_vehicular')
      @IntFlexibleConverter()
      this.grossWeightKg,
      @JsonKey(name: 'capacidad_de_pasajeros') this.passengersCapacityRaw,
      @JsonKey(name: 'capacidad_pasajeros_sentados')
      @IntFlexibleConverter()
      this.seatedPassengers,
      @JsonKey(name: 'n_mero_de_ejes') @IntFlexibleConverter() this.axles});
  factory _RuntVehicleTechnicalData.fromJson(Map<String, dynamic> json) =>
      _$RuntVehicleTechnicalDataFromJson(json);

  @override
  @JsonKey(name: 'capacidad_de_carga')
  @IntFlexibleConverter()
  final int? loadCapacityKg;
  @override
  @JsonKey(name: 'peso_bruto_vehicular')
  @IntFlexibleConverter()
  final int? grossWeightKg;
  @override
  @JsonKey(name: 'capacidad_de_pasajeros')
  final String? passengersCapacityRaw;
  @override
  @JsonKey(name: 'capacidad_pasajeros_sentados')
  @IntFlexibleConverter()
  final int? seatedPassengers;
  @override
  @JsonKey(name: 'n_mero_de_ejes')
  @IntFlexibleConverter()
  final int? axles;

  /// Create a copy of RuntVehicleTechnicalData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntVehicleTechnicalDataCopyWith<_RuntVehicleTechnicalData> get copyWith =>
      __$RuntVehicleTechnicalDataCopyWithImpl<_RuntVehicleTechnicalData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntVehicleTechnicalDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntVehicleTechnicalData &&
            (identical(other.loadCapacityKg, loadCapacityKg) ||
                other.loadCapacityKg == loadCapacityKg) &&
            (identical(other.grossWeightKg, grossWeightKg) ||
                other.grossWeightKg == grossWeightKg) &&
            (identical(other.passengersCapacityRaw, passengersCapacityRaw) ||
                other.passengersCapacityRaw == passengersCapacityRaw) &&
            (identical(other.seatedPassengers, seatedPassengers) ||
                other.seatedPassengers == seatedPassengers) &&
            (identical(other.axles, axles) || other.axles == axles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, loadCapacityKg, grossWeightKg,
      passengersCapacityRaw, seatedPassengers, axles);

  @override
  String toString() {
    return 'RuntVehicleTechnicalData(loadCapacityKg: $loadCapacityKg, grossWeightKg: $grossWeightKg, passengersCapacityRaw: $passengersCapacityRaw, seatedPassengers: $seatedPassengers, axles: $axles)';
  }
}

/// @nodoc
abstract mixin class _$RuntVehicleTechnicalDataCopyWith<$Res>
    implements $RuntVehicleTechnicalDataCopyWith<$Res> {
  factory _$RuntVehicleTechnicalDataCopyWith(_RuntVehicleTechnicalData value,
          $Res Function(_RuntVehicleTechnicalData) _then) =
      __$RuntVehicleTechnicalDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'capacidad_de_carga')
      @IntFlexibleConverter()
      int? loadCapacityKg,
      @JsonKey(name: 'peso_bruto_vehicular')
      @IntFlexibleConverter()
      int? grossWeightKg,
      @JsonKey(name: 'capacidad_de_pasajeros') String? passengersCapacityRaw,
      @JsonKey(name: 'capacidad_pasajeros_sentados')
      @IntFlexibleConverter()
      int? seatedPassengers,
      @JsonKey(name: 'n_mero_de_ejes') @IntFlexibleConverter() int? axles});
}

/// @nodoc
class __$RuntVehicleTechnicalDataCopyWithImpl<$Res>
    implements _$RuntVehicleTechnicalDataCopyWith<$Res> {
  __$RuntVehicleTechnicalDataCopyWithImpl(this._self, this._then);

  final _RuntVehicleTechnicalData _self;
  final $Res Function(_RuntVehicleTechnicalData) _then;

  /// Create a copy of RuntVehicleTechnicalData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? loadCapacityKg = freezed,
    Object? grossWeightKg = freezed,
    Object? passengersCapacityRaw = freezed,
    Object? seatedPassengers = freezed,
    Object? axles = freezed,
  }) {
    return _then(_RuntVehicleTechnicalData(
      loadCapacityKg: freezed == loadCapacityKg
          ? _self.loadCapacityKg
          : loadCapacityKg // ignore: cast_nullable_to_non_nullable
              as int?,
      grossWeightKg: freezed == grossWeightKg
          ? _self.grossWeightKg
          : grossWeightKg // ignore: cast_nullable_to_non_nullable
              as int?,
      passengersCapacityRaw: freezed == passengersCapacityRaw
          ? _self.passengersCapacityRaw
          : passengersCapacityRaw // ignore: cast_nullable_to_non_nullable
              as String?,
      seatedPassengers: freezed == seatedPassengers
          ? _self.seatedPassengers
          : seatedPassengers // ignore: cast_nullable_to_non_nullable
              as int?,
      axles: freezed == axles
          ? _self.axles
          : axles // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$RuntSoatRecord {
// CAMBIO CRÍTICO: El JSON trae int (ej: 94020727), convertimos a String
  @JsonKey(name: 'n_mero_de_p_liza')
  @StringFlexibleConverter()
  String? get policyNumber;
  @JsonKey(name: 'fecha_expedici_n')
  String? get issueDate;
  @JsonKey(name: 'fecha_inicio_de_vigencia')
  String? get validityStart;
  @JsonKey(name: 'fecha_fin_de_vigencia')
  String? get validityEnd;
  @JsonKey(name: 'entidad_expide_soat')
  String? get insurer;
  @JsonKey(name: 'c_digo_tarifa')
  @IntFlexibleConverter()
  int? get tariffCode;
  String? get estado;

  /// Create a copy of RuntSoatRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntSoatRecordCopyWith<RuntSoatRecord> get copyWith =>
      _$RuntSoatRecordCopyWithImpl<RuntSoatRecord>(
          this as RuntSoatRecord, _$identity);

  /// Serializes this RuntSoatRecord to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntSoatRecord &&
            (identical(other.policyNumber, policyNumber) ||
                other.policyNumber == policyNumber) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.validityStart, validityStart) ||
                other.validityStart == validityStart) &&
            (identical(other.validityEnd, validityEnd) ||
                other.validityEnd == validityEnd) &&
            (identical(other.insurer, insurer) || other.insurer == insurer) &&
            (identical(other.tariffCode, tariffCode) ||
                other.tariffCode == tariffCode) &&
            (identical(other.estado, estado) || other.estado == estado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, policyNumber, issueDate,
      validityStart, validityEnd, insurer, tariffCode, estado);

  @override
  String toString() {
    return 'RuntSoatRecord(policyNumber: $policyNumber, issueDate: $issueDate, validityStart: $validityStart, validityEnd: $validityEnd, insurer: $insurer, tariffCode: $tariffCode, estado: $estado)';
  }
}

/// @nodoc
abstract mixin class $RuntSoatRecordCopyWith<$Res> {
  factory $RuntSoatRecordCopyWith(
          RuntSoatRecord value, $Res Function(RuntSoatRecord) _then) =
      _$RuntSoatRecordCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'n_mero_de_p_liza')
      @StringFlexibleConverter()
      String? policyNumber,
      @JsonKey(name: 'fecha_expedici_n') String? issueDate,
      @JsonKey(name: 'fecha_inicio_de_vigencia') String? validityStart,
      @JsonKey(name: 'fecha_fin_de_vigencia') String? validityEnd,
      @JsonKey(name: 'entidad_expide_soat') String? insurer,
      @JsonKey(name: 'c_digo_tarifa') @IntFlexibleConverter() int? tariffCode,
      String? estado});
}

/// @nodoc
class _$RuntSoatRecordCopyWithImpl<$Res>
    implements $RuntSoatRecordCopyWith<$Res> {
  _$RuntSoatRecordCopyWithImpl(this._self, this._then);

  final RuntSoatRecord _self;
  final $Res Function(RuntSoatRecord) _then;

  /// Create a copy of RuntSoatRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? policyNumber = freezed,
    Object? issueDate = freezed,
    Object? validityStart = freezed,
    Object? validityEnd = freezed,
    Object? insurer = freezed,
    Object? tariffCode = freezed,
    Object? estado = freezed,
  }) {
    return _then(_self.copyWith(
      policyNumber: freezed == policyNumber
          ? _self.policyNumber
          : policyNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      validityStart: freezed == validityStart
          ? _self.validityStart
          : validityStart // ignore: cast_nullable_to_non_nullable
              as String?,
      validityEnd: freezed == validityEnd
          ? _self.validityEnd
          : validityEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      insurer: freezed == insurer
          ? _self.insurer
          : insurer // ignore: cast_nullable_to_non_nullable
              as String?,
      tariffCode: freezed == tariffCode
          ? _self.tariffCode
          : tariffCode // ignore: cast_nullable_to_non_nullable
              as int?,
      estado: freezed == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntSoatRecord].
extension RuntSoatRecordPatterns on RuntSoatRecord {
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
    TResult Function(_RuntSoatRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntSoatRecord() when $default != null:
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
    TResult Function(_RuntSoatRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntSoatRecord():
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
    TResult? Function(_RuntSoatRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntSoatRecord() when $default != null:
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
            @JsonKey(name: 'n_mero_de_p_liza')
            @StringFlexibleConverter()
            String? policyNumber,
            @JsonKey(name: 'fecha_expedici_n') String? issueDate,
            @JsonKey(name: 'fecha_inicio_de_vigencia') String? validityStart,
            @JsonKey(name: 'fecha_fin_de_vigencia') String? validityEnd,
            @JsonKey(name: 'entidad_expide_soat') String? insurer,
            @JsonKey(name: 'c_digo_tarifa')
            @IntFlexibleConverter()
            int? tariffCode,
            String? estado)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntSoatRecord() when $default != null:
        return $default(
            _that.policyNumber,
            _that.issueDate,
            _that.validityStart,
            _that.validityEnd,
            _that.insurer,
            _that.tariffCode,
            _that.estado);
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
            @JsonKey(name: 'n_mero_de_p_liza')
            @StringFlexibleConverter()
            String? policyNumber,
            @JsonKey(name: 'fecha_expedici_n') String? issueDate,
            @JsonKey(name: 'fecha_inicio_de_vigencia') String? validityStart,
            @JsonKey(name: 'fecha_fin_de_vigencia') String? validityEnd,
            @JsonKey(name: 'entidad_expide_soat') String? insurer,
            @JsonKey(name: 'c_digo_tarifa')
            @IntFlexibleConverter()
            int? tariffCode,
            String? estado)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntSoatRecord():
        return $default(
            _that.policyNumber,
            _that.issueDate,
            _that.validityStart,
            _that.validityEnd,
            _that.insurer,
            _that.tariffCode,
            _that.estado);
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
            @JsonKey(name: 'n_mero_de_p_liza')
            @StringFlexibleConverter()
            String? policyNumber,
            @JsonKey(name: 'fecha_expedici_n') String? issueDate,
            @JsonKey(name: 'fecha_inicio_de_vigencia') String? validityStart,
            @JsonKey(name: 'fecha_fin_de_vigencia') String? validityEnd,
            @JsonKey(name: 'entidad_expide_soat') String? insurer,
            @JsonKey(name: 'c_digo_tarifa')
            @IntFlexibleConverter()
            int? tariffCode,
            String? estado)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntSoatRecord() when $default != null:
        return $default(
            _that.policyNumber,
            _that.issueDate,
            _that.validityStart,
            _that.validityEnd,
            _that.insurer,
            _that.tariffCode,
            _that.estado);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntSoatRecord implements RuntSoatRecord {
  const _RuntSoatRecord(
      {@JsonKey(name: 'n_mero_de_p_liza')
      @StringFlexibleConverter()
      this.policyNumber,
      @JsonKey(name: 'fecha_expedici_n') this.issueDate,
      @JsonKey(name: 'fecha_inicio_de_vigencia') this.validityStart,
      @JsonKey(name: 'fecha_fin_de_vigencia') this.validityEnd,
      @JsonKey(name: 'entidad_expide_soat') this.insurer,
      @JsonKey(name: 'c_digo_tarifa') @IntFlexibleConverter() this.tariffCode,
      this.estado});
  factory _RuntSoatRecord.fromJson(Map<String, dynamic> json) =>
      _$RuntSoatRecordFromJson(json);

// CAMBIO CRÍTICO: El JSON trae int (ej: 94020727), convertimos a String
  @override
  @JsonKey(name: 'n_mero_de_p_liza')
  @StringFlexibleConverter()
  final String? policyNumber;
  @override
  @JsonKey(name: 'fecha_expedici_n')
  final String? issueDate;
  @override
  @JsonKey(name: 'fecha_inicio_de_vigencia')
  final String? validityStart;
  @override
  @JsonKey(name: 'fecha_fin_de_vigencia')
  final String? validityEnd;
  @override
  @JsonKey(name: 'entidad_expide_soat')
  final String? insurer;
  @override
  @JsonKey(name: 'c_digo_tarifa')
  @IntFlexibleConverter()
  final int? tariffCode;
  @override
  final String? estado;

  /// Create a copy of RuntSoatRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntSoatRecordCopyWith<_RuntSoatRecord> get copyWith =>
      __$RuntSoatRecordCopyWithImpl<_RuntSoatRecord>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntSoatRecordToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntSoatRecord &&
            (identical(other.policyNumber, policyNumber) ||
                other.policyNumber == policyNumber) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.validityStart, validityStart) ||
                other.validityStart == validityStart) &&
            (identical(other.validityEnd, validityEnd) ||
                other.validityEnd == validityEnd) &&
            (identical(other.insurer, insurer) || other.insurer == insurer) &&
            (identical(other.tariffCode, tariffCode) ||
                other.tariffCode == tariffCode) &&
            (identical(other.estado, estado) || other.estado == estado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, policyNumber, issueDate,
      validityStart, validityEnd, insurer, tariffCode, estado);

  @override
  String toString() {
    return 'RuntSoatRecord(policyNumber: $policyNumber, issueDate: $issueDate, validityStart: $validityStart, validityEnd: $validityEnd, insurer: $insurer, tariffCode: $tariffCode, estado: $estado)';
  }
}

/// @nodoc
abstract mixin class _$RuntSoatRecordCopyWith<$Res>
    implements $RuntSoatRecordCopyWith<$Res> {
  factory _$RuntSoatRecordCopyWith(
          _RuntSoatRecord value, $Res Function(_RuntSoatRecord) _then) =
      __$RuntSoatRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'n_mero_de_p_liza')
      @StringFlexibleConverter()
      String? policyNumber,
      @JsonKey(name: 'fecha_expedici_n') String? issueDate,
      @JsonKey(name: 'fecha_inicio_de_vigencia') String? validityStart,
      @JsonKey(name: 'fecha_fin_de_vigencia') String? validityEnd,
      @JsonKey(name: 'entidad_expide_soat') String? insurer,
      @JsonKey(name: 'c_digo_tarifa') @IntFlexibleConverter() int? tariffCode,
      String? estado});
}

/// @nodoc
class __$RuntSoatRecordCopyWithImpl<$Res>
    implements _$RuntSoatRecordCopyWith<$Res> {
  __$RuntSoatRecordCopyWithImpl(this._self, this._then);

  final _RuntSoatRecord _self;
  final $Res Function(_RuntSoatRecord) _then;

  /// Create a copy of RuntSoatRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? policyNumber = freezed,
    Object? issueDate = freezed,
    Object? validityStart = freezed,
    Object? validityEnd = freezed,
    Object? insurer = freezed,
    Object? tariffCode = freezed,
    Object? estado = freezed,
  }) {
    return _then(_RuntSoatRecord(
      policyNumber: freezed == policyNumber
          ? _self.policyNumber
          : policyNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      validityStart: freezed == validityStart
          ? _self.validityStart
          : validityStart // ignore: cast_nullable_to_non_nullable
              as String?,
      validityEnd: freezed == validityEnd
          ? _self.validityEnd
          : validityEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      insurer: freezed == insurer
          ? _self.insurer
          : insurer // ignore: cast_nullable_to_non_nullable
              as String?,
      tariffCode: freezed == tariffCode
          ? _self.tariffCode
          : tariffCode // ignore: cast_nullable_to_non_nullable
              as int?,
      estado: freezed == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$RuntRcInsuranceRecord {
// CAMBIO CRÍTICO: El JSON trae int (ej: 2000674202), convertimos a String
  @JsonKey(name: 'n_mero_de_p_liza')
  @StringFlexibleConverter()
  String? get policyNumber;
  @JsonKey(name: 'fecha_expedici_n')
  String? get issueDate;
  @JsonKey(name: 'fecha_inicio_de_vigencia')
  String? get validityStart;
  @JsonKey(name: 'fecha_fin_de_vigencia')
  String? get validityEnd;
  @JsonKey(name: 'entidad_que_expide')
  String? get insurer;
  @JsonKey(name: 'tipo_de_p_liza')
  String? get policyType;
  String? get estado;
  @JsonKey(name: 'detalle')
  String? get detail;

  /// Create a copy of RuntRcInsuranceRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntRcInsuranceRecordCopyWith<RuntRcInsuranceRecord> get copyWith =>
      _$RuntRcInsuranceRecordCopyWithImpl<RuntRcInsuranceRecord>(
          this as RuntRcInsuranceRecord, _$identity);

  /// Serializes this RuntRcInsuranceRecord to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntRcInsuranceRecord &&
            (identical(other.policyNumber, policyNumber) ||
                other.policyNumber == policyNumber) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.validityStart, validityStart) ||
                other.validityStart == validityStart) &&
            (identical(other.validityEnd, validityEnd) ||
                other.validityEnd == validityEnd) &&
            (identical(other.insurer, insurer) || other.insurer == insurer) &&
            (identical(other.policyType, policyType) ||
                other.policyType == policyType) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.detail, detail) || other.detail == detail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, policyNumber, issueDate,
      validityStart, validityEnd, insurer, policyType, estado, detail);

  @override
  String toString() {
    return 'RuntRcInsuranceRecord(policyNumber: $policyNumber, issueDate: $issueDate, validityStart: $validityStart, validityEnd: $validityEnd, insurer: $insurer, policyType: $policyType, estado: $estado, detail: $detail)';
  }
}

/// @nodoc
abstract mixin class $RuntRcInsuranceRecordCopyWith<$Res> {
  factory $RuntRcInsuranceRecordCopyWith(RuntRcInsuranceRecord value,
          $Res Function(RuntRcInsuranceRecord) _then) =
      _$RuntRcInsuranceRecordCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'n_mero_de_p_liza')
      @StringFlexibleConverter()
      String? policyNumber,
      @JsonKey(name: 'fecha_expedici_n') String? issueDate,
      @JsonKey(name: 'fecha_inicio_de_vigencia') String? validityStart,
      @JsonKey(name: 'fecha_fin_de_vigencia') String? validityEnd,
      @JsonKey(name: 'entidad_que_expide') String? insurer,
      @JsonKey(name: 'tipo_de_p_liza') String? policyType,
      String? estado,
      @JsonKey(name: 'detalle') String? detail});
}

/// @nodoc
class _$RuntRcInsuranceRecordCopyWithImpl<$Res>
    implements $RuntRcInsuranceRecordCopyWith<$Res> {
  _$RuntRcInsuranceRecordCopyWithImpl(this._self, this._then);

  final RuntRcInsuranceRecord _self;
  final $Res Function(RuntRcInsuranceRecord) _then;

  /// Create a copy of RuntRcInsuranceRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? policyNumber = freezed,
    Object? issueDate = freezed,
    Object? validityStart = freezed,
    Object? validityEnd = freezed,
    Object? insurer = freezed,
    Object? policyType = freezed,
    Object? estado = freezed,
    Object? detail = freezed,
  }) {
    return _then(_self.copyWith(
      policyNumber: freezed == policyNumber
          ? _self.policyNumber
          : policyNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      validityStart: freezed == validityStart
          ? _self.validityStart
          : validityStart // ignore: cast_nullable_to_non_nullable
              as String?,
      validityEnd: freezed == validityEnd
          ? _self.validityEnd
          : validityEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      insurer: freezed == insurer
          ? _self.insurer
          : insurer // ignore: cast_nullable_to_non_nullable
              as String?,
      policyType: freezed == policyType
          ? _self.policyType
          : policyType // ignore: cast_nullable_to_non_nullable
              as String?,
      estado: freezed == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String?,
      detail: freezed == detail
          ? _self.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntRcInsuranceRecord].
extension RuntRcInsuranceRecordPatterns on RuntRcInsuranceRecord {
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
    TResult Function(_RuntRcInsuranceRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntRcInsuranceRecord() when $default != null:
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
    TResult Function(_RuntRcInsuranceRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntRcInsuranceRecord():
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
    TResult? Function(_RuntRcInsuranceRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntRcInsuranceRecord() when $default != null:
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
            @JsonKey(name: 'n_mero_de_p_liza')
            @StringFlexibleConverter()
            String? policyNumber,
            @JsonKey(name: 'fecha_expedici_n') String? issueDate,
            @JsonKey(name: 'fecha_inicio_de_vigencia') String? validityStart,
            @JsonKey(name: 'fecha_fin_de_vigencia') String? validityEnd,
            @JsonKey(name: 'entidad_que_expide') String? insurer,
            @JsonKey(name: 'tipo_de_p_liza') String? policyType,
            String? estado,
            @JsonKey(name: 'detalle') String? detail)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntRcInsuranceRecord() when $default != null:
        return $default(
            _that.policyNumber,
            _that.issueDate,
            _that.validityStart,
            _that.validityEnd,
            _that.insurer,
            _that.policyType,
            _that.estado,
            _that.detail);
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
            @JsonKey(name: 'n_mero_de_p_liza')
            @StringFlexibleConverter()
            String? policyNumber,
            @JsonKey(name: 'fecha_expedici_n') String? issueDate,
            @JsonKey(name: 'fecha_inicio_de_vigencia') String? validityStart,
            @JsonKey(name: 'fecha_fin_de_vigencia') String? validityEnd,
            @JsonKey(name: 'entidad_que_expide') String? insurer,
            @JsonKey(name: 'tipo_de_p_liza') String? policyType,
            String? estado,
            @JsonKey(name: 'detalle') String? detail)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntRcInsuranceRecord():
        return $default(
            _that.policyNumber,
            _that.issueDate,
            _that.validityStart,
            _that.validityEnd,
            _that.insurer,
            _that.policyType,
            _that.estado,
            _that.detail);
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
            @JsonKey(name: 'n_mero_de_p_liza')
            @StringFlexibleConverter()
            String? policyNumber,
            @JsonKey(name: 'fecha_expedici_n') String? issueDate,
            @JsonKey(name: 'fecha_inicio_de_vigencia') String? validityStart,
            @JsonKey(name: 'fecha_fin_de_vigencia') String? validityEnd,
            @JsonKey(name: 'entidad_que_expide') String? insurer,
            @JsonKey(name: 'tipo_de_p_liza') String? policyType,
            String? estado,
            @JsonKey(name: 'detalle') String? detail)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntRcInsuranceRecord() when $default != null:
        return $default(
            _that.policyNumber,
            _that.issueDate,
            _that.validityStart,
            _that.validityEnd,
            _that.insurer,
            _that.policyType,
            _that.estado,
            _that.detail);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntRcInsuranceRecord implements RuntRcInsuranceRecord {
  const _RuntRcInsuranceRecord(
      {@JsonKey(name: 'n_mero_de_p_liza')
      @StringFlexibleConverter()
      this.policyNumber,
      @JsonKey(name: 'fecha_expedici_n') this.issueDate,
      @JsonKey(name: 'fecha_inicio_de_vigencia') this.validityStart,
      @JsonKey(name: 'fecha_fin_de_vigencia') this.validityEnd,
      @JsonKey(name: 'entidad_que_expide') this.insurer,
      @JsonKey(name: 'tipo_de_p_liza') this.policyType,
      this.estado,
      @JsonKey(name: 'detalle') this.detail});
  factory _RuntRcInsuranceRecord.fromJson(Map<String, dynamic> json) =>
      _$RuntRcInsuranceRecordFromJson(json);

// CAMBIO CRÍTICO: El JSON trae int (ej: 2000674202), convertimos a String
  @override
  @JsonKey(name: 'n_mero_de_p_liza')
  @StringFlexibleConverter()
  final String? policyNumber;
  @override
  @JsonKey(name: 'fecha_expedici_n')
  final String? issueDate;
  @override
  @JsonKey(name: 'fecha_inicio_de_vigencia')
  final String? validityStart;
  @override
  @JsonKey(name: 'fecha_fin_de_vigencia')
  final String? validityEnd;
  @override
  @JsonKey(name: 'entidad_que_expide')
  final String? insurer;
  @override
  @JsonKey(name: 'tipo_de_p_liza')
  final String? policyType;
  @override
  final String? estado;
  @override
  @JsonKey(name: 'detalle')
  final String? detail;

  /// Create a copy of RuntRcInsuranceRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntRcInsuranceRecordCopyWith<_RuntRcInsuranceRecord> get copyWith =>
      __$RuntRcInsuranceRecordCopyWithImpl<_RuntRcInsuranceRecord>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntRcInsuranceRecordToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntRcInsuranceRecord &&
            (identical(other.policyNumber, policyNumber) ||
                other.policyNumber == policyNumber) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.validityStart, validityStart) ||
                other.validityStart == validityStart) &&
            (identical(other.validityEnd, validityEnd) ||
                other.validityEnd == validityEnd) &&
            (identical(other.insurer, insurer) || other.insurer == insurer) &&
            (identical(other.policyType, policyType) ||
                other.policyType == policyType) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.detail, detail) || other.detail == detail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, policyNumber, issueDate,
      validityStart, validityEnd, insurer, policyType, estado, detail);

  @override
  String toString() {
    return 'RuntRcInsuranceRecord(policyNumber: $policyNumber, issueDate: $issueDate, validityStart: $validityStart, validityEnd: $validityEnd, insurer: $insurer, policyType: $policyType, estado: $estado, detail: $detail)';
  }
}

/// @nodoc
abstract mixin class _$RuntRcInsuranceRecordCopyWith<$Res>
    implements $RuntRcInsuranceRecordCopyWith<$Res> {
  factory _$RuntRcInsuranceRecordCopyWith(_RuntRcInsuranceRecord value,
          $Res Function(_RuntRcInsuranceRecord) _then) =
      __$RuntRcInsuranceRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'n_mero_de_p_liza')
      @StringFlexibleConverter()
      String? policyNumber,
      @JsonKey(name: 'fecha_expedici_n') String? issueDate,
      @JsonKey(name: 'fecha_inicio_de_vigencia') String? validityStart,
      @JsonKey(name: 'fecha_fin_de_vigencia') String? validityEnd,
      @JsonKey(name: 'entidad_que_expide') String? insurer,
      @JsonKey(name: 'tipo_de_p_liza') String? policyType,
      String? estado,
      @JsonKey(name: 'detalle') String? detail});
}

/// @nodoc
class __$RuntRcInsuranceRecordCopyWithImpl<$Res>
    implements _$RuntRcInsuranceRecordCopyWith<$Res> {
  __$RuntRcInsuranceRecordCopyWithImpl(this._self, this._then);

  final _RuntRcInsuranceRecord _self;
  final $Res Function(_RuntRcInsuranceRecord) _then;

  /// Create a copy of RuntRcInsuranceRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? policyNumber = freezed,
    Object? issueDate = freezed,
    Object? validityStart = freezed,
    Object? validityEnd = freezed,
    Object? insurer = freezed,
    Object? policyType = freezed,
    Object? estado = freezed,
    Object? detail = freezed,
  }) {
    return _then(_RuntRcInsuranceRecord(
      policyNumber: freezed == policyNumber
          ? _self.policyNumber
          : policyNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      validityStart: freezed == validityStart
          ? _self.validityStart
          : validityStart // ignore: cast_nullable_to_non_nullable
              as String?,
      validityEnd: freezed == validityEnd
          ? _self.validityEnd
          : validityEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      insurer: freezed == insurer
          ? _self.insurer
          : insurer // ignore: cast_nullable_to_non_nullable
              as String?,
      policyType: freezed == policyType
          ? _self.policyType
          : policyType // ignore: cast_nullable_to_non_nullable
              as String?,
      estado: freezed == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String?,
      detail: freezed == detail
          ? _self.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$RuntRtmRecord {
  @JsonKey(name: 'tipo_revisi_n')
  String? get revisionType;
  @JsonKey(name: 'fecha_expedici_n')
  String? get issueDate;
  @JsonKey(name: 'fecha_vigencia')
  String? get validityDate;
  @JsonKey(name: 'cda_expide_rtm')
  String? get cda;
  String? get vigente;
  @JsonKey(name: 'nro_certificado')
  @IntFlexibleConverter()
  int? get certificateNumber;
  @JsonKey(name: 'informaci_n_consistente')
  String? get informationConsistent;
  String? get acciones;

  /// Create a copy of RuntRtmRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntRtmRecordCopyWith<RuntRtmRecord> get copyWith =>
      _$RuntRtmRecordCopyWithImpl<RuntRtmRecord>(
          this as RuntRtmRecord, _$identity);

  /// Serializes this RuntRtmRecord to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntRtmRecord &&
            (identical(other.revisionType, revisionType) ||
                other.revisionType == revisionType) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.validityDate, validityDate) ||
                other.validityDate == validityDate) &&
            (identical(other.cda, cda) || other.cda == cda) &&
            (identical(other.vigente, vigente) || other.vigente == vigente) &&
            (identical(other.certificateNumber, certificateNumber) ||
                other.certificateNumber == certificateNumber) &&
            (identical(other.informationConsistent, informationConsistent) ||
                other.informationConsistent == informationConsistent) &&
            (identical(other.acciones, acciones) ||
                other.acciones == acciones));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      revisionType,
      issueDate,
      validityDate,
      cda,
      vigente,
      certificateNumber,
      informationConsistent,
      acciones);

  @override
  String toString() {
    return 'RuntRtmRecord(revisionType: $revisionType, issueDate: $issueDate, validityDate: $validityDate, cda: $cda, vigente: $vigente, certificateNumber: $certificateNumber, informationConsistent: $informationConsistent, acciones: $acciones)';
  }
}

/// @nodoc
abstract mixin class $RuntRtmRecordCopyWith<$Res> {
  factory $RuntRtmRecordCopyWith(
          RuntRtmRecord value, $Res Function(RuntRtmRecord) _then) =
      _$RuntRtmRecordCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'tipo_revisi_n') String? revisionType,
      @JsonKey(name: 'fecha_expedici_n') String? issueDate,
      @JsonKey(name: 'fecha_vigencia') String? validityDate,
      @JsonKey(name: 'cda_expide_rtm') String? cda,
      String? vigente,
      @JsonKey(name: 'nro_certificado')
      @IntFlexibleConverter()
      int? certificateNumber,
      @JsonKey(name: 'informaci_n_consistente') String? informationConsistent,
      String? acciones});
}

/// @nodoc
class _$RuntRtmRecordCopyWithImpl<$Res>
    implements $RuntRtmRecordCopyWith<$Res> {
  _$RuntRtmRecordCopyWithImpl(this._self, this._then);

  final RuntRtmRecord _self;
  final $Res Function(RuntRtmRecord) _then;

  /// Create a copy of RuntRtmRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? revisionType = freezed,
    Object? issueDate = freezed,
    Object? validityDate = freezed,
    Object? cda = freezed,
    Object? vigente = freezed,
    Object? certificateNumber = freezed,
    Object? informationConsistent = freezed,
    Object? acciones = freezed,
  }) {
    return _then(_self.copyWith(
      revisionType: freezed == revisionType
          ? _self.revisionType
          : revisionType // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      validityDate: freezed == validityDate
          ? _self.validityDate
          : validityDate // ignore: cast_nullable_to_non_nullable
              as String?,
      cda: freezed == cda
          ? _self.cda
          : cda // ignore: cast_nullable_to_non_nullable
              as String?,
      vigente: freezed == vigente
          ? _self.vigente
          : vigente // ignore: cast_nullable_to_non_nullable
              as String?,
      certificateNumber: freezed == certificateNumber
          ? _self.certificateNumber
          : certificateNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      informationConsistent: freezed == informationConsistent
          ? _self.informationConsistent
          : informationConsistent // ignore: cast_nullable_to_non_nullable
              as String?,
      acciones: freezed == acciones
          ? _self.acciones
          : acciones // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntRtmRecord].
extension RuntRtmRecordPatterns on RuntRtmRecord {
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
    TResult Function(_RuntRtmRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntRtmRecord() when $default != null:
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
    TResult Function(_RuntRtmRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntRtmRecord():
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
    TResult? Function(_RuntRtmRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntRtmRecord() when $default != null:
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
            @JsonKey(name: 'tipo_revisi_n') String? revisionType,
            @JsonKey(name: 'fecha_expedici_n') String? issueDate,
            @JsonKey(name: 'fecha_vigencia') String? validityDate,
            @JsonKey(name: 'cda_expide_rtm') String? cda,
            String? vigente,
            @JsonKey(name: 'nro_certificado')
            @IntFlexibleConverter()
            int? certificateNumber,
            @JsonKey(name: 'informaci_n_consistente')
            String? informationConsistent,
            String? acciones)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntRtmRecord() when $default != null:
        return $default(
            _that.revisionType,
            _that.issueDate,
            _that.validityDate,
            _that.cda,
            _that.vigente,
            _that.certificateNumber,
            _that.informationConsistent,
            _that.acciones);
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
            @JsonKey(name: 'tipo_revisi_n') String? revisionType,
            @JsonKey(name: 'fecha_expedici_n') String? issueDate,
            @JsonKey(name: 'fecha_vigencia') String? validityDate,
            @JsonKey(name: 'cda_expide_rtm') String? cda,
            String? vigente,
            @JsonKey(name: 'nro_certificado')
            @IntFlexibleConverter()
            int? certificateNumber,
            @JsonKey(name: 'informaci_n_consistente')
            String? informationConsistent,
            String? acciones)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntRtmRecord():
        return $default(
            _that.revisionType,
            _that.issueDate,
            _that.validityDate,
            _that.cda,
            _that.vigente,
            _that.certificateNumber,
            _that.informationConsistent,
            _that.acciones);
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
            @JsonKey(name: 'tipo_revisi_n') String? revisionType,
            @JsonKey(name: 'fecha_expedici_n') String? issueDate,
            @JsonKey(name: 'fecha_vigencia') String? validityDate,
            @JsonKey(name: 'cda_expide_rtm') String? cda,
            String? vigente,
            @JsonKey(name: 'nro_certificado')
            @IntFlexibleConverter()
            int? certificateNumber,
            @JsonKey(name: 'informaci_n_consistente')
            String? informationConsistent,
            String? acciones)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntRtmRecord() when $default != null:
        return $default(
            _that.revisionType,
            _that.issueDate,
            _that.validityDate,
            _that.cda,
            _that.vigente,
            _that.certificateNumber,
            _that.informationConsistent,
            _that.acciones);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntRtmRecord implements RuntRtmRecord {
  const _RuntRtmRecord(
      {@JsonKey(name: 'tipo_revisi_n') this.revisionType,
      @JsonKey(name: 'fecha_expedici_n') this.issueDate,
      @JsonKey(name: 'fecha_vigencia') this.validityDate,
      @JsonKey(name: 'cda_expide_rtm') this.cda,
      this.vigente,
      @JsonKey(name: 'nro_certificado')
      @IntFlexibleConverter()
      this.certificateNumber,
      @JsonKey(name: 'informaci_n_consistente') this.informationConsistent,
      this.acciones});
  factory _RuntRtmRecord.fromJson(Map<String, dynamic> json) =>
      _$RuntRtmRecordFromJson(json);

  @override
  @JsonKey(name: 'tipo_revisi_n')
  final String? revisionType;
  @override
  @JsonKey(name: 'fecha_expedici_n')
  final String? issueDate;
  @override
  @JsonKey(name: 'fecha_vigencia')
  final String? validityDate;
  @override
  @JsonKey(name: 'cda_expide_rtm')
  final String? cda;
  @override
  final String? vigente;
  @override
  @JsonKey(name: 'nro_certificado')
  @IntFlexibleConverter()
  final int? certificateNumber;
  @override
  @JsonKey(name: 'informaci_n_consistente')
  final String? informationConsistent;
  @override
  final String? acciones;

  /// Create a copy of RuntRtmRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntRtmRecordCopyWith<_RuntRtmRecord> get copyWith =>
      __$RuntRtmRecordCopyWithImpl<_RuntRtmRecord>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntRtmRecordToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntRtmRecord &&
            (identical(other.revisionType, revisionType) ||
                other.revisionType == revisionType) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.validityDate, validityDate) ||
                other.validityDate == validityDate) &&
            (identical(other.cda, cda) || other.cda == cda) &&
            (identical(other.vigente, vigente) || other.vigente == vigente) &&
            (identical(other.certificateNumber, certificateNumber) ||
                other.certificateNumber == certificateNumber) &&
            (identical(other.informationConsistent, informationConsistent) ||
                other.informationConsistent == informationConsistent) &&
            (identical(other.acciones, acciones) ||
                other.acciones == acciones));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      revisionType,
      issueDate,
      validityDate,
      cda,
      vigente,
      certificateNumber,
      informationConsistent,
      acciones);

  @override
  String toString() {
    return 'RuntRtmRecord(revisionType: $revisionType, issueDate: $issueDate, validityDate: $validityDate, cda: $cda, vigente: $vigente, certificateNumber: $certificateNumber, informationConsistent: $informationConsistent, acciones: $acciones)';
  }
}

/// @nodoc
abstract mixin class _$RuntRtmRecordCopyWith<$Res>
    implements $RuntRtmRecordCopyWith<$Res> {
  factory _$RuntRtmRecordCopyWith(
          _RuntRtmRecord value, $Res Function(_RuntRtmRecord) _then) =
      __$RuntRtmRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'tipo_revisi_n') String? revisionType,
      @JsonKey(name: 'fecha_expedici_n') String? issueDate,
      @JsonKey(name: 'fecha_vigencia') String? validityDate,
      @JsonKey(name: 'cda_expide_rtm') String? cda,
      String? vigente,
      @JsonKey(name: 'nro_certificado')
      @IntFlexibleConverter()
      int? certificateNumber,
      @JsonKey(name: 'informaci_n_consistente') String? informationConsistent,
      String? acciones});
}

/// @nodoc
class __$RuntRtmRecordCopyWithImpl<$Res>
    implements _$RuntRtmRecordCopyWith<$Res> {
  __$RuntRtmRecordCopyWithImpl(this._self, this._then);

  final _RuntRtmRecord _self;
  final $Res Function(_RuntRtmRecord) _then;

  /// Create a copy of RuntRtmRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? revisionType = freezed,
    Object? issueDate = freezed,
    Object? validityDate = freezed,
    Object? cda = freezed,
    Object? vigente = freezed,
    Object? certificateNumber = freezed,
    Object? informationConsistent = freezed,
    Object? acciones = freezed,
  }) {
    return _then(_RuntRtmRecord(
      revisionType: freezed == revisionType
          ? _self.revisionType
          : revisionType // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      validityDate: freezed == validityDate
          ? _self.validityDate
          : validityDate // ignore: cast_nullable_to_non_nullable
              as String?,
      cda: freezed == cda
          ? _self.cda
          : cda // ignore: cast_nullable_to_non_nullable
              as String?,
      vigente: freezed == vigente
          ? _self.vigente
          : vigente // ignore: cast_nullable_to_non_nullable
              as String?,
      certificateNumber: freezed == certificateNumber
          ? _self.certificateNumber
          : certificateNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      informationConsistent: freezed == informationConsistent
          ? _self.informationConsistent
          : informationConsistent // ignore: cast_nullable_to_non_nullable
              as String?,
      acciones: freezed == acciones
          ? _self.acciones
          : acciones // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$RuntOwnershipLimitation {
  @JsonKey(name: 'tipo_de_limitaci_n')
  String? get limitationType;
  @JsonKey(name: 'n_mero_de_oficio')
  @IntFlexibleConverter()
  int? get officeNumber;
  @JsonKey(name: 'entidad_jur_dica')
  String? get legalEntity;
  @JsonKey(name: 'departamento')
  String? get department;
  @JsonKey(name: 'municipio')
  String? get municipality;
  @JsonKey(name: 'fecha_de_expedici_n_del_oficio')
  String? get officeIssueDate;
  @JsonKey(name: 'fecha_de_registro_en_el_sistema')
  String? get systemRegistrationDate;

  /// Create a copy of RuntOwnershipLimitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntOwnershipLimitationCopyWith<RuntOwnershipLimitation> get copyWith =>
      _$RuntOwnershipLimitationCopyWithImpl<RuntOwnershipLimitation>(
          this as RuntOwnershipLimitation, _$identity);

  /// Serializes this RuntOwnershipLimitation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntOwnershipLimitation &&
            (identical(other.limitationType, limitationType) ||
                other.limitationType == limitationType) &&
            (identical(other.officeNumber, officeNumber) ||
                other.officeNumber == officeNumber) &&
            (identical(other.legalEntity, legalEntity) ||
                other.legalEntity == legalEntity) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.municipality, municipality) ||
                other.municipality == municipality) &&
            (identical(other.officeIssueDate, officeIssueDate) ||
                other.officeIssueDate == officeIssueDate) &&
            (identical(other.systemRegistrationDate, systemRegistrationDate) ||
                other.systemRegistrationDate == systemRegistrationDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      limitationType,
      officeNumber,
      legalEntity,
      department,
      municipality,
      officeIssueDate,
      systemRegistrationDate);

  @override
  String toString() {
    return 'RuntOwnershipLimitation(limitationType: $limitationType, officeNumber: $officeNumber, legalEntity: $legalEntity, department: $department, municipality: $municipality, officeIssueDate: $officeIssueDate, systemRegistrationDate: $systemRegistrationDate)';
  }
}

/// @nodoc
abstract mixin class $RuntOwnershipLimitationCopyWith<$Res> {
  factory $RuntOwnershipLimitationCopyWith(RuntOwnershipLimitation value,
          $Res Function(RuntOwnershipLimitation) _then) =
      _$RuntOwnershipLimitationCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'tipo_de_limitaci_n') String? limitationType,
      @JsonKey(name: 'n_mero_de_oficio')
      @IntFlexibleConverter()
      int? officeNumber,
      @JsonKey(name: 'entidad_jur_dica') String? legalEntity,
      @JsonKey(name: 'departamento') String? department,
      @JsonKey(name: 'municipio') String? municipality,
      @JsonKey(name: 'fecha_de_expedici_n_del_oficio') String? officeIssueDate,
      @JsonKey(name: 'fecha_de_registro_en_el_sistema')
      String? systemRegistrationDate});
}

/// @nodoc
class _$RuntOwnershipLimitationCopyWithImpl<$Res>
    implements $RuntOwnershipLimitationCopyWith<$Res> {
  _$RuntOwnershipLimitationCopyWithImpl(this._self, this._then);

  final RuntOwnershipLimitation _self;
  final $Res Function(RuntOwnershipLimitation) _then;

  /// Create a copy of RuntOwnershipLimitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? limitationType = freezed,
    Object? officeNumber = freezed,
    Object? legalEntity = freezed,
    Object? department = freezed,
    Object? municipality = freezed,
    Object? officeIssueDate = freezed,
    Object? systemRegistrationDate = freezed,
  }) {
    return _then(_self.copyWith(
      limitationType: freezed == limitationType
          ? _self.limitationType
          : limitationType // ignore: cast_nullable_to_non_nullable
              as String?,
      officeNumber: freezed == officeNumber
          ? _self.officeNumber
          : officeNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      legalEntity: freezed == legalEntity
          ? _self.legalEntity
          : legalEntity // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      municipality: freezed == municipality
          ? _self.municipality
          : municipality // ignore: cast_nullable_to_non_nullable
              as String?,
      officeIssueDate: freezed == officeIssueDate
          ? _self.officeIssueDate
          : officeIssueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      systemRegistrationDate: freezed == systemRegistrationDate
          ? _self.systemRegistrationDate
          : systemRegistrationDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntOwnershipLimitation].
extension RuntOwnershipLimitationPatterns on RuntOwnershipLimitation {
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
    TResult Function(_RuntOwnershipLimitation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntOwnershipLimitation() when $default != null:
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
    TResult Function(_RuntOwnershipLimitation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntOwnershipLimitation():
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
    TResult? Function(_RuntOwnershipLimitation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntOwnershipLimitation() when $default != null:
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
            @JsonKey(name: 'tipo_de_limitaci_n') String? limitationType,
            @JsonKey(name: 'n_mero_de_oficio')
            @IntFlexibleConverter()
            int? officeNumber,
            @JsonKey(name: 'entidad_jur_dica') String? legalEntity,
            @JsonKey(name: 'departamento') String? department,
            @JsonKey(name: 'municipio') String? municipality,
            @JsonKey(name: 'fecha_de_expedici_n_del_oficio')
            String? officeIssueDate,
            @JsonKey(name: 'fecha_de_registro_en_el_sistema')
            String? systemRegistrationDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntOwnershipLimitation() when $default != null:
        return $default(
            _that.limitationType,
            _that.officeNumber,
            _that.legalEntity,
            _that.department,
            _that.municipality,
            _that.officeIssueDate,
            _that.systemRegistrationDate);
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
            @JsonKey(name: 'tipo_de_limitaci_n') String? limitationType,
            @JsonKey(name: 'n_mero_de_oficio')
            @IntFlexibleConverter()
            int? officeNumber,
            @JsonKey(name: 'entidad_jur_dica') String? legalEntity,
            @JsonKey(name: 'departamento') String? department,
            @JsonKey(name: 'municipio') String? municipality,
            @JsonKey(name: 'fecha_de_expedici_n_del_oficio')
            String? officeIssueDate,
            @JsonKey(name: 'fecha_de_registro_en_el_sistema')
            String? systemRegistrationDate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntOwnershipLimitation():
        return $default(
            _that.limitationType,
            _that.officeNumber,
            _that.legalEntity,
            _that.department,
            _that.municipality,
            _that.officeIssueDate,
            _that.systemRegistrationDate);
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
            @JsonKey(name: 'tipo_de_limitaci_n') String? limitationType,
            @JsonKey(name: 'n_mero_de_oficio')
            @IntFlexibleConverter()
            int? officeNumber,
            @JsonKey(name: 'entidad_jur_dica') String? legalEntity,
            @JsonKey(name: 'departamento') String? department,
            @JsonKey(name: 'municipio') String? municipality,
            @JsonKey(name: 'fecha_de_expedici_n_del_oficio')
            String? officeIssueDate,
            @JsonKey(name: 'fecha_de_registro_en_el_sistema')
            String? systemRegistrationDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntOwnershipLimitation() when $default != null:
        return $default(
            _that.limitationType,
            _that.officeNumber,
            _that.legalEntity,
            _that.department,
            _that.municipality,
            _that.officeIssueDate,
            _that.systemRegistrationDate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntOwnershipLimitation implements RuntOwnershipLimitation {
  const _RuntOwnershipLimitation(
      {@JsonKey(name: 'tipo_de_limitaci_n') this.limitationType,
      @JsonKey(name: 'n_mero_de_oficio')
      @IntFlexibleConverter()
      this.officeNumber,
      @JsonKey(name: 'entidad_jur_dica') this.legalEntity,
      @JsonKey(name: 'departamento') this.department,
      @JsonKey(name: 'municipio') this.municipality,
      @JsonKey(name: 'fecha_de_expedici_n_del_oficio') this.officeIssueDate,
      @JsonKey(name: 'fecha_de_registro_en_el_sistema')
      this.systemRegistrationDate});
  factory _RuntOwnershipLimitation.fromJson(Map<String, dynamic> json) =>
      _$RuntOwnershipLimitationFromJson(json);

  @override
  @JsonKey(name: 'tipo_de_limitaci_n')
  final String? limitationType;
  @override
  @JsonKey(name: 'n_mero_de_oficio')
  @IntFlexibleConverter()
  final int? officeNumber;
  @override
  @JsonKey(name: 'entidad_jur_dica')
  final String? legalEntity;
  @override
  @JsonKey(name: 'departamento')
  final String? department;
  @override
  @JsonKey(name: 'municipio')
  final String? municipality;
  @override
  @JsonKey(name: 'fecha_de_expedici_n_del_oficio')
  final String? officeIssueDate;
  @override
  @JsonKey(name: 'fecha_de_registro_en_el_sistema')
  final String? systemRegistrationDate;

  /// Create a copy of RuntOwnershipLimitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntOwnershipLimitationCopyWith<_RuntOwnershipLimitation> get copyWith =>
      __$RuntOwnershipLimitationCopyWithImpl<_RuntOwnershipLimitation>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntOwnershipLimitationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntOwnershipLimitation &&
            (identical(other.limitationType, limitationType) ||
                other.limitationType == limitationType) &&
            (identical(other.officeNumber, officeNumber) ||
                other.officeNumber == officeNumber) &&
            (identical(other.legalEntity, legalEntity) ||
                other.legalEntity == legalEntity) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.municipality, municipality) ||
                other.municipality == municipality) &&
            (identical(other.officeIssueDate, officeIssueDate) ||
                other.officeIssueDate == officeIssueDate) &&
            (identical(other.systemRegistrationDate, systemRegistrationDate) ||
                other.systemRegistrationDate == systemRegistrationDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      limitationType,
      officeNumber,
      legalEntity,
      department,
      municipality,
      officeIssueDate,
      systemRegistrationDate);

  @override
  String toString() {
    return 'RuntOwnershipLimitation(limitationType: $limitationType, officeNumber: $officeNumber, legalEntity: $legalEntity, department: $department, municipality: $municipality, officeIssueDate: $officeIssueDate, systemRegistrationDate: $systemRegistrationDate)';
  }
}

/// @nodoc
abstract mixin class _$RuntOwnershipLimitationCopyWith<$Res>
    implements $RuntOwnershipLimitationCopyWith<$Res> {
  factory _$RuntOwnershipLimitationCopyWith(_RuntOwnershipLimitation value,
          $Res Function(_RuntOwnershipLimitation) _then) =
      __$RuntOwnershipLimitationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'tipo_de_limitaci_n') String? limitationType,
      @JsonKey(name: 'n_mero_de_oficio')
      @IntFlexibleConverter()
      int? officeNumber,
      @JsonKey(name: 'entidad_jur_dica') String? legalEntity,
      @JsonKey(name: 'departamento') String? department,
      @JsonKey(name: 'municipio') String? municipality,
      @JsonKey(name: 'fecha_de_expedici_n_del_oficio') String? officeIssueDate,
      @JsonKey(name: 'fecha_de_registro_en_el_sistema')
      String? systemRegistrationDate});
}

/// @nodoc
class __$RuntOwnershipLimitationCopyWithImpl<$Res>
    implements _$RuntOwnershipLimitationCopyWith<$Res> {
  __$RuntOwnershipLimitationCopyWithImpl(this._self, this._then);

  final _RuntOwnershipLimitation _self;
  final $Res Function(_RuntOwnershipLimitation) _then;

  /// Create a copy of RuntOwnershipLimitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? limitationType = freezed,
    Object? officeNumber = freezed,
    Object? legalEntity = freezed,
    Object? department = freezed,
    Object? municipality = freezed,
    Object? officeIssueDate = freezed,
    Object? systemRegistrationDate = freezed,
  }) {
    return _then(_RuntOwnershipLimitation(
      limitationType: freezed == limitationType
          ? _self.limitationType
          : limitationType // ignore: cast_nullable_to_non_nullable
              as String?,
      officeNumber: freezed == officeNumber
          ? _self.officeNumber
          : officeNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      legalEntity: freezed == legalEntity
          ? _self.legalEntity
          : legalEntity // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      municipality: freezed == municipality
          ? _self.municipality
          : municipality // ignore: cast_nullable_to_non_nullable
              as String?,
      officeIssueDate: freezed == officeIssueDate
          ? _self.officeIssueDate
          : officeIssueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      systemRegistrationDate: freezed == systemRegistrationDate
          ? _self.systemRegistrationDate
          : systemRegistrationDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$RuntWarranty {
  @JsonKey(name: 'identificaci_n_acreedor')
  String? get creditorId;
  @JsonKey(name: 'acreedor')
  String? get creditorName;
  @JsonKey(name: 'fecha_de_inscripci_n')
  String? get registrationDate;
  @JsonKey(name: 'patrimonio_aut_nomo')
  String? get autonomousPatrimony;
  @JsonKey(name: 'confec_maras')
  String? get confecamaras;

  /// Create a copy of RuntWarranty
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuntWarrantyCopyWith<RuntWarranty> get copyWith =>
      _$RuntWarrantyCopyWithImpl<RuntWarranty>(
          this as RuntWarranty, _$identity);

  /// Serializes this RuntWarranty to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuntWarranty &&
            (identical(other.creditorId, creditorId) ||
                other.creditorId == creditorId) &&
            (identical(other.creditorName, creditorName) ||
                other.creditorName == creditorName) &&
            (identical(other.registrationDate, registrationDate) ||
                other.registrationDate == registrationDate) &&
            (identical(other.autonomousPatrimony, autonomousPatrimony) ||
                other.autonomousPatrimony == autonomousPatrimony) &&
            (identical(other.confecamaras, confecamaras) ||
                other.confecamaras == confecamaras));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, creditorId, creditorName,
      registrationDate, autonomousPatrimony, confecamaras);

  @override
  String toString() {
    return 'RuntWarranty(creditorId: $creditorId, creditorName: $creditorName, registrationDate: $registrationDate, autonomousPatrimony: $autonomousPatrimony, confecamaras: $confecamaras)';
  }
}

/// @nodoc
abstract mixin class $RuntWarrantyCopyWith<$Res> {
  factory $RuntWarrantyCopyWith(
          RuntWarranty value, $Res Function(RuntWarranty) _then) =
      _$RuntWarrantyCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'identificaci_n_acreedor') String? creditorId,
      @JsonKey(name: 'acreedor') String? creditorName,
      @JsonKey(name: 'fecha_de_inscripci_n') String? registrationDate,
      @JsonKey(name: 'patrimonio_aut_nomo') String? autonomousPatrimony,
      @JsonKey(name: 'confec_maras') String? confecamaras});
}

/// @nodoc
class _$RuntWarrantyCopyWithImpl<$Res> implements $RuntWarrantyCopyWith<$Res> {
  _$RuntWarrantyCopyWithImpl(this._self, this._then);

  final RuntWarranty _self;
  final $Res Function(RuntWarranty) _then;

  /// Create a copy of RuntWarranty
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creditorId = freezed,
    Object? creditorName = freezed,
    Object? registrationDate = freezed,
    Object? autonomousPatrimony = freezed,
    Object? confecamaras = freezed,
  }) {
    return _then(_self.copyWith(
      creditorId: freezed == creditorId
          ? _self.creditorId
          : creditorId // ignore: cast_nullable_to_non_nullable
              as String?,
      creditorName: freezed == creditorName
          ? _self.creditorName
          : creditorName // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationDate: freezed == registrationDate
          ? _self.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as String?,
      autonomousPatrimony: freezed == autonomousPatrimony
          ? _self.autonomousPatrimony
          : autonomousPatrimony // ignore: cast_nullable_to_non_nullable
              as String?,
      confecamaras: freezed == confecamaras
          ? _self.confecamaras
          : confecamaras // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RuntWarranty].
extension RuntWarrantyPatterns on RuntWarranty {
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
    TResult Function(_RuntWarranty value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntWarranty() when $default != null:
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
    TResult Function(_RuntWarranty value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntWarranty():
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
    TResult? Function(_RuntWarranty value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntWarranty() when $default != null:
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
            @JsonKey(name: 'identificaci_n_acreedor') String? creditorId,
            @JsonKey(name: 'acreedor') String? creditorName,
            @JsonKey(name: 'fecha_de_inscripci_n') String? registrationDate,
            @JsonKey(name: 'patrimonio_aut_nomo') String? autonomousPatrimony,
            @JsonKey(name: 'confec_maras') String? confecamaras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RuntWarranty() when $default != null:
        return $default(
            _that.creditorId,
            _that.creditorName,
            _that.registrationDate,
            _that.autonomousPatrimony,
            _that.confecamaras);
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
            @JsonKey(name: 'identificaci_n_acreedor') String? creditorId,
            @JsonKey(name: 'acreedor') String? creditorName,
            @JsonKey(name: 'fecha_de_inscripci_n') String? registrationDate,
            @JsonKey(name: 'patrimonio_aut_nomo') String? autonomousPatrimony,
            @JsonKey(name: 'confec_maras') String? confecamaras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntWarranty():
        return $default(
            _that.creditorId,
            _that.creditorName,
            _that.registrationDate,
            _that.autonomousPatrimony,
            _that.confecamaras);
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
            @JsonKey(name: 'identificaci_n_acreedor') String? creditorId,
            @JsonKey(name: 'acreedor') String? creditorName,
            @JsonKey(name: 'fecha_de_inscripci_n') String? registrationDate,
            @JsonKey(name: 'patrimonio_aut_nomo') String? autonomousPatrimony,
            @JsonKey(name: 'confec_maras') String? confecamaras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RuntWarranty() when $default != null:
        return $default(
            _that.creditorId,
            _that.creditorName,
            _that.registrationDate,
            _that.autonomousPatrimony,
            _that.confecamaras);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RuntWarranty implements RuntWarranty {
  const _RuntWarranty(
      {@JsonKey(name: 'identificaci_n_acreedor') this.creditorId,
      @JsonKey(name: 'acreedor') this.creditorName,
      @JsonKey(name: 'fecha_de_inscripci_n') this.registrationDate,
      @JsonKey(name: 'patrimonio_aut_nomo') this.autonomousPatrimony,
      @JsonKey(name: 'confec_maras') this.confecamaras});
  factory _RuntWarranty.fromJson(Map<String, dynamic> json) =>
      _$RuntWarrantyFromJson(json);

  @override
  @JsonKey(name: 'identificaci_n_acreedor')
  final String? creditorId;
  @override
  @JsonKey(name: 'acreedor')
  final String? creditorName;
  @override
  @JsonKey(name: 'fecha_de_inscripci_n')
  final String? registrationDate;
  @override
  @JsonKey(name: 'patrimonio_aut_nomo')
  final String? autonomousPatrimony;
  @override
  @JsonKey(name: 'confec_maras')
  final String? confecamaras;

  /// Create a copy of RuntWarranty
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RuntWarrantyCopyWith<_RuntWarranty> get copyWith =>
      __$RuntWarrantyCopyWithImpl<_RuntWarranty>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RuntWarrantyToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RuntWarranty &&
            (identical(other.creditorId, creditorId) ||
                other.creditorId == creditorId) &&
            (identical(other.creditorName, creditorName) ||
                other.creditorName == creditorName) &&
            (identical(other.registrationDate, registrationDate) ||
                other.registrationDate == registrationDate) &&
            (identical(other.autonomousPatrimony, autonomousPatrimony) ||
                other.autonomousPatrimony == autonomousPatrimony) &&
            (identical(other.confecamaras, confecamaras) ||
                other.confecamaras == confecamaras));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, creditorId, creditorName,
      registrationDate, autonomousPatrimony, confecamaras);

  @override
  String toString() {
    return 'RuntWarranty(creditorId: $creditorId, creditorName: $creditorName, registrationDate: $registrationDate, autonomousPatrimony: $autonomousPatrimony, confecamaras: $confecamaras)';
  }
}

/// @nodoc
abstract mixin class _$RuntWarrantyCopyWith<$Res>
    implements $RuntWarrantyCopyWith<$Res> {
  factory _$RuntWarrantyCopyWith(
          _RuntWarranty value, $Res Function(_RuntWarranty) _then) =
      __$RuntWarrantyCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'identificaci_n_acreedor') String? creditorId,
      @JsonKey(name: 'acreedor') String? creditorName,
      @JsonKey(name: 'fecha_de_inscripci_n') String? registrationDate,
      @JsonKey(name: 'patrimonio_aut_nomo') String? autonomousPatrimony,
      @JsonKey(name: 'confec_maras') String? confecamaras});
}

/// @nodoc
class __$RuntWarrantyCopyWithImpl<$Res>
    implements _$RuntWarrantyCopyWith<$Res> {
  __$RuntWarrantyCopyWithImpl(this._self, this._then);

  final _RuntWarranty _self;
  final $Res Function(_RuntWarranty) _then;

  /// Create a copy of RuntWarranty
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? creditorId = freezed,
    Object? creditorName = freezed,
    Object? registrationDate = freezed,
    Object? autonomousPatrimony = freezed,
    Object? confecamaras = freezed,
  }) {
    return _then(_RuntWarranty(
      creditorId: freezed == creditorId
          ? _self.creditorId
          : creditorId // ignore: cast_nullable_to_non_nullable
              as String?,
      creditorName: freezed == creditorName
          ? _self.creditorName
          : creditorName // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationDate: freezed == registrationDate
          ? _self.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as String?,
      autonomousPatrimony: freezed == autonomousPatrimony
          ? _self.autonomousPatrimony
          : autonomousPatrimony // ignore: cast_nullable_to_non_nullable
              as String?,
      confecamaras: freezed == confecamaras
          ? _self.confecamaras
          : confecamaras // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
