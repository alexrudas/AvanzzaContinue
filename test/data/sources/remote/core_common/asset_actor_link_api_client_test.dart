// ============================================================================
// test/data/sources/remote/core_common/asset_actor_link_api_client_test.dart
// AssetActorLinkApiClient — HTTP contra hito 5a
// ============================================================================
// Valida:
//   - Shape del query y headers enviados (Authorization, filtros, enums wire).
//   - Parseo de la respuesta list (items + nextCursor).
//   - Parseo de findById.
//   - Sin token → UnauthorizedException sin tocar Dio.
//   - DioException 4xx → BadRequestException con `code` preservado.
// ============================================================================

import 'dart:convert';

import 'package:avanzza/data/sources/remote/core_common/asset_actor_link_api_client.dart';
import 'package:avanzza/data/sources/remote/core_common/nestjs_exceptions.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/actor_ref_kind_value.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Dio fake: adapter que captura el RequestOptions ────────────────────────

class _CapturedRequest {
  final String path;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic>? headers;
  final dynamic data;
  final String method;
  _CapturedRequest(RequestOptions o)
      : path = o.path,
        queryParameters = Map<String, dynamic>.from(o.queryParameters),
        headers = Map<String, dynamic>.from(o.headers),
        data = o.data,
        method = o.method;
}

class _FakeAdapter implements HttpClientAdapter {
  _CapturedRequest? captured;
  int statusCode = 200;
  dynamic responseBody;
  DioException? willThrow;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future? cancelFuture,
  ) async {
    captured = _CapturedRequest(options);
    if (willThrow != null) throw willThrow!;
    final body = responseBody ?? <String, dynamic>{};
    return ResponseBody.fromString(
      _encode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}

  String _encode(dynamic body) {
    if (body is String) return body;
    return _mapToJson(body);
  }

  String _mapToJson(dynamic v) {
    // Dio transforms usan JsonDecoder por default. Para evitar dependencia
    // extra usamos un encode manual simple vía dart:convert.
    return _jsonEncode(v);
  }

  // Redirigido abajo.
  String _jsonEncode(dynamic v) => _encoder.convert(v);
  final _encoder = const JsonEncoder();
}

// Dart's dart:convert usado vía alias
// (evita definir encoder propio)

// ----------------------------------------------------------------------------

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
  String token = 'tk',
}) =>
    AssetActorLinkApiClient(
      dio: dio,
      getIdToken: () async => token,
    );

Map<String, dynamic> _linkFixture({
  String id = 'aal-1',
  String orgId = 'org-1',
  String assetId = 'asset-1',
  String role = 'owner',
  String actorRefKind = 'local',
  String? platformActorId,
  String? localKind = 'contact',
  String? localId = 'local-1',
  String status = 'active',
}) {
  return {
    'id': id,
    'orgId': orgId,
    'assetId': assetId,
    'role': role,
    'actorRefKind': actorRefKind,
    'platformActorId': platformActorId,
    'localKind': localKind,
    'localId': localId,
    'source': 'user_declared',
    'verificationStatus': 'pending',
    'status': status,
    'startedAt': '2026-04-15T00:00:00.000Z',
    'createdAt': '2026-04-15T00:00:00.000Z',
    'updatedAt': '2026-04-15T00:00:00.000Z',
  };
}

