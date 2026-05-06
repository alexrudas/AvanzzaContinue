// ============================================================================
// lib/domain/entities/access/access_enums.dart
// ACCESS ENUMS — enums + constantes canónicas del subsistema de acceso.
// ============================================================================
// QUÉ HACE:
// - Define `RequiresAction`: única fuente de verdad sobre qué debe hacer el
//   cliente tras consultar GET /v1/access/me/context.
// - Define `AccessUserStatus`, `AccessWorkspaceState`, `AccessMembershipStatus`
//   como enums wire-stable (parser seguro por nombre).
// - Define la clase `AccessErrorCode` con las constantes `String` de los
//   códigos canónicos que el backend emite en `body.code` (nunca se debe
//   parsear `body.message`).
//
// QUÉ NO HACE:
// - No toma decisiones. La rama (bootstrap / bloqueo / workspace picker /
//   refresh token) la decide el interceptor y el gateway, no el enum.
// - No mapea a UX. Los textos amigables viven en la capa de presentación.
// - No depende de Flutter ni de Dio.
//
// PRINCIPIOS:
// - Wire-stable: el `name` de cada enum coincide literalmente con el valor
//   emitido por Core API. `fromWire` es tolerante (retorna null ante valor
//   desconocido) para permitir rollouts sin romper clientes viejos.
// - Deny-by-default: ante un valor desconocido, el gateway trata la respuesta
//   como bloqueante y degrada UX antes que asumir.
// - Zero dependencias: solo Dart puro.
//
// ENTERPRISE NOTES:
// - Fuente: "Contrato de integración — Flutter ↔ Core API Access" §3.3 + §2.
// - WORKSPACE_CONTEXT_MISSING es 401 (context-missing family), NO 403. Ver
//   memoria `feedback_auth_error_http_status` del repo core-api.
// ============================================================================

/// Única fuente de verdad emitida por GET /v1/access/me/context sobre qué
/// acción debe tomar el cliente para continuar operando. El cliente NUNCA
/// intenta resolver un `requiresAction` distinto al que dicta el servidor.
enum RequiresAction {
  /// Todos los gates pasan (user ACTIVE, workspace ACTIVE, membership ACTIVE).
  /// El cliente puede proceder con endpoints protegidos.
  none,

  /// Falta provisionar: user no existe, workspace no existe o no hay
  /// membership. El cliente debe llamar POST /v1/auth/bootstrap.
  bootstrapRequired,

  /// No hay `activeOrgId` en el claim, o el workspace no está ACTIVE.
  /// El cliente debe presentar workspace picker (fuera del scope de Core API).
  selectWorkspace,

  /// Estado bloqueante por policy (user SUSPENDED/INACTIVE/PENDING o
  /// membership INACTIVE). El cliente NUNCA llama bootstrap ni refresh;
  /// muestra banner bloqueante.
  contactSupport;

  /// Parser tolerante del string emitido por el backend. Retorna null si el
  /// valor es desconocido (forward-compatibility).
  static RequiresAction? fromWire(String? raw) {
    if (raw == null) return null;
    switch (raw) {
      case 'NONE':
        return RequiresAction.none;
      case 'BOOTSTRAP_REQUIRED':
        return RequiresAction.bootstrapRequired;
      case 'SELECT_WORKSPACE':
        return RequiresAction.selectWorkspace;
      case 'CONTACT_SUPPORT':
        return RequiresAction.contactSupport;
      default:
        return null;
    }
  }
}

/// Estado del `User` en el dominio de Core API (Postgres). Solo `active`
/// permite continuar; los demás son terminales hasta intervención humana.
enum AccessUserStatus {
  active,
  inactive,
  suspended,
  pending;

  static AccessUserStatus? fromWire(String? raw) {
    if (raw == null) return null;
    switch (raw) {
      case 'ACTIVE':
        return AccessUserStatus.active;
      case 'INACTIVE':
        return AccessUserStatus.inactive;
      case 'SUSPENDED':
        return AccessUserStatus.suspended;
      case 'PENDING':
        return AccessUserStatus.pending;
      default:
        return null;
    }
  }
}

/// Estado del `Workspace` canónico. Solo `active` permite operar.
enum AccessWorkspaceState {
  active,
  inactive,
  archived;

