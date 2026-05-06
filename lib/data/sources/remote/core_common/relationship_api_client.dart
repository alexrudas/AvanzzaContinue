// ============================================================================
// lib/data/sources/remote/core_common/relationship_api_client.dart
// RelationshipApiClient — HTTP client del CRUD de OperationalRelationship
// ============================================================================
// QUÉ HACE:
//   - Cliente Dio contra avanzza-core-api hito 3:
//       GET    /v1/core-common/relationships
//       GET    /v1/core-common/relationships/:id
//       POST   /v1/core-common/relationships/:id/suspend
//       POST   /v1/core-common/relationships/:id/reactivate
//       POST   /v1/core-common/relationships/:id/close
//   - Adjunta Authorization: Bearer <firebase-id-token>.
//   - Traduce DioException a las excepciones tipadas de core_common.
//   - Preserva el `code` del body JSON cuando existe (ej. RELATIONSHIP_NOT_FOUND,
//     RELATIONSHIP_INVALID_TRANSITION, INVALID_CURSOR).
//
// QUÉ NO HACE:
//   - No cachea: read path va directo al backend (la fuente única de verdad
//     de OperationalRelationship es core-api — ADR §2.8).
//   - No envía sourceWorkspaceId: el backend lo deriva del JWT.
//   - No reintenta: cualquier retry semántico lo decide el repo/caller.
//
// See docs/adr/0001-actor-canon.md §5 (CRUD hito 3) + §8.1.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/entities/core_common/operational_relationship_entity.dart';
import '../../../../domain/entities/core_common/value_objects/relationship_state.dart';
import '../../../../domain/entities/core_common/value_objects/relationship_suspension_reason.dart';
import '../../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import 'nestjs_exceptions.dart';

typedef GetIdToken = Future<String?> Function();

/// Página de resultados del list.
class RelationshipListPage {
  final List<OperationalRelationshipEntity> items;
  final String? nextCursor;
  const RelationshipListPage({required this.items, this.nextCursor});
}

class RelationshipApiClient {
  final Dio _dio;
  final GetIdToken _getIdToken;

  static const _base = '/v1/core-common/relationships';

  RelationshipApiClient({
    required Dio dio,
    required GetIdToken getIdToken,
  })  : _dio = dio,
        _getIdToken = getIdToken;

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
    final status = e.response?.statusCode;
    if (status == null) {
      return NetworkException(
        'Network failure: ${e.type.name}${e.message != null ? ' — ${e.message}' : ''}',
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

  // --------------------------------------------------------------------------
  // GET / — list con filtros y keyset pagination.
  // --------------------------------------------------------------------------
  Future<RelationshipListPage> list({
    RelationshipState? state,
    TargetLocalKind? localKind,
    String? localId,
    String? cursor,
    int? limit,
  }) async {
    final options = await _authOptions();
    final query = <String, dynamic>{
      if (state != null) 'state': state.wireName,
      if (localKind != null) 'localKind': localKind.wireName,
      if (localId != null) 'localId': localId,
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>(
        _base,
        queryParameters: query,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    return _parseListPage(res);
  }

  // --------------------------------------------------------------------------
  // GET /:id — detalle.
  // --------------------------------------------------------------------------
  Future<OperationalRelationshipEntity> findById(String id) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>('$_base/$id', options: options);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    return _parseRelationship(res, 'findById');
  }

  // --------------------------------------------------------------------------
  // POST /:id/suspend — transición vinculada|suspendida → suspendida.
  // --------------------------------------------------------------------------
  Future<OperationalRelationshipEntity> suspend(
    String id,
    RelationshipSuspensionReason reason,
  ) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        '$_base/$id/suspend',
        data: {'reason': reason.wireName},
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    return _parseRelationship(res, 'suspend');
  }

  // --------------------------------------------------------------------------
  // POST /:id/reactivate — transición suspendida → vinculada.
  // --------------------------------------------------------------------------
  Future<OperationalRelationshipEntity> reactivate(String id) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        '$_base/$id/reactivate',
        data: const <String, dynamic>{},
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    return _parseRelationship(res, 'reactivate');
  }

  // --------------------------------------------------------------------------
  // POST /:id/close — transición → cerrada. reason opcional.
  // --------------------------------------------------------------------------
  Future<OperationalRelationshipEntity> close(
    String id, {
    RelationshipSuspensionReason? reason,
  }) async {
    final options = await _authOptions();
    final body = <String, dynamic>{};
    if (reason != null) body['reason'] = reason.wireName;
    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        '$_base/$id/close',
        data: body,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    return _parseRelationship(res, 'close');
  }

  // --------------------------------------------------------------------------
  // Parsers
  // --------------------------------------------------------------------------

  RelationshipListPage _parseListPage(Response<dynamic> res) {
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'list: respuesta inesperada ${data.runtimeType}');
    }
    final rawItems = data['items'];
    if (rawItems is! List) {
      throw ServerException(res.statusCode ?? 0,
          'list: "items" ausente o no es List');
    }
    final items = rawItems
        .cast<Map<String, dynamic>>()
        .map(OperationalRelationshipEntity.fromJson)
        .toList(growable: false);
    final nextCursor = data['nextCursor'] as String?;
    return RelationshipListPage(items: items, nextCursor: nextCursor);
  }

  OperationalRelationshipEntity _parseRelationship(
    Response<dynamic> res,
    String opLabel,
  ) {
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          '$opLabel: respuesta inesperada ${data.runtimeType}');
    }
    return OperationalRelationshipEntity.fromJson(data);
  }
}
