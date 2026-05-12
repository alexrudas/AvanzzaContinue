// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_branch_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProviderBranchEntity {
  /// UUID local del workspace — permite CRUD desde la UI.
  String get id;

  /// Etiqueta humana opcional ("Sede Norte", "Bodega", "Punto Chapinero").
  /// Si es null, la UI deriva un label por ciudad/dirección.
  String? get label;

  /// País de la sede. Reusa catálogo geo del proyecto.
  String? get countryId;

  /// Departamento / región.
  String? get regionId;

  /// Ciudad.
  String? get cityId;

  /// Dirección de calle libre (complemento a cityId).
  String? get addressLine;

  /// Teléfono local de la sede, en formato E.164 canónico.
  /// Validación/normalización responsabilidad del input (ver `PhoneField`).
  String? get phoneE164;

  /// Nombre del contacto específico de la sede (ej. "Andrés — jefe de
  /// bodega"). Opcional. Campo público.
  String? get contactName;

  /// Observaciones operativas de la sede. Público, sincroniza al workspace.
  /// (Las notas PRIVADAS del proveedor viven en `LocalContactEntity.notesPrivate`).
  String? get notes;

  /// Create a copy of ProviderBranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProviderBranchEntityCopyWith<ProviderBranchEntity> get copyWith =>
      _$ProviderBranchEntityCopyWithImpl<ProviderBranchEntity>(
          this as ProviderBranchEntity, _$identity);

  /// Serializes this ProviderBranchEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProviderBranchEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.addressLine, addressLine) ||
                other.addressLine == addressLine) &&
            (identical(other.phoneE164, phoneE164) ||
                other.phoneE164 == phoneE164) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, label, countryId, regionId,
      cityId, addressLine, phoneE164, contactName, notes);

  @override
  String toString() {
    return 'ProviderBranchEntity(id: $id, label: $label, countryId: $countryId, regionId: $regionId, cityId: $cityId, addressLine: $addressLine, phoneE164: $phoneE164, contactName: $contactName, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class $ProviderBranchEntityCopyWith<$Res> {
  factory $ProviderBranchEntityCopyWith(ProviderBranchEntity value,
          $Res Function(ProviderBranchEntity) _then) =
      _$ProviderBranchEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? label,
      String? countryId,
      String? regionId,
      String? cityId,
      String? addressLine,
      String? phoneE164,
      String? contactName,
      String? notes});
}

/// @nodoc
class _$ProviderBranchEntityCopyWithImpl<$Res>
    implements $ProviderBranchEntityCopyWith<$Res> {
  _$ProviderBranchEntityCopyWithImpl(this._self, this._then);

  final ProviderBranchEntity _self;
  final $Res Function(ProviderBranchEntity) _then;

  /// Create a copy of ProviderBranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = freezed,
    Object? countryId = freezed,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? addressLine = freezed,
    Object? phoneE164 = freezed,
    Object? contactName = freezed,
    Object? notes = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      countryId: freezed == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String?,
      regionId: freezed == regionId
          ? _self.regionId
          : regionId // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      addressLine: freezed == addressLine
          ? _self.addressLine
          : addressLine // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneE164: freezed == phoneE164
          ? _self.phoneE164
          : phoneE164 // ignore: cast_nullable_to_non_nullable
              as String?,
      contactName: freezed == contactName
          ? _self.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProviderBranchEntity].
