// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geo_coord.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeoCoord {
  double get lat;
  double get lng;

  /// Create a copy of GeoCoord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GeoCoordCopyWith<GeoCoord> get copyWith =>
      _$GeoCoordCopyWithImpl<GeoCoord>(this as GeoCoord, _$identity);

  /// Serializes this GeoCoord to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GeoCoord &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lng);

  @override
  String toString() {
    return 'GeoCoord(lat: $lat, lng: $lng)';
  }
}

/// @nodoc
abstract mixin class $GeoCoordCopyWith<$Res> {
  factory $GeoCoordCopyWith(GeoCoord value, $Res Function(GeoCoord) _then) =
      _$GeoCoordCopyWithImpl;
  @useResult
  $Res call({double lat, double lng});
}

/// @nodoc
class _$GeoCoordCopyWithImpl<$Res> implements $GeoCoordCopyWith<$Res> {
  _$GeoCoordCopyWithImpl(this._self, this._then);

  final GeoCoord _self;
  final $Res Function(GeoCoord) _then;

  /// Create a copy of GeoCoord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_self.copyWith(
      lat: null == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [GeoCoord].
extension GeoCoordPatterns on GeoCoord {
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
    TResult Function(_GeoCoord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GeoCoord() when $default != null:
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
    TResult Function(_GeoCoord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GeoCoord():
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
    TResult? Function(_GeoCoord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GeoCoord() when $default != null:
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
    TResult Function(double lat, double lng)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GeoCoord() when $default != null:
        return $default(_that.lat, _that.lng);
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
    TResult Function(double lat, double lng) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GeoCoord():
        return $default(_that.lat, _that.lng);
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
    TResult? Function(double lat, double lng)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GeoCoord() when $default != null:
        return $default(_that.lat, _that.lng);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GeoCoord implements GeoCoord {
  const _GeoCoord({required this.lat, required this.lng});
  factory _GeoCoord.fromJson(Map<String, dynamic> json) =>
      _$GeoCoordFromJson(json);

  @override
  final double lat;
  @override
  final double lng;

  /// Create a copy of GeoCoord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GeoCoordCopyWith<_GeoCoord> get copyWith =>
      __$GeoCoordCopyWithImpl<_GeoCoord>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GeoCoordToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GeoCoord &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lng);

  @override
  String toString() {
    return 'GeoCoord(lat: $lat, lng: $lng)';
  }
}

/// @nodoc
abstract mixin class _$GeoCoordCopyWith<$Res>
    implements $GeoCoordCopyWith<$Res> {
  factory _$GeoCoordCopyWith(_GeoCoord value, $Res Function(_GeoCoord) _then) =
      __$GeoCoordCopyWithImpl;
  @override
  @useResult
  $Res call({double lat, double lng});
}

/// @nodoc
class __$GeoCoordCopyWithImpl<$Res> implements _$GeoCoordCopyWith<$Res> {
  __$GeoCoordCopyWithImpl(this._self, this._then);

  final _GeoCoord _self;
  final $Res Function(_GeoCoord) _then;

  /// Create a copy of GeoCoord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_GeoCoord(
      lat: null == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
