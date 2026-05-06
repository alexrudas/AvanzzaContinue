// ============================================================================
// lib/domain/value/capability/capability_profile.dart
// CapabilityProfile — entidad agregadora que describe una capacidad ofrecida
// por un Workspace al mercado.
// ============================================================================
// QUÉ HACE:
//   - Agrupa: discriminator (kind), spec específica del kind, y campos
//     comunes (assetTypeIds, coverageCities, branchId).
//   - Aplica invariante CRÍTICA en construcción: exactamente UNA spec poblada,
//     y esa spec DEBE corresponder al kind. Cualquier otra combinación
//     dispara ArgumentError fail-fast.
//   - Tipado fuerte en TODOS los campos: assetTypeIds usa AssetRegistrationType,
//     coverageCities usa CoverageCityPath, los specs son tipos discriminados.
//   - Serialización JSON estricta: omite specs null en write; rechaza specs
//     extra y kind inconsistente en read.
//
// QUÉ NO HACE:
//   - NO valida la existencia de FKs externas (BusinessCategoryRef,
//     RegulatorLicenseRef): eso es trabajo de los Registry/Validator
//     contracts. Aquí solo se garantiza la sintaxis vía los VOs anidados.
//   - NO valida la existencia de branchId en el repo de Branches: la
//     existencia se valida al persistir contra ese repo.
//   - NO impone que assetTypeIds tenga elementos: una capability transversal
//     puede tener lista vacía.
//   - NO impone que coverageCities tenga elementos: una capability sin
//     cobertura declarada es válida (cobertura se declara al activar).
//
// REGLAS DE EXCLUSIVIDAD (invariante dura):
//   kind == provider  ⇒ providerSpec  != null && otros == null
//   kind == advisor   ⇒ advisorSpec   != null && otros == null
//   kind == broker    ⇒ brokerSpec    != null && otros == null
//   kind == legal     ⇒ legalSpec     != null && otros == null
//   kind == insurer   ⇒ insurerSpec   != null && otros == null
// ============================================================================

import '../../shared/enums/asset_type.dart';
import 'advisor_spec.dart';
import 'broker_spec.dart';
import 'insurer_spec.dart';
import 'legal_spec.dart';
import 'profile_kind.dart';
import 'provider_spec.dart';
import 'refs/coverage_city_path.dart';

class CapabilityProfile {
  /// Discriminator obligatorio. Define cuál spec debe estar poblada.
  final ProfileKind kind;

  /// Tipos de activo a los que aplica la capability. Lista vacía = transversal.
  /// Sin duplicados (validado en constructor).
  final List<AssetRegistrationType> assetTypeIds;

  /// Cobertura geográfica como paths PAIS/REGION/CIUDAD. Lista vacía permitida.
  /// Sin duplicados (validado en constructor).
  final List<CoverageCityPath> coverageCities;

  /// FK opcional al Branch (sucursal) del workspace. La existencia se valida
  /// al persistir contra el repo de Branches; aquí solo se garantiza
  /// no-blank si está presente.
  final String? branchId;

  // Specs por kind (exactamente UNA poblada según kind).
  final ProviderSpec? providerSpec;
  final AdvisorSpec? advisorSpec;
  final BrokerSpec? brokerSpec;
  final LegalSpec? legalSpec;
  final InsurerSpec? insurerSpec;

  CapabilityProfile({
    required this.kind,
    this.assetTypeIds = const [],
    this.coverageCities = const [],
    this.branchId,
    this.providerSpec,
    this.advisorSpec,
    this.brokerSpec,
    this.legalSpec,
    this.insurerSpec,
  }) {
    _validateExclusiveSpec();
    _validateAssetTypeIds();
    _validateCoverageCities();
    _validateBranchId();
  }

  /// Verifica que exactamente UNA spec esté poblada y que coincida con [kind].
  void _validateExclusiveSpec() {
    final populated = <ProfileKind>[
      if (providerSpec != null) ProfileKind.provider,
      if (advisorSpec != null) ProfileKind.advisor,
      if (brokerSpec != null) ProfileKind.broker,
      if (legalSpec != null) ProfileKind.legal,
      if (insurerSpec != null) ProfileKind.insurer,
    ];
    if (populated.isEmpty) {
      throw ArgumentError(
        'CapabilityProfile: kind=${kind.wireName} requiere su spec poblada '
        '(${_specFieldNameFor(kind)} != null)',
      );
    }
    if (populated.length > 1) {
      throw ArgumentError(
        'CapabilityProfile: exactamente 1 spec debe estar poblada, '
        'encontradas: ${populated.map((k) => k.wireName).join(", ")}',
      );
    }
    final populatedKind = populated.first;
    if (populatedKind != kind) {
      throw ArgumentError(
        'CapabilityProfile: kind=${kind.wireName} no coincide con la spec '
        'poblada (${populatedKind.wireName}). Use ${_specFieldNameFor(kind)} '
        'para kind=${kind.wireName}.',
      );
    }
  }

