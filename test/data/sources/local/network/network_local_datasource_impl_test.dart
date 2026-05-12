import 'package:avanzza/core/utils/text_normalization.dart';
import 'package:avanzza/data/models/network/network_actor_cache_model.dart';
import 'package:avanzza/data/models/network/network_actor_projection.dart';
import 'package:avanzza/data/models/network/network_cache_enums.dart';
import 'package:avanzza/data/models/network/network_section_meta_model.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../../../../helpers/isar_test_db_network_cache.dart';

/// Construye una proyección network sintética para tests, ya con
/// `displayNameNormalized` calculado por `normalizeForSearch`.
NetworkActorProjection _makeProj({
  required String actorRefRaw,
  String displayName = 'Actor X',
  String? providerProfileId,
  List<String> categories = const ['workshop'],
  String primaryCategory = 'workshop',
  String relationshipState = 'vinculada',
  bool isRestricted = false,
  String? restrictionReason,
  String? primaryPhoneE164 = '+573001234567',
  String? primaryEmail = 'x@y.co',
  bool hasWhatsApp = true,
  DateTime? updatedAt,
  List<String> sectionKeys = const ['parts_and_supplies'],
}) {
  // Derivar kind / id del ref crudo.
  final parts = actorRefRaw.split(':');
  final kind = parts.first;
  final id = parts.last;
  return NetworkActorProjection(
    actorRefRaw: actorRefRaw,
    actorRefKind: kind,
    actorRefId: id,
    providerProfileId: providerProfileId,
    displayName: displayName,
    displayNameNormalized: normalizeForSearch(displayName),
    avatarRef: null,
    primaryCategoryKey: primaryCategory,
    categoriesAllKeys: categories,
    relationshipState: relationshipState,
    isRestricted: isRestricted,
    restrictionReason: restrictionReason,
    sectionKeys: sectionKeys,
    primaryPhoneE164: primaryPhoneE164,
    primaryEmail: primaryEmail,
    hasWhatsApp: hasWhatsApp,
    updatedAt: updatedAt ?? DateTime.utc(2026, 5, 11, 10, 0, 0),
  );
}

