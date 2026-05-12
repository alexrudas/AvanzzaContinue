import 'package:avanzza/data/models/network/network_cache_enums.dart';
import 'package:avanzza/data/models/network/network_section_meta_model.dart';
import 'package:avanzza/data/repositories/network/refresh_network_outcome.dart';
import 'package:avanzza/presentation/controllers/network/v2/section_classifier.dart';
import 'package:avanzza/presentation/controllers/network/v2/section_ui_state.dart';
import 'package:flutter_test/flutter_test.dart';

NetworkSectionMetaModel _meta({
  String workspaceId = 'ws-1',
  String sectionKey = 'network',
  DateTime? lastSyncedAt,
  DateTime? lastSyncAttemptAt,
  NetworkSectionSyncStatus syncStatus = NetworkSectionSyncStatus.confirmed,
  String? lastErrorCode,
  int projectionSchemaVersion =
      NetworkSectionMetaModel.kCurrentProjectionSchemaVersion,
  int itemCountLastSync = 0,
  int missingItemCount = 0,
  int consecutiveFailures = 0,
}) {
  return NetworkSectionMetaModel()
    ..compositeKey = NetworkSectionMetaModel.makeCompositeKey(
      workspaceId: workspaceId,
      sectionKey: sectionKey,
    )
    ..workspaceId = workspaceId
    ..sectionKey = sectionKey
    ..schemaVersion = 2
    ..projectionSchemaVersion = projectionSchemaVersion
    ..nextCursor = null
    ..hasReachedEnd = true
    ..serverTime = null
    ..lastSyncedAt = lastSyncedAt
    ..lastSyncAttemptAt = lastSyncAttemptAt
    ..syncStatus = syncStatus
    ..lastErrorCode = lastErrorCode
    ..consecutiveFailures = consecutiveFailures
    ..itemCountLastSync = itemCountLastSync
    ..missingItemCount = missingItemCount
    ..suspiciousShrinkFlag = false;
}

