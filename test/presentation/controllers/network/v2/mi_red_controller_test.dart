// ============================================================================
// test/presentation/controllers/network/v2/mi_red_controller_test.dart
// MiRedController — estados por sección + concurrencia loadMore + 403 parcial
// ============================================================================
// Cubre:
//   - loadInitial: dispara ambas secciones; estado Loading→Loaded/Empty.
//   - 403 en /network NO bloquea /team (y viceversa).
//   - Cambio de filtro resetea network sin tocar team.
//   - reloadNetworkSection desde Forbidden vuelve a Loading→Loaded.
//   - loadMore concurrente (AJUSTE 4):
//       · request al repo se hace UNA sola vez.
//       · items NO se duplican.
//       · isLoadingMore se respeta como lock idempotente.
//   - schemaVersion incompatible → SectionError.
//   - loadMore con repo cuelga → libera lock al fallar (no congela).
// ============================================================================

import 'dart:async';

import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_category.dart';
import 'package:avanzza/data/models/network/network_envelope.dart';
import 'package:avanzza/data/models/network/team_member_summary_dto.dart';
import 'package:avanzza/data/models/network/unsupported_schema_version_exception.dart';
import 'package:avanzza/data/repositories/network/refresh_network_outcome.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource.dart';
import 'package:avanzza/data/sources/local/network/team_local_datasource.dart';
import 'package:avanzza/domain/errors/remote_exceptions.dart';
import 'package:avanzza/domain/repositories/network/network_repository.dart';
import 'package:avanzza/domain/repositories/network/team_repository.dart';
import 'package:avanzza/presentation/controllers/network/v2/mi_red_controller.dart';
import 'package:avanzza/presentation/controllers/network/v2/section_state.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Fakes ────────────────────────────────────────────────────────────────

/// Repo fake con plan de respuestas configurable por llamada y opcional
/// hold con Completer para test de concurrencia.
class _FakeNetworkRepo implements NetworkRepository {
  /// Cola de planes ordenados. Cada llamada consume el siguiente.
  final List<_NetworkPlan> plan = [];
  final List<_NetworkCallArgs> calls = [];

  @override
  Future<NetworkPageEnvelope<NetworkActorSummaryDto>> fetchPage({
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    String? cursor,
    int? limit,
  }) async {
    calls.add(_NetworkCallArgs(
      category: category,
      state: state,
      assetId: assetId,
      cursor: cursor,
      limit: limit,
    ));
    if (plan.isEmpty) {
      throw StateError(
          'Fake sin plan: llamada N=${calls.length} args=${calls.last}');
    }
    final next = plan.removeAt(0);
    if (next.holdUntil != null) await next.holdUntil!.future;
    if (next.error != null) throw next.error!;
    return next.envelope!;
  }

  @override
  Future<NetworkCategoriesSummaryEnvelope> fetchSummary() {
    throw UnimplementedError('summary no usado en estos tests');
  }

  // Cache-first API (Fase 4 Paso 3a) — no usada en este suite que cubre
  // exclusivamente el path legacy fetchPage. Stubs vacíos.
  @override
  Stream<NetworkSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) =>
      const Stream.empty();

  @override
  Future<RefreshNetworkOutcome> refreshSection({
    required String workspaceId,
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    int? limit,
  }) async =>
      RefreshNetworkOutcome.success;
}

class _NetworkPlan {
  final NetworkPageEnvelope<NetworkActorSummaryDto>? envelope;
  final Object? error;
  final Completer<void>? holdUntil;
  _NetworkPlan({this.envelope, this.error, this.holdUntil});
}

class _NetworkCallArgs {
  final NetworkCategory? category;
  final NetworkRelationshipState? state;
  final String? assetId;
  final String? cursor;
  final int? limit;
  _NetworkCallArgs({
    this.category,
    this.state,
    this.assetId,
    this.cursor,
    this.limit,
  });

  @override
  String toString() => 'cat=$category state=$state assetId=$assetId '
      'cursor=$cursor limit=$limit';
}

class _FakeTeamRepo implements TeamRepository {
  final List<_TeamPlan> plan = [];
  final List<_TeamCallArgs> calls = [];

