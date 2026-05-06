// ============================================================================
// lib/application/services/access/access_session_state.dart
// ACCESS SESSION STATE — holder de outcome + mutex del subsistema de acceso.
// ============================================================================
// QUÉ HACE:
// - Mantiene el resultado discriminado del último bootstrap de la sesión
//   (`BootstrapOutcome`) y el mutex single-flight (`bootstrapInFlight`).
// - Expone getters derivados para que `AccessInterceptor` y `AccessGateway`
//   decidan si hay que:
//     · intentar bootstrap (notAttempted),
//     · reintentar bootstrap cuando aparezca orgId (failedMissingOrgId),
//     · considerar terminal la sesión (failedBlockingPolicy / failedOther),
//     · considerar resuelto (succeeded).
// - Expone `resetForLogout()` / `resetForWorkspaceSwitch()` como únicas
//   operaciones legítimas de reinicio (invariante §7.1).
//
// QUÉ NO HACE:
// - No reintenta ni llama HTTP. Es un holder puro.
// - No expone `bootstrapOutcome` reactivo — el interceptor lo consulta de
//   forma síncrona en cada onError.
//
// PRINCIPIOS:
// - Fuente única de verdad por proceso. Un solo singleton inyectado vía DI
//   al interceptor y al gateway.
// - Outcome DISCRIMINADO: el fallo por `ACTIVE_ORG_ID_MISSING` es recuperable
//   (aparece orgId → nuevo intento), mientras que un policy blocker
//   (USER_SUSPENDED, etc.) es terminal. Tratarlos igual (como hacía el flag
//   boolean `bootstrapAttempted` anterior) cerraba la puerta a onboarding:
//   un usuario recién autenticado sin activeContext quemaba el flag y
//   quedaba bloqueado hasta logout.
// - Reset SOLO en logout o workspace switch; el contrato lo exige.
//
// ENTERPRISE NOTES:
// - Fuente: "Contrato de integración — Flutter ↔ Core API Access" §7 + §4.
// - El counter de retry por request se mantiene en `Options.extra` de Dio,
//   no aquí — es per-request, no per-session.
// - `bootstrapAttempted` se conserva como getter derivado por compat /
//   telemetría, pero las decisiones ya no deben basarse en él. Usar
//   `bootstrapSucceeded` / `bootstrapTerminal` / `bootstrapRecoverableMissingOrg`.
// ============================================================================

import 'package:flutter/foundation.dart';

/// Resultado discriminado del último intento de bootstrap en la sesión.
///
/// Reemplaza al flag booleano `bootstrapAttempted` que trataba igual a un
/// fallo recuperable (falta orgId) y a un terminal (USER_SUSPENDED), cerrando
/// la puerta a reintentos legítimos tras onboarding.
enum BootstrapOutcome {
  /// Aún no se intentó bootstrap en esta sesión. Puede intentarse cuando
  /// haya orgId local resuelto (el interceptor/gateway hace pre-check).
  notAttempted,

  /// Bootstrap completó 200 OK. El user está provisionado. No hay razón
  /// para volver a llamarlo en esta sesión.
  succeeded,

  /// Bootstrap falló con 400 `ACTIVE_ORG_ID_MISSING`: no hay orgId ni en
  /// claim ni en body/local. ES RECUPERABLE: cuando el usuario termine
  /// onboarding, cambie workspace, o el SessionContext hidrate un orgId,
  /// el próximo trigger puede reintentar bootstrap con éxito.
  failedMissingOrgId,

  /// Bootstrap falló con un policy blocker (USER_SUSPENDED, USER_INACTIVE,
  /// USER_PENDING_ACTIVATION, MEMBERSHIP_INACTIVE). TERMINAL para esta
  /// sesión; el usuario debe contactar soporte. Sólo logout/relogin limpia.
  failedBlockingPolicy,

  /// Bootstrap falló por otra causa (red, 5xx, shape inesperado,
  /// inconsistencia). TERMINAL por esta sesión para evitar loops.
  failedOther,
}

class AccessSessionState {
  /// Resultado del último intento de bootstrap en esta sesión.
  BootstrapOutcome _bootstrapOutcome = BootstrapOutcome.notAttempted;

  /// Mutex single-flight: si hay un bootstrap en vuelo, los requests
  /// paralelos que también observan un 401 recuperable deben esperar a
  /// este Future en lugar de disparar otro bootstrap.
  /// Invariante §7.4: bootstrap no recursivo + single-flight.
  Future<void>? _bootstrapInFlight;

  // ── Getters discriminados ─────────────────────────────────────────────────

  BootstrapOutcome get bootstrapOutcome => _bootstrapOutcome;

