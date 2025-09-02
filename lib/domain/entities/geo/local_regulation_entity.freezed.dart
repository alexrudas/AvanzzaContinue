// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_regulation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PicoYPlacaRule {
  int get dayOfWeek; // 1=Mon .. 7=Sun
  List<String> get digitsRestricted;
  String get startTime; // HH:mm
  String get endTime; // HH:mm
  String? get notes;

  /// Create a copy of PicoYPlacaRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PicoYPlacaRuleCopyWith<PicoYPlacaRule> get copyWith =>
      _$PicoYPlacaRuleCopyWithImpl<PicoYPlacaRule>(
          this as PicoYPlacaRule, _$identity);

  /// Serializes this PicoYPlacaRule to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PicoYPlacaRule &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            const DeepCollectionEquality()
                .equals(other.digitsRestricted, digitsRestricted) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dayOfWeek,
      const DeepCollectionEquality().hash(digitsRestricted),
      startTime,
      endTime,
      notes);

  @override
  String toString() {
    return 'PicoYPlacaRule(dayOfWeek: $dayOfWeek, digitsRestricted: $digitsRestricted, startTime: $startTime, endTime: $endTime, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class $PicoYPlacaRuleCopyWith<$Res> {
  factory $PicoYPlacaRuleCopyWith(
          PicoYPlacaRule value, $Res Function(PicoYPlacaRule) _then) =
      _$PicoYPlacaRuleCopyWithImpl;
  @useResult
  $Res call(
      {int dayOfWeek,
      List<String> digitsRestricted,
      String startTime,
      String endTime,
      String? notes});
}

