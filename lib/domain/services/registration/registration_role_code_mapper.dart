// ============================================================================
// lib/domain/services/registration/registration_role_code_mapper.dart
//
// Puente transicional entre el wizard legacy (string `selectedRole`) y el
// contrato Fase 2 tipado (`WorkspaceType` / `resolvedWorkspaceTypeName`).
//
// QUÉ HACE:
// - Mapea códigos de rol del wizard (ej. 'admin_activos_org', 'propietario',
//   'proveedor_servicios') al enum canónico [WorkspaceType].
// - Detecta intent de proveedor preferiendo el campo tipado y cayendo al
//   substring legacy solo si el tipado no existe (datos pre-migración).
//
// QUÉ NO HACE:
// - NO participa en RBAC, capabilities, ni policy.
// - NO crea Membership, Organization ni resuelve la matriz formal §4.
//   (Eso es responsabilidad de [RegistrationWorkspaceResolver] cuando el
//   usuario llega al final de Fase 2.)
//
// PRINCIPIOS:
// - Pure domain. Sin Flutter, GetX, Isar ni infraestructura.
// - Stateless. Determinístico.
// - Wire-stable: usa [WorkspaceTypeX.wireName] como output.
// ============================================================================

import '../../entities/workspace/workspace_type.dart';

/// Mapper transicional wizard-role-code → [WorkspaceType].
///
/// Se introduce como parte de la migración de `selectedRole` (string legacy)
/// hacia `resolvedWorkspaceTypeName` (wireName tipado). Ver
/// `docs/architecture/onboarding_workspace_contract.md` §3.
class RegistrationRoleCodeMapper {
  const RegistrationRoleCodeMapper._();

  /// Mapea un código del wizard a [WorkspaceType].
  ///
  /// Acepta tanto códigos internos (`'admin_activos_org'`, `'propietario_emp'`)
  /// como labels UI (`'Administrador'`, `'Propietario'`) — el match es
  /// case-insensitive porque ambos formatos terminan persistidos en
  /// `selectedRole` en distintos puntos del flujo.
  ///
  /// Retorna [WorkspaceType.unknown] si el code es null, vacío o no reconocido.
  static WorkspaceType fromRoleCode(String? code) {
    if (code == null) return WorkspaceType.unknown;
    final c = code.trim().toLowerCase();
    if (c.isEmpty) return WorkspaceType.unknown;

    // Administrador de activos (persona / empresa / label UI).
    if (c.startsWith('admin_activos') || c == 'administrador') {
      return WorkspaceType.assetAdmin;
    }

    // Propietario (persona / empresa / label UI).
    if (c == 'propietario' || c == 'propietario_emp') {
      return WorkspaceType.owner;
    }

    // Arrendatario.
    if (c == 'arrendatario' || c == 'arrendatario_emp') {
      return WorkspaceType.renter;
    }

    // Proveedor de servicios técnicos (taller).
    if (c == 'proveedor_servicios') return WorkspaceType.workshop;

    // Proveedor de artículos / repuestos.
    if (c == 'proveedor_articulos') return WorkspaceType.supplier;

    // Aseguradora / broker / asesor de seguros.
    if (c == 'aseguradora' || c == 'asesor_seguros') {
      return WorkspaceType.insurer;
    }

    // Legal.
    if (c == 'abogado' || c == 'abogados_firma') {
      return WorkspaceType.legal;
    }

    // Fallback genérico para "proveedor" sin sub-tipo: se asume taller
    // (workshop). El refinamiento workshop ↔ supplier ocurre después en
    // ProviderProfile vía `providerType`.
    if (c.contains('proveedor') || c.contains('provider')) {
      return WorkspaceType.workshop;
    }

    return WorkspaceType.unknown;
  }

  /// Atajo: wireName del [WorkspaceType] derivado del code.
  ///
  /// Retorna `null` para code null/vacío/no reconocido — apto para escribir
  /// directamente en `RegistrationProgressModel.resolvedWorkspaceTypeName`,
  /// que es nullable.
  static String? wireNameFromRoleCode(String? code) {
    final type = fromRoleCode(code);
    return type == WorkspaceType.unknown ? null : type.wireName;
  }

  /// Indica si el progreso de registro representa un onboarding de proveedor
  /// (workshop o supplier).
  ///
  /// PREFIERE el campo tipado [resolvedWorkspaceTypeName]. Solo cae al
  /// substring legacy cuando el tipado no existe (registros escritos antes de
  /// la migración).
  static bool isProviderIntent({
    String? resolvedWorkspaceTypeName,
    String? legacySelectedRole,
  }) {
    if (resolvedWorkspaceTypeName != null &&
        resolvedWorkspaceTypeName.isNotEmpty) {
      final type = WorkspaceTypeX.fromWireName(resolvedWorkspaceTypeName);
      return type == WorkspaceType.workshop || type == WorkspaceType.supplier;
    }

    if (legacySelectedRole == null || legacySelectedRole.isEmpty) return false;
    final lower = legacySelectedRole.toLowerCase();
    return lower.contains('proveedor') || lower.contains('provider');
  }
}
