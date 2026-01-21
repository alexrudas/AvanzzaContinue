// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PortfolioEntity {
  String get id;
  PortfolioType get portfolioType;
  String get portfolioName;
  String get countryId;
  String get cityId;
  PortfolioStatus get status;
  int get assetsCount;
  String get createdBy;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of PortfolioEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PortfolioEntityCopyWith<PortfolioEntity> get copyWith =>
      _$PortfolioEntityCopyWithImpl<PortfolioEntity>(
          this as PortfolioEntity, _$identity);

  /// Serializes this PortfolioEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PortfolioEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.portfolioType, portfolioType) ||
                other.portfolioType == portfolioType) &&
            (identical(other.portfolioName, portfolioName) ||
                other.portfolioName == portfolioName) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assetsCount, assetsCount) ||
                other.assetsCount == assetsCount) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, portfolioType, portfolioName,
      countryId, cityId, status, assetsCount, createdBy, createdAt, updatedAt);

  @override
  String toString() {
    return 'PortfolioEntity(id: $id, portfolioType: $portfolioType, portfolioName: $portfolioName, countryId: $countryId, cityId: $cityId, status: $status, assetsCount: $assetsCount, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $PortfolioEntityCopyWith<$Res> {
  factory $PortfolioEntityCopyWith(
          PortfolioEntity value, $Res Function(PortfolioEntity) _then) =
      _$PortfolioEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      PortfolioType portfolioType,
      String portfolioName,
      String countryId,
      String cityId,
      PortfolioStatus status,
      int assetsCount,
      String createdBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$PortfolioEntityCopyWithImpl<$Res>
    implements $PortfolioEntityCopyWith<$Res> {
  _$PortfolioEntityCopyWithImpl(this._self, this._then);

  final PortfolioEntity _self;
  final $Res Function(PortfolioEntity) _then;

  /// Create a copy of PortfolioEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? portfolioType = null,
    Object? portfolioName = null,
    Object? countryId = null,
    Object? cityId = null,
    Object? status = null,
    Object? assetsCount = null,
    Object? createdBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      portfolioType: null == portfolioType
          ? _self.portfolioType
          : portfolioType // ignore: cast_nullable_to_non_nullable
              as PortfolioType,
      portfolioName: null == portfolioName
          ? _self.portfolioName
          : portfolioName // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      cityId: null == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PortfolioStatus,
      assetsCount: null == assetsCount
          ? _self.assetsCount
          : assetsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
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

/// Adds pattern-matching-related methods to [PortfolioEntity].
extension PortfolioEntityPatterns on PortfolioEntity {
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
    TResult Function(_PortfolioEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioEntity() when $default != null:
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
    TResult Function(_PortfolioEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioEntity():
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
    TResult? Function(_PortfolioEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioEntity() when $default != null:
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
            PortfolioType portfolioType,
            String portfolioName,
            String countryId,
            String cityId,
            PortfolioStatus status,
            int assetsCount,
            String createdBy,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioEntity() when $default != null:
        return $default(
            _that.id,
            _that.portfolioType,
            _that.portfolioName,
            _that.countryId,
            _that.cityId,
            _that.status,
            _that.assetsCount,
            _that.createdBy,
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
            PortfolioType portfolioType,
            String portfolioName,
            String countryId,
            String cityId,
            PortfolioStatus status,
            int assetsCount,
            String createdBy,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioEntity():
        return $default(
            _that.id,
            _that.portfolioType,
            _that.portfolioName,
            _that.countryId,
            _that.cityId,
            _that.status,
            _that.assetsCount,
            _that.createdBy,
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
            PortfolioType portfolioType,
            String portfolioName,
            String countryId,
            String cityId,
            PortfolioStatus status,
            int assetsCount,
            String createdBy,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioEntity() when $default != null:
        return $default(
            _that.id,
            _that.portfolioType,
            _that.portfolioName,
            _that.countryId,
            _that.cityId,
            _that.status,
            _that.assetsCount,
            _that.createdBy,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PortfolioEntity implements PortfolioEntity {
  const _PortfolioEntity(
      {required this.id,
      required this.portfolioType,
      required this.portfolioName,
      required this.countryId,
      required this.cityId,
      this.status = PortfolioStatus.draft,
      this.assetsCount = 0,
      required this.createdBy,
      this.createdAt,
      this.updatedAt});
  factory _PortfolioEntity.fromJson(Map<String, dynamic> json) =>
      _$PortfolioEntityFromJson(json);

  @override
  final String id;
  @override
  final PortfolioType portfolioType;
  @override
  final String portfolioName;
  @override
  final String countryId;
  @override
  final String cityId;
  @override
  @JsonKey()
  final PortfolioStatus status;
  @override
  @JsonKey()
  final int assetsCount;
  @override
  final String createdBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of PortfolioEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PortfolioEntityCopyWith<_PortfolioEntity> get copyWith =>
      __$PortfolioEntityCopyWithImpl<_PortfolioEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PortfolioEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PortfolioEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.portfolioType, portfolioType) ||
                other.portfolioType == portfolioType) &&
            (identical(other.portfolioName, portfolioName) ||
                other.portfolioName == portfolioName) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assetsCount, assetsCount) ||
                other.assetsCount == assetsCount) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, portfolioType, portfolioName,
      countryId, cityId, status, assetsCount, createdBy, createdAt, updatedAt);

  @override
  String toString() {
    return 'PortfolioEntity(id: $id, portfolioType: $portfolioType, portfolioName: $portfolioName, countryId: $countryId, cityId: $cityId, status: $status, assetsCount: $assetsCount, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$PortfolioEntityCopyWith<$Res>
    implements $PortfolioEntityCopyWith<$Res> {
  factory _$PortfolioEntityCopyWith(
          _PortfolioEntity value, $Res Function(_PortfolioEntity) _then) =
      __$PortfolioEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      PortfolioType portfolioType,
      String portfolioName,
      String countryId,
      String cityId,
      PortfolioStatus status,
      int assetsCount,
      String createdBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$PortfolioEntityCopyWithImpl<$Res>
    implements _$PortfolioEntityCopyWith<$Res> {
  __$PortfolioEntityCopyWithImpl(this._self, this._then);

  final _PortfolioEntity _self;
  final $Res Function(_PortfolioEntity) _then;

  /// Create a copy of PortfolioEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? portfolioType = null,
    Object? portfolioName = null,
    Object? countryId = null,
    Object? cityId = null,
    Object? status = null,
    Object? assetsCount = null,
    Object? createdBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_PortfolioEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      portfolioType: null == portfolioType
          ? _self.portfolioType
          : portfolioType // ignore: cast_nullable_to_non_nullable
              as PortfolioType,
      portfolioName: null == portfolioName
          ? _self.portfolioName
          : portfolioName // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      cityId: null == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PortfolioStatus,
      assetsCount: null == assetsCount
          ? _self.assetsCount
          : assetsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
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
