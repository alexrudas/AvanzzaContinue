// ============================================================================
// test/data/repositories/network/network_repository_impl_v2_test.dart
// NetworkRepositoryImpl — Cache-first (Fase 4 Paso 3a)
// ============================================================================
// Cubre:
//   - refreshSection HTTP 200 → reconcileFromServer ejecutado → success
//   - HTTP timeout/network → markSyncFailed('network') → networkError
//   - HTTP 401 → markSyncFailed('401') → authError
//   - HTTP 403 → markSyncFailed('403') → forbidden
//   - HTTP 5xx → markSyncFailed('server') → serverError
//   - watchSection delega al DS local
//   - Cache de actores NUNCA se borra ante fallo remoto
//   - Múltiples refreshes idempotentes (sin duplicados en cache)
// ============================================================================

import 'dart:convert';

import 'package:avanzza/data/repositories/network/network_repository_impl.dart';
import 'package:avanzza/data/repositories/network/refresh_network_outcome.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource_impl.dart';
import 'package:avanzza/data/sources/remote/network/network_api_client.dart';
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
      'schemaVersion': 2,
      'items': items,
      'nextCursor': nextCursor,
      'serverTime': '2026-05-11T10:00:00.000Z',
    };

Map<String, dynamic> _actor({
  required String refRaw,
  String displayName = 'Provider',
  List<String> sectionKeys = const ['parts_and_supplies'],
  String primaryCategory = 'workshop',
  List<String> categories = const ['workshop'],
}) =>
    {
      'ref': refRaw,
      'displayName': displayName,
      'avatarRef': null,
      'unresolved': false,
      'categories': categories,
      'primaryCategory': primaryCategory,
      'isTeamMember': false,
      'isRestricted': false,
      'restrictionReason': null,
      'primaryPhoneE164': '+573001234567',
      'primaryEmail': 'p@e.co',
      'hasWhatsApp': true,
      'relationshipState': 'vinculada',
      'providerProfileId': null,
      'availableActions': const <Map<String, dynamic>>[],
      'sectionKeys': sectionKeys,
      'updatedAt': '2026-05-11T10:00:00.000Z',
    };

