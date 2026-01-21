// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_receivable_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountReceivableEntity {
  String get id;
  String get portfolioId;
  String get debtorActorId;
  double get amount;
  DateTime get issueDate;
  DateTime get dueDate;
  AccountReceivableStatus get status;
  String? get description;
  String get createdBy;
  DateTime get createdAt;

  /// Create a copy of AccountReceivableEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountReceivableEntityCopyWith<AccountReceivableEntity> get copyWith =>
      _$AccountReceivableEntityCopyWithImpl<AccountReceivableEntity>(
          this as AccountReceivableEntity, _$identity);

  /// Serializes this AccountReceivableEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountReceivableEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.portfolioId, portfolioId) ||
                other.portfolioId == portfolioId) &&
            (identical(other.debtorActorId, debtorActorId) ||
                other.debtorActorId == debtorActorId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, portfolioId, debtorActorId,
      amount, issueDate, dueDate, status, description, createdBy, createdAt);

  @override
  String toString() {
    return 'AccountReceivableEntity(id: $id, portfolioId: $portfolioId, debtorActorId: $debtorActorId, amount: $amount, issueDate: $issueDate, dueDate: $dueDate, status: $status, description: $description, createdBy: $createdBy, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $AccountReceivableEntityCopyWith<$Res> {
  factory $AccountReceivableEntityCopyWith(AccountReceivableEntity value,
          $Res Function(AccountReceivableEntity) _then) =
      _$AccountReceivableEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String portfolioId,
      String debtorActorId,
      double amount,
      DateTime issueDate,
      DateTime dueDate,
      AccountReceivableStatus status,
      String? description,
      String createdBy,
      DateTime createdAt});
}

/// @nodoc
class _$AccountReceivableEntityCopyWithImpl<$Res>
    implements $AccountReceivableEntityCopyWith<$Res> {
  _$AccountReceivableEntityCopyWithImpl(this._self, this._then);

  final AccountReceivableEntity _self;
  final $Res Function(AccountReceivableEntity) _then;

  /// Create a copy of AccountReceivableEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? portfolioId = null,
    Object? debtorActorId = null,
    Object? amount = null,
    Object? issueDate = null,
    Object? dueDate = null,
    Object? status = null,
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
      debtorActorId: null == debtorActorId
          ? _self.debtorActorId
          : debtorActorId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      issueDate: null == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dueDate: null == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as AccountReceivableStatus,
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

/// Adds pattern-matching-related methods to [AccountReceivableEntity].
extension AccountReceivableEntityPatterns on AccountReceivableEntity {
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
    TResult Function(_AccountReceivableEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountReceivableEntity() when $default != null:
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
    TResult Function(_AccountReceivableEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountReceivableEntity():
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
    TResult? Function(_AccountReceivableEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountReceivableEntity() when $default != null:
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
            String debtorActorId,
            double amount,
            DateTime issueDate,
            DateTime dueDate,
            AccountReceivableStatus status,
            String? description,
            String createdBy,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountReceivableEntity() when $default != null:
        return $default(
            _that.id,
            _that.portfolioId,
            _that.debtorActorId,
            _that.amount,
            _that.issueDate,
            _that.dueDate,
            _that.status,
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
            String debtorActorId,
            double amount,
            DateTime issueDate,
            DateTime dueDate,
            AccountReceivableStatus status,
            String? description,
            String createdBy,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountReceivableEntity():
        return $default(
            _that.id,
            _that.portfolioId,
            _that.debtorActorId,
            _that.amount,
            _that.issueDate,
            _that.dueDate,
            _that.status,
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
            String debtorActorId,
            double amount,
            DateTime issueDate,
            DateTime dueDate,
            AccountReceivableStatus status,
            String? description,
            String createdBy,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountReceivableEntity() when $default != null:
        return $default(
            _that.id,
            _that.portfolioId,
            _that.debtorActorId,
            _that.amount,
            _that.issueDate,
            _that.dueDate,
            _that.status,
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
class _AccountReceivableEntity implements AccountReceivableEntity {
  const _AccountReceivableEntity(
      {required this.id,
      required this.portfolioId,
      required this.debtorActorId,
      required this.amount,
      required this.issueDate,
      required this.dueDate,
      this.status = AccountReceivableStatus.pendiente,
      this.description,
      required this.createdBy,
      required this.createdAt});
  factory _AccountReceivableEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountReceivableEntityFromJson(json);

  @override
  final String id;
  @override
  final String portfolioId;
  @override
  final String debtorActorId;
  @override
  final double amount;
  @override
  final DateTime issueDate;
  @override
  final DateTime dueDate;
  @override
  @JsonKey()
  final AccountReceivableStatus status;
  @override
  final String? description;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;

  /// Create a copy of AccountReceivableEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccountReceivableEntityCopyWith<_AccountReceivableEntity> get copyWith =>
      __$AccountReceivableEntityCopyWithImpl<_AccountReceivableEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccountReceivableEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountReceivableEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.portfolioId, portfolioId) ||
                other.portfolioId == portfolioId) &&
            (identical(other.debtorActorId, debtorActorId) ||
                other.debtorActorId == debtorActorId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, portfolioId, debtorActorId,
      amount, issueDate, dueDate, status, description, createdBy, createdAt);

  @override
  String toString() {
    return 'AccountReceivableEntity(id: $id, portfolioId: $portfolioId, debtorActorId: $debtorActorId, amount: $amount, issueDate: $issueDate, dueDate: $dueDate, status: $status, description: $description, createdBy: $createdBy, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$AccountReceivableEntityCopyWith<$Res>
    implements $AccountReceivableEntityCopyWith<$Res> {
  factory _$AccountReceivableEntityCopyWith(_AccountReceivableEntity value,
          $Res Function(_AccountReceivableEntity) _then) =
      __$AccountReceivableEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String portfolioId,
      String debtorActorId,
      double amount,
      DateTime issueDate,
      DateTime dueDate,
      AccountReceivableStatus status,
      String? description,
      String createdBy,
      DateTime createdAt});
}

/// @nodoc
class __$AccountReceivableEntityCopyWithImpl<$Res>
    implements _$AccountReceivableEntityCopyWith<$Res> {
  __$AccountReceivableEntityCopyWithImpl(this._self, this._then);

  final _AccountReceivableEntity _self;
  final $Res Function(_AccountReceivableEntity) _then;

  /// Create a copy of AccountReceivableEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? portfolioId = null,
    Object? debtorActorId = null,
    Object? amount = null,
    Object? issueDate = null,
    Object? dueDate = null,
    Object? status = null,
    Object? description = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(_AccountReceivableEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      portfolioId: null == portfolioId
          ? _self.portfolioId
          : portfolioId // ignore: cast_nullable_to_non_nullable
              as String,
      debtorActorId: null == debtorActorId
          ? _self.debtorActorId
          : debtorActorId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      issueDate: null == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dueDate: null == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as AccountReceivableStatus,
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
