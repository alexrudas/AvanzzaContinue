// ============================================================================
// lib/data/sources/remote/catalog/specialty_catalog_api_client.dart
// SPECIALTY CATALOG API CLIENT — HTTP client (Avanzza Core API)
//
// QUÉ HACE:
// - Cliente Dio contra `GET /v1/catalog/specialties`.
// - Adjunta `Authorization: Bearer <firebase-id-token>`.
// - Traduce `DioException` a la jerarquía canónica de `remote_exceptions.dart`
//   (Network / Unauthorized / BadRequest(code) / Server).
// - Preserva `code` del body JSON (`INVALID_ASSET_TYPE`,
//   `INVALID_SPECIALTY_TYPE`) para que la UI razone por código, no por mensaje.
//
// QUÉ NO HACE:
// - NO cachea: backend ya cachea 60s.
// - NO normaliza `assetType` ni `type`: el backend hace trim/uppercase.
// - NO reintenta: el repo/UI deciden la estrategia.
//
// PRINCIPIOS:
// - Mismo patrón que el resto de ApiClients de core_common
//   (`asset_actor_link_api_client.dart`, `relationship_api_client.dart`).
// - Inyección de `getIdToken` para mantener la clase testeable sin acoplarse
//   a `FirebaseAuth.instance` directamente.
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-25).
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/errors/remote_exceptions.dart';
import '../../../models/catalog/specialty_dto.dart';

typedef GetIdToken = Future<String?> Function();

class SpecialtyCatalogApiClient {
  final Dio _dio;
  final GetIdToken _getIdToken;

  static const String _path = '/v1/catalog/specialties';

  SpecialtyCatalogApiClient({
    required Dio dio,
    required GetIdToken getIdToken,
  })  : _dio = dio,
        _getIdToken = getIdToken;

  /// `GET /v1/catalog/specialties?assetType=...&type=...`
  ///
  /// Devuelve el DTO completo del response. El mapeo a dominio lo hace el
  /// repository.
  ///
  /// [cancelToken] opcional: si se cancela, lanza [DioException] que se
  /// traduce a [RequestCancelledException] vía [_mapDioError].
  Future<SpecialtyCatalogResultDto> list({
    required String assetType,
    String? type,
    CancelToken? cancelToken,
  }) async {
    final options = await _authOptions();
    final query = <String, dynamic>{
      'assetType': assetType,
      if (type != null) 'type': type,
    };

    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>(
        _path,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(
        res.statusCode ?? 0,
        'GET $_path: respuesta inesperada ${data.runtimeType}',
      );
    }
    try {
      return SpecialtyCatalogResultDto.fromJson(data);
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
    // Cancelación explícita (CancelToken.cancel): el caller la disparó al
    // recibir un nuevo input del usuario; NO es un error de red ni 4xx.
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
