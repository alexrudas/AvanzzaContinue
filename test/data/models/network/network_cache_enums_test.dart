import 'package:avanzza/data/models/network/network_cache_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkCacheSource — fallback seguro al deserializar', () {
    test('nombre conocido se parsea exactamente', () {
      expect(
        networkCacheSourceFromName('serverRefresh'),
        NetworkCacheSource.serverRefresh,
      );
      expect(
        networkCacheSourceFromName('localOptimistic'),
        NetworkCacheSource.localOptimistic,
      );
    });

    test('nombre desconocido → default `serverRefresh`', () {
      expect(
        networkCacheSourceFromName('UNKNOWN_VALUE_FROM_FUTURE_BACKEND'),
        NetworkCacheSource.serverRefresh,
      );
    });

    test('null → default `serverRefresh`', () {
      expect(networkCacheSourceFromName(null), NetworkCacheSource.serverRefresh);
    });

    test('string vacío → default `serverRefresh`', () {
      expect(networkCacheSourceFromName(''), NetworkCacheSource.serverRefresh);
    });

    test('case-sensitive (no matchea variaciones)', () {
      expect(
        networkCacheSourceFromName('ServerRefresh'),
        NetworkCacheSource.serverRefresh, // fallback, no match
      );
      expect(
        networkCacheSourceFromName('SERVERREFRESH'),
        NetworkCacheSource.serverRefresh, // fallback, no match
      );
    });

    test('serialización por .name es estable para todos los valores', () {
      for (final v in NetworkCacheSource.values) {
        expect(networkCacheSourceFromName(v.name), v);
      }
    });
  });

  group('NetworkCacheSyncState — fallback seguro al deserializar', () {
    test('todos los nombres conocidos roundtripean', () {
      for (final v in NetworkCacheSyncState.values) {
        expect(networkCacheSyncStateFromName(v.name), v);
      }
    });

    test('desconocido → default `confirmed`', () {
      expect(
        networkCacheSyncStateFromName('mysteryState'),
        NetworkCacheSyncState.confirmed,
      );
    });

    test('null → default `confirmed`', () {
      expect(
        networkCacheSyncStateFromName(null),
        NetworkCacheSyncState.confirmed,
      );
    });

    test('string vacío → default `confirmed`', () {
      expect(
        networkCacheSyncStateFromName(''),
        NetworkCacheSyncState.confirmed,
      );
    });
  });

  group('NetworkSectionSyncStatus — fallback seguro al deserializar', () {
    test('todos los nombres conocidos roundtripean', () {
      for (final v in NetworkSectionSyncStatus.values) {
        expect(networkSectionSyncStatusFromName(v.name), v);
      }
    });

    test('desconocido → default `syncFailed` (conservador)', () {
      expect(
        networkSectionSyncStatusFromName('happyPath'),
        NetworkSectionSyncStatus.syncFailed,
      );
    });

    test('null → default `syncFailed`', () {
      expect(
        networkSectionSyncStatusFromName(null),
        NetworkSectionSyncStatus.syncFailed,
      );
    });
  });

  group('Catálogo cerrado — guardrail estructural', () {
    test('NetworkCacheSource tiene exactamente los 2 valores esperados', () {
      expect(NetworkCacheSource.values.length, 2);
      expect(
        NetworkCacheSource.values.map((e) => e.name).toSet(),
        {'serverRefresh', 'localOptimistic'},
      );
    });

    test('NetworkCacheSyncState tiene exactamente los 5 valores esperados', () {
      expect(NetworkCacheSyncState.values.length, 5);
      expect(
        NetworkCacheSyncState.values.map((e) => e.name).toSet(),
        {
          'confirmed',
          'pendingCreate',
          'pendingUpdate',
          'pendingDelete',
          'syncFailed',
        },
      );
    });

    test('NetworkSectionSyncStatus tiene exactamente los 2 valores esperados',
        () {
      expect(NetworkSectionSyncStatus.values.length, 2);
      expect(
        NetworkSectionSyncStatus.values.map((e) => e.name).toSet(),
        {'confirmed', 'syncFailed'},
      );
    });
  });
}
