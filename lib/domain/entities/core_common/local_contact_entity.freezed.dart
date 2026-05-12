// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_contact_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocalContactEntity {
  String get id;

  /// Partition key. Workspace dueño del registro local.
  String get workspaceId;

  /// Nombre mostrado en la UI del workspace.
  String get displayName;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// FK opcional a LocalOrganization del mismo workspace.
  /// Null = contacto suelto (ej. conductor persona, técnico freelance).
  String? get organizationId;

  /// Etiqueta libre del rol en el workspace ("vendedor", "conductor",
  /// "técnico"). Sin semántica vertical: solo anotación local.
  String? get roleLabel;

  /// Teléfono normalizado a E.164. Llave candidata principal.
  String? get primaryPhoneE164;

  /// Email de contacto. Llave candidata secundaria.
  String? get primaryEmail;

  /// Documento de identidad normalizado. Llave candidata secundaria.
  String? get docId;

  /// Nota privada del workspace. NUNCA se sincroniza.
  String? get notesPrivate;

  /// Tags privadas del workspace. NUNCA se sincronizan.
  List<String> get tagsPrivate;

  /// PlatformActor origen de adopciones manuales de campo (si aplica).
  String? get snapshotSourcePlatformActorId;

  /// Timestamp de la última adopción.
  DateTime? get snapshotAdoptedAt;

  /// Soft delete flag. true = registro archivado.
  /// Las queries operativas del repositorio excluyen isDeleted=true por default.
  bool get isDeleted;

  /// Timestamp del soft-delete. Null mientras isDeleted=false.
  DateTime?
      get deletedAt; // ── v2 PERFIL ESTRUCTURADO (flujo Proveedores) ─────────────────────────
  /// Clasificación comercial operativa. Null = sin clasificar (legado o
  /// alta rápida). Ver `SupplierType` para el wire contract.
  SupplierType? get supplierType;

  /// Categorías verticales libres (repuestos, lubricantes, taller...).
  /// Acepta cualquier string; la UI ofrece sugerencias pero no impone.
  /// Vacío = sin categorías.
  List<String> get categories;

  /// País del proveedor. Reusa IDs del catálogo geo del proyecto.
  String? get countryId;

  /// Región/Departamento.
  String? get regionId;

  /// Ciudad principal (sede).
  String? get cityId;

  /// Dirección de calle libre (complemento a cityId/regionId). No se parsea.
  String? get addressLine;

  /// Teléfono alternativo E.164. No es llave de matching.
  String? get secondaryPhoneE164;

  /// URL del sitio web del proveedor. Texto libre, sin validación remota.
  String? get website;

  /// IDs de ciudades donde el proveedor ofrece servicio. Puede estar
  /// vacía (ej. proveedor solo de productos). Cuando está vacía, asumir
  /// que la cobertura es cityId (ver completeness helper).
  ///
  /// Semántica con `coverageAllCountry`:
  ///   - `coverageAllCountry=true`  → esta lista DEBE estar vacía (canon).
  ///   - `coverageAllCountry=false` → selección manual opcional.
  List<String> get coverageCityIds;

  /// Modo "Envíos a todo el país". Cuando es true, `coverageCityIds`
  /// debe ignorarse (canon: el controller lo vacía al activar el toggle).
  /// Campo público (se sincroniza vía Firestore).
  bool get coverageAllCountry;

  /// FK opcional al `ProviderProfile` canónico (Postgres) que representa
  /// este contacto en la red comercial (Avanzza Core API).
  ///
  /// Semántica:
  ///   - `null` = aún no provisionado contra Core API (default).
  ///   - String = el `providerProfileId` retornado por
  ///     `POST /v1/providers`. Usado por `ProviderFormController` para:
  ///       1. Saltar el POST en edit mode → ir directo a `GET + PUT`.
  ///       2. Hidratar `specialtyIds` desde `GET /v1/providers/:id`.
  ///
  /// Default `null` ⇒ retrocompatible con registros legacy: contactos
  /// creados antes del flujo canónico simplemente nacen sin vinculación.
  /// Sin migración destructiva.
  ///
  /// IMPORTANTE: este campo se persiste SOLO tras un `provision()` 2xx
  /// exitoso (ver `ProviderFormController.save()`). Si el POST falla o
  /// si `replaceSpecialties` falla luego, la regla canónica es:
  ///   - POST falló → NO tocar este campo (queda null o el valor previo).
  ///   - POST OK + PUT specialties falló → este campo SÍ se actualiza
  ///     porque el provider ya existe; el siguiente save salta el POST
  ///     y reintenta solo el PUT (idempotente backend).
  String? get linkedProviderProfileId;

  /// Sedes ADICIONALES del proveedor. La sede PRINCIPAL vive IMPLÍCITA
  /// en los campos geo + `primaryPhoneE164` del propio `LocalContactEntity`
  /// (retrocompat con registros ya persistidos). Esta lista cubre solo
  /// las sedes extra — visualmente se muestran bajo una sección
  /// "Otras sedes".
  ///
  /// DECISIÓN EXPLÍCITA — ASIMETRÍA INCREMENTAL:
  ///   Existe a propósito una asimetría entre la sede principal
  ///   (campos sueltos del proveedor) y las sedes adicionales (objetos
  ///   en esta lista). La razón es cero migración destructiva sobre los
  ///   registros de proveedor ya guardados en producción. Cuando el
  ///   producto justifique un refactor a un modelo simétrico
  ///   (`mainBranch: ProviderBranchEntity` + `additionalBranches: List`),
  ///   esa migración debe hacerse con un paso de hidratación explícito
  ///   que mueva los campos actuales a `mainBranch.*`. HOY NO es el
  ///   momento: romper la SSOT y los datos persistidos para ganar
  ///   simetría estética no justifica el riesgo.
  ///
  /// Semántica:
  ///   - La identidad de cada sede es el `id` (uuid) del
  ///     `ProviderBranchEntity`.
  ///   - Cobertura, supplierType y categorías NO se duplican por sede:
  ///     son del proveedor como entidad comercial.
  ///   - Notas operativas de la sede (`notes`) son públicas; las privadas
  ///     del proveedor siguen en `notesPrivate`.
  List<ProviderBranchEntity> get additionalBranches;

  /// Create a copy of LocalContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocalContactEntityCopyWith<LocalContactEntity> get copyWith =>
      _$LocalContactEntityCopyWithImpl<LocalContactEntity>(
          this as LocalContactEntity, _$identity);

  /// Serializes this LocalContactEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocalContactEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.roleLabel, roleLabel) ||
                other.roleLabel == roleLabel) &&
            (identical(other.primaryPhoneE164, primaryPhoneE164) ||
                other.primaryPhoneE164 == primaryPhoneE164) &&
            (identical(other.primaryEmail, primaryEmail) ||
                other.primaryEmail == primaryEmail) &&
            (identical(other.docId, docId) || other.docId == docId) &&
            (identical(other.notesPrivate, notesPrivate) ||
                other.notesPrivate == notesPrivate) &&
            const DeepCollectionEquality()
                .equals(other.tagsPrivate, tagsPrivate) &&
            (identical(other.snapshotSourcePlatformActorId,
                    snapshotSourcePlatformActorId) ||
                other.snapshotSourcePlatformActorId ==
                    snapshotSourcePlatformActorId) &&
            (identical(other.snapshotAdoptedAt, snapshotAdoptedAt) ||
                other.snapshotAdoptedAt == snapshotAdoptedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.supplierType, supplierType) ||
                other.supplierType == supplierType) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.addressLine, addressLine) ||
                other.addressLine == addressLine) &&
            (identical(other.secondaryPhoneE164, secondaryPhoneE164) ||
                other.secondaryPhoneE164 == secondaryPhoneE164) &&
            (identical(other.website, website) || other.website == website) &&
            const DeepCollectionEquality()
                .equals(other.coverageCityIds, coverageCityIds) &&
            (identical(other.coverageAllCountry, coverageAllCountry) ||
                other.coverageAllCountry == coverageAllCountry) &&
            (identical(
                    other.linkedProviderProfileId, linkedProviderProfileId) ||
                other.linkedProviderProfileId == linkedProviderProfileId) &&
            const DeepCollectionEquality()
                .equals(other.additionalBranches, additionalBranches));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        workspaceId,
        displayName,
        createdAt,
        updatedAt,
        organizationId,
        roleLabel,
        primaryPhoneE164,
        primaryEmail,
        docId,
        notesPrivate,
        const DeepCollectionEquality().hash(tagsPrivate),
        snapshotSourcePlatformActorId,
        snapshotAdoptedAt,
        isDeleted,
        deletedAt,
        supplierType,
        const DeepCollectionEquality().hash(categories),
        countryId,
        regionId,
        cityId,
        addressLine,
        secondaryPhoneE164,
        website,
        const DeepCollectionEquality().hash(coverageCityIds),
        coverageAllCountry,
        linkedProviderProfileId,
        const DeepCollectionEquality().hash(additionalBranches)
      ]);

  @override
  String toString() {
    return 'LocalContactEntity(id: $id, workspaceId: $workspaceId, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, organizationId: $organizationId, roleLabel: $roleLabel, primaryPhoneE164: $primaryPhoneE164, primaryEmail: $primaryEmail, docId: $docId, notesPrivate: $notesPrivate, tagsPrivate: $tagsPrivate, snapshotSourcePlatformActorId: $snapshotSourcePlatformActorId, snapshotAdoptedAt: $snapshotAdoptedAt, isDeleted: $isDeleted, deletedAt: $deletedAt, supplierType: $supplierType, categories: $categories, countryId: $countryId, regionId: $regionId, cityId: $cityId, addressLine: $addressLine, secondaryPhoneE164: $secondaryPhoneE164, website: $website, coverageCityIds: $coverageCityIds, coverageAllCountry: $coverageAllCountry, linkedProviderProfileId: $linkedProviderProfileId, additionalBranches: $additionalBranches)';
  }
}

