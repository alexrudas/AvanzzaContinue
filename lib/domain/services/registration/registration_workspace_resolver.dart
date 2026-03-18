// ============================================================================
// lib/domain/services/registration/registration_workspace_resolver.dart
// REGISTRATION WORKSPACE RESOLVER — Enterprise Ultra Pro Premium (Domain / Services / Registration)
//
// QUÉ HACE:
// - Aplica la Matriz de Mapeo Formal (§4 del contrato v1.1) para resolver
//   el legacyRoleCode canónico desde (workspaceType, businessMode, orgType).
// - Construye un workspaceId determinístico alineado con el contrato:
//     deterministic(orgId, membershipId, workspaceType)
// - Produce ResolvedRegistrationWorkspace como output contract tipado.
// - Verifica isConsistent antes de retornar para garantizar que el contrato
//   sea seguro para doble escritura y bootstrap.
//
// QUÉ NO HACE:
// - NO persiste nada.
// - NO navega ni decide rutas.
// - NO importa Flutter, GetX, Isar ni infraestructura.
// - NO crea Organization, Membership ni UserEntity.
// - NO define la matriz: la implementa.
//
// PRINCIPIOS:
// - PURE DOMAIN SERVICE: cero dependencias de infraestructura.
// - FAIL-FAST: lanza excepciones semánticas si el intent no es válido, si la
//   combinación no existe en la matriz o si el contrato producido no es consistente.
// - DETERMINISMO: la misma entrada produce siempre el mismo output.
// - SINGLE RESPONSIBILITY: resuelve el contrato; no escribe, no navega.
//
// MATRIZ FORMAL (contrato §4):
//   owner      + self_managed     + personal → propietario
//   owner      + delegated        + personal → propietario
//   assetAdmin + third_party      + empresa  → administrador
//   assetAdmin + hybrid           + empresa  → administrador
//   renter     + consumer         + personal → arrendatario
//   renter     + consumer         + empresa  → arrendatario
//   workshop   + service_provider + empresa  → proveedor_servicios
//   supplier   + retailer         + empresa  → proveedor_articulos
//
// DEPENDENCIAS:
// - RegistrationWorkspaceIntent (domain/entities/workspace)
// - WorkspaceType (domain/entities/workspace)
// - BusinessMode (domain/value/workspace)
// - WorkspaceContextSeed (domain/value/workspace)
// - ResolvedRegistrationWorkspace (domain/value/registration)
// ============================================================================

import '../../entities/workspace/registration_workspace_intent.dart';
import '../../entities/workspace/workspace_type.dart';
import '../../value/registration/resolved_registration_workspace.dart';
import '../../value/workspace/business_mode.dart';
import '../../value/workspace/workspace_context_seed.dart';

/// Excepción semántica del resolver.
///
/// Lanzada cuando:
/// - la combinación (workspaceType, businessMode, orgType) no existe en la matriz
/// - el contrato producido no pasa validación de consistencia
class RegistrationWorkspaceResolverException implements Exception {
  /// Código semántico estable para UI, logs y telemetría.
  final String reasonCode;

  /// Detalle técnico opcional para diagnóstico.
  final String? detail;

  const RegistrationWorkspaceResolverException(
    this.reasonCode, {
    this.detail,
  });

  @override
  String toString() {
    final suffix = detail == null ? '' : ', detail: $detail';
    return 'RegistrationWorkspaceResolverException($reasonCode$suffix)';
  }
}

/// Servicio de dominio que aplica la Matriz de Mapeo Formal (§4) y produce
/// el output contract tipado del registro.
///
/// Stateless. Todas las operaciones son puras y deterministas.
class RegistrationWorkspaceResolver {
  const RegistrationWorkspaceResolver();

  // ==========================================================================
  // RESOLUCIÓN PRINCIPAL
  // ==========================================================================

