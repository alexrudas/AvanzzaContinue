// ============================================================================
// lib/data/sources/remote/core_common/match_candidate_nestjs_ds_impl.dart
// MATCH CANDIDATE NESTJS DS — Implementación real HTTP (F5 Hito 1)
// ============================================================================
// QUÉ HACE:
//   - Implementa MatchCandidateNestJsDataSource con requests HTTP reales
//     contra Avanzza Core API (NestJS) bajo /v1/core-common/match-candidates.
//   - Adjunta Authorization: Bearer <firebase-id-token> por request.
//
// QUÉ NO HACE:
//   - NO captura silenciosamente; mapea DioException a excepciones tipadas de
//     nestjs_exceptions.dart y las propaga.
//   - NO retorna null como fallback de error.
//   - NO retry ni encolado — el Repository y/o el caso de uso deciden.
//
// DERIVACIÓN DEL workspaceId:
//   El backend deriva el workspaceId del claim activeOrgId del JWT.
//   Este DS recibe el workspaceId (por contrato abstracto) pero NO lo envía
//   en el request: sirve solo para scoping local (cache, consistencia) del
//   caller. Si el JWT y el workspaceId divergen, es bug aguas arriba
//   (desincronización de activeContext) — no lo oculta este DS.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/entities/core_common/match_candidate_entity.dart';
import '../../../../domain/entities/core_common/operational_relationship_entity.dart';
import '../../../../domain/entities/core_common/value_objects/match_candidate_state.dart';
import '../../../../domain/entities/core_common/value_objects/normalized_key.dart';
import '../../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../../domain/entities/core_common/value_objects/verified_key_type.dart';
import 'match_candidate_nestjs_ds.dart';
import 'nestjs_exceptions.dart';

/// Obtiene el Firebase ID token actual. null si no hay sesión.
typedef GetIdToken = Future<String?> Function();

class MatchCandidateNestJsDataSourceImpl
    implements MatchCandidateNestJsDataSource {
  final Dio _dio;
  final GetIdToken _getIdToken;

  MatchCandidateNestJsDataSourceImpl({
    required Dio dio,
    required GetIdToken getIdToken,
  })  : _dio = dio,
        _getIdToken = getIdToken;

  static const _base = '/v1/core-common/match-candidates';

  /// Construye Options con Authorization Bearer. Lanza UnauthorizedException
  /// si no hay token (caller no autenticado).
  Future<Options> _authOptions() async {
    final token = await _getIdToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException('No active Firebase session (no ID token).');
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

  /// POST /v1/core-common/match-candidates/probe
  @override
  Future<List<MatchCandidateEntity>> probe({
    required TargetLocalKind localKind,
    required String localId,
    required List<NormalizedKey> probes,
  }) async {
    final Options options = await _authOptions();
    final body = <String, dynamic>{
      'localKind': localKind.wireName,
      'localId': localId,
      'probes': probes
          .map((p) => <String, dynamic>{
                'keyType': p.keyType.wireName,
                'normalizedValue': p.normalizedValue,
              })
          .toList(),
    };
    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        '$_base/probe',
        data: body,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! List) {
      throw ServerException(res.statusCode ?? 0,
          'probe: respuesta inesperada (se esperaba List), recibido ${data.runtimeType}');
    }
    return data
        .map((j) => MatchCandidateEntity.fromJson(j as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<List<MatchCandidateEntity>> fetchExposedByWorkspace(
    String workspaceId,
  ) async {
    final Options options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>(_base, options: options);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! List) {
      throw ServerException(res.statusCode ?? 0,
          'fetchExposedByWorkspace: respuesta inesperada (se esperaba List), recibido ${data.runtimeType}');
    }
    return data
        .map((j) => MatchCandidateEntity.fromJson(j as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<ResolveMatchCandidateResult> submitResolution(
    MatchCandidateEntity entity,
  ) async {
    // Mapping estricto: el caller DEBE transicionar el state a un terminal
    // resolutivo ANTES de invocar. Cualquier otro state es un bug upstream.
    final String decision;
    switch (entity.state) {
      case MatchCandidateState.dismissedByWorkspace:
        decision = 'dismiss';
        break;
      case MatchCandidateState.confirmedIntoRelationship:
        decision = 'confirm';
        break;
      case MatchCandidateState.detectedInternal:
      case MatchCandidateState.exposedToWorkspace:
        throw StateError(
          'submitResolution: state debe ser dismissedByWorkspace o '
          'confirmedIntoRelationship, recibido ${entity.state.wireName}',
        );
    }

    final Options options = await _authOptions();
    final body = <String, dynamic>{
      'decision': decision,
      if (entity.resultingRelationshipId != null)
        'resultingRelationshipId': entity.resultingRelationshipId,
    };

    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        '$_base/${entity.id}/resolve',
        data: body,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(
        res.statusCode ?? 0,
        'submitResolution: respuesta inesperada (se esperaba Map), '
        'recibido ${data.runtimeType}',
      );
    }

    final mcJson = data['matchCandidate'];
    if (mcJson is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'submitResolution: "matchCandidate" ausente o inválido en respuesta');
    }
    final mc = MatchCandidateEntity.fromJson(mcJson);

    final relJson = data['relationship'];
    final OperationalRelationshipEntity? relationship;
    if (relJson == null) {
      relationship = null;
    } else if (relJson is Map<String, dynamic>) {
      relationship = OperationalRelationshipEntity.fromJson(relJson);
    } else {
      throw ServerException(res.statusCode ?? 0,
          'submitResolution: "relationship" inválido en respuesta');
    }

    return ResolveMatchCandidateResult(
      matchCandidate: mc,
      relationship: relationship,
    );
  }
}
