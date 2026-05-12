// ============================================================================
// test/data/sources/remote/network/team_api_client_test.dart
// TeamApiClient — HTTP del equipo interno (Mi Red Operativa v1)
// ============================================================================
// Cubre:
//   - GET /v1/team con cursor + limit + Authorization.
//   - parseo envelope con TeamMemberSummaryDto.
//   - 401 → UnauthorizedException.
//   - 403 → ForbiddenException (capability team.read ausente).
//   - schemaVersion!=1 → UnsupportedSchemaVersionException.
//   - GET /v1/team/summary.
//   - Sin token → UnauthorizedException sin tocar HTTP.
// ============================================================================

import 'dart:convert';

import 'package:avanzza/data/models/network/unsupported_schema_version_exception.dart';
import 'package:avanzza/data/sources/remote/network/team_api_client.dart';
import 'package:avanzza/domain/errors/remote_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _CapturedRequest {
  final String path;
  final Map<String, dynamic> queryParameters;
  final Map<String, dynamic> headers;
  final String method;
  _CapturedRequest(RequestOptions o)
      : path = o.path,
        queryParameters = Map<String, dynamic>.from(o.queryParameters),
        headers = Map<String, dynamic>.from(o.headers),
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

TeamApiClient _client(Dio dio, {String? token = 'tk'}) =>
    TeamApiClient(dio: dio, getIdToken: () async => token);

Map<String, dynamic> _validMember({
  String ref = 'user:u-1',
  List<String> teamRoleKeys = const [],
}) =>
    {
      'ref': ref,
      'membershipId': 'm-1',
      'displayName': 'Juan',
      'avatarRef': null,
      'teamRoleKeys': teamRoleKeys,
      'primaryPhoneE164': null,
      'primaryEmail': null,
      'hasWhatsApp': false,
      'availableActions': const [],
      'updatedAt': '2026-05-01T10:00:00.000Z',
    };

Map<String, dynamic> _validEnvelope({
  List<Map<String, dynamic>>? items,
  String? nextCursor,
}) =>
    {
      'schemaVersion': 1,
      'items': items ?? [_validMember()],
      'nextCursor': nextCursor,
      'serverTime': '2026-05-01T10:00:00.000Z',
    };

DioException _httpError({required int status, Map<String, dynamic>? body}) {
  final req = RequestOptions(path: '/v1/team');
  return DioException(
    requestOptions: req,
    response: Response<dynamic>(
      requestOptions: req,
      statusCode: status,
      data: body ?? {'message': 'HTTP $status'},
    ),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  group('TeamApiClient.list — request canónico', () {
    test('sin filtros: solo Authorization', () async {
      final a = _FakeAdapter()..responseBody = _validEnvelope(items: const []);
      final c = _client(_dio(a));

      await c.list();

      final req = a.captured!;
      expect(req.method, 'GET');
      expect(req.path, '/v1/team');
      expect(req.queryParameters, isEmpty);
      expect(req.headers['Authorization'], 'Bearer tk');
    });

    test('con cursor + limit', () async {
      final a = _FakeAdapter()..responseBody = _validEnvelope(items: const []);
      final c = _client(_dio(a));

      await c.list(cursor: 'CUR', limit: 10);

      expect(a.captured!.queryParameters, {'cursor': 'CUR', 'limit': 10});
    });
  });

  group('TeamApiClient.list — parseo envelope', () {
    test('200 con miembros parsea correctamente', () async {
      final a = _FakeAdapter()
        ..responseBody = _validEnvelope(
          items: [
            _validMember(ref: 'user:u-1', teamRoleKeys: ['admin']),
            _validMember(ref: 'user:u-2'),
          ],
          nextCursor: 'NEXT',
        );
      final c = _client(_dio(a));

      final env = await c.list();

      expect(env.items, hasLength(2));
      expect(env.items[0].ref.id, 'u-1');
      expect(env.items[0].teamRoleKeys, ['admin']);
      expect(env.items[1].ref.id, 'u-2');
      expect(env.nextCursor, 'NEXT');
    });

    test('última página (nextCursor=null)', () async {
      final a = _FakeAdapter()
        ..responseBody = _validEnvelope(items: const [], nextCursor: null);
      final c = _client(_dio(a));

      final env = await c.list();
      expect(env.isLastPage, isTrue);
    });

    test('schemaVersion=2 lanza UnsupportedSchemaVersionException', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'schemaVersion': 2,
          'items': const [],
          'nextCursor': null,
          'serverTime': '2026-05-01T10:00:00.000Z',
        };
      final c = _client(_dio(a));

      await expectLater(
        c.list(),
        throwsA(isA<UnsupportedSchemaVersionException>()
            .having((e) => e.endpoint, 'endpoint', 'GET /v1/team')),
      );
    });
  });

  group('TeamApiClient.list — separación 401 vs 403', () {
    test('401 → UnauthorizedException', () async {
      final a = _FakeAdapter()..willThrow = _httpError(status: 401);
      final c = _client(_dio(a));
      await expectLater(c.list(), throwsA(isA<UnauthorizedException>()));
    });

    test('403 → ForbiddenException (capability team.read ausente)', () async {
      final a = _FakeAdapter()
        ..willThrow = _httpError(
          status: 403,
          body: {'message': 'Missing capability', 'code': 'CAPABILITY_MISSING'},
        );
      final c = _client(_dio(a));

      await expectLater(c.list(), throwsA(isA<ForbiddenException>()));
    });

    test('403 NO se confunde con 401', () async {
      final a = _FakeAdapter()..willThrow = _httpError(status: 403);
      final c = _client(_dio(a));

      await expectLater(
        c.list(),
        throwsA(isA<ForbiddenException>().having(
          (e) => e is UnauthorizedException,
          'NO es UnauthorizedException',
          isFalse,
        )),
      );
    });
  });

  group('TeamApiClient — sin token', () {
    test('null → UnauthorizedException sin tocar HTTP', () async {
      final a = _FakeAdapter()..responseBody = _validEnvelope();
      final c = _client(_dio(a), token: null);

      await expectLater(c.list(), throwsA(isA<UnauthorizedException>()));
      expect(a.captured, isNull);
    });
  });

  group('TeamApiClient.getSummary', () {
    test('200 parsea activeCount', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'schemaVersion': 1,
          'activeCount': 5,
          'serverTime': '2026-05-01T10:00:00.000Z',
        };
      final c = _client(_dio(a));

      final env = await c.getSummary();
      expect(env.activeCount, 5);
      expect(a.captured!.path, '/v1/team/summary');
    });

    test('403 → ForbiddenException', () async {
      final a = _FakeAdapter()..willThrow = _httpError(status: 403);
      final c = _client(_dio(a));

      await expectLater(c.getSummary(), throwsA(isA<ForbiddenException>()));
    });

    test('schemaVersion incompatible lanza tipado', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'schemaVersion': 0,
          'activeCount': 0,
          'serverTime': '2026-05-01T10:00:00.000Z',
        };
      final c = _client(_dio(a));

      await expectLater(
        c.getSummary(),
        throwsA(isA<UnsupportedSchemaVersionException>()),
      );
    });
  });
}
