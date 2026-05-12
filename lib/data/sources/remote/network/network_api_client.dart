// ============================================================================
// lib/data/sources/remote/network/network_api_client.dart
// NETWORK API CLIENT — HTTP cliente de Mi Red Operativa v1 (red externa)
// ============================================================================
// QUÉ HACE:
//   - Cliente Dio que consume los endpoints de Core API congelado para la
//     Red Operativa externa:
//       GET /v1/network                       → lista paginada con filtros.
//       GET /v1/network/categories/summary    → contador de externos activos.
//   - Adjunta Authorization: Bearer <firebase-id-token>.
//   - Traduce DioException a las excepciones tipadas del dominio:
//       · 401 → UnauthorizedException.
//       · 403 → ForbiddenException  (capability `network.read` ausente).
//       · 5xx → ServerException.
//       · 4xx (resto) → BadRequestException con `code` si el body lo trae.
//       · sin respuesta HTTP → NetworkException.
//   - Valida `schemaVersion` en cada respuesta vía
//     [NetworkPageEnvelope.fromJson]; si difiere lanza
//     [UnsupportedSchemaVersionException] (señal de app desactualizada).
//
// QUÉ NO HACE:
//   - No cachea: read path va directo al backend (Hito 5b sin Isar).
//   - No mantiene estado de paginación (cursor en memoria del controller).
//   - No reintenta: cualquier retry semántico lo decide repo/controller.
//   - No infiere permisos: el backend calcula `availableActions[].enabled`.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/errors/remote_exceptions.dart';
import '../../../models/network/network_actor_summary_dto.dart';
import '../../../models/network/network_category.dart';
import '../../../models/network/network_envelope.dart';

/// Callback que el caller provee para obtener el Firebase ID token.
/// Idéntica al typedef usado en otros API clients del proyecto.
typedef GetIdToken = Future<String?> Function();

/// HTTP cliente para los endpoints de /v1/network.
class NetworkApiClient {
  final Dio _dio;
  final GetIdToken _getIdToken;

  static const _basePath = '/v1/network';
  static const _summaryPath = '/v1/network/categories/summary';

  NetworkApiClient({
    required Dio dio,
    required GetIdToken getIdToken,
  })  : _dio = dio,
        _getIdToken = getIdToken;

  // --------------------------------------------------------------------------
  // GET /v1/network
  // --------------------------------------------------------------------------

  /// Lista paginada de actores de la Red Operativa externa.
  ///
  /// - [cursor] null = primera página.
  /// - El caller debe resetear cursor cuando cambian los filtros para evitar
  ///   inconsistencias con cursores generados con otros filtros.
  /// - [limit] sigue el contrato (1..100, default 50 si null).
  Future<NetworkPageEnvelope<NetworkActorSummaryDto>> list({
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    String? cursor,
    int? limit,
  }) async {
    final options = await _authOptions();
    final query = <String, dynamic>{
      if (category != null) 'category': category.wireName,
      if (state != null) 'state': state.wireName,
      if (assetId != null) 'assetId': assetId,
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };

    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>(
        _basePath,
        queryParameters: query,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'GET $_basePath: respuesta inesperada ${data.runtimeType}');
    }

    return NetworkPageEnvelope<NetworkActorSummaryDto>.fromJson(
      data,
      parseItem: NetworkActorSummaryDto.fromJson,
      endpoint: 'GET $_basePath',
      expectedSchemaVersion: kNetworkSchemaVersion,
    );
  }

  // --------------------------------------------------------------------------
  // GET /v1/network/categories/summary
  // --------------------------------------------------------------------------

  Future<NetworkCategoriesSummaryEnvelope> getCategoriesSummary() async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>(_summaryPath, options: options);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'GET $_summaryPath: respuesta inesperada ${data.runtimeType}');
    }
    return NetworkCategoriesSummaryEnvelope.fromJson(
      data,
      endpoint: 'GET $_summaryPath',
    );
  }

  // --------------------------------------------------------------------------
  // Internals
  // --------------------------------------------------------------------------

  Future<Options> _authOptions() async {
    final token = await _getIdToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException(
        'No active Firebase session (no ID token).',
      );
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  /// Mapeo HTTP→excepción con separación 401/403:
  ///   - 401 ⇒ UnauthorizedException (sesión inválida → re-login).
  ///   - 403 ⇒ ForbiddenException (capability `network.read` ausente; otras
  ///           secciones del UI siguen operando).
  CoreCommonRemoteException _mapDioError(DioException e) {
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

    if (status == 401) return UnauthorizedException(msg);
    if (status == 403) return ForbiddenException(msg);
    if (status >= 500) return ServerException(status, msg);
    return BadRequestException(status, msg, code: code);
  }
}
