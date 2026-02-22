// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_access_contract.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrganizationAccessContract {
// ----------------------------------------------------------------------
// VERSIONING (future-proof)
// ----------------------------------------------------------------------
  /// Versión de esquema del contrato.
  ///
  /// - Debe incrementarse cuando cambie el shape/semántica del JSON.
  /// - El motor/capa de app puede migrar contratos antiguos basándose en esto.
  int get schemaVersion;

  /// Perfil semántico del contrato (útil para presets / logs / soporte).
  ///
  /// - NO es pricing.
  /// - Sirve para diagnosticar: 'guest' | 'personal' | 'team' | 'enterprise' | 'custom'
  String
      get schemaProfile; // ----------------------------------------------------------------------
// INFRASTRUCTURE
// ----------------------------------------------------------------------
  /// Modo de infraestructura/conectividad. Default seguro: localOnly.
  InfrastructureMode
      get mode; // ----------------------------------------------------------------------
// INTELLIGENCE
// ----------------------------------------------------------------------
  /// Nivel de IA disponible. Default seguro: none.
  IntelligenceTier
      get intelligence; // ----------------------------------------------------------------------
// STRUCTURAL CAPABILITIES (gates de subsistemas)
// ----------------------------------------------------------------------
  /// Capacidades estructurales. Default seguro: todo false (deny-by-default).
  StructuralCapabilities
      get capabilities; // ----------------------------------------------------------------------
// QUANTITATIVE LIMITS (por recurso)
// ----------------------------------------------------------------------
  /// Máximo de activos registrables en esta organización.
  QuantitativeLimit get maxAssets;

  /// Máximo de miembros (membresías) en esta organización.
  QuantitativeLimit get maxMembers;

  /// Máximo de organizaciones (solo aplica si multiOrganizationEnabled).
  ///
  /// Default restrictivo viable:
  /// - En ausencia de multi-org, 1 mantiene el modelo consistente (la org existe).
  /// - Si multi-org está habilitado, el motor/policies pueden evaluar este límite.
  QuantitativeLimit get maxOrganizations;

  /// Create a copy of OrganizationAccessContract
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrganizationAccessContractCopyWith<OrganizationAccessContract>
      get copyWith =>
          _$OrganizationAccessContractCopyWithImpl<OrganizationAccessContract>(
              this as OrganizationAccessContract, _$identity);

  /// Serializes this OrganizationAccessContract to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrganizationAccessContract &&
            (identical(other.schemaVersion, schemaVersion) ||
                other.schemaVersion == schemaVersion) &&
            (identical(other.schemaProfile, schemaProfile) ||
                other.schemaProfile == schemaProfile) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.intelligence, intelligence) ||
                other.intelligence == intelligence) &&
            (identical(other.capabilities, capabilities) ||
                other.capabilities == capabilities) &&
            (identical(other.maxAssets, maxAssets) ||
                other.maxAssets == maxAssets) &&
            (identical(other.maxMembers, maxMembers) ||
                other.maxMembers == maxMembers) &&
            (identical(other.maxOrganizations, maxOrganizations) ||
                other.maxOrganizations == maxOrganizations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      schemaVersion,
      schemaProfile,
      mode,
      intelligence,
      capabilities,
      maxAssets,
      maxMembers,
      maxOrganizations);

  @override
  String toString() {
    return 'OrganizationAccessContract(schemaVersion: $schemaVersion, schemaProfile: $schemaProfile, mode: $mode, intelligence: $intelligence, capabilities: $capabilities, maxAssets: $maxAssets, maxMembers: $maxMembers, maxOrganizations: $maxOrganizations)';
  }
}

/// @nodoc
abstract mixin class $OrganizationAccessContractCopyWith<$Res> {
  factory $OrganizationAccessContractCopyWith(OrganizationAccessContract value,
          $Res Function(OrganizationAccessContract) _then) =
      _$OrganizationAccessContractCopyWithImpl;
  @useResult
  $Res call(
      {int schemaVersion,
      String schemaProfile,
      InfrastructureMode mode,
      IntelligenceTier intelligence,
      StructuralCapabilities capabilities,
      QuantitativeLimit maxAssets,
      QuantitativeLimit maxMembers,
      QuantitativeLimit maxOrganizations});

  $StructuralCapabilitiesCopyWith<$Res> get capabilities;
  $QuantitativeLimitCopyWith<$Res> get maxAssets;
  $QuantitativeLimitCopyWith<$Res> get maxMembers;
  $QuantitativeLimitCopyWith<$Res> get maxOrganizations;
}

