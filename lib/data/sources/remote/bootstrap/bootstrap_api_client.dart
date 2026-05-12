// ============================================================================
// lib/data/sources/remote/bootstrap/bootstrap_api_client.dart
// BOOTSTRAP API CLIENT — wire layer del endpoint unificado.
//
// QUÉ HACE:
//   POST /v1/auth/bootstrap → orquesta create/find User + Workspace + Membership
//   + (opcional) ProviderProfile en una sola llamada idempotente. Usa el
//   `coreDio` (con `_CoreBearerInterceptor` que inyecta Authorization
//   Bearer firebase-id-token).
//
// QUÉ NO HACE:
//   - NO retries: el caller (`BootstrapSyncController`) maneja el state
//     machine + backoff.
//   - NO cachea: el contrato es idempotente server-side; reintentar es OK.
//
// ENTERPRISE NOTES:
//   - El endpoint NO requiere user pre-provisionado en Core API; usa
//     FirebaseTokenOnlyGuard. Es la primera escritura tras OTP.
//   - Idempotencia: mismo authUid → mismo (userId, workspaceId, orgId).
//     El campo `status` ('CREATED'|'EXISTING') es solo telemetría.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/errors/remote_exceptions.dart';
import 'unified_bootstrap_dtos.dart';

class BootstrapApiClient {
  final Dio _dio;

  const BootstrapApiClient({required Dio dio}) : _dio = dio;

  /// Ejecuta el bootstrap unificado.
  ///
  /// Errores tipados:
  /// - `UnauthorizedException` (401/403) — token Firebase ausente o inválido.
  /// - `BadRequestException` con `code` (e.g. ACTIVE_ORG_ID_MISSING,
  ///   INVALID_SPECIALTY_IDS, USER_PENDING_ACTIVATION) — payload del backend.
  /// - `ServerException` (5xx) — backend caído.
  /// - `NetworkException` — sin respuesta HTTP (timeout/DNS).
  Future<UnifiedBootstrapResultDto> bootstrap(
    UnifiedBootstrapRequestDto request,
  ) async {
    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        '/v1/auth/bootstrap',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(
        res.statusCode ?? 0,
        'Respuesta inesperada ${data.runtimeType}',
      );
    }
    try {
      return UnifiedBootstrapResultDto.fromJson(data);
    } on FormatException catch (e) {
      throw ServerException(res.statusCode ?? 0, 'Body inválido: ${e.message}');
    } on TypeError catch (e) {
      throw ServerException(res.statusCode ?? 0, 'Body inválido: $e');
    }
  }

  CoreCommonRemoteException _mapDioError(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      return RequestCancelledException(
        e.message ?? 'Request cancelled by client',
      );
    }
    final status = e.response?.statusCode;
    if (status == null) {
      return NetworkException(
        'Network failure: ${e.type.name}'
        '${e.message != null ? ' — ${e.message}' : ''}',
      );
    }
    final body = e.response?.data;
    final msg = body is Map && body['message'] is String
        ? body['message'] as String
        : (body?.toString() ?? 'HTTP $status');
    final code = body is Map && body['code'] is String
        ? body['code'] as String
        : null;

    if (status == 401 || status == 403) return UnauthorizedException(msg);
    if (status >= 500) return ServerException(status, msg);
    return BadRequestException(status, msg, code: code);
  }
}
