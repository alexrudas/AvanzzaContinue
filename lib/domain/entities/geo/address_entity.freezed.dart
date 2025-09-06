// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddressEntity {
  String get countryId;
  String? get regionId;
  String? get cityId;
  String get line1;
  String? get line2;
  String? get postalCode;
  double? get lat;
  double? get lng;

  /// Create a copy of AddressEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddressEntityCopyWith<AddressEntity> get copyWith =>
      _$AddressEntityCopyWithImpl<AddressEntity>(
          this as AddressEntity, _$identity);

  /// Serializes this AddressEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddressEntity &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.line1, line1) || other.line1 == line1) &&
            (identical(other.line2, line2) || other.line2 == line2) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, countryId, regionId, cityId,
      line1, line2, postalCode, lat, lng);

  @override
  String toString() {
    return 'AddressEntity(countryId: $countryId, regionId: $regionId, cityId: $cityId, line1: $line1, line2: $line2, postalCode: $postalCode, lat: $lat, lng: $lng)';
  }
}

/// @nodoc
abstract mixin class $AddressEntityCopyWith<$Res> {
  factory $AddressEntityCopyWith(
          AddressEntity value, $Res Function(AddressEntity) _then) =
      _$AddressEntityCopyWithImpl;
  @useResult
  $Res call(
      {String countryId,
      String? regionId,
      String? cityId,
      String line1,
      String? line2,
      String? postalCode,
      double? lat,
      double? lng});
}

/// @nodoc
class _$AddressEntityCopyWithImpl<$Res>
    implements $AddressEntityCopyWith<$Res> {
  _$AddressEntityCopyWithImpl(this._self, this._then);

  final AddressEntity _self;
  final $Res Function(AddressEntity) _then;

  /// Create a copy of AddressEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countryId = null,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? line1 = null,
    Object? line2 = freezed,
    Object? postalCode = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(_self.copyWith(
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      regionId: freezed == regionId
          ? _self.regionId
          : regionId // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      line1: null == line1
          ? _self.line1
          : line1 // ignore: cast_nullable_to_non_nullable
              as String,
      line2: freezed == line2
          ? _self.line2
          : line2 // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _self.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AddressEntity].
extension AddressEntityPatterns on AddressEntity {
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
    TResult Function(_AddressEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddressEntity() when $default != null:
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
    TResult Function(_AddressEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddressEntity():
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
    TResult? Function(_AddressEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddressEntity() when $default != null:
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
            String countryId,
            String? regionId,
            String? cityId,
            String line1,
            String? line2,
            String? postalCode,
            double? lat,
            double? lng)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddressEntity() when $default != null:
        return $default(_that.countryId, _that.regionId, _that.cityId,
            _that.line1, _that.line2, _that.postalCode, _that.lat, _that.lng);
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
            String countryId,
            String? regionId,
            String? cityId,
            String line1,
            String? line2,
            String? postalCode,
            double? lat,
            double? lng)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddressEntity():
        return $default(_that.countryId, _that.regionId, _that.cityId,
            _that.line1, _that.line2, _that.postalCode, _that.lat, _that.lng);
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
            String countryId,
            String? regionId,
            String? cityId,
            String line1,
            String? line2,
            String? postalCode,
            double? lat,
            double? lng)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddressEntity() when $default != null:
        return $default(_that.countryId, _that.regionId, _that.cityId,
            _that.line1, _that.line2, _that.postalCode, _that.lat, _that.lng);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AddressEntity implements AddressEntity {
  const _AddressEntity(
      {required this.countryId,
      this.regionId,
      this.cityId,
      required this.line1,
      this.line2,
      this.postalCode,
      this.lat,
      this.lng});
  factory _AddressEntity.fromJson(Map<String, dynamic> json) =>
      _$AddressEntityFromJson(json);

  @override
  final String countryId;
  @override
  final String? regionId;
  @override
  final String? cityId;
  @override
  final String line1;
  @override
  final String? line2;
  @override
  final String? postalCode;
  @override
  final double? lat;
  @override
  final double? lng;

  /// Create a copy of AddressEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddressEntityCopyWith<_AddressEntity> get copyWith =>
      __$AddressEntityCopyWithImpl<_AddressEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AddressEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddressEntity &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.line1, line1) || other.line1 == line1) &&
            (identical(other.line2, line2) || other.line2 == line2) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, countryId, regionId, cityId,
      line1, line2, postalCode, lat, lng);

  @override
  String toString() {
    return 'AddressEntity(countryId: $countryId, regionId: $regionId, cityId: $cityId, line1: $line1, line2: $line2, postalCode: $postalCode, lat: $lat, lng: $lng)';
  }
}

/// @nodoc
abstract mixin class _$AddressEntityCopyWith<$Res>
    implements $AddressEntityCopyWith<$Res> {
  factory _$AddressEntityCopyWith(
          _AddressEntity value, $Res Function(_AddressEntity) _then) =
      __$AddressEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String countryId,
      String? regionId,
      String? cityId,
      String line1,
      String? line2,
      String? postalCode,
      double? lat,
      double? lng});
}

/// @nodoc
class __$AddressEntityCopyWithImpl<$Res>
    implements _$AddressEntityCopyWith<$Res> {
  __$AddressEntityCopyWithImpl(this._self, this._then);

  final _AddressEntity _self;
  final $Res Function(_AddressEntity) _then;

  /// Create a copy of AddressEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? countryId = null,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? line1 = null,
    Object? line2 = freezed,
    Object? postalCode = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(_AddressEntity(
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      regionId: freezed == regionId
          ? _self.regionId
          : regionId // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      line1: null == line1
          ? _self.line1
          : line1 // ignore: cast_nullable_to_non_nullable
              as String,
      line2: freezed == line2
          ? _self.line2
          : line2 // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _self.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

// dart format on
