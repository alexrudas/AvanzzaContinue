// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LegalOwner {
  String get documentType;
  String get documentNumber;
  String get name;
  String get source;
  @SafeDateTimeConverter()
  DateTime get verifiedAt;

  /// Create a copy of LegalOwner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LegalOwnerCopyWith<LegalOwner> get copyWith =>
      _$LegalOwnerCopyWithImpl<LegalOwner>(this as LegalOwner, _$identity);

  /// Serializes this LegalOwner to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LegalOwner &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.documentNumber, documentNumber) ||
                other.documentNumber == documentNumber) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, documentType, documentNumber, name, source, verifiedAt);

  @override
  String toString() {
    return 'LegalOwner(documentType: $documentType, documentNumber: $documentNumber, name: $name, source: $source, verifiedAt: $verifiedAt)';
  }
}

/// @nodoc
abstract mixin class $LegalOwnerCopyWith<$Res> {
  factory $LegalOwnerCopyWith(
          LegalOwner value, $Res Function(LegalOwner) _then) =
      _$LegalOwnerCopyWithImpl;
  @useResult
  $Res call(
      {String documentType,
      String documentNumber,
      String name,
      String source,
      @SafeDateTimeConverter() DateTime verifiedAt});
}

/// @nodoc
class _$LegalOwnerCopyWithImpl<$Res> implements $LegalOwnerCopyWith<$Res> {
  _$LegalOwnerCopyWithImpl(this._self, this._then);

  final LegalOwner _self;
  final $Res Function(LegalOwner) _then;

