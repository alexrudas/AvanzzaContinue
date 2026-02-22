// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quantitative_limit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
QuantitativeLimit _$QuantitativeLimitFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'unlimited':
      return QuantitativeLimitUnlimited.fromJson(json);
    case 'limited':
      return QuantitativeLimitLimited.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'QuantitativeLimit',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$QuantitativeLimit {
  /// Serializes this QuantitativeLimit to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is QuantitativeLimit);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'QuantitativeLimit()';
  }
}

/// @nodoc
class $QuantitativeLimitCopyWith<$Res> {
  $QuantitativeLimitCopyWith(
      QuantitativeLimit _, $Res Function(QuantitativeLimit) __);
}

/// Adds pattern-matching-related methods to [QuantitativeLimit].
extension QuantitativeLimitPatterns on QuantitativeLimit {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QuantitativeLimitUnlimited value)? unlimited,
    TResult Function(QuantitativeLimitLimited value)? limited,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case QuantitativeLimitUnlimited() when unlimited != null:
        return unlimited(_that);
      case QuantitativeLimitLimited() when limited != null:
        return limited(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(QuantitativeLimitUnlimited value) unlimited,
    required TResult Function(QuantitativeLimitLimited value) limited,
  }) {
    final _that = this;
    switch (_that) {
      case QuantitativeLimitUnlimited():
        return unlimited(_that);
      case QuantitativeLimitLimited():
        return limited(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QuantitativeLimitUnlimited value)? unlimited,
    TResult? Function(QuantitativeLimitLimited value)? limited,
  }) {
    final _that = this;
    switch (_that) {
      case QuantitativeLimitUnlimited() when unlimited != null:
        return unlimited(_that);
      case QuantitativeLimitLimited() when limited != null:
        return limited(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unlimited,
    TResult Function(int value)? limited,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case QuantitativeLimitUnlimited() when unlimited != null:
        return unlimited();
      case QuantitativeLimitLimited() when limited != null:
        return limited(_that.value);
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
  TResult when<TResult extends Object?>({
    required TResult Function() unlimited,
    required TResult Function(int value) limited,
  }) {
    final _that = this;
    switch (_that) {
      case QuantitativeLimitUnlimited():
        return unlimited();
      case QuantitativeLimitLimited():
        return limited(_that.value);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unlimited,
    TResult? Function(int value)? limited,
  }) {
    final _that = this;
    switch (_that) {
      case QuantitativeLimitUnlimited() when unlimited != null:
        return unlimited();
      case QuantitativeLimitLimited() when limited != null:
        return limited(_that.value);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class QuantitativeLimitUnlimited extends QuantitativeLimit {
  const QuantitativeLimitUnlimited({final String? $type})
      : $type = $type ?? 'unlimited',
        super._();
  factory QuantitativeLimitUnlimited.fromJson(Map<String, dynamic> json) =>
      _$QuantitativeLimitUnlimitedFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$QuantitativeLimitUnlimitedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QuantitativeLimitUnlimited);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'QuantitativeLimit.unlimited()';
  }
}

/// @nodoc
@JsonSerializable()
class QuantitativeLimitLimited extends QuantitativeLimit {
  const QuantitativeLimitLimited(this.value, {final String? $type})
      : assert(value >= 0, 'El límite no puede ser negativo.'),
        $type = $type ?? 'limited',
        super._();
  factory QuantitativeLimitLimited.fromJson(Map<String, dynamic> json) =>
      _$QuantitativeLimitLimitedFromJson(json);

  final int value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of QuantitativeLimit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QuantitativeLimitLimitedCopyWith<QuantitativeLimitLimited> get copyWith =>
      _$QuantitativeLimitLimitedCopyWithImpl<QuantitativeLimitLimited>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$QuantitativeLimitLimitedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QuantitativeLimitLimited &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'QuantitativeLimit.limited(value: $value)';
  }
}

/// @nodoc
abstract mixin class $QuantitativeLimitLimitedCopyWith<$Res>
    implements $QuantitativeLimitCopyWith<$Res> {
  factory $QuantitativeLimitLimitedCopyWith(QuantitativeLimitLimited value,
          $Res Function(QuantitativeLimitLimited) _then) =
      _$QuantitativeLimitLimitedCopyWithImpl;
  @useResult
  $Res call({int value});
}

/// @nodoc
class _$QuantitativeLimitLimitedCopyWithImpl<$Res>
    implements $QuantitativeLimitLimitedCopyWith<$Res> {
  _$QuantitativeLimitLimitedCopyWithImpl(this._self, this._then);

  final QuantitativeLimitLimited _self;
  final $Res Function(QuantitativeLimitLimited) _then;

  /// Create a copy of QuantitativeLimit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
  }) {
    return _then(QuantitativeLimitLimited(
      null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
