// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_programming_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MaintenanceProgrammingEntity {
  String get id;
  String get orgId;
  String get assetId;
  List<String> get incidenciasIds;
  List<DateTime> get programmingDates;
  String? get assignedToTechId;
  String? get notes;
  String? get cityId;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of MaintenanceProgrammingEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MaintenanceProgrammingEntityCopyWith<MaintenanceProgrammingEntity>
      get copyWith => _$MaintenanceProgrammingEntityCopyWithImpl<
              MaintenanceProgrammingEntity>(
          this as MaintenanceProgrammingEntity, _$identity);

  /// Serializes this MaintenanceProgrammingEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MaintenanceProgrammingEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            const DeepCollectionEquality()
                .equals(other.incidenciasIds, incidenciasIds) &&
            const DeepCollectionEquality()
                .equals(other.programmingDates, programmingDates) &&
            (identical(other.assignedToTechId, assignedToTechId) ||
                other.assignedToTechId == assignedToTechId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
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
      orgId,
      assetId,
      const DeepCollectionEquality().hash(incidenciasIds),
      const DeepCollectionEquality().hash(programmingDates),
      assignedToTechId,
      notes,
      cityId,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'MaintenanceProgrammingEntity(id: $id, orgId: $orgId, assetId: $assetId, incidenciasIds: $incidenciasIds, programmingDates: $programmingDates, assignedToTechId: $assignedToTechId, notes: $notes, cityId: $cityId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $MaintenanceProgrammingEntityCopyWith<$Res> {
  factory $MaintenanceProgrammingEntityCopyWith(
          MaintenanceProgrammingEntity value,
          $Res Function(MaintenanceProgrammingEntity) _then) =
      _$MaintenanceProgrammingEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String assetId,
      List<String> incidenciasIds,
      List<DateTime> programmingDates,
      String? assignedToTechId,
      String? notes,
      String? cityId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$MaintenanceProgrammingEntityCopyWithImpl<$Res>
    implements $MaintenanceProgrammingEntityCopyWith<$Res> {
  _$MaintenanceProgrammingEntityCopyWithImpl(this._self, this._then);

  final MaintenanceProgrammingEntity _self;
  final $Res Function(MaintenanceProgrammingEntity) _then;

  /// Create a copy of MaintenanceProgrammingEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetId = null,
    Object? incidenciasIds = null,
    Object? programmingDates = null,
    Object? assignedToTechId = freezed,
    Object? notes = freezed,
    Object? cityId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      incidenciasIds: null == incidenciasIds
          ? _self.incidenciasIds
          : incidenciasIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      programmingDates: null == programmingDates
          ? _self.programmingDates
          : programmingDates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      assignedToTechId: freezed == assignedToTechId
          ? _self.assignedToTechId
          : assignedToTechId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [MaintenanceProgrammingEntity].
extension MaintenanceProgrammingEntityPatterns on MaintenanceProgrammingEntity {
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
    TResult Function(_MaintenanceProgrammingEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MaintenanceProgrammingEntity() when $default != null:
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
    TResult Function(_MaintenanceProgrammingEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MaintenanceProgrammingEntity():
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
    TResult? Function(_MaintenanceProgrammingEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MaintenanceProgrammingEntity() when $default != null:
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
            String orgId,
            String assetId,
            List<String> incidenciasIds,
            List<DateTime> programmingDates,
            String? assignedToTechId,
            String? notes,
            String? cityId,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MaintenanceProgrammingEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.incidenciasIds,
            _that.programmingDates,
            _that.assignedToTechId,
            _that.notes,
            _that.cityId,
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
            String orgId,
            String assetId,
            List<String> incidenciasIds,
            List<DateTime> programmingDates,
            String? assignedToTechId,
            String? notes,
            String? cityId,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MaintenanceProgrammingEntity():
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.incidenciasIds,
            _that.programmingDates,
            _that.assignedToTechId,
            _that.notes,
            _that.cityId,
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
            String orgId,
            String assetId,
            List<String> incidenciasIds,
            List<DateTime> programmingDates,
            String? assignedToTechId,
            String? notes,
            String? cityId,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MaintenanceProgrammingEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.incidenciasIds,
            _that.programmingDates,
            _that.assignedToTechId,
            _that.notes,
            _that.cityId,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MaintenanceProgrammingEntity implements MaintenanceProgrammingEntity {
  const _MaintenanceProgrammingEntity(
      {required this.id,
      required this.orgId,
      required this.assetId,
      final List<String> incidenciasIds = const <String>[],
      final List<DateTime> programmingDates = const <DateTime>[],
      this.assignedToTechId,
      this.notes,
      this.cityId,
      this.createdAt,
      this.updatedAt})
      : _incidenciasIds = incidenciasIds,
        _programmingDates = programmingDates;
  factory _MaintenanceProgrammingEntity.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceProgrammingEntityFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String assetId;
  final List<String> _incidenciasIds;
  @override
  @JsonKey()
  List<String> get incidenciasIds {
    if (_incidenciasIds is EqualUnmodifiableListView) return _incidenciasIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incidenciasIds);
  }

  final List<DateTime> _programmingDates;
  @override
  @JsonKey()
  List<DateTime> get programmingDates {
    if (_programmingDates is EqualUnmodifiableListView)
      return _programmingDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_programmingDates);
  }

  @override
  final String? assignedToTechId;
  @override
  final String? notes;
  @override
  final String? cityId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of MaintenanceProgrammingEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MaintenanceProgrammingEntityCopyWith<_MaintenanceProgrammingEntity>
      get copyWith => __$MaintenanceProgrammingEntityCopyWithImpl<
          _MaintenanceProgrammingEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MaintenanceProgrammingEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MaintenanceProgrammingEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            const DeepCollectionEquality()
                .equals(other._incidenciasIds, _incidenciasIds) &&
            const DeepCollectionEquality()
                .equals(other._programmingDates, _programmingDates) &&
            (identical(other.assignedToTechId, assignedToTechId) ||
                other.assignedToTechId == assignedToTechId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
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
      orgId,
      assetId,
      const DeepCollectionEquality().hash(_incidenciasIds),
      const DeepCollectionEquality().hash(_programmingDates),
      assignedToTechId,
      notes,
      cityId,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'MaintenanceProgrammingEntity(id: $id, orgId: $orgId, assetId: $assetId, incidenciasIds: $incidenciasIds, programmingDates: $programmingDates, assignedToTechId: $assignedToTechId, notes: $notes, cityId: $cityId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$MaintenanceProgrammingEntityCopyWith<$Res>
    implements $MaintenanceProgrammingEntityCopyWith<$Res> {
  factory _$MaintenanceProgrammingEntityCopyWith(
          _MaintenanceProgrammingEntity value,
          $Res Function(_MaintenanceProgrammingEntity) _then) =
      __$MaintenanceProgrammingEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String assetId,
      List<String> incidenciasIds,
      List<DateTime> programmingDates,
      String? assignedToTechId,
      String? notes,
      String? cityId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$MaintenanceProgrammingEntityCopyWithImpl<$Res>
    implements _$MaintenanceProgrammingEntityCopyWith<$Res> {
  __$MaintenanceProgrammingEntityCopyWithImpl(this._self, this._then);

  final _MaintenanceProgrammingEntity _self;
  final $Res Function(_MaintenanceProgrammingEntity) _then;

  /// Create a copy of MaintenanceProgrammingEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetId = null,
    Object? incidenciasIds = null,
    Object? programmingDates = null,
    Object? assignedToTechId = freezed,
    Object? notes = freezed,
    Object? cityId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_MaintenanceProgrammingEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      incidenciasIds: null == incidenciasIds
          ? _self._incidenciasIds
          : incidenciasIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      programmingDates: null == programmingDates
          ? _self._programmingDates
          : programmingDates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      assignedToTechId: freezed == assignedToTechId
          ? _self.assignedToTechId
          : assignedToTechId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
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
