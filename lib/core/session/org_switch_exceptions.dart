// ============================================================================
// lib/core/session/org_switch_exceptions.dart
// ORG SWITCH EXCEPTIONS — Tipos de error del flujo de cambio de organización.
//
// QUÉ HACE:
// - Define [OrgContextSwitchingException]: lanzada por el interceptor cuando
//   un request org-scoped es bloqueado. Distinguible de errores reales de red
//   para que la UI no muestre mensajes de error engañosos.
// - Define [SwitchOrganizationFailureReason]: enum de razones explícitas de fallo.
// - Define [SwitchOrganizationException]: error del use case con razón tipada.
//
// QUÉ NO HACE:
// - No determina lógica de retry ni manejo de UI.
// - No interactúa con Dio ni Firebase directamente.
//
// PRINCIPIOS:
// - OrgContextSwitchingException es distinguible de DioException de red/servidor.
//   La UI debe tratarla como "operación temporalmente no disponible", no como error.
// - SwitchOrganizationException porta la razón del fallo para logging y UX granular.
// ============================================================================

/// Excepción lanzada por [OrgSwitchInterceptor] cuando una request org-scoped
/// es rechazada por estado [OrgSwitchState.switching] o escritura durante
/// [OrgSwitchState.validating].
///
/// NO es un error de red ni de servidor. La UI debe tratarla como
/// "contexto no disponible temporalmente" y NO mostrar mensaje de error de red.
class OrgContextSwitchingException implements Exception {
  final String reason;

  const OrgContextSwitchingException([
    this.reason = 'Org context switch in progress — request blocked',
  ]);

  @override
  String toString() => 'OrgContextSwitchingException: $reason';
}

/// Razones de fallo del switch de organización activa.
enum SwitchOrganizationFailureReason {
  /// No hay usuario autenticado al intentar el switch.
  notAuthenticated,

  /// El backend devolvió error al procesar el switch.
  backendError,

  /// El refresh del JWT token falló después de que el backend respondió OK.
  tokenRefreshFailed,

  /// Los claims frescos no reflejan el orgId esperado después de reintentos.
  /// Indica un problema de propagación de custom claims en Firebase Auth.
  claimsPropagationFailed,

  /// La membresía del nuevo orgId no existe en el repositorio local.
  /// El backend confirmó el switch pero los datos locales están inconsistentes.
  membershipNotFound,

  /// El backend confirmó el switch y los claims JWT son correctos,
  /// pero la persistencia local (Isar/Firestore) falló al aplicar el nuevo contexto.
  /// El estado vuelve a [OrgSwitchState.idle] — no a failed — porque los claims son válidos.
  /// La próxima startup validation detectará y reparará la divergencia Isar/claims.
  persistenceFailed,

  /// Error no clasificado durante el flujo de switch.
  unknown,
}

/// Excepción lanzada por [SwitchActiveOrganizationUC] con razón explícita.
///
/// Cuando esta excepción es lanzada, el contexto previo queda intacto y
/// [OrgSwitchStateHolder.state] queda en [OrgSwitchState.failed].
class SwitchOrganizationException implements Exception {
  final String message;
  final SwitchOrganizationFailureReason reason;

  const SwitchOrganizationException(this.message, this.reason);

  @override
  String toString() =>
      'SwitchOrganizationException(${reason.name}): $message';
}
