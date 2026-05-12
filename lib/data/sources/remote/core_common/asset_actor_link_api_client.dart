// ============================================================================
// lib/data/sources/remote/core_common/asset_actor_link_api_client.dart
// AssetActorLinkApiClient — HTTP client de vínculos actor↔activo
// ============================================================================
// QUÉ HACE:
//   - Cliente Dio contra:
//       GET  /v1/core-common/asset-actor-links
//       GET  /v1/core-common/asset-actor-links/:id
//       POST /v1/core-common/asset-actor-links     (Hito 1.x — user_declared)
//   - Adjunta Authorization: Bearer <firebase-id-token>.
//   - Traduce DioException a excepciones tipadas de core_common.
//   - Preserva `code` del body JSON (ASSET_ACTOR_LINK_NOT_FOUND,
//     INVALID_CURSOR, INVALID_ASSET_TYPE_INPUT, ASSET_TYPE_NOT_FOUND,
//     INVALID_ACTOR_REF_SHAPE).
//
// QUÉ NO HACE:
//   - No edita/termina: otros flujos (RUNT, contratos) escriben server-side.
//   - El POST solo emite vínculos `source=user_declared`. Las otras fuentes
//     (runt|contract|import) tienen sus propios servicios productores.
//   - No resuelve actores ni hidrata atributos: projected reference, no
//     identidad (ADR §2.6).
//   - No cachea: el consumer decide cache policy.
//
// TAXONOMÍA — `assetClass` vs `assetTypeId` (XOR estricto):
//   El método `create()` exige exactamente uno de los dos en runtime. La
//   resolución de `assetClass → AssetType.id` la hace el backend; el
//   cliente NUNCA mapea taxonomía. Ver
//   `lib/domain/entities/core_common/value_objects/asset_class.dart`.
//
// See docs/adr/0001-actor-canon.md §2.9 (vínculo actor↔activo) + §8.1.
// ============================================================================

import 'package:dio/dio.dart';

import '../../../../domain/entities/core_common/asset_actor_link_entity.dart';
import '../../../../domain/entities/core_common/value_objects/actor_ref_kind_value.dart';
import '../../../../domain/entities/core_common/value_objects/asset_actor_role.dart';
import '../../../../domain/entities/core_common/value_objects/asset_class.dart';
import '../../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import 'nestjs_exceptions.dart';

typedef GetIdToken = Future<String?> Function();

/// Valores del filtro `status` del list.
/// - 'active' (default): solo vínculos en curso.
/// - 'ended': solo los cerrados.
/// - 'any': sin filtro.
enum AssetActorLinkStatusFilter {
  active,
  ended,
  any;

  String get wireName => name;
}

/// Página de resultados del list.
class AssetActorLinkListPage {
  final List<AssetActorLinkEntity> items;
  final String? nextCursor;
  const AssetActorLinkListPage({required this.items, this.nextCursor});
}

class AssetActorLinkApiClient {
  final Dio _dio;
  final GetIdToken _getIdToken;

  static const _base = '/v1/core-common/asset-actor-links';

  AssetActorLinkApiClient({
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
  // GET / — list con filtros opcionales y keyset pagination.
  // --------------------------------------------------------------------------
  Future<AssetActorLinkListPage> list({
    String? assetId,
    AssetActorRole? role,
    ActorRefKindValue? actorRefKind,
    String? platformActorId,
    TargetLocalKind? localKind,
    String? localId,
    AssetActorLinkStatusFilter? status,
    String? cursor,
    int? limit,
  }) async {
    final options = await _authOptions();
    final query = <String, dynamic>{
      if (assetId != null) 'assetId': assetId,
      if (role != null) 'role': role.wireName,
      if (actorRefKind != null) 'actorRefKind': actorRefKind.wireName,
      if (platformActorId != null) 'platformActorId': platformActorId,
      if (localKind != null) 'localKind': localKind.wireName,
      if (localId != null) 'localId': localId,
      if (status != null) 'status': status.wireName,
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
  // GET /:id — detalle con tenancy.
  // --------------------------------------------------------------------------
  Future<AssetActorLinkEntity> findById(String id) async {
    final options = await _authOptions();
    final Response<dynamic> res;
    try {
      res = await _dio.get<dynamic>('$_base/$id', options: options);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'findById: respuesta inesperada ${data.runtimeType}');
    }
    return AssetActorLinkEntity.fromJson(data);
  }

  // --------------------------------------------------------------------------
  // POST / — declarar vínculo `source=user_declared` (Hito 1.x).
  //
  // Idempotente server-side: re-envíos con la misma clave lógica
  // ((orgId, assetId, role, assetTypeId resuelto, actorRefKind, refs...))
  // devuelven la fila existente con HTTP 200 sin duplicar.
  //
  // Taxonomía: XOR estricto entre `assetTypeId` y `assetClass`. El cliente
  // valida en runtime que se pase exactamente uno de los dos. La resolución
  // a `AssetType.id` canónico la hace el backend.
  //
  // Lanza:
  //   - ArgumentError si el XOR se viola en cliente (defensivo: el backend
  //     también lo rechaza con 400 INVALID_ASSET_TYPE_INPUT).
  //   - BadRequestException con `code` preservado para errores backend:
  //       INVALID_ASSET_TYPE_INPUT | ASSET_TYPE_NOT_FOUND |
  //       INVALID_ACTOR_REF_SHAPE.
  //   - UnauthorizedException si el caller no tiene capability
  //     `asset_actor_link.create` (HTTP 401/403).
  //   - ServerException para 5xx.
  //   - NetworkException si no hay respuesta HTTP.
  // --------------------------------------------------------------------------
  Future<AssetActorLinkEntity> create({
    required String assetId,
    String? assetTypeId,
    AssetClass? assetClass,
    required AssetActorRole role,
    required ActorRefKindValue actorRefKind,
    String? platformActorId,
    TargetLocalKind? localKind,
    String? localId,
  }) async {
    // XOR estricto en cliente. Defensivo — el backend también lo valida.
    final hasAssetTypeId = assetTypeId != null && assetTypeId.isNotEmpty;
    final hasAssetClass = assetClass != null;
    if (hasAssetTypeId == hasAssetClass) {
      throw ArgumentError(
        'create() requiere exactamente uno de `assetTypeId` o `assetClass`.',
      );
    }

    final options = await _authOptions();
    final body = <String, dynamic>{
      'assetId': assetId,
      if (hasAssetTypeId) 'assetTypeId': assetTypeId,
      if (hasAssetClass) 'assetClass': assetClass.wireName,
      'role': role.wireName,
      'actorRefKind': actorRefKind.wireName,
      if (platformActorId != null && platformActorId.isNotEmpty)
        'platformActorId': platformActorId,
      if (localKind != null) 'localKind': localKind.wireName,
      if (localId != null && localId.isNotEmpty) 'localId': localId,
      'source': 'user_declared',
    };

    final Response<dynamic> res;
    try {
      res = await _dio.post<dynamic>(_base, data: body, options: options);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException(res.statusCode ?? 0,
          'create: respuesta inesperada ${data.runtimeType}');
    }
    return AssetActorLinkEntity.fromJson(data);
  }

  // --------------------------------------------------------------------------
  // Parser
  // --------------------------------------------------------------------------

  AssetActorLinkListPage _parseListPage(Response<dynamic> res) {
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
        .map(AssetActorLinkEntity.fromJson)
        .toList(growable: false);
    final nextCursor = data['nextCursor'] as String?;
    return AssetActorLinkListPage(items: items, nextCursor: nextCursor);
  }
}
