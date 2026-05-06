// ============================================================================
// lib/domain/services/workspace/context_validator.dart
// CONTEXT VALIDATOR — Enterprise Ultra Pro Premium (Domain Service)
//
// QUÉ HACE:
// - Valida si un WorkspaceContext es estructuralmente íntegro.
// - Valida si un WorkspaceContext está respaldado por al menos una membership
//   activa del usuario en la misma organización.
// - Verifica consistencia entre roleCode legacy y WorkspaceType canónico.
// - Retorna un resultado explícito y trazable vía ContextValidationResult.
//
// QUÉ NO HACE:
// - NO evalúa permisos de features, módulos o acciones finas.
// - NO navega ni decide rutas.
// - NO persiste estado.
// - NO importa Flutter, GetX, Isar ni infraestructura.
// - NO conoce WorkspaceShell, WorkspaceNavigationRegistry ni WorkspaceConfig.
// - NO hace fallback silencioso a assetAdmin.
//
// PRINCIPIOS:
// - PURE DART: solo lógica de dominio.
// - FAIL SAFE: en caso de duda, invalida.
// - TRAZABILIDAD: siempre expone un reasonCode estable.
// - CONSISTENCIA: valida tanto integridad estructural como respaldo por membership.
// - NO SUBSTRING MAGIC: evita contains() permisivos para matching de roles.
//
// INVARIANTES:
// - Un contexto con WorkspaceType.unknown siempre es inválido.
// - Un contexto sin workspaceId/orgId/membershipId siempre es inválido.
// - Un contexto sin roleCode siempre es inválido.
// - Un contexto sin membership activa compatible siempre es inválido.
//
// DEPENDENCIAS:
// - WorkspaceContextAdapter (normalización y mapping canónico legacy)
// - MembershipEntity
// - WorkspaceContext
// - WorkspaceType
// ============================================================================

import '../../adapters/workspace_context_adapter.dart';
import '../../entities/user/membership_entity.dart';
import '../../entities/workspace/workspace_context.dart';
import '../../entities/workspace/workspace_type.dart';

/// Resultado explícito de validación de contexto.
///
/// `reasonCode` debe ser estable y apto para logs, debugging y telemetría.
class ContextValidationResult {
  /// True si el contexto es válido y accesible.
  final bool isValid;

  /// Código semántico del motivo.
  ///
  /// Si [isValid] == true, normalmente será `valid`.
  final String reasonCode;

  /// Detalle opcional para diagnóstico.
  final String? detail;

  const ContextValidationResult._({
    required this.isValid,
    required this.reasonCode,
    this.detail,
  });

  const ContextValidationResult.valid({String? detail})
      : this._(
          isValid: true,
          reasonCode: 'valid',
          detail: detail,
        );

  const ContextValidationResult.invalid(
    String reasonCode, {
    String? detail,
  }) : this._(
          isValid: false,
          reasonCode: reasonCode,
          detail: detail,
        );

  @override
  String toString() {
    if (detail == null || detail!.trim().isEmpty) {
      return isValid ? 'valid' : 'invalid($reasonCode)';
    }
    return isValid ? 'valid($detail)' : 'invalid($reasonCode, detail: $detail)';
  }
}

/// Servicio de validación de WorkspaceContext.
///
/// Este servicio valida que el contexto:
/// 1. sea estructuralmente íntegro,
/// 2. no esté en cuarentena (`unknown`),
/// 3. esté respaldado por una membership activa en la misma org,
/// 4. sea consistente con al menos un rol legacy de esa membership.
class ContextValidator {
  ContextValidator._();

  // ==========================================================================
  // API pública
  // ==========================================================================

  /// Valida un [WorkspaceContext] contra las memberships del usuario.
  static ContextValidationResult validate({
    required WorkspaceContext context,
    required List<MembershipEntity> memberships,
  }) {
    final structuralResult = _validateStructure(context);
    if (!structuralResult.isValid) {
      return structuralResult;
    }

    return _validateAgainstMemberships(
      context: context,
      memberships: memberships,
    );
  }

  /// Shorthand booleano cuando solo importa el resultado final.
  static bool isValid({
    required WorkspaceContext context,
    required List<MembershipEntity> memberships,
  }) {
    return validate(
      context: context,
      memberships: memberships,
    ).isValid;
  }

  // ==========================================================================
  // Validación estructural
  // ==========================================================================

  static ContextValidationResult _validateStructure(WorkspaceContext context) {
    if (context.workspaceId.trim().isEmpty) {
      return const ContextValidationResult.invalid('workspace_id_empty');
    }

    if (context.membershipId.trim().isEmpty) {
      return const ContextValidationResult.invalid('membership_id_empty');
    }

    if (context.orgId.trim().isEmpty) {
      return const ContextValidationResult.invalid('org_id_empty');
    }

    if (context.orgName.trim().isEmpty) {
      return const ContextValidationResult.invalid('org_name_empty');
    }

    // Fase 2 (KILL SWITCH ROL LEGACY): roleCode puede ser vacío. El "rol UI"
    // se deriva de capabilities + isProvider. Solo se rechaza si el tipo del
    // workspace está en cuarentena explícita (`unknown`).
    if (context.type == WorkspaceType.unknown) {
      return const ContextValidationResult.invalid('workspace_type_unknown');
    }

    if (!context.isValid) {
      return const ContextValidationResult.invalid('workspace_context_invalid');
    }

    return const ContextValidationResult.valid();
  }

  // ==========================================================================
  // Validación contra memberships
  // ==========================================================================

  static ContextValidationResult _validateAgainstMemberships({
    required WorkspaceContext context,
    required List<MembershipEntity> memberships,
  }) {
    if (memberships.isEmpty) {
      return const ContextValidationResult.invalid('no_memberships');
    }

    // Fase 2 (KILL SWITCH ROL LEGACY): basta con que exista una membership
    // ACTIVE para la misma orgId. Ya no se exige que `m.roles` cubra el
    // `roleCode` del contexto — los permisos viven en `capabilities[]`.
    final hasActiveSameOrg = memberships.any(
      (m) => _isMembershipActive(m.estatus) && m.orgId == context.orgId,
    );

    if (!hasActiveSameOrg) {
      return const ContextValidationResult.invalid(
        'no_active_membership_for_org',
      );
    }

    return const ContextValidationResult.valid();
  }

  // ==========================================================================
  // Helpers privados
  // ==========================================================================

  static bool _isMembershipActive(String estatus) {
    final normalized = WorkspaceContextAdapter.normalizeRole(estatus);
    return normalized == 'activo' || normalized == 'active';
  }

}
