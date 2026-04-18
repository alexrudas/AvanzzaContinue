// ============================================================================
// lib/application/services/session/switch_active_organization_uc.dart
// SWITCH ACTIVE ORGANIZATION UC — Orquestador del cambio de org activa.
//
// QUÉ HACE:
// - Ejecuta la secuencia completa de cambio de organización activa con Zero Trust:
//   1. Marca estado switching + cancela requests org-scoped pendientes.
//   2. Llama Firebase backend switchActiveOrganization y valida que el orgId
//      confirmado coincida con el solicitado (validación cruzada backend→UC).
//   3. Lee claims frescos con getIdTokenResult(true) con retry — hasta 3 intentos
//      con 2s de espera para tolerar propagación eventual de custom claims.
//      [getIdTokenResult(true) ya fuerza el refresh del token — no requiere
//       getIdToken(true) previo, que sería un network call redundante.]
//   4. Valida consistencia claims vs orgId esperado (claimsPropagationFailed si diverge).
//   5. Resuelve orgName desde memberships locales (sin Firestore read adicional).
//   6. Construye y retorna ActiveContext validado listo para persistir.
//
// QUÉ NO HACE:
// - No persiste en Isar ni actualiza SessionContextController — responsabilidad del caller.
// - No navega ni toma decisiones de UI.
// - No setea idle — lo hace el caller después de aplicar el resultado.
//
// PRINCIPIOS:
// - Si falla cualquier paso: estado → failed, contexto previo intacto (no lo modifica).
// - Idempotencia garantizada por el chequeo en SessionContextController._applyValidatedContext.
// - providerType/categories/assetTypes: reset explícito al cambiar de org (no preservar).
//
// ENTERPRISE NOTES:
// - CREADO (2026-04): Deuda de sync activeContext — orquestador único del switch.
// - MODIFICADO (2026-04): M-1: validación cruzada confirmedOrgId backend→UC.
//                         M-3: eliminado getIdToken(true) redundante previo al loop.
// ============================================================================

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/session/org_switch_exceptions.dart';
import '../../../core/session/org_switch_state.dart';
import '../../../data/datasources/organizations/switch_active_organization_remote_ds.dart';
import '../../../domain/entities/user/active_context.dart';
import '../../../domain/entities/user/membership_entity.dart';
import '../../../domain/repositories/user_repository.dart';

/// Resultado del switch exitoso: contexto ya validado contra JWT claims frescos.
class SwitchOrganizationResult {
  /// ActiveContext construido desde orgId (claims) + orgName (membership local)
  /// + rol (elección de workspace del usuario).
  final ActiveContext newContext;

  /// Membership resuelta localmente para el nuevo orgId.
  final MembershipEntity resolvedMembership;

  const SwitchOrganizationResult({
    required this.newContext,
    required this.resolvedMembership,
  });
}

/// Use case orquestador del cambio de organización activa.
///
/// Único punto de orquestación — no debe haber lógica equivalente distribuida
/// en controllers, repositorios ni datasources.
///
/// Vive en la capa application (no domain) porque necesita imports de core
/// (OrgSwitchStateHolder) y data (SwitchActiveOrganizationRemoteDS).
class SwitchActiveOrganizationUC {
  final SwitchActiveOrganizationRemoteDS _remoteDs;
  final UserRepository _userRepository;
  final FirebaseAuth _firebaseAuth;

