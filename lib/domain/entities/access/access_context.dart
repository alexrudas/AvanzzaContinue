// ============================================================================
// lib/domain/entities/access/access_context.dart
// ACCESS CONTEXT ENTITY — snapshot canónico del estado de acceso del caller.
// ============================================================================
// QUÉ HACE:
// - Modela la respuesta de GET /v1/access/me/context como entidad de dominio
//   (inmutable, agnóstica de Dio/Flutter).
// - Encapsula sub-entidades `AccessUser`, `AccessWorkspace`, `AccessMembership`.
// - Expone el `requiresAction` canónico, lista de `capabilities` y el flag
//   `requiresTokenRefresh`.
//
// QUÉ NO HACE:
// - No decide flujo. El consumer (AccessGateway) interpreta `requiresAction`.
// - No persiste a disco. Este es snapshot runtime; se recalcula llamando a
//   /context de nuevo.
// - No mapea a UX. La UI decide textos/banners en presentation.
//
// PRINCIPIOS:
// - Inmutabilidad + construcción explícita (sin reflection).
// - Parser tolerante: desconocidos → null en sub-entities, nunca excepción
//   silenciosa en el dominio (el DTO en data layer hace parsing seguro).
// - Zero dependencies fuera de dart:core.
//
// ENTERPRISE NOTES:
// - Fuente: "Contrato de integración — Flutter ↔ Core API Access" §3.1.
// - `capabilities` se guarda en un `SessionCapabilitiesStore` separado (no
//   dentro de este snapshot) porque su ciclo de vida y observabilidad son
//   independientes de un fetch puntual.
// ============================================================================

import 'access_enums.dart';

/// Identidad interna del caller (fila `user` en Postgres de Core API).
/// Null si `isProvisioned == false`.
class AccessUser {
  /// UUID del user en Postgres.
  final String id;

  /// Estado del user. Solo `active` permite continuar.
  final AccessUserStatus status;

  const AccessUser({
    required this.id,
    required this.status,
  });

  @override
  String toString() => 'AccessUser(id=$id, status=${status.name})';
}

/// Workspace canónico resuelto vía bridge `orgId` (legacy string) ↔
/// `Workspace.id` (UUID). Null si no hay `activeOrgId` o el bridge no
/// encuentra workspace.
class AccessWorkspace {
  /// UUID canónico (`Workspace.id`).
  final String id;

  /// Bridge legacy string (`Workspace.orgId`).
  final String orgId;

  /// Estado del workspace. Solo `active` permite operar.
  final AccessWorkspaceState state;

  const AccessWorkspace({
    required this.id,
    required this.orgId,
    required this.state,
  });

  @override
  String toString() =>
      'AccessWorkspace(id=$id, orgId=$orgId, state=${state.name})';
}

/// Vínculo del caller al workspace resuelto. Null si no existe membership
/// entre (user, workspace).
class AccessMembership {
  /// UUID de la membership.
  final String id;

  /// Estado de la membership. Solo `active` permite operar.
  final AccessMembershipStatus status;

  const AccessMembership({
    required this.id,
    required this.status,
  });

  @override
  String toString() => 'AccessMembership(id=$id, status=${status.name})';
}

/// Snapshot canónico del estado de acceso del caller en un instante dado.
/// Es el único entregable de GET /v1/access/me/context.
class AccessContext {
  /// `true` si el caller tiene fila en Postgres (`user.authUid == token.uid`).
  final bool isProvisioned;

  /// Identidad interna. Null si `isProvisioned == false`.
  final AccessUser? user;

  /// `orgId` resuelto del token claim. Null si el token no trae claim.
  final String? activeOrgId;

  /// Workspace canónico resuelto vía bridge. Null si `activeOrgId` es null
  /// o no existe workspace con ese `orgId`.
  final AccessWorkspace? activeWorkspace;

  /// Vínculo del caller al workspace. Null si no existe membership.
  final AccessMembership? membership;

  /// Capabilities resueltas (`Membership → Role → RoleCapability → Capability.id`).
  /// Siempre lista no-null (vacía si nada). Útil para pre-habilitar UI.
  final List<String> capabilities;

  /// Única fuente de verdad sobre qué debe hacer el cliente ahora.
  final RequiresAction requiresAction;

  /// Si `true`, el cliente DEBE `FirebaseAuth.currentUser?.getIdToken(true)`
  /// antes de continuar (forward-compatibility con Cloud Function de claims).
  final bool requiresTokenRefresh;

  const AccessContext({
    required this.isProvisioned,
    required this.user,
    required this.activeOrgId,
    required this.activeWorkspace,
    required this.membership,
    required this.capabilities,
    required this.requiresAction,
    required this.requiresTokenRefresh,
  });

  /// Convenience: cliente listo para llamadas protegidas.
  bool get isReady => requiresAction == RequiresAction.none;

  /// Convenience: estado bloqueante terminal por policy (sin bootstrap
  /// posible).
  bool get isBlocked => requiresAction == RequiresAction.contactSupport;

  @override
  String toString() => 'AccessContext('
      'isProvisioned=$isProvisioned, '
      'activeOrgId=$activeOrgId, '
      'requiresAction=${requiresAction.name}, '
      'capabilities=${capabilities.length}, '
      'requiresTokenRefresh=$requiresTokenRefresh)';
}