extension ProviderBranchEntityPatterns on ProviderBranchEntity {
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
    TResult Function(_ProviderBranchEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProviderBranchEntity() when $default != null:
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
    TResult Function(_ProviderBranchEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProviderBranchEntity():
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
    TResult? Function(_ProviderBranchEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProviderBranchEntity() when $default != null:
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
            String? label,
            String? countryId,
            String? regionId,
            String? cityId,
            String? addressLine,
            String? phoneE164,
            String? contactName,
            String? notes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProviderBranchEntity() when $default != null:
        return $default(
            _that.id,
            _that.label,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.addressLine,
            _that.phoneE164,
            _that.contactName,
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
    TResult Function(
            String id,
            String? label,
            String? countryId,
            String? regionId,
            String? cityId,
            String? addressLine,
            String? phoneE164,
            String? contactName,
            String? notes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProviderBranchEntity():
        return $default(
            _that.id,
            _that.label,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.addressLine,
            _that.phoneE164,
            _that.contactName,
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
    TResult? Function(
            String id,
            String? label,
            String? countryId,
            String? regionId,
            String? cityId,
            String? addressLine,
            String? phoneE164,
            String? contactName,
            String? notes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProviderBranchEntity() when $default != null:
        return $default(
            _that.id,
            _that.label,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.addressLine,
            _that.phoneE164,
            _that.contactName,
            _that.notes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProviderBranchEntity implements ProviderBranchEntity {
  const _ProviderBranchEntity(
      {required this.id,
      this.label,
      this.countryId,
      this.regionId,
      this.cityId,
      this.addressLine,
      this.phoneE164,
      this.contactName,
      this.notes});
  factory _ProviderBranchEntity.fromJson(Map<String, dynamic> json) =>
      _$ProviderBranchEntityFromJson(json);

  /// UUID local del workspace — permite CRUD desde la UI.
  @override
  final String id;

  /// Etiqueta humana opcional ("Sede Norte", "Bodega", "Punto Chapinero").
  /// Si es null, la UI deriva un label por ciudad/dirección.
  @override
  final String? label;

  /// País de la sede. Reusa catálogo geo del proyecto.
  @override
  final String? countryId;

  /// Departamento / región.
  @override
  final String? regionId;

  /// Ciudad.
  @override
  final String? cityId;

  /// Dirección de calle libre (complemento a cityId).
  @override
  final String? addressLine;

  /// Teléfono local de la sede, en formato E.164 canónico.
  /// Validación/normalización responsabilidad del input (ver `PhoneField`).
  @override
  final String? phoneE164;

  /// Nombre del contacto específico de la sede (ej. "Andrés — jefe de
  /// bodega"). Opcional. Campo público.
  @override
  final String? contactName;

  /// Observaciones operativas de la sede. Público, sincroniza al workspace.
  /// (Las notas PRIVADAS del proveedor viven en `LocalContactEntity.notesPrivate`).
  @override
  final String? notes;

  /// Create a copy of ProviderBranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProviderBranchEntityCopyWith<_ProviderBranchEntity> get copyWith =>
      __$ProviderBranchEntityCopyWithImpl<_ProviderBranchEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProviderBranchEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProviderBranchEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.addressLine, addressLine) ||
                other.addressLine == addressLine) &&
            (identical(other.phoneE164, phoneE164) ||
                other.phoneE164 == phoneE164) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, label, countryId, regionId,
      cityId, addressLine, phoneE164, contactName, notes);

  @override
  String toString() {
    return 'ProviderBranchEntity(id: $id, label: $label, countryId: $countryId, regionId: $regionId, cityId: $cityId, addressLine: $addressLine, phoneE164: $phoneE164, contactName: $contactName, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class _$ProviderBranchEntityCopyWith<$Res>
    implements $ProviderBranchEntityCopyWith<$Res> {
  factory _$ProviderBranchEntityCopyWith(_ProviderBranchEntity value,
          $Res Function(_ProviderBranchEntity) _then) =
      __$ProviderBranchEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? label,
      String? countryId,
      String? regionId,
      String? cityId,
      String? addressLine,
      String? phoneE164,
      String? contactName,
      String? notes});
}

/// @nodoc
class __$ProviderBranchEntityCopyWithImpl<$Res>
    implements _$ProviderBranchEntityCopyWith<$Res> {
  __$ProviderBranchEntityCopyWithImpl(this._self, this._then);

  final _ProviderBranchEntity _self;
  final $Res Function(_ProviderBranchEntity) _then;

  /// Create a copy of ProviderBranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? label = freezed,
    Object? countryId = freezed,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? addressLine = freezed,
    Object? phoneE164 = freezed,
    Object? contactName = freezed,
    Object? notes = freezed,
  }) {
    return _then(_ProviderBranchEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      countryId: freezed == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String?,
      regionId: freezed == regionId
          ? _self.regionId
          : regionId // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      addressLine: freezed == addressLine
          ? _self.addressLine
          : addressLine // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneE164: freezed == phoneE164
          ? _self.phoneE164
          : phoneE164 // ignore: cast_nullable_to_non_nullable
              as String?,
      contactName: freezed == contactName
          ? _self.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