  static AccessWorkspaceState? fromWire(String? raw) {
    if (raw == null) return null;
    switch (raw) {
      case 'ACTIVE':
        return AccessWorkspaceState.active;
      case 'INACTIVE':
        return AccessWorkspaceState.inactive;
      case 'ARCHIVED':
        return AccessWorkspaceState.archived;
      default:
        return null;
    }
  }
}

/// Estado de la `Membership` entre `User` y `Workspace`. Solo `active` permite
/// operar.
enum AccessMembershipStatus {
  active,
  inactive;

  static AccessMembershipStatus? fromWire(String? raw) {
    if (raw == null) return null;
    switch (raw) {
      case 'ACTIVE':
        return AccessMembershipStatus.active;
      case 'INACTIVE':
        return AccessMembershipStatus.inactive;
      default:
        return null;
    }
  }
}

/// Origen del `orgId` resuelto por el servidor al procesar bootstrap.
/// Telemetría/debugging: ver repetidos `bodyFallback` en producción indica
/// que la Cloud Function de emisión de claim no está operativa.
enum BootstrapOrgIdSource {
  tokenClaim,
  bodyFallback;

  static BootstrapOrgIdSource? fromWire(String? raw) {
    if (raw == null) return null;
    switch (raw) {
      case 'token_claim':
        return BootstrapOrgIdSource.tokenClaim;
      case 'body_fallback':
        return BootstrapOrgIdSource.bodyFallback;
      default:
        return null;
    }
  }
}

/// Códigos canónicos que Core API emite en `body.code`. El cliente SIEMPRE
/// discrimina por este código; `body.message` es texto humano variable.
///
/// Clase namespace de constantes (no enum para permitir código extensible
/// sin romper el switch). Agrupada por familia HTTP para lectura.
class AccessErrorCode {
  AccessErrorCode._();

  // ── 400 — client error ──────────────────────────────────────────────────
  static const String activeOrgIdMissing = 'ACTIVE_ORG_ID_MISSING';

  // ── 401 — context-missing / unauthenticated ─────────────────────────────
  static const String missingAuthToken = 'MISSING_AUTH_TOKEN';
  static const String invalidAuthToken = 'INVALID_AUTH_TOKEN';
  static const String unauthenticated = 'UNAUTHENTICATED';
  static const String userNotProvisioned = 'USER_NOT_PROVISIONED';
  static const String workspaceContextMissing = 'WORKSPACE_CONTEXT_MISSING';
  static const String tenantContextMissing = 'TENANT_CONTEXT_MISSING';
  static const String tenantNotResolved = 'TENANT_NOT_RESOLVED';

  // ── 403 — policy denied ─────────────────────────────────────────────────
  static const String userSuspended = 'USER_SUSPENDED';
  static const String userInactive = 'USER_INACTIVE';
  static const String userPendingActivation = 'USER_PENDING_ACTIVATION';
  static const String membershipInactive = 'MEMBERSHIP_INACTIVE';
  static const String membershipNotFoundOrInactive =
      'MEMBERSHIP_NOT_FOUND_OR_INACTIVE';
  static const String workspaceNotActive = 'WORKSPACE_NOT_ACTIVE';
  static const String capabilityNotGranted = 'CAPABILITY_NOT_GRANTED';
  static const String permissionEvaluationFailed =
      'PERMISSION_EVALUATION_FAILED';

  // ── 429 — rate limit ────────────────────────────────────────────────────
  static const String circuitReadRateLimit = 'CIRCUIT_READ_RATE_LIMIT';

  // ── Conjuntos útiles para el interceptor ────────────────────────────────

  /// Familia recuperable vía bootstrap (primer intento). Todos son 401 por
  /// contrato, o 403 MEMBERSHIP_NOT_FOUND_OR_INACTIVE como caso especial.
  static const Set<String> bootstrapRecoverable = {
    userNotProvisioned,
    workspaceContextMissing,
    membershipNotFoundOrInactive,
  };

  /// Familia bloqueante por policy. Nunca bootstrap ni retry.
  static const Set<String> blockingUserState = {
    userSuspended,
    userInactive,
    userPendingActivation,
    membershipInactive,
  };
}
