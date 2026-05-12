import 'package:avanzza/core/utils/text_normalization.dart';
import 'package:avanzza/data/models/network/network_actor_projection.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../../../../helpers/isar_test_db_network_cache.dart';

NetworkActorProjection _makeProj({
  required String actorRefRaw,
  String displayName = 'Actor X',
  List<String> categories = const ['workshop'],
  String primaryCategory = 'workshop',
  String relationshipState = 'vinculada',
  bool isRestricted = false,
  String? providerProfileId,
  DateTime? updatedAt,
  List<String> sectionKeys = const ['parts_and_supplies'],
}) {
  final parts = actorRefRaw.split(':');
  return NetworkActorProjection(
    actorRefRaw: actorRefRaw,
    actorRefKind: parts.first,
    actorRefId: parts.last,
    providerProfileId: providerProfileId,
    displayName: displayName,
    displayNameNormalized: normalizeForSearch(displayName),
    avatarRef: null,
    primaryCategoryKey: primaryCategory,
    categoriesAllKeys: categories,
    relationshipState: relationshipState,
    isRestricted: isRestricted,
    restrictionReason: null,
    primaryPhoneE164: '+573001234567',
    primaryEmail: 'x@y.co',
    hasWhatsApp: true,
    updatedAt: updatedAt ?? DateTime.utc(2026, 5, 11, 10),
    sectionKeys: sectionKeys,
  );
}

