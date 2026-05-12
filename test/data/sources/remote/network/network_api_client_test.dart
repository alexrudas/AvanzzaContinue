// ============================================================================
// test/data/sources/remote/network/network_api_client_test.dart
// NetworkApiClient — HTTP contra contrato congelado de Mi Red Operativa v1
// ============================================================================
// Cubre:
//   - GET /v1/network: query con filtros + Authorization + parseo envelope.
//   - GET /v1/network: paginación con cursor + isLastPage cuando nextCursor=null.
//   - 401 → UnauthorizedException.
//   - 403 → ForbiddenException (separación obligatoria de 401).
//   - 5xx → ServerException.
//   - 4xx con `code` → BadRequestException(code: ...).
//   - schemaVersion!=1 → UnsupportedSchemaVersionException.
//   - Sin token → UnauthorizedException antes del request.
//   - GET /v1/network/categories/summary.
// ============================================================================

import 'dart:convert';

import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_category.dart';
import 'package:avanzza/data/models/network/unsupported_schema_version_exception.dart';
import 'package:avanzza/data/sources/remote/network/network_api_client.dart';
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

NetworkApiClient _client(Dio dio, {String? token = 'tk'}) =>
    NetworkApiClient(dio: dio, getIdToken: () async => token);

Map<String, dynamic> _validActor({String ref = 'platform:p-1'}) => {
      'ref': ref,
      'displayName': 'Taller Central',
      'avatarRef': null,
      'unresolved': false,
      'categories': ['workshop'],
      'primaryCategory': 'workshop',
      'isTeamMember': false,
      'isRestricted': false,
      'restrictionReason': null,
      'primaryPhoneE164': '+573001112233',
      'primaryEmail': 'x@y.co',
      'hasWhatsApp': true,
      'relationshipState': 'vinculada',
      'providerProfileId': null,
      'availableActions': const [],
      'updatedAt': '2026-05-01T10:00:00.000Z',
    };

Map<String, dynamic> _validEnvelope({
  List<Map<String, dynamic>>? items,
  String? nextCursor,
}) =>
    {
      // /v1/network emite schemaVersion=2 (kNetworkSchemaVersion).
      'schemaVersion': 2,
      'items': items ?? [_validActor()],
      'nextCursor': nextCursor,
      'serverTime': '2026-05-01T10:00:00.000Z',
    };

