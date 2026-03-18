// ============================================================================
// lib/domain/adapters/workspace_context_adapter.dart
// WORKSPACE CONTEXT ADAPTER — Enterprise Ultra Pro Premium (Domain Adapter)
//
// QUÉ HACE:
// - Traduce el modelo legacy (roles string + providerType + orgType)
//   al nuevo modelo tipado [WorkspaceContext].
// - Define la ÚNICA fuente de verdad del mapping roleCode → WorkspaceType
//   durante la Fase 1 transicional.
// - Construye WorkspaceContexts disponibles a partir de MembershipEntity[].
// - Genera workspaceId determinista y estable para UX/session switching.
// - Deduplica contextos equivalentes dentro del mismo ciclo de hidratación.
// - Aísla toda la lógica legacy para que bootstrap y navegación no dependan
//   de strings de rol.
//
// QUÉ NO HACE:
// - NO navega ni resuelve rutas.
// - NO persiste ningún estado en Isar o Firestore.
// - NO lee infraestructura ni repositorios.
// - NO evalúa permisos ni policies.
// - NO decide cuál contexto activo es válido en runtime
//   (eso pertenece a ContextValidator / bootstrap).
// - NO toca WorkspaceType ni MembershipEntity (solo los consume).
//
// PRINCIPIOS:
// - AISLAMIENTO: nadie fuera de este adapter debe hacer contains/switch sobre
//   strings de rol legacy.
// - DETERMINISMO: el mismo input produce el mismo WorkspaceContext.
// - COMPATIBILIDAD: usa SOLO campos que existen en MembershipEntity hoy:
//   userId, orgId, orgName, roles, providerProfiles, estatus.
// - SEGURIDAD: WorkspaceType.unknown NO hace fallback silencioso a assetAdmin.
// - TRAZABILIDAD: roleCode y source quedan preservados en el contexto.
//
// MAPPING CANÓNICO FASE 1 (usa solo valores existentes en WorkspaceType):
//   'admin*' | 'gestor*' | 'gestion*'              → WorkspaceType.assetAdmin
//   'propietario*' | 'owner*' | 'inversor*'        → WorkspaceType.owner
//   'arrendatario*' | 'inquilino*' | 'lessee*'     → WorkspaceType.renter
//   'taller*' | 'tecnico*' | 'mecanico*'           → WorkspaceType.workshop
//   'proveedor*' + providerType='articulos'        → WorkspaceType.supplier
//   'proveedor*' + providerType='servicios'        → WorkspaceType.workshop
//   'proveedor*' sin providerType                  → WorkspaceType.supplier (conservador)
//   'aseguradora*' | 'broker*' | 'seguros*'        → WorkspaceType.insurer
//   'abog*' | 'juridic*' | 'legal*'                → WorkspaceType.legal
//   'asesor*' | 'consultor*' | 'auditor*'          → WorkspaceType.advisor
//   'conductor*' | 'driver*' | 'operador*'         → WorkspaceType.unknown
//     ↑ PENDIENTE FASE 2: WorkspaceType.driverOperator aún no existe en el enum.
//       Cuando se agregue, actualizar SOLO esta sección del adapter.
//   otherwise                                      → WorkspaceType.unknown
//
// ENTERPRISE NOTES:
// - membershipId no existe como campo en MembershipEntity (Fase 1).
//   Se construye de forma transicional como '${userId}_${orgId}'.
//   Cuando MembershipEntity incorpore membershipId propio, actualizar
//   _resolveMembershipId() sin tocar el resto del adapter.
//
// DEPENDENCIAS:
// - MembershipEntity (domain/entities/user)
// - WorkspaceContext, WorkspaceContextSource (domain/entities/workspace)
// - WorkspaceType (domain/entities/workspace)
// ============================================================================

import '../entities/user/membership_entity.dart';
import '../entities/workspace/workspace_context.dart';
import '../entities/workspace/workspace_type.dart';

class WorkspaceContextAdapter {
  WorkspaceContextAdapter._();

  // ==========================================================================
  // API PÚBLICA
  // ==========================================================================

