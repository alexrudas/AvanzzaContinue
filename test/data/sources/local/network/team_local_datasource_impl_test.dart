import 'package:avanzza/core/utils/text_normalization.dart';
import 'package:avanzza/data/models/network/network_cache_enums.dart';
import 'package:avanzza/data/models/network/network_section_meta_model.dart';
import 'package:avanzza/data/models/network/team_actor_cache_model.dart';
import 'package:avanzza/data/models/network/team_actor_projection.dart';
import 'package:avanzza/data/sources/local/network/team_local_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../../../../helpers/isar_test_db_network_cache.dart';

TeamActorProjection _makeTeam({
  required String membershipId,
  String userId = 'user-default',
  String displayName = 'Miembro X',
  List<String> teamRoleKeys = const ['owner'],
  String? primaryPhoneE164 = '+573001234567',
  String? primaryEmail = 'x@y.co',
  bool hasWhatsApp = true,
  DateTime? updatedAt,
}) {
  return TeamActorProjection(
    actorRefRaw: 'user:$userId',
    userId: userId,
    membershipId: membershipId,
    displayName: displayName,
    displayNameNormalized: normalizeForSearch(displayName),
    avatarRef: null,
    teamRoleKeys: teamRoleKeys,
    primaryPhoneE164: primaryPhoneE164,
    primaryEmail: primaryEmail,
    hasWhatsApp: hasWhatsApp,
    updatedAt: updatedAt ?? DateTime.utc(2026, 5, 11, 10),
  );
}

