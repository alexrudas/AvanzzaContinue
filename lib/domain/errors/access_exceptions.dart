// ============================================================================
// lib/domain/errors/access_exceptions.dart
// ACCESS EXCEPTIONS — excepciones tipadas del subsistema de acceso.
// ============================================================================
// QUÉ HACE:
// - Define excepciones específicas que el `AccessInterceptor` y el
//   `AccessGateway` pueden propagar a la capa de presentación para decidir UX
//   sin inspeccionar HTTP/Dio.
// - Complementa `domain/errors/remote_exceptions.dart`: aquellas siguen
//   existiendo para errores genéricos; estas son estados terminales del
//   subsistema de acceso.
//
// QUÉ NO HACE:
// - No captura ni reintenta.
// - No imprime banners. La UI decide el mensaje humano.
//
// PRINCIPIOS:
// - Una excepción = un estado UX distinto. No se agrupan estados diferentes
//   bajo la misma clase.
// - Cada excepción preserva el `code` canónico del backend para telemetría
//   precisa.
//
// ENTERPRISE NOTES:
// - Fuente: "Contrato de integración — Flutter ↔ Core API Access" §6 + §9.4.
// - Estas son TERMINALES (el interceptor ya agotó retries/bootstrap): su
//   recepción en presentation significa "no puedo avanzar automáticamente;
//   UI decide".
// ============================================================================

import '../entities/access/access_enums.dart';
import 'remote_exceptions.dart';

/// Base común del subsistema de acceso.
abstract class AccessException extends CoreCommonRemoteException {
  /// Código canónico del backend (`body.code`). Null si la excepción es
  /// sintetizada localmente (p. ej. loop detectado).
  final String? code;

  const AccessException(super.message, {this.code});

  @override
  String toString() =>
      '$runtimeType(${code != null ? "code=$code, " : ""}$message)';
}

/// Estado bloqueante por policy — la UI DEBE mostrar banner terminal y
/// NUNCA reintentar. Cubre USER_SUSPENDED / USER_INACTIVE /
/// USER_PENDING_ACTIVATION / MEMBERSHIP_INACTIVE.
class AccessBlockedException extends AccessException {
  const AccessBlockedException(super.message, {super.code});
}

/// CAPABILITY_NOT_GRANTED — el caller no tiene el permiso requerido. UI
/// muestra "sin permiso" inline. NUNCA bootstrap.
class AccessCapabilityDeniedException extends AccessException {
  const AccessCapabilityDeniedException(super.message) : super(code: null);

  /// Pista semántica: la capability que faltó, si el backend la informó.
  /// Hoy Core API no la incluye en body; queda como futuro.
  const AccessCapabilityDeniedException.withCode(String backendCode, String message)
      : super(message, code: backendCode);
}

/// SELECT_WORKSPACE o WORKSPACE_NOT_ACTIVE — el cliente debe presentar el
/// workspace picker. UI NO debe navegar a rutas rotas si el picker aún no
/// existe; debe quedarse en estado "requiresWorkspaceSelection".
class AccessWorkspaceSelectionRequiredException extends AccessException {
  const AccessWorkspaceSelectionRequiredException(super.message, {super.code});
}

/// Bootstrap ya se intentó en esta sesión y el endpoint protegido sigue
/// devolviendo un error recuperable. Estado terminal: "auth inconsistent,
/// relogin". UI debe forzar logout.
class AccessBootstrapExhaustedException extends AccessException {
  const AccessBootstrapExhaustedException(super.message, {super.code});
}

/// Token refresh agotado (1 intento) y el backend sigue rechazando con
/// INVALID_AUTH_TOKEN. Estado terminal: forzar logout.
class AccessTokenRefreshExhaustedException extends AccessException {
  const AccessTokenRefreshExhaustedException(super.message)
      : super(code: AccessErrorCode.invalidAuthToken);
}

/// Estado recuperable: el cliente no tiene `orgId` local que pasar al
/// servidor (ni activeContext en sesión, ni membership hidratada). Se
/// adelanta antes de llamar a `/v1/auth/bootstrap` para evitar un
/// `400 ACTIVE_ORG_ID_MISSING` inútil y NO quema el flag de sesión:
/// cuando el usuario complete onboarding o seleccione workspace, el
/// próximo trigger reintentará bootstrap.
///
/// UX: "No hay organización activa para provisionar Core API. Completa
/// el onboarding o selecciona un workspace."
class AccessMissingActiveOrgException extends AccessException {
  const AccessMissingActiveOrgException([
    String message =
        'No hay organización activa para provisionar Core API. '
        'Completa el onboarding o selecciona un workspace.',
  ]) : super(message, code: AccessErrorCode.activeOrgIdMissing);
}

/// Rate limit (429) y retry post-Retry-After también falló. El caller debe
/// surface al usuario con reintento manual.
class AccessRateLimitedException extends AccessException {
  /// Segundos sugeridos por el header `Retry-After` (puede ser 1 si el
  /// servidor no lo incluyó).
  final int retryAfterSeconds;

  const AccessRateLimitedException({
    required this.retryAfterSeconds,
    required String message,
  }) : super(message, code: AccessErrorCode.circuitReadRateLimit);

  @override
  String toString() =>
      'AccessRateLimitedException(retryAfter=${retryAfterSeconds}s, $message)';
}
