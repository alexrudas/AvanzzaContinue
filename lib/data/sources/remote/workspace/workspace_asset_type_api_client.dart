// ============================================================================
// lib/data/sources/remote/workspace/workspace_asset_type_api_client.dart
// WORKSPACE ASSET TYPE API CLIENT — HTTP client (Avanzza Core API)
//
// QUÉ HACE:
// - Cliente Dio contra `GET /v1/core-common/workspaces/me/asset-types`.
// - Adjunta `Authorization: Bearer <firebase-id-token>`.
// - Traduce `DioException` a `remote_exceptions.dart` canónicas.
//
// QUÉ NO HACE:
// - NO cachea: backend asume cache server-side si añade en el futuro.
// - NO acepta parámetros (workspace viene del JWT en backend).
// - NO maneja paginación (la lista es pequeña por design — un workspace
//   típico opera 1-3 verticales).
//
// PRINCIPIOS:
// - Mismo patrón que `asset_actor_link_api_client.dart` y
//   `specialty_catalog_api_client.dart`. Cero duplicación de patrón.
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-26): reemplazo del dropdown hardcodeado en provider form.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/entities/workspace/workspace_asset_type_entity.dart';
import '../../../../domain/errors/remote_exceptions.dart';
import '../../../models/workspace/workspace_asset_type_dto.dart';

typedef GetIdToken = Future<String?> Function();

class WorkspaceAssetTypeApiClient {
  final Dio _dio;
  final GetIdToken _getIdToken;

  static const String _path = '/v1/core-common/workspaces/me/asset-types';

  WorkspaceAssetTypeApiClient({
    required Dio dio,
    required GetIdToken getIdToken,
  })  : _dio = dio,
        _getIdToken = getIdToken;

  Future<List<WorkspaceAssetTypeEntity>> listActive({
    CancelToken? cancelToken,
  }) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>(
        _path,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! List) {
      throw ServerException(
        res.statusCode ?? 0,
        'GET $_path: respuesta inesperada ${data.runtimeType}, esperado List.',
      );
    }
    try {
      return data
          .whereType<Map<String, dynamic>>()
          .map(WorkspaceAssetTypeDto.fromJson)
          .map((d) => d.toEntity())
          .toList(growable: false);
    } on FormatException catch (e) {
      throw ServerException(res.statusCode ?? 0, 'Body inválido: ${e.message}');
    }
  }

  Future<Options> _authOptions() async {
    final token = await _getIdToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException(
        'No active Firebase session (no ID token).',
      );
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
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
