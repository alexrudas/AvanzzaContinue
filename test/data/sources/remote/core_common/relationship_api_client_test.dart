// ============================================================================
// test/data/sources/remote/core_common/relationship_api_client_test.dart
// RelationshipApiClient — HTTP contra hito 3 del ADR actor-canon
// ============================================================================
// Valida:
//   - list: query con filtros + parseo de items + nextCursor.
//   - findById: GET /:id con Authorization.
//   - suspend/reactivate/close: POST con body canónico.
//   - Sin token → UnauthorizedException.
//   - 409 INVALID_TRANSITION preserva `code`.
// ============================================================================

import 'dart:convert';

import 'package:avanzza/data/sources/remote/core_common/nestjs_exceptions.dart';
import 'package:avanzza/data/sources/remote/core_common/relationship_api_client.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_suspension_reason.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _CapturedRequest {
  final String path;
  final Map<String, dynamic> queryParameters;
  final Map<String, dynamic> headers;
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
    return ResponseBody.fromString(
      jsonEncode(responseBody ?? <String, dynamic>{}),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dio(_FakeAdapter a) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.test',
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  ));
  dio.httpClientAdapter = a;
  return dio;
}

RelationshipApiClient _client(Dio dio, {String token = 'tk'}) =>
    RelationshipApiClient(dio: dio, getIdToken: () async => token);

Map<String, dynamic> _relFixture({
  String id = 'rel-1',
  String state = 'vinculada',
  String? suspensionReason,
}) {
  return {
    'id': id,
    'sourceWorkspaceId': 'ws-1',
    'targetLocalKind': 'contact',
    'targetLocalId': 'local-1',
    'targetPlatformActorId': 'pa-1',
    'state': state,
    'relationshipKind': 'generic',
    'stateUpdatedAt': '2026-04-15T00:00:00.000Z',
    'linkedAt': '2026-04-15T00:00:00.000Z',
    'suspendedAt': null,
    'closedAt': null,
    'suspensionReason': suspensionReason,
    'lastInvitationId': null,
    'createdAt': '2026-04-15T00:00:00.000Z',
    'updatedAt': '2026-04-15T00:00:00.000Z',
  };
}

void main() {
  group('RelationshipApiClient.list', () {
    test('envía filtros wire-stable + Authorization', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'items': [_relFixture()],
          'nextCursor': null,
        };
      final c = _client(_dio(a));

      await c.list(
        state: RelationshipState.vinculada,
        cursor: 'CURSOR',
        limit: 25,
      );

      final req = a.captured!;
      expect(req.method, 'GET');
      expect(req.path, '/v1/core-common/relationships');
      expect(req.queryParameters, {
        'state': 'vinculada',
        'cursor': 'CURSOR',
        'limit': 25,
      });
      expect(req.headers['Authorization'], 'Bearer tk');
    });

    test('sin token → UnauthorizedException sin tocar Dio', () async {
      final a = _FakeAdapter();
      final c = RelationshipApiClient(
        dio: _dio(a),
        getIdToken: () async => null,
      );
      await expectLater(c.list(), throwsA(isA<UnauthorizedException>()));
      expect(a.captured, isNull);
    });

    test('parsea items + nextCursor opaco', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'items': [_relFixture(id: 'rel-a'), _relFixture(id: 'rel-b')],
          'nextCursor': 'OPAQUE',
        };
      final c = _client(_dio(a));

      final page = await c.list();
      expect(page.items, hasLength(2));
      expect(page.items.first.id, 'rel-a');
      expect(page.nextCursor, 'OPAQUE');
    });

    test('400 INVALID_CURSOR preserva code', () async {
      final ro = RequestOptions(path: '/v1/core-common/relationships');
      final a = _FakeAdapter()
        ..willThrow = DioException(
          requestOptions: ro,
          response: Response(
            requestOptions: ro,
            statusCode: 400,
            data: {'code': 'INVALID_CURSOR', 'message': 'bad'},
          ),
          type: DioExceptionType.badResponse,
        );
      final c = _client(_dio(a));

      final err = await c.list().then<Object?>((_) => null).catchError(
            (e) => e as Object,
          );
      expect(err, isA<BadRequestException>());
      expect((err as BadRequestException).code, 'INVALID_CURSOR');
    });
  });

  group('RelationshipApiClient.findById', () {
    test('GET /:id', () async {
      final a = _FakeAdapter()..responseBody = _relFixture(id: 'rel-x');
      final c = _client(_dio(a));
      final r = await c.findById('rel-x');
      expect(r.id, 'rel-x');
      expect(a.captured!.path, '/v1/core-common/relationships/rel-x');
    });
  });

  group('RelationshipApiClient.suspend', () {
    test('POST /:id/suspend con body { reason }', () async {
      final a = _FakeAdapter()
        ..responseBody =
            _relFixture(state: 'suspendida', suspensionReason: 'userRequested');
      final c = _client(_dio(a));

      final r = await c.suspend('rel-x', RelationshipSuspensionReason.userRequested);
      expect(r.state, RelationshipState.suspendida);
      expect(a.captured!.method, 'POST');
      expect(a.captured!.path, '/v1/core-common/relationships/rel-x/suspend');
      // El body se envía como Map; Dio lo serializa. Validamos que contiene reason.
      expect(a.captured!.data, {'reason': 'userRequested'});
    });

    test('409 INVALID_TRANSITION preserva code', () async {
      final ro = RequestOptions(
        path: '/v1/core-common/relationships/rel-x/suspend',
      );
      final a = _FakeAdapter()
        ..willThrow = DioException(
          requestOptions: ro,
          response: Response(
            requestOptions: ro,
            statusCode: 409,
            data: {
              'code': 'RELATIONSHIP_INVALID_TRANSITION',
              'message': 'from cerrada no se puede',
            },
          ),
          type: DioExceptionType.badResponse,
        );
      final c = _client(_dio(a));

      final err = await c
          .suspend('rel-x', RelationshipSuspensionReason.userRequested)
          .then<Object?>((_) => null)
          .catchError((e) => e as Object);
      expect(err, isA<BadRequestException>());
      expect(
        (err as BadRequestException).code,
        'RELATIONSHIP_INVALID_TRANSITION',
      );
    });
  });

  group('RelationshipApiClient.reactivate', () {
    test('POST /:id/reactivate con body vacío', () async {
      final a = _FakeAdapter()..responseBody = _relFixture();
      final c = _client(_dio(a));
      await c.reactivate('rel-x');
      expect(a.captured!.method, 'POST');
      expect(
        a.captured!.path,
        '/v1/core-common/relationships/rel-x/reactivate',
      );
      expect(a.captured!.data, <String, dynamic>{});
    });
  });

  group('RelationshipApiClient.close', () {
    test('POST /:id/close sin reason → body vacío', () async {
      final a = _FakeAdapter()..responseBody = _relFixture(state: 'cerrada');
      final c = _client(_dio(a));
      await c.close('rel-x');
      expect(a.captured!.method, 'POST');
      expect(a.captured!.path, '/v1/core-common/relationships/rel-x/close');
      expect(a.captured!.data, <String, dynamic>{});
    });

    test('POST /:id/close con reason → body { reason }', () async {
      final a = _FakeAdapter()
        ..responseBody = _relFixture(
          state: 'cerrada',
          suspensionReason: 'systemPolicy',
        );
      final c = _client(_dio(a));
      await c.close('rel-x', reason: RelationshipSuspensionReason.systemPolicy);
      expect(a.captured!.data, {'reason': 'systemPolicy'});
    });
  });
}