void main() {
  late Isar isar;
  late NetworkLocalDataSourceImpl localDs;
  late _FakeAdapter adapter;
  late NetworkRepositoryImpl repo;

  setUp(() async {
    isar = await openTestIsarForNetworkCache();
    localDs = NetworkLocalDataSourceImpl(isar);
    adapter = _FakeAdapter();
    final client = NetworkApiClient(
      dio: _dio(adapter),
      getIdToken: () async => 'tk',
    );
    repo = NetworkRepositoryImpl(client: client, localDataSource: localDs);
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
        _actor(refRaw: 'platform:a'),
        _actor(refRaw: 'platform:b'),
      ]);

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.success);

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(2));
      expect(snap.meta, isNotNull);
      expect(
        snap.meta!.syncStatus.name,
        'confirmed',
        reason: 'meta debe quedar confirmed tras reconcile exitoso',
      );
    });

    test('HTTP 200 con items=[] → reconcile blindaje (no toca cache)',
        () async {
      // Sembramos primero con un refresh exitoso.
      adapter.responseBody =
          _validEnvelope(items: [_actor(refRaw: 'platform:seeded')]);
      await repo.refreshSection(workspaceId: 'ws-1');
      expect((await localDs.getSection(workspaceId: 'ws-1')).actors, hasLength(1));

      // Segundo refresh con items vacíos → blindaje incoming_empty.
      adapter.responseBody = _validEnvelope(items: const []);
      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.success);

      // Cache intacta.
      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(1),
          reason: 'blindaje incoming_empty NO debe borrar cache');
    });

    test('múltiples refreshes con mismo set → idempotente (sin duplicados)',
        () async {
      adapter.responseBody = _validEnvelope(items: [
        _actor(refRaw: 'platform:a'),
        _actor(refRaw: 'platform:b'),
      ]);

      await repo.refreshSection(workspaceId: 'ws-1');
      await repo.refreshSection(workspaceId: 'ws-1');
      await repo.refreshSection(workspaceId: 'ws-1');

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(2),
          reason: 'unique:replace garantiza no-duplicación');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // refreshSection — Errores → markSyncFailed + outcome tipado
  // ──────────────────────────────────────────────────────────────────────────

  group('refreshSection — errores remotos', () {
    test('HTTP 401 → outcome=authError + meta.syncStatus=syncFailed', () async {
      adapter.statusCode = 401;
      adapter.responseBody = {'error': 'unauthorized'};

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.authError);

      final meta = await localDs.getSectionMeta(workspaceId: 'ws-1');
      expect(meta, isNotNull);
      expect(meta!.syncStatus.name, 'syncFailed');
      expect(meta.lastErrorCode, '401');
    });

    test('HTTP 403 → outcome=forbidden + lastErrorCode=403', () async {
      adapter.statusCode = 403;
      adapter.responseBody = {'error': 'forbidden'};

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.forbidden);

      final meta = await localDs.getSectionMeta(workspaceId: 'ws-1');
      expect(meta!.lastErrorCode, '403');
    });

    test('HTTP 500 → outcome=serverError + lastErrorCode=server', () async {
      adapter.statusCode = 500;
      adapter.responseBody = {'error': 'server'};

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.serverError);

      final meta = await localDs.getSectionMeta(workspaceId: 'ws-1');
      expect(meta!.lastErrorCode, 'server');
    });

    test('NetworkException (timeout) → outcome=networkError', () async {
      adapter.willThrow = DioException.connectionTimeout(
        timeout: const Duration(seconds: 30),
        requestOptions: RequestOptions(path: '/v1/network'),
      );

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.networkError);

      final meta = await localDs.getSectionMeta(workspaceId: 'ws-1');
      expect(meta!.syncStatus.name, 'syncFailed');
      expect(meta.lastErrorCode, 'network');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Invariante crítica: cache de actores sobrevive fallos
  // ──────────────────────────────────────────────────────────────────────────

  group('cache intacta ante fallo remoto (invariante local-first)', () {
    test('refresh OK → refresh 5xx → actores siguen visibles', () async {
      // Seed con 2 actores.
      adapter.statusCode = 200;
      adapter.responseBody = _validEnvelope(items: [
        _actor(refRaw: 'platform:a'),
        _actor(refRaw: 'platform:b'),
      ]);
      await repo.refreshSection(workspaceId: 'ws-1');
      expect((await localDs.getSection(workspaceId: 'ws-1')).actors,
          hasLength(2));

      // Falla 5xx en el siguiente refresh.
      adapter.statusCode = 500;
      adapter.responseBody = {'error': 'oops'};
      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.serverError);

      // Cache de actores PRESERVADA.
      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(2),
          reason: 'fallo remoto NO debe destruir cache local');
      expect(snap.meta!.syncStatus.name, 'syncFailed');
      expect(snap.meta!.lastErrorCode, 'server');
    });

    test('refresh OK → refresh timeout → cache intacta + banner ready',
        () async {
      adapter.statusCode = 200;
      adapter.responseBody =
          _validEnvelope(items: [_actor(refRaw: 'platform:a')]);
      await repo.refreshSection(workspaceId: 'ws-1');

      adapter.willThrow = DioException.connectionTimeout(
        timeout: const Duration(seconds: 30),
        requestOptions: RequestOptions(path: '/v1/network'),
      );
      await repo.refreshSection(workspaceId: 'ws-1');

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(1));
      expect(snap.meta!.lastErrorCode, 'network');
    });

    test('fallo en primer intento (sin cache previa) → cache vacía, meta marcada',
        () async {
      adapter.statusCode = 500;
      adapter.responseBody = {'error': 'oops'};

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.serverError);

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, isEmpty);
      expect(snap.meta, isNotNull,
          reason: 'meta debe crearse para registrar el fallo');
      expect(snap.meta!.syncStatus.name, 'syncFailed');
      expect(snap.meta!.lastErrorCode, 'server');
      expect(snap.meta!.lastSyncedAt, isNull,
          reason: 'lastSyncedAt NUNCA avanza si el sync falló');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // HARDENING — Malformed payload (FormatException)
  // ──────────────────────────────────────────────────────────────────────────
  // V1: per-row quarantine NO implementado. UN actor malformado tumba la
  // página completa. Lo que SÍ garantizamos:
  //   - Cache de actores cacheados PRESERVADA (nunca llegamos a reconcile).
  //   - outcome=unknownError (no networkError, no serverError).
  //   - meta.lastErrorCode='parseError' para telemetría / diagnóstico UI.
  // Per-row quarantine queda como deuda V2 documentada en el header del impl.

  group('hardening — malformed payload', () {
    test(
        'actor con updatedAt malformado → FormatException → '
        'outcome=unknownError + cache previa intacta', () async {
      // Seed con 2 actores válidos.
      adapter.statusCode = 200;
      adapter.responseBody = _validEnvelope(items: [
        _actor(refRaw: 'platform:cached-1'),
        _actor(refRaw: 'platform:cached-2'),
      ]);
      await repo.refreshSection(workspaceId: 'ws-1');
      expect((await localDs.getSection(workspaceId: 'ws-1')).actors,
          hasLength(2));

      // Próximo refresh trae UN actor con updatedAt malformado en medio
      // de actores válidos — toda la página se rechaza.
      adapter.statusCode = 200;
      adapter.responseBody = _validEnvelope(items: [
        _actor(refRaw: 'platform:valid-a'),
        {
          'ref': 'platform:malformed',
          'displayName': 'Malformed',
          'avatarRef': null,
          'unresolved': false,
          'categories': const ['workshop'],
          'primaryCategory': 'workshop',
          'isTeamMember': false,
          'isRestricted': false,
          'restrictionReason': null,
          'primaryPhoneE164': null,
          'primaryEmail': null,
          'hasWhatsApp': false,
          'relationshipState': 'vinculada',
          'providerProfileId': null,
          'availableActions': const <Map<String, dynamic>>[],
          'sectionKeys': const ['parts_and_supplies'],
          'updatedAt': 'this-is-not-a-date',
        },
        _actor(refRaw: 'platform:valid-b'),
      ]);

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.unknownError);

      // INVARIANTE CRÍTICA: cache previa intacta.
      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(2),
          reason: 'cache previa NO debe destruirse por parse error');
      expect(
        snap.actors.map((a) => a.actorRefRaw).toSet(),
        {'platform:cached-1', 'platform:cached-2'},
        reason: 'los actores cacheados son los del refresh exitoso anterior',
      );

      // Meta marcada con errorCode específico.
      expect(snap.meta!.syncStatus.name, 'syncFailed');
      expect(snap.meta!.lastErrorCode, 'parseError',
          reason: 'parseError es el código específico, no "unknown"');
      // lastSyncedAt conserva el último éxito.
      expect(snap.meta!.lastSyncedAt, isNotNull);
    });

    test(
        'JSON inválido (envelope schemaVersion ausente) → FormatException → '
        'parseError, cache intacta', () async {
      // Seed.
      adapter.statusCode = 200;
      adapter.responseBody =
          _validEnvelope(items: [_actor(refRaw: 'platform:seeded')]);
      await repo.refreshSection(workspaceId: 'ws-1');

      // Respuesta sin schemaVersion (parser strict del envelope falla).
      adapter.statusCode = 200;
      adapter.responseBody = {
        'items': const <Map<String, dynamic>>[],
        'nextCursor': null,
        'serverTime': '2026-05-11T10:00:00.000Z',
      };

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.unknownError);

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(1),
          reason: 'cache previa intacta ante envelope malformado');
      expect(snap.meta!.lastErrorCode, 'parseError');
    });

    test(
        'sin cache previa + payload malformado → cache vacía + meta marcada '
        '(lastSyncedAt sigue null)', () async {
      adapter.statusCode = 200;
      adapter.responseBody = {
        // schemaVersion ausente → FormatException en envelope.
        'items': const <Map<String, dynamic>>[],
      };

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.unknownError);

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, isEmpty);
      expect(snap.meta, isNotNull);
      expect(snap.meta!.lastErrorCode, 'parseError');
      expect(snap.meta!.lastSyncedAt, isNull,
          reason: 'lastSyncedAt nunca avanza ante parse error');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // watchSection — delegación al DS local
  // ──────────────────────────────────────────────────────────────────────────

  group('watchSection — delegación al DS local', () {
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
        _actor(refRaw: 'platform:a'),
        _actor(refRaw: 'platform:b'),
      ]);
      await repo.refreshSection(workspaceId: 'ws-1');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(events.length, greaterThan(baseline));
      expect(events.last, 2);

      await sub.cancel();
    });

    test('aislamiento por workspace — refresh en ws-2 no emite para ws-1',
        () async {
      final ws1Events = <int>[];
      final sub = repo.watchSection(workspaceId: 'ws-1').listen((snap) {
        ws1Events.add(snap.actors.length);
      });
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final after = ws1Events.length;

      adapter.statusCode = 200;
      adapter.responseBody =
          _validEnvelope(items: [_actor(refRaw: 'platform:x')]);
      await repo.refreshSection(workspaceId: 'ws-2');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(ws1Events.length, after,
          reason: 'sub a ws-1 NO debe recibir emisiones por escrituras en ws-2');

      await sub.cancel();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Consistencia local ↔ remoto (verdad operacional ↔ contractual)
  // ──────────────────────────────────────────────────────────────────────────

  group('reconcile sectionKeys preservados en cache', () {
    test('actores entran a cache con projectionJson conteniendo sectionKeys',
        () async {
      adapter.statusCode = 200;
      adapter.responseBody = _validEnvelope(items: [
        _actor(
          refRaw: 'platform:services-only',
          sectionKeys: const ['services_and_workshops'],
        ),
      ]);

      final outcome = await repo.refreshSection(workspaceId: 'ws-1');
      expect(outcome, RefreshNetworkOutcome.success);

      final snap = await localDs.getSection(workspaceId: 'ws-1');
      expect(snap.actors, hasLength(1));
      // El projection rehidrata desde el JSON persistido y debe traer
      // los datos canónicos del actor.
      final a = snap.actors.first;
      expect(a.actorRefRaw, 'platform:services-only');
      expect(a.displayName, 'Provider');
    });
  });
}
