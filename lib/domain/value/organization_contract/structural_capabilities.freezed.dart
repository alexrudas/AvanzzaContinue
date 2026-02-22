// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'structural_capabilities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StructuralCapabilities {
// ------------------------------------------------------------------------
// CONNECTIVITY / DATA PLANE
// ------------------------------------------------------------------------
  /// Sincronización Nube <-> Local.
  ///
  /// - True: La organización pretende operar conectada (si el modo lo permite).
  /// - False: Operación local-only (o sync deshabilitado por contrato).
  ///
  /// IMPORTANTE:
  /// - Si mode == localOnly, la capacidad efectiva debe ser false.
  bool
      get cloudSyncEnabled; // ------------------------------------------------------------------------
// IDENTITY / ACCESS CONTROL
// ------------------------------------------------------------------------
  /// RBAC avanzado (roles custom + scopes granulares + jerarquías).
  ///
  /// - False: Modelo simple (owner + members básicos).
  /// - True: RBAC completo (roles custom, scopes, jerarquías, etc.).
  bool
      get rbacAdvancedEnabled; // ------------------------------------------------------------------------
// WORKSPACE / ORG MODEL
// ------------------------------------------------------------------------
  /// Multi-organización (varios workspaces bajo un mismo owner/billing).
  ///
  /// Nota:
  /// - En la mayoría de arquitecturas, multi-org requiere conectividad cloud.
  /// - Este VO NO asume, pero `normalizedFor(localOnly)` lo fuerza a false.
  bool
      get multiOrganizationEnabled; // ------------------------------------------------------------------------
// REPORTING / EXPORT / BI
// ------------------------------------------------------------------------
  /// Reporting avanzado / BI / export masivo (nivel organizacional).
  ///
  /// Nota:
  /// - Puede depender de cloud o ser local en el futuro.
  /// - Por defecto, en localOnly se normaliza a false para evitar promesas falsas.
  bool
      get advancedReportingEnabled; // ------------------------------------------------------------------------
// INTEGRATIONS
// ------------------------------------------------------------------------
  /// Integraciones externas vía API pública (REST/Partners).
  ///
  /// En la práctica, requiere cloud. Se normaliza a false en localOnly.
  bool
      get publicApiEnabled; // ------------------------------------------------------------------------
// COMPLIANCE / AUDIT
// ------------------------------------------------------------------------
  /// Audit trail inmutable (logs operativos/legales).
  ///
  /// En la práctica, suele requerir cloud (retención + evidencia).
  /// Se normaliza a false en localOnly.
  bool get auditLogEnabled;

  /// Create a copy of StructuralCapabilities
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StructuralCapabilitiesCopyWith<StructuralCapabilities> get copyWith =>
      _$StructuralCapabilitiesCopyWithImpl<StructuralCapabilities>(
          this as StructuralCapabilities, _$identity);

  /// Serializes this StructuralCapabilities to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StructuralCapabilities &&
            (identical(other.cloudSyncEnabled, cloudSyncEnabled) ||
                other.cloudSyncEnabled == cloudSyncEnabled) &&
            (identical(other.rbacAdvancedEnabled, rbacAdvancedEnabled) ||
                other.rbacAdvancedEnabled == rbacAdvancedEnabled) &&
            (identical(
                    other.multiOrganizationEnabled, multiOrganizationEnabled) ||
                other.multiOrganizationEnabled == multiOrganizationEnabled) &&
            (identical(
                    other.advancedReportingEnabled, advancedReportingEnabled) ||
                other.advancedReportingEnabled == advancedReportingEnabled) &&
            (identical(other.publicApiEnabled, publicApiEnabled) ||
                other.publicApiEnabled == publicApiEnabled) &&
            (identical(other.auditLogEnabled, auditLogEnabled) ||
                other.auditLogEnabled == auditLogEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      cloudSyncEnabled,
      rbacAdvancedEnabled,
      multiOrganizationEnabled,
      advancedReportingEnabled,
      publicApiEnabled,
      auditLogEnabled);

  @override
  String toString() {
    return 'StructuralCapabilities(cloudSyncEnabled: $cloudSyncEnabled, rbacAdvancedEnabled: $rbacAdvancedEnabled, multiOrganizationEnabled: $multiOrganizationEnabled, advancedReportingEnabled: $advancedReportingEnabled, publicApiEnabled: $publicApiEnabled, auditLogEnabled: $auditLogEnabled)';
  }
}

/// @nodoc
abstract mixin class $StructuralCapabilitiesCopyWith<$Res> {
  factory $StructuralCapabilitiesCopyWith(StructuralCapabilities value,
          $Res Function(StructuralCapabilities) _then) =
      _$StructuralCapabilitiesCopyWithImpl;
  @useResult
  $Res call(
      {bool cloudSyncEnabled,
      bool rbacAdvancedEnabled,
      bool multiOrganizationEnabled,
      bool advancedReportingEnabled,
      bool publicApiEnabled,
      bool auditLogEnabled});
}

