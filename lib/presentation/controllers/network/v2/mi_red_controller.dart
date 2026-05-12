// ============================================================================
// lib/presentation/controllers/network/v2/mi_red_controller.dart
// MI RED CONTROLLER — Orquestador de streams local-first (Fase 4 Paso 4a)
// ============================================================================
//
// ═══════════════════════════════════════════════════════════════════════════
// CAMBIO ARQUITECTÓNICO V2:
//   El controller DEJA DE SER cargador de datos HTTP y se convierte en
//   ORQUESTADOR de 3 streams local-first:
//     1. NetworkRepository.watchSection(workspaceId)
//     2. TeamRepository.watchSection(workspaceId)
//     3. LocalContactLocalDataSource.watchByWorkspace(workspaceId)
//
//   Refresh HTTP se dispara unawaited (sin bloquear UI). Las escrituras al
//   cache local (vía reconcileFromServer / save) reemiten en los streams →
//   recompute → bucketize → emit bucketsRx.
//
// VERDAD OPERACIONAL vs CONTRACTUAL:
//   - Local Isar = verdad operacional inmediata.
//   - Backend = verdad contractual consolidada.
//   - merger arbitra: archive override local + synth + dedupe.
//
// COMPONENTES DELEGADOS (no inline en el controller):
//   - mi_red_merger.dart      → merge + dedupe + archive override.
//   - synth_actor_builder.dart → LocalContact → synth VM con acciones locales.
//
// LEGACY COMPAT:
//   - `_networkState` / `_teamState` siguen siendo `Rx<SectionState>`. Su
//     contenido ahora deriva del merger, no de HTTP fetchPage directo.
//   - `loadMoreNetwork` / `loadMoreTeam` siguen usando fetchPage legacy.
//     LIMITACIÓN CONOCIDA: la próxima emisión de stream sobrescribe items
//     paginados. Pagination V1 es best-effort. Hito futuro re-diseñará.
//   - `fetchPage` legacy del repo NO se toca.
//
// DEBOUNCE:
//   - 50ms por defecto. Cancela el timer previo en cada emisión.
//   - Tests inyectan `Duration.zero` para recompute síncrono determinístico.
//
// WORKSPACE ISOLATION:
//   - `_currentWorkspaceId` se valida en cada emisión de stream — emisiones
//     tardías del workspace previo se descartan silenciosamente.
//   - Cambio de workspace cancela los 3 subs, resetea estado, suscribe los
//     nuevos.
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint, visibleForTesting;
import 'package:get/get.dart';

import '../../../../data/models/core_common/local_contact_model.dart';
import '../../../../data/models/network/network_category.dart';
import '../../../../data/sources/local/core_common/local_contact_local_ds.dart';
import '../../../../data/sources/local/network/network_local_datasource.dart';
import '../../../../data/sources/local/network/team_local_datasource.dart';
import '../../../../domain/entities/core_common/value_objects/supplier_type.dart';
import '../../../../domain/errors/remote_exceptions.dart';
import '../../../../domain/repositories/network/network_repository.dart';
import '../../../../domain/repositories/network/team_repository.dart';
import '../../../view_models/network/v2/mi_red_buckets.dart';
import '../../../view_models/network/v2/network_actor_summary_vm.dart';
import '../../../view_models/network/v2/team_member_summary_vm.dart';
import 'mi_red_merger.dart';
import 'section_state.dart';

class MiRedController extends GetxController {
  final NetworkRepository _network;
  final TeamRepository _team;
  final LocalContactLocalDataSource? _contactsLocalDs;
  final String? _workspaceId;
  final String? _currentUserId;

  /// Debounce window para coalescer emisiones cercanas de los 3 streams.
  /// `Duration.zero` (vía constructor) ejecuta `_recompute` sincrónico —
  /// usado por tests para determinismo.
  final Duration _debounceDuration;

  static const int _defaultLimit = 50;

  // ── Estado Rx ─────────────────────────────────────────────────────────────

