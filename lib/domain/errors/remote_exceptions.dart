// ============================================================================
// lib/domain/errors/remote_exceptions.dart
// REMOTE EXCEPTIONS — Contrato de fallos de un datasource remoto
// ============================================================================
// QUÉ HACE:
//   - Define la jerarquía canónica de excepciones que cualquier datasource
//     remoto (HTTP/NestJS/etc.) puede propagar al repository y,
//     eventualmente, a la capa de presentación para decidir UX.
//   - Vive en `domain/errors/` porque es contrato del dominio, NO detalle
//     de implementación de data: controllers y use cases tienen derecho a
//     distinguir Network / Unauthorized / BadRequest(code) / Server sin
//     importar paquetes de `data/` (prohibido por Clean Architecture).
//
// QUÉ NO HACE:
//   - No captura ni reintenta. La traducción HTTP → excepción vive en el
//     datasource; el repo decide si reintenta; el controller decide UX.
//   - No registra logs persistentes.
//
// ENTERPRISE NOTES:
//   - `BadRequestException.code` preserva el campo `code` canónico del body
//     JSON cuando el backend lo emite (p. ej. `ACTOR_REF_UNKNOWN`,
//     `CONFLICTING_VENDOR_REFS`, `TOO_MANY_TARGETS`). Permite a la UI
//     mapear a mensajes humanos específicos sin parsear `message`.
//   - Mantenemos `data/sources/remote/core_common/nestjs_exceptions.dart`
//     como re-export para compat retroactiva con datasources existentes;
//     no hay duplicación de tipos.
//
// See docs/adr/0001-actor-canon.md §6 (tabla de errores del contrato).
// ============================================================================

/// Base de toda excepción remota del dominio.
abstract class CoreCommonRemoteException implements Exception {
  final String message;
  const CoreCommonRemoteException(this.message);

  @override
  String toString() => '$runtimeType($message)';
}

/// Fallo sin respuesta HTTP: timeout, DNS, conexión caída.
class NetworkException extends CoreCommonRemoteException {
  const NetworkException(super.message);
}

/// 401. Token ausente, inválido, expirado o sin claim activeOrgId.
///
/// SEMÁNTICA CANÓNICA: solo 401 (autenticación faltante o inválida). Para
/// 403 (autenticado pero sin permiso) usa [ForbiddenException].
///
/// COMPAT: callers legacy (RelationshipApiClient, etc.) aún mapean 401+403
/// a este tipo por inercia histórica. Migración a la separación 401/403 se
/// hace por API client conforme se tocan; no se rompe behavior existente
/// hasta que cada caller migre.
class UnauthorizedException extends CoreCommonRemoteException {
  const UnauthorizedException(super.message);
}

/// 403. Autenticado correctamente pero sin permiso para el recurso/acción.
///
/// Distinta de [UnauthorizedException] porque la UX correcta es diferente:
///   - 401 ⇒ sesión inválida → forzar re-login.
///   - 403 ⇒ falta capability → mostrar estado "sin permiso" en la sección
///     afectada SIN cerrar sesión, y permitir que otras secciones del
///     mismo screen sigan funcionando (ej. /network OK pero /team 403).
///
/// Esta separación es obligatoria para Mi Red Operativa: /v1/network y
/// /v1/team tienen capabilities distintas (`network.read` y `team.read`)
/// y pueden fallar de forma independiente.
class ForbiddenException extends CoreCommonRemoteException {
  const ForbiddenException(super.message);
}

/// 4xx cliente (excluyendo 401/403). Body malformado, estado inválido, etc.
///
/// [code] preserva el campo `code` canónico del body JSON cuando el backend
/// lo emite (p. ej. `ACTOR_REF_UNKNOWN`, `CONFLICTING_VENDOR_REFS`,
/// `VENDOR_CONTACT_IDS_DEPRECATED`). Null si el body no trae `code`.
class BadRequestException extends CoreCommonRemoteException {
  final int statusCode;
  final String? code;
  const BadRequestException(this.statusCode, String message, {this.code})
      : super(message);

  @override
  String toString() =>
      'BadRequestException($statusCode${code != null ? ", code=$code" : ""}, $message)';
}

/// 5xx. El backend falló; el caller puede decidir si considerar retry futuro.
class ServerException extends CoreCommonRemoteException {
  final int statusCode;
  const ServerException(this.statusCode, String message) : super(message);