/// @nodoc
class _$StructuralCapabilitiesCopyWithImpl<$Res>
    implements $StructuralCapabilitiesCopyWith<$Res> {
  _$StructuralCapabilitiesCopyWithImpl(this._self, this._then);

  final StructuralCapabilities _self;
  final $Res Function(StructuralCapabilities) _then;

  /// Create a copy of StructuralCapabilities
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cloudSyncEnabled = null,
    Object? rbacAdvancedEnabled = null,
    Object? multiOrganizationEnabled = null,
    Object? advancedReportingEnabled = null,
    Object? publicApiEnabled = null,
    Object? auditLogEnabled = null,
  }) {
    return _then(_self.copyWith(
      cloudSyncEnabled: null == cloudSyncEnabled
          ? _self.cloudSyncEnabled
          : cloudSyncEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      rbacAdvancedEnabled: null == rbacAdvancedEnabled
          ? _self.rbacAdvancedEnabled
          : rbacAdvancedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      multiOrganizationEnabled: null == multiOrganizationEnabled
          ? _self.multiOrganizationEnabled
          : multiOrganizationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      advancedReportingEnabled: null == advancedReportingEnabled
          ? _self.advancedReportingEnabled
          : advancedReportingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      publicApiEnabled: null == publicApiEnabled
          ? _self.publicApiEnabled
          : publicApiEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      auditLogEnabled: null == auditLogEnabled
          ? _self.auditLogEnabled
          : auditLogEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [StructuralCapabilities].
extension StructuralCapabilitiesPatterns on StructuralCapabilities {
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
    TResult Function(_StructuralCapabilities value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StructuralCapabilities() when $default != null:
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
    TResult Function(_StructuralCapabilities value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StructuralCapabilities():
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
    TResult? Function(_StructuralCapabilities value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StructuralCapabilities() when $default != null:
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
            bool cloudSyncEnabled,
            bool rbacAdvancedEnabled,
            bool multiOrganizationEnabled,
            bool advancedReportingEnabled,
            bool publicApiEnabled,
            bool auditLogEnabled)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StructuralCapabilities() when $default != null:
        return $default(
            _that.cloudSyncEnabled,
            _that.rbacAdvancedEnabled,
            _that.multiOrganizationEnabled,
            _that.advancedReportingEnabled,
            _that.publicApiEnabled,
            _that.auditLogEnabled);
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
            bool cloudSyncEnabled,
            bool rbacAdvancedEnabled,
            bool multiOrganizationEnabled,
            bool advancedReportingEnabled,
            bool publicApiEnabled,
            bool auditLogEnabled)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StructuralCapabilities():
        return $default(
            _that.cloudSyncEnabled,
            _that.rbacAdvancedEnabled,
            _that.multiOrganizationEnabled,
            _that.advancedReportingEnabled,
            _that.publicApiEnabled,
            _that.auditLogEnabled);
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
            bool cloudSyncEnabled,
            bool rbacAdvancedEnabled,
            bool multiOrganizationEnabled,
            bool advancedReportingEnabled,
            bool publicApiEnabled,
            bool auditLogEnabled)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StructuralCapabilities() when $default != null:
        return $default(
            _that.cloudSyncEnabled,
            _that.rbacAdvancedEnabled,
            _that.multiOrganizationEnabled,
            _that.advancedReportingEnabled,
            _that.publicApiEnabled,
            _that.auditLogEnabled);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StructuralCapabilities extends StructuralCapabilities {
  const _StructuralCapabilities(
      {this.cloudSyncEnabled = false,
      this.rbacAdvancedEnabled = false,
      this.multiOrganizationEnabled = false,
      this.advancedReportingEnabled = false,
      this.publicApiEnabled = false,
      this.auditLogEnabled = false})
      : super._();
  factory _StructuralCapabilities.fromJson(Map<String, dynamic> json) =>
      _$StructuralCapabilitiesFromJson(json);

// ------------------------------------------------------------------------
// CONNECTIVITY / DATA PLANE
// ------------------------------------------------------------------------
  /// Sincronización Nube <-> Local.
  ///
  /// - True: La organización pretende operar conectada (si el modo lo permite).
  /// - False: Operación local-only (o sync deshabilitado por contrato).
  ///
  /// IMPORTANTE:
  /// - Si mode == localOnly, la capacidad efectiva debe ser false.
  @override
  @JsonKey()
  final bool cloudSyncEnabled;
// ------------------------------------------------------------------------
// IDENTITY / ACCESS CONTROL
// ------------------------------------------------------------------------
  /// RBAC avanzado (roles custom + scopes granulares + jerarquías).
  ///
  /// - False: Modelo simple (owner + members básicos).
  /// - True: RBAC completo (roles custom, scopes, jerarquías, etc.).
  @override
  @JsonKey()
  final bool rbacAdvancedEnabled;
// ------------------------------------------------------------------------
// WORKSPACE / ORG MODEL
// ------------------------------------------------------------------------
  /// Multi-organización (varios workspaces bajo un mismo owner/billing).
  ///
  /// Nota:
  /// - En la mayoría de arquitecturas, multi-org requiere conectividad cloud.
  /// - Este VO NO asume, pero `normalizedFor(localOnly)` lo fuerza a false.
  @override
  @JsonKey()
  final bool multiOrganizationEnabled;
// ------------------------------------------------------------------------
// REPORTING / EXPORT / BI
// ------------------------------------------------------------------------
  /// Reporting avanzado / BI / export masivo (nivel organizacional).
  ///
  /// Nota:
  /// - Puede depender de cloud o ser local en el futuro.
  /// - Por defecto, en localOnly se normaliza a false para evitar promesas falsas.
  @override
  @JsonKey()
  final bool advancedReportingEnabled;
// ------------------------------------------------------------------------
// INTEGRATIONS
// ------------------------------------------------------------------------
  /// Integraciones externas vía API pública (REST/Partners).
  ///
  /// En la práctica, requiere cloud. Se normaliza a false en localOnly.
  @override
  @JsonKey()
  final bool publicApiEnabled;
// ------------------------------------------------------------------------
// COMPLIANCE / AUDIT
// ------------------------------------------------------------------------
  /// Audit trail inmutable (logs operativos/legales).
  ///
  /// En la práctica, suele requerir cloud (retención + evidencia).
  /// Se normaliza a false en localOnly.
  @override
  @JsonKey()
  final bool auditLogEnabled;

  /// Create a copy of StructuralCapabilities
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StructuralCapabilitiesCopyWith<_StructuralCapabilities> get copyWith =>
      __$StructuralCapabilitiesCopyWithImpl<_StructuralCapabilities>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StructuralCapabilitiesToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StructuralCapabilities &&
            (identical(other.cloudSyncEnabled, cloudSyncEnabled) ||
                other.cloudSyncEnabled == cloudSyncEnabled) &&
            (identical(other.rbacAdvancedEnabled, rbacAdvancedEnabled) ||
                other.rbacAdvancedEnabled == rbacAdvancedEnabled) &&
            (identical(
                    other.multiOrganizationEnabled, multiOrganizationEnabled) ||
                other.multiOrganizationEnabled == multiOrganizationEnabled) &&
            (identical(
                    other.advancedReportingEnabled, advancedReportingEnabled) ||
                other.advancedReportingEnabled == advancedReportingEnabled) &&
            (identical(other.publicApiEnabled, publicApiEnabled) ||
                other.publicApiEnabled == publicApiEnabled) &&
            (identical(other.auditLogEnabled, auditLogEnabled) ||
                other.auditLogEnabled == auditLogEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      cloudSyncEnabled,
      rbacAdvancedEnabled,
      multiOrganizationEnabled,
      advancedReportingEnabled,
      publicApiEnabled,
      auditLogEnabled);

  @override
  String toString() {
    return 'StructuralCapabilities(cloudSyncEnabled: $cloudSyncEnabled, rbacAdvancedEnabled: $rbacAdvancedEnabled, multiOrganizationEnabled: $multiOrganizationEnabled, advancedReportingEnabled: $advancedReportingEnabled, publicApiEnabled: $publicApiEnabled, auditLogEnabled: $auditLogEnabled)';
  }
}

/// @nodoc
abstract mixin class _$StructuralCapabilitiesCopyWith<$Res>
    implements $StructuralCapabilitiesCopyWith<$Res> {
  factory _$StructuralCapabilitiesCopyWith(_StructuralCapabilities value,
          $Res Function(_StructuralCapabilities) _then) =
      __$StructuralCapabilitiesCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool cloudSyncEnabled,
      bool rbacAdvancedEnabled,
      bool multiOrganizationEnabled,
      bool advancedReportingEnabled,
      bool publicApiEnabled,
      bool auditLogEnabled});
}

/// @nodoc
class __$StructuralCapabilitiesCopyWithImpl<$Res>
    implements _$StructuralCapabilitiesCopyWith<$Res> {
  __$StructuralCapabilitiesCopyWithImpl(this._self, this._then);

  final _StructuralCapabilities _self;
  final $Res Function(_StructuralCapabilities) _then;

  /// Create a copy of StructuralCapabilities
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cloudSyncEnabled = null,
    Object? rbacAdvancedEnabled = null,
    Object? multiOrganizationEnabled = null,
    Object? advancedReportingEnabled = null,
    Object? publicApiEnabled = null,
    Object? auditLogEnabled = null,
  }) {
    return _then(_StructuralCapabilities(
      cloudSyncEnabled: null == cloudSyncEnabled
          ? _self.cloudSyncEnabled
          : cloudSyncEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      rbacAdvancedEnabled: null == rbacAdvancedEnabled
          ? _self.rbacAdvancedEnabled
          : rbacAdvancedEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      multiOrganizationEnabled: null == multiOrganizationEnabled
          ? _self.multiOrganizationEnabled
          : multiOrganizationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      advancedReportingEnabled: null == advancedReportingEnabled
          ? _self.advancedReportingEnabled
          : advancedReportingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      publicApiEnabled: null == publicApiEnabled
          ? _self.publicApiEnabled
          : publicApiEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      auditLogEnabled: null == auditLogEnabled
          ? _self.auditLogEnabled
          : auditLogEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
