// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PortfolioEntity {
  String get id;
  PortfolioType get portfolioType;
  String get portfolioName;
  String get countryId;
  String get cityId;

  /// Partition key del tenant SaaS.
  /// Permite consultar portafolios por organización activa.
  /// Wire-stable: nunca renombrar este campo.
  String get orgId;
  PortfolioStatus get status;
  int get assetsCount;
  String get createdBy;
  DateTime? get createdAt;
  DateTime?
      get updatedAt; // ── Snapshot del propietario VRC ────────────────────────────────────────
// Persistido al completar un batch VRC (completed | partially_completed).
// Null cuando el portafolio nunca pasó por un batch VRC.
// Wire-stable: no renombrar estos campos — están indexados en Isar.
  String? get ownerName;
  String? get ownerDocument;
  String? get ownerDocumentType;
  String? get licenseStatus;

  /// Fecha de vencimiento de la licencia (formato "DD/MM/YYYY" del RUNT).
  /// Derivada de la categoría con fecha más tardía en el batch VRC.
  String? get licenseExpiryDate;
  bool? get simitHasFines;

  /// Conteo total de infracciones SIMIT (todos los tipos).
  int? get simitFinesCount;

  /// Comparendos (infracciones de tránsito — dato firme del backend).
  int? get simitComparendosCount;

  /// Multas confirmadas (puede ser null si el backend aún no las envía).
  int? get simitMultasCount;
  String? get simitFormattedTotal;

  /// Timestamp de la consulta VRC que originó este snapshot.
  DateTime? get simitCheckedAt;

  /// Create a copy of PortfolioEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PortfolioEntityCopyWith<PortfolioEntity> get copyWith =>
      _$PortfolioEntityCopyWithImpl<PortfolioEntity>(
          this as PortfolioEntity, _$identity);

  /// Serializes this PortfolioEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PortfolioEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.portfolioType, portfolioType) ||
                other.portfolioType == portfolioType) &&
            (identical(other.portfolioName, portfolioName) ||
                other.portfolioName == portfolioName) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assetsCount, assetsCount) ||
                other.assetsCount == assetsCount) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerDocument, ownerDocument) ||
                other.ownerDocument == ownerDocument) &&
            (identical(other.ownerDocumentType, ownerDocumentType) ||
                other.ownerDocumentType == ownerDocumentType) &&
            (identical(other.licenseStatus, licenseStatus) ||
                other.licenseStatus == licenseStatus) &&
            (identical(other.licenseExpiryDate, licenseExpiryDate) ||
                other.licenseExpiryDate == licenseExpiryDate) &&
            (identical(other.simitHasFines, simitHasFines) ||
                other.simitHasFines == simitHasFines) &&
            (identical(other.simitFinesCount, simitFinesCount) ||
                other.simitFinesCount == simitFinesCount) &&
            (identical(other.simitComparendosCount, simitComparendosCount) ||
                other.simitComparendosCount == simitComparendosCount) &&
            (identical(other.simitMultasCount, simitMultasCount) ||
                other.simitMultasCount == simitMultasCount) &&
            (identical(other.simitFormattedTotal, simitFormattedTotal) ||
                other.simitFormattedTotal == simitFormattedTotal) &&
            (identical(other.simitCheckedAt, simitCheckedAt) ||
                other.simitCheckedAt == simitCheckedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        portfolioType,
        portfolioName,
        countryId,
        cityId,
        orgId,
        status,
        assetsCount,
        createdBy,
        createdAt,
        updatedAt,
        ownerName,
        ownerDocument,
        ownerDocumentType,
        licenseStatus,
        licenseExpiryDate,
        simitHasFines,
        simitFinesCount,
        simitComparendosCount,
        simitMultasCount,
        simitFormattedTotal,
        simitCheckedAt
      ]);

  @override
  String toString() {
    return 'PortfolioEntity(id: $id, portfolioType: $portfolioType, portfolioName: $portfolioName, countryId: $countryId, cityId: $cityId, orgId: $orgId, status: $status, assetsCount: $assetsCount, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, ownerName: $ownerName, ownerDocument: $ownerDocument, ownerDocumentType: $ownerDocumentType, licenseStatus: $licenseStatus, licenseExpiryDate: $licenseExpiryDate, simitHasFines: $simitHasFines, simitFinesCount: $simitFinesCount, simitComparendosCount: $simitComparendosCount, simitMultasCount: $simitMultasCount, simitFormattedTotal: $simitFormattedTotal, simitCheckedAt: $simitCheckedAt)';
  }
}