/// @nodoc
class _$OrganizationAccessContractCopyWithImpl<$Res>
    implements $OrganizationAccessContractCopyWith<$Res> {
  _$OrganizationAccessContractCopyWithImpl(this._self, this._then);

  final OrganizationAccessContract _self;
  final $Res Function(OrganizationAccessContract) _then;

  /// Create a copy of OrganizationAccessContract
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schemaVersion = null,
    Object? schemaProfile = null,
    Object? mode = null,
    Object? intelligence = null,
    Object? capabilities = null,
    Object? maxAssets = null,
    Object? maxMembers = null,
    Object? maxOrganizations = null,
  }) {
    return _then(_self.copyWith(
      schemaVersion: null == schemaVersion
          ? _self.schemaVersion
          : schemaVersion // ignore: cast_nullable_to_non_nullable
              as int,
      schemaProfile: null == schemaProfile
          ? _self.schemaProfile
          : schemaProfile // ignore: cast_nullable_to_non_nullable
              as String,
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as InfrastructureMode,
      intelligence: null == intelligence
          ? _self.intelligence
          : intelligence // ignore: cast_nullable_to_non_nullable
              as IntelligenceTier,
      capabilities: null == capabilities
          ? _self.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as StructuralCapabilities,
      maxAssets: null == maxAssets
          ? _self.maxAssets
          : maxAssets // ignore: cast_nullable_to_non_nullable
              as QuantitativeLimit,
      maxMembers: null == maxMembers
          ? _self.maxMembers
          : maxMembers // ignore: cast_nullable_to_non_nullable
              as QuantitativeLimit,
      maxOrganizations: null == maxOrganizations
          ? _self.maxOrganizations
          : maxOrganizations // ignore: cast_nullable_to_non_nullable
              as QuantitativeLimit,
    ));
  }

  /// Create a copy of OrganizationAccessContract
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StructuralCapabilitiesCopyWith<$Res> get capabilities {
    return $StructuralCapabilitiesCopyWith<$Res>(_self.capabilities, (value) {
      return _then(_self.copyWith(capabilities: value));
    });
  }

  /// Create a copy of OrganizationAccessContract
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuantitativeLimitCopyWith<$Res> get maxAssets {
    return $QuantitativeLimitCopyWith<$Res>(_self.maxAssets, (value) {
      return _then(_self.copyWith(maxAssets: value));
    });
  }

  /// Create a copy of OrganizationAccessContract
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuantitativeLimitCopyWith<$Res> get maxMembers {
    return $QuantitativeLimitCopyWith<$Res>(_self.maxMembers, (value) {
      return _then(_self.copyWith(maxMembers: value));
    });
  }

  /// Create a copy of OrganizationAccessContract
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuantitativeLimitCopyWith<$Res> get maxOrganizations {
    return $QuantitativeLimitCopyWith<$Res>(_self.maxOrganizations, (value) {
      return _then(_self.copyWith(maxOrganizations: value));
    });
  }
}

