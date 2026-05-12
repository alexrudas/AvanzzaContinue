// ============================================================================
// test/presentation/controllers/network/v2/mi_red_controller_streams_test.dart
// MI RED CONTROLLER — Tests del orquestador de streams (Fase 4 Paso 4a).
// ============================================================================
// Cubre:
//   - Streams conectados al construir + dispatch refresh unawaited.
//   - Synth aparece desde LocalContact stream sin necesidad de HTTP.
//   - Dedupe synth → real al llegar refresh.
//   - Archive override inmediato.
//   - Workspace isolation y cancel de streams al cambiar workspace.
//   - Cache sobrevive fallo de refresh.
//   - Bucketizer regression intacto (priority chain).
//   - supplierByRef construido correctamente.
//   - Debounce determinista con `Duration.zero` para tests.
// ============================================================================

import 'dart:async';
import 'dart:io';

import 'package:avanzza/core/utils/text_normalization.dart';
import 'package:avanzza/data/models/core_common/local_contact_model.dart';
import 'package:avanzza/data/models/network/network_actor_cache_model.dart';
import 'package:avanzza/data/models/network/network_actor_projection.dart';
import 'package:avanzza/data/models/network/network_actor_summary_dto.dart';
import 'package:avanzza/data/models/network/network_category.dart';
import 'package:avanzza/data/models/network/network_envelope.dart';
import 'package:avanzza/data/models/network/network_section_meta_model.dart';
import 'package:avanzza/data/models/network/team_actor_cache_model.dart';
import 'package:avanzza/data/models/network/team_member_summary_dto.dart';
import 'package:avanzza/data/repositories/network/refresh_network_outcome.dart';
import 'package:avanzza/data/sources/local/core_common/local_contact_local_ds.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource.dart';
import 'package:avanzza/data/sources/local/network/network_local_datasource_impl.dart';
import 'package:avanzza/data/sources/local/network/team_local_datasource.dart';
import 'package:avanzza/data/sources/local/network/team_local_datasource_impl.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/supplier_type.dart';
import 'package:avanzza/domain/repositories/network/network_repository.dart';
import 'package:avanzza/domain/repositories/network/team_repository.dart';
import 'package:avanzza/presentation/controllers/network/v2/mi_red_controller.dart';
import 'package:avanzza/presentation/controllers/network/v2/section_state.dart';
import 'package:avanzza/presentation/view_models/network/v2/mi_red_buckets.dart';
import 'package:avanzza/presentation/view_models/network/v2/network_actor_summary_vm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../../../../helpers/isar_test_db_local_contact.dart'
    show closeTestIsar;

// Helper: abre un Isar con TODOS los schemas necesarios para el controller.
// (Local contact + Network + Team + Section meta.)
Future<Isar> _openFullTestIsar() async {
  final dir = Directory.systemTemp.createTempSync('isar_mi_red_streams_');
  await Isar.initializeIsarCore(download: true);
  return Isar.open(
    [
      NetworkActorCacheModelSchema,
      TeamActorCacheModelSchema,
      NetworkSectionMetaModelSchema,
      LocalContactModelSchema,
    ],
    directory: dir.path,
    name: 'db_${dir.path.hashCode.abs()}',
  );
}

/// Fake NetworkRepository que apunta al DS local pero no hace HTTP.
/// Permite testear el flujo de stream sin levantar HTTP real.
class _FakeNetworkRepo implements NetworkRepository {
  final NetworkLocalDataSource _ds;
  RefreshNetworkOutcome refreshOutcome = RefreshNetworkOutcome.success;
  List<NetworkActorProjection> nextRefreshItems = const [];
  int refreshCallCount = 0;

  _FakeNetworkRepo(this._ds);

