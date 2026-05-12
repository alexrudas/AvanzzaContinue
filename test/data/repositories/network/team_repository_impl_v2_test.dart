// ============================================================================
// test/data/repositories/network/team_repository_impl_v2_test.dart
// TeamRepositoryImpl — Cache-first (Fase 4 Paso 3b)
// ============================================================================
// Paridad con NetworkRepositoryImpl_v2_test:
//   - refreshSection HTTP 200 → reconcileFromServer → success
//   - HTTP timeout/network → markSyncFailed('network') → networkError
//   - HTTP 401 → markSyncFailed('401') → authError
//   - HTTP 403 → markSyncFailed('403') → forbidden
//   - HTTP 5xx → markSyncFailed('server') → serverError
//   - watchSection delega al DS local
//   - Cache NUNCA se borra ante fallo remoto
//   - Múltiples refreshes idempotentes
//
// VERIFICACIÓN PREVENTIVA:
//   TeamMemberSummaryDto.updatedAt es campo REQUERIDO del wire (parser
//   estricto). LWW por updatedAt es semánticamente VÁLIDO para team —
//   no se degrada por falta de base temporal.
// ============================================================================

import 'dart:convert';

import 'package:avanzza/data/repositories/network/refresh_network_outcome.dart';
import 'package:avanzza/data/repositories/network/team_repository_impl.dart';
import 'package:avanzza/data/sources/local/network/team_local_datasource_impl.dart';
import 'package:avanzza/data/sources/remote/network/team_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../../../helpers/isar_test_db_network_cache.dart';