  @override
  Future<NetworkPageEnvelope<TeamMemberSummaryDto>> fetchPage({
    String? cursor,
    int? limit,
  }) async {
    calls.add(_TeamCallArgs(cursor: cursor, limit: limit));
    if (plan.isEmpty) {
      throw StateError('Fake team sin plan: llamada N=${calls.length}');
    }
    final next = plan.removeAt(0);
    if (next.holdUntil != null) await next.holdUntil!.future;
    if (next.error != null) throw next.error!;
    return next.envelope!;
  }

  @override
  Future<TeamSummaryEnvelope> fetchSummary() {
    throw UnimplementedError('summary no usado en estos tests');
  }

  // Cache-first API (Fase 4 Paso 3b) — no usada en este suite legacy.
  @override
  Stream<TeamSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) =>
      const Stream.empty();

  @override
  Future<RefreshNetworkOutcome> refreshSection({
    required String workspaceId,
    int? limit,
  }) async =>
      RefreshNetworkOutcome.success;
}

class _TeamPlan {
  final NetworkPageEnvelope<TeamMemberSummaryDto>? envelope;
  final Object? error;
  final Completer<void>? holdUntil;
  _TeamPlan({this.envelope, this.error, this.holdUntil});
}

class _TeamCallArgs {
  final String? cursor;
  final int? limit;
  _TeamCallArgs({this.cursor, this.limit});
}

// ── Fixtures ─────────────────────────────────────────────────────────────