/// @nodoc
abstract mixin class $PortfolioEntityCopyWith<$Res> {
  factory $PortfolioEntityCopyWith(
          PortfolioEntity value, $Res Function(PortfolioEntity) _then) =
      _$PortfolioEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      PortfolioType portfolioType,
      String portfolioName,
      String countryId,
      String cityId,
      String orgId,
      PortfolioStatus status,
      int assetsCount,
      String createdBy,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? ownerName,
      String? ownerDocument,
      String? ownerDocumentType,
      String? licenseStatus,
      String? licenseExpiryDate,
      bool? simitHasFines,
      int? simitFinesCount,
      int? simitComparendosCount,
      int? simitMultasCount,
      String? simitFormattedTotal,
      DateTime? simitCheckedAt});
}

/// @nodoc
class _$PortfolioEntityCopyWithImpl<$Res>
    implements $PortfolioEntityCopyWith<$Res> {
  _$PortfolioEntityCopyWithImpl(this._self, this._then);

  final PortfolioEntity _self;
  final $Res Function(PortfolioEntity) _then;

  /// Create a copy of PortfolioEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? portfolioType = null,
    Object? portfolioName = null,
    Object? countryId = null,
    Object? cityId = null,
    Object? orgId = null,
    Object? status = null,
    Object? assetsCount = null,
    Object? createdBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? ownerName = freezed,
    Object? ownerDocument = freezed,
    Object? ownerDocumentType = freezed,
    Object? licenseStatus = freezed,
    Object? licenseExpiryDate = freezed,
    Object? simitHasFines = freezed,
    Object? simitFinesCount = freezed,
    Object? simitComparendosCount = freezed,
    Object? simitMultasCount = freezed,
    Object? simitFormattedTotal = freezed,
    Object? simitCheckedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      portfolioType: null == portfolioType
          ? _self.portfolioType
          : portfolioType // ignore: cast_nullable_to_non_nullable
              as PortfolioType,
      portfolioName: null == portfolioName
          ? _self.portfolioName
          : portfolioName // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      cityId: null == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PortfolioStatus,
      assetsCount: null == assetsCount
          ? _self.assetsCount
          : assetsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ownerName: freezed == ownerName
          ? _self.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerDocument: freezed == ownerDocument
          ? _self.ownerDocument
          : ownerDocument // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerDocumentType: freezed == ownerDocumentType
          ? _self.ownerDocumentType
          : ownerDocumentType // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseStatus: freezed == licenseStatus
          ? _self.licenseStatus
          : licenseStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseExpiryDate: freezed == licenseExpiryDate
          ? _self.licenseExpiryDate
          : licenseExpiryDate // ignore: cast_nullable_to_non_nullable
              as String?,
      simitHasFines: freezed == simitHasFines
          ? _self.simitHasFines
          : simitHasFines // ignore: cast_nullable_to_non_nullable
              as bool?,
      simitFinesCount: freezed == simitFinesCount
          ? _self.simitFinesCount
          : simitFinesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      simitComparendosCount: freezed == simitComparendosCount
          ? _self.simitComparendosCount
          : simitComparendosCount // ignore: cast_nullable_to_non_nullable
              as int?,
      simitMultasCount: freezed == simitMultasCount
          ? _self.simitMultasCount
          : simitMultasCount // ignore: cast_nullable_to_non_nullable
              as int?,
      simitFormattedTotal: freezed == simitFormattedTotal
          ? _self.simitFormattedTotal
          : simitFormattedTotal // ignore: cast_nullable_to_non_nullable
              as String?,
      simitCheckedAt: freezed == simitCheckedAt
          ? _self.simitCheckedAt
          : simitCheckedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PortfolioEntity].