  /// `true` si ya se ejecutó bootstrap al menos una vez (éxito o fracaso).
  /// Mantenido sólo para observabilidad / telemetría. Las DECISIONES de
  /// retry deben consultar `bootstrapSucceeded`, `bootstrapTerminal` o
  /// `bootstrapRecoverableMissingOrg` — nunca este flag boolean.
  bool get bootstrapAttempted =>
      _bootstrapOutcome != BootstrapOutcome.notAttempted;

  /// `true` si bootstrap completó con 200 en esta sesión.
  bool get bootstrapSucceeded =>
      _bootstrapOutcome == BootstrapOutcome.succeeded;

  /// `true` si bootstrap falló con un estado terminal (policy blocker u otro
  /// error no recuperable). No hay retry posible hasta logout.
  bool get bootstrapTerminal =>
      _bootstrapOutcome == BootstrapOutcome.failedBlockingPolicy ||
      _bootstrapOutcome == BootstrapOutcome.failedOther;

  /// `true` si bootstrap falló por falta de orgId local. Es **recuperable**:
  /// al siguiente evento que publique un orgId (fin de onboarding, switch
  /// de workspace), el flujo proactivo/reactivo puede volver a intentar.
  bool get bootstrapRecoverableMissingOrg =>
      _bootstrapOutcome == BootstrapOutcome.failedMissingOrgId;

  Future<void>? get bootstrapInFlight => _bootstrapInFlight;

  // ── Setters de outcome ────────────────────────────────────────────────────

  /// Marca bootstrap como exitoso (200 OK). Llamar tras `requiresTokenRefresh`.
  void markBootstrapSucceeded() {
    _bootstrapOutcome = BootstrapOutcome.succeeded;
    _log('outcome = succeeded');
  }

  /// Marca bootstrap fallido por falta de orgId — RECUPERABLE. Usar cuando:
  ///   · El pre-check local detecta que no hay orgId y no vale la pena
  ///     golpear al backend.
  ///   · El backend respondió 400 `ACTIVE_ORG_ID_MISSING`.
  /// NO cierra la puerta a reintentos: cuando el orgId aparezca (p. ej. al
  /// completar onboarding) el próximo trigger puede volver a intentar.
  void markBootstrapFailedMissingOrgId() {
    _bootstrapOutcome = BootstrapOutcome.failedMissingOrgId;
    _log('outcome = failedMissingOrgId (recoverable when orgId arrives)');
  }

  /// Marca bootstrap fallido por policy blocker — TERMINAL en esta sesión.
  /// Usar para USER_SUSPENDED / USER_INACTIVE / USER_PENDING_ACTIVATION /
  /// MEMBERSHIP_INACTIVE y equivalentes (cualquier 401/403 que el backend
  /// emita durante bootstrap — el usuario no puede resolverlo en-app).
  void markBootstrapFailedBlockingPolicy() {
    _bootstrapOutcome = BootstrapOutcome.failedBlockingPolicy;
    _log('outcome = failedBlockingPolicy (terminal)');
  }

  /// Marca bootstrap fallido por otra razón — TERMINAL en esta sesión para
  /// evitar loops. Usar para 5xx, red caída persistente, shape inválido.
  void markBootstrapFailedOther() {
    _bootstrapOutcome = BootstrapOutcome.failedOther;
    _log('outcome = failedOther (terminal)');
  }

  // ── Mutex single-flight ───────────────────────────────────────────────────

  /// Registra el Future en vuelo. El caller DEBE limpiarlo vía
  /// `clearBootstrapInFlight()` en `whenComplete` para mantener el mutex
  /// consistente.
  void setBootstrapInFlight(Future<void> future) {
    _bootstrapInFlight = future;
  }

  /// Libera el mutex. Invocar en `whenComplete`.
  void clearBootstrapInFlight() {
    _bootstrapInFlight = null;
  }

  // ── Reset ─────────────────────────────────────────────────────────────────

  /// Reset obligatorio al hacer logout. Después de esto, el próximo 401
  /// recuperable puede disparar bootstrap de nuevo.
  void resetForLogout() {
    _bootstrapOutcome = BootstrapOutcome.notAttempted;
    _bootstrapInFlight = null;
    _log('session state reset (logout)');
  }

  /// Reset al cambiar de workspace. El nuevo workspace puede requerir un
  /// bootstrap distinto; el outcome no debe persistir entre workspaces.
  void resetForWorkspaceSwitch() {
    _bootstrapOutcome = BootstrapOutcome.notAttempted;
    _bootstrapInFlight = null;
    _log('session state reset (workspace switch)');
  }

  void _log(String msg) {
    if (kDebugMode) debugPrint('[ACCESS] $msg');
  }
}