  @override
  String toString() => 'ServerException($statusCode, $message)';
}

/// Cancelación explícita por el caller (p. ej. el usuario disparó otro fetch
/// con un filtro distinto y el anterior fue abortado vía CancelToken).
///
/// Distinguible de [NetworkException] para que la UI NO muestre un mensaje
/// de error: es flujo esperado, no un fallo. Los controllers la ignoran
/// silenciosamente y dejan que el fetch nuevo actualice el estado.
class RequestCancelledException extends CoreCommonRemoteException {
  const RequestCancelledException(super.message);
}

// ═════════════════════════════════════════════════════════════════════════════
// PROVIDER CANONICAL — excepciones tipadas (Hito 1)
// ═════════════════════════════════════════════════════════════════════════════
//
// Estas excepciones existen porque el flujo `LocalContact → POST /v1/providers
// → PUT /:id/specialties` necesita ramificar UX de forma específica para
// algunos códigos canónicos del backend (especialmente AMBIGUOUS, que requiere
// snackbar técnico + log estructurado con candidates para soporte). Para el
// resto de códigos basta con `BadRequestException(code: '...')`.

/// 404 con `code='LOCAL_REF_NOT_FOUND'`. El `localId` no tiene attestation
/// previa en el workspace. El cliente debe disparar un probe via
/// `MatchCandidateNestJsDataSource.probe(...)` antes del POST.
///
/// Distinguible de `BadRequestException` genérico para que el caller decida
/// si reintentar automáticamente tras probe (no recomendado por defecto)
/// o pedir al usuario reintentar manualmente.
class LocalRefNotFoundException extends CoreCommonRemoteException {
  const LocalRefNotFoundException(super.message);
}

/// 404 con `code='PROVIDER_PROFILE_NOT_FOUND'`. El `providerProfileId` no
/// existe (o fue eliminado tras una sesión anterior).
///
/// El controller del form usa este caso como señal: si el `linkedProviderProfileId`
/// cacheado en `LocalContactEntity` apunta a un profile que ya no existe,
/// limpia el cache y cae al CREATE flow del save (POST + PUT).
class ProviderProfileNotFoundException extends CoreCommonRemoteException {
  const ProviderProfileNotFoundException(super.message);
}

/// 404 con `code='WORKSPACE_NOT_FOUND'`. El `activeOrgId` del JWT no tiene
/// Workspace en backend (bootstrap pendiente para ese org).
class WorkspaceNotFoundException extends CoreCommonRemoteException {
  const WorkspaceNotFoundException(super.message);
}

/// 409 con `code='AMBIGUOUS_PLATFORM_ACTOR_MATCH'`. Las probes coinciden
/// con >1 `PlatformActor` distintos en el catálogo verificado.
///
/// El backend rechaza la creación automática — la elección es responsabilidad
/// humana. La UI debe:
///   1. Bloquear el flujo (no permitir el save).
///   2. Loguear con `candidates` para auditoría / soporte.
///   3. Hito 1.5+: ofrecer picker para que el usuario elija un candidato y
///      reintente con `source.kind=EXISTING_PLATFORM_ACTOR`.
///
/// En Hito 1 hoy el flujo del form solo bloquea con snackbar técnico. El
/// picker llega en Hito 1.5.
class AmbiguousPlatformActorException extends CoreCommonRemoteException {
  /// Candidatos retornados por el backend en el body del 409.
  /// Forma: `[{ platformActorId, displayName, matchedKeys: [phoneE164|email|docId] }]`.
  final List<AmbiguousPlatformActorCandidate> candidates;

  const AmbiguousPlatformActorException(super.message, {required this.candidates});

  @override
  String toString() =>
      'AmbiguousPlatformActorException(${candidates.length} candidates, $message)';
}

/// Candidato individual del 409 AMBIGUOUS_PLATFORM_ACTOR_MATCH.
class AmbiguousPlatformActorCandidate {
  final String platformActorId;
  final String displayName;

  /// Wire names de los `VerifiedKeyType` que matchearon
  /// (`'phoneE164' | 'email' | 'docId'`).
  final List<String> matchedKeys;

  const AmbiguousPlatformActorCandidate({
    required this.platformActorId,
    required this.displayName,
    required this.matchedKeys,
  });
}
