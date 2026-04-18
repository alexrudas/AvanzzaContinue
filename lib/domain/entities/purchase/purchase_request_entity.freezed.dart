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
mixin _$PurchaseRequestItemEntity {
  String get id;
  String get description;
  num get quantity;
  String get unit;
  String? get notes;

  /// Create a copy of PurchaseRequestItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PurchaseRequestItemEntityCopyWith<PurchaseRequestItemEntity> get copyWith =>
      _$PurchaseRequestItemEntityCopyWithImpl<PurchaseRequestItemEntity>(
          this as PurchaseRequestItemEntity, _$identity);

  /// Serializes this PurchaseRequestItemEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PurchaseRequestItemEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, description, quantity, unit, notes);

  @override
  String toString() {
    return 'PurchaseRequestItemEntity(id: $id, description: $description, quantity: $quantity, unit: $unit, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class $PurchaseRequestItemEntityCopyWith<$Res> {
  factory $PurchaseRequestItemEntityCopyWith(PurchaseRequestItemEntity value,
          $Res Function(PurchaseRequestItemEntity) _then) =
      _$PurchaseRequestItemEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String description,
      num quantity,
      String unit,
      String? notes});
}

/// @nodoc
class _$PurchaseRequestItemEntityCopyWithImpl<$Res>
    implements $PurchaseRequestItemEntityCopyWith<$Res> {
  _$PurchaseRequestItemEntityCopyWithImpl(this._self, this._then);

  final PurchaseRequestItemEntity _self;
  final $Res Function(PurchaseRequestItemEntity) _then;

  /// Create a copy of PurchaseRequestItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? quantity = null,
    Object? unit = null,
    Object? notes = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as num,
      unit: null == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PurchaseRequestItemEntity].