  final Rx<SectionState<NetworkActorSummaryVM>> _networkState =
      Rx<SectionState<NetworkActorSummaryVM>>(
          const SectionLoading<NetworkActorSummaryVM>());

  final Rx<SectionState<TeamMemberSummaryVM>> _teamState =
      Rx<SectionState<TeamMemberSummaryVM>>(
          const SectionLoading<TeamMemberSummaryVM>());

  final Rx<MiRedBuckets> _buckets =
      Rx<MiRedBuckets>(MiRedBuckets.empty());

  final Rxn<NetworkCategory> _filterCategory = Rxn<NetworkCategory>();
  final RxBool _initialLoadCompleted = false.obs;
  final Rx<Map<String, SupplierType>> _supplierByRef =
      Rx<Map<String, SupplierType>>(const {});

  // ── Stream subs ───────────────────────────────────────────────────────────

  StreamSubscription<NetworkSectionSnapshot>? _networkSub;
  StreamSubscription<TeamSectionSnapshot>? _teamSub;
  StreamSubscription<List<LocalContactModel>>? _contactsSub;

  // ── Latest snapshots (input al merger) ────────────────────────────────────

  NetworkSectionSnapshot? _lastNetworkSnap;
  TeamSectionSnapshot? _lastTeamSnap;
  List<LocalContactModel>? _lastContacts;

  bool _networkFirstEmitted = false;
  bool _teamFirstEmitted = false;
  bool _contactsFirstEmitted = false;

  // ── Debounce timer ────────────────────────────────────────────────────────

  Timer? _debounceTimer;

  // ── Guards ────────────────────────────────────────────────────────────────

  bool _loadInitialInFlight = false;

  MiRedController({
    required NetworkRepository networkRepository,
    required TeamRepository teamRepository,
    String? currentUserId,
    LocalContactLocalDataSource? contactsLocalDataSource,
    String? workspaceId,
    Duration debounceDuration = const Duration(milliseconds: 50),
  })  : _network = networkRepository,
        _team = teamRepository,
        _currentUserId = currentUserId,
        _contactsLocalDs = contactsLocalDataSource,
        _workspaceId = workspaceId,
        _debounceDuration = debounceDuration;

  // ── Accessors ─────────────────────────────────────────────────────────────

  SectionState<NetworkActorSummaryVM> get networkState => _networkState.value;
  SectionState<TeamMemberSummaryVM> get teamState => _teamState.value;
  NetworkCategory? get filterCategory => _filterCategory.value;
  Rx<SectionState<NetworkActorSummaryVM>> get networkStateRx => _networkState;
  Rx<SectionState<TeamMemberSummaryVM>> get teamStateRx => _teamState;
  Rx<MiRedBuckets> get bucketsRx => _buckets;
  Rxn<NetworkCategory> get filterCategoryRx => _filterCategory;
  RxBool get initialLoadCompletedRx => _initialLoadCompleted;
  Rx<Map<String, SupplierType>> get supplierByRefRx => _supplierByRef;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onClose() {
    _cancelStreams();
    _debounceTimer?.cancel();
    super.onClose();
  }

  void _cancelStreams() {
    _networkSub?.cancel();
    _teamSub?.cancel();
    _contactsSub?.cancel();
    _networkSub = null;
    _teamSub = null;
    _contactsSub = null;
  }

  // ── Bootstrap ─────────────────────────────────────────────────────────────

  /// Bootstrap dual:
  ///   - Con `workspaceId` válido: suscribe streams local-first + dispara
  ///     refresh remoto unawaited (path nuevo cache-first).
  ///   - Sin `workspaceId` (legacy / tests sin contexto de workspace):
  ///     cae al path HTTP-only fetchPage en paralelo (compatibilidad con
  ///     tests pre-rewrite que no inyectan DS local).
  Future<void> loadInitial() async {
    if (_loadInitialInFlight) return;
    _loadInitialInFlight = true;
    try {
      final ws = _workspaceId;
      if (ws != null && ws.isNotEmpty) {
        // Path cache-first.
        _bindStreams();
        unawaited(_network.refreshSection(
          workspaceId: ws,
          category: _filterCategory.value,
          limit: _defaultLimit,
        ));
        unawaited(_team.refreshSection(workspaceId: ws, limit: _defaultLimit));
      } else {
        // Path legacy HTTP-only (tests sin workspace, compat).
        await Future.wait([
          _legacyReloadNetworkSection(),
          _legacyReloadTeamSection(),
        ]);
        _initialLoadCompleted.value = true;
      }
    } finally {
      _loadInitialInFlight = false;
    }
  }