  /// Aplica la matriz formal y produce [ResolvedRegistrationWorkspace].
  ///
  /// Parámetros contextuales requeridos:
  /// - [userId]: UID del usuario autenticado.
  /// - [orgId]: ID de la organización creada.
  /// - [orgName]: nombre visible de la organización.
  ///
  /// Lanza [RegistrationWorkspaceIntentException] si el intent no es válido.
  /// Lanza [RegistrationWorkspaceResolverException] si:
  /// - la combinación no existe en la matriz
  /// - el contrato producido no es consistente
  ResolvedRegistrationWorkspace resolve({
    required RegistrationWorkspaceIntent intent,
    required String userId,
    required String orgId,
    required String orgName,
  }) {
    // Paso 1: validar el intent antes de cualquier resolución.
    intent.validate();

    final normalizedUserId = userId.trim();
    final normalizedOrgId = orgId.trim();
    final normalizedOrgName = orgName.trim();

    if (normalizedUserId.isEmpty) {
      throw const RegistrationWorkspaceResolverException(
        'empty_user_id',
        detail: 'userId must not be empty',
      );
    }

    if (normalizedOrgId.isEmpty) {
      throw const RegistrationWorkspaceResolverException(
        'empty_org_id',
        detail: 'orgId must not be empty',
      );
    }

    if (normalizedOrgName.isEmpty) {
      throw const RegistrationWorkspaceResolverException(
        'empty_org_name',
        detail: 'orgName must not be empty',
      );
    }

    // Paso 2: resolver legacyRoleCode desde la matriz formal.
    final legacyRoleCode = _resolveRoleCode(
      workspaceType: intent.workspaceType,
      businessMode: intent.businessMode,
      orgType: intent.orgType,
    );

    // Paso 3: construir membershipId transicional (Fase 2).
    final membershipId = '${normalizedUserId}_$normalizedOrgId';

    // Paso 4: construir workspaceId determinístico ALINEADO CON EL CONTRATO.
    // Regla: workspaceId depende de orgId + membershipId + workspaceType.
    // NO depende estructuralmente de legacyRoleCode.
    final workspaceId = _buildWorkspaceId(
      orgId: normalizedOrgId,
      membershipId: membershipId,
      workspaceType: intent.workspaceType,
    );

    // Paso 5: construir el seed serializable.
    final seed = WorkspaceContextSeed(
      workspaceId: workspaceId,
      membershipId: membershipId,
      orgId: normalizedOrgId,
      orgName: normalizedOrgName,
      orgType: intent.orgType,
      workspaceType: intent.workspaceType,
      roleCode: legacyRoleCode,
      providerType: intent.providerType,
    );

    // Paso 6: construir el contrato de salida.
    final resolved = ResolvedRegistrationWorkspace(
      workspaceType: intent.workspaceType,
      businessMode: intent.businessMode,
      workspaceId: workspaceId,
      orgId: normalizedOrgId,
      orgType: intent.orgType,
      membershipId: membershipId,
      legacyRoleCode: legacyRoleCode,
      activeWorkspaceId: workspaceId,
      workspaceContextSeed: seed,
      providerType: intent.providerType,
    );

    // Paso 7: verificar consistencia interna antes de retornar.
    if (!resolved.isConsistent) {
      throw RegistrationWorkspaceResolverException(
        'inconsistent_output_contract',
        detail: resolved.debugDescription,
      );
    }

    return resolved;
  }

  // ==========================================================================
  // MATRIZ DE MAPEO FORMAL — §4 del contrato v1.1
  // ==========================================================================

  /// Resuelve legacyRoleCode desde (workspaceType, businessMode, orgType).
  ///
  /// Si la combinación no existe en la matriz, lanza
  /// [RegistrationWorkspaceResolverException] con reasonCode
  /// `unmapped_combination`.
  String _resolveRoleCode({
    required WorkspaceType workspaceType,
    required BusinessMode businessMode,
    required String orgType,
  }) {
    final org = orgType.trim().toLowerCase();

    if (workspaceType == WorkspaceType.owner &&
        businessMode == BusinessMode.selfManaged &&
        org == 'personal') {
      return 'propietario';
    }

    if (workspaceType == WorkspaceType.owner &&
        businessMode == BusinessMode.delegated &&
        org == 'personal') {
      return 'propietario';
    }

    if (workspaceType == WorkspaceType.assetAdmin &&
        businessMode == BusinessMode.thirdParty &&
        org == 'empresa') {
      return 'administrador';
    }

    if (workspaceType == WorkspaceType.assetAdmin &&
        businessMode == BusinessMode.hybrid &&
        org == 'empresa') {
      return 'administrador';
    }

    if (workspaceType == WorkspaceType.renter &&
        businessMode == BusinessMode.consumer &&
        (org == 'personal' || org == 'empresa')) {
      return 'arrendatario';
    }

    if (workspaceType == WorkspaceType.workshop &&
        businessMode == BusinessMode.serviceProvider &&
        org == 'empresa') {
      return 'proveedor_servicios';
    }

    if (workspaceType == WorkspaceType.supplier &&
        businessMode == BusinessMode.retailer &&
        org == 'empresa') {
      return 'proveedor_articulos';
    }

    throw RegistrationWorkspaceResolverException(
      'unmapped_combination',
      detail: 'No entry in formal matrix for '
          'workspaceType=${workspaceType.wireName}, '
          'businessMode=${businessMode.wireName}, '
          'orgType=$orgType',
    );
  }

  // ==========================================================================
  // WORKSPACE ID DETERMINÍSTICO
  // ==========================================================================

  /// Construye un workspaceId determinístico alineado con el contrato v1.1.
  ///
  /// Regla:
  ///   deterministic(orgId, membershipId, workspaceType)
  ///
  /// NO depende estructuralmente de legacyRoleCode.
  String _buildWorkspaceId({
    required String orgId,
    required String membershipId,
    required WorkspaceType workspaceType,
  }) {
    final safeOrgId = _slug(orgId);
    final safeMembershipId = _slug(membershipId);
    final safeType = _slug(workspaceType.wireName);

    return 'ws_${safeOrgId}_${safeMembershipId}_$safeType';
  }

  // ==========================================================================
  // HELPERS PRIVADOS
  // ==========================================================================

  static String _slug(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    return normalized.isEmpty ? 'na' : normalized;
  }
}
