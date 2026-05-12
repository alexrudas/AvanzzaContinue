// ============================================================================
// lib/data/sources/remote/network/team_api_client.dart
// TEAM API CLIENT — HTTP cliente del equipo interno (Mi Red Operativa v1)
// ============================================================================
// QUÉ HACE:
//   - Cliente Dio que consume los endpoints de Core API congelado para el
//     equipo interno:
//       GET /v1/team           → lista paginada de membresías ACTIVE.
//       GET /v1/team/summary   → contador de miembros activos.
//   - Adjunta Authorization: Bearer <firebase-id-token>.
//   - Mapeo HTTP→excepción separado:
//       · 401 → UnauthorizedException.
//       · 403 → ForbiddenException  (capability `team.read` ausente).
//       · 5xx → ServerException.
//       · 4xx (resto) → BadRequestException con `code` si el body lo trae.
//       · sin respuesta HTTP → NetworkException.
//   - Valida `schemaVersion==1` por respuesta.
//
// QUÉ NO HACE:
//   - No expone categories, primaryCategory, isRestricted, relationshipState
//     ni providerProfileId: ese eje es exclusivo de /v1/network. Mezclarlos
//     violaría la separación red externa vs equipo interno.
//   - No filtra por rol: el backend retorna todos los miembros activos. La
//     UI agrupa por `teamRoleKeys[]` si los hay.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/errors/remote_exceptions.dart';
import '../../../models/network/network_envelope.dart';
import '../../../models/network/team_member_summary_dto.dart';
import 'network_api_client.dart' show GetIdToken;

/// HTTP cliente para los endpoints de /v1/team.
class TeamApiClient {
  final Dio _dio;
  final GetIdToken _getIdToken;

  static const _basePath = '/v1/team';
  static const _summaryPath = '/v1/team/summary';

  TeamApiClient({
    required Dio dio,
    required GetIdToken getIdToken,
  })  : _dio = dio,
        _getIdToken = getIdToken;

  // --------------------------------------------------------------------------
  // GET /v1/team
  // --------------------------------------------------------------------------

  Future<NetworkPageEnvelope<TeamMemberSummaryDto>> list({
    String? cursor,
    int? limit,
  }) async {
    final options = await _authOptions();
    final query = <String, dynamic>{
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

    return NetworkPageEnvelope<TeamMemberSummaryDto>.fromJson(
      data,
      parseItem: TeamMemberSummaryDto.fromJson,
      endpoint: 'GET $_basePath',
      expectedSchemaVersion: kTeamSchemaVersion,
    );
  }

  // --------------------------------------------------------------------------
  // GET /v1/team/summary
  // --------------------------------------------------------------------------

  Future<TeamSummaryEnvelope> getSummary() async {
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
    return TeamSummaryEnvelope.fromJson(
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
  ///   - 401 ⇒ UnauthorizedException.
  ///   - 403 ⇒ ForbiddenException (capability `team.read` ausente; /network
  ///           puede seguir cargando independientemente).
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
