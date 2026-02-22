// ============================================================================
// lib/domain/value/organization_contract/structural_capabilities.dart
// STRUCTURAL CAPABILITIES — Enterprise Ultra Pro (Domain / Value Object)
//
// QUÉ HACE:
// - Define gates ESTRUCTURALES por organización (habilitan subsistemas completos).
// - Deny-by-default: todo false salvo presets explícitos.
// - Serializa estable vía Freezed (para persistencia en contractJson).
// - Expone señales derivadas para evitar ifs regados.
// - Expone normalización determinística contra InfrastructureMode.
//
// QUÉ NO HACE:
// - No es UI feature flags.
// - No define cuotas/límites.
// - No ejecuta enforcement (eso es AccessPolicy/Repositorios/ProductAccessContext).
//
// PRINCIPIO ENTERPRISE:
// - El contrato declara intención (flags).
// - El motor (ProductAccessContext) decide la capacidad efectiva cruzando:
//   InfrastructureMode + StructuralCapabilities (+ otros inputs).
// - Para evitar deuda, este VO provee `normalizedFor(mode)` como "pre-filtro"
//   determinístico para flags inválidas en ciertos modos.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'infrastructure_mode.dart';

part 'structural_capabilities.freezed.dart';
part 'structural_capabilities.g.dart';

@freezed
abstract class StructuralCapabilities with _$StructuralCapabilities {
  const StructuralCapabilities._();

  const factory StructuralCapabilities({
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
    @Default(false) bool cloudSyncEnabled,

    // ------------------------------------------------------------------------
    // IDENTITY / ACCESS CONTROL
    // ------------------------------------------------------------------------

    /// RBAC avanzado (roles custom + scopes granulares + jerarquías).
    ///
    /// - False: Modelo simple (owner + members básicos).
    /// - True: RBAC completo (roles custom, scopes, jerarquías, etc.).
    @Default(false) bool rbacAdvancedEnabled,

    // ------------------------------------------------------------------------
    // WORKSPACE / ORG MODEL
    // ------------------------------------------------------------------------

    /// Multi-organización (varios workspaces bajo un mismo owner/billing).
    ///
    /// Nota:
    /// - En la mayoría de arquitecturas, multi-org requiere conectividad cloud.
    /// - Este VO NO asume, pero `normalizedFor(localOnly)` lo fuerza a false.
    @Default(false) bool multiOrganizationEnabled,

    // ------------------------------------------------------------------------
    // REPORTING / EXPORT / BI
    // ------------------------------------------------------------------------

    /// Reporting avanzado / BI / export masivo (nivel organizacional).
    ///
    /// Nota:
    /// - Puede depender de cloud o ser local en el futuro.
    /// - Por defecto, en localOnly se normaliza a false para evitar promesas falsas.
    @Default(false) bool advancedReportingEnabled,

    // ------------------------------------------------------------------------
    // INTEGRATIONS
    // ------------------------------------------------------------------------

    /// Integraciones externas vía API pública (REST/Partners).
    ///
    /// En la práctica, requiere cloud. Se normaliza a false en localOnly.
    @Default(false) bool publicApiEnabled,

    // ------------------------------------------------------------------------
    // COMPLIANCE / AUDIT
    // ------------------------------------------------------------------------

    /// Audit trail inmutable (logs operativos/legales).
    ///
    /// En la práctica, suele requerir cloud (retención + evidencia).
    /// Se normaliza a false en localOnly.
    @Default(false) bool auditLogEnabled,
  }) = _StructuralCapabilities;

  factory StructuralCapabilities.fromJson(Map<String, dynamic> json) =>
      _$StructuralCapabilitiesFromJson(json);

  // --------------------------------------------------------------------------
  // DERIVED SIGNALS (NO enforcement; solo UX/telemetría/diagnóstico)
  // --------------------------------------------------------------------------

  /// Colaboración real: requiere RBAC avanzado.
  bool get supportsCollaboration => rbacAdvancedEnabled;

  /// Señal estructural “enterprise-grade” (no pricing).
  bool get isEnterpriseGrade =>
      multiOrganizationEnabled && publicApiEnabled && auditLogEnabled;

