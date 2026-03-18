// ============================================================================
// lib/domain/value/workspace/business_mode.dart
// BUSINESS MODE — Enterprise Ultra Pro Premium (Domain / Value / Workspace)
//
// QUÉ HACE:
// - Define BusinessMode: concepto de valor que describe el modo operativo
//   canónico del usuario dentro de su workspace.
// - Provee wireName estable para serialización y persistencia.
// - Provee fromWireName con normalización tolerante para inputs legacy.
//
// QUÉ NO HACE:
// - NO es una entidad con identidad (vive en domain/value, no en domain/entities).
// - NO importa Flutter, GetX, Isar ni ninguna infraestructura.
// - NO define WorkspaceType (eso es workspace_type.dart).
// - NO contiene lógica de UI ni navegación.
//
// PRINCIPIOS:
// - VALUE CONCEPT: BusinessMode es inmutable y sin identidad propia.
//   Dos instancias del mismo valor son intercambiables.
// - WIRE-STABLE: los wireName son contratos de serialización.
//   NUNCA renombrar valores ya publicados. Si se elimina un valor,
//   marcarlo @Deprecated, nunca borrarlo.
// - TOLERANCIA LEGACY: fromWireName normaliza antes de comparar
//   (trim, lowercase, guiones y espacios → guiones bajos).
//
// VALORES CANÓNICOS (ref: docs/architecture/onboarding_workspace_contract.md §3):
//   self_managed     → propietario gestiona sus propios activos
//   delegated        → propietario delega gestión a un tercero
//   third_party      → organización administra activos de clientes externos
//   hybrid           → activos propios y de terceros mezclados
//   consumer         → usuario que arrienda o consume un activo
//   service_provider → proveedor de servicios técnicos o mantenimiento
//   retailer         → proveedor de artículos, repuestos o insumos
//
// DEPENDENCIAS: ninguna (pure Dart).
// ============================================================================

/// Modo operativo canónico del usuario dentro de su workspace.
///
/// Capturado durante el onboarding como parte de RegistrationWorkspaceIntent.
/// Junto con WorkspaceType y orgType, determina el legacyRoleCode canónico
/// según la Matriz de Mapeo Formal del contrato de onboarding.
enum BusinessMode {
  /// Propietario que gestiona directamente sus propios activos.
  selfManaged,

  /// Propietario que delega la gestión operativa a un administrador externo.
  delegated,

  /// Organización que administra activos de clientes terceros (solo empresa).
  thirdParty,

  /// Organización que administra activos propios y de terceros (solo empresa).
  hybrid,

  /// Usuario que arrienda o consume un activo como cliente final.
  consumer,

  /// Proveedor que ofrece servicios técnicos o de mantenimiento.
  serviceProvider,

  /// Proveedor que comercializa artículos, repuestos o insumos.
  retailer;

  // ==========================================================================
  // SERIALIZACIÓN — wire-stable
  // ==========================================================================

  /// Nombre canónico para serialización y persistencia.
  ///
  /// CONTRATO DE WIRE: estos valores no pueden cambiar una vez publicados.
  /// Son la fuente de verdad para serialización, persistencia y telemetría.
  String get wireName {
    switch (this) {
      case BusinessMode.selfManaged:
        return 'self_managed';
      case BusinessMode.delegated:
        return 'delegated';
      case BusinessMode.thirdParty:
        return 'third_party';
      case BusinessMode.hybrid:
        return 'hybrid';
      case BusinessMode.consumer:
        return 'consumer';
      case BusinessMode.serviceProvider:
        return 'service_provider';
      case BusinessMode.retailer:
        return 'retailer';
    }
  }

  /// Deserializa desde wireName con normalización tolerante a inputs legacy.
  ///
  /// Normalización aplicada antes de comparar:
  /// - trim
  /// - lowercase
  /// - guiones (`-`) → guiones bajos (`_`)
  /// - espacios → guiones bajos (`_`)
  ///
  /// Ejemplos que resuelven correctamente:
  /// - `"self_managed"`, `"self-managed"`, `"SELF_MANAGED"`, `"self managed"`
  ///   → [BusinessMode.selfManaged]
  ///
  /// Retorna null si el valor no está reconocido (sin crash en producción).
  static BusinessMode? fromWireName(String? value) {
    if (value == null) return null;
    final normalized =
        value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
    if (normalized.isEmpty) return null;
    for (final mode in BusinessMode.values) {
      if (mode.wireName == normalized) return mode;
    }
    return null;
  }

  @override
  String toString() => 'BusinessMode($wireName)';
}
