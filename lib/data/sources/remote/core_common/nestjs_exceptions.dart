// ============================================================================
// lib/data/sources/remote/core_common/nestjs_exceptions.dart
// NESTJS EXCEPTIONS — Tipados para Core Common remote (F5 Hito 1)
// ============================================================================
// Qué hace:
//   - Jerarquía mínima de excepciones que un datasource remoto NestJS de
//     Core Common puede lanzar. Todas derivan de CoreCommonRemoteException.
//   - Permite al Repository decidir UX/retry a partir del tipo, no del
//     status HTTP crudo.
//
// Qué NO hace:
//   - No captura ni reintenta. El DS propaga; el Repository decide.
//   - No registra logs persistentes (eso vive aguas arriba).
//
// Guardrail F5 Hito 1 aplicado:
//   - NO hay try/catch silencioso en el DS: cualquier fallo se traduce a una
//     de estas excepciones y se propaga.
//   - NO se retorna null como fallback de error — null solo existe para
//     "recurso no encontrado" legítimo.
// ============================================================================

/// Base de toda excepción de Core Common remote NestJS.
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

/// 401 o 403. Token ausente, inválido, expirado o sin claim activeOrgId.
class UnauthorizedException extends CoreCommonRemoteException {
  const UnauthorizedException(super.message);
}

/// 4xx cliente (excluyendo 401/403). Body malformado, estado inválido, etc.
class BadRequestException extends CoreCommonRemoteException {
  final int statusCode;
  const BadRequestException(this.statusCode, String message) : super(message);

  @override
  String toString() => 'BadRequestException($statusCode, $message)';
}

/// 5xx. El backend falló; el caller puede decidir si considerar retry futuro.
class ServerException extends CoreCommonRemoteException {
  final int statusCode;
  const ServerException(this.statusCode, String message) : super(message);

  @override
  String toString() => 'ServerException($statusCode, $message)';
}