void main() {
  late Isar isar;
  late NetworkLocalDataSourceImpl ds;

  setUp(() async {
    isar = await openTestIsarForNetworkCache();
    ds = NetworkLocalDataSourceImpl(isar);
  });

  tearDown(() async {
    await closeTestIsarNetworkCache(isar);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Upsert idempotente y meta inicial
  // ──────────────────────────────────────────────────────────────────────────
  group('reconcileFromServer — upsert idempotente', () {
    test('primer sync inserta actores + crea meta confirmada', () async {
      final report = await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a', displayName: 'Auto Korea'),
          _makeProj(actorRefRaw: 'platform:b', displayName: 'Peña Motors'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        nextCursor: null,
        serverTime: DateTime.utc(2026, 5, 11, 10),
        now: DateTime.utc(2026, 5, 11, 10),
      );

      expect(report.upserted, 2);
      expect(report.markedMissing, 0);
      expect(report.blindajeActivated, isFalse);

      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.actors.map((p) => p.actorRefRaw).toList(),
          ['platform:a', 'platform:b']);
      expect(snap.meta, isNotNull);
      expect(snap.meta!.syncStatus, NetworkSectionSyncStatus.confirmed);
      expect(snap.meta!.itemCountLastSync, 2);
      expect(snap.meta!.missingItemCount, 0);
      expect(snap.meta!.consecutiveFailures, 0);
      // Isar community devuelve DateTime en zona local aunque el stored sea UTC.
      expect(
        snap.meta!.lastSyncedAt!.isAtSameMomentAs(DateTime.utc(2026, 5, 11, 10)),
        isTrue,
      );
    });

    test('segundo sync con los mismos actores NO duplica filas', () async {
      final base = [
        _makeProj(actorRefRaw: 'platform:a'),
        _makeProj(actorRefRaw: 'platform:b'),
      ];
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: base,
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 10),
      );
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: base,
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 11),
      );

      final count = await isar.networkActorCacheModels.count();
      expect(count, 2, reason: 'idempotente: replace en unique index');

      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.actors.length, 2);
    });

    test('upsert actualiza campos mutables del actor', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(
            actorRefRaw: 'platform:a',
            displayName: 'Auto Korea v1',
            primaryPhoneE164: '+573001111111',
          ),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 10),
      );
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(
            actorRefRaw: 'platform:a',
            displayName: 'Auto Korea v2',
            primaryPhoneE164: '+573002222222',
            updatedAt: DateTime.utc(2026, 5, 11, 12),
          ),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 12),
      );

      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.actors.length, 1);
      expect(snap.actors.first.displayName, 'Auto Korea v2');
      expect(snap.actors.first.primaryPhoneE164, '+573002222222');
      expect(snap.actors.first.updatedAt, DateTime.utc(2026, 5, 11, 12));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Atomicidad + rollback (writeTxn único)
  // ──────────────────────────────────────────────────────────────────────────
  group('atomicidad y rollback — writeTxn único', () {
    test(
        'si falla persistencia tras upsert de actores → rollback completo: '
        'ni actores nuevos quedan ni meta avanza',
        () async {
      // Estado previo: 1 actor + meta confirmada con timestamp T0.
      final t0 = DateTime.utc(2026, 5, 11, 9);
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:OLD', displayName: 'Old')],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: t0,
      );
      final metaBefore = await ds.getSectionMeta(workspaceId: 'ws-1');
      expect(metaBefore!.lastSyncedAt!.isAtSameMomentAs(t0), isTrue);
      expect(metaBefore.itemCountLastSync, 1);

      // Inyectar falla DESPUÉS del upsert pero ANTES del meta write.
      ds.testFailureHookAfterActors = () async {
        throw StateError('simulated failure mid-txn');
      };

      // Intentar segundo sync con 3 actores nuevos.
      Object? caught;
      try {
        await ds.reconcileFromServer(
          workspaceId: 'ws-1',
          incoming: [
            _makeProj(actorRefRaw: 'platform:NEW1'),
            _makeProj(actorRefRaw: 'platform:NEW2'),
            _makeProj(actorRefRaw: 'platform:NEW3'),
          ],
          isFullSnapshot: true,
          schemaVersion: 2,
          now: DateTime.utc(2026, 5, 11, 11),
        );
      } catch (e) {
        caught = e;
      }
      expect(caught, isA<StateError>());

      // ── Garantía 1: NO hay actores nuevos persistidos.
      final allActors = await isar.networkActorCacheModels.where().findAll();
      expect(allActors.length, 1, reason: 'rollback: nuevos descartados');
      expect(allActors.first.actorRefRaw, 'platform:OLD');

      // ── Garantía 2: meta NO avanzó (lastSyncedAt sigue en T0).
      final metaAfter = await ds.getSectionMeta(workspaceId: 'ws-1');
      expect(metaAfter!.lastSyncedAt!.isAtSameMomentAs(t0), isTrue);
      expect(metaAfter.itemCountLastSync, 1);
      expect(metaAfter.syncStatus, NetworkSectionSyncStatus.confirmed);

      // ── Garantía 3: el OLD original sigue marcado como visible (no missing
      //                accidental por txn parcial).
      expect(allActors.first.missingInLastSync, isFalse);
    });

    test(
        'rollback en primer sync (sin meta previa) deja la base limpia: '
        'sin actores y sin meta',
        () async {
      ds.testFailureHookAfterActors = () async {
        throw StateError('fail mid-first-sync');
      };

      Object? caught;
      try {
        await ds.reconcileFromServer(
          workspaceId: 'ws-1',
          incoming: [_makeProj(actorRefRaw: 'platform:a')],
          isFullSnapshot: true,
          schemaVersion: 2,
        );
      } catch (e) {
        caught = e;
      }
      expect(caught, isA<StateError>());

      final actorCount = await isar.networkActorCacheModels.count();
      final metaCount = await isar.networkSectionMetaModels.count();
      expect(actorCount, 0);
      expect(metaCount, 0,
          reason: 'meta no debe crearse en estado "fresh" falso');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Blindajes anti-mass-delete
  // ──────────────────────────────────────────────────────────────────────────
  group('blindaje — incoming vacío no purga ni marca missing', () {
    test('refresh con items:[] no borra ni marca missing', () async {
      // Sembrar cache con 3 actores.
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
          _makeProj(actorRefRaw: 'platform:c'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 10),
      );

      final report = await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: const [],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 11),
      );

      expect(report.blindajeActivated, isTrue);
      expect(report.blindajeReason, 'incoming_empty');
      expect(report.markedMissing, 0);

      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.actors.length, 3, reason: 'cache intacta');
      for (final a in snap.actors) {
        // Ninguno marcado missing accidentalmente.
        final row = await isar.networkActorCacheModels
            .filter()
            .actorRefRawEqualTo(a.actorRefRaw)
            .findFirst();
        expect(row!.missingInLastSync, isFalse);
      }
    });
  });

  group('blindaje — caída >50% no destruye cache', () {
    test('si más del 50% del set previo desaparecería, no marca missing',
        () async {
      // Sembrar 4 actores.
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
          _makeProj(actorRefRaw: 'platform:c'),
          _makeProj(actorRefRaw: 'platform:d'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 10),
      );

      // Segundo refresh trae solo 1 → 3/4 = 75% desaparecerían.
      final report = await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 11),
      );

      expect(report.blindajeActivated, isTrue);
      expect(report.blindajeReason, 'delta_over_50');
      expect(report.suspiciousShrink, isTrue);
      expect(report.wouldHaveBeenMissing, 3);
      expect(report.markedMissing, 0,
          reason: 'blindaje impide marcar missing masivamente');

      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.actors.length, 4, reason: 'cache intacta visualmente');
      for (final a in snap.actors) {
        final row = await isar.networkActorCacheModels
            .filter()
            .actorRefRawEqualTo(a.actorRefRaw)
            .findFirst();
        expect(row!.missingInLastSync, isFalse);
      }
      expect(snap.meta!.suspiciousShrinkFlag, isTrue);
      expect(snap.meta!.missingItemCount, 0);
    });

    test('caída justo en 50% (exacta) tampoco activa blindaje delta', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
          _makeProj(actorRefRaw: 'platform:c'),
          _makeProj(actorRefRaw: 'platform:d'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 10),
      );
      // 2 desaparecen = 50% exacto → permitido marcar missing.
      final report = await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 11),
      );
      expect(report.blindajeActivated, isFalse);
      expect(report.markedMissing, 2);
    });

    test('caída <50% permite marcar missing normalmente', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
          _makeProj(actorRefRaw: 'platform:c'),
          _makeProj(actorRefRaw: 'platform:d'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 10),
      );
      // 1 desaparece = 25% → marca missing.
      final report = await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
          _makeProj(actorRefRaw: 'platform:c'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 11),
      );
      expect(report.blindajeActivated, isFalse);
      expect(report.markedMissing, 1);

      // d ahora visible con badge missing.
      final all = await ds.getSection(workspaceId: 'ws-1');
      final d = all.actors.firstWhere((p) => p.actorRefRaw == 'platform:d');
      final dRow = await isar.networkActorCacheModels
          .filter()
          .actorRefRawEqualTo(d.actorRefRaw)
          .findFirst();
      expect(dRow!.missingInLastSync, isTrue);
      expect(all.meta!.missingItemCount, 1);
    });
  });

  group('blindaje — paginación (not_full_snapshot)', () {
    test('respuesta con nextCursor solo upserta, no marca missing', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 10),
      );

      final report = await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:c')],
        isFullSnapshot: false,
        schemaVersion: 2,
        nextCursor: 'cursor-page-2',
        now: DateTime.utc(2026, 5, 11, 11),
      );

      expect(report.blindajeActivated, isTrue);
      expect(report.blindajeReason, 'not_full_snapshot');
      expect(report.markedMissing, 0);

      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.actors.length, 3,
          reason: 'paginada solo agrega, no purga ni marca missing');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // missingInLastSync — política y re-aparición
  // ──────────────────────────────────────────────────────────────────────────
  group('missingInLastSync — política y reaparición', () {
    test('actor que reaparece se desmarca de missing', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 10),
      );
      // b desaparece → se marca missing.
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 11),
      );
      final bRow = await isar.networkActorCacheModels
          .filter()
          .actorRefRawEqualTo('platform:b')
          .findFirst();
      expect(bRow!.missingInLastSync, isTrue);

      // b reaparece → upsert resetea el flag.
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 12),
      );
      final bRow2 = await isar.networkActorCacheModels
          .filter()
          .actorRefRawEqualTo('platform:b')
          .findFirst();
      expect(bRow2!.missingInLastSync, isFalse);

      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.meta!.missingItemCount, 0);
    });

    test('lastSeenAt NO se actualiza para actor recién marcado missing', () async {
      final t1 = DateTime.utc(2026, 5, 11, 10);
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: t1,
      );

      final t2 = DateTime.utc(2026, 5, 11, 14);
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: t2,
      );

      final bRow = await isar.networkActorCacheModels
          .filter()
          .actorRefRawEqualTo('platform:b')
          .findFirst();
      expect(bRow!.missingInLastSync, isTrue);
      expect(bRow.lastSeenAt!.isAtSameMomentAs(t1), isTrue,
          reason: 'lastSeenAt queda fijo en el último avistamiento real');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // includeMissing filter (preparación para hide/archive futuro)
  // ──────────────────────────────────────────────────────────────────────────
  group('getSection — filtro includeMissing', () {
    test('includeMissing=false oculta actores marcados missing', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );

      final withMissing =
          await ds.getSection(workspaceId: 'ws-1', includeMissing: true);
      final withoutMissing =
          await ds.getSection(workspaceId: 'ws-1', includeMissing: false);

      expect(withMissing.actors.length, 2);
      expect(withoutMissing.actors.length, 1);
      expect(withoutMissing.actors.first.actorRefRaw, 'platform:a');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Búsqueda local por displayNameNormalized
  // ──────────────────────────────────────────────────────────────────────────
  group('searchByDisplayName — tolerancia ES/CO', () {
    setUp(() async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:1', displayName: 'Peña Motors'),
          _makeProj(actorRefRaw: 'platform:2', displayName: 'Niño Repuestos'),
          _makeProj(actorRefRaw: 'platform:3', displayName: 'Auto Korea S.A.S.'),
          _makeProj(actorRefRaw: 'platform:4', displayName: 'José Núñez'),
          _makeProj(actorRefRaw: 'platform:5', displayName: 'Lubricantes y Aceites'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
    });

    test('búsqueda con ñ matchea (peña)', () async {
      final r = await ds.searchByDisplayName(workspaceId: 'ws-1', query: 'peña');
      expect(r.map((p) => p.displayName), contains('Peña Motors'));
    });

    test('búsqueda sin ñ matchea (pena → peña)', () async {
      final r = await ds.searchByDisplayName(workspaceId: 'ws-1', query: 'pena');
      expect(r.map((p) => p.displayName), contains('Peña Motors'));
    });

    test('búsqueda mayúsculas matchea (PEÑA)', () async {
      final r = await ds.searchByDisplayName(workspaceId: 'ws-1', query: 'PEÑA');
      expect(r.map((p) => p.displayName), contains('Peña Motors'));
    });

    test('búsqueda con tilde matchea (núñez)', () async {
      final r =
          await ds.searchByDisplayName(workspaceId: 'ws-1', query: 'núñez');
      expect(r.map((p) => p.displayName), contains('José Núñez'));
    });

    test('búsqueda sin tilde matchea (nunez)', () async {
      final r =
          await ds.searchByDisplayName(workspaceId: 'ws-1', query: 'nunez');
      expect(r.map((p) => p.displayName), contains('José Núñez'));
    });

    test('búsqueda con espacios extra matchea (  auto korea )', () async {
      final r = await ds.searchByDisplayName(
          workspaceId: 'ws-1', query: '  auto korea ');
      expect(r.map((p) => p.displayName), contains('Auto Korea S.A.S.'));
    });

    test('búsqueda con puntuación matchea (S.A.S. → sas)', () async {
      final r = await ds.searchByDisplayName(workspaceId: 'ws-1', query: 's.a.s');
      expect(r.map((p) => p.displayName), contains('Auto Korea S.A.S.'));
    });

    test('búsqueda con substring matchea (lubricantes y)', () async {
      final r = await ds.searchByDisplayName(
          workspaceId: 'ws-1', query: 'lubricantes y');
      expect(r.map((p) => p.displayName), contains('Lubricantes y Aceites'));
    });

    test('búsqueda sin resultados retorna lista vacía', () async {
      final r =
          await ds.searchByDisplayName(workspaceId: 'ws-1', query: 'xxxxxxx');
      expect(r, isEmpty);
    });

    test('query vacía/solo puntuación retorna lista vacía', () async {
      expect(
          await ds.searchByDisplayName(workspaceId: 'ws-1', query: ''),
          isEmpty);
      expect(
          await ds.searchByDisplayName(workspaceId: 'ws-1', query: '   '),
          isEmpty);
      expect(
          await ds.searchByDisplayName(workspaceId: 'ws-1', query: '.,;!?'),
          isEmpty);
    });

    test('búsqueda en workspace distinto no matchea actores de otro workspace',
        () async {
      final r =
          await ds.searchByDisplayName(workspaceId: 'ws-OTRO', query: 'peña');
      expect(r, isEmpty);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Aislamiento por workspace / orgId
  // ──────────────────────────────────────────────────────────────────────────
  group('separación estricta por workspace', () {
    test('actores de ws-1 no aparecen al leer ws-2', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a', displayName: 'A-en-1')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      await ds.reconcileFromServer(
        workspaceId: 'ws-2',
        incoming: [_makeProj(actorRefRaw: 'platform:a', displayName: 'A-en-2')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );

      final snap1 = await ds.getSection(workspaceId: 'ws-1');
      final snap2 = await ds.getSection(workspaceId: 'ws-2');

      expect(snap1.actors.length, 1);
      expect(snap1.actors.first.displayName, 'A-en-1');
      expect(snap2.actors.length, 1);
      expect(snap2.actors.first.displayName, 'A-en-2');
    });

    test('meta es independiente por workspace', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 10),
      );
      await ds.markSyncFailed(
        workspaceId: 'ws-2',
        errorCode: 'timeout',
        now: DateTime.utc(2026, 5, 11, 11),
      );

      final m1 = await ds.getSectionMeta(workspaceId: 'ws-1');
      final m2 = await ds.getSectionMeta(workspaceId: 'ws-2');

      expect(m1!.syncStatus, NetworkSectionSyncStatus.confirmed);
      expect(m1.lastErrorCode, isNull);
      expect(m2!.syncStatus, NetworkSectionSyncStatus.syncFailed);
      expect(m2.lastErrorCode, 'timeout');
      expect(m2.consecutiveFailures, 1);
    });

    test(
        'reconcile en ws-1 con incoming=[] (blindaje) no afecta cache de ws-2',
        () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:x')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      await ds.reconcileFromServer(
        workspaceId: 'ws-2',
        incoming: [
          _makeProj(actorRefRaw: 'platform:y'),
          _makeProj(actorRefRaw: 'platform:z'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
      );

      // Refresh vacío en ws-1 — blindaje. ws-2 no se toca.
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: const [],
        isFullSnapshot: true,
        schemaVersion: 2,
      );

      final snap1 = await ds.getSection(workspaceId: 'ws-1');
      final snap2 = await ds.getSection(workspaceId: 'ws-2');
      expect(snap1.actors.length, 1);
      expect(snap2.actors.length, 2);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // markSyncFailed — solo meta, sin tocar actores
  // ──────────────────────────────────────────────────────────────────────────
  group('markSyncFailed — atomicidad y no destrucción de cache', () {
    test('NO toca actores, solo meta', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
        now: DateTime.utc(2026, 5, 11, 10),
      );

      await ds.markSyncFailed(
        workspaceId: 'ws-1',
        errorCode: '5xx',
        now: DateTime.utc(2026, 5, 11, 11),
      );

      final snap = await ds.getSection(workspaceId: 'ws-1');
      expect(snap.actors.length, 2);
      expect(
        snap.meta!.lastSyncedAt!.isAtSameMomentAs(DateTime.utc(2026, 5, 11, 10)),
        isTrue,
        reason: 'lastSyncedAt queda en el último éxito',
      );
      expect(
        snap.meta!.lastSyncAttemptAt!
            .isAtSameMomentAs(DateTime.utc(2026, 5, 11, 11)),
        isTrue,
      );
      expect(snap.meta!.syncStatus, NetworkSectionSyncStatus.syncFailed);
      expect(snap.meta!.lastErrorCode, '5xx');
      expect(snap.meta!.consecutiveFailures, 1);
    });

    test('fallas consecutivas incrementan consecutiveFailures', () async {
      await ds.markSyncFailed(workspaceId: 'ws-1', errorCode: 'timeout');
      await ds.markSyncFailed(workspaceId: 'ws-1', errorCode: 'timeout');
      await ds.markSyncFailed(workspaceId: 'ws-1', errorCode: '5xx');
      final meta = await ds.getSectionMeta(workspaceId: 'ws-1');
      expect(meta!.consecutiveFailures, 3);
      expect(meta.lastErrorCode, '5xx');
    });

    test(
        'sync exitoso tras fallas resetea consecutiveFailures y lastErrorCode',
        () async {
      await ds.markSyncFailed(workspaceId: 'ws-1', errorCode: 'timeout');
      await ds.markSyncFailed(workspaceId: 'ws-1', errorCode: 'timeout');
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      final meta = await ds.getSectionMeta(workspaceId: 'ws-1');
      expect(meta!.consecutiveFailures, 0);
      expect(meta.lastErrorCode, isNull);
      expect(meta.syncStatus, NetworkSectionSyncStatus.confirmed);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Integridad de campos cacheados
  // ──────────────────────────────────────────────────────────────────────────
  group('integridad — campos persistidos correctamente', () {
    test('source/syncState V1 = serverRefresh/confirmed (no optimistic)', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      final row = await isar.networkActorCacheModels
          .filter()
          .actorRefRawEqualTo('platform:a')
          .findFirst();
      expect(row!.source, NetworkCacheSource.serverRefresh);
      expect(row.syncState, NetworkCacheSyncState.confirmed);
      expect(row.clientGeneratedId, isNull);
      expect(row.serverConfirmedAt, isNull);
      expect(row.failedSyncReason, isNull);
    });

    test(
        'projectionSchemaVersion se estampa con kCurrentProjectionSchemaVersion',
        () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      final row = await isar.networkActorCacheModels.where().findFirst();
      expect(row!.projectionSchemaVersion,
          NetworkSectionMetaModel.kCurrentProjectionSchemaVersion);

      final meta = await ds.getSectionMeta(workspaceId: 'ws-1');
      expect(meta!.projectionSchemaVersion,
          NetworkSectionMetaModel.kCurrentProjectionSchemaVersion);
    });

    test('campos indexados sincronizados con projectionJson', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(
            actorRefRaw: 'platform:abc',
            displayName: 'Peña Motors',
            categories: ['workshop', 'provider'],
            primaryCategory: 'workshop',
          ),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      final row = await isar.networkActorCacheModels.where().findFirst();
      expect(row!.displayName, 'Peña Motors');
      expect(row.displayNameNormalized, 'pena motors');
      expect(row.primaryCategoryKey, 'workshop');
      expect(row.categoriesAllKeys, ['workshop', 'provider']);
      expect(row.actorRefKind, 'platform');
      expect(row.actorRefId, 'abc');
    });
  });
}