/// @nodoc
abstract mixin class $LocalContactEntityCopyWith<$Res> {
  factory $LocalContactEntityCopyWith(
          LocalContactEntity value, $Res Function(LocalContactEntity) _then) =
      _$LocalContactEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String displayName,
      DateTime createdAt,
      DateTime updatedAt,
      String? organizationId,
      String? roleLabel,
      String? primaryPhoneE164,
      String? primaryEmail,
      String? docId,
      String? notesPrivate,
      List<String> tagsPrivate,
      String? snapshotSourcePlatformActorId,
      DateTime? snapshotAdoptedAt,
      bool isDeleted,
      DateTime? deletedAt,
      SupplierType? supplierType,
      List<String> categories,
      String? countryId,
      String? regionId,
      String? cityId,
      String? addressLine,
      String? secondaryPhoneE164,
      String? website,
      List<String> coverageCityIds,
      bool coverageAllCountry,
      String? linkedProviderProfileId,
      List<ProviderBranchEntity> additionalBranches});
}

/// @nodoc
class _$LocalContactEntityCopyWithImpl<$Res>
    implements $LocalContactEntityCopyWith<$Res> {
  _$LocalContactEntityCopyWithImpl(this._self, this._then);

  final LocalContactEntity _self;
  final $Res Function(LocalContactEntity) _then;

  /// Create a copy of LocalContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? displayName = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? organizationId = freezed,
    Object? roleLabel = freezed,
    Object? primaryPhoneE164 = freezed,
    Object? primaryEmail = freezed,
    Object? docId = freezed,
    Object? notesPrivate = freezed,
    Object? tagsPrivate = null,
    Object? snapshotSourcePlatformActorId = freezed,
    Object? snapshotAdoptedAt = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? supplierType = freezed,
    Object? categories = null,
    Object? countryId = freezed,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? addressLine = freezed,
    Object? secondaryPhoneE164 = freezed,
    Object? website = freezed,
    Object? coverageCityIds = null,
    Object? coverageAllCountry = null,
    Object? linkedProviderProfileId = freezed,
    Object? additionalBranches = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _self.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      organizationId: freezed == organizationId
          ? _self.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
      roleLabel: freezed == roleLabel
          ? _self.roleLabel
          : roleLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryPhoneE164: freezed == primaryPhoneE164
          ? _self.primaryPhoneE164
          : primaryPhoneE164 // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryEmail: freezed == primaryEmail
          ? _self.primaryEmail
          : primaryEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      docId: freezed == docId
          ? _self.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String?,
      notesPrivate: freezed == notesPrivate
          ? _self.notesPrivate
          : notesPrivate // ignore: cast_nullable_to_non_nullable
              as String?,
      tagsPrivate: null == tagsPrivate
          ? _self.tagsPrivate
          : tagsPrivate // ignore: cast_nullable_to_non_nullable
              as List<String>,
      snapshotSourcePlatformActorId: freezed == snapshotSourcePlatformActorId
          ? _self.snapshotSourcePlatformActorId
          : snapshotSourcePlatformActorId // ignore: cast_nullable_to_non_nullable
              as String?,
      snapshotAdoptedAt: freezed == snapshotAdoptedAt
          ? _self.snapshotAdoptedAt
          : snapshotAdoptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      supplierType: freezed == supplierType
          ? _self.supplierType
          : supplierType // ignore: cast_nullable_to_non_nullable
              as SupplierType?,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
      secondaryPhoneE164: freezed == secondaryPhoneE164
          ? _self.secondaryPhoneE164
          : secondaryPhoneE164 // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _self.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      coverageCityIds: null == coverageCityIds
          ? _self.coverageCityIds
          : coverageCityIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      coverageAllCountry: null == coverageAllCountry
          ? _self.coverageAllCountry
          : coverageAllCountry // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedProviderProfileId: freezed == linkedProviderProfileId
          ? _self.linkedProviderProfileId
          : linkedProviderProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalBranches: null == additionalBranches
          ? _self.additionalBranches
          : additionalBranches // ignore: cast_nullable_to_non_nullable
              as List<ProviderBranchEntity>,
    ));
  }
}