extension PortfolioEntityPatterns on PortfolioEntity {
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
    TResult Function(_PortfolioEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioEntity() when $default != null:
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
    TResult Function(_PortfolioEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioEntity():
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
    TResult? Function(_PortfolioEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioEntity() when $default != null:
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
            PortfolioType portfolioType,
            String portfolioName,
            String countryId,
            String cityId,
            String orgId,
            PortfolioStatus status,
            int assetsCount,
            String createdBy,
            DateTime? createdAt,
            DateTime? updatedAt,
            String? ownerName,
            String? ownerDocument,
            String? ownerDocumentType,
            String? licenseStatus,
            String? licenseExpiryDate,
            bool? simitHasFines,
            int? simitFinesCount,
            int? simitComparendosCount,
            int? simitMultasCount,
            String? simitFormattedTotal,
            DateTime? simitCheckedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioEntity() when $default != null:
        return $default(
            _that.id,
            _that.portfolioType,
            _that.portfolioName,
            _that.countryId,
            _that.cityId,
            _that.orgId,
            _that.status,
            _that.assetsCount,
            _that.createdBy,
            _that.createdAt,
            _that.updatedAt,
            _that.ownerName,
            _that.ownerDocument,
            _that.ownerDocumentType,
            _that.licenseStatus,
            _that.licenseExpiryDate,
            _that.simitHasFines,
            _that.simitFinesCount,
            _that.simitComparendosCount,
            _that.simitMultasCount,
            _that.simitFormattedTotal,
            _that.simitCheckedAt);
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
            PortfolioType portfolioType,
            String portfolioName,
            String countryId,
            String cityId,
            String orgId,
            PortfolioStatus status,
            int assetsCount,
            String createdBy,
            DateTime? createdAt,
            DateTime? updatedAt,
            String? ownerName,
            String? ownerDocument,
            String? ownerDocumentType,
            String? licenseStatus,
            String? licenseExpiryDate,
            bool? simitHasFines,
            int? simitFinesCount,
            int? simitComparendosCount,
            int? simitMultasCount,
            String? simitFormattedTotal,
            DateTime? simitCheckedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioEntity():
        return $default(
            _that.id,
            _that.portfolioType,
            _that.portfolioName,
            _that.countryId,
            _that.cityId,
            _that.orgId,
            _that.status,
            _that.assetsCount,
            _that.createdBy,
            _that.createdAt,
            _that.updatedAt,
            _that.ownerName,
            _that.ownerDocument,
            _that.ownerDocumentType,
            _that.licenseStatus,
            _that.licenseExpiryDate,
            _that.simitHasFines,
            _that.simitFinesCount,
            _that.simitComparendosCount,
            _that.simitMultasCount,
            _that.simitFormattedTotal,
            _that.simitCheckedAt);
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
            PortfolioType portfolioType,
            String portfolioName,
            String countryId,
            String cityId,
            String orgId,
            PortfolioStatus status,
            int assetsCount,
            String createdBy,
            DateTime? createdAt,
            DateTime? updatedAt,
            String? ownerName,
            String? ownerDocument,
            String? ownerDocumentType,
            String? licenseStatus,
            String? licenseExpiryDate,
            bool? simitHasFines,
            int? simitFinesCount,
            int? simitComparendosCount,
            int? simitMultasCount,
            String? simitFormattedTotal,
            DateTime? simitCheckedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioEntity() when $default != null:
        return $default(
            _that.id,
            _that.portfolioType,
            _that.portfolioName,
            _that.countryId,
            _that.cityId,
            _that.orgId,
            _that.status,
            _that.assetsCount,
            _that.createdBy,
            _that.createdAt,
            _that.updatedAt,
            _that.ownerName,
            _that.ownerDocument,
            _that.ownerDocumentType,
            _that.licenseStatus,
            _that.licenseExpiryDate,
            _that.simitHasFines,
            _that.simitFinesCount,
            _that.simitComparendosCount,
            _that.simitMultasCount,
            _that.simitFormattedTotal,
            _that.simitCheckedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PortfolioEntity implements PortfolioEntity {
  const _PortfolioEntity(
      {required this.id,
      required this.portfolioType,
      required this.portfolioName,
      required this.countryId,
      required this.cityId,
      this.orgId = '',
      this.status = PortfolioStatus.draft,
      this.assetsCount = 0,
      required this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.ownerName = null,
      this.ownerDocument = null,
      this.ownerDocumentType = null,
      this.licenseStatus = null,
      this.licenseExpiryDate = null,
      this.simitHasFines = null,
      this.simitFinesCount = null,
      this.simitComparendosCount = null,
      this.simitMultasCount = null,
      this.simitFormattedTotal = null,
      this.simitCheckedAt = null});
  factory _PortfolioEntity.fromJson(Map<String, dynamic> json) =>
      _$PortfolioEntityFromJson(json);

  @override
  final String id;
  @override
  final PortfolioType portfolioType;
  @override
  final String portfolioName;
  @override
  final String countryId;
  @override
  final String cityId;

  /// Partition key del tenant SaaS.
  /// Permite consultar portafolios por organización activa.
  /// Wire-stable: nunca renombrar este campo.
  @override
  @JsonKey()
  final String orgId;
  @override
  @JsonKey()
  final PortfolioStatus status;
  @override
  @JsonKey()
  final int assetsCount;
  @override
  final String createdBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// ── Snapshot del propietario VRC ────────────────────────────────────────
// Persistido al completar un batch VRC (completed | partially_completed).
// Null cuando el portafolio nunca pasó por un batch VRC.
// Wire-stable: no renombrar estos campos — están indexados en Isar.
  @override
  @JsonKey()
  final String? ownerName;
  @override
  @JsonKey()
  final String? ownerDocument;
  @override
  @JsonKey()
  final String? ownerDocumentType;
  @override
  @JsonKey()
  final String? licenseStatus;

  /// Fecha de vencimiento de la licencia (formato "DD/MM/YYYY" del RUNT).
  /// Derivada de la categoría con fecha más tardía en el batch VRC.
  @override
  @JsonKey()
  final String? licenseExpiryDate;
  @override
  @JsonKey()
  final bool? simitHasFines;

  /// Conteo total de infracciones SIMIT (todos los tipos).
  @override
  @JsonKey()
  final int? simitFinesCount;

  /// Comparendos (infracciones de tránsito — dato firme del backend).
  @override
  @JsonKey()
  final int? simitComparendosCount;

  /// Multas confirmadas (puede ser null si el backend aún no las envía).
  @override
  @JsonKey()
  final int? simitMultasCount;
  @override
  @JsonKey()
  final String? simitFormattedTotal;

  /// Timestamp de la consulta VRC que originó este snapshot.
  @override
  @JsonKey()
  final DateTime? simitCheckedAt;

  /// Create a copy of PortfolioEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PortfolioEntityCopyWith<_PortfolioEntity> get copyWith =>
      __$PortfolioEntityCopyWithImpl<_PortfolioEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PortfolioEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PortfolioEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.portfolioType, portfolioType) ||
                other.portfolioType == portfolioType) &&
            (identical(other.portfolioName, portfolioName) ||
                other.portfolioName == portfolioName) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assetsCount, assetsCount) ||
                other.assetsCount == assetsCount) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerDocument, ownerDocument) ||
                other.ownerDocument == ownerDocument) &&
            (identical(other.ownerDocumentType, ownerDocumentType) ||
                other.ownerDocumentType == ownerDocumentType) &&
            (identical(other.licenseStatus, licenseStatus) ||
                other.licenseStatus == licenseStatus) &&
            (identical(other.licenseExpiryDate, licenseExpiryDate) ||
                other.licenseExpiryDate == licenseExpiryDate) &&
            (identical(other.simitHasFines, simitHasFines) ||
                other.simitHasFines == simitHasFines) &&
            (identical(other.simitFinesCount, simitFinesCount) ||
                other.simitFinesCount == simitFinesCount) &&
            (identical(other.simitComparendosCount, simitComparendosCount) ||
                other.simitComparendosCount == simitComparendosCount) &&
            (identical(other.simitMultasCount, simitMultasCount) ||
                other.simitMultasCount == simitMultasCount) &&
            (identical(other.simitFormattedTotal, simitFormattedTotal) ||
                other.simitFormattedTotal == simitFormattedTotal) &&
            (identical(other.simitCheckedAt, simitCheckedAt) ||
                other.simitCheckedAt == simitCheckedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        portfolioType,
        portfolioName,
        countryId,
        cityId,
        orgId,
        status,
        assetsCount,
        createdBy,
        createdAt,
        updatedAt,
        ownerName,
        ownerDocument,
        ownerDocumentType,
        licenseStatus,
        licenseExpiryDate,
        simitHasFines,
        simitFinesCount,
        simitComparendosCount,
        simitMultasCount,
        simitFormattedTotal,
        simitCheckedAt
      ]);

  @override
  String toString() {
    return 'PortfolioEntity(id: $id, portfolioType: $portfolioType, portfolioName: $portfolioName, countryId: $countryId, cityId: $cityId, orgId: $orgId, status: $status, assetsCount: $assetsCount, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, ownerName: $ownerName, ownerDocument: $ownerDocument, ownerDocumentType: $ownerDocumentType, licenseStatus: $licenseStatus, licenseExpiryDate: $licenseExpiryDate, simitHasFines: $simitHasFines, simitFinesCount: $simitFinesCount, simitComparendosCount: $simitComparendosCount, simitMultasCount: $simitMultasCount, simitFormattedTotal: $simitFormattedTotal, simitCheckedAt: $simitCheckedAt)';
  }
}

