// ============================================================================
// test/data/sources/remote/provider/provider_canonical_api_client_test.dart
// ProviderCanonicalApiClient — HTTP contra Hito 1 (Avanzza Core API)
// ============================================================================
// Cubre:
//   - HEADERS / METHOD / PATH / BODY de los 3 endpoints:
//       * POST  /v1/providers          (provision)
//       * GET   /v1/providers/:id      (getById)
//       * PUT   /v1/providers/:id/specialties (replaceSpecialties)
//   - Authorization: Bearer <token> en cada request.
//   - Sin token → UnauthorizedException sin tocar Dio.
//   - Mapeo canónico de DioException → excepciones tipadas:
//       * 404 LOCAL_REF_NOT_FOUND      → LocalRefNotFoundException
//       * 404 PROVIDER_PROFILE_NOT_FOUND → ProviderProfileNotFoundException
//       * 404 WORKSPACE_NOT_FOUND      → WorkspaceNotFoundException
//       * 409 AMBIGUOUS_PLATFORM_ACTOR_MATCH → AmbiguousPlatformActorException
//         con `candidates` parseados (preserva displayName + matchedKeys).
//       * 401/403                       → UnauthorizedException
//       * 5xx                           → ServerException
//       * 4xx genérico con `code`       → BadRequestException(code preservado)
//       * DioExceptionType.cancel       → RequestCancelledException
//       * Sin response (network)        → NetworkException
//   - Body inválido del response (campos faltantes) → ServerException
//     (FormatException atrapada).
//   - PUT response con shape parcial → fallback a GET (verifica que el
//     parser tolera el doble formato).
// ============================================================================

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:avanzza/data/sources/remote/provider/provider_canonical_api_client.dart';
import 'package:avanzza/domain/entities/provider/provider_canonical_entity.dart';
import 'package:avanzza/domain/errors/remote_exceptions.dart';
import 'package:avanzza/domain/repositories/provider/provider_canonical_repository.dart';
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

// ─── Fake adapter scriptable ────────────────────────────────────────────────
//
// Acepta una secuencia de respuestas (List). Cada `fetch()` consume la
// siguiente. Permite testear el fallback PUT-parcial → GET-completo en una
// sola corrida.

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