/// Adds pattern-matching-related methods to [LocalContactEntity].
extension LocalContactEntityPatterns on LocalContactEntity {
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
    TResult Function(_LocalContactEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocalContactEntity() when $default != null:
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
    TResult Function(_LocalContactEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalContactEntity():
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
    TResult? Function(_LocalContactEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalContactEntity() when $default != null:
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
            String workspaceId,
            String displayName,
            DateTime createdAt,
            DateTime updatedAt,
            String? organizationId,
            String? roleLabel,
            String? primaryPhoneE164,
            String? primaryEmail,
            String? docId,
            String? notesPrivate,
            List<String> tagsPrivate,
            String? snapshotSourcePlatformActorId,
            DateTime? snapshotAdoptedAt,
            bool isDeleted,
            DateTime? deletedAt,
            SupplierType? supplierType,
            List<String> categories,
            String? countryId,
            String? regionId,
            String? cityId,
            String? addressLine,
            String? secondaryPhoneE164,
            String? website,
            List<String> coverageCityIds,
            bool coverageAllCountry,
            String? linkedProviderProfileId,
            List<ProviderBranchEntity> additionalBranches)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocalContactEntity() when $default != null:
        return $default(
            _that.id,
            _that.workspaceId,
            _that.displayName,
            _that.createdAt,
            _that.updatedAt,
            _that.organizationId,
            _that.roleLabel,
            _that.primaryPhoneE164,
            _that.primaryEmail,
            _that.docId,
            _that.notesPrivate,
            _that.tagsPrivate,
            _that.snapshotSourcePlatformActorId,
            _that.snapshotAdoptedAt,
            _that.isDeleted,
            _that.deletedAt,
            _that.supplierType,
            _that.categories,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.addressLine,
            _that.secondaryPhoneE164,
            _that.website,
            _that.coverageCityIds,
            _that.coverageAllCountry,
            _that.linkedProviderProfileId,
            _that.additionalBranches);
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
            String workspaceId,
            String displayName,
            DateTime createdAt,
            DateTime updatedAt,
            String? organizationId,
            String? roleLabel,
            String? primaryPhoneE164,
            String? primaryEmail,
            String? docId,
            String? notesPrivate,
            List<String> tagsPrivate,
            String? snapshotSourcePlatformActorId,
            DateTime? snapshotAdoptedAt,
            bool isDeleted,
            DateTime? deletedAt,
            SupplierType? supplierType,
            List<String> categories,
            String? countryId,
            String? regionId,
            String? cityId,
            String? addressLine,
            String? secondaryPhoneE164,
            String? website,
            List<String> coverageCityIds,
            bool coverageAllCountry,
            String? linkedProviderProfileId,
            List<ProviderBranchEntity> additionalBranches)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalContactEntity():
        return $default(
            _that.id,
            _that.workspaceId,
            _that.displayName,
            _that.createdAt,
            _that.updatedAt,
            _that.organizationId,
            _that.roleLabel,
            _that.primaryPhoneE164,
            _that.primaryEmail,
            _that.docId,
            _that.notesPrivate,
            _that.tagsPrivate,
            _that.snapshotSourcePlatformActorId,
            _that.snapshotAdoptedAt,
            _that.isDeleted,
            _that.deletedAt,
            _that.supplierType,
            _that.categories,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.addressLine,
            _that.secondaryPhoneE164,
            _that.website,
            _that.coverageCityIds,
            _that.coverageAllCountry,
            _that.linkedProviderProfileId,
            _that.additionalBranches);
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
            String workspaceId,
            String displayName,
            DateTime createdAt,
            DateTime updatedAt,
            String? organizationId,
            String? roleLabel,
            String? primaryPhoneE164,
            String? primaryEmail,
            String? docId,
            String? notesPrivate,
            List<String> tagsPrivate,
            String? snapshotSourcePlatformActorId,
            DateTime? snapshotAdoptedAt,
            bool isDeleted,
            DateTime? deletedAt,
            SupplierType? supplierType,
            List<String> categories,
            String? countryId,
            String? regionId,
            String? cityId,
            String? addressLine,
            String? secondaryPhoneE164,
            String? website,
            List<String> coverageCityIds,
            bool coverageAllCountry,
            String? linkedProviderProfileId,
            List<ProviderBranchEntity> additionalBranches)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocalContactEntity() when $default != null:
        return $default(
            _that.id,
            _that.workspaceId,
            _that.displayName,
            _that.createdAt,
            _that.updatedAt,
            _that.organizationId,
            _that.roleLabel,
            _that.primaryPhoneE164,
            _that.primaryEmail,
            _that.docId,
            _that.notesPrivate,
            _that.tagsPrivate,
            _that.snapshotSourcePlatformActorId,
            _that.snapshotAdoptedAt,
            _that.isDeleted,
            _that.deletedAt,
            _that.supplierType,
            _that.categories,
            _that.countryId,
            _that.regionId,
            _that.cityId,
            _that.addressLine,
            _that.secondaryPhoneE164,
            _that.website,
            _that.coverageCityIds,
            _that.coverageAllCountry,
            _that.linkedProviderProfileId,
            _that.additionalBranches);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LocalContactEntity implements LocalContactEntity {
  const _LocalContactEntity(
      {required this.id,
      required this.workspaceId,
      required this.displayName,
      required this.createdAt,
      required this.updatedAt,
      this.organizationId,
      this.roleLabel,
      this.primaryPhoneE164,
      this.primaryEmail,
      this.docId,
      this.notesPrivate,
      final List<String> tagsPrivate = const <String>[],
      this.snapshotSourcePlatformActorId,
      this.snapshotAdoptedAt,
      this.isDeleted = false,
      this.deletedAt,
      this.supplierType,
      final List<String> categories = const <String>[],
      this.countryId,
      this.regionId,
      this.cityId,
      this.addressLine,
      this.secondaryPhoneE164,
      this.website,
      final List<String> coverageCityIds = const <String>[],
      this.coverageAllCountry = false,
      this.linkedProviderProfileId,
      final List<ProviderBranchEntity> additionalBranches =
          const <ProviderBranchEntity>[]})
      : _tagsPrivate = tagsPrivate,
        _categories = categories,
        _coverageCityIds = coverageCityIds,
        _additionalBranches = additionalBranches;
  factory _LocalContactEntity.fromJson(Map<String, dynamic> json) =>
      _$LocalContactEntityFromJson(json);

  @override
  final String id;

  /// Partition key. Workspace dueño del registro local.
  @override
  final String workspaceId;

  /// Nombre mostrado en la UI del workspace.
  @override
  final String displayName;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// FK opcional a LocalOrganization del mismo workspace.
  /// Null = contacto suelto (ej. conductor persona, técnico freelance).
  @override
  final String? organizationId;

  /// Etiqueta libre del rol en el workspace ("vendedor", "conductor",
  /// "técnico"). Sin semántica vertical: solo anotación local.
  @override
  final String? roleLabel;

  /// Teléfono normalizado a E.164. Llave candidata principal.
  @override
  final String? primaryPhoneE164;

  /// Email de contacto. Llave candidata secundaria.
  @override
  final String? primaryEmail;

  /// Documento de identidad normalizado. Llave candidata secundaria.
  @override
  final String? docId;

  /// Nota privada del workspace. NUNCA se sincroniza.
  @override
  final String? notesPrivate;

  /// Tags privadas del workspace. NUNCA se sincronizan.
  final List<String> _tagsPrivate;

  /// Tags privadas del workspace. NUNCA se sincronizan.
  @override
  @JsonKey()
  List<String> get tagsPrivate {
    if (_tagsPrivate is EqualUnmodifiableListView) return _tagsPrivate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagsPrivate);
  }