  SwitchActiveOrganizationUC({
    required SwitchActiveOrganizationRemoteDS remoteDs,
    required UserRepository userRepository,
    FirebaseAuth? firebaseAuth,
  })  : _remoteDs = remoteDs,
        _userRepository = userRepository,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Ejecuta el flujo completo de cambio de organización activa.
  ///
  /// [organizationId]: la organización destino confirmada en el backend.
  /// [targetWorkspaceRole]: el workspace role con el que entra a la nueva org.
  ///   Es una elección UX del usuario — NO derivada de claims.
  /// [uid]: UID del usuario autenticado (para fetchMemberships local).
  ///
  /// Retorna [SwitchOrganizationResult] con el contexto listo para aplicar.
  /// Lanza [SwitchOrganizationException] si algún paso falla.
  /// En cualquier fallo: estado → failed, contexto previo queda intacto.
  Future<SwitchOrganizationResult> execute({
    required String organizationId,
    required String targetWorkspaceRole,
    required String uid,
  }) async {
    final holder = OrgSwitchStateHolder();

    // ── 1. Marcar switching + cancelar requests org-scoped pendientes ─────────
    // IMPORTANTE: esto debe ocurrir ANTES del HTTP call al backend.
    holder.state.value = OrgSwitchState.switching;
    holder.cancelAndRotateToken();
    debugPrint('[SwitchOrgUC] Switching → orgId=$organizationId rol=$targetWorkspaceRole');

    try {
      // ── 2. Llamar backend (actualiza user_active_contexts + custom claims) ──
      // M-1: capturar respuesta y validar que el orgId confirmado coincida
      // con el solicitado. El DS construye el response pero el UC no lo validaba.
      final backendResponse = await _remoteDs.switchActiveOrganization(organizationId);
      if (backendResponse.organizationId != organizationId) {
        throw SwitchOrganizationException(
          'Backend confirmed unexpected orgId: '
          'expected=$organizationId, got=${backendResponse.organizationId}',
          SwitchOrganizationFailureReason.backendError,
        );
      }
      debugPrint('[SwitchOrgUC] Backend confirmed switch (orgId=${backendResponse.organizationId})');

      // ── 3. Verificar que el usuario Firebase sigue autenticado ───────────────
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw const SwitchOrganizationException(
          'Firebase user became null during switch',
          SwitchOrganizationFailureReason.notAuthenticated,
        );
      }

      // ── 4. Leer claims frescos con retry para propagación eventual ────────────
      // Firebase Admin setCustomUserClaims() puede tardar 1-2s en propagarse.
      // Se reintenta hasta maxAttempts veces con 2s de espera entre intentos.
      // getIdTokenResult(true) ya fuerza el refresh del token en cada intento —
      // no se requiere getIdToken(true) previo (sería una network call redundante).
      String? claimsOrgId;
      const maxAttempts = 3; // intentos 0, 1, 2

      for (int attempt = 0; attempt < maxAttempts; attempt++) {
        try {
          final idTokenResult = await firebaseUser.getIdTokenResult(true);
          final claims = idTokenResult.claims ?? {};
          final activeCtxClaims =
              claims['activeContext'] as Map<String, dynamic>?;
          claimsOrgId =
              activeCtxClaims?['organizationId'] as String?;
          debugPrint(
            '[SwitchOrgUC] Claims attempt ${attempt + 1}/$maxAttempts: claimsOrgId=$claimsOrgId',
          );
        } catch (e) {
          throw SwitchOrganizationException(
            'getIdTokenResult failed on attempt ${attempt + 1}: $e',
            SwitchOrganizationFailureReason.tokenRefreshFailed,
          );
        }

        if (claimsOrgId == organizationId) break;

        // Claims aún no propagaron — esperar antes del siguiente intento
        if (attempt < maxAttempts - 1) {
          await Future<void>.delayed(const Duration(seconds: 2));
        }
      }

      // ── 5. Validar consistencia claims vs orgId esperado ─────────────────────
      if (claimsOrgId != organizationId) {
        throw SwitchOrganizationException(
          'Claims propagation failed after $maxAttempts attempts. '
          'Expected=$organizationId, got=$claimsOrgId',
          SwitchOrganizationFailureReason.claimsPropagationFailed,
        );
      }

      // ── 6. Resolver orgName desde memberships locales ─────────────────────────
      // Sin Firestore read adicional — memberships están en el repositorio local (Isar).
      final memberships = await _userRepository.fetchMemberships(uid);
      final membership = memberships.firstWhereOrNull(
        (m) => m.orgId == organizationId,
      );

      if (membership == null) {
        throw SwitchOrganizationException(
          'Membership for orgId=$organizationId not found locally after backend switch. '
          'Local membership data is inconsistent with backend state.',
          SwitchOrganizationFailureReason.membershipNotFound,
        );
      }

      // ── 7. Construir ActiveContext validado ────────────────────────────────────
      // orgId: desde claims (fuente canónica de tenancy).
      // orgName: desde membership local (no está en claims).
      // rol: elección UX del usuario — no derivada de claims.
      // providerType/categories/assetTypes: reset explícito — nueva org = nuevo contexto.
      //   No se preservan valores anteriores que podrían ser incoherentes con la nueva org.
      final newContext = ActiveContext(
        orgId: organizationId,
        orgName: membership.orgName,
        rol: targetWorkspaceRole,
        // providerType: null (default de ActiveContext)
        // categories: []  (default de ActiveContext)
        // assetTypes: []  (default de ActiveContext)
      );

      debugPrint('[SwitchOrgUC] Context built: orgId=$organizationId orgName=${membership.orgName}');

      // Nota: NO seteamos idle aquí.
      // El caller (SessionContextController.switchOrganization) lo hace después
      // de persistir el contexto con _applyValidatedContext.
      return SwitchOrganizationResult(
        newContext: newContext,
        resolvedMembership: membership,
      );
    } catch (e) {
      // Cualquier fallo → estado failed. El contexto previo sigue intacto
      // porque este use case nunca escribe directamente al controller o Isar.
      holder.state.value = OrgSwitchState.failed;
      debugPrint('[SwitchOrgUC] Switch failed: $e');

      if (e is SwitchOrganizationException) rethrow;
      throw SwitchOrganizationException(
        'Unexpected error during org switch: $e',
        SwitchOrganizationFailureReason.unknown,
      );
    }
  }
}
