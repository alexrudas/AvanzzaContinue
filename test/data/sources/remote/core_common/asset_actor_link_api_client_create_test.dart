// ============================================================================
// test/data/sources/remote/core_common/asset_actor_link_api_client_create_test.dart
// AssetActorLinkApiClient.create() — XOR + payload shape + error mapping
// ============================================================================
// QUÉ CUBRE:
//   - happy A: assetTypeId directo → POST con body correcto + Bearer token.
//   - happy B: assetClass=vehicle → POST con `assetClass: 'vehicle'`.
//   - XOR violado en cliente (defensivo): ambos / ninguno → ArgumentError
//     ANTES de tocar Dio.
//   - idempotencia: backend devuelve 200 con la fila existente → cliente
//     parsea idéntico al happy path.
//   - 400 INVALID_ASSET_TYPE_INPUT → BadRequestException con `code` preservado.
//   - 400 ASSET_TYPE_NOT_FOUND → BadRequestException con `code` preservado.
//   - 401/403 → UnauthorizedException.
//   - 5xx → ServerException.
//   - DioException sin response → NetworkException.
//
// PATRÓN: fake `HttpClientAdapter` scriptable (mismo del provider client).
// ============================================================================

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:avanzza/data/sources/remote/core_common/asset_actor_link_api_client.dart';
import 'package:avanzza/data/sources/remote/core_common/nestjs_exceptions.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/actor_ref_kind_value.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/asset_class.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Captured request ───────────────────────────────────────────────────────

class _CapturedRequest {
  final String path;
  final String method;
  final Map<String, dynamic> headers;
  final dynamic data;

  _CapturedRequest(RequestOptions o)
      : path = o.path,
        method = o.method,
        headers = Map<String, dynamic>.from(o.headers),
        data = o.data;
}

// ─── Fake adapter ───────────────────────────────────────────────────────────

class _FakeAdapter implements HttpClientAdapter {
  final List<_CapturedRequest> captured = [];
  final List<_FakeResponseScript> _script = [];
  int _i = 0;

  void enqueue(_FakeResponseScript r) => _script.add(r);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future? cancelFuture,
  ) async {
    captured.add(_CapturedRequest(options));
    if (_i >= _script.length) {
      throw StateError(
        '_FakeAdapter: no script left for ${options.method} ${options.path}',
      );
    }
    final entry = _script[_i++];
    if (entry.willThrow != null) throw entry.willThrow!;
    final body = entry.body ?? <String, dynamic>{};
    final raw = body is String ? body : jsonEncode(body);
    return ResponseBody.fromBytes(
      Uint8List.fromList(utf8.encode(raw)),
      entry.statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _FakeResponseScript {
  final dynamic body;
  final int statusCode;
  final DioException? willThrow;
  _FakeResponseScript({
    this.body,
    this.statusCode = 200,
    this.willThrow,
  });
}

// ─── Builders ───────────────────────────────────────────────────────────────

Dio _makeDio(_FakeAdapter adapter) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.test',
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  ));
  dio.httpClientAdapter = adapter;
  return dio;
}

AssetActorLinkApiClient _makeClient(
  Dio dio, {
  String? token = 'tk',
}) =>
    AssetActorLinkApiClient(
      dio: dio,
      getIdToken: () async => token,
    );

Map<String, dynamic> _validResponse({Map<String, dynamic>? overrides}) {
  return {
    'id': 'aal-1',
    'orgId': 'org-1',
    'assetId': 'asset-42',
    'role': 'owner',
    'actorRefKind': 'local',
    'platformActorId': null,
    'localKind': 'organization',
    'localId': 'org-1',
    'source': 'user_declared',
    'verificationStatus': 'pending',
    'status': 'active',
    'startedAt': '2026-04-26T12:00:00Z',
    'endedAt': null,
    'createdAt': '2026-04-26T12:00:00Z',
    'updatedAt': '2026-04-26T12:00:00Z',
    ...?overrides,
  };
}

