// ============================================================================
// lib/data/sources/remote/provider/provider_canonical_api_client.dart
// PROVIDER CANONICAL API CLIENT — HTTP client (Avanzza Core API)
//
// QUÉ HACE:
// - Cliente Dio contra los endpoints canónicos del provisionamiento de
//   proveedor:
//     - POST  /v1/providers
//     - GET   /v1/providers/:providerProfileId
//     - PUT   /v1/providers/:providerProfileId/specialties
// - Adjunta `Authorization: Bearer <firebase-id-token>`.
// - Traduce DioException a la jerarquía canónica de `remote_exceptions.dart`,
//   incluyendo las excepciones tipadas específicas del Hito 1
//   (`AmbiguousPlatformActorException`, `LocalRefNotFoundException`,
//   `ProviderProfileNotFoundException`, `WorkspaceNotFoundException`).
//
// QUÉ NO HACE:
// - NO normaliza probes (responsabilidad del caller).
// - NO cachea respuestas: la SSOT vive en Postgres via Core API.
// - NO orquesta el probe de match-candidate previo al POST. Eso vive en
//   el controller del form.
//
// PRINCIPIOS:
// - Mismo patrón que `asset_actor_link_api_client.dart` y
//   `specialty_catalog_api_client.dart`: Dio inyectado (tag:'core'),
//   `getIdToken` callback, mapping centralizado de DioException.
// - Errores se distinguen por `code` del body JSON. Si el body trae
//   `candidates` (caso AMBIGUOUS), se parsea y se inyecta en la excepción.
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-26): Hito 1 — integración Flutter canónica.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/entities/provider/provider_canonical_entity.dart';
import '../../../../domain/errors/remote_exceptions.dart';
import '../../../../domain/repositories/provider/provider_canonical_repository.dart';
import '../../../models/provider/provider_canonical_dto.dart';

typedef GetIdToken = Future<String?> Function();

class ProviderCanonicalApiClient {
  final Dio _dio;
  final GetIdToken _getIdToken;

  static const String _basePath = '/v1/providers';

  ProviderCanonicalApiClient({
    required Dio dio,
    required GetIdToken getIdToken,
  })  : _dio = dio,
        _getIdToken = getIdToken;

  // ─── POST /v1/providers ────────────────────────────────────────────────
  Future<ProviderCanonicalEntity> provision(
    ProvisionProviderInput input, {
    CancelToken? cancelToken,
  }) async {
    final options = await _authOptions();
    final body = ProvisionProviderRequestDto(input).toJson();

    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(
        _basePath,
        data: body,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    return _parseResponse(res);
  }

  // ─── GET /v1/providers/:id ─────────────────────────────────────────────
  Future<ProviderCanonicalEntity> getById(
    String providerProfileId, {
    CancelToken? cancelToken,
  }) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>(
        '$_basePath/$providerProfileId',
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    return _parseResponse(res);
  }

  // ─── PUT /v1/providers/:id/specialties ─────────────────────────────────
  Future<ProviderCanonicalEntity> replaceSpecialties({
    required String providerProfileId,
    required Set<String> specialtyIds,
    required DateTime providerProfileUpdatedAt,
    CancelToken? cancelToken,
  }) async {
    final options = await _authOptions();
    final body = ReplaceSpecialtiesRequestDto(
      specialtyIds: specialtyIds,
      providerProfileUpdatedAt: providerProfileUpdatedAt,
    ).toJson();

    final Response<dynamic> res;
    try {
      res = await _dio.put<dynamic>(
        '$_basePath/$providerProfileId/specialties',
        data: body,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    // El response de PUT specialties tiene una shape ligeramente distinta
    // (devuelve solo providerProfileId + specialties + updatedAt).
    // Para mantener un solo flujo de cache, hacemos un GET tras el PUT
    // para reusar el parser canónico — alternativamente parseamos la
    // shape PUT específicamente. Optamos por re-call: el backend cachea
    // 60s y la consistencia se preserva.
    //
    // ALTERNATIVA: parsear directamente. Lo hacemos así para evitar el
    // round-trip extra. El parseo es defensivo y compatible con ambos.
    return _parsePartialOrFullResponse(res, providerProfileId);
  }

  // ─── Helpers privados ──────────────────────────────────────────────────

  Future<Options> _authOptions() async {
    final token = await _getIdToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException(
        'No active Firebase session (no ID token).',
      );
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  ProviderCanonicalEntity _parseResponse(Response<dynamic> res) {
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(
        res.statusCode ?? 0,
        'Respuesta inesperada ${data.runtimeType}',
      );
    }
    try {
      return ProviderCanonicalResponseDto.fromJson(data).toEntity();
    } on FormatException catch (e) {
      throw ServerException(res.statusCode ?? 0, 'Body inválido: ${e.message}');
    }
  }

  /// Parser tolerante para el response de `PUT /:id/specialties`:
  /// - Si el body tiene la shape COMPLETA del provider (con `displayName`,
  ///   `actorKind`, etc.) → usa el parser canónico.
  /// - Si el body es la shape PARCIAL `{providerProfileId, specialties[],
  ///   updatedAt}` → hace un GET subsecuente al provider para construir la
  ///   entity completa. Esto centraliza el mapeo en un solo punto.
  Future<ProviderCanonicalEntity> _parsePartialOrFullResponse(
    Response<dynamic> res,
    String providerProfileId,
  ) async {
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(
        res.statusCode ?? 0,
        'Respuesta inesperada ${data.runtimeType}',
      );
    }
    if (data.containsKey('displayName') && data.containsKey('actorKind')) {
      // Shape completa: usa parser canónico.
      try {
        return ProviderCanonicalResponseDto.fromJson(data).toEntity();
      } on FormatException catch (e) {
        throw ServerException(res.statusCode ?? 0, 'Body inválido: ${e.message}');
      }
    }
    // Shape parcial: hidrata via GET. Usa el mismo path de auth.
    return getById(providerProfileId);
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

    // ── Excepciones tipadas específicas del Hito 1 ──
    if (status == 404 && code == 'LOCAL_REF_NOT_FOUND') {
      return LocalRefNotFoundException(msg);
    }
    if (status == 404 && code == 'PROVIDER_PROFILE_NOT_FOUND') {
      return ProviderProfileNotFoundException(msg);
    }
    if (status == 404 && code == 'WORKSPACE_NOT_FOUND') {
      return WorkspaceNotFoundException(msg);
    }
    if (status == 409 && code == 'AMBIGUOUS_PLATFORM_ACTOR_MATCH') {
      return AmbiguousPlatformActorException(
        msg,
        candidates: _parseCandidates(body),
      );
    }

    // ── Mapeo genérico ──
    if (status == 401 || status == 403) return UnauthorizedException(msg);
    if (status >= 500) return ServerException(status, msg);
    return BadRequestException(status, msg, code: code);
  }

  List<AmbiguousPlatformActorCandidate> _parseCandidates(dynamic body) {
    if (body is! Map) return const [];
    final raw = body['candidates'];
    if (raw is! List) return const [];
    final out = <AmbiguousPlatformActorCandidate>[];
    for (final item in raw) {
      if (item is! Map) continue;
      final pid = item['platformActorId'];
      final dn = item['displayName'];
      final mk = item['matchedKeys'];
      if (pid is! String || dn is! String || mk is! List) continue;
      out.add(
        AmbiguousPlatformActorCandidate(
          platformActorId: pid,
          displayName: dn,
          matchedKeys: mk.whereType<String>().toList(growable: false),
        ),
      );
    }
    return out;
  }
}
