// ============================================================================
// lib/domain/value/organization_contract/organization_access_contract.dart
// ORGANIZATION ACCESS CONTRACT — Enterprise Ultra Pro (Domain / Value Object)
//
// QUÉ HACE:
// - Define el contrato de acceso completo de una organización.
// - Compone: InfrastructureMode, IntelligenceTier, StructuralCapabilities,
//   y límites cuantitativos (QuantitativeLimit) por recurso.
// - Inmutable, JSON serializable, dominio puro (sin Flutter ni infra).
// - Provee presets seguros: guest, personal, team, enterprise.
// - Provee defaultRestricted() como fallback seguro ante JSON faltante/corrupto.
//
// QUÉ NO HACE:
// - No ejecuta enforcement (eso es ProductAccessContext / policies / repositorios).
// - No resuelve billing ni pricing (eso es capa de aplicación/infra).
// - No persiste por sí mismo (OrganizationModel.contractJson lo maneja).
// - No modifica MembershipScope (son contratos ortogonales).
//
// PRINCIPIO ENTERPRISE:
// - "Contrato" = capacidades + límites versionados.
// - "Facturación" = estado externo; NO debe contaminar este modelo.
// - Deny-by-default: el default debe ser el más restrictivo y determinístico.
// - Versionado: schemaVersion permite evolución sin hacks.
//
// SERIALIZACIÓN:
// - Freezed + JsonSerializable.
// - Persistido como JSON string (contractJson) en OrganizationModel.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'infrastructure_mode.dart';
import 'intelligence_tier.dart';
import 'quantitative_limit.dart';
import 'structural_capabilities.dart';

part 'organization_access_contract.freezed.dart';
part 'organization_access_contract.g.dart';

@freezed
abstract class OrganizationAccessContract with _$OrganizationAccessContract {
  const OrganizationAccessContract._();

  const factory OrganizationAccessContract({
    // ----------------------------------------------------------------------
    // VERSIONING (future-proof)
    // ----------------------------------------------------------------------

    /// Versión de esquema del contrato.
    ///
    /// - Debe incrementarse cuando cambie el shape/semántica del JSON.
    /// - El motor/capa de app puede migrar contratos antiguos basándose en esto.
    @Default(1) int schemaVersion,

    /// Perfil semántico del contrato (útil para presets / logs / soporte).
    ///
    /// - NO es pricing.
    /// - Sirve para diagnosticar: 'guest' | 'personal' | 'team' | 'enterprise' | 'custom'
    @Default('canonical') String schemaProfile,

    // ----------------------------------------------------------------------
    // INFRASTRUCTURE
    // ----------------------------------------------------------------------

    /// Modo de infraestructura/conectividad. Default seguro: localOnly.
    @Default(InfrastructureMode.localOnly) InfrastructureMode mode,

    // ----------------------------------------------------------------------
    // INTELLIGENCE
    // ----------------------------------------------------------------------

    /// Nivel de IA disponible. Default seguro: none.
    @Default(IntelligenceTier.none) IntelligenceTier intelligence,

    // ----------------------------------------------------------------------
    // STRUCTURAL CAPABILITIES (gates de subsistemas)
    // ----------------------------------------------------------------------

    /// Capacidades estructurales. Default seguro: todo false (deny-by-default).
    @Default(StructuralCapabilities()) StructuralCapabilities capabilities,

    // ----------------------------------------------------------------------
    // QUANTITATIVE LIMITS (por recurso)
    // ----------------------------------------------------------------------

    /// Máximo de activos registrables en esta organización.
    @Default(QuantitativeLimit.limited(0)) QuantitativeLimit maxAssets,

    /// Máximo de miembros (membresías) en esta organización.
    @Default(QuantitativeLimit.limited(0)) QuantitativeLimit maxMembers,

    /// Máximo de organizaciones (solo aplica si multiOrganizationEnabled).
    ///
    /// Default restrictivo viable:
    /// - En ausencia de multi-org, 1 mantiene el modelo consistente (la org existe).
    /// - Si multi-org está habilitado, el motor/policies pueden evaluar este límite.
    @Default(QuantitativeLimit.limited(1)) QuantitativeLimit maxOrganizations,
  }) = _OrganizationAccessContract;

  factory OrganizationAccessContract.fromJson(Map<String, dynamic> json) =>
      _$OrganizationAccessContractFromJson(json);

  // --------------------------------------------------------------------------
  // DEFAULTS SEGUROS
  // --------------------------------------------------------------------------

  /// Default seguro máximo restrictivo (deny-by-default).
  ///
  /// Usado como fallback cuando:
  /// - contractJson es null, vacío o corrupto.
  /// - La org no tiene contrato asignado.
  ///
  /// Resultado:
  /// - mode: localOnly
  /// - intelligence: none
  /// - capabilities: todo false
  /// - maxAssets/maxMembers: 0 (no puede crear)
  /// - maxOrganizations: 1 (org única, coherencia mínima del modelo)
  factory OrganizationAccessContract.defaultRestricted() =>
      const OrganizationAccessContract(
        schemaProfile: 'restricted',
      );