class _FakeResponseScript {
  final dynamic body;
  final DioException? willThrow;
  _FakeResponseScript({
    this.body,
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

ProviderCanonicalApiClient _makeClient(
  Dio dio, {
  String? token = 'tk',
}) =>
    ProviderCanonicalApiClient(
      dio: dio,
      getIdToken: () async => token,
    );

Map<String, dynamic> _validResponse({Map<String, dynamic>? overrides}) {
  return {
    'providerProfileId': 'pp-1',
    'workspaceId': 'ws-1',
    'platformActorId': 'pa-1',
    'displayName': 'Lubricentro X',
    'actorKind': 'organization',
    'legalName': 'Lubricentro X SAS',
    'fullLegalName': null,
    'isActive': true,
    'responseRateAvg': null,
    'notes': null,
    'specialties': const [],
    'createdAt': '2026-04-26T12:00:00.000Z',
    'updatedAt': '2026-04-26T12:05:00.000Z',
    ...?overrides,
  };
}

DioException _badResponse({
  required String path,
  required int statusCode,
  required Map<String, dynamic> body,
}) {
  final req = RequestOptions(path: path);
  return DioException(
    requestOptions: req,
    response: Response(
      requestOptions: req,
      statusCode: statusCode,
      data: body,
    ),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  // ════════════════════════════════════════════════════════════════════════
  // POST /v1/providers (provision)
  // ════════════════════════════════════════════════════════════════════════

  group('ProviderCanonicalApiClient.provision', () {
    test('POST con body shape correcto + Bearer header', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(body: _validResponse()));
      final client = _makeClient(_makeDio(adapter));

      await client.provision(ProvisionProviderInput(
        source: ProvisionProviderSource.localContact(localId: 'lc-1'),
        identity: const ProvisionProviderIdentity(
          displayName: 'Lubricentro X',
          actorKind: ProviderActorKind.organization,
          legalName: 'Lubricentro X SAS',
        ),
      ));

      final req = adapter.captured.single;
      expect(req.method, 'POST');
      expect(req.path, '/v1/providers');
      expect(req.headers['Authorization'], 'Bearer tk');
      expect(req.data, isA<Map<String, dynamic>>());
      final m = req.data as Map<String, dynamic>;
      expect(m['source']['kind'], 'LOCAL_CONTACT');
      expect(m['identity']['displayName'], 'Lubricentro X');
    });

    test('parsea response a entity correctamente', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(body: _validResponse(overrides: {
          'providerProfileId': 'pp-7',
          'specialties': [
            {'id': 'sp-1', 'key': 'k', 'name': 'A', 'kind': 'SERVICE'}
          ],
        })));
      final client = _makeClient(_makeDio(adapter));

      final out = await client.provision(ProvisionProviderInput(
        source: ProvisionProviderSource.localContact(localId: 'lc-1'),
        identity: const ProvisionProviderIdentity(
          displayName: 'Acme',
          actorKind: ProviderActorKind.organization,
          legalName: 'Acme SAS',
        ),
      ));

      expect(out.providerProfileId, 'pp-7');
      expect(out.actorKind, ProviderActorKind.organization);
      expect(out.specialties, hasLength(1));
      expect(out.specialties.single.id, 'sp-1');
    });

    test('sin token → UnauthorizedException sin tocar Dio', () async {
      final adapter = _FakeAdapter();
      final client = _makeClient(_makeDio(adapter), token: null);

      await expectLater(
        client.provision(ProvisionProviderInput(
          source: ProvisionProviderSource.localContact(localId: 'lc-1'),
          identity: const ProvisionProviderIdentity(
            displayName: 'X',
            actorKind: ProviderActorKind.organization,
            legalName: 'X',
          ),
        )),
        throwsA(isA<UnauthorizedException>()),
      );
      // Importantísimo: Dio NUNCA debe haberse invocado (cero captures).
      expect(adapter.captured, isEmpty);
    });

    test('body inválido (sin providerProfileId) → ServerException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(body: const {'workspaceId': 'ws-1'}));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        client.provision(ProvisionProviderInput(
          source: ProvisionProviderSource.localContact(localId: 'lc-1'),
          identity: const ProvisionProviderIdentity(
            displayName: 'X',
            actorKind: ProviderActorKind.organization,
            legalName: 'X',
          ),
        )),
        throwsA(isA<ServerException>()),
      );
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // GET /v1/providers/:id
  // ════════════════════════════════════════════════════════════════════════

