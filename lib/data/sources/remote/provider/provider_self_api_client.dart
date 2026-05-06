// ============================================================================
// lib/data/sources/remote/provider/provider_self_api_client.dart
// PROVIDER SELF API CLIENT — wire layer para MF1.
//
// QUÉ HACE:
//   Llama a 2 endpoints del Core API:
//     - POST /v1/providers/bootstrap     → crea/reactiva ProviderProfile SELF.
//     - GET  /v1/providers/me            → vista agregada self.
//   Devuelve entities domain (no DTOs internos del wire).
//
// QUÉ NO HACE:
//   - NO consume agent invitations / claim / local provider (otras MF).
//   - NO cachea ni persiste local. Caching es M2.
//
// REUSE:
//   - `coreDio` con `_CoreBearerInterceptor` + `AccessInterceptor`
//     ya wired en `container.dart`. El cliente NO conoce la URL base.
//   - Patrón de `_authOptions()` espejado de `ProviderCanonicalApiClient`
//     para fail-fast cuando no hay sesión Firebase.
//
// ENTERPRISE NOTES:
//   El backend espera body camelCase exacto. Las claves opcionales se
//   omiten cuando son null para que el ValidationPipe del backend
//   (whitelist=true, forbidNonWhitelisted) no rechace.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/entities/provider/bootstrap_provider_result_entity.dart';
import '../../../../domain/entities/provider/provider_me_entity.dart';
import '../../../../domain/errors/remote_exceptions.dart';

typedef GetIdToken = Future<String?> Function();

class ProviderSelfApiClient {
  final Dio _dio;
  final GetIdToken _getIdToken;

  const ProviderSelfApiClient({
    required Dio dio,
    required GetIdToken getIdToken,
  })  : _dio = dio,
        _getIdToken = getIdToken;

  /// POST /v1/providers/bootstrap.
  ///
  /// Body: `{ name, phone?, specialtyIds[], assetTypeIds? }`.
  /// Response: `{ providerProfileId, workspaceId, created }`.
  ///
  /// Errores tipados:
  /// - `WorkspaceNotFoundException` (404 WORKSPACE_NOT_FOUND).
  /// - `BadRequestException(code='PROVIDER_ALREADY_BOOTSTRAPPED', 409)`
  /// - `BadRequestException(code='INVALID_SPECIALTY_IDS' | 'EMPTY_SPECIALTY_LIST'
  ///    | 'SPECIALTY_ASSET_TYPE_INCOMPATIBLE' | 'INVALID_ASSET_TYPE_IDS')`.
  /// - `UnauthorizedException` (401/403).
  /// - `ServerException` / `NetworkException` / `RequestCancelledException`.
  Future<BootstrapProviderResultEntity> bootstrap({
    required String name,
    String? phone,
    required List<String> specialtyIds,
    List<String>? assetTypeIds,
  }) async {
    final options = await _authOptions();
    final body = <String, dynamic>{
      'name': name,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      'specialtyIds': specialtyIds,
      if (assetTypeIds != null && assetTypeIds.isNotEmpty)
        'assetTypeIds': assetTypeIds,
    };

    try {
      final res = await _dio.post<dynamic>(
        '/v1/providers/bootstrap',
        data: body,
        options: options,
      );
      return _parseBootstrap(res);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// GET /v1/providers/me.
  ///
  /// Devuelve `ProviderMeEntity` con `isProvider=false` cuando el user
  /// aún no es proveedor en el workspace activo (NO lanza).
  ///
  /// Errores tipados: `WorkspaceNotFoundException` (404),
  /// `UnauthorizedException` (401/403), `ServerException` / `NetworkException`.
  Future<ProviderMeEntity> me() async {
    final options = await _authOptions();
    try {
      final res = await _dio.get<dynamic>(
        '/v1/providers/me',
        options: options,
      );
      return _parseMe(res);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // ─── Helpers privados ──────────────────────────────────────────────────

  /// Fail-fast si no hay sesión Firebase válida. Defensivo: el
  /// `_CoreBearerInterceptor` también inyecta, pero acá lanzamos antes
  /// de pegarle al backend para devolver una excepción tipada al caller.
  Future<Options> _authOptions() async {
    final token = await _getIdToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException(
        'No active Firebase session (no ID token).',
      );
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  BootstrapProviderResultEntity _parseBootstrap(Response<dynamic> res) {
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(
        res.statusCode ?? 0,
        'Respuesta inesperada ${data.runtimeType}',
      );
    }
    try {
      return BootstrapProviderResultEntity.fromJson(data);
    } on FormatException catch (e) {
      throw ServerException(res.statusCode ?? 0, 'Body inválido: ${e.message}');
    } on TypeError catch (e) {
      throw ServerException(res.statusCode ?? 0, 'Body inválido: $e');
    }
  }

  ProviderMeEntity _parseMe(Response<dynamic> res) {
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(
        res.statusCode ?? 0,
        'Respuesta inesperada ${data.runtimeType}',
      );
    }
    try {
      return ProviderMeEntity.fromJson(data);
    } on FormatException catch (e) {
      throw ServerException(res.statusCode ?? 0, 'Body inválido: ${e.message}');
    } on TypeError catch (e) {
      throw ServerException(res.statusCode ?? 0, 'Body inválido: $e');
    }
  }

  /// Mapea DioException → jerarquía tipada de `remote_exceptions.dart`.
  /// Espejo del patrón en `ProviderCanonicalApiClient._mapDioError`.
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

    // ── Tipados específicos MF1 ──
    if (status == 404 && code == 'WORKSPACE_NOT_FOUND') {
      return WorkspaceNotFoundException(msg);
    }

    // ── Mapeo genérico ──
    if (status == 401 || status == 403) return UnauthorizedException(msg);
    if (status >= 500) return ServerException(status, msg);
    return BadRequestException(status, msg, code: code);
  }
}