  // --------------------------------------------------------------------------
  // PRESETS DE PRODUCTO (decisiones centralizadas)
  // --------------------------------------------------------------------------

  /// Guest / exploración.
  ///
  /// - Solo local.
  /// - Sin IA.
  /// - Límites mínimos para explorar (sin monetización cloud).
  factory OrganizationAccessContract.guest() =>
      const OrganizationAccessContract(
        schemaProfile: 'guest',
        mode: InfrastructureMode.localOnly,
        intelligence: IntelligenceTier.none,
        capabilities: StructuralCapabilities(),
        maxAssets: QuantitativeLimit.limited(3),
        maxMembers: QuantitativeLimit.limited(1),
        maxOrganizations: QuantitativeLimit.limited(1),
      );

  /// Personal / freelancer.
  ///
  /// - Cloud lite (sync manual/periódico según tu motor).
  /// - IA básica.
  /// - Sin RBAC avanzado (modelo simple).
  factory OrganizationAccessContract.personal() => OrganizationAccessContract(
        schemaProfile: 'personal',
        mode: InfrastructureMode.cloudLite,
        intelligence: IntelligenceTier.basic,
        capabilities: StructuralCapabilities.defaultsPersonal(),
        maxAssets: const QuantitativeLimit.limited(10),
        maxMembers: const QuantitativeLimit.limited(3),
        maxOrganizations: const QuantitativeLimit.limited(1),
      );

  /// Team / pyme.
  ///
  /// - Cloud full (sync real-time si tu motor lo habilita).
  /// - IA básica.
  /// - RBAC + reporting.
  factory OrganizationAccessContract.team() => OrganizationAccessContract(
        schemaProfile: 'team',
        mode: InfrastructureMode.cloudFull,
        intelligence: IntelligenceTier.basic,
        capabilities: StructuralCapabilities.defaultsTeam(),
        maxAssets: const QuantitativeLimit.limited(50),
        maxMembers: const QuantitativeLimit.limited(20),
        maxOrganizations: const QuantitativeLimit.limited(1),
      );

  /// Enterprise.
  ///
  /// - Infra enterprise.
  /// - IA avanzada.
  /// - Todos los módulos habilitados.
  /// - Sin límites (unlimited).
  factory OrganizationAccessContract.enterprise() => OrganizationAccessContract(
        schemaProfile: 'enterprise',
        mode: InfrastructureMode.enterprise,
        intelligence: IntelligenceTier.advanced,
        capabilities: StructuralCapabilities.defaultsEnterprise(),
        maxAssets: const QuantitativeLimit.unlimited(),
        maxMembers: const QuantitativeLimit.unlimited(),
        maxOrganizations: const QuantitativeLimit.unlimited(),
      );

  // --------------------------------------------------------------------------
  // QUERIES (convenience, no enforcement)
  // --------------------------------------------------------------------------

  /// Capacidades normalizadas contra el modo de infraestructura.
  ///
  /// Usar esto en el motor (ProductAccessContext) para garantizar coherencia
  /// entre mode y capabilities sin ifs dispersos.
  StructuralCapabilities get effectiveCapabilities =>
      capabilities.normalizedFor(mode);

  /// True si la org puede sincronizar con la nube (mode + capabilities efectivas).
  bool get canSync =>
      mode.requiresCloud && effectiveCapabilities.cloudSyncEnabled;

  /// True si la org tiene IA disponible.
  bool get hasIntelligence => intelligence.isAvailable;

  /// True si la org soporta colaboración (señal estructural).
  bool get supportsCollaboration => effectiveCapabilities.supportsCollaboration;

  /// True si el contrato es el default restrictivo emitido por [defaultRestricted()].
  ///
  /// Señal canónica: schemaProfile == 'restricted'.
  /// - Semántica estable: no depende de igualdad estructural.
  /// - Ningún preset usa 'restricted', por lo que no hay falsos positivos.
  /// - Fuente de verdad: el mismo valor que asigna [defaultRestricted()].
  bool get isDefaultRestricted => schemaProfile == 'restricted';

  /// Debug string estable para logs (NO wire).
  String toDebugString() {
    return 'OrganizationAccessContract('
        'v=$schemaVersion, '
        'profile=$schemaProfile, '
        'mode=${mode.wireName}, '
        'intelligence=${intelligence.wireName}, '
        'canSync=$canSync, '
        'enterpriseModules=${effectiveCapabilities.hasAnyEnterpriseModule}, '
        'assets=${maxAssets.toDebugString()}, '
        'members=${maxMembers.toDebugString()}, '
        'orgs=${maxOrganizations.toDebugString()}'
        ')';
  }
}
