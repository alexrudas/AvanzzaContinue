// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_advisor_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIAdvisorEntity {
  String get id;
  String get orgId;
  String get userId;
  String
      get modulo; // activos | mantenimiento | compras | contabilidad | seguros | chat
  String get inputText;
  Map<String, dynamic>? get structuredContext;
  String? get outputText;
  List<String> get suggestions;
  DateTime get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of AIAdvisorEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIAdvisorEntityCopyWith<AIAdvisorEntity> get copyWith =>
      _$AIAdvisorEntityCopyWithImpl<AIAdvisorEntity>(
          this as AIAdvisorEntity, _$identity);

  /// Serializes this AIAdvisorEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIAdvisorEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.modulo, modulo) || other.modulo == modulo) &&
            (identical(other.inputText, inputText) ||
                other.inputText == inputText) &&
            const DeepCollectionEquality()
                .equals(other.structuredContext, structuredContext) &&
            (identical(other.outputText, outputText) ||
                other.outputText == outputText) &&
            const DeepCollectionEquality()
                .equals(other.suggestions, suggestions) &&
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
      userId,
      modulo,
      inputText,
      const DeepCollectionEquality().hash(structuredContext),
      outputText,
      const DeepCollectionEquality().hash(suggestions),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AIAdvisorEntity(id: $id, orgId: $orgId, userId: $userId, modulo: $modulo, inputText: $inputText, structuredContext: $structuredContext, outputText: $outputText, suggestions: $suggestions, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AIAdvisorEntityCopyWith<$Res> {
  factory $AIAdvisorEntityCopyWith(
          AIAdvisorEntity value, $Res Function(AIAdvisorEntity) _then) =
      _$AIAdvisorEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String userId,
      String modulo,
      String inputText,
      Map<String, dynamic>? structuredContext,
      String? outputText,
      List<String> suggestions,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AIAdvisorEntityCopyWithImpl<$Res>
    implements $AIAdvisorEntityCopyWith<$Res> {
  _$AIAdvisorEntityCopyWithImpl(this._self, this._then);

  final AIAdvisorEntity _self;
  final $Res Function(AIAdvisorEntity) _then;

  /// Create a copy of AIAdvisorEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? userId = null,
    Object? modulo = null,
    Object? inputText = null,
    Object? structuredContext = freezed,
    Object? outputText = freezed,
    Object? suggestions = null,
    Object? createdAt = null,
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
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      modulo: null == modulo
          ? _self.modulo
          : modulo // ignore: cast_nullable_to_non_nullable
              as String,
      inputText: null == inputText
          ? _self.inputText
          : inputText // ignore: cast_nullable_to_non_nullable
              as String,
      structuredContext: freezed == structuredContext
          ? _self.structuredContext
          : structuredContext // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      outputText: freezed == outputText
          ? _self.outputText
          : outputText // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestions: null == suggestions
          ? _self.suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AIAdvisorEntity].
extension AIAdvisorEntityPatterns on AIAdvisorEntity {
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
    TResult Function(_AIAdvisorEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AIAdvisorEntity() when $default != null:
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
    TResult Function(_AIAdvisorEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AIAdvisorEntity():
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
    TResult? Function(_AIAdvisorEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AIAdvisorEntity() when $default != null:
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
            String userId,
            String modulo,
            String inputText,
            Map<String, dynamic>? structuredContext,
            String? outputText,
            List<String> suggestions,
            DateTime createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AIAdvisorEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.userId,
            _that.modulo,
            _that.inputText,
            _that.structuredContext,
            _that.outputText,
            _that.suggestions,
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
            String userId,
            String modulo,
            String inputText,
            Map<String, dynamic>? structuredContext,
            String? outputText,
            List<String> suggestions,
            DateTime createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AIAdvisorEntity():
        return $default(
            _that.id,
            _that.orgId,
            _that.userId,
            _that.modulo,
            _that.inputText,
            _that.structuredContext,
            _that.outputText,
            _that.suggestions,
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
            String userId,
            String modulo,
            String inputText,
            Map<String, dynamic>? structuredContext,
            String? outputText,
            List<String> suggestions,
            DateTime createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AIAdvisorEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.userId,
            _that.modulo,
            _that.inputText,
            _that.structuredContext,
            _that.outputText,
            _that.suggestions,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AIAdvisorEntity implements AIAdvisorEntity {
  const _AIAdvisorEntity(
      {required this.id,
      required this.orgId,
      required this.userId,
      required this.modulo,
      required this.inputText,
      final Map<String, dynamic>? structuredContext,
      this.outputText,
      final List<String> suggestions = const <String>[],
      required this.createdAt,
      this.updatedAt})
      : _structuredContext = structuredContext,
        _suggestions = suggestions;
  factory _AIAdvisorEntity.fromJson(Map<String, dynamic> json) =>
      _$AIAdvisorEntityFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String userId;
  @override
  final String modulo;
// activos | mantenimiento | compras | contabilidad | seguros | chat
  @override
  final String inputText;
  final Map<String, dynamic>? _structuredContext;
  @override
  Map<String, dynamic>? get structuredContext {
    final value = _structuredContext;
    if (value == null) return null;
    if (_structuredContext is EqualUnmodifiableMapView)
      return _structuredContext;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? outputText;
  final List<String> _suggestions;
  @override
  @JsonKey()
  List<String> get suggestions {
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestions);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of AIAdvisorEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AIAdvisorEntityCopyWith<_AIAdvisorEntity> get copyWith =>
      __$AIAdvisorEntityCopyWithImpl<_AIAdvisorEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AIAdvisorEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AIAdvisorEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.modulo, modulo) || other.modulo == modulo) &&
            (identical(other.inputText, inputText) ||
                other.inputText == inputText) &&
            const DeepCollectionEquality()
                .equals(other._structuredContext, _structuredContext) &&
            (identical(other.outputText, outputText) ||
                other.outputText == outputText) &&
            const DeepCollectionEquality()
                .equals(other._suggestions, _suggestions) &&
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
      userId,
      modulo,
      inputText,
      const DeepCollectionEquality().hash(_structuredContext),
      outputText,
      const DeepCollectionEquality().hash(_suggestions),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AIAdvisorEntity(id: $id, orgId: $orgId, userId: $userId, modulo: $modulo, inputText: $inputText, structuredContext: $structuredContext, outputText: $outputText, suggestions: $suggestions, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AIAdvisorEntityCopyWith<$Res>
    implements $AIAdvisorEntityCopyWith<$Res> {
  factory _$AIAdvisorEntityCopyWith(
          _AIAdvisorEntity value, $Res Function(_AIAdvisorEntity) _then) =
      __$AIAdvisorEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String userId,
      String modulo,
      String inputText,
      Map<String, dynamic>? structuredContext,
      String? outputText,
      List<String> suggestions,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$AIAdvisorEntityCopyWithImpl<$Res>
    implements _$AIAdvisorEntityCopyWith<$Res> {
  __$AIAdvisorEntityCopyWithImpl(this._self, this._then);

  final _AIAdvisorEntity _self;
  final $Res Function(_AIAdvisorEntity) _then;

  /// Create a copy of AIAdvisorEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? userId = null,
    Object? modulo = null,
    Object? inputText = null,
    Object? structuredContext = freezed,
    Object? outputText = freezed,
    Object? suggestions = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_AIAdvisorEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      modulo: null == modulo
          ? _self.modulo
          : modulo // ignore: cast_nullable_to_non_nullable
              as String,
      inputText: null == inputText
          ? _self.inputText
          : inputText // ignore: cast_nullable_to_non_nullable
              as String,
      structuredContext: freezed == structuredContext
          ? _self._structuredContext
          : structuredContext // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      outputText: freezed == outputText
          ? _self.outputText
          : outputText // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestions: null == suggestions
          ? _self._suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