Map<String, dynamic> _actorJson({String ref = 'platform:p-1'}) => {
      'ref': ref,
      'displayName': 'Taller',
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

Map<String, dynamic> _memberJson({String ref = 'user:u-1'}) => {
      'ref': ref,
      'membershipId': 'm-1',
      'displayName': 'Juan',
      'avatarRef': null,
      'teamRoleKeys': const <String>[],
      'primaryPhoneE164': null,
      'primaryEmail': null,
      'hasWhatsApp': false,
      'availableActions': const [],
      'updatedAt': '2026-05-01T10:00:00.000Z',
    };

NetworkPageEnvelope<NetworkActorSummaryDto> _networkEnv({
  List<String> refs = const ['platform:p-1'],
  String? nextCursor,
}) {
  return NetworkPageEnvelope.fromJson(
    {
      'schemaVersion': kNetworkSchemaVersion,
      'items': [for (final r in refs) _actorJson(ref: r)],
      'nextCursor': nextCursor,
      'serverTime': '2026-05-01T10:00:00.000Z',
    },
    parseItem: NetworkActorSummaryDto.fromJson,
    endpoint: 'GET /v1/network',
    expectedSchemaVersion: kNetworkSchemaVersion,
  );
}

NetworkPageEnvelope<TeamMemberSummaryDto> _teamEnv({
  List<String> refs = const ['user:u-1'],
  String? nextCursor,
}) {
  return NetworkPageEnvelope.fromJson(
    {
      'schemaVersion': kTeamSchemaVersion,
      'items': [for (final r in refs) _memberJson(ref: r)],
      'nextCursor': nextCursor,
      'serverTime': '2026-05-01T10:00:00.000Z',
    },
    parseItem: TeamMemberSummaryDto.fromJson,
    endpoint: 'GET /v1/team',
    expectedSchemaVersion: kTeamSchemaVersion,
  );
}

MiRedController _ctrl(_FakeNetworkRepo n, _FakeTeamRepo t) =>
    MiRedController(networkRepository: n, teamRepository: t);

// ── Tests ────────────────────────────────────────────────────────────────

void main() {
  group('MiRedController.loadInitial', () {
    test('ambas secciones cargan en paralelo y quedan Loaded', () async {
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(envelope: _networkEnv()));
      final t = _FakeTeamRepo()..plan.add(_TeamPlan(envelope: _teamEnv()));
      final c = _ctrl(n, t);

      await c.loadInitial();

      expect(c.networkState, isA<SectionLoaded>());
      expect(c.teamState, isA<SectionLoaded>());
      final ns = c.networkState as SectionLoaded;
      expect(ns.items, hasLength(1));
    });

    test('items=[] + nextCursor=null ⇒ SectionEmpty', () async {
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(envelope: _networkEnv(refs: const [])));
      final t = _FakeTeamRepo()
        ..plan.add(_TeamPlan(envelope: _teamEnv(refs: const [])));
      final c = _ctrl(n, t);

      await c.loadInitial();
      expect(c.networkState, isA<SectionEmpty>());
      expect(c.teamState, isA<SectionEmpty>());
    });
  });

  group('MiRedController — fallo parcial 403', () {
    test('403 en /network NO bloquea /team', () async {
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(error: const ForbiddenException('no perm')));
      final t = _FakeTeamRepo()..plan.add(_TeamPlan(envelope: _teamEnv()));
      final c = _ctrl(n, t);

      await c.loadInitial();

      expect(c.networkState, isA<SectionForbidden>());
      expect(c.teamState, isA<SectionLoaded>());
    });

    test('403 en /team NO bloquea /network', () async {
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(envelope: _networkEnv()));
      final t = _FakeTeamRepo()
        ..plan.add(_TeamPlan(error: const ForbiddenException('no perm')));
      final c = _ctrl(n, t);

      await c.loadInitial();

      expect(c.networkState, isA<SectionLoaded>());
      expect(c.teamState, isA<SectionForbidden>());
    });

    test('reloadNetworkSection desde Forbidden vuelve a Loaded si permiso recupera',
        () async {
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(error: const ForbiddenException('no perm')))
        ..plan.add(_NetworkPlan(envelope: _networkEnv()));
      final t = _FakeTeamRepo()..plan.add(_TeamPlan(envelope: _teamEnv()));
      final c = _ctrl(n, t);

      await c.loadInitial();
      expect(c.networkState, isA<SectionForbidden>());

      await c.reloadNetworkSection();
      expect(c.networkState, isA<SectionLoaded>());
    });
  });

  group('MiRedController — errores no-403', () {
    test('schemaVersion incompatible ⇒ SectionError', () async {
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(
          error: const UnsupportedSchemaVersionException(
            received: 2,
            supported: [1],
            endpoint: 'GET /v1/network',
          ),
        ));
      final t = _FakeTeamRepo()..plan.add(_TeamPlan(envelope: _teamEnv()));
      final c = _ctrl(n, t);

      await c.loadInitial();
      expect(c.networkState, isA<SectionError>());
      final err = (c.networkState as SectionError).error;
      expect(err, isA<UnsupportedSchemaVersionException>());
    });
  });

  group('MiRedController — filtro', () {
    test('setFilterCategory resetea network y NO toca team', () async {
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(envelope: _networkEnv())) // initial
        ..plan.add(_NetworkPlan(envelope: _networkEnv(refs: const ['platform:p-2']))); // filtered
      final t = _FakeTeamRepo()..plan.add(_TeamPlan(envelope: _teamEnv()));
      final c = _ctrl(n, t);

      await c.loadInitial();
      expect(c.networkState, isA<SectionLoaded>());

      await c.setFilterCategory(NetworkCategory.workshop);

      // Network se recargó con el filtro
      expect(n.calls.length, 2);
      expect(n.calls.last.category, NetworkCategory.workshop);
      // Team intocado (1 sola llamada)
      expect(t.calls.length, 1);
    });

    test('setFilterCategory con mismo valor no dispara reload', () async {
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(envelope: _networkEnv()));
      final t = _FakeTeamRepo()..plan.add(_TeamPlan(envelope: _teamEnv()));
      final c = _ctrl(n, t);

      await c.loadInitial();
      await c.setFilterCategory(null); // ya era null
      expect(n.calls.length, 1);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // AJUSTE 4: concurrencia de loadMore
  // ──────────────────────────────────────────────────────────────────────

  group('MiRedController.loadMoreNetwork — concurrencia (lock idempotente)', () {
    test('llamada concurrente NO duplica request al repo', () async {
      final hold = Completer<void>();
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(
          envelope: _networkEnv(refs: ['platform:p-1'], nextCursor: 'C2'),
        ))
        // El siguiente fetch (loadMore) cuelga hasta que liberemos `hold`.
        ..plan.add(_NetworkPlan(
          envelope: _networkEnv(refs: ['platform:p-2'], nextCursor: null),
          holdUntil: hold,
        ));
      final t = _FakeTeamRepo()..plan.add(_TeamPlan(envelope: _teamEnv()));
      final c = _ctrl(n, t);

      await c.loadInitial();
      expect(n.calls.length, 1);
      expect((c.networkState as SectionLoaded).hasMore, isTrue);

      // Disparamos 3 loadMore concurrentes (sin await entre ellos).
      final f1 = c.loadMoreNetwork();
      final f2 = c.loadMoreNetwork();
      final f3 = c.loadMoreNetwork();

      // Todavía no liberamos hold: solo 1 request debió alcanzar al repo
      // (el primero); las concurrentes vieron isLoadingMore=true y se
      // descartaron silenciosamente.
      // Cedemos un microtick para que las 3 entradas concurrentes ejecuten
      // su check de lock antes de revisar.
      await Future<void>.delayed(Duration.zero);
      expect(n.calls.length, 2,
          reason: 'initial(1) + loadMore(1); las 2 concurrentes descartadas');

      // Mientras tanto, el estado refleja isLoadingMore=true.
      final mid = c.networkState as SectionLoaded;
      expect(mid.isLoadingMore, isTrue);
      expect(mid.items.length, 1, reason: 'aún sin append');

      // Liberamos el hold y dejamos que f1 termine; f2 y f3 ya retornaron
      // sin hacer nada.
      hold.complete();
      await Future.wait([f1, f2, f3]);

      // Resultado final: items duplicados NO; cursor avanzó; lock liberado.
      final after = c.networkState as SectionLoaded;
      expect(after.items.length, 2,
          reason: 'p-1 + p-2, sin duplicados');
      expect(after.items.map((e) => e.ref.id).toList(), ['p-1', 'p-2']);
      expect(after.isLoadingMore, isFalse);
      expect(after.hasMore, isFalse);
    });

    test('loadMore en última página (hasMore=false) es no-op', () async {
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(envelope: _networkEnv(nextCursor: null)));
      final t = _FakeTeamRepo()..plan.add(_TeamPlan(envelope: _teamEnv()));
      final c = _ctrl(n, t);

      await c.loadInitial();
      expect((c.networkState as SectionLoaded).hasMore, isFalse);

      await c.loadMoreNetwork();
      expect(n.calls.length, 1, reason: 'no debió llamar al repo');
    });

    test('loadMore desde Loading/Forbidden/Empty es no-op', () async {
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(error: const ForbiddenException('x')));
      final t = _FakeTeamRepo()..plan.add(_TeamPlan(envelope: _teamEnv()));
      final c = _ctrl(n, t);

      await c.loadInitial();
      expect(c.networkState, isA<SectionForbidden>());

      await c.loadMoreNetwork();
      // Solo la llamada inicial fallida; loadMore no llamó al repo.
      expect(n.calls.length, 1);
    });

    test('loadMore que falla libera lock sin tocar items existentes', () async {
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(envelope: _networkEnv(nextCursor: 'C2')))
        ..plan.add(_NetworkPlan(error: const ServerException(500, 'boom')));
      final t = _FakeTeamRepo()..plan.add(_TeamPlan(envelope: _teamEnv()));
      final c = _ctrl(n, t);

      await c.loadInitial();
      final before = c.networkState as SectionLoaded;
      expect(before.items.length, 1);

      await c.loadMoreNetwork();

      final after = c.networkState as SectionLoaded;
      expect(after.items.length, 1, reason: 'items de página 1 intactos');
      expect(after.isLoadingMore, isFalse, reason: 'lock liberado');
      expect(after.nextCursor, 'C2',
          reason: 'cursor preservado para reintentar manualmente');
    });
  });

  group('MiRedController.loadMoreTeam — concurrencia análoga', () {
    test('llamada concurrente NO duplica request', () async {
      final hold = Completer<void>();
      final n = _FakeNetworkRepo()
        ..plan.add(_NetworkPlan(envelope: _networkEnv()));
      final t = _FakeTeamRepo()
        ..plan.add(_TeamPlan(envelope: _teamEnv(nextCursor: 'C2')))
        ..plan.add(_TeamPlan(
          envelope: _teamEnv(refs: ['user:u-2'], nextCursor: null),
          holdUntil: hold,
        ));
      final c = _ctrl(n, t);

      await c.loadInitial();
      expect(t.calls.length, 1);

      final f1 = c.loadMoreTeam();
      final f2 = c.loadMoreTeam();
      await Future<void>.delayed(Duration.zero);
      expect(t.calls.length, 2,
          reason: 'initial + loadMore(1); concurrente descartada');

      hold.complete();
      await Future.wait([f1, f2]);

      final after = c.teamState as SectionLoaded;
      expect(after.items.length, 2);
      expect(after.isLoadingMore, isFalse);
    });
  });
}
