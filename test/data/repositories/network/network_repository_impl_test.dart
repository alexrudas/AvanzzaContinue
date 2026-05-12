// ============================================================================
// test/data/repositories/network/network_repository_impl_test.dart
// NetworkRepositoryImpl — delegación pura + propagación de errores
// ============================================================================
// Cubre:
//   - fetchPage delega a NetworkApiClient.list con todos los params.
//   - fetchSummary delega a NetworkApiClient.getCategoriesSummary.
//   - Errores tipados (Forbidden/Unauthorized/Unsupported/etc.) burbujean
//     sin envolver: el dominio ya los conoce.
// ============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:avanzza/data/models/network/network_actor_projection.dart';
import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_category.dart';
import 'package:avanzza/data/models/network/network_section_meta_model.dart';
import 'package:avanzza/data/models/network/unsupported_schema_version_exception.dart';
import 'package:avanzza/data/repositories/network/network_repository_impl.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource.dart';
import 'package:avanzza/data/sources/remote/network/network_api_client.dart';
import 'package:avanzza/domain/errors/remote_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// DS local stub para tests del path legacy (fetchPage / fetchSummary).
/// Los métodos cache-first (watchSection, reconcileFromServer, markSyncFailed)
/// no se invocan en este suite — el suite v2 cubre esos caminos.
class _NoOpNetworkLocalDataSource implements NetworkLocalDataSource {
  @override
  Future<NetworkSectionSnapshot> getSection({
    required String workspaceId,
    bool includeMissing = true,
  }) async =>
      NetworkSectionSnapshot(
        workspaceId: workspaceId,
        actors: const [],
        meta: null,
      );

  @override
  Future<NetworkSectionMetaModel?> getSectionMeta({
    required String workspaceId,
  }) async =>
      null;

  @override
  Stream<NetworkSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) =>
      const Stream.empty();

  @override
  Future<List<NetworkActorProjection>> searchByDisplayName({
    required String workspaceId,
    required String query,
    bool includeMissing = true,
  }) async =>
      const [];

  @override
  Future<ReconcileReport> reconcileFromServer({
    required String workspaceId,
    required List<NetworkActorProjection> incoming,
    required bool isFullSnapshot,
    required int schemaVersion,
    String? nextCursor,
    DateTime? serverTime,
    DateTime? now,
  }) async {
    throw UnimplementedError('not used in legacy fetchPage tests');
  }

  @override
  Future<void> markSyncFailed({
    required String workspaceId,
    required String errorCode,
    DateTime? now,
  }) async {
    throw UnimplementedError('not used in legacy fetchPage tests');
  }
}

class _CapturedRequest {
  final String path;
  final Map<String, dynamic> queryParameters;
  _CapturedRequest(RequestOptions o)
      : path = o.path,
        queryParameters = Map<String, dynamic>.from(o.queryParameters);
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

NetworkRepositoryImpl _repo(_FakeAdapter a) {
  final client = NetworkApiClient(
    dio: _dio(a),
    getIdToken: () async => 'tk',
  );
  return NetworkRepositoryImpl(
    client: client,
    localDataSource: _NoOpNetworkLocalDataSource(),
  );
}

Map<String, dynamic> _validEnvelope() => {
      // /v1/network → schemaVersion=2 (kNetworkSchemaVersion).
      'schemaVersion': 2,
      'items': const <Map<String, dynamic>>[],
      'nextCursor': null,
      'serverTime': '2026-05-01T10:00:00.000Z',
    };

DioException _httpError({required int status, Map<String, dynamic>? body}) {
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
  group('NetworkRepositoryImpl.fetchPage — delegación', () {
    test('llama al endpoint correcto sin filtros', () async {
      final a = _FakeAdapter()..responseBody = _validEnvelope();
      final repo = _repo(a);

      await repo.fetchPage();

      expect(a.captured!.path, '/v1/network');
      expect(a.captured!.queryParameters, isEmpty);
    });

    test('propaga todos los filtros al cliente', () async {
      final a = _FakeAdapter()..responseBody = _validEnvelope();
      final repo = _repo(a);

      await repo.fetchPage(
        category: NetworkCategory.workshop,
        state: NetworkRelationshipState.suspendida,
        assetId: 'asset-9',
        cursor: 'CUR-1',
        limit: 25,
      );

      expect(a.captured!.queryParameters, {
        'category': 'workshop',
        'state': 'suspendida',
        'assetId': 'asset-9',
        'cursor': 'CUR-1',
        'limit': 25,
      });
    });

    test('retorna el envelope tal como lo emite el cliente', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'schemaVersion': 2,
          'items': [
            {
              'ref': 'platform:p-1',
              'displayName': 'Taller',
              'avatarRef': null,
              'unresolved': false,
              'categories': ['workshop'],
              'primaryCategory': 'workshop',
              'isTeamMember': false,
              'isRestricted': false,
              'restrictionReason': null,
              'primaryPhoneE164': null,
              'primaryEmail': null,
              'hasWhatsApp': false,
              'relationshipState': 'vinculada',
              'providerProfileId': null,
              'availableActions': const [],
              'updatedAt': '2026-05-01T10:00:00.000Z',
            }
          ],
          'nextCursor': 'NEXT',
          'serverTime': '2026-05-01T10:00:00.000Z',
        };
      final repo = _repo(a);

      final env = await repo.fetchPage();
      expect(env.items, hasLength(1));
      expect(env.items.first.ref.id, 'p-1');
      expect(env.nextCursor, 'NEXT');
      expect(env.isLastPage, isFalse);
    });
  });

  group('NetworkRepositoryImpl — propagación de errores (sin envolver)', () {
    test('403 burbuja como ForbiddenException', () async {
      final a = _FakeAdapter()..willThrow = _httpError(status: 403);
      final repo = _repo(a);
      await expectLater(repo.fetchPage(), throwsA(isA<ForbiddenException>()));
    });

    test('401 burbuja como UnauthorizedException', () async {
      final a = _FakeAdapter()..willThrow = _httpError(status: 401);
      final repo = _repo(a);
      await expectLater(
        repo.fetchPage(),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('schemaVersion incompatible burbuja sin envolver', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'schemaVersion': 99,
          'items': const [],
          'nextCursor': null,
          'serverTime': '2026-05-01T10:00:00.000Z',
        };
      final repo = _repo(a);
      await expectLater(
        repo.fetchPage(),
        throwsA(isA<UnsupportedSchemaVersionException>()),
      );
    });

    test('400 con code preserva BadRequestException(code)', () async {
      final a = _FakeAdapter()
        ..willThrow = _httpError(
          status: 400,
          body: {'message': 'cursor inválido', 'code': 'INVALID_CURSOR'},
        );
      final repo = _repo(a);
      await expectLater(
        repo.fetchPage(cursor: 'corrupt'),
        throwsA(isA<BadRequestException>()
            .having((e) => e.code, 'code', 'INVALID_CURSOR')),
      );
    });
  });

  group('NetworkRepositoryImpl.fetchSummary', () {
    test('delega al endpoint summary', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'schemaVersion': 2,
          'externalActiveCount': 12,
          'serverTime': '2026-05-01T10:00:00.000Z',
        };
      final repo = _repo(a);

      final env = await repo.fetchSummary();
      expect(env.externalActiveCount, 12);
      expect(a.captured!.path, '/v1/network/categories/summary');
    });

    test('403 burbuja como ForbiddenException', () async {
      final a = _FakeAdapter()..willThrow = _httpError(status: 403);
      final repo = _repo(a);
      await expectLater(
        repo.fetchSummary(),
        throwsA(isA<ForbiddenException>()),
      );
    });
  });
}
