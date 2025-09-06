// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incidencia_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IncidenciaEntity {
  String get id;
  String get orgId;
  String get assetId;
  String get descripcion;
  List<String> get fotosUrls;
  String? get prioridad;
  String get estado; // abierta | cerrada
  String get reportedBy;
  String? get cityId;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of IncidenciaEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IncidenciaEntityCopyWith<IncidenciaEntity> get copyWith =>
      _$IncidenciaEntityCopyWithImpl<IncidenciaEntity>(
          this as IncidenciaEntity, _$identity);

  /// Serializes this IncidenciaEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IncidenciaEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            const DeepCollectionEquality().equals(other.fotosUrls, fotosUrls) &&
            (identical(other.prioridad, prioridad) ||
                other.prioridad == prioridad) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.reportedBy, reportedBy) ||
                other.reportedBy == reportedBy) &&
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
      descripcion,
      const DeepCollectionEquality().hash(fotosUrls),
      prioridad,
      estado,
      reportedBy,
      cityId,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'IncidenciaEntity(id: $id, orgId: $orgId, assetId: $assetId, descripcion: $descripcion, fotosUrls: $fotosUrls, prioridad: $prioridad, estado: $estado, reportedBy: $reportedBy, cityId: $cityId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $IncidenciaEntityCopyWith<$Res> {
  factory $IncidenciaEntityCopyWith(
          IncidenciaEntity value, $Res Function(IncidenciaEntity) _then) =
      _$IncidenciaEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String assetId,
      String descripcion,
      List<String> fotosUrls,
      String? prioridad,
      String estado,
      String reportedBy,
      String? cityId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$IncidenciaEntityCopyWithImpl<$Res>
    implements $IncidenciaEntityCopyWith<$Res> {
  _$IncidenciaEntityCopyWithImpl(this._self, this._then);

  final IncidenciaEntity _self;
  final $Res Function(IncidenciaEntity) _then;

  /// Create a copy of IncidenciaEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetId = null,
    Object? descripcion = null,
    Object? fotosUrls = null,
    Object? prioridad = freezed,
    Object? estado = null,
    Object? reportedBy = null,
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
      descripcion: null == descripcion
          ? _self.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String,
      fotosUrls: null == fotosUrls
          ? _self.fotosUrls
          : fotosUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      prioridad: freezed == prioridad
          ? _self.prioridad
          : prioridad // ignore: cast_nullable_to_non_nullable
              as String?,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      reportedBy: null == reportedBy
          ? _self.reportedBy
          : reportedBy // ignore: cast_nullable_to_non_nullable
              as String,
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

/// Adds pattern-matching-related methods to [IncidenciaEntity].
extension IncidenciaEntityPatterns on IncidenciaEntity {
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
    TResult Function(_IncidenciaEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IncidenciaEntity() when $default != null:
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
    TResult Function(_IncidenciaEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncidenciaEntity():
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
    TResult? Function(_IncidenciaEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncidenciaEntity() when $default != null:
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
            String descripcion,
            List<String> fotosUrls,
            String? prioridad,
            String estado,
            String reportedBy,
            String? cityId,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IncidenciaEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.descripcion,
            _that.fotosUrls,
            _that.prioridad,
            _that.estado,
            _that.reportedBy,
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
            String descripcion,
            List<String> fotosUrls,
            String? prioridad,
            String estado,
            String reportedBy,
            String? cityId,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncidenciaEntity():
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.descripcion,
            _that.fotosUrls,
            _that.prioridad,
            _that.estado,
            _that.reportedBy,
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
            String descripcion,
            List<String> fotosUrls,
            String? prioridad,
            String estado,
            String reportedBy,
            String? cityId,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncidenciaEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.descripcion,
            _that.fotosUrls,
            _that.prioridad,
            _that.estado,
            _that.reportedBy,
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
class _IncidenciaEntity implements IncidenciaEntity {
  const _IncidenciaEntity(
      {required this.id,
      required this.orgId,
      required this.assetId,
      required this.descripcion,
      final List<String> fotosUrls = const <String>[],
      this.prioridad,
      required this.estado,
      required this.reportedBy,
      this.cityId,
      this.createdAt,
      this.updatedAt})
      : _fotosUrls = fotosUrls;
  factory _IncidenciaEntity.fromJson(Map<String, dynamic> json) =>
      _$IncidenciaEntityFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String assetId;
  @override
  final String descripcion;
  final List<String> _fotosUrls;
  @override
  @JsonKey()
  List<String> get fotosUrls {
    if (_fotosUrls is EqualUnmodifiableListView) return _fotosUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fotosUrls);
  }

  @override
  final String? prioridad;
  @override
  final String estado;
// abierta | cerrada
  @override
  final String reportedBy;
  @override
  final String? cityId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of IncidenciaEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IncidenciaEntityCopyWith<_IncidenciaEntity> get copyWith =>
      __$IncidenciaEntityCopyWithImpl<_IncidenciaEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$IncidenciaEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IncidenciaEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            const DeepCollectionEquality()
                .equals(other._fotosUrls, _fotosUrls) &&
            (identical(other.prioridad, prioridad) ||
                other.prioridad == prioridad) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.reportedBy, reportedBy) ||
                other.reportedBy == reportedBy) &&
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
      descripcion,
      const DeepCollectionEquality().hash(_fotosUrls),
      prioridad,
      estado,
      reportedBy,
      cityId,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'IncidenciaEntity(id: $id, orgId: $orgId, assetId: $assetId, descripcion: $descripcion, fotosUrls: $fotosUrls, prioridad: $prioridad, estado: $estado, reportedBy: $reportedBy, cityId: $cityId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$IncidenciaEntityCopyWith<$Res>
    implements $IncidenciaEntityCopyWith<$Res> {
  factory _$IncidenciaEntityCopyWith(
          _IncidenciaEntity value, $Res Function(_IncidenciaEntity) _then) =
      __$IncidenciaEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String assetId,
      String descripcion,
      List<String> fotosUrls,
      String? prioridad,
      String estado,
      String reportedBy,
      String? cityId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$IncidenciaEntityCopyWithImpl<$Res>
    implements _$IncidenciaEntityCopyWith<$Res> {
  __$IncidenciaEntityCopyWithImpl(this._self, this._then);

  final _IncidenciaEntity _self;
  final $Res Function(_IncidenciaEntity) _then;

  /// Create a copy of IncidenciaEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetId = null,
    Object? descripcion = null,
    Object? fotosUrls = null,
    Object? prioridad = freezed,
    Object? estado = null,
    Object? reportedBy = null,
    Object? cityId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_IncidenciaEntity(
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
      descripcion: null == descripcion
          ? _self.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String,
      fotosUrls: null == fotosUrls
          ? _self._fotosUrls
          : fotosUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      prioridad: freezed == prioridad
          ? _self.prioridad
          : prioridad // ignore: cast_nullable_to_non_nullable
              as String?,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      reportedBy: null == reportedBy
          ? _self.reportedBy
          : reportedBy // ignore: cast_nullable_to_non_nullable
              as String,
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