  /// Path legacy: fetchPage HTTP-only, sin streams. Usado cuando no hay
  /// workspaceId disponible (tests pre-rewrite + early bootstrap fail).
  Future<void> _legacyReloadNetworkSection() async {
    _networkState.value = const SectionLoading<NetworkActorSummaryVM>();
    try {
      final env = await _network.fetchPage(
        category: _filterCategory.value,
        limit: _defaultLimit,
      );
      final vms =
          env.items.map(NetworkActorSummaryVM.fromDto).toList(growable: false);
      _networkState.value = vms.isEmpty
          ? const SectionEmpty<NetworkActorSummaryVM>()
          : SectionLoaded<NetworkActorSummaryVM>(
              items: vms,
              nextCursor: env.nextCursor,
            );
    } on ForbiddenException catch (e) {
      _networkState.value =
          SectionForbidden<NetworkActorSummaryVM>(message: e.message);
    } catch (e) {
      _networkState.value = SectionError<NetworkActorSummaryVM>(error: e);
    } finally {
      _legacyRebuildBuckets();
    }
  }

  Future<void> _legacyReloadTeamSection() async {
    _teamState.value = const SectionLoading<TeamMemberSummaryVM>();
    try {
      final env = await _team.fetchPage(limit: _defaultLimit);
      final vms =
          env.items.map(TeamMemberSummaryVM.fromDto).toList(growable: false);
      _teamState.value = vms.isEmpty
          ? const SectionEmpty<TeamMemberSummaryVM>()
          : SectionLoaded<TeamMemberSummaryVM>(
              items: vms,
              nextCursor: env.nextCursor,
            );
    } on ForbiddenException catch (e) {
      _teamState.value =
          SectionForbidden<TeamMemberSummaryVM>(message: e.message);
    } catch (e) {
      _teamState.value = SectionError<TeamMemberSummaryVM>(error: e);
    } finally {
      _legacyRebuildBuckets();
    }
  }

  void _legacyRebuildBuckets() {
    final networkItems = switch (_networkState.value) {
      SectionLoaded<NetworkActorSummaryVM>(:final items) => items,
      _ => const <NetworkActorSummaryVM>[],
    };
    final teamItems = switch (_teamState.value) {
      SectionLoaded<TeamMemberSummaryVM>(:final items) => items,
      _ => const <TeamMemberSummaryVM>[],
    };
    _buckets.value = bucketize(
      networkItems: networkItems,
      teamItems: teamItems,
      currentUserId: _currentUserId,
      supplierByRef: _supplierByRef.value,
    );
  }