  /// Create a copy of LegalOwner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = null,
    Object? documentNumber = null,
    Object? name = null,
    Object? source = null,
    Object? verifiedAt = null,
  }) {
    return _then(_self.copyWith(
      documentType: null == documentType
          ? _self.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      documentNumber: null == documentNumber
          ? _self.documentNumber
          : documentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      verifiedAt: null == verifiedAt
          ? _self.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [LegalOwner].
extension LegalOwnerPatterns on LegalOwner {
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
    TResult Function(_LegalOwner value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LegalOwner() when $default != null:
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
    TResult Function(_LegalOwner value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LegalOwner():
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
    TResult? Function(_LegalOwner value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LegalOwner() when $default != null:
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
    TResult Function(String documentType, String documentNumber, String name,
            String source, @SafeDateTimeConverter() DateTime verifiedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LegalOwner() when $default != null:
        return $default(_that.documentType, _that.documentNumber, _that.name,
            _that.source, _that.verifiedAt);
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
    TResult Function(String documentType, String documentNumber, String name,
            String source, @SafeDateTimeConverter() DateTime verifiedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LegalOwner():
        return $default(_that.documentType, _that.documentNumber, _that.name,
            _that.source, _that.verifiedAt);
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
    TResult? Function(String documentType, String documentNumber, String name,
            String source, @SafeDateTimeConverter() DateTime verifiedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LegalOwner() when $default != null:
        return $default(_that.documentType, _that.documentNumber, _that.name,
            _that.source, _that.verifiedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LegalOwner implements LegalOwner {
  const _LegalOwner(
      {required this.documentType,
      required this.documentNumber,
      required this.name,
      required this.source,
      @SafeDateTimeConverter() required this.verifiedAt});
  factory _LegalOwner.fromJson(Map<String, dynamic> json) =>
      _$LegalOwnerFromJson(json);

  @override
  final String documentType;
  @override
  final String documentNumber;
  @override
  final String name;
  @override
  final String source;
  @override
  @SafeDateTimeConverter()
  final DateTime verifiedAt;

  /// Create a copy of LegalOwner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LegalOwnerCopyWith<_LegalOwner> get copyWith =>
      __$LegalOwnerCopyWithImpl<_LegalOwner>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LegalOwnerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LegalOwner &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.documentNumber, documentNumber) ||
                other.documentNumber == documentNumber) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, documentType, documentNumber, name, source, verifiedAt);

  @override
  String toString() {
    return 'LegalOwner(documentType: $documentType, documentNumber: $documentNumber, name: $name, source: $source, verifiedAt: $verifiedAt)';
  }
}

/// @nodoc
abstract mixin class _$LegalOwnerCopyWith<$Res>
    implements $LegalOwnerCopyWith<$Res> {
  factory _$LegalOwnerCopyWith(
          _LegalOwner value, $Res Function(_LegalOwner) _then) =
      __$LegalOwnerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String documentType,
      String documentNumber,
      String name,
      String source,
      @SafeDateTimeConverter() DateTime verifiedAt});
}

/// @nodoc
class __$LegalOwnerCopyWithImpl<$Res> implements _$LegalOwnerCopyWith<$Res> {
  __$LegalOwnerCopyWithImpl(this._self, this._then);

  final _LegalOwner _self;
  final $Res Function(_LegalOwner) _then;

  /// Create a copy of LegalOwner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? documentType = null,
    Object? documentNumber = null,
    Object? name = null,
    Object? source = null,
    Object? verifiedAt = null,
  }) {
    return _then(_LegalOwner(
      documentType: null == documentType
          ? _self.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      documentNumber: null == documentNumber
          ? _self.documentNumber
          : documentNumber // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      verifiedAt: null == verifiedAt
          ? _self.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$BeneficialOwner {
  BeneficialOwnerType get ownerType;
  String get ownerId;
  String get ownerName;
  OwnershipRelationship get relationship;
  @SafeDateTimeConverter()
  DateTime get assignedAt;
  String get assignedBy;

  /// Create a copy of BeneficialOwner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BeneficialOwnerCopyWith<BeneficialOwner> get copyWith =>
      _$BeneficialOwnerCopyWithImpl<BeneficialOwner>(
          this as BeneficialOwner, _$identity);

  /// Serializes this BeneficialOwner to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BeneficialOwner &&
            (identical(other.ownerType, ownerType) ||
                other.ownerType == ownerType) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt) &&
            (identical(other.assignedBy, assignedBy) ||
                other.assignedBy == assignedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ownerType, ownerId, ownerName,
      relationship, assignedAt, assignedBy);

  @override
  String toString() {
    return 'BeneficialOwner(ownerType: $ownerType, ownerId: $ownerId, ownerName: $ownerName, relationship: $relationship, assignedAt: $assignedAt, assignedBy: $assignedBy)';
  }
}

/// @nodoc
abstract mixin class $BeneficialOwnerCopyWith<$Res> {
  factory $BeneficialOwnerCopyWith(
          BeneficialOwner value, $Res Function(BeneficialOwner) _then) =
      _$BeneficialOwnerCopyWithImpl;
  @useResult
  $Res call(
      {BeneficialOwnerType ownerType,
      String ownerId,
      String ownerName,
      OwnershipRelationship relationship,
      @SafeDateTimeConverter() DateTime assignedAt,
      String assignedBy});
}

/// @nodoc
class _$BeneficialOwnerCopyWithImpl<$Res>
    implements $BeneficialOwnerCopyWith<$Res> {
  _$BeneficialOwnerCopyWithImpl(this._self, this._then);

  final BeneficialOwner _self;
  final $Res Function(BeneficialOwner) _then;

  /// Create a copy of BeneficialOwner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ownerType = null,
    Object? ownerId = null,
    Object? ownerName = null,
    Object? relationship = null,
    Object? assignedAt = null,
    Object? assignedBy = null,
  }) {
    return _then(_self.copyWith(
      ownerType: null == ownerType
          ? _self.ownerType
          : ownerType // ignore: cast_nullable_to_non_nullable
              as BeneficialOwnerType,
      ownerId: null == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: null == ownerName
          ? _self.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      relationship: null == relationship
          ? _self.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as OwnershipRelationship,
      assignedAt: null == assignedAt
          ? _self.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      assignedBy: null == assignedBy
          ? _self.assignedBy
          : assignedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [BeneficialOwner].
extension BeneficialOwnerPatterns on BeneficialOwner {
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
    TResult Function(_BeneficialOwner value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BeneficialOwner() when $default != null:
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
    TResult Function(_BeneficialOwner value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeneficialOwner():
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
    TResult? Function(_BeneficialOwner value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeneficialOwner() when $default != null:
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
            BeneficialOwnerType ownerType,
            String ownerId,
            String ownerName,
            OwnershipRelationship relationship,
            @SafeDateTimeConverter() DateTime assignedAt,
            String assignedBy)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BeneficialOwner() when $default != null:
        return $default(_that.ownerType, _that.ownerId, _that.ownerName,
            _that.relationship, _that.assignedAt, _that.assignedBy);
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
            BeneficialOwnerType ownerType,
            String ownerId,
            String ownerName,
            OwnershipRelationship relationship,
            @SafeDateTimeConverter() DateTime assignedAt,
            String assignedBy)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeneficialOwner():
        return $default(_that.ownerType, _that.ownerId, _that.ownerName,
            _that.relationship, _that.assignedAt, _that.assignedBy);
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
            BeneficialOwnerType ownerType,
            String ownerId,
            String ownerName,
            OwnershipRelationship relationship,
            @SafeDateTimeConverter() DateTime assignedAt,
            String assignedBy)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeneficialOwner() when $default != null:
        return $default(_that.ownerType, _that.ownerId, _that.ownerName,
            _that.relationship, _that.assignedAt, _that.assignedBy);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BeneficialOwner implements BeneficialOwner {
  const _BeneficialOwner(
      {required this.ownerType,
      required this.ownerId,
      required this.ownerName,
      required this.relationship,
      @SafeDateTimeConverter() required this.assignedAt,
      required this.assignedBy});
  factory _BeneficialOwner.fromJson(Map<String, dynamic> json) =>
      _$BeneficialOwnerFromJson(json);

  @override
  final BeneficialOwnerType ownerType;
  @override
  final String ownerId;
  @override
  final String ownerName;
  @override
  final OwnershipRelationship relationship;
  @override
  @SafeDateTimeConverter()
  final DateTime assignedAt;
  @override
  final String assignedBy;

  /// Create a copy of BeneficialOwner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BeneficialOwnerCopyWith<_BeneficialOwner> get copyWith =>
      __$BeneficialOwnerCopyWithImpl<_BeneficialOwner>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BeneficialOwnerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BeneficialOwner &&
            (identical(other.ownerType, ownerType) ||
                other.ownerType == ownerType) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt) &&
            (identical(other.assignedBy, assignedBy) ||
                other.assignedBy == assignedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ownerType, ownerId, ownerName,
      relationship, assignedAt, assignedBy);

  @override
  String toString() {
    return 'BeneficialOwner(ownerType: $ownerType, ownerId: $ownerId, ownerName: $ownerName, relationship: $relationship, assignedAt: $assignedAt, assignedBy: $assignedBy)';
  }
}

/// @nodoc
abstract mixin class _$BeneficialOwnerCopyWith<$Res>
    implements $BeneficialOwnerCopyWith<$Res> {
  factory _$BeneficialOwnerCopyWith(
          _BeneficialOwner value, $Res Function(_BeneficialOwner) _then) =
      __$BeneficialOwnerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {BeneficialOwnerType ownerType,
      String ownerId,
      String ownerName,
      OwnershipRelationship relationship,
      @SafeDateTimeConverter() DateTime assignedAt,
      String assignedBy});
}

/// @nodoc
class __$BeneficialOwnerCopyWithImpl<$Res>
    implements _$BeneficialOwnerCopyWith<$Res> {
  __$BeneficialOwnerCopyWithImpl(this._self, this._then);

  final _BeneficialOwner _self;
  final $Res Function(_BeneficialOwner) _then;

  /// Create a copy of BeneficialOwner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ownerType = null,
    Object? ownerId = null,
    Object? ownerName = null,
    Object? relationship = null,
    Object? assignedAt = null,
    Object? assignedBy = null,
  }) {
    return _then(_BeneficialOwner(
      ownerType: null == ownerType
          ? _self.ownerType
          : ownerType // ignore: cast_nullable_to_non_nullable
              as BeneficialOwnerType,
      ownerId: null == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: null == ownerName
          ? _self.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      relationship: null == relationship
          ? _self.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as OwnershipRelationship,
      assignedAt: null == assignedAt
          ? _self.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      assignedBy: null == assignedBy
          ? _self.assignedBy
          : assignedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$AssetEntity {
  String get id;

  /// assetKey derivado del contenido (INVARIANTE: == content.assetKey)
  String get assetKey;
  AssetType get type;
  AssetState get state;
  AssetContent get content;
  LegalOwner? get legalOwner;
  BeneficialOwner? get beneficialOwner;
  String? get snapshotId;
  String? get portfolioId;
  Map<String, dynamic> get metadata;
  @SafeDateTimeConverter()
  DateTime get createdAt;
  @SafeDateTimeConverter()
  DateTime get updatedAt;

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetEntityCopyWith<AssetEntity> get copyWith =>
      _$AssetEntityCopyWithImpl<AssetEntity>(this as AssetEntity, _$identity);

  /// Serializes this AssetEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetKey, assetKey) ||
                other.assetKey == assetKey) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.legalOwner, legalOwner) ||
                other.legalOwner == legalOwner) &&
            (identical(other.beneficialOwner, beneficialOwner) ||
                other.beneficialOwner == beneficialOwner) &&
            (identical(other.snapshotId, snapshotId) ||
                other.snapshotId == snapshotId) &&
            (identical(other.portfolioId, portfolioId) ||
                other.portfolioId == portfolioId) &&
            const DeepCollectionEquality().equals(other.metadata, metadata) &&
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
      assetKey,
      type,
      state,
      content,
      legalOwner,
      beneficialOwner,
      snapshotId,
      portfolioId,
      const DeepCollectionEquality().hash(metadata),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AssetEntity(id: $id, assetKey: $assetKey, type: $type, state: $state, content: $content, legalOwner: $legalOwner, beneficialOwner: $beneficialOwner, snapshotId: $snapshotId, portfolioId: $portfolioId, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AssetEntityCopyWith<$Res> {
  factory $AssetEntityCopyWith(
          AssetEntity value, $Res Function(AssetEntity) _then) =
      _$AssetEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String assetKey,
      AssetType type,
      AssetState state,
      AssetContent content,
      LegalOwner? legalOwner,
      BeneficialOwner? beneficialOwner,
      String? snapshotId,
      String? portfolioId,
      Map<String, dynamic> metadata,
      @SafeDateTimeConverter() DateTime createdAt,
      @SafeDateTimeConverter() DateTime updatedAt});

  $AssetContentCopyWith<$Res> get content;
  $LegalOwnerCopyWith<$Res>? get legalOwner;
  $BeneficialOwnerCopyWith<$Res>? get beneficialOwner;
}

/// @nodoc
class _$AssetEntityCopyWithImpl<$Res> implements $AssetEntityCopyWith<$Res> {
  _$AssetEntityCopyWithImpl(this._self, this._then);

  final AssetEntity _self;
  final $Res Function(AssetEntity) _then;

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assetKey = null,
    Object? type = null,
    Object? state = null,
    Object? content = null,
    Object? legalOwner = freezed,
    Object? beneficialOwner = freezed,
    Object? snapshotId = freezed,
    Object? portfolioId = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assetKey: null == assetKey
          ? _self.assetKey
          : assetKey // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AssetType,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as AssetState,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as AssetContent,
      legalOwner: freezed == legalOwner
          ? _self.legalOwner
          : legalOwner // ignore: cast_nullable_to_non_nullable
              as LegalOwner?,
      beneficialOwner: freezed == beneficialOwner
          ? _self.beneficialOwner
          : beneficialOwner // ignore: cast_nullable_to_non_nullable
              as BeneficialOwner?,
      snapshotId: freezed == snapshotId
          ? _self.snapshotId
          : snapshotId // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolioId: freezed == portfolioId
          ? _self.portfolioId
          : portfolioId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssetContentCopyWith<$Res> get content {
    return $AssetContentCopyWith<$Res>(_self.content, (value) {
      return _then(_self.copyWith(content: value));
    });
  }

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LegalOwnerCopyWith<$Res>? get legalOwner {
    if (_self.legalOwner == null) {
      return null;
    }

    return $LegalOwnerCopyWith<$Res>(_self.legalOwner!, (value) {
      return _then(_self.copyWith(legalOwner: value));
    });
  }

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BeneficialOwnerCopyWith<$Res>? get beneficialOwner {
    if (_self.beneficialOwner == null) {
      return null;
    }

    return $BeneficialOwnerCopyWith<$Res>(_self.beneficialOwner!, (value) {
      return _then(_self.copyWith(beneficialOwner: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AssetEntity].
extension AssetEntityPatterns on AssetEntity {
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
    TResult Function(_AssetEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetEntity() when $default != null:
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
    TResult Function(_AssetEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetEntity():
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
    TResult? Function(_AssetEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetEntity() when $default != null:
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
            String assetKey,
            AssetType type,
            AssetState state,
            AssetContent content,
            LegalOwner? legalOwner,
            BeneficialOwner? beneficialOwner,
            String? snapshotId,
            String? portfolioId,
            Map<String, dynamic> metadata,
            @SafeDateTimeConverter() DateTime createdAt,
            @SafeDateTimeConverter() DateTime updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetEntity() when $default != null:
        return $default(
            _that.id,
            _that.assetKey,
            _that.type,
            _that.state,
            _that.content,
            _that.legalOwner,
            _that.beneficialOwner,
            _that.snapshotId,
            _that.portfolioId,
            _that.metadata,
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
            String assetKey,
            AssetType type,
            AssetState state,
            AssetContent content,
            LegalOwner? legalOwner,
            BeneficialOwner? beneficialOwner,
            String? snapshotId,
            String? portfolioId,
            Map<String, dynamic> metadata,
            @SafeDateTimeConverter() DateTime createdAt,
            @SafeDateTimeConverter() DateTime updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetEntity():
        return $default(
            _that.id,
            _that.assetKey,
            _that.type,
            _that.state,
            _that.content,
            _that.legalOwner,
            _that.beneficialOwner,
            _that.snapshotId,
            _that.portfolioId,
            _that.metadata,
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
            String assetKey,
            AssetType type,
            AssetState state,
            AssetContent content,
            LegalOwner? legalOwner,
            BeneficialOwner? beneficialOwner,
            String? snapshotId,
            String? portfolioId,
            Map<String, dynamic> metadata,
            @SafeDateTimeConverter() DateTime createdAt,
            @SafeDateTimeConverter() DateTime updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetEntity() when $default != null:
        return $default(
            _that.id,
            _that.assetKey,
            _that.type,
            _that.state,
            _that.content,
            _that.legalOwner,
            _that.beneficialOwner,
            _that.snapshotId,
            _that.portfolioId,
            _that.metadata,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssetEntity extends AssetEntity {
  const _AssetEntity(
      {required this.id,
      required this.assetKey,
      required this.type,
      this.state = AssetState.draft,
      required this.content,
      this.legalOwner,
      this.beneficialOwner,
      this.snapshotId,
      this.portfolioId,
      final Map<String, dynamic> metadata = const <String, dynamic>{},
      @SafeDateTimeConverter() required this.createdAt,
      @SafeDateTimeConverter() required this.updatedAt})
      : _metadata = metadata,
        super._();
  factory _AssetEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetEntityFromJson(json);

  @override
  final String id;

  /// assetKey derivado del contenido (INVARIANTE: == content.assetKey)
  @override
  final String assetKey;
  @override
  final AssetType type;
  @override
  @JsonKey()
  final AssetState state;
  @override
  final AssetContent content;
  @override
  final LegalOwner? legalOwner;
  @override
  final BeneficialOwner? beneficialOwner;
  @override
  final String? snapshotId;
  @override
  final String? portfolioId;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  @SafeDateTimeConverter()
  final DateTime createdAt;
  @override
  @SafeDateTimeConverter()
  final DateTime updatedAt;

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetEntityCopyWith<_AssetEntity> get copyWith =>
      __$AssetEntityCopyWithImpl<_AssetEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetKey, assetKey) ||
                other.assetKey == assetKey) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.legalOwner, legalOwner) ||
                other.legalOwner == legalOwner) &&
            (identical(other.beneficialOwner, beneficialOwner) ||
                other.beneficialOwner == beneficialOwner) &&
            (identical(other.snapshotId, snapshotId) ||
                other.snapshotId == snapshotId) &&
            (identical(other.portfolioId, portfolioId) ||
                other.portfolioId == portfolioId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
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
      assetKey,
      type,
      state,
      content,
      legalOwner,
      beneficialOwner,
      snapshotId,
      portfolioId,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AssetEntity(id: $id, assetKey: $assetKey, type: $type, state: $state, content: $content, legalOwner: $legalOwner, beneficialOwner: $beneficialOwner, snapshotId: $snapshotId, portfolioId: $portfolioId, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AssetEntityCopyWith<$Res>
    implements $AssetEntityCopyWith<$Res> {
  factory _$AssetEntityCopyWith(
          _AssetEntity value, $Res Function(_AssetEntity) _then) =
      __$AssetEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String assetKey,
      AssetType type,
      AssetState state,
      AssetContent content,
      LegalOwner? legalOwner,
      BeneficialOwner? beneficialOwner,
      String? snapshotId,
      String? portfolioId,
      Map<String, dynamic> metadata,
      @SafeDateTimeConverter() DateTime createdAt,
      @SafeDateTimeConverter() DateTime updatedAt});

  @override
  $AssetContentCopyWith<$Res> get content;
  @override
  $LegalOwnerCopyWith<$Res>? get legalOwner;
  @override
  $BeneficialOwnerCopyWith<$Res>? get beneficialOwner;
}

/// @nodoc
class __$AssetEntityCopyWithImpl<$Res> implements _$AssetEntityCopyWith<$Res> {
  __$AssetEntityCopyWithImpl(this._self, this._then);

  final _AssetEntity _self;
  final $Res Function(_AssetEntity) _then;

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? assetKey = null,
    Object? type = null,
    Object? state = null,
    Object? content = null,
    Object? legalOwner = freezed,
    Object? beneficialOwner = freezed,
    Object? snapshotId = freezed,
    Object? portfolioId = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_AssetEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assetKey: null == assetKey
          ? _self.assetKey
          : assetKey // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AssetType,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as AssetState,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as AssetContent,
      legalOwner: freezed == legalOwner
          ? _self.legalOwner
          : legalOwner // ignore: cast_nullable_to_non_nullable
              as LegalOwner?,
      beneficialOwner: freezed == beneficialOwner
          ? _self.beneficialOwner
          : beneficialOwner // ignore: cast_nullable_to_non_nullable
              as BeneficialOwner?,
      snapshotId: freezed == snapshotId
          ? _self.snapshotId
          : snapshotId // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolioId: freezed == portfolioId
          ? _self.portfolioId
          : portfolioId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _self._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssetContentCopyWith<$Res> get content {
    return $AssetContentCopyWith<$Res>(_self.content, (value) {
      return _then(_self.copyWith(content: value));
    });
  }

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LegalOwnerCopyWith<$Res>? get legalOwner {
    if (_self.legalOwner == null) {
      return null;
    }

    return $LegalOwnerCopyWith<$Res>(_self.legalOwner!, (value) {
      return _then(_self.copyWith(legalOwner: value));
    });
  }

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BeneficialOwnerCopyWith<$Res>? get beneficialOwner {
    if (_self.beneficialOwner == null) {
      return null;
    }

    return $BeneficialOwnerCopyWith<$Res>(_self.beneficialOwner!, (value) {
      return _then(_self.copyWith(beneficialOwner: value));
    });
  }
}

// dart format on
