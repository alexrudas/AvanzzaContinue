// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_audit_log_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIAuditLogEntity {
  String get id;
  String get orgId;
  String get userId;
  String get accion; // consulta | ejecución sugerida | rechazo
  String get modulo;
  Map<String, dynamic> get contexto;
  Map<String, dynamic> get resultado;
  DateTime get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of AIAuditLogEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIAuditLogEntityCopyWith<AIAuditLogEntity> get copyWith =>
      _$AIAuditLogEntityCopyWithImpl<AIAuditLogEntity>(
          this as AIAuditLogEntity, _$identity);

  /// Serializes this AIAuditLogEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIAuditLogEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.accion, accion) || other.accion == accion) &&
            (identical(other.modulo, modulo) || other.modulo == modulo) &&
            const DeepCollectionEquality().equals(other.contexto, contexto) &&
            const DeepCollectionEquality().equals(other.resultado, resultado) &&
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
      accion,
      modulo,
      const DeepCollectionEquality().hash(contexto),
      const DeepCollectionEquality().hash(resultado),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AIAuditLogEntity(id: $id, orgId: $orgId, userId: $userId, accion: $accion, modulo: $modulo, contexto: $contexto, resultado: $resultado, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AIAuditLogEntityCopyWith<$Res> {
  factory $AIAuditLogEntityCopyWith(
          AIAuditLogEntity value, $Res Function(AIAuditLogEntity) _then) =
      _$AIAuditLogEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String userId,
      String accion,
      String modulo,
      Map<String, dynamic> contexto,
      Map<String, dynamic> resultado,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AIAuditLogEntityCopyWithImpl<$Res>
    implements $AIAuditLogEntityCopyWith<$Res> {
  _$AIAuditLogEntityCopyWithImpl(this._self, this._then);

  final AIAuditLogEntity _self;
  final $Res Function(AIAuditLogEntity) _then;

  /// Create a copy of AIAuditLogEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? userId = null,
    Object? accion = null,
    Object? modulo = null,
    Object? contexto = null,
    Object? resultado = null,
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
      accion: null == accion
          ? _self.accion
          : accion // ignore: cast_nullable_to_non_nullable
              as String,
      modulo: null == modulo
          ? _self.modulo
          : modulo // ignore: cast_nullable_to_non_nullable
              as String,
      contexto: null == contexto
          ? _self.contexto
          : contexto // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      resultado: null == resultado
          ? _self.resultado
          : resultado // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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

/// Adds pattern-matching-related methods to [AIAuditLogEntity].
extension AIAuditLogEntityPatterns on AIAuditLogEntity {
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
    TResult Function(_AIAuditLogEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AIAuditLogEntity() when $default != null:
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
    TResult Function(_AIAuditLogEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AIAuditLogEntity():
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
    TResult? Function(_AIAuditLogEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AIAuditLogEntity() when $default != null:
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
            String accion,
            String modulo,
            Map<String, dynamic> contexto,
            Map<String, dynamic> resultado,
            DateTime createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AIAuditLogEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.userId,
            _that.accion,
            _that.modulo,
            _that.contexto,
            _that.resultado,
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
            String accion,
            String modulo,
            Map<String, dynamic> contexto,
            Map<String, dynamic> resultado,
            DateTime createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AIAuditLogEntity():
        return $default(
            _that.id,
            _that.orgId,
            _that.userId,
            _that.accion,
            _that.modulo,
            _that.contexto,
            _that.resultado,
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
            String accion,
            String modulo,
            Map<String, dynamic> contexto,
            Map<String, dynamic> resultado,
            DateTime createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AIAuditLogEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.userId,
            _that.accion,
            _that.modulo,
            _that.contexto,
            _that.resultado,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AIAuditLogEntity implements AIAuditLogEntity {
  const _AIAuditLogEntity(
      {required this.id,
      required this.orgId,
      required this.userId,
      required this.accion,
      required this.modulo,
      required final Map<String, dynamic> contexto,
      required final Map<String, dynamic> resultado,
      required this.createdAt,
      this.updatedAt})
      : _contexto = contexto,
        _resultado = resultado;
  factory _AIAuditLogEntity.fromJson(Map<String, dynamic> json) =>
      _$AIAuditLogEntityFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String userId;
  @override
  final String accion;
// consulta | ejecución sugerida | rechazo
  @override
  final String modulo;
  final Map<String, dynamic> _contexto;
  @override
  Map<String, dynamic> get contexto {
    if (_contexto is EqualUnmodifiableMapView) return _contexto;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_contexto);
  }

  final Map<String, dynamic> _resultado;
  @override
  Map<String, dynamic> get resultado {
    if (_resultado is EqualUnmodifiableMapView) return _resultado;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_resultado);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of AIAuditLogEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AIAuditLogEntityCopyWith<_AIAuditLogEntity> get copyWith =>
      __$AIAuditLogEntityCopyWithImpl<_AIAuditLogEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AIAuditLogEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AIAuditLogEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.accion, accion) || other.accion == accion) &&
            (identical(other.modulo, modulo) || other.modulo == modulo) &&
            const DeepCollectionEquality().equals(other._contexto, _contexto) &&
            const DeepCollectionEquality()
                .equals(other._resultado, _resultado) &&
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
      accion,
      modulo,
      const DeepCollectionEquality().hash(_contexto),
      const DeepCollectionEquality().hash(_resultado),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AIAuditLogEntity(id: $id, orgId: $orgId, userId: $userId, accion: $accion, modulo: $modulo, contexto: $contexto, resultado: $resultado, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AIAuditLogEntityCopyWith<$Res>
    implements $AIAuditLogEntityCopyWith<$Res> {
  factory _$AIAuditLogEntityCopyWith(
          _AIAuditLogEntity value, $Res Function(_AIAuditLogEntity) _then) =
      __$AIAuditLogEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String userId,
      String accion,
      String modulo,
      Map<String, dynamic> contexto,
      Map<String, dynamic> resultado,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$AIAuditLogEntityCopyWithImpl<$Res>
    implements _$AIAuditLogEntityCopyWith<$Res> {
  __$AIAuditLogEntityCopyWithImpl(this._self, this._then);

  final _AIAuditLogEntity _self;
  final $Res Function(_AIAuditLogEntity) _then;

  /// Create a copy of AIAuditLogEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? userId = null,
    Object? accion = null,
    Object? modulo = null,
    Object? contexto = null,
    Object? resultado = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_AIAuditLogEntity(
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
      accion: null == accion
          ? _self.accion
          : accion // ignore: cast_nullable_to_non_nullable
              as String,
      modulo: null == modulo
          ? _self.modulo
          : modulo // ignore: cast_nullable_to_non_nullable
              as String,
      contexto: null == contexto
          ? _self._contexto
          : contexto // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      resultado: null == resultado
          ? _self._resultado
          : resultado // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