/// Cede el event loop varias veces para permitir que Isar dispare watchers
/// y que `emitCurrent` complete su `await getSection(...)`.
Future<void> _settle([Duration d = const Duration(milliseconds: 50)]) async {
  await Future<void>.delayed(d);
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
  // watchSection — emisiones
  // ──────────────────────────────────────────────────────────────────────────

  group('watchSection — emisión inicial y reactividad', () {
    test('emite UN snapshot inmediato al suscribirse, con workspaceId correcto',
        () async {
      final events = <NetworkSectionSnapshot>[];
      final sub = ds.watchSection(workspaceId: 'ws-1').listen(events.add);
      await _settle();

      expect(events.length, 1);
      expect(events.first.workspaceId, 'ws-1');
      expect(events.first.actors, isEmpty);
      expect(events.first.meta, isNull);

      await sub.cancel();
    });

    test('re-emite tras reconcileFromServer (cambio en actores)', () async {
      final events = <NetworkSectionSnapshot>[];
      final sub = ds.watchSection(workspaceId: 'ws-1').listen(events.add);
      await _settle();
      expect(events.length, 1);

      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a', displayName: 'A')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      await _settle();

      expect(events.length, greaterThanOrEqualTo(2));
      expect(events.last.actors.length, 1);
      expect(events.last.actors.first.actorRefRaw, 'platform:a');
      expect(events.last.meta, isNotNull);

      await sub.cancel();
    });

    test('re-emite tras markSyncFailed (cambio solo en meta)', () async {
      // Sembramos data primero para que actores no cambien al fallar.
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );

      final events = <NetworkSectionSnapshot>[];
      final sub = ds.watchSection(workspaceId: 'ws-1').listen(events.add);
      await _settle();
      final initialCount = events.length;

      await ds.markSyncFailed(workspaceId: 'ws-1', errorCode: 'timeout');
      await _settle();

      expect(events.length, greaterThan(initialCount));
      final last = events.last;
      expect(last.actors.length, 1, reason: 'actores no se borran al fallar');
      expect(last.meta!.lastErrorCode, 'timeout');

      await sub.cancel();
    });

    test('emisiones incluyen workspaceId estable en todos los eventos',
        () async {
      final events = <NetworkSectionSnapshot>[];
      final sub = ds.watchSection(workspaceId: 'ws-aaa').listen(events.add);
      await _settle();

      await ds.reconcileFromServer(
        workspaceId: 'ws-aaa',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      await _settle();

      await ds.markSyncFailed(workspaceId: 'ws-aaa', errorCode: '5xx');
      await _settle();

      expect(events, isNotEmpty);
      for (final e in events) {
        expect(e.workspaceId, 'ws-aaa');
      }
      await sub.cancel();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Aislamiento por workspace
  // ──────────────────────────────────────────────────────────────────────────

  group('watchSection — aislamiento por workspace', () {
    test('escrituras en ws-2 NO emiten para suscripción a ws-1', () async {
      final ws1Events = <NetworkSectionSnapshot>[];
      final sub = ds.watchSection(workspaceId: 'ws-1').listen(ws1Events.add);
      await _settle();
      final after = ws1Events.length;

      // Toda la actividad en ws-2 no debe disparar emisiones para ws-1.
      await ds.reconcileFromServer(
        workspaceId: 'ws-2',
        incoming: [_makeProj(actorRefRaw: 'platform:x')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      await ds.markSyncFailed(workspaceId: 'ws-2', errorCode: 'timeout');
      await _settle();

      expect(
        ws1Events.length,
        after,
        reason:
            'ws-1 no debe recibir emisiones por escrituras en ws-2 (aislamiento)',
      );
      await sub.cancel();
    });

    test('dos suscripciones a workspaces distintos reciben emisiones independientes',
        () async {
      final ws1Events = <NetworkSectionSnapshot>[];
      final ws2Events = <NetworkSectionSnapshot>[];
      final sub1 = ds.watchSection(workspaceId: 'ws-1').listen(ws1Events.add);
      final sub2 = ds.watchSection(workspaceId: 'ws-2').listen(ws2Events.add);
      await _settle();
      final base1 = ws1Events.length;
      final base2 = ws2Events.length;

      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      await _settle();

      expect(ws1Events.length, greaterThan(base1));
      expect(ws2Events.length, base2,
          reason: 'sub a ws-2 no se ve afectada por escritura en ws-1');

      await sub1.cancel();
      await sub2.cancel();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Cleanup
  // ──────────────────────────────────────────────────────────────────────────

  group('watchSection — cancel', () {
    test('tras cancel, escrituras posteriores no producen emisiones', () async {
      final events = <NetworkSectionSnapshot>[];
      final sub = ds.watchSection(workspaceId: 'ws-1').listen(events.add);
      await _settle();
      final before = events.length;

      await sub.cancel();

      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      await _settle();

      expect(events.length, before,
          reason: 'cancel detuvo las re-emisiones');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // contentSignature
  // ──────────────────────────────────────────────────────────────────────────

  group('contentSignature — estabilidad y cambio', () {
    test('snapshots idénticos (mismo workspace, sin cambios) → misma signature',
        () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );

      final a = await ds.getSection(workspaceId: 'ws-1');
      final b = await ds.getSection(workspaceId: 'ws-1');

      expect(a.contentSignature, b.contentSignature);
    });

    test('al cambiar un actor (updatedAt diferente) → signature cambia',
        () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(
            actorRefRaw: 'platform:a',
            updatedAt: DateTime.utc(2026, 5, 11, 10),
          ),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      final before = (await ds.getSection(workspaceId: 'ws-1')).contentSignature;

      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(
            actorRefRaw: 'platform:a',
            displayName: 'Actor X v2',
            updatedAt: DateTime.utc(2026, 5, 11, 12),
          ),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      final after = (await ds.getSection(workspaceId: 'ws-1')).contentSignature;

      expect(before == after, isFalse);
    });

    test('al añadir un actor → signature cambia', () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      final before = (await ds.getSection(workspaceId: 'ws-1')).contentSignature;

      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      final after = (await ds.getSection(workspaceId: 'ws-1')).contentSignature;

      expect(before == after, isFalse);
    });

    test('al cambiar meta.syncStatus (markSyncFailed) → signature cambia',
        () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      final before = (await ds.getSection(workspaceId: 'ws-1')).contentSignature;

      await ds.markSyncFailed(workspaceId: 'ws-1', errorCode: 'timeout');
      final after = (await ds.getSection(workspaceId: 'ws-1')).contentSignature;

      expect(before == after, isFalse);
    });

    test('al cambiar SOLO lastErrorCode (mismo syncStatus) → signature cambia',
        () async {
      await ds.markSyncFailed(workspaceId: 'ws-1', errorCode: 'timeout');
      final before = (await ds.getSection(workspaceId: 'ws-1')).contentSignature;

      await ds.markSyncFailed(workspaceId: 'ws-1', errorCode: '5xx');
      final after = (await ds.getSection(workspaceId: 'ws-1')).contentSignature;

      expect(before == after, isFalse,
          reason: 'signature debe propagar el cambio de lastErrorCode '
              'para que el banner se actualice');
    });

    test('mismos actores en workspaces distintos → signature DISTINTA',
        () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      await ds.reconcileFromServer(
        workspaceId: 'ws-2',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );

      final s1 = (await ds.getSection(workspaceId: 'ws-1')).contentSignature;
      final s2 = (await ds.getSection(workspaceId: 'ws-2')).contentSignature;
      expect(s1 == s2, isFalse,
          reason: 'workspaceId distinto debe producir signature distinta');
    });

    test('signature determinista — mismo state, dos lecturas seguidas',
        () async {
      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [
          _makeProj(actorRefRaw: 'platform:a'),
          _makeProj(actorRefRaw: 'platform:b'),
        ],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      final s1 = (await ds.getSection(workspaceId: 'ws-1')).contentSignature;
      final s2 = (await ds.getSection(workspaceId: 'ws-1')).contentSignature;
      final s3 = (await ds.getSection(workspaceId: 'ws-1')).contentSignature;
      expect(s1, s2);
      expect(s2, s3);
    });

    test('al limpiar lastErrorCode tras sync exitoso → signature cambia',
        () async {
      await ds.markSyncFailed(workspaceId: 'ws-1', errorCode: 'timeout');
      final failedSig =
          (await ds.getSection(workspaceId: 'ws-1')).contentSignature;

      await ds.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_makeProj(actorRefRaw: 'platform:a')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      final successSig =
          (await ds.getSection(workspaceId: 'ws-1')).contentSignature;

      expect(failedSig == successSig, isFalse);
    });
  });
}
