// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_request_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseRequestEntity {
  String get id;
  String get orgId;
  String? get assetId;
  String get tipoRepuesto;
  String? get specs;
  int get cantidad;
  String get ciudadEntrega; // cityId
  List<String> get proveedorIdsInvitados;
  String get estado; // abierta | cerrada | asignada
  int get respuestasCount;
  String get currencyCode;
  DateTime? get expectedDate;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of PurchaseRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PurchaseRequestEntityCopyWith<PurchaseRequestEntity> get copyWith =>
      _$PurchaseRequestEntityCopyWithImpl<PurchaseRequestEntity>(
          this as PurchaseRequestEntity, _$identity);

  /// Serializes this PurchaseRequestEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PurchaseRequestEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.tipoRepuesto, tipoRepuesto) ||
                other.tipoRepuesto == tipoRepuesto) &&
            (identical(other.specs, specs) || other.specs == specs) &&
            (identical(other.cantidad, cantidad) ||
                other.cantidad == cantidad) &&
            (identical(other.ciudadEntrega, ciudadEntrega) ||
                other.ciudadEntrega == ciudadEntrega) &&
            const DeepCollectionEquality()
                .equals(other.proveedorIdsInvitados, proveedorIdsInvitados) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.respuestasCount, respuestasCount) ||
                other.respuestasCount == respuestasCount) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.expectedDate, expectedDate) ||
                other.expectedDate == expectedDate) &&
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
      tipoRepuesto,
      specs,
      cantidad,
      ciudadEntrega,
      const DeepCollectionEquality().hash(proveedorIdsInvitados),
      estado,
      respuestasCount,
      currencyCode,
      expectedDate,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'PurchaseRequestEntity(id: $id, orgId: $orgId, assetId: $assetId, tipoRepuesto: $tipoRepuesto, specs: $specs, cantidad: $cantidad, ciudadEntrega: $ciudadEntrega, proveedorIdsInvitados: $proveedorIdsInvitados, estado: $estado, respuestasCount: $respuestasCount, currencyCode: $currencyCode, expectedDate: $expectedDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $PurchaseRequestEntityCopyWith<$Res> {
  factory $PurchaseRequestEntityCopyWith(PurchaseRequestEntity value,
          $Res Function(PurchaseRequestEntity) _then) =
      _$PurchaseRequestEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String? assetId,
      String tipoRepuesto,
      String? specs,
      int cantidad,
      String ciudadEntrega,
      List<String> proveedorIdsInvitados,
      String estado,
      int respuestasCount,
      String currencyCode,
      DateTime? expectedDate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$PurchaseRequestEntityCopyWithImpl<$Res>
    implements $PurchaseRequestEntityCopyWith<$Res> {
  _$PurchaseRequestEntityCopyWithImpl(this._self, this._then);

  final PurchaseRequestEntity _self;
  final $Res Function(PurchaseRequestEntity) _then;

  /// Create a copy of PurchaseRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetId = freezed,
    Object? tipoRepuesto = null,
    Object? specs = freezed,
    Object? cantidad = null,
    Object? ciudadEntrega = null,
    Object? proveedorIdsInvitados = null,
    Object? estado = null,
    Object? respuestasCount = null,
    Object? currencyCode = null,
    Object? expectedDate = freezed,
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
      assetId: freezed == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      tipoRepuesto: null == tipoRepuesto
          ? _self.tipoRepuesto
          : tipoRepuesto // ignore: cast_nullable_to_non_nullable
              as String,
      specs: freezed == specs
          ? _self.specs
          : specs // ignore: cast_nullable_to_non_nullable
              as String?,
      cantidad: null == cantidad
          ? _self.cantidad
          : cantidad // ignore: cast_nullable_to_non_nullable
              as int,
      ciudadEntrega: null == ciudadEntrega
          ? _self.ciudadEntrega
          : ciudadEntrega // ignore: cast_nullable_to_non_nullable
              as String,
      proveedorIdsInvitados: null == proveedorIdsInvitados
          ? _self.proveedorIdsInvitados
          : proveedorIdsInvitados // ignore: cast_nullable_to_non_nullable
              as List<String>,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      respuestasCount: null == respuestasCount
          ? _self.respuestasCount
          : respuestasCount // ignore: cast_nullable_to_non_nullable
              as int,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      expectedDate: freezed == expectedDate
          ? _self.expectedDate
          : expectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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

/// Adds pattern-matching-related methods to [PurchaseRequestEntity].
extension PurchaseRequestEntityPatterns on PurchaseRequestEntity {
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
    TResult Function(_PurchaseRequestEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestEntity() when $default != null:
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
    TResult Function(_PurchaseRequestEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestEntity():
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
    TResult? Function(_PurchaseRequestEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestEntity() when $default != null:
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
            String? assetId,
            String tipoRepuesto,
            String? specs,
            int cantidad,
            String ciudadEntrega,
            List<String> proveedorIdsInvitados,
            String estado,
            int respuestasCount,
            String currencyCode,
            DateTime? expectedDate,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.tipoRepuesto,
            _that.specs,
            _that.cantidad,
            _that.ciudadEntrega,
            _that.proveedorIdsInvitados,
            _that.estado,
            _that.respuestasCount,
            _that.currencyCode,
            _that.expectedDate,
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
            String? assetId,
            String tipoRepuesto,
            String? specs,
            int cantidad,
            String ciudadEntrega,
            List<String> proveedorIdsInvitados,
            String estado,
            int respuestasCount,
            String currencyCode,
            DateTime? expectedDate,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestEntity():
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.tipoRepuesto,
            _that.specs,
            _that.cantidad,
            _that.ciudadEntrega,
            _that.proveedorIdsInvitados,
            _that.estado,
            _that.respuestasCount,
            _that.currencyCode,
            _that.expectedDate,
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
            String? assetId,
            String tipoRepuesto,
            String? specs,
            int cantidad,
            String ciudadEntrega,
            List<String> proveedorIdsInvitados,
            String estado,
            int respuestasCount,
            String currencyCode,
            DateTime? expectedDate,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestEntity() when $default != null:
        return $default(
            _that.id,
            _that.orgId,
            _that.assetId,
            _that.tipoRepuesto,
            _that.specs,
            _that.cantidad,
            _that.ciudadEntrega,
            _that.proveedorIdsInvitados,
            _that.estado,
            _that.respuestasCount,
            _that.currencyCode,
            _that.expectedDate,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PurchaseRequestEntity implements PurchaseRequestEntity {
  const _PurchaseRequestEntity(
      {required this.id,
      required this.orgId,
      this.assetId,
      required this.tipoRepuesto,
      this.specs,
      required this.cantidad,
      required this.ciudadEntrega,
      final List<String> proveedorIdsInvitados = const <String>[],
      required this.estado,
      this.respuestasCount = 0,
      required this.currencyCode,
      this.expectedDate,
      this.createdAt,
      this.updatedAt})
      : _proveedorIdsInvitados = proveedorIdsInvitados;
  factory _PurchaseRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestEntityFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String? assetId;
  @override
  final String tipoRepuesto;
  @override
  final String? specs;
  @override
  final int cantidad;
  @override
  final String ciudadEntrega;
// cityId
  final List<String> _proveedorIdsInvitados;
// cityId
  @override
  @JsonKey()
  List<String> get proveedorIdsInvitados {
    if (_proveedorIdsInvitados is EqualUnmodifiableListView)
      return _proveedorIdsInvitados;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_proveedorIdsInvitados);
  }

  @override
  final String estado;
// abierta | cerrada | asignada
  @override
  @JsonKey()
  final int respuestasCount;
  @override
  final String currencyCode;
  @override
  final DateTime? expectedDate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of PurchaseRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PurchaseRequestEntityCopyWith<_PurchaseRequestEntity> get copyWith =>
      __$PurchaseRequestEntityCopyWithImpl<_PurchaseRequestEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PurchaseRequestEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PurchaseRequestEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.tipoRepuesto, tipoRepuesto) ||
                other.tipoRepuesto == tipoRepuesto) &&
            (identical(other.specs, specs) || other.specs == specs) &&
            (identical(other.cantidad, cantidad) ||
                other.cantidad == cantidad) &&
            (identical(other.ciudadEntrega, ciudadEntrega) ||
                other.ciudadEntrega == ciudadEntrega) &&
            const DeepCollectionEquality()
                .equals(other._proveedorIdsInvitados, _proveedorIdsInvitados) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.respuestasCount, respuestasCount) ||
                other.respuestasCount == respuestasCount) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.expectedDate, expectedDate) ||
                other.expectedDate == expectedDate) &&
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
      tipoRepuesto,
      specs,
      cantidad,
      ciudadEntrega,
      const DeepCollectionEquality().hash(_proveedorIdsInvitados),
      estado,
      respuestasCount,
      currencyCode,
      expectedDate,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'PurchaseRequestEntity(id: $id, orgId: $orgId, assetId: $assetId, tipoRepuesto: $tipoRepuesto, specs: $specs, cantidad: $cantidad, ciudadEntrega: $ciudadEntrega, proveedorIdsInvitados: $proveedorIdsInvitados, estado: $estado, respuestasCount: $respuestasCount, currencyCode: $currencyCode, expectedDate: $expectedDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$PurchaseRequestEntityCopyWith<$Res>
    implements $PurchaseRequestEntityCopyWith<$Res> {
  factory _$PurchaseRequestEntityCopyWith(_PurchaseRequestEntity value,
          $Res Function(_PurchaseRequestEntity) _then) =
      __$PurchaseRequestEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String? assetId,
      String tipoRepuesto,
      String? specs,
      int cantidad,
      String ciudadEntrega,
      List<String> proveedorIdsInvitados,
      String estado,
      int respuestasCount,
      String currencyCode,
      DateTime? expectedDate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$PurchaseRequestEntityCopyWithImpl<$Res>
    implements _$PurchaseRequestEntityCopyWith<$Res> {
  __$PurchaseRequestEntityCopyWithImpl(this._self, this._then);

  final _PurchaseRequestEntity _self;
  final $Res Function(_PurchaseRequestEntity) _then;

  /// Create a copy of PurchaseRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? assetId = freezed,
    Object? tipoRepuesto = null,
    Object? specs = freezed,
    Object? cantidad = null,
    Object? ciudadEntrega = null,
    Object? proveedorIdsInvitados = null,
    Object? estado = null,
    Object? respuestasCount = null,
    Object? currencyCode = null,
    Object? expectedDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_PurchaseRequestEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: freezed == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      tipoRepuesto: null == tipoRepuesto
          ? _self.tipoRepuesto
          : tipoRepuesto // ignore: cast_nullable_to_non_nullable
              as String,
      specs: freezed == specs
          ? _self.specs
          : specs // ignore: cast_nullable_to_non_nullable
              as String?,
      cantidad: null == cantidad
          ? _self.cantidad
          : cantidad // ignore: cast_nullable_to_non_nullable
              as int,
      ciudadEntrega: null == ciudadEntrega
          ? _self.ciudadEntrega
          : ciudadEntrega // ignore: cast_nullable_to_non_nullable
              as String,
      proveedorIdsInvitados: null == proveedorIdsInvitados
          ? _self._proveedorIdsInvitados
          : proveedorIdsInvitados // ignore: cast_nullable_to_non_nullable
              as List<String>,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      respuestasCount: null == respuestasCount
          ? _self.respuestasCount
          : respuestasCount // ignore: cast_nullable_to_non_nullable
              as int,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      expectedDate: freezed == expectedDate
          ? _self.expectedDate
          : expectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