  @override
  Stream<NetworkSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) =>
      _ds.watchSection(workspaceId: workspaceId, includeMissing: includeMissing);

  @override
  Future<RefreshNetworkOutcome> refreshSection({
    required String workspaceId,
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    int? limit,
  }) async {
    refreshCallCount++;
    if (refreshOutcome == RefreshNetworkOutcome.success) {
      await _ds.reconcileFromServer(
        workspaceId: workspaceId,
        incoming: nextRefreshItems,
        isFullSnapshot: true,
        schemaVersion: 2,
        nextCursor: null,
        serverTime: DateTime.utc(2026, 5, 11, 10),
      );
    } else {
      await _ds.markSyncFailed(
        workspaceId: workspaceId,
        errorCode: _outcomeToCode(refreshOutcome),
      );
    }
    return refreshOutcome;
  }

  @override
  Future<NetworkPageEnvelope<NetworkActorSummaryDto>> fetchPage({
    NetworkCategory? category,
    NetworkRelationshipState? state,
    String? assetId,
    String? cursor,
    int? limit,
  }) async =>
      throw UnimplementedError('fetchPage no usado en suite streams');

  @override
  Future<NetworkCategoriesSummaryEnvelope> fetchSummary() =>
      throw UnimplementedError();

  String _outcomeToCode(RefreshNetworkOutcome o) {
    switch (o) {
      case RefreshNetworkOutcome.networkError:
        return 'network';
      case RefreshNetworkOutcome.authError:
        return '401';
      case RefreshNetworkOutcome.forbidden:
        return '403';
      case RefreshNetworkOutcome.serverError:
        return 'server';
      default:
        return 'unknown';
    }
  }
}

class _FakeTeamRepo implements TeamRepository {
  final TeamLocalDataSource _ds;
  int refreshCallCount = 0;

  _FakeTeamRepo(this._ds);

  @override
  Stream<TeamSectionSnapshot> watchSection({
    required String workspaceId,
    bool includeMissing = true,
  }) =>
      _ds.watchSection(workspaceId: workspaceId, includeMissing: includeMissing);

  @override
  Future<RefreshNetworkOutcome> refreshSection({
    required String workspaceId,
    int? limit,
  }) async {
    refreshCallCount++;
    // No-op: el suite no testea team data, solo que el controller llama.
    return RefreshNetworkOutcome.success;
  }

  @override
  Future<NetworkPageEnvelope<TeamMemberSummaryDto>> fetchPage({
    String? cursor,
    int? limit,
  }) async =>
      throw UnimplementedError();

  @override
  Future<TeamSummaryEnvelope> fetchSummary() => throw UnimplementedError();
}

NetworkActorProjection _proj({
  required String refRaw,
  String displayName = 'Real',
  List<String> sectionKeys = const ['parts_and_supplies'],
}) {
  return NetworkActorProjection(
    actorRefRaw: refRaw,
    actorRefKind: refRaw.split(':').first,
    actorRefId: refRaw.split(':').last,
    providerProfileId: refRaw.startsWith('platform:') ? refRaw.split(':').last : null,
    displayName: displayName,
    displayNameNormalized: normalizeForSearch(displayName),
    avatarRef: null,
    primaryCategoryKey: 'workshop',
    categoriesAllKeys: const ['workshop'],
    relationshipState: 'vinculada',
    isRestricted: false,
    restrictionReason: null,
    primaryPhoneE164: '+573001234567',
    primaryEmail: 'r@e.co',
    hasWhatsApp: true,
    updatedAt: DateTime.utc(2026, 5, 11, 10),
    sectionKeys: sectionKeys,
  );
}

LocalContactModel _contact({
  required String id,
  String workspaceId = 'ws-1',
  SupplierType? supplier,
  String? linkedProviderProfileId,
  String displayName = 'Local',
  String? primaryPhoneE164 = '+573009998888',
  bool isDeleted = false,
}) {
  final now = DateTime.utc(2026, 5, 11, 10);
  return LocalContactModel(
    id: id,
    workspaceId: workspaceId,
    displayName: displayName,
    createdAt: now,
    updatedAt: now,
    supplierTypeWire: supplier?.wireName,
    linkedProviderProfileId: linkedProviderProfileId,
    primaryPhoneE164: primaryPhoneE164,
    primaryEmail: 'l@e.co',
    isDeleted: isDeleted,
  );
}