  /// Construye un [WorkspaceContext] desde campos legacy directos.
  ///
  /// Útil para: bootstrap temprano, reconstrucción desde activeContext legacy,
  /// onboarding, tests.
  ///
  /// - [orgId]        Partition key Firestore/Isar. NUNCA usar workspaceId para queries.
  /// - [orgName]      Display name de la organización.
  /// - [roleCode]     Rol legacy (e.g., 'administrador', 'propietario').
  /// - [membershipId] ID semántico de membership. En Fase 1: '{userId}_{orgId}'.
  ///                  Acepta vacío cuando el userId aún no está disponible.
  /// - [providerType] 'articulos' | 'servicios' | null.
  /// - [orgType]      'personal' | 'empresa'. Default: 'personal'.
  /// - [source]       Origen del contexto. Default: derivedFromLegacy.
  static WorkspaceContext fromLegacy({
    required String orgId,
    required String orgName,
    required String roleCode,
    String membershipId = '',
    String? providerType,
    String orgType = 'personal',
    WorkspaceContextSource source = WorkspaceContextSource.derivedFromLegacy,
  }) {
    final normalizedRole = normalizeRole(roleCode);
    final normalizedProviderType = normalizeProviderType(providerType);
    final normalizedOrgType = normalizeOrgType(orgType);

    final type = resolveType(
      normalizedRole: normalizedRole,
      normalizedProviderType: normalizedProviderType,
    );

    final effectiveMembershipId = membershipId.trim();
    final workspaceId = buildWorkspaceId(
      orgId: orgId.trim(),
      membershipId: effectiveMembershipId,
      normalizedRole: normalizedRole,
      type: type,
    );

    return WorkspaceContext(
      workspaceId: workspaceId,
      membershipId: effectiveMembershipId,
      orgId: orgId.trim(),
      orgName: orgName.trim(),
      type: type,
      roleCode: normalizedRole,
      providerType: normalizedProviderType,
      orgType: normalizedOrgType,
      source: source,
    );
  }

  /// Construye todos los [WorkspaceContext] disponibles a partir de memberships.
  ///
  /// REGLAS:
  /// - Ignora memberships con estatus != 'activo'.
  /// - Ignora roles vacíos.
  /// - Deduplica contextos equivalentes por workspaceId+membershipId+type.
  ///
  /// NOTA Fase 1: MembershipEntity no tiene campo membershipId propio.
  /// Se usa '${membership.userId}_${membership.orgId}' como fallback determinista.
  /// Ver _resolveMembershipId() y ENTERPRISE NOTES del encabezado.
  static List<WorkspaceContext> fromMemberships({
    required List<MembershipEntity> memberships,
    String? providerType,
    String orgType = 'personal',
  }) {
    final result = <WorkspaceContext>[];
    final seen = <String>{};

    final normalizedGlobalProviderType = normalizeProviderType(providerType);
    final normalizedGlobalOrgType = normalizeOrgType(orgType);

    for (final membership in memberships) {
      if (!_isMembershipActive(membership.estatus)) continue;
      if (membership.roles.isEmpty) continue;

      // FASE 1: membershipId construido de forma transicional.
      // Actualizar cuando MembershipEntity incluya su propio campo membershipId.
      final resolvedMembershipId = _resolveMembershipId(membership);

      for (final rawRole in membership.roles) {
        final normalizedRole = normalizeRole(rawRole);
        if (normalizedRole.isEmpty) continue;

        final resolvedProviderType = _resolveProviderTypeForMembership(
          membership: membership,
          globalProviderType: normalizedGlobalProviderType,
        );

        final context = fromLegacy(
          orgId: membership.orgId,
          orgName: membership.orgName,
          roleCode: normalizedRole,
          membershipId: resolvedMembershipId,
          providerType: resolvedProviderType,
          orgType: normalizedGlobalOrgType,
          source: WorkspaceContextSource.resolvedFromMembership,
        );

        final dedupeKey = '${context.workspaceId}|${context.membershipId}|${context.type.wireName}';
        if (seen.add(dedupeKey)) {
          result.add(context);
        }
      }
    }

    return result;
  }

  // ==========================================================================
  // MAPPING CANÓNICO LEGACY → WORKSPACETYPE
  // (ÚNICA fuente de verdad del mapping transicional)
  // ==========================================================================

