// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProviderProfile {
  String get providerType; // 'articulos' | 'servicios'
  List<String>
      get assetTypeIds; // ['vehiculos','inmuebles','maquinaria','equipos','otros']
  String get businessCategoryId; // ej: 'lubricentro' | 'mecanico_independiente'
  List<String> get assetSegmentIds; // ej: ['moto','auto']
  List<String> get offeringLineIds; // opcional
  List<String> get coverageCities; // 'PAIS/REGION/CIUDAD'
  String? get branchId; // si aplica
  DateTime? get updatedAt;

  /// Create a copy of ProviderProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProviderProfileCopyWith<ProviderProfile> get copyWith =>
      _$ProviderProfileCopyWithImpl<ProviderProfile>(
          this as ProviderProfile, _$identity);

  /// Serializes this ProviderProfile to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProviderProfile &&
            (identical(other.providerType, providerType) ||
                other.providerType == providerType) &&
            const DeepCollectionEquality()
                .equals(other.assetTypeIds, assetTypeIds) &&
            (identical(other.businessCategoryId, businessCategoryId) ||
                other.businessCategoryId == businessCategoryId) &&
            const DeepCollectionEquality()
                .equals(other.assetSegmentIds, assetSegmentIds) &&
            const DeepCollectionEquality()
                .equals(other.offeringLineIds, offeringLineIds) &&
            const DeepCollectionEquality()
                .equals(other.coverageCities, coverageCities) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      providerType,
      const DeepCollectionEquality().hash(assetTypeIds),
      businessCategoryId,
      const DeepCollectionEquality().hash(assetSegmentIds),
      const DeepCollectionEquality().hash(offeringLineIds),
      const DeepCollectionEquality().hash(coverageCities),
      branchId,
      updatedAt);

  @override
  String toString() {
    return 'ProviderProfile(providerType: $providerType, assetTypeIds: $assetTypeIds, businessCategoryId: $businessCategoryId, assetSegmentIds: $assetSegmentIds, offeringLineIds: $offeringLineIds, coverageCities: $coverageCities, branchId: $branchId, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ProviderProfileCopyWith<$Res> {
  factory $ProviderProfileCopyWith(
          ProviderProfile value, $Res Function(ProviderProfile) _then) =
      _$ProviderProfileCopyWithImpl;
  @useResult
  $Res call(
      {String providerType,
      List<String> assetTypeIds,
      String businessCategoryId,
      List<String> assetSegmentIds,
      List<String> offeringLineIds,
      List<String> coverageCities,
      String? branchId,
      DateTime? updatedAt});
}

/// @nodoc
class _$ProviderProfileCopyWithImpl<$Res>
    implements $ProviderProfileCopyWith<$Res> {
  _$ProviderProfileCopyWithImpl(this._self, this._then);

  final ProviderProfile _self;
  final $Res Function(ProviderProfile) _then;

  /// Create a copy of ProviderProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? providerType = null,
    Object? assetTypeIds = null,
    Object? businessCategoryId = null,
    Object? assetSegmentIds = null,
    Object? offeringLineIds = null,
    Object? coverageCities = null,
    Object? branchId = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      providerType: null == providerType
          ? _self.providerType
          : providerType // ignore: cast_nullable_to_non_nullable
              as String,
      assetTypeIds: null == assetTypeIds
          ? _self.assetTypeIds
          : assetTypeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      businessCategoryId: null == businessCategoryId
          ? _self.businessCategoryId
          : businessCategoryId // ignore: cast_nullable_to_non_nullable
              as String,
      assetSegmentIds: null == assetSegmentIds
          ? _self.assetSegmentIds
          : assetSegmentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      offeringLineIds: null == offeringLineIds
          ? _self.offeringLineIds
          : offeringLineIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      coverageCities: null == coverageCities
          ? _self.coverageCities
          : coverageCities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      branchId: freezed == branchId
          ? _self.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProviderProfile].
