// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CountryEntity {
  String get id; // ISO-3166 alpha-2
  String get name;
  String get iso3;
  String? get phoneCode;
  String? get timezone;
  String? get currencyCode;
  String? get currencySymbol;
  String? get taxName;
  double? get taxRateDefault;
  List<String> get documentTypes;
  String? get plateFormatRegex;
  List<String> get nationalHolidays; // YYYY-MM-DD
  bool get isActive;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of CountryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CountryEntityCopyWith<CountryEntity> get copyWith =>
      _$CountryEntityCopyWithImpl<CountryEntity>(
          this as CountryEntity, _$identity);

  /// Serializes this CountryEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CountryEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iso3, iso3) || other.iso3 == iso3) &&
            (identical(other.phoneCode, phoneCode) ||
                other.phoneCode == phoneCode) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.taxName, taxName) || other.taxName == taxName) &&
            (identical(other.taxRateDefault, taxRateDefault) ||
                other.taxRateDefault == taxRateDefault) &&
            const DeepCollectionEquality()
                .equals(other.documentTypes, documentTypes) &&
            (identical(other.plateFormatRegex, plateFormatRegex) ||
                other.plateFormatRegex == plateFormatRegex) &&
            const DeepCollectionEquality()
                .equals(other.nationalHolidays, nationalHolidays) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      iso3,
      phoneCode,
      timezone,
      currencyCode,
      currencySymbol,
      taxName,
      taxRateDefault,
      const DeepCollectionEquality().hash(documentTypes),
      plateFormatRegex,
      const DeepCollectionEquality().hash(nationalHolidays),
      isActive,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'CountryEntity(id: $id, name: $name, iso3: $iso3, phoneCode: $phoneCode, timezone: $timezone, currencyCode: $currencyCode, currencySymbol: $currencySymbol, taxName: $taxName, taxRateDefault: $taxRateDefault, documentTypes: $documentTypes, plateFormatRegex: $plateFormatRegex, nationalHolidays: $nationalHolidays, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $CountryEntityCopyWith<$Res> {
  factory $CountryEntityCopyWith(
          CountryEntity value, $Res Function(CountryEntity) _then) =
      _$CountryEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String iso3,
      String? phoneCode,
      String? timezone,
      String? currencyCode,
      String? currencySymbol,
      String? taxName,
      double? taxRateDefault,
      List<String> documentTypes,
      String? plateFormatRegex,
      List<String> nationalHolidays,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$CountryEntityCopyWithImpl<$Res>
    implements $CountryEntityCopyWith<$Res> {
  _$CountryEntityCopyWithImpl(this._self, this._then);

  final CountryEntity _self;
  final $Res Function(CountryEntity) _then;

  /// Create a copy of CountryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iso3 = null,
    Object? phoneCode = freezed,
    Object? timezone = freezed,
    Object? currencyCode = freezed,
    Object? currencySymbol = freezed,
    Object? taxName = freezed,
    Object? taxRateDefault = freezed,
    Object? documentTypes = null,
    Object? plateFormatRegex = freezed,
    Object? nationalHolidays = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iso3: null == iso3
          ? _self.iso3
          : iso3 // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCode: freezed == phoneCode
          ? _self.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _self.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: freezed == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: freezed == currencySymbol
          ? _self.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      taxName: freezed == taxName
          ? _self.taxName
          : taxName // ignore: cast_nullable_to_non_nullable
              as String?,
      taxRateDefault: freezed == taxRateDefault
          ? _self.taxRateDefault
          : taxRateDefault // ignore: cast_nullable_to_non_nullable
              as double?,
      documentTypes: null == documentTypes
          ? _self.documentTypes
          : documentTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      plateFormatRegex: freezed == plateFormatRegex
          ? _self.plateFormatRegex
          : plateFormatRegex // ignore: cast_nullable_to_non_nullable
              as String?,
      nationalHolidays: null == nationalHolidays
          ? _self.nationalHolidays
          : nationalHolidays // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CountryEntity].
extension CountryEntityPatterns on CountryEntity {
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
    TResult Function(_CountryEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CountryEntity() when $default != null:
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
    TResult Function(_CountryEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CountryEntity():
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
    TResult? Function(_CountryEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CountryEntity() when $default != null:
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
            String name,
            String iso3,
            String? phoneCode,
            String? timezone,
            String? currencyCode,
            String? currencySymbol,
            String? taxName,
            double? taxRateDefault,
            List<String> documentTypes,
            String? plateFormatRegex,
            List<String> nationalHolidays,
            bool isActive,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CountryEntity() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.iso3,
            _that.phoneCode,
            _that.timezone,
            _that.currencyCode,
            _that.currencySymbol,
            _that.taxName,
            _that.taxRateDefault,
            _that.documentTypes,
            _that.plateFormatRegex,
            _that.nationalHolidays,
            _that.isActive,
            _that.createdAt,
            _that.updatedAt);
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
            String name,
            String iso3,
            String? phoneCode,
            String? timezone,
            String? currencyCode,
            String? currencySymbol,
            String? taxName,
            double? taxRateDefault,
            List<String> documentTypes,
            String? plateFormatRegex,
            List<String> nationalHolidays,
            bool isActive,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CountryEntity():
        return $default(
            _that.id,
            _that.name,
            _that.iso3,
            _that.phoneCode,
            _that.timezone,
            _that.currencyCode,
            _that.currencySymbol,
            _that.taxName,
            _that.taxRateDefault,
            _that.documentTypes,
            _that.plateFormatRegex,
            _that.nationalHolidays,
            _that.isActive,
            _that.createdAt,
            _that.updatedAt);
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
            String name,
            String iso3,
            String? phoneCode,
            String? timezone,
            String? currencyCode,
            String? currencySymbol,
            String? taxName,
            double? taxRateDefault,
            List<String> documentTypes,
            String? plateFormatRegex,
            List<String> nationalHolidays,
            bool isActive,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CountryEntity() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.iso3,
            _that.phoneCode,
            _that.timezone,
            _that.currencyCode,
            _that.currencySymbol,
            _that.taxName,
            _that.taxRateDefault,
            _that.documentTypes,
            _that.plateFormatRegex,
            _that.nationalHolidays,
            _that.isActive,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CountryEntity implements CountryEntity {
  const _CountryEntity(
      {required this.id,
      required this.name,
      required this.iso3,
      this.phoneCode,
      this.timezone,
      this.currencyCode,
      this.currencySymbol,
      this.taxName,
      this.taxRateDefault,
      final List<String> documentTypes = const <String>[],
      this.plateFormatRegex,
      final List<String> nationalHolidays = const <String>[],
      this.isActive = true,
      this.createdAt,
      this.updatedAt})
      : _documentTypes = documentTypes,
        _nationalHolidays = nationalHolidays;
  factory _CountryEntity.fromJson(Map<String, dynamic> json) =>
      _$CountryEntityFromJson(json);

  @override
  final String id;
// ISO-3166 alpha-2
  @override
  final String name;
  @override
  final String iso3;
  @override
  final String? phoneCode;
  @override
  final String? timezone;
  @override
  final String? currencyCode;
  @override
  final String? currencySymbol;
  @override
  final String? taxName;
  @override
  final double? taxRateDefault;
  final List<String> _documentTypes;
  @override
  @JsonKey()
  List<String> get documentTypes {
    if (_documentTypes is EqualUnmodifiableListView) return _documentTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documentTypes);
  }

  @override
  final String? plateFormatRegex;
  final List<String> _nationalHolidays;
  @override
  @JsonKey()
  List<String> get nationalHolidays {
    if (_nationalHolidays is EqualUnmodifiableListView)
      return _nationalHolidays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nationalHolidays);
  }

// YYYY-MM-DD
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of CountryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CountryEntityCopyWith<_CountryEntity> get copyWith =>
      __$CountryEntityCopyWithImpl<_CountryEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CountryEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CountryEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iso3, iso3) || other.iso3 == iso3) &&
            (identical(other.phoneCode, phoneCode) ||
                other.phoneCode == phoneCode) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.taxName, taxName) || other.taxName == taxName) &&
            (identical(other.taxRateDefault, taxRateDefault) ||
                other.taxRateDefault == taxRateDefault) &&
            const DeepCollectionEquality()
                .equals(other._documentTypes, _documentTypes) &&
            (identical(other.plateFormatRegex, plateFormatRegex) ||
                other.plateFormatRegex == plateFormatRegex) &&
            const DeepCollectionEquality()
                .equals(other._nationalHolidays, _nationalHolidays) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      iso3,
      phoneCode,
      timezone,
      currencyCode,
      currencySymbol,
      taxName,
      taxRateDefault,
      const DeepCollectionEquality().hash(_documentTypes),
      plateFormatRegex,
      const DeepCollectionEquality().hash(_nationalHolidays),
      isActive,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'CountryEntity(id: $id, name: $name, iso3: $iso3, phoneCode: $phoneCode, timezone: $timezone, currencyCode: $currencyCode, currencySymbol: $currencySymbol, taxName: $taxName, taxRateDefault: $taxRateDefault, documentTypes: $documentTypes, plateFormatRegex: $plateFormatRegex, nationalHolidays: $nationalHolidays, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$CountryEntityCopyWith<$Res>
    implements $CountryEntityCopyWith<$Res> {
  factory _$CountryEntityCopyWith(
          _CountryEntity value, $Res Function(_CountryEntity) _then) =
      __$CountryEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String iso3,
      String? phoneCode,
      String? timezone,
      String? currencyCode,
      String? currencySymbol,
      String? taxName,
      double? taxRateDefault,
      List<String> documentTypes,
      String? plateFormatRegex,
      List<String> nationalHolidays,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$CountryEntityCopyWithImpl<$Res>
    implements _$CountryEntityCopyWith<$Res> {
  __$CountryEntityCopyWithImpl(this._self, this._then);

  final _CountryEntity _self;
  final $Res Function(_CountryEntity) _then;

  /// Create a copy of CountryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iso3 = null,
    Object? phoneCode = freezed,
    Object? timezone = freezed,
    Object? currencyCode = freezed,
    Object? currencySymbol = freezed,
    Object? taxName = freezed,
    Object? taxRateDefault = freezed,
    Object? documentTypes = null,
    Object? plateFormatRegex = freezed,
    Object? nationalHolidays = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_CountryEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iso3: null == iso3
          ? _self.iso3
          : iso3 // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCode: freezed == phoneCode
          ? _self.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _self.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: freezed == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: freezed == currencySymbol
          ? _self.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      taxName: freezed == taxName
          ? _self.taxName
          : taxName // ignore: cast_nullable_to_non_nullable
              as String?,
      taxRateDefault: freezed == taxRateDefault
          ? _self.taxRateDefault
          : taxRateDefault // ignore: cast_nullable_to_non_nullable
              as double?,
      documentTypes: null == documentTypes
          ? _self._documentTypes
          : documentTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      plateFormatRegex: freezed == plateFormatRegex
          ? _self.plateFormatRegex
          : plateFormatRegex // ignore: cast_nullable_to_non_nullable
              as String?,
      nationalHolidays: null == nationalHolidays
          ? _self._nationalHolidays
          : nationalHolidays // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