  static String _specFieldNameFor(ProfileKind k) {
    switch (k) {
      case ProfileKind.provider:
        return 'providerSpec';
      case ProfileKind.advisor:
        return 'advisorSpec';
      case ProfileKind.broker:
        return 'brokerSpec';
      case ProfileKind.legal:
        return 'legalSpec';
      case ProfileKind.insurer:
        return 'insurerSpec';
    }
  }

  void _validateAssetTypeIds() {
    if (assetTypeIds.toSet().length != assetTypeIds.length) {
      throw ArgumentError(
        'CapabilityProfile: assetTypeIds contiene duplicados '
        '(${assetTypeIds.map((t) => t.wireName).toList()})',
      );
    }
  }

  void _validateCoverageCities() {
    if (coverageCities.toSet().length != coverageCities.length) {
      throw ArgumentError(
        'CapabilityProfile: coverageCities contiene duplicados '
        '(${coverageCities.map((c) => c.value).toList()})',
      );
    }
  }

  void _validateBranchId() {
    if (branchId != null && branchId!.trim().isEmpty) {
      throw ArgumentError(
        'CapabilityProfile: branchId presente pero vacío o solo whitespace',
      );
    }
  }

  /// copyWith limitado a campos COMUNES. Para cambiar kind o spec, construir
  /// un nuevo CapabilityProfile — eso fuerza re-validación explícita de la
  /// invariante de exclusividad.
  CapabilityProfile copyWith({
    List<AssetRegistrationType>? assetTypeIds,
    List<CoverageCityPath>? coverageCities,
    String? branchId,
  }) {
    return CapabilityProfile(
      kind: kind,
      assetTypeIds: assetTypeIds ?? this.assetTypeIds,
      coverageCities: coverageCities ?? this.coverageCities,
      branchId: branchId ?? this.branchId,
      providerSpec: providerSpec,
      advisorSpec: advisorSpec,
      brokerSpec: brokerSpec,
      legalSpec: legalSpec,
      insurerSpec: insurerSpec,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'kind': kind.wireName,
      'assetTypeIds': assetTypeIds.map((t) => t.wireName).toList(),
      'coverageCities': coverageCities.map((c) => c.toJson()).toList(),
    };
    if (branchId != null) json['branchId'] = branchId;
    if (providerSpec != null) json['providerSpec'] = providerSpec!.toJson();
    if (advisorSpec != null) json['advisorSpec'] = advisorSpec!.toJson();
    if (brokerSpec != null) json['brokerSpec'] = brokerSpec!.toJson();
    if (legalSpec != null) json['legalSpec'] = legalSpec!.toJson();
    if (insurerSpec != null) json['insurerSpec'] = insurerSpec!.toJson();
    return json;
  }

