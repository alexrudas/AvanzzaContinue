// ============================================================================
// lib/domain/repositories/access_repository.dart
// ACCESS REPOSITORY — contrato (interface) del subsistema de acceso.
// ============================================================================
// QUÉ HACE:
// - Declara el contrato que cualquier implementación de acceso (HTTP Dio,
//   fake, mock) debe cumplir.
// - Expone dos operaciones canónicas:
//     1. getContext()   → GET /v1/access/me/context
//     2. bootstrap(...) → POST /v1/auth/bootstrap
//
// QUÉ NO HACE:
// - No decide flujo. El `AccessGateway` interpreta `requiresAction` y decide
//   si hay que llamar bootstrap.
// - No reintenta. El `AccessInterceptor` maneja retries por request.
//
// PRINCIPIOS:
// - Repositorio = contrato. Sin detalles de transport.
// - Errores viajan vía excepciones (`AccessException` o
//   `CoreCommonRemoteException`), no vía `Result<T>` para mantener simetría
//   con el resto de repositorios HTTP del proyecto.
//
// ENTERPRISE NOTES:
// - Fuente: "Contrato de integración — Flutter ↔ Core API Access" §1.1 + §1.2.
// - `bootstrap()` es idempotente: llamadas múltiples con los mismos inputs
//   retornan los mismos ids.
// ============================================================================

import '../entities/access/access_bootstrap_result.dart';
import '../entities/access/access_context.dart';

abstract class AccessRepository {
  /// Retorna el snapshot canónico del estado de acceso del caller.
  ///
  /// Nunca lanza 403 (ver contrato §1.2). Puede lanzar:
  /// - `UnauthorizedException` (401 MISSING/INVALID_AUTH_TOKEN).
  /// - `NetworkException` / `ServerException` (fallos genéricos).
  Future<AccessContext> getContext();

  /// Provisiona/repara la tupla (user, workspace, membership) para el caller
  /// autenticado. Idempotente.
  ///
  /// Reglas de entrada:
  /// - En producción, si el token trae claim `activeContext.organizationId`,
  ///   omitir `orgId`.
  /// - En dev/piloto, si el claim aún no se emite, pasar `orgId` explícito.
  /// - `workspaceName` es opcional; solo aplica en la primera creación.
  ///
  /// Puede lanzar:
  /// - `BadRequestException(code=ACTIVE_ORG_ID_MISSING)` si ni claim ni body.
  /// - `AccessBlockedException` (USER_SUSPENDED/INACTIVE/PENDING, MEMBERSHIP_INACTIVE).
  /// - `UnauthorizedException` (401 token inválido).
  Future<AccessBootstrapResult> bootstrap({
    String? orgId,
    String? workspaceName,
  });
}