/// Adds pattern-matching-related methods to [OrganizationAccessContract].
extension OrganizationAccessContractPatterns on OrganizationAccessContract {
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
    TResult Function(_OrganizationAccessContract value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrganizationAccessContract() when $default != null:
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
    TResult Function(_OrganizationAccessContract value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrganizationAccessContract():
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
    TResult? Function(_OrganizationAccessContract value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrganizationAccessContract() when $default != null:
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
            int schemaVersion,
            String schemaProfile,
            InfrastructureMode mode,
            IntelligenceTier intelligence,
            StructuralCapabilities capabilities,
            QuantitativeLimit maxAssets,
            QuantitativeLimit maxMembers,
            QuantitativeLimit maxOrganizations)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrganizationAccessContract() when $default != null:
        return $default(
            _that.schemaVersion,
            _that.schemaProfile,
            _that.mode,
            _that.intelligence,
            _that.capabilities,
            _that.maxAssets,
            _that.maxMembers,
            _that.maxOrganizations);
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
            int schemaVersion,
            String schemaProfile,
            InfrastructureMode mode,
            IntelligenceTier intelligence,
            StructuralCapabilities capabilities,
            QuantitativeLimit maxAssets,
            QuantitativeLimit maxMembers,
            QuantitativeLimit maxOrganizations)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrganizationAccessContract():
        return $default(
            _that.schemaVersion,
            _that.schemaProfile,
            _that.mode,
            _that.intelligence,
            _that.capabilities,
            _that.maxAssets,
            _that.maxMembers,
            _that.maxOrganizations);
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
            int schemaVersion,
            String schemaProfile,
            InfrastructureMode mode,
            IntelligenceTier intelligence,
            StructuralCapabilities capabilities,
            QuantitativeLimit maxAssets,
            QuantitativeLimit maxMembers,
            QuantitativeLimit maxOrganizations)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrganizationAccessContract() when $default != null:
        return $default(
            _that.schemaVersion,
            _that.schemaProfile,
            _that.mode,
            _that.intelligence,
            _that.capabilities,
            _that.maxAssets,
            _that.maxMembers,
            _that.maxOrganizations);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OrganizationAccessContract extends OrganizationAccessContract {
  const _OrganizationAccessContract(
      {this.schemaVersion = 1,
      this.schemaProfile = 'canonical',
      this.mode = InfrastructureMode.localOnly,
      this.intelligence = IntelligenceTier.none,
      this.capabilities = const StructuralCapabilities(),
      this.maxAssets = const QuantitativeLimit.limited(0),
      this.maxMembers = const QuantitativeLimit.limited(0),
      this.maxOrganizations = const QuantitativeLimit.limited(1)})
      : super._();
  factory _OrganizationAccessContract.fromJson(Map<String, dynamic> json) =>
      _$OrganizationAccessContractFromJson(json);

// ----------------------------------------------------------------------
// VERSIONING (future-proof)
// ----------------------------------------------------------------------
  /// Versión de esquema del contrato.
  ///
  /// - Debe incrementarse cuando cambie el shape/semántica del JSON.
  /// - El motor/capa de app puede migrar contratos antiguos basándose en esto.
  @override
  @JsonKey()
  final int schemaVersion;

  /// Perfil semántico del contrato (útil para presets / logs / soporte).
  ///
  /// - NO es pricing.
  /// - Sirve para diagnosticar: 'guest' | 'personal' | 'team' | 'enterprise' | 'custom'
  @override
  @JsonKey()
  final String schemaProfile;
// ----------------------------------------------------------------------
// INFRASTRUCTURE
// ----------------------------------------------------------------------
  /// Modo de infraestructura/conectividad. Default seguro: localOnly.
  @override
  @JsonKey()
  final InfrastructureMode mode;
// ----------------------------------------------------------------------
// INTELLIGENCE
// ----------------------------------------------------------------------
  /// Nivel de IA disponible. Default seguro: none.
  @override
  @JsonKey()
  final IntelligenceTier intelligence;
// ----------------------------------------------------------------------
// STRUCTURAL CAPABILITIES (gates de subsistemas)
// ----------------------------------------------------------------------
  /// Capacidades estructurales. Default seguro: todo false (deny-by-default).
  @override
  @JsonKey()
  final StructuralCapabilities capabilities;
// ----------------------------------------------------------------------
// QUANTITATIVE LIMITS (por recurso)
// ----------------------------------------------------------------------
  /// Máximo de activos registrables en esta organización.
  @override
  @JsonKey()
  final QuantitativeLimit maxAssets;

  /// Máximo de miembros (membresías) en esta organización.
  @override
  @JsonKey()
  final QuantitativeLimit maxMembers;

  /// Máximo de organizaciones (solo aplica si multiOrganizationEnabled).
  ///
  /// Default restrictivo viable:
  /// - En ausencia de multi-org, 1 mantiene el modelo consistente (la org existe).
  /// - Si multi-org está habilitado, el motor/policies pueden evaluar este límite.
  @override
  @JsonKey()
  final QuantitativeLimit maxOrganizations;

  /// Create a copy of OrganizationAccessContract
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrganizationAccessContractCopyWith<_OrganizationAccessContract>
      get copyWith => __$OrganizationAccessContractCopyWithImpl<
          _OrganizationAccessContract>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrganizationAccessContractToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrganizationAccessContract &&
            (identical(other.schemaVersion, schemaVersion) ||
                other.schemaVersion == schemaVersion) &&
            (identical(other.schemaProfile, schemaProfile) ||
                other.schemaProfile == schemaProfile) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.intelligence, intelligence) ||
                other.intelligence == intelligence) &&
            (identical(other.capabilities, capabilities) ||
                other.capabilities == capabilities) &&
            (identical(other.maxAssets, maxAssets) ||
                other.maxAssets == maxAssets) &&
            (identical(other.maxMembers, maxMembers) ||
                other.maxMembers == maxMembers) &&
            (identical(other.maxOrganizations, maxOrganizations) ||
                other.maxOrganizations == maxOrganizations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      schemaVersion,
      schemaProfile,
      mode,
      intelligence,
      capabilities,
      maxAssets,
      maxMembers,
      maxOrganizations);

  @override
  String toString() {
    return 'OrganizationAccessContract(schemaVersion: $schemaVersion, schemaProfile: $schemaProfile, mode: $mode, intelligence: $intelligence, capabilities: $capabilities, maxAssets: $maxAssets, maxMembers: $maxMembers, maxOrganizations: $maxOrganizations)';
  }
}