void main() {
  group('AssetActorLinkApiClient.list', () {
    test('envía query con filtros wire-stable y Authorization Bearer', () async {
      final adapter = _FakeAdapter()
        ..responseBody = {
          'items': [_linkFixture()],
          'nextCursor': null,
        };
      final client = _makeClient(_makeDio(adapter));

      await client.list(
        assetId: 'asset-42',
        role: AssetActorRole.owner,
        actorRefKind: ActorRefKindValue.local,
        localKind: TargetLocalKind.contact,
        localId: 'local-xyz',
        status: AssetActorLinkStatusFilter.active,
        limit: 25,
      );

      final req = adapter.captured!;
      expect(req.method, 'GET');
      expect(req.path, '/v1/core-common/asset-actor-links');
      expect(req.queryParameters, {
        'assetId': 'asset-42',
        'role': 'owner',
        'actorRefKind': 'local',
        'localKind': 'contact',
        'localId': 'local-xyz',
        'status': 'active',
        'limit': 25,
      });
      expect(req.headers!['Authorization'], 'Bearer tk');
    });

    test('sin token activo → UnauthorizedException sin pegarle a Dio', () async {
      final adapter = _FakeAdapter();
      final client = AssetActorLinkApiClient(
        dio: _makeDio(adapter),
        getIdToken: () async => null,
      );

      await expectLater(
        client.list(),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(adapter.captured, isNull);
    });

    test('parsea items + nextCursor', () async {
      final adapter = _FakeAdapter()
        ..responseBody = {
          'items': [
            _linkFixture(id: 'aal-1'),
            _linkFixture(id: 'aal-2', role: 'tenant'),
          ],
          'nextCursor': 'OPAQUE-CURSOR',
        };
      final client = _makeClient(_makeDio(adapter));

      final page = await client.list();
      expect(page.items, hasLength(2));
      expect(page.items.first.id, 'aal-1');
      expect(page.items.first.role, AssetActorRole.owner);
      expect(page.items.last.role, AssetActorRole.tenant);
      expect(page.nextCursor, 'OPAQUE-CURSOR');
    });

    test('omite query keys nulos para no ensuciar el endpoint', () async {
      final adapter = _FakeAdapter()
        ..responseBody = {'items': [], 'nextCursor': null};
      final client = _makeClient(_makeDio(adapter));

      await client.list();
      expect(adapter.captured!.queryParameters, isEmpty);
    });

    test('4xx con body { code, message } preserva el code', () async {
      final req = RequestOptions(path: '/v1/core-common/asset-actor-links');
      final adapter = _FakeAdapter()
        ..willThrow = DioException(
          requestOptions: req,
          response: Response(
            requestOptions: req,
            statusCode: 400,
            data: {'code': 'INVALID_CURSOR', 'message': 'cursor corrupto'},
          ),
          type: DioExceptionType.badResponse,
        );
      final client = _makeClient(_makeDio(adapter));

      final err = await client.list().then<Object?>((_) => null).catchError(
            (e) => e as Object,
          );
      expect(err, isA<BadRequestException>());
      final be = err as BadRequestException;
      expect(be.statusCode, 400);
      expect(be.code, 'INVALID_CURSOR');
      expect(be.message, 'cursor corrupto');
    });
  });

  group('AssetActorLinkApiClient.findById', () {
    test('GET /:id devuelve entity', () async {
      final adapter = _FakeAdapter()..responseBody = _linkFixture(id: 'aal-9');
      final client = _makeClient(_makeDio(adapter));

      final link = await client.findById('aal-9');
      expect(link.id, 'aal-9');
      expect(adapter.captured!.path, '/v1/core-common/asset-actor-links/aal-9');
      expect(adapter.captured!.method, 'GET');
    });

    test('404 → BadRequestException con code preservado', () async {
      final req = RequestOptions(path: '/v1/core-common/asset-actor-links/x');
      final adapter = _FakeAdapter()
        ..willThrow = DioException(
          requestOptions: req,
          response: Response(
            requestOptions: req,
            statusCode: 404,
            data: {
              'code': 'ASSET_ACTOR_LINK_NOT_FOUND',
              'message': 'no existe',
            },
          ),
          type: DioExceptionType.badResponse,
        );
      final client = _makeClient(_makeDio(adapter));

      final err = await client
          .findById('x')
          .then<Object?>((_) => null)
          .catchError((e) => e as Object);
      expect(err, isA<BadRequestException>());
      expect((err as BadRequestException).code, 'ASSET_ACTOR_LINK_NOT_FOUND');
    });
  });
}