  group('ProviderCanonicalApiClient.getById', () {
    test('GET con path correcto + Bearer', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(body: _validResponse()));
      final client = _makeClient(_makeDio(adapter));

      await client.getById('pp-99');

      final req = adapter.captured.single;
      expect(req.method, 'GET');
      expect(req.path, '/v1/providers/pp-99');
      expect(req.headers['Authorization'], 'Bearer tk');
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // PUT /v1/providers/:id/specialties
  // ════════════════════════════════════════════════════════════════════════

  group('ProviderCanonicalApiClient.replaceSpecialties', () {
    test('PUT con specialtyIds + providerProfileUpdatedAt en body', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(body: _validResponse(overrides: {
          'specialties': [
            {'id': 'sp-1', 'key': 'k', 'name': 'A', 'kind': 'SERVICE'}
          ],
        })));
      final client = _makeClient(_makeDio(adapter));

      await client.replaceSpecialties(
        providerProfileId: 'pp-1',
        specialtyIds: {'sp-1', 'sp-2'},
        providerProfileUpdatedAt: DateTime.utc(2026, 4, 26, 12, 0, 0),
      );

      final req = adapter.captured.single;
      expect(req.method, 'PUT');
      expect(req.path, '/v1/providers/pp-1/specialties');
      final body = req.data as Map<String, dynamic>;
      expect((body['specialtyIds'] as List).toSet(), {'sp-1', 'sp-2'});
      expect(body['providerProfileUpdatedAt'], '2026-04-26T12:00:00.000Z');
    });

    test('shape parcial del PUT → fallback a GET para hidratar', () async {
      // Backend (en algunos paths) devuelve solo {providerProfileId,
      // specialties, updatedAt} en el PUT. El client detecta shape
      // parcial y dispara un GET subsecuente al provider para hidratar
      // la entity completa.
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(body: const {
          'providerProfileId': 'pp-1',
          'specialties': [
            {'id': 'sp-1', 'key': 'k', 'name': 'A', 'kind': 'SERVICE'}
          ],
          'updatedAt': '2026-04-26T12:30:00.000Z',
        }))
        ..enqueue(_FakeResponseScript(body: _validResponse(overrides: {
          'updatedAt': '2026-04-26T12:30:00.000Z',
          'specialties': [
            {'id': 'sp-1', 'key': 'k', 'name': 'A', 'kind': 'SERVICE'}
          ],
        })));
      final client = _makeClient(_makeDio(adapter));

      final out = await client.replaceSpecialties(
        providerProfileId: 'pp-1',
        specialtyIds: {'sp-1'},
        providerProfileUpdatedAt: DateTime.utc(2026, 4, 26, 12, 0, 0),
      );

      // 2 requests: PUT + GET de hidratación.
      expect(adapter.captured, hasLength(2));
      expect(adapter.captured[0].method, 'PUT');
      expect(adapter.captured[1].method, 'GET');
      expect(adapter.captured[1].path, '/v1/providers/pp-1');
      expect(out.providerProfileId, 'pp-1');
      expect(out.displayName, 'Lubricentro X'); // hidratado del GET
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // ERROR MAPPING
  // ════════════════════════════════════════════════════════════════════════

  group('ProviderCanonicalApiClient — error mapping', () {
    test('404 LOCAL_REF_NOT_FOUND → LocalRefNotFoundException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: _badResponse(
            path: '/v1/providers',
            statusCode: 404,
            body: {
              'code': 'LOCAL_REF_NOT_FOUND',
              'message': 'no attestation',
            },
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        client.provision(ProvisionProviderInput(
          source: ProvisionProviderSource.localContact(localId: 'lc-x'),
          identity: const ProvisionProviderIdentity(
            displayName: 'X',
            actorKind: ProviderActorKind.organization,
            legalName: 'X',
          ),
        )),
        throwsA(isA<LocalRefNotFoundException>()),
      );
    });

    test('404 PROVIDER_PROFILE_NOT_FOUND → ProviderProfileNotFoundException',
        () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: _badResponse(
            path: '/v1/providers/pp-x',
            statusCode: 404,
            body: {
              'code': 'PROVIDER_PROFILE_NOT_FOUND',
              'message': 'gone',
            },
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        client.getById('pp-x'),
        throwsA(isA<ProviderProfileNotFoundException>()),
      );
    });

    test('404 WORKSPACE_NOT_FOUND → WorkspaceNotFoundException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: _badResponse(
            path: '/v1/providers',
            statusCode: 404,
            body: {
              'code': 'WORKSPACE_NOT_FOUND',
              'message': 'no workspace',
            },
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        client.provision(ProvisionProviderInput(
          source: ProvisionProviderSource.localContact(localId: 'lc-1'),
          identity: const ProvisionProviderIdentity(
            displayName: 'X',
            actorKind: ProviderActorKind.organization,
            legalName: 'X',
          ),
        )),
        throwsA(isA<WorkspaceNotFoundException>()),
      );
    });

    test(
        '409 AMBIGUOUS_PLATFORM_ACTOR_MATCH → '
        'AmbiguousPlatformActorException con candidates parseados', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: _badResponse(
            path: '/v1/providers',
            statusCode: 409,
            body: {
              'code': 'AMBIGUOUS_PLATFORM_ACTOR_MATCH',
              'message': 'multiple matches',
              'candidates': [
                {
                  'platformActorId': 'pa-A',
                  'displayName': 'Lubricentro Alfa',
                  'matchedKeys': ['phoneE164'],
                },
                {
                  'platformActorId': 'pa-B',
                  'displayName': 'Lubricentro Beta',
                  'matchedKeys': ['docId', 'email'],
                },
              ],
            },
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      AmbiguousPlatformActorException? captured;
      try {
        await client.provision(ProvisionProviderInput(
          source: ProvisionProviderSource.localContact(localId: 'lc-1'),
          identity: const ProvisionProviderIdentity(
            displayName: 'X',
            actorKind: ProviderActorKind.organization,
            legalName: 'X',
          ),
        ));
      } on AmbiguousPlatformActorException catch (e) {
        captured = e;
      }

      expect(captured, isNotNull);
      expect(captured!.candidates, hasLength(2));
      expect(captured.candidates[0].platformActorId, 'pa-A');
      expect(captured.candidates[0].displayName, 'Lubricentro Alfa');
      expect(captured.candidates[0].matchedKeys, ['phoneE164']);
      expect(captured.candidates[1].matchedKeys, ['docId', 'email']);
    });