  /// Señal de intención de conectividad (ojo: mode puede anular).
  bool get wantsCloudConnectivity => cloudSyncEnabled;

  /// Señal "capabilities fuertes" para producto (útil en logs/telemetría).
  bool get hasAnyEnterpriseModule =>
      publicApiEnabled || auditLogEnabled || multiOrganizationEnabled;

  /// Señal para experiencia de usuario: hay features “heavy” habilitadas.
  bool get hasAnyHeavyModule =>
      advancedReportingEnabled || publicApiEnabled || auditLogEnabled;

  /// Debug string estable para logs (NO wire/persistencia).
  String toDebugString() {
    final enabled = <String>[
      if (cloudSyncEnabled) 'cloudSync',
      if (rbacAdvancedEnabled) 'rbacAdvanced',
      if (multiOrganizationEnabled) 'multiOrg',
      if (advancedReportingEnabled) 'advancedReporting',
      if (publicApiEnabled) 'publicApi',
      if (auditLogEnabled) 'auditLog',
    ];
    return enabled.isEmpty
        ? 'StructuralCapabilities(none)'
        : 'StructuralCapabilities(${enabled.join(',')})';
  }

  // --------------------------------------------------------------------------
  // NORMALIZATION (single source of truth para el motor)
  // --------------------------------------------------------------------------

  /// Normaliza capacidades contra el modo de infraestructura.
  ///
  /// Objetivo:
  /// - Evitar estados imposibles/contradictorios antes de evaluar en el motor.
  /// - Mantener determinismo y evitar ifs dispersos.
  ///
  /// Reglas duras actuales (opinionadas, Enterprise-safe):
  /// - localOnly => cloudSyncEnabled=false
  /// - localOnly => publicApiEnabled=false
  /// - localOnly => multiOrganizationEnabled=false
  /// - localOnly => advancedReportingEnabled=false (evita promesas BI que no corren)
  /// - localOnly => auditLogEnabled=false (audit legal suele requerir cloud)
  ///
  /// Nota:
  /// - Si en el futuro soportas "audit local" o "reporting local", se ajusta aquí
  ///   en un solo sitio y el resto del sistema queda consistente.
  StructuralCapabilities normalizedFor(InfrastructureMode mode) {
    return switch (mode) {
      InfrastructureMode.localOnly => copyWith(
          cloudSyncEnabled: false,
          publicApiEnabled: false,
          multiOrganizationEnabled: false,
          advancedReportingEnabled: false,
          auditLogEnabled: false,
        ),
      _ => this,
    };
  }

  // --------------------------------------------------------------------------
  // PRESETS (política de producto; no deuda técnica)
  // --------------------------------------------------------------------------

  /// Preset base para "org personal" (freelancer / individual).
  ///
  /// Decisión de producto:
  /// - cloudSyncEnabled: true (multi-device personal / backup).
  /// - RBAC avanzado: no (modelo simple).
  factory StructuralCapabilities.defaultsPersonal() =>
      const StructuralCapabilities(
        cloudSyncEnabled: true,
        rbacAdvancedEnabled: false,
        multiOrganizationEnabled: false,
        advancedReportingEnabled: false,
        publicApiEnabled: false,
        auditLogEnabled: false,
      );

  /// Preset base para "team" (pyme / operación con roles).
  ///
  /// Decisión de producto:
  /// - cloudSyncEnabled: true
  /// - RBAC avanzado: true
  /// - reporting: true
  factory StructuralCapabilities.defaultsTeam() => const StructuralCapabilities(
        cloudSyncEnabled: true,
        rbacAdvancedEnabled: true,
        multiOrganizationEnabled: false,
        advancedReportingEnabled: true,
        publicApiEnabled: false,
        auditLogEnabled: false,
      );

  /// Preset full para Enterprise.
  factory StructuralCapabilities.defaultsEnterprise() =>
      const StructuralCapabilities(
        cloudSyncEnabled: true,
        rbacAdvancedEnabled: true,
        multiOrganizationEnabled: true,
        advancedReportingEnabled: true,
        publicApiEnabled: true,
        auditLogEnabled: true,
      );
}