  /// PlatformActor origen de adopciones manuales de campo (si aplica).
  @override
  final String? snapshotSourcePlatformActorId;

  /// Timestamp de la última adopción.
  @override
  final DateTime? snapshotAdoptedAt;

  /// Soft delete flag. true = registro archivado.
  /// Las queries operativas del repositorio excluyen isDeleted=true por default.
  @override
  @JsonKey()
  final bool isDeleted;

  /// Timestamp del soft-delete. Null mientras isDeleted=false.
  @override
  final DateTime? deletedAt;
// ── v2 PERFIL ESTRUCTURADO (flujo Proveedores) ─────────────────────────
  /// Clasificación comercial operativa. Null = sin clasificar (legado o
  /// alta rápida). Ver `SupplierType` para el wire contract.
  @override
  final SupplierType? supplierType;

  /// Categorías verticales libres (repuestos, lubricantes, taller...).
  /// Acepta cualquier string; la UI ofrece sugerencias pero no impone.
  /// Vacío = sin categorías.
  final List<String> _categories;

  /// Categorías verticales libres (repuestos, lubricantes, taller...).
  /// Acepta cualquier string; la UI ofrece sugerencias pero no impone.
  /// Vacío = sin categorías.
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// País del proveedor. Reusa IDs del catálogo geo del proyecto.
  @override
  final String? countryId;