  /// Suscribe los 3 streams al workspace actual. Si ya hay subs activas,
  /// las cancela primero (workspace switch path).
  void _bindStreams() {
    _cancelStreams();
    _networkFirstEmitted = false;
    _teamFirstEmitted = false;
    _contactsFirstEmitted = false;

    final ws = _workspaceId;
    if (ws == null || ws.isEmpty) {
      // Sin workspace: nada que suscribir. _recompute() emite empty.
      _scheduleRecompute();
      return;
    }

    debugPrint('[MiRed][Controller] binding streams workspace=$ws');

    _networkSub = _network.watchSection(workspaceId: ws).listen(
      (snap) {
        if (snap.workspaceId != ws) {
          // Emisión tardía de un workspace previo → descartar.
          debugPrint('[MiRed][Controller] drop stale network emission '
              'received=${snap.workspaceId} expected=$ws');
          return;
        }
        _lastNetworkSnap = snap;
        _networkFirstEmitted = true;
        _scheduleRecompute();
      },
      onError: (Object e, StackTrace st) {
        debugPrint('[MiRed][Controller] network stream error: $e');
        _networkState.value = SectionError<NetworkActorSummaryVM>(error: e);
        _networkFirstEmitted = true;
        _scheduleRecompute();
      },
    );

    _teamSub = _team.watchSection(workspaceId: ws).listen(
      (snap) {
        if (snap.workspaceId != ws) {
          debugPrint('[MiRed][Controller] drop stale team emission '
              'received=${snap.workspaceId} expected=$ws');
          return;
        }
        _lastTeamSnap = snap;
        _teamFirstEmitted = true;
        _scheduleRecompute();
      },
      onError: (Object e, StackTrace st) {
        debugPrint('[MiRed][Controller] team stream error: $e');
        _teamState.value = SectionError<TeamMemberSummaryVM>(error: e);
        _teamFirstEmitted = true;
        _scheduleRecompute();
      },
    );

    final ds = _contactsLocalDs;
    if (ds != null) {
      // Usamos watchAll (incluye soft-deleted) porque el merger necesita los
      // archivados para construir el archive override set. Sin esto, los
      // archivados nunca llegan al merger y la intención local de ocultar
      // no se aplica sobre el cache wire.
      _contactsSub = ds.watchAllByWorkspace(ws).listen(
        (contacts) {
          _lastContacts = contacts;
          _contactsFirstEmitted = true;
          _scheduleRecompute();
        },
        onError: (Object e, StackTrace st) {
          debugPrint('[MiRed][Controller] contacts stream error: $e');
          _lastContacts = const [];
          _contactsFirstEmitted = true;
          _scheduleRecompute();
        },
      );
    } else {
      _lastContacts = const [];
      _contactsFirstEmitted = true;
      _scheduleRecompute();
    }
  }

  // ── Debounce + recompute ──────────────────────────────────────────────────

  void _scheduleRecompute() {
    _debounceTimer?.cancel();
    if (_debounceDuration == Duration.zero) {
      _recompute();
    } else {
      _debounceTimer = Timer(_debounceDuration, _recompute);
    }
  }

  /// FUNCIÓN LIGERA: solo coordina + delega.
  /// Toda la lógica pesada (merge + dedupe + archive override) vive en
  /// `mi_red_merger.dart`.
  void _recompute() {
    final ws = _workspaceId;
    if (ws == null || ws.isEmpty) {
      _networkState.value = const SectionEmpty<NetworkActorSummaryVM>();
      _teamState.value = const SectionEmpty<TeamMemberSummaryVM>();
      _buckets.value = MiRedBuckets.empty();
      _initialLoadCompleted.value = true;
      return;
    }

    // Convertir projections → VMs (network).
    final remoteNetworkVMs = _lastNetworkSnap?.actors
            .map(NetworkActorSummaryVM.fromProjection)
            .toList(growable: false) ??
        const <NetworkActorSummaryVM>[];

    final contacts = _lastContacts ?? const <LocalContactModel>[];

    // Merger PURO: aplica archive override + supplierByRef + synth + dedupe.
    final mergeResult = mergeMiRed(
      networkActors: remoteNetworkVMs,
      localContacts: contacts,
    );

    _supplierByRef.value = mergeResult.supplierByRef;
    _networkState.value = _deriveNetworkSectionState(
      mergeResult.mergedActors,
      _lastNetworkSnap,
    );

    // Team (no synth; no archive override en V1).
    final teamVMs = _lastTeamSnap?.actors
            .map(TeamMemberSummaryVM.fromProjection)
            .toList(growable: false) ??
        const <TeamMemberSummaryVM>[];
    _teamState.value = _deriveTeamSectionState(teamVMs, _lastTeamSnap);

    _buckets.value = bucketize(
      networkItems: mergeResult.mergedActors,
      teamItems: teamVMs,
      currentUserId: _currentUserId,
      supplierByRef: mergeResult.supplierByRef,
    );

    if (_networkFirstEmitted && _teamFirstEmitted && _contactsFirstEmitted) {
      _initialLoadCompleted.value = true;
    }

    debugPrint('[MiRed][Controller] recompute workspace=$ws '
        'merged=${mergeResult.mergedActors.length} '
        'synth=${mergeResult.synthCount} '
        'enrichedReal=${mergeResult.enrichedRealCount} '
        'archived=${mergeResult.archivedRefs.length} '
        'team=${teamVMs.length} '
        'supplierByRef=${mergeResult.supplierByRef.length}');
  }