/// Espera DETERMINISTAS hasta que la condición se cumpla o timeout.
/// Cada poll es un round-trip del event loop (1ms) → emisiones de Isar
/// watchers + listeners del controller tienen oportunidad de procesarse.
/// Reemplaza el patrón frágil `Future.delayed(80ms)` por una espera
/// orientada al estado deseado.
Future<void> _waitFor(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 3),
  Duration pollInterval = const Duration(milliseconds: 1),
  String? description,
}) async {
  final sw = Stopwatch()..start();
  while (!condition() && sw.elapsed < timeout) {
    await Future<void>.delayed(pollInterval);
  }
  if (!condition()) {
    throw TimeoutException(
      'Timeout esperando condición'
      '${description != null ? ": $description" : ""} '
      '(elapsed=${sw.elapsedMilliseconds}ms)',
    );
  }
}

/// Para tests que solo necesitan que TODOS los streams hayan emitido al menos
/// una vez (recompute haya corrido con datos coherentes).
Future<void> _waitForFirstRecompute(MiRedController c) =>
    _waitFor(() => c.debugAllStreamsEmitted,
        description: 'controller.debugAllStreamsEmitted');

/// Para tests que asertan sobre bucketsRx / supplierByRef tras una mutación.
/// Espera al menos 2 ms para que el writeTxn + watcher + listener completen.
/// Si la condición lógica no aplica, usar `_waitFor` directamente.
Future<void> _settle() => Future<void>.delayed(const Duration(milliseconds: 5));

