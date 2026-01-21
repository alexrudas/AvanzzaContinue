// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseEntity {
  String get id;
  String get portfolioId;
  double get amount;
  DateTime get date;
  ExpenseType get expenseType;
  String? get description;
  String get createdBy;
  DateTime get createdAt;

  /// Create a copy of ExpenseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExpenseEntityCopyWith<ExpenseEntity> get copyWith =>
      _$ExpenseEntityCopyWithImpl<ExpenseEntity>(
          this as ExpenseEntity, _$identity);

  /// Serializes this ExpenseEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExpenseEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.portfolioId, portfolioId) ||
                other.portfolioId == portfolioId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.expenseType, expenseType) ||
                other.expenseType == expenseType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, portfolioId, amount, date,
      expenseType, description, createdBy, createdAt);

  @override
  String toString() {
    return 'ExpenseEntity(id: $id, portfolioId: $portfolioId, amount: $amount, date: $date, expenseType: $expenseType, description: $description, createdBy: $createdBy, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ExpenseEntityCopyWith<$Res> {
  factory $ExpenseEntityCopyWith(
          ExpenseEntity value, $Res Function(ExpenseEntity) _then) =
      _$ExpenseEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String portfolioId,
      double amount,
      DateTime date,
      ExpenseType expenseType,
      String? description,
      String createdBy,
      DateTime createdAt});
}

/// @nodoc
class _$ExpenseEntityCopyWithImpl<$Res>
    implements $ExpenseEntityCopyWith<$Res> {
  _$ExpenseEntityCopyWithImpl(this._self, this._then);

  final ExpenseEntity _self;
  final $Res Function(ExpenseEntity) _then;

  /// Create a copy of ExpenseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? portfolioId = null,
    Object? amount = null,
    Object? date = null,
    Object? expenseType = null,
    Object? description = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      portfolioId: null == portfolioId
          ? _self.portfolioId
          : portfolioId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expenseType: null == expenseType
          ? _self.expenseType
          : expenseType // ignore: cast_nullable_to_non_nullable
              as ExpenseType,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ExpenseEntity].
extension ExpenseEntityPatterns on ExpenseEntity {
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
    TResult Function(_ExpenseEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExpenseEntity() when $default != null:
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
    TResult Function(_ExpenseEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseEntity():
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
    TResult? Function(_ExpenseEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseEntity() when $default != null:
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
            String portfolioId,
            double amount,
            DateTime date,
            ExpenseType expenseType,
            String? description,
            String createdBy,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExpenseEntity() when $default != null:
        return $default(
            _that.id,
            _that.portfolioId,
            _that.amount,
            _that.date,
            _that.expenseType,
            _that.description,
            _that.createdBy,
            _that.createdAt);
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
            String portfolioId,
            double amount,
            DateTime date,
            ExpenseType expenseType,
            String? description,
            String createdBy,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseEntity():
        return $default(
            _that.id,
            _that.portfolioId,
            _that.amount,
            _that.date,
            _that.expenseType,
            _that.description,
            _that.createdBy,
            _that.createdAt);
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
            String portfolioId,
            double amount,
            DateTime date,
            ExpenseType expenseType,
            String? description,
            String createdBy,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseEntity() when $default != null:
        return $default(
            _that.id,
            _that.portfolioId,
            _that.amount,
            _that.date,
            _that.expenseType,
            _that.description,
            _that.createdBy,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ExpenseEntity implements ExpenseEntity {
  const _ExpenseEntity(
      {required this.id,
      required this.portfolioId,
      required this.amount,
      required this.date,
      required this.expenseType,
      this.description,
      required this.createdBy,
      required this.createdAt});
  factory _ExpenseEntity.fromJson(Map<String, dynamic> json) =>
      _$ExpenseEntityFromJson(json);

  @override
  final String id;
  @override
  final String portfolioId;
  @override
  final double amount;
  @override
  final DateTime date;
  @override
  final ExpenseType expenseType;
  @override
  final String? description;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;

  /// Create a copy of ExpenseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExpenseEntityCopyWith<_ExpenseEntity> get copyWith =>
      __$ExpenseEntityCopyWithImpl<_ExpenseEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExpenseEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExpenseEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.portfolioId, portfolioId) ||
                other.portfolioId == portfolioId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.expenseType, expenseType) ||
                other.expenseType == expenseType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, portfolioId, amount, date,
      expenseType, description, createdBy, createdAt);

  @override
  String toString() {
    return 'ExpenseEntity(id: $id, portfolioId: $portfolioId, amount: $amount, date: $date, expenseType: $expenseType, description: $description, createdBy: $createdBy, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ExpenseEntityCopyWith<$Res>
    implements $ExpenseEntityCopyWith<$Res> {
  factory _$ExpenseEntityCopyWith(
          _ExpenseEntity value, $Res Function(_ExpenseEntity) _then) =
      __$ExpenseEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String portfolioId,
      double amount,
      DateTime date,
      ExpenseType expenseType,
      String? description,
      String createdBy,
      DateTime createdAt});
}

/// @nodoc
class __$ExpenseEntityCopyWithImpl<$Res>
    implements _$ExpenseEntityCopyWith<$Res> {
  __$ExpenseEntityCopyWithImpl(this._self, this._then);

  final _ExpenseEntity _self;
  final $Res Function(_ExpenseEntity) _then;

  /// Create a copy of ExpenseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? portfolioId = null,
    Object? amount = null,
    Object? date = null,
    Object? expenseType = null,
    Object? description = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(_ExpenseEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      portfolioId: null == portfolioId
          ? _self.portfolioId
          : portfolioId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expenseType: null == expenseType
          ? _self.expenseType
          : expenseType // ignore: cast_nullable_to_non_nullable
              as ExpenseType,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