  SectionState<NetworkActorSummaryVM> _deriveNetworkSectionState(
    List<NetworkActorSummaryVM> mergedActors,
    NetworkSectionSnapshot? snap,
  ) {
    if (mergedActors.isNotEmpty) {
      return SectionLoaded<NetworkActorSummaryVM>(
        items: mergedActors,
        nextCursor: snap?.meta?.nextCursor,
      );
    }
    final meta = snap?.meta;
    if (meta == null) {
      // Sin meta y sin items: estado initial / sin sync aún.
      return const SectionEmpty<NetworkActorSummaryVM>();
    }
    if (meta.syncStatus.name == 'syncFailed') {
      final code = meta.lastErrorCode;
      if (code == '403') {
        return const SectionForbidden<NetworkActorSummaryVM>(
            message: 'Sin acceso a esta red');
      }
      return SectionError<NetworkActorSummaryVM>(error: code ?? 'unknown');
    }
    return const SectionEmpty<NetworkActorSummaryVM>();
  }

  SectionState<TeamMemberSummaryVM> _deriveTeamSectionState(
    List<TeamMemberSummaryVM> items,
    TeamSectionSnapshot? snap,
  ) {
    if (items.isNotEmpty) {
      return SectionLoaded<TeamMemberSummaryVM>(
        items: items,
        nextCursor: snap?.meta?.nextCursor,
      );
    }
    final meta = snap?.meta;
    if (meta == null) return const SectionEmpty<TeamMemberSummaryVM>();
    if (meta.syncStatus.name == 'syncFailed') {
      final code = meta.lastErrorCode;
      if (code == '403') {
        return const SectionForbidden<TeamMemberSummaryVM>(
            message: 'Sin acceso al equipo');
      }
      return SectionError<TeamMemberSummaryVM>(error: code ?? 'unknown');
    }
    return const SectionEmpty<TeamMemberSummaryVM>();
  }

  // ── Reload APIs (compat legacy) ───────────────────────────────────────────

  /// Re-dispara refresh. Con workspace → refreshSection (cache-first).
  /// Sin workspace → legacy fetchPage path (compat tests).
  Future<void> reloadNetworkSection() async {
    final ws = _workspaceId;
    if (ws == null || ws.isEmpty) {
      await _legacyReloadNetworkSection();
      return;
    }
    await _network.refreshSection(
      workspaceId: ws,
      category: _filterCategory.value,
      limit: _defaultLimit,
    );
  }

  /// Re-dispara refresh de team. Dual-mode igual que network.
  Future<void> reloadTeamSection() async {
    final ws = _workspaceId;
    if (ws == null || ws.isEmpty) {
      await _legacyReloadTeamSection();
      return;
    }
    await _team.refreshSection(workspaceId: ws, limit: _defaultLimit);
  }

  // ── loadMore (legacy compat — limitación V1 documentada) ──────────────────

