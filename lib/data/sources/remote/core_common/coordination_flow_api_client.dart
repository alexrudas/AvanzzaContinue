// ============================================================================
// lib/data/sources/remote/core_common/coordination_flow_api_client.dart
// COORDINATION FLOW API CLIENT — HTTP client contra Core API (F5 Hito 14)
// ============================================================================
// QUÉ HACE:
//   - Cliente HTTP único contra avanzza-core-api para coordination flows.
//   - POST /v1/coordination-flows (startFlow): crea flow + primera request
//     en una transacción Serializable server-side.
//   - Adjunta Authorization: Bearer <firebase-id-token> por request.
//   - Mapea DioException a excepciones tipadas (nestjs_exceptions.dart).
//
// QUÉ NO HACE:
//   - No define abstract/interface: Core API es la única fuente remota; no
//     hay alternativa ni fakes en tests que justifiquen un contrato extra.
//     Si en el futuro se requiere mockear, se usa package:mocktail directo
//     sobre esta clase (mocktail soporta clases concretas).
//   - No encola ni reintenta: la creación es online-only.
//
// CONTRATO DE TENANT:
//   - sourceWorkspaceId y startedBy NO viajan en body. El backend los deriva
//     del Firebase ID token (claim activeOrgId / uid). Enviarlos provoca 400
//     por forbidNonWhitelisted del backend.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/entities/core_common/coordination_flow_entity.dart';
import '../../../../domain/entities/core_common/operational_request_entity.dart';
import '../../../../domain/entities/core_common/value_objects/coordination_flow_kind.dart';
import '../../../../domain/entities/core_common/value_objects/request_kind.dart';
import '../../../../domain/entities/core_common/value_objects/request_origin_channel.dart';
import 'nestjs_exceptions.dart';

/// Firebase ID token provider. null si no hay sesión activa.
typedef GetIdToken = Future<String?> Function();

/// Body del POST /v1/coordination-flows.
/// sourceWorkspaceId y startedBy NO viajan aquí: el backend los deriva del
/// Firebase ID token (activeOrgId / uid). Nunca se aceptan desde body.
class StartCoordinationFlowRequest {
  final String relationshipId;
  final InitialRequestPayload initialRequest;
  final CoordinationFlowKind? flowKind;

  const StartCoordinationFlowRequest({
    required this.relationshipId,
    required this.initialRequest,
    this.flowKind,
  });
}

class InitialRequestPayload {
  final String title;
  final String? summary;
  final RequestKind? requestKind;

  /// Metadata (no influye en lógica de dominio backend).
  final RequestOriginChannel? originChannel;

  const InitialRequestPayload({
    required this.title,
    this.summary,
    this.requestKind,
    this.originChannel,
  });
}

/// Respuesta de POST /v1/coordination-flows.
class StartCoordinationFlowResponse {
  final CoordinationFlowEntity flow;
  final OperationalRequestEntity request;

  const StartCoordinationFlowResponse({
    required this.flow,
    required this.request,
  });
}

class CoordinationFlowApiClient {
  final Dio _dio;
  final GetIdToken _getIdToken;

  CoordinationFlowApiClient({
    required Dio dio,
    required GetIdToken getIdToken,
  })  : _dio = dio,
        _getIdToken = getIdToken;

  static const _base = '/v1/coordination-flows';

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
    if (status == 401 || status == 403) return UnauthorizedException(msg);
    if (status >= 500) return ServerException(status, msg);
    return BadRequestException(status, msg);
  }

  Future<StartCoordinationFlowResponse> startFlow(
    StartCoordinationFlowRequest input,
  ) async {
    final Options options = await _authOptions();
    final body = <String, dynamic>{
      'relationshipId': input.relationshipId,
      'initialRequest': <String, dynamic>{
        'title': input.initialRequest.title,
        if (input.initialRequest.summary != null)
          'summary': input.initialRequest.summary,
        if (input.initialRequest.requestKind != null)
          'requestKind': input.initialRequest.requestKind!.wireName,
        if (input.initialRequest.originChannel != null)
          'originChannel': input.initialRequest.originChannel!.wireName,
      },
      if (input.flowKind != null) 'flowKind': input.flowKind!.wireName,
    };

    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(_base, data: body, options: options);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(
        res.statusCode ?? 0,
        'startFlow: respuesta inesperada (se esperaba Map), recibido ${data.runtimeType}',
      );
    }

    final flowJson = data['flow'];
    if (flowJson is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'startFlow: "flow" ausente o inválido en respuesta');
    }
    final requestJson = data['request'];
    if (requestJson is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'startFlow: "request" ausente o inválido en respuesta');
    }

    return StartCoordinationFlowResponse(
      flow: CoordinationFlowEntity.fromJson(flowJson),
      request: OperationalRequestEntity.fromJson(requestJson),
    );
  }
}