/// @nodoc
class _$PicoYPlacaRuleCopyWithImpl<$Res>
    implements $PicoYPlacaRuleCopyWith<$Res> {
  _$PicoYPlacaRuleCopyWithImpl(this._self, this._then);

  final PicoYPlacaRule _self;
  final $Res Function(PicoYPlacaRule) _then;

  /// Create a copy of PicoYPlacaRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? digitsRestricted = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? notes = freezed,
  }) {
    return _then(_self.copyWith(
      dayOfWeek: null == dayOfWeek
          ? _self.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      digitsRestricted: null == digitsRestricted
          ? _self.digitsRestricted
          : digitsRestricted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PicoYPlacaRule].
extension PicoYPlacaRulePatterns on PicoYPlacaRule {
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
    TResult Function(_PicoYPlacaRule value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PicoYPlacaRule() when $default != null:
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
    TResult Function(_PicoYPlacaRule value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PicoYPlacaRule():
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
    TResult? Function(_PicoYPlacaRule value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PicoYPlacaRule() when $default != null:
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
    TResult Function(int dayOfWeek, List<String> digitsRestricted,
            String startTime, String endTime, String? notes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PicoYPlacaRule() when $default != null:
        return $default(_that.dayOfWeek, _that.digitsRestricted,
            _that.startTime, _that.endTime, _that.notes);
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
    TResult Function(int dayOfWeek, List<String> digitsRestricted,
            String startTime, String endTime, String? notes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PicoYPlacaRule():
        return $default(_that.dayOfWeek, _that.digitsRestricted,
            _that.startTime, _that.endTime, _that.notes);
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
    TResult? Function(int dayOfWeek, List<String> digitsRestricted,
            String startTime, String endTime, String? notes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PicoYPlacaRule() when $default != null:
        return $default(_that.dayOfWeek, _that.digitsRestricted,
            _that.startTime, _that.endTime, _that.notes);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PicoYPlacaRule implements PicoYPlacaRule {
  const _PicoYPlacaRule(
      {required this.dayOfWeek,
      final List<String> digitsRestricted = const <String>[],
      required this.startTime,
      required this.endTime,
      this.notes})
      : _digitsRestricted = digitsRestricted;
  factory _PicoYPlacaRule.fromJson(Map<String, dynamic> json) =>
      _$PicoYPlacaRuleFromJson(json);

  @override
  final int dayOfWeek;
// 1=Mon .. 7=Sun
  final List<String> _digitsRestricted;
// 1=Mon .. 7=Sun
  @override
  @JsonKey()
  List<String> get digitsRestricted {
    if (_digitsRestricted is EqualUnmodifiableListView)
      return _digitsRestricted;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_digitsRestricted);
  }

  @override
  final String startTime;
// HH:mm
  @override
  final String endTime;
// HH:mm
  @override
  final String? notes;

  /// Create a copy of PicoYPlacaRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PicoYPlacaRuleCopyWith<_PicoYPlacaRule> get copyWith =>
      __$PicoYPlacaRuleCopyWithImpl<_PicoYPlacaRule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PicoYPlacaRuleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PicoYPlacaRule &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            const DeepCollectionEquality()
                .equals(other._digitsRestricted, _digitsRestricted) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dayOfWeek,
      const DeepCollectionEquality().hash(_digitsRestricted),
      startTime,
      endTime,
      notes);

  @override
  String toString() {
    return 'PicoYPlacaRule(dayOfWeek: $dayOfWeek, digitsRestricted: $digitsRestricted, startTime: $startTime, endTime: $endTime, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class _$PicoYPlacaRuleCopyWith<$Res>
    implements $PicoYPlacaRuleCopyWith<$Res> {
  factory _$PicoYPlacaRuleCopyWith(
          _PicoYPlacaRule value, $Res Function(_PicoYPlacaRule) _then) =
      __$PicoYPlacaRuleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int dayOfWeek,
      List<String> digitsRestricted,
      String startTime,
      String endTime,
      String? notes});
}

/// @nodoc
class __$PicoYPlacaRuleCopyWithImpl<$Res>
    implements _$PicoYPlacaRuleCopyWith<$Res> {
  __$PicoYPlacaRuleCopyWithImpl(this._self, this._then);

  final _PicoYPlacaRule _self;
  final $Res Function(_PicoYPlacaRule) _then;

  /// Create a copy of PicoYPlacaRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dayOfWeek = null,
    Object? digitsRestricted = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? notes = freezed,
  }) {
    return _then(_PicoYPlacaRule(
      dayOfWeek: null == dayOfWeek
          ? _self.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      digitsRestricted: null == digitsRestricted
          ? _self._digitsRestricted
          : digitsRestricted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$LocalRegulationEntity {
  String get id;
  String get countryId;
  String get cityId;
  List<PicoYPlacaRule> get picoYPlacaRules;
  List<String> get circulationExceptions;
  List<String> get maintenanceBlackoutDates; // YYYY-MM-DD
  String get updatedBy;
  String? get sourceUrl;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of LocalRegulationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocalRegulationEntityCopyWith<LocalRegulationEntity> get copyWith =>
      _$LocalRegulationEntityCopyWithImpl<LocalRegulationEntity>(
          this as LocalRegulationEntity, _$identity);

  /// Serializes this LocalRegulationEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocalRegulationEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            const DeepCollectionEquality()
                .equals(other.picoYPlacaRules, picoYPlacaRules) &&
            const DeepCollectionEquality()
                .equals(other.circulationExceptions, circulationExceptions) &&
            const DeepCollectionEquality().equals(
                other.maintenanceBlackoutDates, maintenanceBlackoutDates) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.sourceUrl, sourceUrl) ||
                other.sourceUrl == sourceUrl) &&
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
      countryId,
      cityId,
      const DeepCollectionEquality().hash(picoYPlacaRules),
      const DeepCollectionEquality().hash(circulationExceptions),
      const DeepCollectionEquality().hash(maintenanceBlackoutDates),
      updatedBy,
      sourceUrl,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'LocalRegulationEntity(id: $id, countryId: $countryId, cityId: $cityId, picoYPlacaRules: $picoYPlacaRules, circulationExceptions: $circulationExceptions, maintenanceBlackoutDates: $maintenanceBlackoutDates, updatedBy: $updatedBy, sourceUrl: $sourceUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $LocalRegulationEntityCopyWith<$Res> {
  factory $LocalRegulationEntityCopyWith(LocalRegulationEntity value,
          $Res Function(LocalRegulationEntity) _then) =
      _$LocalRegulationEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String countryId,
      String cityId,
      List<PicoYPlacaRule> picoYPlacaRules,
      List<String> circulationExceptions,
      List<String> maintenanceBlackoutDates,
      String updatedBy,
      String? sourceUrl,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$LocalRegulationEntityCopyWithImpl<$Res>
    implements $LocalRegulationEntityCopyWith<$Res> {
  _$LocalRegulationEntityCopyWithImpl(this._self, this._then);

  final LocalRegulationEntity _self;
  final $Res Function(LocalRegulationEntity) _then;

  /// Create a copy of LocalRegulationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? countryId = null,
    Object? cityId = null,
    Object? picoYPlacaRules = null,
    Object? circulationExceptions = null,
    Object? maintenanceBlackoutDates = null,
    Object? updatedBy = null,
    Object? sourceUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      cityId: null == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String,
      picoYPlacaRules: null == picoYPlacaRules
          ? _self.picoYPlacaRules
          : picoYPlacaRules // ignore: cast_nullable_to_non_nullable
              as List<PicoYPlacaRule>,
      circulationExceptions: null == circulationExceptions
          ? _self.circulationExceptions
          : circulationExceptions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maintenanceBlackoutDates: null == maintenanceBlackoutDates
          ? _self.maintenanceBlackoutDates
          : maintenanceBlackoutDates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedBy: null == updatedBy
          ? _self.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String,
      sourceUrl: freezed == sourceUrl
          ? _self.sourceUrl
          : sourceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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

/// Adds pattern-matching-related methods to [LocalRegulationEntity].
extension LocalRegulationEntityPatterns on LocalRegulationEntity {
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
    TResult Function(_LocalRegulationEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocalRegulationEntity() when $default != null:
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
    TResult Function(_LocalRegulationEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalRegulationEntity():
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
    TResult? Function(_LocalRegulationEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalRegulationEntity() when $default != null:
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
            String countryId,
            String cityId,
            List<PicoYPlacaRule> picoYPlacaRules,
            List<String> circulationExceptions,
            List<String> maintenanceBlackoutDates,
            String updatedBy,
            String? sourceUrl,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocalRegulationEntity() when $default != null:
        return $default(
            _that.id,
            _that.countryId,
            _that.cityId,
            _that.picoYPlacaRules,
            _that.circulationExceptions,
            _that.maintenanceBlackoutDates,
            _that.updatedBy,
            _that.sourceUrl,
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
            String countryId,
            String cityId,
            List<PicoYPlacaRule> picoYPlacaRules,
            List<String> circulationExceptions,
            List<String> maintenanceBlackoutDates,
            String updatedBy,
            String? sourceUrl,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalRegulationEntity():
        return $default(
            _that.id,
            _that.countryId,
            _that.cityId,
            _that.picoYPlacaRules,
            _that.circulationExceptions,
            _that.maintenanceBlackoutDates,
            _that.updatedBy,
            _that.sourceUrl,
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
            String countryId,
            String cityId,
            List<PicoYPlacaRule> picoYPlacaRules,
            List<String> circulationExceptions,
            List<String> maintenanceBlackoutDates,
            String updatedBy,
            String? sourceUrl,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalRegulationEntity() when $default != null:
        return $default(
            _that.id,
            _that.countryId,
            _that.cityId,
            _that.picoYPlacaRules,
            _that.circulationExceptions,
            _that.maintenanceBlackoutDates,
            _that.updatedBy,
            _that.sourceUrl,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _LocalRegulationEntity implements LocalRegulationEntity {
  const _LocalRegulationEntity(
      {required this.id,
      required this.countryId,
      required this.cityId,
      final List<PicoYPlacaRule> picoYPlacaRules = const <PicoYPlacaRule>[],
      final List<String> circulationExceptions = const <String>[],
      final List<String> maintenanceBlackoutDates = const <String>[],
      required this.updatedBy,
      this.sourceUrl,
      this.createdAt,
      this.updatedAt})
      : _picoYPlacaRules = picoYPlacaRules,
        _circulationExceptions = circulationExceptions,
        _maintenanceBlackoutDates = maintenanceBlackoutDates;
  factory _LocalRegulationEntity.fromJson(Map<String, dynamic> json) =>
      _$LocalRegulationEntityFromJson(json);

  @override
  final String id;
  @override
  final String countryId;
  @override
  final String cityId;
  final List<PicoYPlacaRule> _picoYPlacaRules;
  @override
  @JsonKey()
  List<PicoYPlacaRule> get picoYPlacaRules {
    if (_picoYPlacaRules is EqualUnmodifiableListView) return _picoYPlacaRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_picoYPlacaRules);
  }

  final List<String> _circulationExceptions;
  @override
  @JsonKey()
  List<String> get circulationExceptions {
    if (_circulationExceptions is EqualUnmodifiableListView)
      return _circulationExceptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_circulationExceptions);
  }

  final List<String> _maintenanceBlackoutDates;
  @override
  @JsonKey()
  List<String> get maintenanceBlackoutDates {
    if (_maintenanceBlackoutDates is EqualUnmodifiableListView)
      return _maintenanceBlackoutDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_maintenanceBlackoutDates);
  }

// YYYY-MM-DD
  @override
  final String updatedBy;
  @override
  final String? sourceUrl;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of LocalRegulationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LocalRegulationEntityCopyWith<_LocalRegulationEntity> get copyWith =>
      __$LocalRegulationEntityCopyWithImpl<_LocalRegulationEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LocalRegulationEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalRegulationEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            const DeepCollectionEquality()
                .equals(other._picoYPlacaRules, _picoYPlacaRules) &&
            const DeepCollectionEquality()
                .equals(other._circulationExceptions, _circulationExceptions) &&
            const DeepCollectionEquality().equals(
                other._maintenanceBlackoutDates, _maintenanceBlackoutDates) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.sourceUrl, sourceUrl) ||
                other.sourceUrl == sourceUrl) &&
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
      countryId,
      cityId,
      const DeepCollectionEquality().hash(_picoYPlacaRules),
      const DeepCollectionEquality().hash(_circulationExceptions),
      const DeepCollectionEquality().hash(_maintenanceBlackoutDates),
      updatedBy,
      sourceUrl,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'LocalRegulationEntity(id: $id, countryId: $countryId, cityId: $cityId, picoYPlacaRules: $picoYPlacaRules, circulationExceptions: $circulationExceptions, maintenanceBlackoutDates: $maintenanceBlackoutDates, updatedBy: $updatedBy, sourceUrl: $sourceUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$LocalRegulationEntityCopyWith<$Res>
    implements $LocalRegulationEntityCopyWith<$Res> {
  factory _$LocalRegulationEntityCopyWith(_LocalRegulationEntity value,
          $Res Function(_LocalRegulationEntity) _then) =
      __$LocalRegulationEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String countryId,
      String cityId,
      List<PicoYPlacaRule> picoYPlacaRules,
      List<String> circulationExceptions,
      List<String> maintenanceBlackoutDates,
      String updatedBy,
      String? sourceUrl,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$LocalRegulationEntityCopyWithImpl<$Res>
    implements _$LocalRegulationEntityCopyWith<$Res> {
  __$LocalRegulationEntityCopyWithImpl(this._self, this._then);

  final _LocalRegulationEntity _self;
  final $Res Function(_LocalRegulationEntity) _then;

  /// Create a copy of LocalRegulationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? countryId = null,
    Object? cityId = null,
    Object? picoYPlacaRules = null,
    Object? circulationExceptions = null,
    Object? maintenanceBlackoutDates = null,
    Object? updatedBy = null,
    Object? sourceUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_LocalRegulationEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      cityId: null == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String,
      picoYPlacaRules: null == picoYPlacaRules
          ? _self._picoYPlacaRules
          : picoYPlacaRules // ignore: cast_nullable_to_non_nullable
              as List<PicoYPlacaRule>,
      circulationExceptions: null == circulationExceptions
          ? _self._circulationExceptions
          : circulationExceptions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maintenanceBlackoutDates: null == maintenanceBlackoutDates
          ? _self._maintenanceBlackoutDates
          : maintenanceBlackoutDates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedBy: null == updatedBy
          ? _self.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String,
      sourceUrl: freezed == sourceUrl
          ? _self.sourceUrl
          : sourceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