extension PurchaseRequestItemEntityPatterns on PurchaseRequestItemEntity {
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
    TResult Function(_PurchaseRequestItemEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestItemEntity() when $default != null:
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
    TResult Function(_PurchaseRequestItemEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestItemEntity():
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
    TResult? Function(_PurchaseRequestItemEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestItemEntity() when $default != null:
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
    TResult Function(String id, String description, num quantity, String unit,
            String? notes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestItemEntity() when $default != null:
        return $default(_that.id, _that.description, _that.quantity, _that.unit,
            _that.notes);
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
    TResult Function(String id, String description, num quantity, String unit,
            String? notes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestItemEntity():
        return $default(_that.id, _that.description, _that.quantity, _that.unit,
            _that.notes);
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
    TResult? Function(String id, String description, num quantity, String unit,
            String? notes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestItemEntity() when $default != null:
        return $default(_that.id, _that.description, _that.quantity, _that.unit,
            _that.notes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PurchaseRequestItemEntity implements PurchaseRequestItemEntity {
  const _PurchaseRequestItemEntity(
      {required this.id,
      required this.description,
      required this.quantity,
      required this.unit,
      this.notes});
  factory _PurchaseRequestItemEntity.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestItemEntityFromJson(json);

  @override
  final String id;
  @override
  final String description;
  @override
  final num quantity;
  @override
  final String unit;
  @override
  final String? notes;

  /// Create a copy of PurchaseRequestItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PurchaseRequestItemEntityCopyWith<_PurchaseRequestItemEntity>
      get copyWith =>
          __$PurchaseRequestItemEntityCopyWithImpl<_PurchaseRequestItemEntity>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PurchaseRequestItemEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PurchaseRequestItemEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, description, quantity, unit, notes);

  @override
  String toString() {
    return 'PurchaseRequestItemEntity(id: $id, description: $description, quantity: $quantity, unit: $unit, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class _$PurchaseRequestItemEntityCopyWith<$Res>
    implements $PurchaseRequestItemEntityCopyWith<$Res> {
  factory _$PurchaseRequestItemEntityCopyWith(_PurchaseRequestItemEntity value,
          $Res Function(_PurchaseRequestItemEntity) _then) =
      __$PurchaseRequestItemEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String description,
      num quantity,
      String unit,
      String? notes});
}

/// @nodoc
class __$PurchaseRequestItemEntityCopyWithImpl<$Res>
    implements _$PurchaseRequestItemEntityCopyWith<$Res> {
  __$PurchaseRequestItemEntityCopyWithImpl(this._self, this._then);

  final _PurchaseRequestItemEntity _self;
  final $Res Function(_PurchaseRequestItemEntity) _then;

  /// Create a copy of PurchaseRequestItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? quantity = null,
    Object? unit = null,
    Object? notes = freezed,
  }) {
    return _then(_PurchaseRequestItemEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as num,
      unit: null == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$PurchaseRequestDeliveryEntity {
  String? get department;
  String get city;
  String get address;
  String? get info;

  /// Create a copy of PurchaseRequestDeliveryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PurchaseRequestDeliveryEntityCopyWith<PurchaseRequestDeliveryEntity>
      get copyWith => _$PurchaseRequestDeliveryEntityCopyWithImpl<
              PurchaseRequestDeliveryEntity>(
          this as PurchaseRequestDeliveryEntity, _$identity);

  /// Serializes this PurchaseRequestDeliveryEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PurchaseRequestDeliveryEntity &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.info, info) || other.info == info));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, department, city, address, info);

  @override
  String toString() {
    return 'PurchaseRequestDeliveryEntity(department: $department, city: $city, address: $address, info: $info)';
  }
}

/// @nodoc
abstract mixin class $PurchaseRequestDeliveryEntityCopyWith<$Res> {
  factory $PurchaseRequestDeliveryEntityCopyWith(
          PurchaseRequestDeliveryEntity value,
          $Res Function(PurchaseRequestDeliveryEntity) _then) =
      _$PurchaseRequestDeliveryEntityCopyWithImpl;
  @useResult
  $Res call({String? department, String city, String address, String? info});
}

/// @nodoc
class _$PurchaseRequestDeliveryEntityCopyWithImpl<$Res>
    implements $PurchaseRequestDeliveryEntityCopyWith<$Res> {
  _$PurchaseRequestDeliveryEntityCopyWithImpl(this._self, this._then);

  final PurchaseRequestDeliveryEntity _self;
  final $Res Function(PurchaseRequestDeliveryEntity) _then;

  /// Create a copy of PurchaseRequestDeliveryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? department = freezed,
    Object? city = null,
    Object? address = null,
    Object? info = freezed,
  }) {
    return _then(_self.copyWith(
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      info: freezed == info
          ? _self.info
          : info // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PurchaseRequestDeliveryEntity].
extension PurchaseRequestDeliveryEntityPatterns
    on PurchaseRequestDeliveryEntity {
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
    TResult Function(_PurchaseRequestDeliveryEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestDeliveryEntity() when $default != null:
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
    TResult Function(_PurchaseRequestDeliveryEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestDeliveryEntity():
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
    TResult? Function(_PurchaseRequestDeliveryEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestDeliveryEntity() when $default != null:
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
            String? department, String city, String address, String? info)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestDeliveryEntity() when $default != null:
        return $default(
            _that.department, _that.city, _that.address, _that.info);
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
            String? department, String city, String address, String? info)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestDeliveryEntity():
        return $default(
            _that.department, _that.city, _that.address, _that.info);
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
            String? department, String city, String address, String? info)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseRequestDeliveryEntity() when $default != null:
        return $default(
            _that.department, _that.city, _that.address, _that.info);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PurchaseRequestDeliveryEntity implements PurchaseRequestDeliveryEntity {
  const _PurchaseRequestDeliveryEntity(
      {this.department, required this.city, required this.address, this.info});
  factory _PurchaseRequestDeliveryEntity.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestDeliveryEntityFromJson(json);

  @override
  final String? department;
  @override
  final String city;
  @override
  final String address;
  @override
  final String? info;

  /// Create a copy of PurchaseRequestDeliveryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PurchaseRequestDeliveryEntityCopyWith<_PurchaseRequestDeliveryEntity>
      get copyWith => __$PurchaseRequestDeliveryEntityCopyWithImpl<
          _PurchaseRequestDeliveryEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PurchaseRequestDeliveryEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PurchaseRequestDeliveryEntity &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.info, info) || other.info == info));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, department, city, address, info);

  @override
  String toString() {
    return 'PurchaseRequestDeliveryEntity(department: $department, city: $city, address: $address, info: $info)';
  }
}

/// @nodoc
abstract mixin class _$PurchaseRequestDeliveryEntityCopyWith<$Res>
    implements $PurchaseRequestDeliveryEntityCopyWith<$Res> {
  factory _$PurchaseRequestDeliveryEntityCopyWith(
          _PurchaseRequestDeliveryEntity value,
          $Res Function(_PurchaseRequestDeliveryEntity) _then) =
      __$PurchaseRequestDeliveryEntityCopyWithImpl;
  @override
  @useResult
  $Res call({String? department, String city, String address, String? info});
}

/// @nodoc
class __$PurchaseRequestDeliveryEntityCopyWithImpl<$Res>
    implements _$PurchaseRequestDeliveryEntityCopyWith<$Res> {
  __$PurchaseRequestDeliveryEntityCopyWithImpl(this._self, this._then);

  final _PurchaseRequestDeliveryEntity _self;
  final $Res Function(_PurchaseRequestDeliveryEntity) _then;

  /// Create a copy of PurchaseRequestDeliveryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? department = freezed,
    Object? city = null,
    Object? address = null,
    Object? info = freezed,
  }) {
    return _then(_PurchaseRequestDeliveryEntity(
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      info: freezed == info
          ? _self.info
          : info // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$PurchaseRequestEntity {
  String get id;
  String get orgId;
  String get title;
  PurchaseRequestTypeInput get type;
  String? get category;
  PurchaseRequestOriginInput get originType;
  String? get assetId;
  String? get notes;
  PurchaseRequestDeliveryEntity? get delivery;

  /// Cuenta de ítems (útil para list/detail sin cargar ítems detallados).
  int get itemsCount;

  /// Ítems detallados. Puede venir vacío cuando la entidad nace de cache.
  List<PurchaseRequestItemEntity> get items;
  List<String> get vendorContactIds;

  /// Estado wire-stable: sent | partially_responded | responded | closed.
  String get status;
  int get respuestasCount;
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
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.originType, originType) ||
                other.originType == originType) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.delivery, delivery) ||
                other.delivery == delivery) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            const DeepCollectionEquality()
                .equals(other.vendorContactIds, vendorContactIds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.respuestasCount, respuestasCount) ||
                other.respuestasCount == respuestasCount) &&
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
      title,
      type,
      category,
      originType,
      assetId,
      notes,
      delivery,
      itemsCount,
      const DeepCollectionEquality().hash(items),
      const DeepCollectionEquality().hash(vendorContactIds),
      status,
      respuestasCount,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'PurchaseRequestEntity(id: $id, orgId: $orgId, title: $title, type: $type, category: $category, originType: $originType, assetId: $assetId, notes: $notes, delivery: $delivery, itemsCount: $itemsCount, items: $items, vendorContactIds: $vendorContactIds, status: $status, respuestasCount: $respuestasCount, createdAt: $createdAt, updatedAt: $updatedAt)';
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
      String title,
      PurchaseRequestTypeInput type,
      String? category,
      PurchaseRequestOriginInput originType,
      String? assetId,
      String? notes,
      PurchaseRequestDeliveryEntity? delivery,
      int itemsCount,
      List<PurchaseRequestItemEntity> items,
      List<String> vendorContactIds,
      String status,
      int respuestasCount,
      DateTime? createdAt,
      DateTime? updatedAt});

  $PurchaseRequestDeliveryEntityCopyWith<$Res>? get delivery;
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
    Object? title = null,
    Object? type = null,
    Object? category = freezed,
    Object? originType = null,
    Object? assetId = freezed,
    Object? notes = freezed,
    Object? delivery = freezed,
    Object? itemsCount = null,
    Object? items = null,
    Object? vendorContactIds = null,
    Object? status = null,
    Object? respuestasCount = null,
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
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as PurchaseRequestTypeInput,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      originType: null == originType
          ? _self.originType
          : originType // ignore: cast_nullable_to_non_nullable
              as PurchaseRequestOriginInput,
      assetId: freezed == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      delivery: freezed == delivery
          ? _self.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as PurchaseRequestDeliveryEntity?,
      itemsCount: null == itemsCount
          ? _self.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PurchaseRequestItemEntity>,
      vendorContactIds: null == vendorContactIds
          ? _self.vendorContactIds
          : vendorContactIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      respuestasCount: null == respuestasCount
          ? _self.respuestasCount
          : respuestasCount // ignore: cast_nullable_to_non_nullable
              as int,
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

  /// Create a copy of PurchaseRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PurchaseRequestDeliveryEntityCopyWith<$Res>? get delivery {
    if (_self.delivery == null) {
      return null;
    }

    return $PurchaseRequestDeliveryEntityCopyWith<$Res>(_self.delivery!,
        (value) {
      return _then(_self.copyWith(delivery: value));
    });
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
            String title,
            PurchaseRequestTypeInput type,
            String? category,
            PurchaseRequestOriginInput originType,
            String? assetId,
            String? notes,
            PurchaseRequestDeliveryEntity? delivery,
            int itemsCount,
            List<PurchaseRequestItemEntity> items,
            List<String> vendorContactIds,
            String status,
            int respuestasCount,
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
            _that.title,
            _that.type,
            _that.category,
            _that.originType,
            _that.assetId,
            _that.notes,
            _that.delivery,
            _that.itemsCount,
            _that.items,
            _that.vendorContactIds,
            _that.status,
            _that.respuestasCount,
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
            String title,
            PurchaseRequestTypeInput type,
            String? category,
            PurchaseRequestOriginInput originType,
            String? assetId,
            String? notes,
            PurchaseRequestDeliveryEntity? delivery,
            int itemsCount,
            List<PurchaseRequestItemEntity> items,
            List<String> vendorContactIds,
            String status,
            int respuestasCount,
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
            _that.title,
            _that.type,
            _that.category,
            _that.originType,
            _that.assetId,
            _that.notes,
            _that.delivery,
            _that.itemsCount,
            _that.items,
            _that.vendorContactIds,
            _that.status,
            _that.respuestasCount,
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
            String title,
            PurchaseRequestTypeInput type,
            String? category,
            PurchaseRequestOriginInput originType,
            String? assetId,
            String? notes,
            PurchaseRequestDeliveryEntity? delivery,
            int itemsCount,
            List<PurchaseRequestItemEntity> items,
            List<String> vendorContactIds,
            String status,
            int respuestasCount,
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
            _that.title,
            _that.type,
            _that.category,
            _that.originType,
            _that.assetId,
            _that.notes,
            _that.delivery,
            _that.itemsCount,
            _that.items,
            _that.vendorContactIds,
            _that.status,
            _that.respuestasCount,
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
      required this.title,
      required this.type,
      this.category,
      required this.originType,
      this.assetId,
      this.notes,
      this.delivery,
      this.itemsCount = 0,
      final List<PurchaseRequestItemEntity> items =
          const <PurchaseRequestItemEntity>[],
      final List<String> vendorContactIds = const <String>[],
      required this.status,
      this.respuestasCount = 0,
      this.createdAt,
      this.updatedAt})
      : _items = items,
        _vendorContactIds = vendorContactIds;
  factory _PurchaseRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestEntityFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String title;
  @override
  final PurchaseRequestTypeInput type;
  @override
  final String? category;
  @override
  final PurchaseRequestOriginInput originType;
  @override
  final String? assetId;
  @override
  final String? notes;
  @override
  final PurchaseRequestDeliveryEntity? delivery;

  /// Cuenta de ítems (útil para list/detail sin cargar ítems detallados).
  @override
  @JsonKey()
  final int itemsCount;

  /// Ítems detallados. Puede venir vacío cuando la entidad nace de cache.
  final List<PurchaseRequestItemEntity> _items;

  /// Ítems detallados. Puede venir vacío cuando la entidad nace de cache.
  @override
  @JsonKey()
  List<PurchaseRequestItemEntity> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<String> _vendorContactIds;
  @override
  @JsonKey()
  List<String> get vendorContactIds {
    if (_vendorContactIds is EqualUnmodifiableListView)
      return _vendorContactIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vendorContactIds);
  }

  /// Estado wire-stable: sent | partially_responded | responded | closed.
  @override
  final String status;
  @override
  @JsonKey()
  final int respuestasCount;
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
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.originType, originType) ||
                other.originType == originType) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.delivery, delivery) ||
                other.delivery == delivery) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._vendorContactIds, _vendorContactIds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.respuestasCount, respuestasCount) ||
                other.respuestasCount == respuestasCount) &&
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
      title,
      type,
      category,
      originType,
      assetId,
      notes,
      delivery,
      itemsCount,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_vendorContactIds),
      status,
      respuestasCount,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'PurchaseRequestEntity(id: $id, orgId: $orgId, title: $title, type: $type, category: $category, originType: $originType, assetId: $assetId, notes: $notes, delivery: $delivery, itemsCount: $itemsCount, items: $items, vendorContactIds: $vendorContactIds, status: $status, respuestasCount: $respuestasCount, createdAt: $createdAt, updatedAt: $updatedAt)';
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
      String title,
      PurchaseRequestTypeInput type,
      String? category,
      PurchaseRequestOriginInput originType,
      String? assetId,
      String? notes,
      PurchaseRequestDeliveryEntity? delivery,
      int itemsCount,
      List<PurchaseRequestItemEntity> items,
      List<String> vendorContactIds,
      String status,
      int respuestasCount,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $PurchaseRequestDeliveryEntityCopyWith<$Res>? get delivery;
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
    Object? title = null,
    Object? type = null,
    Object? category = freezed,
    Object? originType = null,
    Object? assetId = freezed,
    Object? notes = freezed,
    Object? delivery = freezed,
    Object? itemsCount = null,
    Object? items = null,
    Object? vendorContactIds = null,
    Object? status = null,
    Object? respuestasCount = null,
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
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as PurchaseRequestTypeInput,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      originType: null == originType
          ? _self.originType
          : originType // ignore: cast_nullable_to_non_nullable
              as PurchaseRequestOriginInput,
      assetId: freezed == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      delivery: freezed == delivery
          ? _self.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as PurchaseRequestDeliveryEntity?,
      itemsCount: null == itemsCount
          ? _self.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PurchaseRequestItemEntity>,
      vendorContactIds: null == vendorContactIds
          ? _self._vendorContactIds
          : vendorContactIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      respuestasCount: null == respuestasCount
          ? _self.respuestasCount
          : respuestasCount // ignore: cast_nullable_to_non_nullable
              as int,
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

  /// Create a copy of PurchaseRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PurchaseRequestDeliveryEntityCopyWith<$Res>? get delivery {
    if (_self.delivery == null) {
      return null;
    }

    return $PurchaseRequestDeliveryEntityCopyWith<$Res>(_self.delivery!,
        (value) {
      return _then(_self.copyWith(delivery: value));
    });
  }
}

// dart format on
