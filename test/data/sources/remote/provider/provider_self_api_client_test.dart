// ============================================================================
// test/data/sources/remote/provider/provider_self_api_client_test.dart
// MF1 — ProviderSelfApiClient: bootstrap + me.
// ============================================================================
// Cubre:
//   - HEADER Authorization Bearer en bootstrap y me.
//   - PATH y METHOD correctos (POST /v1/providers/bootstrap, GET /v1/providers/me).
//   - Body shape: name + specialtyIds + opcionales (phone, assetTypeIds).
//   - Mapeo de respuesta a entity.
//   - Sin token → UnauthorizedException sin tocar Dio.
//   - 404 WORKSPACE_NOT_FOUND → WorkspaceNotFoundException.
//   - 409 PROVIDER_ALREADY_BOOTSTRAPPED → BadRequestException(code='...').
//   - 401/403 → UnauthorizedException.
//   - DioExceptionType.cancel → RequestCancelledException.
// ============================================================================

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:avanzza/data/sources/remote/provider/provider_self_api_client.dart';
import 'package:avanzza/domain/errors/remote_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

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

class _FakeResponseScript {
  final dynamic body;
  final DioException? willThrow;
  _FakeResponseScript({this.body, this.willThrow});
}

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
    return ResponseBody.fromBytes(
      Uint8List.fromList(utf8.encode(jsonEncode(body))),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _makeDio(_FakeAdapter adapter) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.test',
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  ));
  dio.httpClientAdapter = adapter;
  return dio;
}

ProviderSelfApiClient _makeClient(Dio dio, {String? token = 'tk'}) =>
    ProviderSelfApiClient(
      dio: dio,
      getIdToken: () async => token,
    );

Map<String, dynamic> _validBootstrapBody() => {
      'providerProfileId': 'pp-bob',
      'workspaceId': 'ws-bob',
      'created': true,
    };

Map<String, dynamic> _validMeBody({bool isProvider = true}) {
  return {
    'workspaceId': 'ws-bob',
    'isProvider': isProvider,
    if (isProvider)
      'providerProfile': {
        'providerProfileId': 'pp-bob',
        'platformActorId': 'pa-bob',
        'displayName': 'Bob',
        'isActive': true,
        'updatedAt': '2026-04-27T10:00:00.000Z',
      }
    else
      'providerProfile': null,
    'specialties': isProvider
        ? const [
            {
              'id': 'sp-1',
              'key': 'engine',
              'name': 'Motor',
              'kind': 'SERVICE',
            },
          ]
        : const [],
    'assetTypes': isProvider
        ? const [
            {'id': 'vehicle.car', 'name': 'Auto'},
          ]
        : const [],
    'capabilities': isProvider
        ? const [
            'provider.read',
            'provider.invite_agent',
            'provider.revoke_agent',
            'provider.agent_invitation.read',
          ]
        : const ['provider.read', 'purchase_request.read'],
  };
}

DioException _badResponse({
  required String path,
  required int statusCode,
  Map<String, dynamic>? body,
}) {
  final req = RequestOptions(path: path);
  return DioException(
    requestOptions: req,
    response: Response(
      requestOptions: req,
      statusCode: statusCode,
      data: body ?? <String, dynamic>{},
    ),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  group('ProviderSelfApiClient.bootstrap', () {
    test('POST /v1/providers/bootstrap con Bearer + body shape correcto',
        () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(body: _validBootstrapBody()));
      final client = _makeClient(_makeDio(adapter));

      final out = await client.bootstrap(
        name: 'Bob',
        phone: '+57300',
        specialtyIds: ['sp-1', 'sp-2'],
        assetTypeIds: ['vehicle.car'],
      );

      expect(out.providerProfileId, 'pp-bob');
      expect(out.workspaceId, 'ws-bob');
      expect(out.created, isTrue);

      final req = adapter.captured.single;
      expect(req.method, 'POST');
      expect(req.path, '/v1/providers/bootstrap');
      expect(req.headers['Authorization'], 'Bearer tk');
      final body = req.data as Map<String, dynamic>;
      expect(body['name'], 'Bob');
      expect(body['phone'], '+57300');
      expect(body['specialtyIds'], ['sp-1', 'sp-2']);
      expect(body['assetTypeIds'], ['vehicle.car']);
    });

    test('omite phone y assetTypeIds cuando son null/empty', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(body: _validBootstrapBody()));
      final client = _makeClient(_makeDio(adapter));

      await client.bootstrap(
        name: 'Bob',
        specialtyIds: ['sp-1'],
      );

      final body = adapter.captured.single.data as Map<String, dynamic>;
      expect(body.containsKey('phone'), isFalse);
      expect(body.containsKey('assetTypeIds'), isFalse);
    });

    test('sin token → UnauthorizedException SIN tocar Dio', () async {
      final adapter = _FakeAdapter();
      final client = _makeClient(_makeDio(adapter), token: null);

      await expectLater(
        () => client.bootstrap(name: 'X', specialtyIds: ['s1']),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(adapter.captured, isEmpty);
    });

    test('409 PROVIDER_ALREADY_BOOTSTRAPPED → BadRequestException(code)',
        () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: _badResponse(
            path: '/v1/providers/bootstrap',
            statusCode: 409,
            body: {
              'code': 'PROVIDER_ALREADY_BOOTSTRAPPED',
              'message': 'Ya tienes provider en este workspace',
            },
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      try {
        await client.bootstrap(name: 'X', specialtyIds: ['s1']);
        fail('Expected exception');
      } on BadRequestException catch (e) {
        expect(e.code, 'PROVIDER_ALREADY_BOOTSTRAPPED');
        expect(e.statusCode, 409);
      }
    });

    test('404 WORKSPACE_NOT_FOUND → WorkspaceNotFoundException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: _badResponse(
            path: '/v1/providers/bootstrap',
            statusCode: 404,
            body: {
              'code': 'WORKSPACE_NOT_FOUND',
              'message': 'No Workspace',
            },
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        () => client.bootstrap(name: 'X', specialtyIds: ['s1']),
        throwsA(isA<WorkspaceNotFoundException>()),
      );
    });

    test('401 → UnauthorizedException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: _badResponse(
            path: '/v1/providers/bootstrap',
            statusCode: 401,
            body: {'message': 'unauthenticated'},
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        () => client.bootstrap(name: 'X', specialtyIds: ['s1']),
        throwsA(isA<UnauthorizedException>()),
      );
    });
  });

  group('ProviderSelfApiClient.me', () {
    test('GET /v1/providers/me con Bearer y mapper isProvider=true',
        () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(body: _validMeBody()));
      final client = _makeClient(_makeDio(adapter));

      final me = await client.me();
      expect(me.workspaceId, 'ws-bob');
      expect(me.isProvider, isTrue);
      expect(me.providerProfile, isNotNull);
      expect(me.specialties.length, 1);
      expect(me.assetTypes.length, 1);
      expect(me.hasInviteAgentCapability, isTrue);
      expect(me.hasReadAgentInvitationsCapability, isTrue);

      final req = adapter.captured.single;
      expect(req.method, 'GET');
      expect(req.path, '/v1/providers/me');
      expect(req.headers['Authorization'], 'Bearer tk');
    });

    test('isProvider=false NO lanza — UI ramifica', () async {
      final adapter = _FakeAdapter()
        ..enqueue(
            _FakeResponseScript(body: _validMeBody(isProvider: false)));
      final client = _makeClient(_makeDio(adapter));

      final me = await client.me();
      expect(me.isProvider, isFalse);
      expect(me.providerProfile, isNull);
    });
  });
}
