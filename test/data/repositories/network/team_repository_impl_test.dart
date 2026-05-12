// ============================================================================
// test/data/repositories/network/team_repository_impl_test.dart
// TeamRepositoryImpl — delegación pura + propagación de errores
// ============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:avanzza/data/models/network/network_section_meta_model.dart';
import 'package:avanzza/data/models/network/team_actor_projection.dart';
import 'package:avanzza/data/models/network/unsupported_schema_version_exception.dart';
import 'package:avanzza/data/repositories/network/team_repository_impl.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource.dart'
    show ReconcileReport;
import 'package:avanzza/data/sources/local/network/team_local_datasource.dart';
import 'package:avanzza/data/sources/remote/network/team_api_client.dart';
import 'package:avanzza/domain/errors/remote_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stub para tests del path legacy (fetchPage/fetchSummary).
class _NoOpTeamLocalDataSource implements TeamLocalDataSource {
  @override
  Future<TeamSectionSnapshot> getSection({
    required String workspaceId,
    bool includeMissing = true,
  }) async =>
      TeamSectionSnapshot(
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
  Stream<TeamSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) =>
      const Stream.empty();

  @override
  Future<List<TeamActorProjection>> searchByDisplayName({
    required String workspaceId,
    required String query,
    bool includeMissing = true,
  }) async =>
      const [];

  @override
  Future<ReconcileReport> reconcileFromServer({
    required String workspaceId,
    required List<TeamActorProjection> incoming,
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
      200,
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

TeamRepositoryImpl _repo(_FakeAdapter a) {
  final client = TeamApiClient(
    dio: _dio(a),
    getIdToken: () async => 'tk',
  );
  return TeamRepositoryImpl(
    client: client,
    localDataSource: _NoOpTeamLocalDataSource(),
  );
}

Map<String, dynamic> _validEnvelope() => {
      'schemaVersion': 1,
      'items': const <Map<String, dynamic>>[],
      'nextCursor': null,
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
  group('TeamRepositoryImpl.fetchPage — delegación', () {
    test('llama a /v1/team sin params', () async {
      final a = _FakeAdapter()..responseBody = _validEnvelope();
      final repo = _repo(a);

      await repo.fetchPage();
      expect(a.captured!.path, '/v1/team');
      expect(a.captured!.queryParameters, isEmpty);
    });

    test('propaga cursor + limit', () async {
      final a = _FakeAdapter()..responseBody = _validEnvelope();
      final repo = _repo(a);

      await repo.fetchPage(cursor: 'CUR', limit: 50);
      expect(a.captured!.queryParameters, {'cursor': 'CUR', 'limit': 50});
    });

    test('retorna miembros parseados', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'schemaVersion': 1,
          'items': [
            {
              'ref': 'user:u-1',
              'membershipId': 'm-1',
              'displayName': 'Juan',
              'avatarRef': null,
              'teamRoleKeys': ['admin'],
              'primaryPhoneE164': null,
              'primaryEmail': null,
              'hasWhatsApp': false,
              'availableActions': const [],
              'updatedAt': '2026-05-01T10:00:00.000Z',
            }
          ],
          'nextCursor': null,
          'serverTime': '2026-05-01T10:00:00.000Z',
        };
      final repo = _repo(a);

      final env = await repo.fetchPage();
      expect(env.items, hasLength(1));
      expect(env.items.first.teamRoleKeys, ['admin']);
      expect(env.isLastPage, isTrue);
    });
  });

  group('TeamRepositoryImpl — propagación de errores', () {
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

    test('schemaVersion incompatible burbuja tipado', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'schemaVersion': 7,
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
  });

  group('TeamRepositoryImpl.fetchSummary', () {
    test('delega a /v1/team/summary', () async {
      final a = _FakeAdapter()
        ..responseBody = {
          'schemaVersion': 1,
          'activeCount': 4,
          'serverTime': '2026-05-01T10:00:00.000Z',
        };
      final repo = _repo(a);

      final env = await repo.fetchSummary();
      expect(env.activeCount, 4);
      expect(a.captured!.path, '/v1/team/summary');
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
