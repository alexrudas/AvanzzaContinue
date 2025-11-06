// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_lite_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkspaceLiteEntity {
  String get id;
  String get name;
  String? get subtitle;
  String? get iconName;
  DateTime? get lastUsed;

  /// Create a copy of WorkspaceLiteEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkspaceLiteEntityCopyWith<WorkspaceLiteEntity> get copyWith =>
      _$WorkspaceLiteEntityCopyWithImpl<WorkspaceLiteEntity>(
          this as WorkspaceLiteEntity, _$identity);

  /// Serializes this WorkspaceLiteEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkspaceLiteEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.lastUsed, lastUsed) ||
                other.lastUsed == lastUsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, subtitle, iconName, lastUsed);

  @override
  String toString() {
    return 'WorkspaceLiteEntity(id: $id, name: $name, subtitle: $subtitle, iconName: $iconName, lastUsed: $lastUsed)';
  }
}

/// @nodoc
abstract mixin class $WorkspaceLiteEntityCopyWith<$Res> {
  factory $WorkspaceLiteEntityCopyWith(
          WorkspaceLiteEntity value, $Res Function(WorkspaceLiteEntity) _then) =
      _$WorkspaceLiteEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String? subtitle,
      String? iconName,
      DateTime? lastUsed});
}

/// @nodoc
class _$WorkspaceLiteEntityCopyWithImpl<$Res>
    implements $WorkspaceLiteEntityCopyWith<$Res> {
  _$WorkspaceLiteEntityCopyWithImpl(this._self, this._then);

  final WorkspaceLiteEntity _self;
  final $Res Function(WorkspaceLiteEntity) _then;

  /// Create a copy of WorkspaceLiteEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? subtitle = freezed,
    Object? iconName = freezed,
    Object? lastUsed = freezed,
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
      subtitle: freezed == subtitle
          ? _self.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _self.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUsed: freezed == lastUsed
          ? _self.lastUsed
          : lastUsed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [WorkspaceLiteEntity].
extension WorkspaceLiteEntityPatterns on WorkspaceLiteEntity {
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
    TResult Function(_WorkspaceLiteEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkspaceLiteEntity() when $default != null:
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
    TResult Function(_WorkspaceLiteEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkspaceLiteEntity():
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
    TResult? Function(_WorkspaceLiteEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkspaceLiteEntity() when $default != null:
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
    TResult Function(String id, String name, String? subtitle, String? iconName,
            DateTime? lastUsed)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkspaceLiteEntity() when $default != null:
        return $default(_that.id, _that.name, _that.subtitle, _that.iconName,
            _that.lastUsed);
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
    TResult Function(String id, String name, String? subtitle, String? iconName,
            DateTime? lastUsed)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkspaceLiteEntity():
        return $default(_that.id, _that.name, _that.subtitle, _that.iconName,
            _that.lastUsed);
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
    TResult? Function(String id, String name, String? subtitle,
            String? iconName, DateTime? lastUsed)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkspaceLiteEntity() when $default != null:
        return $default(_that.id, _that.name, _that.subtitle, _that.iconName,
            _that.lastUsed);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkspaceLiteEntity implements WorkspaceLiteEntity {
  const _WorkspaceLiteEntity(
      {required this.id,
      required this.name,
      this.subtitle,
      this.iconName,
      this.lastUsed});
  factory _WorkspaceLiteEntity.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceLiteEntityFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? subtitle;
  @override
  final String? iconName;
  @override
  final DateTime? lastUsed;

  /// Create a copy of WorkspaceLiteEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkspaceLiteEntityCopyWith<_WorkspaceLiteEntity> get copyWith =>
      __$WorkspaceLiteEntityCopyWithImpl<_WorkspaceLiteEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkspaceLiteEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkspaceLiteEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.lastUsed, lastUsed) ||
                other.lastUsed == lastUsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, subtitle, iconName, lastUsed);

  @override
  String toString() {
    return 'WorkspaceLiteEntity(id: $id, name: $name, subtitle: $subtitle, iconName: $iconName, lastUsed: $lastUsed)';
  }
}

/// @nodoc
abstract mixin class _$WorkspaceLiteEntityCopyWith<$Res>
    implements $WorkspaceLiteEntityCopyWith<$Res> {
  factory _$WorkspaceLiteEntityCopyWith(_WorkspaceLiteEntity value,
          $Res Function(_WorkspaceLiteEntity) _then) =
      __$WorkspaceLiteEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? subtitle,
      String? iconName,
      DateTime? lastUsed});
}

/// @nodoc
class __$WorkspaceLiteEntityCopyWithImpl<$Res>
    implements _$WorkspaceLiteEntityCopyWith<$Res> {
  __$WorkspaceLiteEntityCopyWithImpl(this._self, this._then);

  final _WorkspaceLiteEntity _self;
  final $Res Function(_WorkspaceLiteEntity) _then;

  /// Create a copy of WorkspaceLiteEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? subtitle = freezed,
    Object? iconName = freezed,
    Object? lastUsed = freezed,
  }) {
    return _then(_WorkspaceLiteEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _self.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _self.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUsed: freezed == lastUsed
          ? _self.lastUsed
          : lastUsed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