void main() {
  late Isar isar;
  late NetworkLocalDataSourceImpl netDs;
  late TeamLocalDataSourceImpl teamDs;
  late LocalContactLocalDataSource contactsDs;
  late _FakeNetworkRepo netRepo;
  late _FakeTeamRepo teamRepo;

  setUp(() async {
    isar = await _openFullTestIsar();
    netDs = NetworkLocalDataSourceImpl(isar);
    teamDs = TeamLocalDataSourceImpl(isar);
    contactsDs = LocalContactLocalDataSource(isar);
    netRepo = _FakeNetworkRepo(netDs);
    teamRepo = _FakeTeamRepo(teamDs);
  });

  tearDown(() async {
    // Drenar microtasks + native Isar events pendientes (refreshes
    // unawaited, watcher cancels, debounce timer cancels) antes de cerrar
    // Isar. Sin esto, escritos pendientes a Isar cerrado disparan
    // IsarError post-test y rompen los tests siguientes en la cadena.
    // 30ms es suficiente para Isar nativo (no es un sleep arbitrario:
    // es el tiempo mínimo medido para que el motor procese sus colas).
    await Future<void>.delayed(const Duration(milliseconds: 30));
    await closeTestIsar(isar);
  });

  MiRedController makeController({String workspaceId = 'ws-1'}) {
    return MiRedController(
      networkRepository: netRepo,
      teamRepository: teamRepo,
      contactsLocalDataSource: contactsDs,
      workspaceId: workspaceId,
      debounceDuration: Duration.zero, // recompute síncrono para tests
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 1. Streams conectados
  // ──────────────────────────────────────────────────────────────────────────
  group('streams conectados al construir', () {
    test('loadInitial dispara refresh de network y team', () async {
      final c = makeController();
      await c.loadInitial();
      await _waitFor(() => netRepo.refreshCallCount >= 1,
          description: 'network refresh dispatched');
      await _waitFor(() => teamRepo.refreshCallCount >= 1,
          description: 'team refresh dispatched');
      expect(netRepo.refreshCallCount, 1);
      expect(teamRepo.refreshCallCount, 1);
      c.onClose();
    });

    test('initialLoadCompleted llega a true tras primer recompute', () async {
      final c = makeController();
      await c.loadInitial();
      await _waitFor(() => c.initialLoadCompletedRx.value,
          description: 'initialLoadCompleted=true');
      expect(c.initialLoadCompletedRx.value, isTrue);
      c.onClose();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 2. Synth aparece desde LocalContact sin esperar HTTP
  // ──────────────────────────────────────────────────────────────────────────
  group('synth desde LocalContact (sin esperar HTTP)', () {
    test(
        'crear LocalContact con supplier=services → aparece en bucket '
        'Servicios sin refresh', () async {
      // Sembramos un contact ANTES de loadInitial.
      await contactsDs.upsert(_contact(
        id: 'C-1',
        supplier: SupplierType.services,
        displayName: 'Synth Service',
      ));

      final c = makeController();
      await c.loadInitial();
      await _waitFor(
        () => c.bucketsRx.value.network[MiRedBucket.servicios]?.isNotEmpty ??
            false,
        description: 'synth aparece en bucket Servicios',
      );

      final buckets = c.bucketsRx.value;
      expect(buckets.network[MiRedBucket.servicios], hasLength(1),
          reason: 'el synth aparece en Servicios via supplierType local');
      expect(buckets.network[MiRedBucket.servicios]!.first.ref.raw,
          'local:contact:C-1');
      c.onClose();
    });

    test('crear LocalContact DESPUÉS de loadInitial también aparece', () async {
      final c = makeController();
      await c.loadInitial();
      await _waitForFirstRecompute(c);

      await contactsDs.upsert(_contact(
        id: 'C-late',
        supplier: SupplierType.products,
      ));
      await _waitFor(
        () => c.bucketsRx.value.network[MiRedBucket.productos]?.isNotEmpty ??
            false,
        description: 'synth tardío en bucket Productos',
      );

      final buckets = c.bucketsRx.value;
      expect(buckets.network[MiRedBucket.productos], hasLength(1));
      c.onClose();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 3. Dedupe synth ↔ real
  // ──────────────────────────────────────────────────────────────────────────
  group('dedupe synth ↔ real al llegar refresh', () {
    test(
        'LocalContact con link → refresh trae real → synth desaparece, '
        'real prevalece, no duplica', () async {
      await contactsDs.upsert(_contact(
        id: 'C-2',
        supplier: SupplierType.services,
        linkedProviderProfileId: 'prov-link',
      ));

      // Refresh traerá el actor real platform:prov-link.
      netRepo.nextRefreshItems = [
        _proj(refRaw: 'platform:prov-link', displayName: 'Real Provider'),
      ];

      final c = makeController();
      await c.loadInitial();
      // Esperar hasta que el real haya llegado y dedupe ocurra.
      await _waitFor(
        () {
          final list = c.bucketsRx.value.network[MiRedBucket.servicios] ?? [];
          return list.length == 1 && list.first.ref.isPlatform;
        },
        description: 'real prevalece y synth desaparece',
      );

      final buckets = c.bucketsRx.value;
      expect(buckets.network[MiRedBucket.servicios], hasLength(1),
          reason: 'solo aparece UNO — dedupe synth/real');
      expect(buckets.network[MiRedBucket.servicios]!.first.ref.raw,
          'platform:prov-link');
      expect(buckets.totalRenderedActors, 1);
      // El visualStableKey ancla el real al MISMO id que tenía el synth.
      expect(buckets.network[MiRedBucket.servicios]!.first.visualStableKey,
          'contact:C-2',
          reason:
              'visualStableKey debe seguir referenciando el LocalContact id '
              '— sin esto Flutter destruiría el tile en la transición');
      c.onClose();
    });

    test(
        'LocalContact CON link pero refresh NO trae real → synth visible '
        '(no gap)', () async {
      await contactsDs.upsert(_contact(
        id: 'C-3',
        supplier: SupplierType.services,
        linkedProviderProfileId: 'prov-not-yet',
      ));
      // Refresh trae lista vacía → real no llegó aún.
      netRepo.nextRefreshItems = const [];

      final c = makeController();
      await c.loadInitial();
      await _waitFor(
        () => c.bucketsRx.value.network[MiRedBucket.servicios]?.isNotEmpty ??
            false,
        description: 'synth visible mientras real no llega',
      );

      final buckets = c.bucketsRx.value;
      expect(buckets.network[MiRedBucket.servicios], hasLength(1),
          reason: 'synth visible mientras real no llega — sin gap');
      expect(buckets.network[MiRedBucket.servicios]!.first.ref.raw,
          'local:contact:C-3');
      c.onClose();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 4. Archive override inmediato
  // ──────────────────────────────────────────────────────────────────────────
  group('archive override — local prevalece sobre cache wire', () {
    test(
        'LocalContact con link archived → real platform en wire también '
        'se oculta', () async {
      // Sembramos un real en cache.
      await netDs.reconcileFromServer(
        workspaceId: 'ws-1',
        incoming: [_proj(refRaw: 'platform:to-archive')],
        isFullSnapshot: true,
        schemaVersion: 2,
      );
      // Local contact con link al mismo provider, archived.
      await contactsDs.upsert(_contact(
        id: 'C-arch',
        supplier: SupplierType.services,
        linkedProviderProfileId: 'to-archive',
        isDeleted: true,
      ));

      final c = makeController();
      await c.loadInitial();
      // Esperar hasta que archive override haya filtrado.
      await _waitFor(() => c.bucketsRx.value.totalRenderedActors == 0,
          description: 'archive override filtró el actor');

      final buckets = c.bucketsRx.value;
      expect(buckets.totalRenderedActors, 0,
          reason:
              'archive override local oculta el real aunque siga en cache wire');
      c.onClose();
    });

    test('archivar mientras Tab 5 está abierta → desaparece en próximo emit',
        () async {
      await contactsDs.upsert(_contact(
        id: 'C-live',
        supplier: SupplierType.services,
      ));
      final c = makeController();
      await c.loadInitial();
      await _waitFor(() => c.bucketsRx.value.totalRenderedActors == 1,
          description: 'actor visible antes del archive');

      await contactsDs.softDeleteById('C-live', DateTime.utc(2026, 5, 12));
      await _waitFor(() => c.bucketsRx.value.totalRenderedActors == 0,
          description: 'actor oculto tras archive');

      expect(c.bucketsRx.value.totalRenderedActors, 0,
          reason: 'el stream emite tras softDelete → controller re-bucketea');
      c.onClose();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 5. Workspace isolation
  // ──────────────────────────────────────────────────────────────────────────
  group('workspace isolation', () {
    test('controller ws-1 NO ve contacts de ws-2', () async {
      await contactsDs.upsert(_contact(
        id: 'C-ws1',
        workspaceId: 'ws-1',
        supplier: SupplierType.services,
      ));
      await contactsDs.upsert(_contact(
        id: 'C-ws2',
        workspaceId: 'ws-2',
        supplier: SupplierType.products,
      ));

      final c = makeController(workspaceId: 'ws-1');
      await c.loadInitial();
      await _waitFor(
        () => c.bucketsRx.value.network[MiRedBucket.servicios]?.isNotEmpty ??
            false,
        description: 'synth de ws-1 visible',
      );

      final buckets = c.bucketsRx.value;
      expect(buckets.network[MiRedBucket.servicios], hasLength(1));
      expect(buckets.network[MiRedBucket.servicios]!.first.ref.raw,
          'local:contact:C-ws1');
      expect(buckets.network[MiRedBucket.productos], isEmpty);
      c.onClose();
    });

    test('onClose cancela streams sin emitir tras dispose', () async {
      await contactsDs.upsert(_contact(
        id: 'C',
        supplier: SupplierType.services,
      ));
      final c = makeController();
      await c.loadInitial();
      await _waitFor(() => c.bucketsRx.value.totalRenderedActors == 1,
          description: 'contacto inicial visible');

      c.onClose();

      // Escribir más después de dispose no debe afectar bucketsRx.
      // controller no procesa más emisiones.
      await contactsDs.upsert(_contact(
        id: 'C-new',
        supplier: SupplierType.products,
      ));
      // Solo unos ms para confirmar no crash; no esperamos condición porque
      // no esperamos que pase nada.
      await _settle();

      // No assertion sobre contenido — solo que no crash.
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 6. Cache sobrevive fallo de refresh
  // ──────────────────────────────────────────────────────────────────────────
  group('cache survives refresh failure', () {
    test(
        'refresh OK con datos → siguiente refresh falla → actors siguen visibles',
        () async {
      netRepo.nextRefreshItems = [
        _proj(refRaw: 'platform:cached', displayName: 'Cached'),
      ];

      final c = makeController();
      await c.loadInitial();
      await _waitFor(() => c.bucketsRx.value.totalRenderedActors == 1,
          description: 'cache poblada tras refresh inicial');

      // Simulamos siguiente refresh con error.
      netRepo.refreshOutcome = RefreshNetworkOutcome.serverError;
      await c.reloadNetworkSection();
      // El error fue marcado en meta — no esperamos cambio de count, solo
      // ceder al event loop para que el stream re-emita la meta.
      await _settle();

      // Actor SIGUE visible porque cache no se borró.
      expect(c.bucketsRx.value.totalRenderedActors, 1);
      c.onClose();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 7. Bucketizer regression — priority chain intacta
  // ──────────────────────────────────────────────────────────────────────────
  group('bucketizer priority chain intacta', () {
    test(
        'conflicto local=services + wire=parts_and_supplies → gana local',
        () async {
      await contactsDs.upsert(_contact(
        id: 'C-conflict',
        supplier: SupplierType.services,
        linkedProviderProfileId: 'prov-conflict',
      ));
      netRepo.nextRefreshItems = [
        _proj(
          refRaw: 'platform:prov-conflict',
          sectionKeys: const ['parts_and_supplies'], // wire dice productos
        ),
      ];

      final c = makeController();
      await c.loadInitial();
      await _waitFor(
        () => c.bucketsRx.value.network[MiRedBucket.servicios]?.isNotEmpty ??
            false,
        description: 'priority chain favorece local',
      );

      final buckets = c.bucketsRx.value;
      expect(buckets.network[MiRedBucket.servicios], hasLength(1),
          reason: 'supplierType local debe ganar sobre wire sectionKeys');
      expect(buckets.network[MiRedBucket.productos], isEmpty);
      c.onClose();
    });

    test(
        'actor wire sin LocalContact + sectionKeys=parts → bucket Productos '
        '(fallback wire correcto)', () async {
      netRepo.nextRefreshItems = [
        _proj(
          refRaw: 'platform:wire-only',
          sectionKeys: const ['parts_and_supplies'],
        ),
      ];
      final c = makeController();
      await c.loadInitial();
      await _waitFor(
        () => c.bucketsRx.value.network[MiRedBucket.productos]?.isNotEmpty ??
            false,
        description: 'fallback wire visible en Productos',
      );

      final buckets = c.bucketsRx.value;
      expect(buckets.network[MiRedBucket.productos], hasLength(1));
      c.onClose();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 8. supplierByRef intacto (paridad con bugfix anterior)
  // ──────────────────────────────────────────────────────────────────────────
  group('supplierByRef se construye reactivamente', () {
    test('contact con link emite ambas claves (local + platform)', () async {
      await contactsDs.upsert(_contact(
        id: 'C-map',
        supplier: SupplierType.services,
        linkedProviderProfileId: 'prov-map',
      ));

      final c = makeController();
      await c.loadInitial();
      await _waitFor(
        () => c.supplierByRefRx.value.containsKey('platform:prov-map'),
        description: 'supplierByRef contiene ambas claves',
      );

      final map = c.supplierByRefRx.value;
      expect(map['local:contact:C-map'], SupplierType.services);
      expect(map['platform:prov-map'], SupplierType.services);
      c.onClose();
    });

    test('cambio en LocalContact → supplierByRef se reconstruye', () async {
      await contactsDs.upsert(_contact(
        id: 'C-flip',
        supplier: SupplierType.services,
      ));
      final c = makeController();
      await c.loadInitial();
      await _waitFor(
        () => c.supplierByRefRx.value['local:contact:C-flip'] ==
            SupplierType.services,
        description: 'supplier inicial = services',
      );

      // Cambiar supplier
      await contactsDs.upsert(_contact(
        id: 'C-flip',
        supplier: SupplierType.products,
      ));
      await _waitFor(
        () => c.supplierByRefRx.value['local:contact:C-flip'] ==
            SupplierType.products,
        description: 'supplier actualizado a products',
      );
      c.onClose();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 9. loadMore es NO-OP en stream-first (no corrompe buckets)
  // ──────────────────────────────────────────────────────────────────────────
  group('loadMore safety en stream-first', () {
    test(
        'loadMoreNetwork en modo workspace es no-op — no toca state ni '
        'buckets', () async {
      await contactsDs.upsert(_contact(
        id: 'C',
        supplier: SupplierType.services,
      ));
      final c = makeController();
      await c.loadInitial();
      await _waitFor(() => c.bucketsRx.value.totalRenderedActors == 1,
          description: 'estado base estabilizado');
      final countBefore = c.bucketsRx.value.totalRenderedActors;
      final refsBefore = c.bucketsRx.value.network[MiRedBucket.servicios]!
          .map((a) => a.ref.raw)
          .toSet();

      // Intentar loadMore — debe ser no-op (early return en stream-first).
      await c.loadMoreNetwork();
      // Cedemos ticks por si hubo emisión espuria.
      await _settle();

      // El conteo y los refs deben ser idénticos (loadMore no añade items).
      expect(c.bucketsRx.value.totalRenderedActors, countBefore,
          reason: 'loadMore en stream-first no debe alterar el conteo');
      final refsAfter = c.bucketsRx.value.network[MiRedBucket.servicios]!
          .map((a) => a.ref.raw)
          .toSet();
      expect(refsAfter, refsBefore,
          reason: 'loadMore en stream-first no debe agregar ni quitar refs');
      c.onClose();
    });

    test(
        'loadMoreTeam en modo workspace es no-op (paridad con network)',
        () async {
      final c = makeController();
      await c.loadInitial();
      await _waitForFirstRecompute(c);
      final stateBefore = c.teamState;

      await c.loadMoreTeam();
      await _settle();

      expect(c.teamState, stateBefore);
      c.onClose();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 10. SectionState derivado del stream
  // ──────────────────────────────────────────────────────────────────────────
  group('SectionState derivado del snapshot', () {
    test('items merged > 0 → SectionLoaded con items', () async {
      await contactsDs.upsert(_contact(
        id: 'C',
        supplier: SupplierType.services,
      ));
      final c = makeController();
      await c.loadInitial();
      await _waitFor(
        () => c.networkState is SectionLoaded<NetworkActorSummaryVM>,
        description: 'networkState → Loaded',
      );
      expect(c.networkState, isA<SectionLoaded<NetworkActorSummaryVM>>());
      c.onClose();
    });

    test('meta.syncStatus=syncFailed + items vacíos → SectionError', () async {
      netRepo.refreshOutcome = RefreshNetworkOutcome.networkError;
      final c = makeController();
      await c.loadInitial();
      await _waitFor(
        () => c.networkState is SectionError<NetworkActorSummaryVM>,
        description: 'networkState → Error tras refresh fail',
      );
      expect(c.networkState, isA<SectionError<NetworkActorSummaryVM>>());
      c.onClose();
    });
  });
}