  /// Región/Departamento.
  @override
  final String? regionId;

  /// Ciudad principal (sede).
  @override
  final String? cityId;

  /// Dirección de calle libre (complemento a cityId/regionId). No se parsea.
  @override
  final String? addressLine;

  /// Teléfono alternativo E.164. No es llave de matching.
  @override
  final String? secondaryPhoneE164;

  /// URL del sitio web del proveedor. Texto libre, sin validación remota.
  @override
  final String? website;

  /// IDs de ciudades donde el proveedor ofrece servicio. Puede estar
  /// vacía (ej. proveedor solo de productos). Cuando está vacía, asumir
  /// que la cobertura es cityId (ver completeness helper).
  ///
  /// Semántica con `coverageAllCountry`:
  ///   - `coverageAllCountry=true`  → esta lista DEBE estar vacía (canon).
  ///   - `coverageAllCountry=false` → selección manual opcional.
  final List<String> _coverageCityIds;

  /// IDs de ciudades donde el proveedor ofrece servicio. Puede estar
  /// vacía (ej. proveedor solo de productos). Cuando está vacía, asumir
  /// que la cobertura es cityId (ver completeness helper).
  ///
  /// Semántica con `coverageAllCountry`:
  ///   - `coverageAllCountry=true`  → esta lista DEBE estar vacía (canon).
  ///   - `coverageAllCountry=false` → selección manual opcional.
  @override
  @JsonKey()
  List<String> get coverageCityIds {
    if (_coverageCityIds is EqualUnmodifiableListView) return _coverageCityIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coverageCityIds);
  }

  /// Modo "Envíos a todo el país". Cuando es true, `coverageCityIds`
  /// debe ignorarse (canon: el controller lo vacía al activar el toggle).
  /// Campo público (se sincroniza vía Firestore).
  @override
  @JsonKey()
  final bool coverageAllCountry;

  /// FK opcional al `ProviderProfile` canónico (Postgres) que representa
  /// este contacto en la red comercial (Avanzza Core API).
  ///
  /// Semántica:
  ///   - `null` = aún no provisionado contra Core API (default).
  ///   - String = el `providerProfileId` retornado por
  ///     `POST /v1/providers`. Usado por `ProviderFormController` para:
  ///       1. Saltar el POST en edit mode → ir directo a `GET + PUT`.
  ///       2. Hidratar `specialtyIds` desde `GET /v1/providers/:id`.
  ///
  /// Default `null` ⇒ retrocompatible con registros legacy: contactos
  /// creados antes del flujo canónico simplemente nacen sin vinculación.
  /// Sin migración destructiva.
  ///
  /// IMPORTANTE: este campo se persiste SOLO tras un `provision()` 2xx
  /// exitoso (ver `ProviderFormController.save()`). Si el POST falla o
  /// si `replaceSpecialties` falla luego, la regla canónica es:
  ///   - POST falló → NO tocar este campo (queda null o el valor previo).
  ///   - POST OK + PUT specialties falló → este campo SÍ se actualiza
  ///     porque el provider ya existe; el siguiente save salta el POST
  ///     y reintenta solo el PUT (idempotente backend).
  @override
  final String? linkedProviderProfileId;

  /// Sedes ADICIONALES del proveedor. La sede PRINCIPAL vive IMPLÍCITA
  /// en los campos geo + `primaryPhoneE164` del propio `LocalContactEntity`
  /// (retrocompat con registros ya persistidos). Esta lista cubre solo
  /// las sedes extra — visualmente se muestran bajo una sección
  /// "Otras sedes".
  ///
  /// DECISIÓN EXPLÍCITA — ASIMETRÍA INCREMENTAL:
  ///   Existe a propósito una asimetría entre la sede principal
  ///   (campos sueltos del proveedor) y las sedes adicionales (objetos
  ///   en esta lista). La razón es cero migración destructiva sobre los
  ///   registros de proveedor ya guardados en producción. Cuando el
  ///   producto justifique un refactor a un modelo simétrico
  ///   (`mainBranch: ProviderBranchEntity` + `additionalBranches: List`),
  ///   esa migración debe hacerse con un paso de hidratación explícito
  ///   que mueva los campos actuales a `mainBranch.*`. HOY NO es el
  ///   momento: romper la SSOT y los datos persistidos para ganar
  ///   simetría estética no justifica el riesgo.
  ///
  /// Semántica:
  ///   - La identidad de cada sede es el `id` (uuid) del
  ///     `ProviderBranchEntity`.
  ///   - Cobertura, supplierType y categorías NO se duplican por sede:
  ///     son del proveedor como entidad comercial.
  ///   - Notas operativas de la sede (`notes`) son públicas; las privadas
  ///     del proveedor siguen en `notesPrivate`.
  final List<ProviderBranchEntity> _additionalBranches;

  /// Sedes ADICIONALES del proveedor. La sede PRINCIPAL vive IMPLÍCITA
  /// en los campos geo + `primaryPhoneE164` del propio `LocalContactEntity`
  /// (retrocompat con registros ya persistidos). Esta lista cubre solo
  /// las sedes extra — visualmente se muestran bajo una sección
  /// "Otras sedes".
  ///
  /// DECISIÓN EXPLÍCITA — ASIMETRÍA INCREMENTAL:
  ///   Existe a propósito una asimetría entre la sede principal
  ///   (campos sueltos del proveedor) y las sedes adicionales (objetos
  ///   en esta lista). La razón es cero migración destructiva sobre los
  ///   registros de proveedor ya guardados en producción. Cuando el
  ///   producto justifique un refactor a un modelo simétrico
  ///   (`mainBranch: ProviderBranchEntity` + `additionalBranches: List`),
  ///   esa migración debe hacerse con un paso de hidratación explícito
  ///   que mueva los campos actuales a `mainBranch.*`. HOY NO es el
  ///   momento: romper la SSOT y los datos persistidos para ganar
  ///   simetría estética no justifica el riesgo.
  ///
  /// Semántica:
  ///   - La identidad de cada sede es el `id` (uuid) del
  ///     `ProviderBranchEntity`.
  ///   - Cobertura, supplierType y categorías NO se duplican por sede:
  ///     son del proveedor como entidad comercial.
  ///   - Notas operativas de la sede (`notes`) son públicas; las privadas
  ///     del proveedor siguen en `notesPrivate`.
  @override
  @JsonKey()
  List<ProviderBranchEntity> get additionalBranches {
    if (_additionalBranches is EqualUnmodifiableListView)
      return _additionalBranches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_additionalBranches);
  }

  /// Create a copy of LocalContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LocalContactEntityCopyWith<_LocalContactEntity> get copyWith =>
      __$LocalContactEntityCopyWithImpl<_LocalContactEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LocalContactEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalContactEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.roleLabel, roleLabel) ||
                other.roleLabel == roleLabel) &&
            (identical(other.primaryPhoneE164, primaryPhoneE164) ||
                other.primaryPhoneE164 == primaryPhoneE164) &&
            (identical(other.primaryEmail, primaryEmail) ||
                other.primaryEmail == primaryEmail) &&
            (identical(other.docId, docId) || other.docId == docId) &&
            (identical(other.notesPrivate, notesPrivate) ||
                other.notesPrivate == notesPrivate) &&
            const DeepCollectionEquality()
                .equals(other._tagsPrivate, _tagsPrivate) &&
            (identical(other.snapshotSourcePlatformActorId,
                    snapshotSourcePlatformActorId) ||
                other.snapshotSourcePlatformActorId ==
                    snapshotSourcePlatformActorId) &&
            (identical(other.snapshotAdoptedAt, snapshotAdoptedAt) ||
                other.snapshotAdoptedAt == snapshotAdoptedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.supplierType, supplierType) ||
                other.supplierType == supplierType) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.countryId, countryId) ||
                other.countryId == countryId) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.addressLine, addressLine) ||
                other.addressLine == addressLine) &&
            (identical(other.secondaryPhoneE164, secondaryPhoneE164) ||
                other.secondaryPhoneE164 == secondaryPhoneE164) &&
            (identical(other.website, website) || other.website == website) &&
            const DeepCollectionEquality()
                .equals(other._coverageCityIds, _coverageCityIds) &&
            (identical(other.coverageAllCountry, coverageAllCountry) ||
                other.coverageAllCountry == coverageAllCountry) &&
            (identical(
                    other.linkedProviderProfileId, linkedProviderProfileId) ||
                other.linkedProviderProfileId == linkedProviderProfileId) &&
            const DeepCollectionEquality()
                .equals(other._additionalBranches, _additionalBranches));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        workspaceId,
        displayName,
        createdAt,
        updatedAt,
        organizationId,
        roleLabel,
        primaryPhoneE164,
        primaryEmail,
        docId,
        notesPrivate,
        const DeepCollectionEquality().hash(_tagsPrivate),
        snapshotSourcePlatformActorId,
        snapshotAdoptedAt,
        isDeleted,
        deletedAt,
        supplierType,
        const DeepCollectionEquality().hash(_categories),
        countryId,
        regionId,
        cityId,
        addressLine,
        secondaryPhoneE164,
        website,
        const DeepCollectionEquality().hash(_coverageCityIds),
        coverageAllCountry,
        linkedProviderProfileId,
        const DeepCollectionEquality().hash(_additionalBranches)
      ]);

  @override
  String toString() {
    return 'LocalContactEntity(id: $id, workspaceId: $workspaceId, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, organizationId: $organizationId, roleLabel: $roleLabel, primaryPhoneE164: $primaryPhoneE164, primaryEmail: $primaryEmail, docId: $docId, notesPrivate: $notesPrivate, tagsPrivate: $tagsPrivate, snapshotSourcePlatformActorId: $snapshotSourcePlatformActorId, snapshotAdoptedAt: $snapshotAdoptedAt, isDeleted: $isDeleted, deletedAt: $deletedAt, supplierType: $supplierType, categories: $categories, countryId: $countryId, regionId: $regionId, cityId: $cityId, addressLine: $addressLine, secondaryPhoneE164: $secondaryPhoneE164, website: $website, coverageCityIds: $coverageCityIds, coverageAllCountry: $coverageAllCountry, linkedProviderProfileId: $linkedProviderProfileId, additionalBranches: $additionalBranches)';
  }
}