  factory CapabilityProfile.fromJson(Map<String, dynamic> json) {
    // 1. kind requerido
    final kindRaw = json['kind'];
    if (kindRaw is! String) {
      throw ArgumentError(
        'CapabilityProfile.fromJson: kind requerido (String wire name)',
      );
    }
    final kind = ProfileKindX.fromWire(kindRaw);

    // 2. assetTypeIds opcional
    final assetTypeIds = <AssetRegistrationType>[];
    final assetTypeIdsRaw = json['assetTypeIds'];
    if (assetTypeIdsRaw != null) {
      if (assetTypeIdsRaw is! List) {
        throw ArgumentError(
          'CapabilityProfile.fromJson: assetTypeIds debe ser List si está presente',
        );
      }
      for (final raw in assetTypeIdsRaw) {
        if (raw is! String) {
          throw ArgumentError(
            'CapabilityProfile.fromJson: cada elemento de assetTypeIds '
            'debe ser String wire name',
          );
        }
        assetTypeIds.add(AssetRegistrationTypeWire.fromWire(raw));
      }
    }

    // 3. coverageCities opcional
    final coverageCities = <CoverageCityPath>[];
    final coverageCitiesRaw = json['coverageCities'];
    if (coverageCitiesRaw != null) {
      if (coverageCitiesRaw is! List) {
        throw ArgumentError(
          'CapabilityProfile.fromJson: coverageCities debe ser List si está presente',
        );
      }
      for (final raw in coverageCitiesRaw) {
        if (raw is! String) {
          throw ArgumentError(
            'CapabilityProfile.fromJson: cada elemento de coverageCities '
            'debe ser String formato PAIS/REGION/CIUDAD',
          );
        }
        coverageCities.add(CoverageCityPath.fromJson(raw));
      }
    }

    // 4. branchId opcional
    final branchIdRaw = json['branchId'];
    if (branchIdRaw != null && branchIdRaw is! String) {
      throw ArgumentError(
        'CapabilityProfile.fromJson: branchId debe ser String si está presente',
      );
    }
    final branchId = branchIdRaw as String?;

    // 5. Specs: leer SOLO la correspondiente al kind. Otras specs presentes
    //    en el JSON son rechazadas (datos inconsistentes).
    ProviderSpec? providerSpec;
    AdvisorSpec? advisorSpec;
    BrokerSpec? brokerSpec;
    LegalSpec? legalSpec;
    InsurerSpec? insurerSpec;

    final foreignSpecs = <String>[];
    void checkForeign(String key) {
      if (json.containsKey(key) && json[key] != null) foreignSpecs.add(key);
    }

    switch (kind) {
      case ProfileKind.provider:
        final raw = json['providerSpec'];
        if (raw is! Map<String, dynamic>) {
          throw ArgumentError(
            'CapabilityProfile.fromJson: kind=provider requiere providerSpec '
            '(Map<String, dynamic>)',
          );
        }
        providerSpec = ProviderSpec.fromJson(raw);
        checkForeign('advisorSpec');
        checkForeign('brokerSpec');
        checkForeign('legalSpec');
        checkForeign('insurerSpec');
        break;
      case ProfileKind.advisor:
        final raw = json['advisorSpec'];
        if (raw is! Map<String, dynamic>) {
          throw ArgumentError(
            'CapabilityProfile.fromJson: kind=advisor requiere advisorSpec '
            '(Map<String, dynamic>)',
          );
        }
        advisorSpec = AdvisorSpec.fromJson(raw);
        checkForeign('providerSpec');
        checkForeign('brokerSpec');
        checkForeign('legalSpec');
        checkForeign('insurerSpec');
        break;
      case ProfileKind.broker:
        final raw = json['brokerSpec'];
        if (raw is! Map<String, dynamic>) {
          throw ArgumentError(
            'CapabilityProfile.fromJson: kind=broker requiere brokerSpec '
            '(Map<String, dynamic>)',
          );
        }
        brokerSpec = BrokerSpec.fromJson(raw);
        checkForeign('providerSpec');
        checkForeign('advisorSpec');
        checkForeign('legalSpec');
        checkForeign('insurerSpec');
        break;
      case ProfileKind.legal:
        final raw = json['legalSpec'];
        if (raw is! Map<String, dynamic>) {
          throw ArgumentError(
            'CapabilityProfile.fromJson: kind=legal requiere legalSpec '
            '(Map<String, dynamic>)',
          );
        }
        legalSpec = LegalSpec.fromJson(raw);
        checkForeign('providerSpec');
        checkForeign('advisorSpec');
        checkForeign('brokerSpec');
        checkForeign('insurerSpec');
        break;
      case ProfileKind.insurer:
        final raw = json['insurerSpec'];
        if (raw is! Map<String, dynamic>) {
          throw ArgumentError(
            'CapabilityProfile.fromJson: kind=insurer requiere insurerSpec '
            '(Map<String, dynamic>)',
          );
        }
        insurerSpec = InsurerSpec.fromJson(raw);
        checkForeign('providerSpec');
        checkForeign('advisorSpec');
        checkForeign('brokerSpec');
        checkForeign('legalSpec');
        break;
    }

    if (foreignSpecs.isNotEmpty) {
      throw ArgumentError(
        'CapabilityProfile.fromJson: kind=${kind.wireName} no admite specs '
        'extras presentes en JSON: $foreignSpecs',
      );
    }

    return CapabilityProfile(
      kind: kind,
      assetTypeIds: assetTypeIds,
      coverageCities: coverageCities,
      branchId: branchId,
      providerSpec: providerSpec,
      advisorSpec: advisorSpec,
      brokerSpec: brokerSpec,
      legalSpec: legalSpec,
      insurerSpec: insurerSpec,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CapabilityProfile) return false;
    if (other.kind != kind) return false;
    if (other.branchId != branchId) return false;
    if (other.providerSpec != providerSpec) return false;
    if (other.advisorSpec != advisorSpec) return false;
    if (other.brokerSpec != brokerSpec) return false;
    if (other.legalSpec != legalSpec) return false;
    if (other.insurerSpec != insurerSpec) return false;
    if (other.assetTypeIds.length != assetTypeIds.length) return false;
    for (var i = 0; i < assetTypeIds.length; i++) {
      if (other.assetTypeIds[i] != assetTypeIds[i]) return false;
    }
    if (other.coverageCities.length != coverageCities.length) return false;
    for (var i = 0; i < coverageCities.length; i++) {
      if (other.coverageCities[i] != coverageCities[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        kind,
        Object.hashAll(assetTypeIds),
        Object.hashAll(coverageCities),
        branchId,
        providerSpec,
        advisorSpec,
        brokerSpec,
        legalSpec,
        insurerSpec,
      );

  @override
  String toString() => 'CapabilityProfile('
      'kind: ${kind.wireName}, '
      'assetTypeIds: ${assetTypeIds.map((t) => t.wireName).toList()}, '
      'coverageCities: ${coverageCities.map((c) => c.value).toList()}, '
      'branchId: $branchId, '
      'spec: ${_activeSpec()})';

  Object? _activeSpec() {
    switch (kind) {
      case ProfileKind.provider:
        return providerSpec;
      case ProfileKind.advisor:
        return advisorSpec;
      case ProfileKind.broker:
        return brokerSpec;
      case ProfileKind.legal:
        return legalSpec;
      case ProfileKind.insurer:
        return insurerSpec;
    }
  }
}