extension ProviderProfilePatterns on ProviderProfile {
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
    TResult Function(_ProviderProfile value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProviderProfile() when $default != null:
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
    TResult Function(_ProviderProfile value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProviderProfile():
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
    TResult? Function(_ProviderProfile value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProviderProfile() when $default != null:
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
            String providerType,
            List<String> assetTypeIds,
            String businessCategoryId,
            List<String> assetSegmentIds,
            List<String> offeringLineIds,
            List<String> coverageCities,
            String? branchId,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProviderProfile() when $default != null:
        return $default(
            _that.providerType,
            _that.assetTypeIds,
            _that.businessCategoryId,
            _that.assetSegmentIds,
            _that.offeringLineIds,
            _that.coverageCities,
            _that.branchId,
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
            String providerType,
            List<String> assetTypeIds,
            String businessCategoryId,
            List<String> assetSegmentIds,
            List<String> offeringLineIds,
            List<String> coverageCities,
            String? branchId,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProviderProfile():
        return $default(
            _that.providerType,
            _that.assetTypeIds,
            _that.businessCategoryId,
            _that.assetSegmentIds,
            _that.offeringLineIds,
            _that.coverageCities,
            _that.branchId,
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
            String providerType,
            List<String> assetTypeIds,
            String businessCategoryId,
            List<String> assetSegmentIds,
            List<String> offeringLineIds,
            List<String> coverageCities,
            String? branchId,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProviderProfile() when $default != null:
        return $default(
            _that.providerType,
            _that.assetTypeIds,
            _that.businessCategoryId,
            _that.assetSegmentIds,
            _that.offeringLineIds,
            _that.coverageCities,
            _that.branchId,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProviderProfile implements ProviderProfile {
  const _ProviderProfile(
      {required this.providerType,
      final List<String> assetTypeIds = const <String>[],
      required this.businessCategoryId,
      final List<String> assetSegmentIds = const <String>[],
      final List<String> offeringLineIds = const <String>[],
      final List<String> coverageCities = const <String>[],
      this.branchId,
      this.updatedAt})
      : _assetTypeIds = assetTypeIds,
        _assetSegmentIds = assetSegmentIds,
        _offeringLineIds = offeringLineIds,
        _coverageCities = coverageCities;
  factory _ProviderProfile.fromJson(Map<String, dynamic> json) =>
      _$ProviderProfileFromJson(json);

  @override
  final String providerType;
// 'articulos' | 'servicios'
  final List<String> _assetTypeIds;
// 'articulos' | 'servicios'
  @override
  @JsonKey()
  List<String> get assetTypeIds {
    if (_assetTypeIds is EqualUnmodifiableListView) return _assetTypeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assetTypeIds);
  }

// ['vehiculos','inmuebles','maquinaria','equipos','otros']
  @override
  final String businessCategoryId;
// ej: 'lubricentro' | 'mecanico_independiente'
  final List<String> _assetSegmentIds;
// ej: 'lubricentro' | 'mecanico_independiente'
  @override
  @JsonKey()
  List<String> get assetSegmentIds {
    if (_assetSegmentIds is EqualUnmodifiableListView) return _assetSegmentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assetSegmentIds);
  }

// ej: ['moto','auto']
  final List<String> _offeringLineIds;
// ej: ['moto','auto']
  @override
  @JsonKey()
  List<String> get offeringLineIds {
    if (_offeringLineIds is EqualUnmodifiableListView) return _offeringLineIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_offeringLineIds);
  }

// opcional
  final List<String> _coverageCities;
// opcional
  @override
  @JsonKey()
  List<String> get coverageCities {
    if (_coverageCities is EqualUnmodifiableListView) return _coverageCities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coverageCities);
  }

// 'PAIS/REGION/CIUDAD'
  @override
  final String? branchId;
// si aplica
  @override
  final DateTime? updatedAt;

  /// Create a copy of ProviderProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProviderProfileCopyWith<_ProviderProfile> get copyWith =>
      __$ProviderProfileCopyWithImpl<_ProviderProfile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProviderProfileToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProviderProfile &&
            (identical(other.providerType, providerType) ||
                other.providerType == providerType) &&
            const DeepCollectionEquality()
                .equals(other._assetTypeIds, _assetTypeIds) &&
            (identical(other.businessCategoryId, businessCategoryId) ||
                other.businessCategoryId == businessCategoryId) &&
            const DeepCollectionEquality()
                .equals(other._assetSegmentIds, _assetSegmentIds) &&
            const DeepCollectionEquality()
                .equals(other._offeringLineIds, _offeringLineIds) &&
            const DeepCollectionEquality()
                .equals(other._coverageCities, _coverageCities) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      providerType,
      const DeepCollectionEquality().hash(_assetTypeIds),
      businessCategoryId,
      const DeepCollectionEquality().hash(_assetSegmentIds),
      const DeepCollectionEquality().hash(_offeringLineIds),
      const DeepCollectionEquality().hash(_coverageCities),
      branchId,
      updatedAt);

  @override
  String toString() {
    return 'ProviderProfile(providerType: $providerType, assetTypeIds: $assetTypeIds, businessCategoryId: $businessCategoryId, assetSegmentIds: $assetSegmentIds, offeringLineIds: $offeringLineIds, coverageCities: $coverageCities, branchId: $branchId, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$ProviderProfileCopyWith<$Res>
    implements $ProviderProfileCopyWith<$Res> {
  factory _$ProviderProfileCopyWith(
          _ProviderProfile value, $Res Function(_ProviderProfile) _then) =
      __$ProviderProfileCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String providerType,
      List<String> assetTypeIds,
      String businessCategoryId,
      List<String> assetSegmentIds,
      List<String> offeringLineIds,
      List<String> coverageCities,
      String? branchId,
      DateTime? updatedAt});
}

/// @nodoc
class __$ProviderProfileCopyWithImpl<$Res>
    implements _$ProviderProfileCopyWith<$Res> {
  __$ProviderProfileCopyWithImpl(this._self, this._then);

  final _ProviderProfile _self;
  final $Res Function(_ProviderProfile) _then;

  /// Create a copy of ProviderProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? providerType = null,
    Object? assetTypeIds = null,
    Object? businessCategoryId = null,
    Object? assetSegmentIds = null,
    Object? offeringLineIds = null,
    Object? coverageCities = null,
    Object? branchId = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_ProviderProfile(
      providerType: null == providerType
          ? _self.providerType
          : providerType // ignore: cast_nullable_to_non_nullable
              as String,
      assetTypeIds: null == assetTypeIds
          ? _self._assetTypeIds
          : assetTypeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      businessCategoryId: null == businessCategoryId
          ? _self.businessCategoryId
          : businessCategoryId // ignore: cast_nullable_to_non_nullable
              as String,
      assetSegmentIds: null == assetSegmentIds
          ? _self._assetSegmentIds
          : assetSegmentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      offeringLineIds: null == offeringLineIds
          ? _self._offeringLineIds
          : offeringLineIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      coverageCities: null == coverageCities
          ? _self._coverageCities
          : coverageCities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      branchId: freezed == branchId
          ? _self.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