/// @nodoc
abstract mixin class _$LocalContactEntityCopyWith<$Res>
    implements $LocalContactEntityCopyWith<$Res> {
  factory _$LocalContactEntityCopyWith(
          _LocalContactEntity value, $Res Function(_LocalContactEntity) _then) =
      __$LocalContactEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String displayName,
      DateTime createdAt,
      DateTime updatedAt,
      String? organizationId,
      String? roleLabel,
      String? primaryPhoneE164,
      String? primaryEmail,
      String? docId,
      String? notesPrivate,
      List<String> tagsPrivate,
      String? snapshotSourcePlatformActorId,
      DateTime? snapshotAdoptedAt,
      bool isDeleted,
      DateTime? deletedAt,
      SupplierType? supplierType,
      List<String> categories,
      String? countryId,
      String? regionId,
      String? cityId,
      String? addressLine,
      String? secondaryPhoneE164,
      String? website,
      List<String> coverageCityIds,
      bool coverageAllCountry,
      String? linkedProviderProfileId,
      List<ProviderBranchEntity> additionalBranches});
}

/// @nodoc
class __$LocalContactEntityCopyWithImpl<$Res>
    implements _$LocalContactEntityCopyWith<$Res> {
  __$LocalContactEntityCopyWithImpl(this._self, this._then);

  final _LocalContactEntity _self;
  final $Res Function(_LocalContactEntity) _then;

  /// Create a copy of LocalContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? displayName = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? organizationId = freezed,
    Object? roleLabel = freezed,
    Object? primaryPhoneE164 = freezed,
    Object? primaryEmail = freezed,
    Object? docId = freezed,
    Object? notesPrivate = freezed,
    Object? tagsPrivate = null,
    Object? snapshotSourcePlatformActorId = freezed,
    Object? snapshotAdoptedAt = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? supplierType = freezed,
    Object? categories = null,
    Object? countryId = freezed,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? addressLine = freezed,
    Object? secondaryPhoneE164 = freezed,
    Object? website = freezed,
    Object? coverageCityIds = null,
    Object? coverageAllCountry = null,
    Object? linkedProviderProfileId = freezed,
    Object? additionalBranches = null,
  }) {
    return _then(_LocalContactEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _self.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      organizationId: freezed == organizationId
          ? _self.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
      roleLabel: freezed == roleLabel
          ? _self.roleLabel
          : roleLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryPhoneE164: freezed == primaryPhoneE164
          ? _self.primaryPhoneE164
          : primaryPhoneE164 // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryEmail: freezed == primaryEmail
          ? _self.primaryEmail
          : primaryEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      docId: freezed == docId
          ? _self.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String?,
      notesPrivate: freezed == notesPrivate
          ? _self.notesPrivate
          : notesPrivate // ignore: cast_nullable_to_non_nullable
              as String?,
      tagsPrivate: null == tagsPrivate
          ? _self._tagsPrivate
          : tagsPrivate // ignore: cast_nullable_to_non_nullable
              as List<String>,
      snapshotSourcePlatformActorId: freezed == snapshotSourcePlatformActorId
          ? _self.snapshotSourcePlatformActorId
          : snapshotSourcePlatformActorId // ignore: cast_nullable_to_non_nullable
              as String?,
      snapshotAdoptedAt: freezed == snapshotAdoptedAt
          ? _self.snapshotAdoptedAt
          : snapshotAdoptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      supplierType: freezed == supplierType
          ? _self.supplierType
          : supplierType // ignore: cast_nullable_to_non_nullable
              as SupplierType?,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
      secondaryPhoneE164: freezed == secondaryPhoneE164
          ? _self.secondaryPhoneE164
          : secondaryPhoneE164 // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _self.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      coverageCityIds: null == coverageCityIds
          ? _self._coverageCityIds
          : coverageCityIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      coverageAllCountry: null == coverageAllCountry
          ? _self.coverageAllCountry
          : coverageAllCountry // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedProviderProfileId: freezed == linkedProviderProfileId
          ? _self.linkedProviderProfileId
          : linkedProviderProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalBranches: null == additionalBranches
          ? _self._additionalBranches
          : additionalBranches // ignore: cast_nullable_to_non_nullable
              as List<ProviderBranchEntity>,
    ));
  }
}

// dart format on