// ─── Tests ──────────────────────────────────────────────────────────────────

void main() {
  group('AssetActorLinkApiClient.create — XOR validation (defensiva en cliente)',
      () {
    test('ambos presentes → ArgumentError sin tocar Dio', () async {
      final adapter = _FakeAdapter();
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        () => client.create(
          assetId: 'asset-42',
          assetTypeId: 'vehicle',
          assetClass: AssetClass.vehicle,
          role: AssetActorRole.owner,
          actorRefKind: ActorRefKindValue.local,
          localKind: TargetLocalKind.organization,
          localId: 'org-1',
        ),
        throwsArgumentError,
      );
      expect(adapter.captured, isEmpty);
    });

    test('ambos ausentes → ArgumentError sin tocar Dio', () async {
      final adapter = _FakeAdapter();
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        () => client.create(
          assetId: 'asset-42',
          // assetTypeId y assetClass omitidos
          role: AssetActorRole.owner,
          actorRefKind: ActorRefKindValue.local,
          localKind: TargetLocalKind.organization,
          localId: 'org-1',
        ),
        throwsArgumentError,
      );
      expect(adapter.captured, isEmpty);
    });
  });

  group('AssetActorLinkApiClient.create — happy paths', () {
    test('camino A — assetTypeId directo: POST con body + Bearer correctos',
        () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          body: _validResponse(),
          statusCode: 200,
        ));
      final client = _makeClient(_makeDio(adapter));

      final entity = await client.create(
        assetId: 'asset-42',
        assetTypeId: 'vehicle.car',
        role: AssetActorRole.owner,
        actorRefKind: ActorRefKindValue.local,
        localKind: TargetLocalKind.organization,
        localId: 'org-1',
      );

      expect(adapter.captured, hasLength(1));
      final req = adapter.captured.first;
      expect(req.method, 'POST');
      expect(req.path, '/v1/core-common/asset-actor-links');
      expect(req.headers['Authorization'], 'Bearer tk');
      final data = req.data as Map<String, dynamic>;
      expect(data['assetId'], 'asset-42');
      expect(data['assetTypeId'], 'vehicle.car');
      expect(data.containsKey('assetClass'), isFalse);
      expect(data['role'], 'owner');
      expect(data['actorRefKind'], 'local');
      expect(data['localKind'], 'organization');
      expect(data['localId'], 'org-1');
      expect(data['source'], 'user_declared');
      expect(entity.id, 'aal-1');
      expect(entity.source, 'user_declared');
    });

    test('camino B — assetClass=vehicle: POST con `assetClass`, sin assetTypeId',
        () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          body: _validResponse(),
          statusCode: 200,
        ));
      final client = _makeClient(_makeDio(adapter));

      await client.create(
        assetId: 'asset-42',
        assetClass: AssetClass.vehicle,
        role: AssetActorRole.owner,
        actorRefKind: ActorRefKindValue.local,
        localKind: TargetLocalKind.organization,
        localId: 'org-1',
      );

      final data = adapter.captured.first.data as Map<String, dynamic>;
      expect(data['assetClass'], 'vehicle');
      expect(data.containsKey('assetTypeId'), isFalse);
      expect(data['source'], 'user_declared');
    });

    test('idempotencia — 200 con fila existente: cliente parsea sin diferencia',
        () async {
      // El backend es idempotente: si ya existe la fila active, devuelve la
      // misma con HTTP 200. El cliente NO distingue creación vs reutilización
      // — solo le interesa el row.
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          body: _validResponse(overrides: {'id': 'aal-existing'}),
          statusCode: 200,
        ));
      final client = _makeClient(_makeDio(adapter));

      final entity = await client.create(
        assetId: 'asset-42',
        assetClass: AssetClass.vehicle,
        role: AssetActorRole.owner,
        actorRefKind: ActorRefKindValue.local,
        localKind: TargetLocalKind.organization,
        localId: 'org-1',
      );

      expect(entity.id, 'aal-existing');
    });
  });

  group('AssetActorLinkApiClient.create — error mapping', () {
    test('sin token → UnauthorizedException sin tocar Dio', () async {
      final adapter = _FakeAdapter();
      final client = _makeClient(_makeDio(adapter), token: null);

      await expectLater(
        () => client.create(
          assetId: 'asset-42',
          assetClass: AssetClass.vehicle,
          role: AssetActorRole.owner,
          actorRefKind: ActorRefKindValue.local,
          localKind: TargetLocalKind.organization,
          localId: 'org-1',
        ),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(adapter.captured, isEmpty);
    });

    test('400 INVALID_ASSET_TYPE_INPUT → BadRequestException con code preservado',
        () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 400,
              data: {
                'code': 'INVALID_ASSET_TYPE_INPUT',
                'message': 'Provide exactly one of assetTypeId or assetClass.',
              },
            ),
            type: DioExceptionType.badResponse,
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        () => client.create(
          assetId: 'asset-42',
          assetTypeId: 'vehicle',
          role: AssetActorRole.owner,
          actorRefKind: ActorRefKindValue.local,
          localKind: TargetLocalKind.organization,
          localId: 'org-1',
        ),
        throwsA(
          isA<BadRequestException>()
              .having((e) => e.code, 'code', 'INVALID_ASSET_TYPE_INPUT'),
        ),
      );
    });

    test('400 ASSET_TYPE_NOT_FOUND → BadRequestException con code preservado',
        () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 400,
              data: {
                'code': 'ASSET_TYPE_NOT_FOUND',
                'message': 'AssetType "vehicle" no existe o está inactivo.',
                'via': 'asset_class',
              },
            ),
            type: DioExceptionType.badResponse,
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        () => client.create(
          assetId: 'asset-42',
          assetClass: AssetClass.vehicle,
          role: AssetActorRole.owner,
          actorRefKind: ActorRefKindValue.local,
          localKind: TargetLocalKind.organization,
          localId: 'org-1',
        ),
        throwsA(
          isA<BadRequestException>()
              .having((e) => e.code, 'code', 'ASSET_TYPE_NOT_FOUND'),
        ),
      );
    });

    test('401 → UnauthorizedException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 401,
              data: {'message': 'unauth'},
            ),
            type: DioExceptionType.badResponse,
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        () => client.create(
          assetId: 'asset-42',
          assetClass: AssetClass.vehicle,
          role: AssetActorRole.owner,
          actorRefKind: ActorRefKindValue.local,
          localKind: TargetLocalKind.organization,
          localId: 'org-1',
        ),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('403 (capability missing) → UnauthorizedException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 403,
              data: {'message': 'forbidden'},
            ),
            type: DioExceptionType.badResponse,
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        () => client.create(
          assetId: 'asset-42',
          assetClass: AssetClass.vehicle,
          role: AssetActorRole.owner,
          actorRefKind: ActorRefKindValue.local,
          localKind: TargetLocalKind.organization,
          localId: 'org-1',
        ),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('5xx → ServerException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 503,
              data: {'message': 'gateway'},
            ),
            type: DioExceptionType.badResponse,
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        () => client.create(
          assetId: 'asset-42',
          assetClass: AssetClass.vehicle,
          role: AssetActorRole.owner,
          actorRefKind: ActorRefKindValue.local,
          localKind: TargetLocalKind.organization,
          localId: 'org-1',
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('DioException sin response (network) → NetworkException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionError,
            message: 'connection refused',
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        () => client.create(
          assetId: 'asset-42',
          assetClass: AssetClass.vehicle,
          role: AssetActorRole.owner,
          actorRefKind: ActorRefKindValue.local,
          localKind: TargetLocalKind.organization,
          localId: 'org-1',
        ),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
