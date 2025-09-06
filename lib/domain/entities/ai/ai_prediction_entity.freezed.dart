// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_prediction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIPredictionEntity {
  String get id;
  String get orgId;
  String get tipo; // fallas | compras | riesgos | contabilidad
  String get targetId; // assetId, purchaseId, etc
  double get score;
  String get explicacion;
  List<String> get recomendaciones;
  DateTime get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of AIPredictionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIPredictionEntityCopyWith<AIPredictionEntity> get copyWith =>
      _$AIPredictionEntityCopyWithImpl<AIPredictionEntity>(
          this as AIPredictionEntity, _$identity);

  /// Serializes this AIPredictionEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIPredictionEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.explicacion, explicacion) ||
                other.explicacion == explicacion) &&
            const DeepCollectionEquality()
                .equals(other.recomendaciones, recomendaciones) &&
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
      tipo,
      targetId,
      score,
      explicacion,
      const DeepCollectionEquality().hash(recomendaciones),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AIPredictionEntity(id: $id, orgId: $orgId, tipo: $tipo, targetId: $targetId, score: $score, explicacion: $explicacion, recomendaciones: $recomendaciones, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AIPredictionEntityCopyWith<$Res> {
  factory $AIPredictionEntityCopyWith(
          AIPredictionEntity value, $Res Function(AIPredictionEntity) _then) =
      _$AIPredictionEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String tipo,
      String targetId,
      double score,
      String explicacion,
      List<String> recomendaciones,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AIPredictionEntityCopyWithImpl<$Res>
    implements $AIPredictionEntityCopyWith<$Res> {
  _$AIPredictionEntityCopyWithImpl(this._self, this._then);

  final AIPredictionEntity _self;
  final $Res Function(AIPredictionEntity) _then;

  /// Create a copy of AIPredictionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? tipo = null,
    Object? targetId = null,
    Object? score = null,
    Object? explicacion = null,
    Object? recomendaciones = null,
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
      tipo: null == tipo
          ? _self.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      explicacion: null == explicacion
          ? _self.explicacion
          : explicacion // ignore: cast_nullable_to_non_nullable
              as String,
      recomendaciones: null == recomendaciones
          ? _self.recomendaciones
          : recomendaciones // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [AIPredictionEntity].
extension AIPredictionEntityPatterns on AIPredictionEntity {
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
    TResult Function(_AIPredictionEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AIPredictionEntity() when $default != null:
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
    TResult Function(_AIPredictionEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AIPredictionEntity():
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
    TResult? Function(_AIPredictionEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AIPredictionEntity() when $default != null:
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
            String tipo,
            String targetId,
            double score,
            String explicacion,
            List<String> recomendaciones,
            DateTime createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AIPredictionEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.tipo,
            _that.targetId,
            _that.score,
            _that.explicacion,
            _that.recomendaciones,
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
            String tipo,
            String targetId,
            double score,
            String explicacion,
            List<String> recomendaciones,
            DateTime createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AIPredictionEntity():
        return $default(
            _that.id,
            _that.orgId,
            _that.tipo,
            _that.targetId,
            _that.score,
            _that.explicacion,
            _that.recomendaciones,
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
            String tipo,
            String targetId,
            double score,
            String explicacion,
            List<String> recomendaciones,
            DateTime createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AIPredictionEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.tipo,
            _that.targetId,
            _that.score,
            _that.explicacion,
            _that.recomendaciones,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AIPredictionEntity implements AIPredictionEntity {
  const _AIPredictionEntity(
      {required this.id,
      required this.orgId,
      required this.tipo,
      required this.targetId,
      required this.score,
      required this.explicacion,
      final List<String> recomendaciones = const <String>[],
      required this.createdAt,
      this.updatedAt})
      : _recomendaciones = recomendaciones;
  factory _AIPredictionEntity.fromJson(Map<String, dynamic> json) =>
      _$AIPredictionEntityFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String tipo;
// fallas | compras | riesgos | contabilidad
  @override
  final String targetId;
// assetId, purchaseId, etc
  @override
  final double score;
  @override
  final String explicacion;
  final List<String> _recomendaciones;
  @override
  @JsonKey()
  List<String> get recomendaciones {
    if (_recomendaciones is EqualUnmodifiableListView) return _recomendaciones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recomendaciones);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of AIPredictionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AIPredictionEntityCopyWith<_AIPredictionEntity> get copyWith =>
      __$AIPredictionEntityCopyWithImpl<_AIPredictionEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AIPredictionEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AIPredictionEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.explicacion, explicacion) ||
                other.explicacion == explicacion) &&
            const DeepCollectionEquality()
                .equals(other._recomendaciones, _recomendaciones) &&
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
      tipo,
      targetId,
      score,
      explicacion,
      const DeepCollectionEquality().hash(_recomendaciones),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AIPredictionEntity(id: $id, orgId: $orgId, tipo: $tipo, targetId: $targetId, score: $score, explicacion: $explicacion, recomendaciones: $recomendaciones, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AIPredictionEntityCopyWith<$Res>
    implements $AIPredictionEntityCopyWith<$Res> {
  factory _$AIPredictionEntityCopyWith(
          _AIPredictionEntity value, $Res Function(_AIPredictionEntity) _then) =
      __$AIPredictionEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String tipo,
      String targetId,
      double score,
      String explicacion,
      List<String> recomendaciones,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$AIPredictionEntityCopyWithImpl<$Res>
    implements _$AIPredictionEntityCopyWith<$Res> {
  __$AIPredictionEntityCopyWithImpl(this._self, this._then);

  final _AIPredictionEntity _self;
  final $Res Function(_AIPredictionEntity) _then;

  /// Create a copy of AIPredictionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? tipo = null,
    Object? targetId = null,
    Object? score = null,
    Object? explicacion = null,
    Object? recomendaciones = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_AIPredictionEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _self.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      explicacion: null == explicacion
          ? _self.explicacion
          : explicacion // ignore: cast_nullable_to_non_nullable
              as String,
      recomendaciones: null == recomendaciones
          ? _self._recomendaciones
          : recomendaciones // ignore: cast_nullable_to_non_nullable
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