/// @nodoc
abstract mixin class _$OrganizationAccessContractCopyWith<$Res>
    implements $OrganizationAccessContractCopyWith<$Res> {
  factory _$OrganizationAccessContractCopyWith(
          _OrganizationAccessContract value,
          $Res Function(_OrganizationAccessContract) _then) =
      __$OrganizationAccessContractCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int schemaVersion,
      String schemaProfile,
      InfrastructureMode mode,
      IntelligenceTier intelligence,
      StructuralCapabilities capabilities,
      QuantitativeLimit maxAssets,
      QuantitativeLimit maxMembers,
      QuantitativeLimit maxOrganizations});

  @override
  $StructuralCapabilitiesCopyWith<$Res> get capabilities;
  @override
  $QuantitativeLimitCopyWith<$Res> get maxAssets;
  @override
  $QuantitativeLimitCopyWith<$Res> get maxMembers;
  @override
  $QuantitativeLimitCopyWith<$Res> get maxOrganizations;
}

/// @nodoc
class __$OrganizationAccessContractCopyWithImpl<$Res>
    implements _$OrganizationAccessContractCopyWith<$Res> {
  __$OrganizationAccessContractCopyWithImpl(this._self, this._then);

  final _OrganizationAccessContract _self;
  final $Res Function(_OrganizationAccessContract) _then;

  /// Create a copy of OrganizationAccessContract
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? schemaVersion = null,
    Object? schemaProfile = null,
    Object? mode = null,
    Object? intelligence = null,
    Object? capabilities = null,
    Object? maxAssets = null,
    Object? maxMembers = null,
    Object? maxOrganizations = null,
  }) {
    return _then(_OrganizationAccessContract(
      schemaVersion: null == schemaVersion
          ? _self.schemaVersion
          : schemaVersion // ignore: cast_nullable_to_non_nullable
              as int,
      schemaProfile: null == schemaProfile
          ? _self.schemaProfile
          : schemaProfile // ignore: cast_nullable_to_non_nullable
              as String,
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as InfrastructureMode,
      intelligence: null == intelligence
          ? _self.intelligence
          : intelligence // ignore: cast_nullable_to_non_nullable
              as IntelligenceTier,
      capabilities: null == capabilities
          ? _self.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as StructuralCapabilities,
      maxAssets: null == maxAssets
          ? _self.maxAssets
          : maxAssets // ignore: cast_nullable_to_non_nullable
              as QuantitativeLimit,
      maxMembers: null == maxMembers
          ? _self.maxMembers
          : maxMembers // ignore: cast_nullable_to_non_nullable
              as QuantitativeLimit,
      maxOrganizations: null == maxOrganizations
          ? _self.maxOrganizations
          : maxOrganizations // ignore: cast_nullable_to_non_nullable
              as QuantitativeLimit,
    ));
  }

  /// Create a copy of OrganizationAccessContract
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StructuralCapabilitiesCopyWith<$Res> get capabilities {
    return $StructuralCapabilitiesCopyWith<$Res>(_self.capabilities, (value) {
      return _then(_self.copyWith(capabilities: value));
    });
  }

  /// Create a copy of OrganizationAccessContract
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuantitativeLimitCopyWith<$Res> get maxAssets {
    return $QuantitativeLimitCopyWith<$Res>(_self.maxAssets, (value) {
      return _then(_self.copyWith(maxAssets: value));
    });
  }

  /// Create a copy of OrganizationAccessContract
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuantitativeLimitCopyWith<$Res> get maxMembers {
    return $QuantitativeLimitCopyWith<$Res>(_self.maxMembers, (value) {
      return _then(_self.copyWith(maxMembers: value));
    });
  }

  /// Create a copy of OrganizationAccessContract
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuantitativeLimitCopyWith<$Res> get maxOrganizations {
    return $QuantitativeLimitCopyWith<$Res>(_self.maxOrganizations, (value) {
      return _then(_self.copyWith(maxOrganizations: value));
    });
  }
}

// dart format on