  /// Resuelve el [WorkspaceType] canónico desde rol normalizado + providerType.
  ///
  /// IMPORTANTE: Usa solo valores existentes en [WorkspaceType] hoy.
  /// Ver sección MAPPING CANÓNICO del encabezado para decisiones pendientes.
  static WorkspaceType resolveType({
    required String normalizedRole,
    String? normalizedProviderType,
  }) {
    // 1. Asset admin
    if (_containsAny(normalizedRole, ['admin', 'administrador', 'gestor', 'gestion'])) {
      return WorkspaceType.assetAdmin;
    }

    // 2. Owner
    if (_containsAny(normalizedRole, ['propietario', 'owner', 'inversionista', 'inversor'])) {
      return WorkspaceType.owner;
    }

    // 3. Renter
    if (_containsAny(normalizedRole, ['arrendatario', 'inquilino', 'renter', 'lessee'])) {
      return WorkspaceType.renter;
    }

    // 4. Conductor / driver / operador
    // PENDIENTE FASE 2: WorkspaceType.driverOperator aún no existe en el enum.
    // Cuando se agregue, reemplazar WorkspaceType.unknown por WorkspaceType.driverOperator aquí.
    if (_containsAny(normalizedRole, ['conductor', 'driver', 'operador', 'operator'])) {
      return WorkspaceType.unknown;
    }

    // 5. Workshop (taller, técnico, mecánico)
    if (_containsAny(normalizedRole, ['taller', 'workshop', 'tecnico', 'mecanico', 'servicio tecnico'])) {
      return WorkspaceType.workshop;
    }

    // 6. Proveedor (diferenciado por providerType)
    if (_containsAny(normalizedRole, ['proveedor', 'supplier', 'repuestos', 'insumos'])) {
      if (normalizedProviderType == 'servicios') return WorkspaceType.workshop;
      // 'articulos' o sin providerType → supplier (fallback conservador)
      return WorkspaceType.supplier;
    }

    // 7. Insurer
    if (_containsAny(normalizedRole, ['aseguradora', 'asegurador', 'broker', 'seguros'])) {
      return WorkspaceType.insurer;
    }

    // 8. Legal
    if (_containsAny(normalizedRole, ['abog', 'juridic', 'legal', 'litigio'])) {
      return WorkspaceType.legal;
    }

    // 9. Advisor
    if (_containsAny(normalizedRole, ['asesor', 'advisor', 'consultor', 'auditor'])) {
      return WorkspaceType.advisor;
    }

    return WorkspaceType.unknown;
  }

  // ==========================================================================
  // NORMALIZACIÓN
  // ==========================================================================

  /// Normaliza un roleCode legacy: lowercase, sin acentos, sin guiones extra.
  static String normalizeRole(String? input) {
    if (input == null) return '';
    return input
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll('ñ', 'n')
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Normaliza providerType: 'articulos' | 'servicios' | null.
  static String? normalizeProviderType(String? input) {
    final v = normalizeRole(input);
    if (v.isEmpty) return null;
    if (v == 'articulos' || v == 'articulo') return 'articulos';
    if (v == 'servicios' || v == 'servicio') return 'servicios';
    return v;
  }

  /// Normaliza orgType: 'empresa' | 'personal'.
  static String normalizeOrgType(String? input) {
    final v = normalizeRole(input);
    if (v == 'empresa') return 'empresa';
    return 'personal';
  }

  // ==========================================================================
  // IDENTITY / WORKSPACE ID
  // ==========================================================================

  /// Construye el workspaceId determinista y estable.
  /// Formato: 'ws_{slug(orgId)}_{slug(membershipId)}_{wireName}_{slug(role)}'
  /// NO usar como partition key de Firestore/Isar.
  static String buildWorkspaceId({
    required String orgId,
    required String membershipId,
    required String normalizedRole,
    required WorkspaceType type,
  }) {
    final safeOrg = _slug(orgId);
    final safeMbr = membershipId.trim().isEmpty ? 'legacy' : _slug(membershipId);
    final safeRole = normalizedRole.isEmpty ? 'no_role' : _slug(normalizedRole);
    return 'ws_${safeOrg}_${safeMbr}_${type.wireName}_$safeRole';
  }

  // ==========================================================================
  // HELPERS PRIVADOS
  // ==========================================================================

  /// Construye membershipId transicional desde campos reales de MembershipEntity.
  ///
  /// FASE 1: MembershipEntity no tiene campo membershipId propio.
  /// Se construye como '${userId}_${orgId}' — determinista y trazable.
  /// Actualizar cuando la entidad incorpore su propio campo.
  static String _resolveMembershipId(MembershipEntity membership) {
    final safeUserId = membership.userId.trim();
    final safeOrgId = membership.orgId.trim();
    if (safeUserId.isEmpty && safeOrgId.isEmpty) return '';
    return '${safeUserId}_$safeOrgId';
  }

  /// Resuelve providerType para una membership específica.
  /// Prioridad: global > inferido desde providerProfiles > null.
  static String? _resolveProviderTypeForMembership({
    required MembershipEntity membership,
    required String? globalProviderType,
  }) {
    if (globalProviderType != null && globalProviderType.isNotEmpty) {
      return globalProviderType;
    }
    if (membership.providerProfiles.isEmpty) return null;
    final serialized = membership.providerProfiles.map((p) => p.toString().toLowerCase()).join(' ');
    if (serialized.contains('articulo') || serialized.contains('repuesto')) return 'articulos';
    return 'servicios';
  }

  static bool _isMembershipActive(String estatus) {
    final v = normalizeRole(estatus);
    return v == 'activo' || v == 'active';
  }

  static bool _containsAny(String source, List<String> needles) {
    for (final needle in needles) {
      final n = normalizeRole(needle);
      if (n.isNotEmpty && source.contains(n)) return true;
    }
    return false;
  }

  static String _slug(String value) {
    final s = normalizeRole(value)
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return s.isEmpty ? 'na' : s;
  }
}