class _FakeAdapter implements HttpClientAdapter {
  int statusCode = 200;
  dynamic responseBody;
  DioException? willThrow;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future? cancelFuture,
  ) async {
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

Map<String, dynamic> _validEnvelope({
  List<Map<String, dynamic>> items = const [],
  String? nextCursor,
}) =>
    {
      'schemaVersion': 1,
      'items': items,
      'nextCursor': nextCursor,
      'serverTime': '2026-05-11T10:00:00.000Z',
    };

Map<String, dynamic> _member({
  required String userId,
  required String membershipId,
  String? displayName = 'Member',
}) =>
    {
      'ref': 'user:$userId',
      'membershipId': membershipId,
      'displayName': displayName,
      'avatarRef': null,
      'teamRoleKeys': const <String>['member'],
      'primaryPhoneE164': '+573009990000',
      'primaryEmail': 'm@e.co',
      'hasWhatsApp': true,
      'availableActions': const <Map<String, dynamic>>[],
      'updatedAt': '2026-05-11T10:00:00.000Z',
    };

void main() {
  late Isar isar;
  late TeamLocalDataSourceImpl localDs;
  late _FakeAdapter adapter;
  late TeamRepositoryImpl repo;

  setUp(() async {
    isar = await openTestIsarForNetworkCache();
    localDs = TeamLocalDataSourceImpl(isar);
    adapter = _FakeAdapter();
    final client = TeamApiClient(
      dio: _dio(adapter),
      getIdToken: () async => 'tk',
    );
    repo = TeamRepositoryImpl(client: client, localDataSource: localDs);
  });

  tearDown(() async {
    await closeTestIsarNetworkCache(isar);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // refreshSection — Path feliz
  // ──────────────────────────────────────────────────────────────────────────

  group('refreshSection — success path', () {
    test('HTTP 200 con items → reconcileFromServer + outcome=success',
        () async {
      adapter.statusCode = 200;
      adapter.responseBody = _validEnvelope(items: [
        _member(userId: 'u-1', membershipId: 'm-1'),
        _member(userId: 'u-2', membershipId: 'm-2'),
      ]);

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.success);

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(2));
      expect(snap.meta, isNotNull);
      expect(snap.meta!.syncStatus.name, 'confirmed');
    });

    test('HTTP 200 con items=[] → reconcile blindaje (no toca cache)',
        () async {
      adapter.responseBody = _validEnvelope(items: [
        _member(userId: 'u-seeded', membershipId: 'm-seeded'),
      ]);
      await repo.refreshSection(workspaceId: 'ws-1');
      expect((await localDs.getSection(workspaceId: 'ws-1')).actors,
          hasLength(1));

      adapter.responseBody = _validEnvelope(items: const []);
      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.success);

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(1),
          reason: 'blindaje incoming_empty no debe borrar cache de team');
    });

    test('múltiples refreshes idempotentes (sin duplicados)', () async {
      adapter.responseBody = _validEnvelope(items: [
        _member(userId: 'u-1', membershipId: 'm-1'),
        _member(userId: 'u-2', membershipId: 'm-2'),
      ]);

      await repo.refreshSection(workspaceId: 'ws-1');
      await repo.refreshSection(workspaceId: 'ws-1');
      await repo.refreshSection(workspaceId: 'ws-1');

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(2));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // refreshSection — Errores
  // ──────────────────────────────────────────────────────────────────────────

  group('refreshSection — errores remotos', () {
    test('HTTP 401 → outcome=authError + lastErrorCode=401', () async {
      adapter.statusCode = 401;
      adapter.responseBody = {'error': 'unauthorized'};

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.authError);

      final meta = await localDs.getSectionMeta(workspaceId: 'ws-1');
      expect(meta!.lastErrorCode, '401');
    });

    test('HTTP 403 → outcome=forbidden + lastErrorCode=403', () async {
      adapter.statusCode = 403;
      adapter.responseBody = {'error': 'forbidden'};

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.forbidden);

      final meta = await localDs.getSectionMeta(workspaceId: 'ws-1');
      expect(meta!.lastErrorCode, '403');
    });

    test('HTTP 500 → outcome=serverError', () async {
      adapter.statusCode = 500;
      adapter.responseBody = {'error': 'oops'};

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.serverError);
    });

    test('NetworkException (timeout) → outcome=networkError', () async {
      adapter.willThrow = DioException.connectionTimeout(
        timeout: const Duration(seconds: 30),
        requestOptions: RequestOptions(path: '/v1/team'),
      );

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.networkError);

      final meta = await localDs.getSectionMeta(workspaceId: 'ws-1');
      expect(meta!.lastErrorCode, 'network');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Invariante local-first: cache sobrevive
  // ──────────────────────────────────────────────────────────────────────────

  group('cache intacta ante fallo remoto', () {
    test('refresh OK → refresh 5xx → miembros siguen visibles', () async {
      adapter.statusCode = 200;
      adapter.responseBody = _validEnvelope(items: [
        _member(userId: 'u-1', membershipId: 'm-1'),
        _member(userId: 'u-2', membershipId: 'm-2'),
      ]);
      await repo.refreshSection(workspaceId: 'ws-1');

      adapter.statusCode = 500;
      adapter.responseBody = {'error': 'oops'};
      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.serverError);

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(2));
      expect(snap.meta!.syncStatus.name, 'syncFailed');
    });

    test('fallo primer intento → meta marcada, lastSyncedAt sigue null',
        () async {
      adapter.statusCode = 500;
      adapter.responseBody = {'error': 'oops'};

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.serverError);

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, isEmpty);
      expect(snap.meta!.lastSyncedAt, isNull,
          reason: 'lastSyncedAt nunca avanza si sync falló');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // HARDENING — Malformed payload (paridad con Network)
  // ──────────────────────────────────────────────────────────────────────────

  group('hardening — malformed payload', () {
    test(
        'miembro con updatedAt malformado → FormatException → '
        'outcome=unknownError + cache previa intacta', () async {
      adapter.statusCode = 200;
      adapter.responseBody = _validEnvelope(items: [
        _member(userId: 'u-cached-1', membershipId: 'm-cached-1'),
        _member(userId: 'u-cached-2', membershipId: 'm-cached-2'),
      ]);
      await repo.refreshSection(workspaceId: 'ws-1');
      expect((await localDs.getSection(workspaceId: 'ws-1')).actors,
          hasLength(2));

      // Payload con un miembro malformado.
      adapter.responseBody = _validEnvelope(items: [
        _member(userId: 'u-valid-a', membershipId: 'm-valid-a'),
        {
          'ref': 'user:u-broken',
          'membershipId': 'm-broken',
          'displayName': 'Broken',
          'avatarRef': null,
          'teamRoleKeys': const ['member'],
          'primaryPhoneE164': null,
          'primaryEmail': null,
          'hasWhatsApp': false,
          'availableActions': const <Map<String, dynamic>>[],
          'updatedAt': 'NOT-A-DATE',
        },
      ]);

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.unknownError);

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(2),
          reason: 'cache previa intacta ante parse error de un miembro');
      expect(snap.meta!.lastErrorCode, 'parseError');
    });

    test('envelope sin schemaVersion → parseError, cache intacta', () async {
      adapter.statusCode = 200;
      adapter.responseBody = _validEnvelope(items: [
        _member(userId: 'u-1', membershipId: 'm-1'),
      ]);
      await repo.refreshSection(workspaceId: 'ws-1');

      adapter.responseBody = {
        'items': const <Map<String, dynamic>>[],
        'nextCursor': null,
        'serverTime': '2026-05-11T10:00:00.000Z',
      };
      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.unknownError);

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(1));
      expect(snap.meta!.lastErrorCode, 'parseError');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // watchSection — delegación
  // ──────────────────────────────────────────────────────────────────────────

  group('watchSection', () {
    test('emite snapshot inicial al suscribirse', () async {
      final events = <int>[];
      final sub = repo.watchSection(workspaceId: 'ws-1').listen((snap) {
        events.add(snap.actors.length);
      });
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(events, [0]);
      await sub.cancel();
    });

    test('re-emite tras refreshSection exitoso', () async {
      final events = <int>[];
      final sub = repo.watchSection(workspaceId: 'ws-1').listen((snap) {
        events.add(snap.actors.length);
      });
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final baseline = events.length;

      adapter.statusCode = 200;
      adapter.responseBody = _validEnvelope(items: [
        _member(userId: 'u-1', membershipId: 'm-1'),
      ]);
      await repo.refreshSection(workspaceId: 'ws-1');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(events.length, greaterThan(baseline));
      expect(events.last, 1);
      await sub.cancel();
    });

    test('aislamiento por workspace — refresh ws-2 no emite a ws-1',
        () async {
      final ws1Events = <int>[];
      final sub = repo.watchSection(workspaceId: 'ws-1').listen((snap) {
        ws1Events.add(snap.actors.length);
      });
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final after = ws1Events.length;

      adapter.statusCode = 200;
      adapter.responseBody = _validEnvelope(items: [
        _member(userId: 'u-x', membershipId: 'm-x'),
      ]);
      await repo.refreshSection(workspaceId: 'ws-2');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ws1Events.length, after);
      await sub.cancel();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // updatedAt — LWW base válida (verificación preventiva)
  // ──────────────────────────────────────────────────────────────────────────

  group('updatedAt es base LWW semánticamente válida', () {
    test('updatedAt del wire se preserva en projection y cache', () async {
      const fixedDateWire = '2026-05-11T14:30:00.000Z';
      adapter.statusCode = 200;
      adapter.responseBody = _validEnvelope(items: [
        {
          'ref': 'user:u-1',
          'membershipId': 'm-1',
          'displayName': 'Alex',
          'avatarRef': null,
          'teamRoleKeys': ['owner'],
          'primaryPhoneE164': null,
          'primaryEmail': null,
          'hasWhatsApp': false,
          'availableActions': const <Map<String, dynamic>>[],
          'updatedAt': fixedDateWire,
        },
      ]);

      await repo.refreshSection(workspaceId: 'ws-1');
      final snap = await localDs.getSection(workspaceId: 'ws-1');

      expect(snap.actors, hasLength(1));
      expect(
        snap.actors.first.updatedAt.toUtc(),
        DateTime.parse(fixedDateWire).toUtc(),
        reason: 'updatedAt del wire debe sobrevivir el round-trip wire → '
            'projection → cache, no fabricarse desde DateTime.now()',
      );
    });
  });
}