DioException _httpError({
  required int status,
  Map<String, dynamic>? body,
}) {
  final req = RequestOptions(path: '/v1/network');
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
  group('NetworkApiClient.list — request canónico', () {
    test('envía Authorization Bearer + path + sin query si no hay filtros',
        () async {
      final a = _FakeAdapter()..responseBody = _validEnvelope(items: const []);
      final c = _client(_dio(a));

      await c.list();

      final req = a.captured!;
      expect(req.method, 'GET');
      expect(req.path, '/v1/network');
      expect(req.queryParameters, isEmpty);
      expect(req.headers['Authorization'], 'Bearer tk');
    });

    test('envía todos los filtros wire-stable', () async {
      final a = _FakeAdapter()..responseBody = _validEnvelope(items: const []);
      final c = _client(_dio(a));

      await c.list(
        category: NetworkCategory.workshop,
        state: NetworkRelationshipState.vinculada,
        assetId: 'asset-99',
        cursor: 'CUR-XYZ',
        limit: 25,
      );

      expect(a.captured!.queryParameters, {
        'category': 'workshop',
        'state': 'vinculada',
        'assetId': 'asset-99',
        'cursor': 'CUR-XYZ',
        'limit': 25,
      });
    });

    test('omite filtros null (no envía clave)', () async {
      final a = _FakeAdapter()..responseBody = _validEnvelope(items: const []);
      final c = _client(_dio(a));

      await c.list(category: NetworkCategory.provider, limit: 10);

      expect(a.captured!.queryParameters, {
        'category': 'provider',
        'limit': 10,
      });
    });
  });

  group('NetworkApiClient.list — parseo envelope', () {
    test('200 con items + nextCursor parsea correctamente', () async {
      final a = _FakeAdapter()
        ..responseBody = _validEnvelope(
          items: [_validActor(ref: 'platform:p-1'), _validActor(ref: 'local:contact:lc-9')],
          nextCursor: 'NEXT',
        );
      final c = _client(_dio(a));

      final env = await c.list();

      expect(env.schemaVersion, 2);
      expect(env.items, hasLength(2));
      expect(env.items[0].ref.id, 'p-1');
      expect(env.items[1].ref.id, 'lc-9');
      expect(env.nextCursor, 'NEXT');
      expect(env.isLastPage, isFalse);
    });

    test('nextCursor=null marca última página', () async {
      final a = _FakeAdapter()
        ..responseBody = _validEnvelope(items: const [], nextCursor: null);
      final c = _client(_dio(a));

      final env = await c.list();
      expect(env.isLastPage, isTrue);
      expect(env.items, isEmpty);
    });

    test('schemaVersion=999 lanza UnsupportedSchemaVersionException', () async {
      // Cualquier versión no esperada por el cliente lanza tipado.
      // Network actualmente espera v2; usamos 999 para evitar acoplar el
      // test al valor concreto.
      final a = _FakeAdapter()
        ..responseBody = {
          'schemaVersion': 999,
          'items': const [],
          'nextCursor': null,
          'serverTime': '2026-05-01T10:00:00.000Z',
        };
      final c = _client(_dio(a));

      await expectLater(
        c.list(),
        throwsA(isA<UnsupportedSchemaVersionException>()
            .having((e) => e.received, 'received', 999)
            .having((e) => e.endpoint, 'endpoint', 'GET /v1/network')),
      );
    });

    test('respuesta no-Map lanza ServerException', () async {
      final a = _FakeAdapter()
        ..responseBody = ['not', 'an', 'object'];
      final c = _client(_dio(a));

      await expectLater(c.list(), throwsA(isA<ServerException>()));
    });
  });

  group('NetworkApiClient.list — separación 401 vs 403', () {
    test('401 → UnauthorizedException (sesión inválida)', () async {
      final a = _FakeAdapter()
        ..willThrow = _httpError(
          status: 401,
          body: {'message': 'Invalid token'},
        );
      final c = _client(_dio(a));

      await expectLater(
        c.list(),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('403 → ForbiddenException (capability network.read ausente)', () async {
      final a = _FakeAdapter()
        ..willThrow = _httpError(
          status: 403,
          body: {
            'message': 'Missing capability',
            'code': 'CAPABILITY_MISSING',
          },
        );
      final c = _client(_dio(a));

      await expectLater(
        c.list(),
        throwsA(isA<ForbiddenException>()),
      );
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

  group('NetworkApiClient.list — otros errores HTTP', () {
    test('500 → ServerException', () async {
      final a = _FakeAdapter()..willThrow = _httpError(status: 500);
      final c = _client(_dio(a));
      await expectLater(c.list(), throwsA(isA<ServerException>()));
    });

    test('400 con code preserva el code', () async {
      final a = _FakeAdapter()
        ..willThrow = _httpError(
          status: 400,
          body: {'message': 'Cursor opaco inválido', 'code': 'INVALID_CURSOR'},
        );
      final c = _client(_dio(a));

      await expectLater(
        c.list(cursor: 'corrupted'),
        throwsA(isA<BadRequestException>()
            .having((e) => e.statusCode, 'statusCode', 400)
            .having((e) => e.code, 'code', 'INVALID_CURSOR')),
      );
    });

    test('sin respuesta HTTP (timeout) → NetworkException', () async {
      final req = RequestOptions(path: '/v1/network');
      final a = _FakeAdapter()
        ..willThrow = DioException(
          requestOptions: req,
          type: DioExceptionType.connectionTimeout,
          message: 'timeout',
        );
      final c = _client(_dio(a));

      await expectLater(c.list(), throwsA(isA<NetworkException>()));
    });
  });

  group('NetworkApiClient — sin token', () {
    test('getIdToken null → UnauthorizedException sin tocar HTTP', () async {
      final a = _FakeAdapter()..responseBody = _validEnvelope();
      final c = _client(_dio(a), token: null);

      await expectLater(c.list(), throwsA(isA<UnauthorizedException>()));
      expect(a.captured, isNull, reason: 'no debió llegar al adapter');
    });

    test('getIdToken vacío → UnauthorizedException', () async {
      final a = _FakeAdapter()..responseBody = _validEnvelope();
      final c = _client(_dio(a), token: '');

      await expectLater(c.list(), throwsA(isA<UnauthorizedException>()));
      expect(a.captured, isNull);
    });
  });

  group('NetworkApiClient.getCategoriesSummary', () {
    test('200 parsea schemaVersion + externalActiveCount', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'schemaVersion': 2,
          'externalActiveCount': 17,
          'serverTime': '2026-05-01T10:00:00.000Z',
        };
      final c = _client(_dio(a));

      final env = await c.getCategoriesSummary();
      expect(env.externalActiveCount, 17);
      expect(a.captured!.path, '/v1/network/categories/summary');
    });

    test('schemaVersion incompatible lanza tipado', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'schemaVersion': 99,
          'externalActiveCount': 0,
          'serverTime': '2026-05-01T10:00:00.000Z',
        };
      final c = _client(_dio(a));

      await expectLater(
        c.getCategoriesSummary(),
        throwsA(isA<UnsupportedSchemaVersionException>()),
      );
    });

    test('403 → ForbiddenException', () async {
      final a = _FakeAdapter()..willThrow = _httpError(status: 403);
      final c = _client(_dio(a));

      await expectLater(
        c.getCategoriesSummary(),
        throwsA(isA<ForbiddenException>()),
      );
    });
  });
}