  /// loadMore aplica SOLO al path legacy (sin workspaceId). En modo stream-first
  /// es NO-OP seguro porque cualquier append manual sería sobrescrito por la
  /// próxima emisión del watchSection con la cache local (que NO contiene los
  /// items paginados N≥2 — la cache solo guarda la página inicial vía
  /// reconcileFromServer).
  ///
  /// Pagination cache-first real es deuda V2 — requiere extender el DS con
  /// `saveActorsPage` que no reconcilie + un cursor persistido en meta.
  Future<void> loadMoreNetwork() async {
    // Guard stream-first: en modo cache-first NO ejecutar append manual que
    // sería sobrescrito por el próximo stream emit. Documentado en doc-comment.
    final ws = _workspaceId;
    if (ws != null && ws.isNotEmpty) {
      debugPrint('[MiRed][Controller] loadMoreNetwork no-op en stream-first '
          '(workspaceId=$ws). Pagination cache-first es deuda V2.');
      return;
    }

    final state = _networkState.value;
    if (state is! SectionLoaded<NetworkActorSummaryVM>) return;
    if (!state.hasMore) return;
    if (state.isLoadingMore) return;

    _networkState.value = state.copyWith(isLoadingMore: true);

    try {
      final env = await _network.fetchPage(
        category: _filterCategory.value,
        cursor: state.nextCursor,
        limit: _defaultLimit,
      );
      final more =
          env.items.map(NetworkActorSummaryVM.fromDto).toList(growable: false);

      final current = _networkState.value;
      if (current is SectionLoaded<NetworkActorSummaryVM>) {
        _networkState.value = current.appendPage(
          moreItems: more,
          nextCursor: env.nextCursor,
        );
        // En modo legacy (sin workspace) rebuild manual; en modo streams,
        // la emisión natural lo hará si hay cambios.
        final ws = _workspaceId;
        if (ws == null || ws.isEmpty) {
          _legacyRebuildBuckets();
        }
      }
    } on ForbiddenException catch (e) {
      _networkState.value =
          SectionForbidden<NetworkActorSummaryVM>(message: e.message);
    } catch (_) {
      final current = _networkState.value;
      if (current is SectionLoaded<NetworkActorSummaryVM>) {
        _networkState.value = current.copyWith(isLoadingMore: false);
      }
    }
  }

  /// loadMore SOLO en path legacy. NO-OP en stream-first (paridad con
  /// loadMoreNetwork). Deuda V2 documentada allí.
  Future<void> loadMoreTeam() async {
    final ws = _workspaceId;
    if (ws != null && ws.isNotEmpty) {
      debugPrint('[MiRed][Controller] loadMoreTeam no-op en stream-first '
          '(workspaceId=$ws). Pagination cache-first es deuda V2.');
      return;
    }

    final state = _teamState.value;
    if (state is! SectionLoaded<TeamMemberSummaryVM>) return;
    if (!state.hasMore) return;
    if (state.isLoadingMore) return;

    _teamState.value = state.copyWith(isLoadingMore: true);

    try {
      final env = await _team.fetchPage(
        cursor: state.nextCursor,
        limit: _defaultLimit,
      );
      final more =
          env.items.map(TeamMemberSummaryVM.fromDto).toList(growable: false);

      final current = _teamState.value;
      if (current is SectionLoaded<TeamMemberSummaryVM>) {
        _teamState.value = current.appendPage(
          moreItems: more,
          nextCursor: env.nextCursor,
        );
        final ws = _workspaceId;
        if (ws == null || ws.isEmpty) {
          _legacyRebuildBuckets();
        }
      }
    } on ForbiddenException catch (e) {
      _teamState.value =
          SectionForbidden<TeamMemberSummaryVM>(message: e.message);
    } catch (_) {
      final current = _teamState.value;
      if (current is SectionLoaded<TeamMemberSummaryVM>) {
        _teamState.value = current.copyWith(isLoadingMore: false);
      }
    }
  }

  // ── Filtro ────────────────────────────────────────────────────────────────

  /// Cambia el filtro de categoría y dispara refresh de network.
  Future<void> setFilterCategory(NetworkCategory? category) async {
    if (_filterCategory.value == category) return;
    _filterCategory.value = category;
    await reloadNetworkSection();
  }

  // ── Test-only hooks ───────────────────────────────────────────────────────

  /// Fuerza el recompute sincrónico inmediato (cancela debounce pendiente).
  /// Usado por tests para evitar timers reales.
  @visibleForTesting
  void debugForceRecompute() {
    _debounceTimer?.cancel();
    _recompute();
  }

  /// Expone el último merge result para inspección en tests.
  @visibleForTesting
  bool get debugAllStreamsEmitted =>
      _networkFirstEmitted && _teamFirstEmitted && _contactsFirstEmitted;
}