/// @nodoc
abstract mixin class _$PortfolioEntityCopyWith<$Res>
    implements $PortfolioEntityCopyWith<$Res> {
  factory _$PortfolioEntityCopyWith(
          _PortfolioEntity value, $Res Function(_PortfolioEntity) _then) =
      __$PortfolioEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      PortfolioType portfolioType,
      String portfolioName,
      String countryId,
      String cityId,
      String orgId,
      PortfolioStatus status,
      int assetsCount,
      String createdBy,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? ownerName,
      String? ownerDocument,
      String? ownerDocumentType,
      String? licenseStatus,
      String? licenseExpiryDate,
      bool? simitHasFines,
      int? simitFinesCount,
      int? simitComparendosCount,
      int? simitMultasCount,
      String? simitFormattedTotal,
      DateTime? simitCheckedAt});
}

/// @nodoc
class __$PortfolioEntityCopyWithImpl<$Res>
    implements _$PortfolioEntityCopyWith<$Res> {
  __$PortfolioEntityCopyWithImpl(this._self, this._then);

  final _PortfolioEntity _self;
  final $Res Function(_PortfolioEntity) _then;

  /// Create a copy of PortfolioEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? portfolioType = null,
    Object? portfolioName = null,
    Object? countryId = null,
    Object? cityId = null,
    Object? orgId = null,
    Object? status = null,
    Object? assetsCount = null,
    Object? createdBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? ownerName = freezed,
    Object? ownerDocument = freezed,
    Object? ownerDocumentType = freezed,
    Object? licenseStatus = freezed,
    Object? licenseExpiryDate = freezed,
    Object? simitHasFines = freezed,
    Object? simitFinesCount = freezed,
    Object? simitComparendosCount = freezed,
    Object? simitMultasCount = freezed,
    Object? simitFormattedTotal = freezed,
    Object? simitCheckedAt = freezed,
  }) {
    return _then(_PortfolioEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      portfolioType: null == portfolioType
          ? _self.portfolioType
          : portfolioType // ignore: cast_nullable_to_non_nullable
              as PortfolioType,
      portfolioName: null == portfolioName
          ? _self.portfolioName
          : portfolioName // ignore: cast_nullable_to_non_nullable
              as String,
      countryId: null == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as String,
      cityId: null == cityId
          ? _self.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _self.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PortfolioStatus,
      assetsCount: null == assetsCount
          ? _self.assetsCount
          : assetsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ownerName: freezed == ownerName
          ? _self.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerDocument: freezed == ownerDocument
          ? _self.ownerDocument
          : ownerDocument // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerDocumentType: freezed == ownerDocumentType
          ? _self.ownerDocumentType
          : ownerDocumentType // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseStatus: freezed == licenseStatus
          ? _self.licenseStatus
          : licenseStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseExpiryDate: freezed == licenseExpiryDate
          ? _self.licenseExpiryDate
          : licenseExpiryDate // ignore: cast_nullable_to_non_nullable
              as String?,
      simitHasFines: freezed == simitHasFines
          ? _self.simitHasFines
          : simitHasFines // ignore: cast_nullable_to_non_nullable
              as bool?,
      simitFinesCount: freezed == simitFinesCount
          ? _self.simitFinesCount
          : simitFinesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      simitComparendosCount: freezed == simitComparendosCount
          ? _self.simitComparendosCount
          : simitComparendosCount // ignore: cast_nullable_to_non_nullable
              as int?,
      simitMultasCount: freezed == simitMultasCount
          ? _self.simitMultasCount
          : simitMultasCount // ignore: cast_nullable_to_non_nullable
              as int?,
      simitFormattedTotal: freezed == simitFormattedTotal
          ? _self.simitFormattedTotal
          : simitFormattedTotal // ignore: cast_nullable_to_non_nullable
              as String?,
      simitCheckedAt: freezed == simitCheckedAt
          ? _self.simitCheckedAt
          : simitCheckedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