void main() {
  late Isar isar;
  late TeamLocalDataSourceImpl ds;

  setUp(() async {
    isar = await openTestIsarForNetworkCache();
    ds = TeamLocalDataSourceImpl(isar);
  });

  tearDown(() async {
    await closeTestIsarNetworkCache(isar);
  });

  group('reconcileFromServer — upsert idempotente', () {
    test('primer sync inserta miembros + crea meta confirmada', () async {
      final report = await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeTeam(
              membershipId: 'm-1',
              userId: 'u-1',
              displayName: 'Alex Rudas'),
          _makeTeam(
              membershipId: 'm-2',
              userId: 'u-2',
              displayName: 'José Núñez'),
        ],
        isFullSnapshot: true,
        schemaVersion: 1,
        now: DateTime.utc(2026, 5, 11, 10),
      );

      expect(report.upserted, 2);
      expect(report.blindajeActivated, isFalse);

      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.actors.map((p) => p.membershipId).toList(), ['m-1', 'm-2']);
      expect(snap.meta, isNotNull);
      expect(snap.meta!.sectionKey, 'team');
      expect(snap.meta!.syncStatus, NetworkSectionSyncStatus.confirmed);
      expect(snap.meta!.itemCountLastSync, 2);
    });

    test('segundo sync con los mismos membershipId NO duplica filas', () async {
      final base = [
        _makeTeam(membershipId: 'm-1', userId: 'u-1'),
        _makeTeam(membershipId: 'm-2', userId: 'u-2'),
      ];
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: base,
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: base,
        isFullSnapshot: true,
        schemaVersion: 1,
      );

      final count = await isar.teamActorCacheModels.count();
      expect(count, 2);
    });

    test('upsert actualiza displayName y teamRoleKeys', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeTeam(
            membershipId: 'm-1',
            userId: 'u-1',
            displayName: 'Alex v1',
            teamRoleKeys: const ['member'],
          ),
        ],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeTeam(
            membershipId: 'm-1',
            userId: 'u-1',
            displayName: 'Alex v2',
            teamRoleKeys: const ['owner', 'admin'],
          ),
        ],
        isFullSnapshot: true,
        schemaVersion: 1,
      );

      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.actors.length, 1);
      expect(snap.actors.first.displayName, 'Alex v2');
      expect(snap.actors.first.teamRoleKeys, ['owner', 'admin']);
    });
  });

  group('atomicidad y rollback', () {
    test(
        'falla mid-txn → rollback completo: ni miembros nuevos ni meta avanza',
        () async {
      final t0 = DateTime.utc(2026, 5, 11, 9);
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeTeam(membershipId: 'm-OLD', userId: 'u-OLD')],
        isFullSnapshot: true,
        schemaVersion: 1,
        now: t0,
      );
      final metaBefore = await ds.getSectionMeta(workspaceId: 'ws-1');

      ds.testFailureHookAfterActors = () async {
        throw StateError('boom');
      };

      Object? caught;
      try {
        await ds.reconcileFromServer(
          workspaceId: 'ws-1',
          incoming: [
            _makeTeam(membershipId: 'm-NEW1', userId: 'u-NEW1'),
            _makeTeam(membershipId: 'm-NEW2', userId: 'u-NEW2'),
          ],
          isFullSnapshot: true,
          schemaVersion: 1,
          now: DateTime.utc(2026, 5, 11, 12),
        );
      } catch (e) {
        caught = e;
      }
      expect(caught, isA<StateError>());

      final rows = await isar.teamActorCacheModels.where().findAll();
      expect(rows.length, 1);
      expect(rows.first.membershipId, 'm-OLD');

      final metaAfter = await ds.getSectionMeta(workspaceId: 'ws-1');
      expect(metaAfter!.lastSyncedAt, metaBefore!.lastSyncedAt);
      expect(metaAfter.itemCountLastSync, 1);
    });
  });

  group('blindaje — incoming vacío', () {
    test('refresh con items:[] no marca missing', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeTeam(membershipId: 'm-1', userId: 'u-1'),
          _makeTeam(membershipId: 'm-2', userId: 'u-2'),
        ],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      final report = await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: const [],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      expect(report.blindajeReason, 'incoming_empty');
      expect(report.markedMissing, 0);

      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.actors.length, 2);
    });
  });

  group('blindaje — caída >50% no destruye cache', () {
    test('3 de 4 desaparecen → blindaje activa, nadie marcado missing',
        () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeTeam(membershipId: 'm-1', userId: 'u-1'),
          _makeTeam(membershipId: 'm-2', userId: 'u-2'),
          _makeTeam(membershipId: 'm-3', userId: 'u-3'),
          _makeTeam(membershipId: 'm-4', userId: 'u-4'),
        ],
        isFullSnapshot: true,
        schemaVersion: 1,
      );

      final report = await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeTeam(membershipId: 'm-1', userId: 'u-1')],
        isFullSnapshot: true,
        schemaVersion: 1,
      );

      expect(report.blindajeReason, 'delta_over_50');
      expect(report.markedMissing, 0);
      expect(report.suspiciousShrink, isTrue);

      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.actors.length, 4);
      expect(snap.meta!.suspiciousShrinkFlag, isTrue);
    });
  });

  group('blindaje — paginación', () {
    test('not_full_snapshot solo agrega, no marca missing', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeTeam(membershipId: 'm-1', userId: 'u-1')],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      final report = await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeTeam(membershipId: 'm-2', userId: 'u-2')],
        isFullSnapshot: false,
        schemaVersion: 1,
        nextCursor: 'pg-2',
      );
      expect(report.blindajeReason, 'not_full_snapshot');
      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.actors.length, 2);
    });
  });

  group('missingInLastSync', () {
    test('miembro removido del set se marca missing (<50%, sin blindaje)',
        () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeTeam(membershipId: 'm-1', userId: 'u-1'),
          _makeTeam(membershipId: 'm-2', userId: 'u-2'),
          _makeTeam(membershipId: 'm-3', userId: 'u-3'),
          _makeTeam(membershipId: 'm-4', userId: 'u-4'),
        ],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      // 1 de 4 desaparece = 25%.
      final report = await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeTeam(membershipId: 'm-1', userId: 'u-1'),
          _makeTeam(membershipId: 'm-2', userId: 'u-2'),
          _makeTeam(membershipId: 'm-3', userId: 'u-3'),
        ],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      expect(report.blindajeActivated, isFalse);
      expect(report.markedMissing, 1);

      final row = await isar.teamActorCacheModels
          .filter()
          .membershipIdEqualTo('m-4')
          .findFirst();
      expect(row!.missingInLastSync, isTrue);
    });

    test('reaparición desmarca missing', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeTeam(membershipId: 'm-1', userId: 'u-1'),
          _makeTeam(membershipId: 'm-2', userId: 'u-2'),
          _makeTeam(membershipId: 'm-3', userId: 'u-3'),
        ],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeTeam(membershipId: 'm-1', userId: 'u-1'),
          _makeTeam(membershipId: 'm-2', userId: 'u-2'),
        ],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      var row = await isar.teamActorCacheModels
          .filter()
          .membershipIdEqualTo('m-3')
          .findFirst();
      expect(row!.missingInLastSync, isTrue);

      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeTeam(membershipId: 'm-1', userId: 'u-1'),
          _makeTeam(membershipId: 'm-2', userId: 'u-2'),
          _makeTeam(membershipId: 'm-3', userId: 'u-3'),
        ],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      row = await isar.teamActorCacheModels
          .filter()
          .membershipIdEqualTo('m-3')
          .findFirst();
      expect(row!.missingInLastSync, isFalse);
    });
  });

  group('searchByDisplayName — tolerancia ES/CO', () {
    setUp(() async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeTeam(
              membershipId: 'm-1', userId: 'u-1', displayName: 'Peña Pérez'),
          _makeTeam(
              membershipId: 'm-2', userId: 'u-2', displayName: 'José Núñez'),
          _makeTeam(
              membershipId: 'm-3', userId: 'u-3', displayName: 'Niño Rodríguez'),
        ],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
    });

    test('pena matchea Peña', () async {
      final r =
          await ds.searchByDisplayName(workspaceId: 'ws-1', query: 'pena');
      expect(r.map((p) => p.displayName), contains('Peña Pérez'));
    });

    test('nunez matchea Núñez', () async {
      final r =
          await ds.searchByDisplayName(workspaceId: 'ws-1', query: 'nunez');
      expect(r.map((p) => p.displayName), contains('José Núñez'));
    });

    test('NIÑO matchea Niño (case + ñ)', () async {
      final r =
          await ds.searchByDisplayName(workspaceId: 'ws-1', query: 'NIÑO');
      expect(r.map((p) => p.displayName), contains('Niño Rodríguez'));
    });
  });

  group('separación estricta por workspace', () {
    test('miembros de ws-1 no aparecen en ws-2', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeTeam(membershipId: 'm-1', userId: 'u-A')],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      await ds.reconcileFromServer(
        workspaceId: 'ws-2',
        incoming: [_makeTeam(membershipId: 'm-1', userId: 'u-B')],
        isFullSnapshot: true,
        schemaVersion: 1,
      );

      final snap1 = await ds.getSection(workspaceId: 'ws-1');
      final snap2 = await ds.getSection(workspaceId: 'ws-2');
      expect(snap1.actors.first.userId, 'u-A');
      expect(snap2.actors.first.userId, 'u-B');
    });

    test('meta team es independiente de meta network del mismo workspace',
        () async {
      // Inserta team
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeTeam(membershipId: 'm-1', userId: 'u-1')],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      // markSyncFailed solo de team — no debe tocar otra sección.
      await ds.markSyncFailed(workspaceId: 'ws-1', errorCode: '5xx');
      final teamMeta = await ds.getSectionMeta(workspaceId: 'ws-1');
      expect(teamMeta!.sectionKey, 'team');
      expect(teamMeta.syncStatus, NetworkSectionSyncStatus.syncFailed);

      // Confirmar que no se creó accidentalmente meta de "network".
      final networkMetaKey = NetworkSectionMetaModel.makeCompositeKey(
          workspaceId: 'ws-1', sectionKey: 'network');
      final networkMeta = await isar.networkSectionMetaModels
          .filter()
          .compositeKeyEqualTo(networkMetaKey)
          .findFirst();
      expect(networkMeta, isNull);
    });
  });

  group('integridad de campos', () {
    test('source/syncState V1 = serverRefresh/confirmed', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeTeam(membershipId: 'm-1', userId: 'u-1')],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      final row = await isar.teamActorCacheModels.where().findFirst();
      expect(row!.source, NetworkCacheSource.serverRefresh);
      expect(row.syncState, NetworkCacheSyncState.confirmed);
      expect(row.clientGeneratedId, isNull);
      expect(row.serverConfirmedAt, isNull);
    });

    test('campos planos sincronizados con projectionJson', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeTeam(
            membershipId: 'm-zzz',
            userId: 'u-zzz',
            displayName: 'José Núñez',
          ),
        ],
        isFullSnapshot: true,
        schemaVersion: 1,
      );
      final row = await isar.teamActorCacheModels.where().findFirst();
      expect(row!.membershipId, 'm-zzz');
      expect(row.userId, 'u-zzz');
      expect(row.actorRefRaw, 'user:u-zzz');
      expect(row.displayName, 'José Núñez');
      expect(row.displayNameNormalized, 'jose nunez');
    });
  });
}