    test('409 AMBIGUOUS sin candidates en body → exception con lista vacía',
        () async {
      // Robustez: si el backend cambia y omite `candidates`, parseamos
      // como lista vacía sin crash.
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: _badResponse(
            path: '/v1/providers',
            statusCode: 409,
            body: {
              'code': 'AMBIGUOUS_PLATFORM_ACTOR_MATCH',
              'message': 'malformed',
            },
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      AmbiguousPlatformActorException? captured;
      try {
        await client.provision(ProvisionProviderInput(
          source: ProvisionProviderSource.localContact(localId: 'lc-1'),
          identity: const ProvisionProviderIdentity(
            displayName: 'X',
            actorKind: ProviderActorKind.organization,
            legalName: 'X',
          ),
        ));
      } on AmbiguousPlatformActorException catch (e) {
        captured = e;
      }

      expect(captured, isNotNull);
      expect(captured!.candidates, isEmpty);
    });

    test('401 → UnauthorizedException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: _badResponse(
            path: '/v1/providers/pp-1',
            statusCode: 401,
            body: {'code': 'UNAUTHENTICATED', 'message': 'token expired'},
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        client.getById('pp-1'),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('403 → UnauthorizedException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: _badResponse(
            path: '/v1/providers/pp-1',
            statusCode: 403,
            body: {'code': 'FORBIDDEN', 'message': 'cross-workspace'},
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        client.getById('pp-1'),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('5xx → ServerException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: _badResponse(
            path: '/v1/providers',
            statusCode: 503,
            body: {'message': 'gateway'},
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        client.provision(ProvisionProviderInput(
          source: ProvisionProviderSource.localContact(localId: 'lc-1'),
          identity: const ProvisionProviderIdentity(
            displayName: 'X',
            actorKind: ProviderActorKind.organization,
            legalName: 'X',
          ),
        )),
        throwsA(isA<ServerException>()),
      );
    });

    test('400 con `code` preservado → BadRequestException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: _badResponse(
            path: '/v1/providers',
            statusCode: 400,
            body: {
              'code': 'INVALID_ACTOR_IDENTITY',
              'message': 'person no debe tener legalName',
            },
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      try {
        await client.provision(ProvisionProviderInput(
          source: ProvisionProviderSource.localContact(localId: 'lc-1'),
          identity: const ProvisionProviderIdentity(
            displayName: 'X',
            actorKind: ProviderActorKind.organization,
            legalName: 'X',
          ),
        ));
        fail('Expected BadRequestException');
      } on BadRequestException catch (e) {
        expect(e.statusCode, 400);
        expect(e.code, 'INVALID_ACTOR_IDENTITY');
        expect(e.message, contains('legalName'));
      }
    });

    test('DioExceptionType.cancel → RequestCancelledException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: DioException(
            requestOptions: RequestOptions(path: '/v1/providers'),
            type: DioExceptionType.cancel,
            message: 'cancelled',
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        client.provision(ProvisionProviderInput(
          source: ProvisionProviderSource.localContact(localId: 'lc-1'),
          identity: const ProvisionProviderIdentity(
            displayName: 'X',
            actorKind: ProviderActorKind.organization,
            legalName: 'X',
          ),
        )),
        throwsA(isA<RequestCancelledException>()),
      );
    });

    test('DioException sin response (network) → NetworkException', () async {
      final adapter = _FakeAdapter()
        ..enqueue(_FakeResponseScript(
          willThrow: DioException(
            requestOptions: RequestOptions(path: '/v1/providers'),
            type: DioExceptionType.connectionError,
            message: 'connection refused',
          ),
        ));
      final client = _makeClient(_makeDio(adapter));

      await expectLater(
        client.provision(ProvisionProviderInput(
          source: ProvisionProviderSource.localContact(localId: 'lc-1'),
          identity: const ProvisionProviderIdentity(
            displayName: 'X',
            actorKind: ProviderActorKind.organization,
            legalName: 'X',
          ),
        )),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