void main() {
  // ──────────────────────────────────────────────────────────────────────────
  // classifyFreshness — tabla exhaustiva de umbrales
  // ──────────────────────────────────────────────────────────────────────────
  group('classifyFreshness — tabla de umbrales', () {
    final base = DateTime.utc(2026, 5, 11, 12, 0, 0);

    test('meta == null → longUnsynced (conservador)', () {
      expect(
        classifyFreshness(meta: null, now: base),
        Freshness.longUnsynced,
      );
    });

    test('meta.lastSyncedAt == null → longUnsynced', () {
      expect(
        classifyFreshness(meta: _meta(lastSyncedAt: null), now: base),
        Freshness.longUnsynced,
      );
    });

    test('projectionSchemaVersion < kCurrent → longUnsynced', () {
      expect(
        classifyFreshness(
          meta: _meta(
            lastSyncedAt: base,
            projectionSchemaVersion: 0,
          ),
          now: base,
        ),
        Freshness.longUnsynced,
      );
    });

    test('age = 0 → fresh', () {
      expect(
        classifyFreshness(meta: _meta(lastSyncedAt: base), now: base),
        Freshness.fresh,
      );
    });

    test('age = 4min59s → fresh', () {
      expect(
        classifyFreshness(
          meta: _meta(
              lastSyncedAt:
                  base.subtract(const Duration(minutes: 4, seconds: 59))),
          now: base,
        ),
        Freshness.fresh,
      );
    });

    test('age = 5min exacto → fresh (borde superior inclusivo)', () {
      expect(
        classifyFreshness(
          meta: _meta(lastSyncedAt: base.subtract(const Duration(minutes: 5))),
          now: base,
        ),
        Freshness.fresh,
      );
    });

    test('age = 5min1s → stale', () {
      expect(
        classifyFreshness(
          meta: _meta(
              lastSyncedAt:
                  base.subtract(const Duration(minutes: 5, seconds: 1))),
          now: base,
        ),
        Freshness.stale,
      );
    });

    test('age = 1 día → stale', () {
      expect(
        classifyFreshness(
          meta: _meta(lastSyncedAt: base.subtract(const Duration(days: 1))),
          now: base,
        ),
        Freshness.stale,
      );
    });

    test('age = 3 días exactos → stale (borde superior inclusivo)', () {
      expect(
        classifyFreshness(
          meta: _meta(lastSyncedAt: base.subtract(const Duration(days: 3))),
          now: base,
        ),
        Freshness.stale,
      );
    });

    test('age = 3 días + 1s → veryStale', () {
      expect(
        classifyFreshness(
          meta: _meta(
              lastSyncedAt:
                  base.subtract(const Duration(days: 3, seconds: 1))),
          now: base,
        ),
        Freshness.veryStale,
      );
    });

    test('age = 15 días → veryStale', () {
      expect(
        classifyFreshness(
          meta: _meta(lastSyncedAt: base.subtract(const Duration(days: 15))),
          now: base,
        ),
        Freshness.veryStale,
      );
    });

    test('age = 30 días exactos → veryStale (borde superior inclusivo)', () {
      expect(
        classifyFreshness(
          meta: _meta(lastSyncedAt: base.subtract(const Duration(days: 30))),
          now: base,
        ),
        Freshness.veryStale,
      );
    });

    test('age = 30 días + 1s → longUnsynced', () {
      expect(
        classifyFreshness(
          meta: _meta(
              lastSyncedAt:
                  base.subtract(const Duration(days: 30, seconds: 1))),
          now: base,
        ),
        Freshness.longUnsynced,
      );
    });

    test('age = 365 días → longUnsynced', () {
      expect(
        classifyFreshness(
          meta: _meta(lastSyncedAt: base.subtract(const Duration(days: 365))),
          now: base,
        ),
        Freshness.longUnsynced,
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // classifySection — Matriz V1..V15 del bug regresivo
  // ──────────────────────────────────────────────────────────────────────────
  group('classifySection — matriz V1..V15', () {
    final now = DateTime.utc(2026, 5, 11, 12, 0, 0);

    test('V1: API↑ + provider + reconcile reciente → Loaded(fresh, banners=[])',
        () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['proveedor-a'],
        meta: _meta(lastSyncedAt: now, itemCountLastSync: 1),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
      );
      expect(s, isA<SectionLoaded<String>>());
      final l = s as SectionLoaded<String>;
      expect(l.workspaceId, 'ws-1');
      expect(l.items, ['proveedor-a']);
      expect(l.freshness, Freshness.fresh);
      expect(l.banners, isEmpty);
    });

    test(
        'V2: API↓ + cache 1 item + último intento networkError → '
        'Loaded(stale) + SyncFailedBanner', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['proveedor-a'],
        meta: _meta(
          lastSyncedAt: now.subtract(const Duration(hours: 2)),
          lastSyncAttemptAt: now,
          syncStatus: NetworkSectionSyncStatus.syncFailed,
          lastErrorCode: 'timeout',
        ),
        lastRefreshOutcome: RefreshNetworkOutcome.networkError,
        now: now,
      );
      expect(s, isA<SectionLoaded<String>>());
      final l = s as SectionLoaded<String>;
      expect(l.freshness, Freshness.stale);
      expect(l.banners.length, 1);
      expect(l.banners.first, isA<SyncFailedBanner>());
      expect((l.banners.first as SyncFailedBanner).underlyingError,
          SectionErrorReason.connectionError);
    });

    test(
        'V3: API↓ + cache vacía + último intento networkError → '
        'Error(connectionError) — JAMÁS EmptyReal', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: const [],
        meta: _meta(
          lastSyncAttemptAt: now,
          syncStatus: NetworkSectionSyncStatus.syncFailed,
          lastErrorCode: 'timeout',
        ),
        lastRefreshOutcome: RefreshNetworkOutcome.networkError,
        now: now,
      );
      expect(s, isA<SectionError<String>>(),
          reason: 'timeout NUNCA debe caer en EmptyReal');
      expect((s as SectionError<String>).reason,
          SectionErrorReason.connectionError);
    });

    test('V4: API↑ + workspace vacío + refresh success → EmptyReal genuino',
        () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: const [],
        meta: _meta(
          lastSyncedAt: now,
          syncStatus: NetworkSectionSyncStatus.confirmed,
          itemCountLastSync: 0,
        ),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
      );
      expect(s, isA<SectionEmptyReal<String>>());
      expect(s.workspaceId, 'ws-1');
    });

    test(
        'V12: 401 auth error + cache vacía → Error(authError)', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: const [],
        meta: _meta(
          lastSyncAttemptAt: now,
          syncStatus: NetworkSectionSyncStatus.syncFailed,
          lastErrorCode: '401',
        ),
        lastRefreshOutcome: RefreshNetworkOutcome.authError,
        now: now,
      );
      expect((s as SectionError<String>).reason, SectionErrorReason.authError);
    });

    test('V13: 403 forbidden + cache vacía → Error(forbiddenError)', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: const [],
        meta: _meta(
          lastSyncAttemptAt: now,
          syncStatus: NetworkSectionSyncStatus.syncFailed,
          lastErrorCode: '403',
        ),
        lastRefreshOutcome: RefreshNetworkOutcome.forbidden,
        now: now,
      );
      expect((s as SectionError<String>).reason,
          SectionErrorReason.forbiddenError);
    });

    test(
        'V14: cache con projectionSchemaVersion < kCurrent + cache vacía + '
        'API↓ → Error(connectionError) [el outcome remoto domina]', () {
      // items.isEmpty + lastRefreshOutcome.failed: el outcome remoto es la
      // señal primaria. schemaIncompatible solo aplica si lastErrorCode lo
      // marca explícito.
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: const [],
        meta: _meta(
          lastSyncedAt: now.subtract(const Duration(days: 5)),
          lastSyncAttemptAt: now,
          syncStatus: NetworkSectionSyncStatus.syncFailed,
          projectionSchemaVersion: 0,
          lastErrorCode: 'timeout',
        ),
        lastRefreshOutcome: RefreshNetworkOutcome.networkError,
        now: now,
      );
      expect(
        (s as SectionError<String>).reason,
        SectionErrorReason.connectionError,
      );
    });

    test(
        'V14b: cache con items + projectionSchemaVersion < kCurrent → '
        'Loaded(longUnsynced) + StaleContentBanner', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a'],
        meta: _meta(
          lastSyncedAt: now.subtract(const Duration(days: 5)),
          projectionSchemaVersion: 0,
        ),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
      );
      expect(s, isA<SectionLoaded<String>>());
      final l = s as SectionLoaded<String>;
      expect(l.freshness, Freshness.longUnsynced);
      expect(l.banners.any((b) => b is StaleContentBanner), isTrue);
    });

    test(
        'V14c: lastErrorCode=schemaIncompatible y sin intento esta sesión → '
        'Error(schemaIncompatible)', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: const [],
        meta: _meta(
          lastSyncAttemptAt: now.subtract(const Duration(hours: 1)),
          syncStatus: NetworkSectionSyncStatus.syncFailed,
          lastErrorCode: 'schemaIncompatible',
        ),
        lastRefreshOutcome: null,
        now: now,
      );
      expect((s as SectionError<String>).reason,
          SectionErrorReason.schemaIncompatible);
    });

    test(
        'V15a: cache + edad veryStale + success → Loaded(veryStale) + '
        'StaleContentBanner solo (sin syncFailed)', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a'],
        meta: _meta(
          lastSyncedAt: now.subtract(const Duration(days: 5)),
          syncStatus: NetworkSectionSyncStatus.confirmed,
        ),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
      );
      final l = s as SectionLoaded<String>;
      expect(l.freshness, Freshness.veryStale);
      expect(l.banners.length, 1);
      expect(l.banners.first, isA<StaleContentBanner>());
      final b = l.banners.first as StaleContentBanner;
      expect(b.level, Freshness.veryStale);
      expect(b.age, const Duration(days: 5));
    });

    test(
        'V15b: cache + longUnsynced + sync ok → Loaded(longUnsynced) + '
        'StaleContentBanner', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a'],
        meta: _meta(
          lastSyncedAt: now.subtract(const Duration(days: 60)),
          syncStatus: NetworkSectionSyncStatus.confirmed,
        ),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
      );
      final l = s as SectionLoaded<String>;
      expect(l.freshness, Freshness.longUnsynced);
      expect(l.banners.length, 1);
      expect(l.banners.first, isA<StaleContentBanner>());
    });

    test(
        'V15c: cache fresh + outcome success → Loaded(fresh) sin banners',
        () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a'],
        meta: _meta(lastSyncedAt: now),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
      );
      final l = s as SectionLoaded<String>;
      expect(l.freshness, Freshness.fresh);
      expect(l.banners, isEmpty);
    });

    test(
        'V15d: cache stale + outcome success → Loaded(stale) sin banners '
        '(stale es silencioso)', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a'],
        meta: _meta(lastSyncedAt: now.subtract(const Duration(hours: 12))),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
      );
      final l = s as SectionLoaded<String>;
      expect(l.freshness, Freshness.stale);
      expect(l.banners, isEmpty);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Estado inicial — Bootstrap
  // ──────────────────────────────────────────────────────────────────────────
  group('classifySection — Bootstrap (cold start)', () {
    final now = DateTime.utc(2026, 5, 11, 12);

    test('items vacíos + lastRefreshOutcome null + meta null → Bootstrap', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: const [],
        meta: null,
        lastRefreshOutcome: null,
        now: now,
      );
      expect(s, isA<SectionBootstrap<String>>());
      expect(s.workspaceId, 'ws-1');
    });

    test(
        'items vacíos + lastRefreshOutcome null + meta sin lastSyncedAt y '
        'syncStatus confirmed → Bootstrap', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: const [],
        meta: _meta(lastSyncedAt: null),
        lastRefreshOutcome: null,
        now: now,
      );
      expect(s, isA<SectionBootstrap<String>>());
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Loaded con SyncFailedBanner desde meta persistida (sin intento sesión)
  // ──────────────────────────────────────────────────────────────────────────
  group('classifySection — SyncFailedBanner desde meta sin intento sesión',
      () {
    final now = DateTime.utc(2026, 5, 11, 12);

    test(
        'items + meta syncFailed con timeout + lastRefreshOutcome=null → '
        'Loaded + SyncFailedBanner(connectionError)', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a'],
        meta: _meta(
          lastSyncedAt: now.subtract(const Duration(hours: 1)),
          syncStatus: NetworkSectionSyncStatus.syncFailed,
          lastErrorCode: 'timeout',
        ),
        lastRefreshOutcome: null,
        now: now,
      );
      final l = s as SectionLoaded<String>;
      expect(l.banners, hasLength(1));
      expect(l.banners.first, isA<SyncFailedBanner>());
      expect((l.banners.first as SyncFailedBanner).underlyingError,
          SectionErrorReason.connectionError);
    });

    test(
        'items + meta syncFailed con 401 + lastRefreshOutcome=null → '
        'Loaded + SyncFailedBanner(authError)', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a'],
        meta: _meta(
          lastSyncedAt: now,
          syncStatus: NetworkSectionSyncStatus.syncFailed,
          lastErrorCode: '401',
        ),
        lastRefreshOutcome: null,
        now: now,
      );
      final l = s as SectionLoaded<String>;
      expect((l.banners.first as SyncFailedBanner).underlyingError,
          SectionErrorReason.authError);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // extraBanners (unmapped, etc.) se preservan
  // ──────────────────────────────────────────────────────────────────────────
  group('classifySection — extraBanners (inyección externa)', () {
    final now = DateTime.utc(2026, 5, 11, 12);

    test('items + extraBanners se anexan al Loaded result', () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a'],
        meta: _meta(lastSyncedAt: now),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
        extraBanners: const [UnmappedCategoriesBanner(unmappedCount: 2)],
      );
      final l = s as SectionLoaded<String>;
      expect(l.banners, hasLength(1));
      expect(l.banners.first, isA<UnmappedCategoriesBanner>());
      expect((l.banners.first as UnmappedCategoriesBanner).unmappedCount, 2);
    });

    test('extraBanners se combinan con banners derivados (stale + unmapped)',
        () {
      final s = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a'],
        meta: _meta(lastSyncedAt: now.subtract(const Duration(days: 10))),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
        extraBanners: const [UnmappedCategoriesBanner(unmappedCount: 1)],
      );
      final l = s as SectionLoaded<String>;
      expect(l.banners.length, 2);
      expect(l.banners.any((b) => b is StaleContentBanner), isTrue);
      expect(l.banners.any((b) => b is UnmappedCategoriesBanner), isTrue);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Garantía dura: ConnectionError NUNCA renderiza como EmptyReal
  // ──────────────────────────────────────────────────────────────────────────
  group('garantía dura — ConnectionError ⊥ EmptyReal', () {
    final now = DateTime.utc(2026, 5, 11, 12);
    final failingOutcomes = [
      RefreshNetworkOutcome.networkError,
      RefreshNetworkOutcome.serverError,
      RefreshNetworkOutcome.authError,
      RefreshNetworkOutcome.forbidden,
      RefreshNetworkOutcome.unknownError,
    ];

    for (final o in failingOutcomes) {
      test(
          'items vacíos + outcome=$o + meta variada → NUNCA EmptyReal',
          () {
        for (final meta in [
          null,
          _meta(),
          _meta(
              lastSyncedAt: now.subtract(const Duration(days: 1)),
              syncStatus: NetworkSectionSyncStatus.syncFailed,
              lastErrorCode: 'timeout'),
          _meta(
              lastSyncedAt: now,
              syncStatus: NetworkSectionSyncStatus.confirmed),
        ]) {
          final s = classifySection<String>(
            workspaceId: 'ws-1',
            items: const [],
            meta: meta,
            lastRefreshOutcome: o,
            now: now,
          );
          expect(s, isNot(isA<SectionEmptyReal<String>>()),
              reason:
                  'outcome=$o meta=$meta no debe colapsar en EmptyReal');
          expect(s, isA<SectionError<String>>());
        }
      });
    }
  });

  // ──────────────────────────────────────────────────────────────────────────
  // workspaceId — siempre propagado, no mezclado
  // ──────────────────────────────────────────────────────────────────────────
  group('workspaceId propagation', () {
    final now = DateTime.utc(2026, 5, 11, 12);

    test('workspaceId del input se preserva en cada variante', () {
      const ws = 'workspace-zzz-9999';
      final variants = <SectionUiState>[
        classifySection<String>(
          workspaceId: ws,
          items: const [],
          meta: null,
          lastRefreshOutcome: null,
          now: now,
        ),
        classifySection<String>(
          workspaceId: ws,
          items: ['a'],
          meta: _meta(lastSyncedAt: now, workspaceId: ws),
          lastRefreshOutcome: RefreshNetworkOutcome.success,
          now: now,
        ),
        classifySection<String>(
          workspaceId: ws,
          items: const [],
          meta: _meta(
            lastSyncedAt: now,
            syncStatus: NetworkSectionSyncStatus.confirmed,
            workspaceId: ws,
          ),
          lastRefreshOutcome: RefreshNetworkOutcome.success,
          now: now,
        ),
        classifySection<String>(
          workspaceId: ws,
          items: const [],
          meta: null,
          lastRefreshOutcome: RefreshNetworkOutcome.networkError,
          now: now,
        ),
      ];
      for (final v in variants) {
        expect(v.workspaceId, ws,
            reason: 'workspaceId debe propagarse en ${v.runtimeType}');
      }
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Equality / hashCode — garantiza distinct() en Rx<SectionUiState>
  // ──────────────────────────────────────────────────────────────────────────
  group('equality / hashCode', () {
    final now = DateTime.utc(2026, 5, 11, 12);

    test('dos Bootstrap con mismo workspaceId son iguales', () {
      expect(
        const SectionBootstrap<String>(workspaceId: 'ws-1'),
        const SectionBootstrap<String>(workspaceId: 'ws-1'),
      );
    });

    test('dos EmptyReal con mismo workspaceId son iguales', () {
      expect(
        const SectionEmptyReal<String>(workspaceId: 'ws-1'),
        const SectionEmptyReal<String>(workspaceId: 'ws-1'),
      );
    });

    test('Error con misma reason son iguales', () {
      expect(
        const SectionError<String>(
          workspaceId: 'ws-1',
          reason: SectionErrorReason.connectionError,
        ),
        const SectionError<String>(
          workspaceId: 'ws-1',
          reason: SectionErrorReason.connectionError,
        ),
      );
    });

    test('Loaded con misma data y banners son iguales', () {
      final a = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a', 'b'],
        meta: _meta(lastSyncedAt: now),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
      );
      final b = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a', 'b'],
        meta: _meta(lastSyncedAt: now),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('Loaded difiere si cambia freshness', () {
      final fresh = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a'],
        meta: _meta(lastSyncedAt: now),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
      );
      final stale = classifySection<String>(
        workspaceId: 'ws-1',
        items: ['a'],
        meta: _meta(lastSyncedAt: now.subtract(const Duration(hours: 1))),
        lastRefreshOutcome: RefreshNetworkOutcome.success,
        now: now,
      );
      expect(fresh == stale, isFalse);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // SectionBanner equality (necesario para distinct en banners list)
  // ──────────────────────────────────────────────────────────────────────────
  group('SectionBanner equality', () {
    test('SyncFailedBanner equal por underlyingError', () {
      expect(
        const SyncFailedBanner(
            underlyingError: SectionErrorReason.connectionError),
        const SyncFailedBanner(
            underlyingError: SectionErrorReason.connectionError),
      );
      expect(
        const SyncFailedBanner(
            underlyingError: SectionErrorReason.connectionError),
        isNot(const SyncFailedBanner(
            underlyingError: SectionErrorReason.authError)),
      );
    });

    test('StaleContentBanner equal por level + age', () {
      expect(
        const StaleContentBanner(
            level: Freshness.veryStale, age: Duration(days: 5)),
        const StaleContentBanner(
            level: Freshness.veryStale, age: Duration(days: 5)),
      );
      expect(
        const StaleContentBanner(
            level: Freshness.veryStale, age: Duration(days: 5)),
        isNot(const StaleContentBanner(
            level: Freshness.veryStale, age: Duration(days: 10))),
      );
    });

    test('UnmappedCategoriesBanner equal por unmappedCount', () {
      expect(
        const UnmappedCategoriesBanner(unmappedCount: 3),
        const UnmappedCategoriesBanner(unmappedCount: 3),
      );
      expect(
        const UnmappedCategoriesBanner(unmappedCount: 3),
        isNot(const UnmappedCategoriesBanner(unmappedCount: 4)),
      );
    });
  });
}
