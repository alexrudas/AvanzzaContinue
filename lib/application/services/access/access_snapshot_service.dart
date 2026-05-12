// ============================================================================
// lib/application/services/access/access_snapshot_service.dart
// AccessSnapshotService — orquestador del AccessContextSnapshot persistido.
// ============================================================================
// QUÉ HACE:
//   Servicio thin sobre `LocalAccessSnapshotDS` + stores reactivos
//   (`SessionCapabilitiesStore`, `ProviderContextStore`). Contrato V2.1:
//
//   1. HIDRATACIÓN síncrona en cold start:
//      · `hydrate(userId, workspaceId)` — el splash llama esto ANTES de
//        cualquier HTTP. Si hay snapshot no críticamente vencido, puebla
//        los stores para que el shell renderice con permisos completos
//        sin esperar red.
//
//   2. ESCRITURA desde dos fuentes ortogonales:
//      · `persistLocalBootstrap(...)` — usuario creó workspace localmente
//        (CompleteOnboardingUC). Source=LOCAL_BOOTSTRAP, syncStatus=PENDING_SYNC.
//        El siguiente refresh remoto exitoso lo elevará a CONFIRMED.
//      · `persistServerRefresh(...)` — Core API respondió Ready/Bootstrap+success.
//        Source=SERVER_REFRESH, syncStatus=CONFIRMED.
//
//   3. CONFIRMACIÓN/FALLO de sync (estado independiente del source):
//      · `markPendingSync(...)` — marca un snapshot CONFIRMED como pending
//        cuando se inicia un cambio local (workspace switch que aún no
//        confirmó, escritura optimista, etc.). Uso esperado: V2.2+.
//      · `markSyncFailed(..., error)` — sync remoto falló (5xx/red). El
//        snapshot sigue usable para lectura local; networkCritical se
//        bloquea hasta el próximo refresh exitoso.
//
//   4. INVALIDACIÓN:
//      · `clearForWorkspace(userId, workspaceId)` — borra UN snapshot
//        (workspace switch a otro o 401/403 sobre ese workspace).
//      · `clearForUser(userId)` — borra TODOS (logout).
//
//   5. POLÍTICA DE STALENESS:
//      · `isFresh()` / `isStale()` / `isCriticallyStale()` — los consumers
//        (UI / acciones críticas) preguntan cómo de viejo es el snapshot.
//        El gating real (`canPerform(action, snapshot, ...)`) vive en
//        `domain/policy/access/` y se construye en V2.2.
//
// QUÉ NO HACE:
//   - NO hace HTTP ni llama al gateway.
//   - NO decide rutas (eso lo hace SplashBootstrapController).
//   - NO emite snackbars ni navega.
//   - NO clasifica acciones (`localSafe` vs `networkCritical`) — V2.2 con
//     domain policy.
//   - NO es GetxController — es servicio puro registrado en DI como singleton.
//
// PRINCIPIOS:
//   - Single source of writes para el snapshot: este servicio o nada.
//   - Idempotente: persistir el mismo payload N veces no notifica re-render
//     (el `set()` reactivo de los stores compara contenido).
//   - 401/403 NO se persiste; el caller debe invocar `clearForWorkspace()`.
//   - LOCAL_BOOTSTRAP nace SIEMPRE como pendingSync. Solo
//     `persistServerRefresh` o el helper `markConfirmed` pueden elevarlo.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/models/access/access_context_snapshot_model.dart';
import '../../../data/sources/local/access/access_context_snapshot_local_ds.dart';
import '../../../domain/entities/access/access_context.dart';
import '../../../domain/entities/org/organization_entity.dart';
import '../../../domain/services/access/owner_default_capabilities.dart';
import '../../../domain/value/capability/profile_kind.dart';
import 'provider_context_store.dart';
import 'session_capabilities_store.dart';

/// Constantes de política de staleness. Centralizadas aquí para que UI y
/// acciones críticas las consulten sin magic numbers.
///
/// V2.1 final (post-revisión): 24h fresh / 72h critically stale. Los
/// thresholds previos (1h/7d) producían banners stale demasiado frecuentes
/// para uso real offline.
class AccessSnapshotPolicy {
  AccessSnapshotPolicy._();

  /// Más nuevo que esto: snapshot fresco. Operar normal.
  static const Duration freshUntil = Duration(hours: 24);

  /// Entre `freshUntil` y `criticallyStaleAfter`: operar normal pero el
  /// refresh debe correr en background; banner suave permitido.
  static const Duration criticallyStaleAfter = Duration(hours: 72);
}

class AccessSnapshotService {
  final LocalAccessSnapshotDS _ds;
  final SessionCapabilitiesStore _capabilitiesStore;
  final ProviderContextStore _providerContextStore;
  final DateTime Function() _clock;

  /// Snapshot activo del par `(uid, workspaceId)` actualmente hidratado o
  /// persistido. Reactivo para que UI (banner, gates de acción) consulten
  /// sin async. `null` = ningún snapshot ha sido hidratado/persistido en
  /// esta sesión runtime.
  ///
  /// El banner observa este Rxn además de `AccessGateway.state` para no
  /// mostrar "verificación falló" cuando hay snapshot local usable y solo
  /// está fallando el refresh remoto oportunista.
  final Rxn<AccessContextSnapshotModel> currentSnapshot =
      Rxn<AccessContextSnapshotModel>();

  AccessSnapshotService({
    required LocalAccessSnapshotDS ds,
    required SessionCapabilitiesStore capabilitiesStore,
    required ProviderContextStore providerContextStore,
    DateTime Function()? clock,
  })  : _ds = ds,
        _capabilitiesStore = capabilitiesStore,
        _providerContextStore = providerContextStore,
        _clock = clock ?? _defaultClock;

  static DateTime _defaultClock() => DateTime.now().toUtc();

  /// True si hay snapshot activo y no está críticamente vencido. La UI
  /// usa este getter para decidir si suprimir el banner de error remoto.
  bool get hasUsableLocalSnapshot {
    final s = currentSnapshot.value;
    if (s == null) return false;
    return !isCriticallyStale(s);
  }

  // ─── HIDRATACIÓN ──────────────────────────────────────────────────────────

  /// Lee el snapshot persistido para `(uid, workspaceId)`. Si existe y NO
  /// está críticamente vencido, puebla los stores reactivos. Retorna el
  /// snapshot leído (o null) para que el caller decida UX adicional.
  ///
  /// SÍNCRONO en costo: una query Isar por compositeKey + dos `set()`
  /// reactivos. Sin red, sin parsing pesado.
  Future<AccessContextSnapshotModel?> hydrate(
    String uid,
    String workspaceId,
  ) async {
    debugPrint('[ACCESS_SNAPSHOT] hydrate start uid=$uid ws=$workspaceId');
    final snapshot = await _ds.read(uid, workspaceId);
    debugPrint('[ACCESS_SNAPSHOT] found=${snapshot != null}');
    if (snapshot == null) {
      currentSnapshot.value = null;
      debugPrint('[ACCESS_SNAPSHOT] stores hydrated=false reason=no_snapshot');
      return null;
    }
    debugPrint('[ACCESS_SNAPSHOT] '
        'source=${snapshot.source.name} '
        'syncStatus=${snapshot.syncStatus.name} '
        'fetchedAt=${snapshot.fetchedAt.toIso8601String()} '
        'staleAt=${snapshot.staleAt.toIso8601String()} '
        'expiresAt=${snapshot.expiresAt.toIso8601String()}');
    debugPrint(
        '[ACCESS_SNAPSHOT] capabilities count=${snapshot.capabilities.length}');
    if (isCriticallyStale(snapshot)) {
      currentSnapshot.value = snapshot;
      debugPrint('[ACCESS_SNAPSHOT] stores hydrated=false '
          'reason=critically_stale (>72h)');
      return snapshot;
    }
    _capabilitiesStore.set(snapshot.capabilities);
    _providerContextStore.set(
      isProvider: snapshot.isProvider,
      workspaceId: snapshot.providerWorkspaceId ?? '',
    );
    currentSnapshot.value = snapshot;
    debugPrint('[ACCESS_SNAPSHOT] stores hydrated=true '
        'isOwner=${snapshot.isOwner} isProvider=${snapshot.isProvider}');
    return snapshot;
  }

  /// Backfill desde evidencia local: si no existe snapshot para
  /// `(uid, workspaceId)` y el usuario tiene `Membership` con `isOwner=true`
  /// para esa org en Isar, sintetiza un LOCAL_BOOTSTRAP+pendingSync.
  ///
  /// Pensado para usuarios EXISTENTES que tenían su workspace creado antes
  /// de que existiera la colección `AccessContextSnapshotModel` (cualquiera
  /// que actualice a V2.1 sin pasar por onboarding nuevo). Sin este
  /// backfill, el banner "verificación falló" aparecería cada cold start
  /// hasta que Core API responda exitosamente al menos una vez.
  ///
  /// No-op si:
  ///   · ya existe snapshot para ese par,
  ///   · el `org` o `membership` provistos son null,
  ///   · `membership.isOwner != true` (no inferimos OWNER sin evidencia).
  Future<AccessContextSnapshotModel?> backfillFromLocalOwnership({
    required String uid,
    required String workspaceId,
    required OrganizationEntity? org,
    required bool isOwnerLocal,
  }) async {
    debugPrint('[ACCESS_SNAPSHOT] backfill check uid=$uid ws=$workspaceId '
        'orgFound=${org != null} isOwnerLocal=$isOwnerLocal');
    final existing = await _ds.read(uid, workspaceId);
    if (existing != null) {
      debugPrint('[ACCESS_SNAPSHOT] backfill skipped: snapshot already exists');
      return existing;
    }
    if (org == null || !isOwnerLocal) {
      debugPrint('[ACCESS_SNAPSHOT] backfill skipped: '
          'no_evidence (need org+isOwner)');
      return null;
    }
    debugPrint('[ACCESS_SNAPSHOT] backfill applying LOCAL_BOOTSTRAP');
    await persistLocalBootstrap(userId: uid, org: org);
    // Re-leer + hidratar stores.
    return hydrate(uid, workspaceId);
  }

  // ─── ESCRITURA ────────────────────────────────────────────────────────────

  /// Persiste un snapshot LOCAL_BOOTSTRAP tras `CompleteOnboardingUC` exitoso.
  /// El usuario es el creador del workspace, así que isOwner=true por
  /// construcción. `isProvider` se infiere de `Organization.capabilityProfiles`.
  ///
  /// `syncStatus = pendingSync` SIEMPRE: la creación local NO es confirmación
  /// del backend. El siguiente `persistServerRefresh()` exitoso lo elevará
  /// a CONFIRMED, o `markSyncFailed()` lo marcará como tal si falla.
  Future<void> persistLocalBootstrap({
    required String userId,
    required OrganizationEntity org,
  }) async {
    final hasProviderCapability = org.capabilityProfiles
        .any((c) => c.kind == ProfileKind.provider);
    final now = _clock();
    final snapshot = AccessContextSnapshotModel()
      ..compositeKey =
          AccessContextSnapshotModel.makeCompositeKey(userId, org.id)
      ..userId = userId
      ..workspaceId = org.id
      ..localWorkspaceId = null
      ..platformActorId = null
      ..membershipId = null
      ..role = 'OWNER'
      ..isOwner = true
      ..isProvider = hasProviderCapability
      ..providerProfileId = null
      ..providerWorkspaceId = null
      ..capabilities = List<String>.from(OwnerDefaultCapabilities.set)
      ..source = AccessSnapshotSource.localBootstrap
      ..syncStatus = AccessSyncStatus.pendingSync
      ..versionTag = null
      ..lastError = null
      ..createdAt = now
      ..fetchedAt = now
      ..staleAt = now.add(AccessSnapshotPolicy.freshUntil)
      ..expiresAt = now.add(AccessSnapshotPolicy.criticallyStaleAfter);
    await _ds.upsert(snapshot);
    currentSnapshot.value = snapshot;
    debugPrint('[ACCESS_SNAPSHOT] persisted LOCAL_BOOTSTRAP+pendingSync '
        'uid=$userId workspaceId=${org.id} '
        'isProvider=$hasProviderCapability');
  }

  /// Persiste un snapshot SERVER_REFRESH desde un AccessContext canónico.
  /// Llamado por `AccessGateway` cuando `/context` resuelve NONE o cuando
  /// `bootstrap` completó y el siguiente `/context` confirmó NONE.
  ///
  /// `syncStatus = confirmed` SIEMPRE — la respuesta del servidor ES la
  /// confirmación. `isProvider` y `providerWorkspaceId` se preservan del
  /// snapshot anterior si el ctx no los trae (ese campo viene de
  /// `/providers/me`, no de `/context`). Para poblar provider info usar
  /// `persistProviderInfo`.
  Future<void> persistServerRefresh({
    required String userId,
    required AccessContext ctx,
    String? versionTag,
  }) async {
    final workspaceId = ctx.activeWorkspace?.orgId;
    if (workspaceId == null || workspaceId.isEmpty) {
      if (kDebugMode) {
        debugPrint('[ACCESS_SNAPSHOT] persistServerRefresh skipped: '
            'no workspaceId resoluble en /context');
      }
      return;
    }
    final previous = await _ds.read(userId, workspaceId);
    final now = _clock();

    final snapshot = AccessContextSnapshotModel()
      ..compositeKey =
          AccessContextSnapshotModel.makeCompositeKey(userId, workspaceId)
      ..userId = userId
      ..workspaceId = workspaceId
      ..localWorkspaceId = previous?.localWorkspaceId
      ..platformActorId = previous?.platformActorId
      ..membershipId = ctx.membership?.id ?? previous?.membershipId
      ..role = previous?.role
      // isOwner no viene en /context. Preservar el flag previo si existe;
      // si no hay previo, default false (deny-by-default — el bypass de
      // fundador requiere evidencia explícita vía LOCAL_BOOTSTRAP previo).
      ..isOwner = previous?.isOwner ?? false
      ..isProvider = previous?.isProvider ?? false
      ..providerProfileId = previous?.providerProfileId
      ..providerWorkspaceId = previous?.providerWorkspaceId
      ..capabilities = List<String>.from(ctx.capabilities)
      ..source = AccessSnapshotSource.serverRefresh
      ..syncStatus = AccessSyncStatus.confirmed
      ..versionTag = versionTag
      ..lastError = null
      ..createdAt = previous?.createdAt ?? now
      ..fetchedAt = now
      ..staleAt = now.add(AccessSnapshotPolicy.freshUntil)
      ..expiresAt = now.add(AccessSnapshotPolicy.criticallyStaleAfter);
    await _ds.upsert(snapshot);
    currentSnapshot.value = snapshot;
    debugPrint('[ACCESS_SNAPSHOT] persisted SERVER_REFRESH+confirmed '
        'uid=$userId workspaceId=$workspaceId '
        'capabilities=${ctx.capabilities.length} '
        'versionTag=$versionTag');
  }

  /// Actualiza solo los campos provider en el snapshot existente. Llamado
  /// por background refresh de `/providers/me`. No-op si no hay snapshot
  /// previo (provider info sin contexto base es ruido).
  Future<void> persistProviderInfo({
    required String userId,
    required String workspaceId,
    required bool isProvider,
    required String providerWorkspaceId,
    String? providerProfileId,
  }) async {
    final previous = await _ds.read(userId, workspaceId);
    if (previous == null) return;
    if (previous.isProvider == isProvider &&
        previous.providerWorkspaceId == providerWorkspaceId &&
        previous.providerProfileId == providerProfileId) {
      return;
    }
    final now = _clock();
    previous
      ..isProvider = isProvider
      ..providerWorkspaceId = providerWorkspaceId
      ..providerProfileId = providerProfileId ?? previous.providerProfileId
      ..fetchedAt = now
      ..staleAt = now.add(AccessSnapshotPolicy.freshUntil)
      ..expiresAt = now.add(AccessSnapshotPolicy.criticallyStaleAfter);
    await _ds.upsert(previous);
    if (kDebugMode) {
      debugPrint('[ACCESS_SNAPSHOT] provider info updated '
          'uid=$userId workspaceId=$workspaceId '
          'isProvider=$isProvider providerWorkspaceId=$providerWorkspaceId');
    }
  }

  // ─── CONFIRMACIÓN / FALLO ─────────────────────────────────────────────────

  /// Marca el snapshot existente como `pendingSync`. Caso de uso V2.2+:
  /// cuando una acción local optimista necesita re-confirmar contexto
  /// antes de permitir networkCritical. No-op si no hay snapshot.
  Future<void> markPendingSync({
    required String userId,
    required String workspaceId,
  }) async {
    final previous = await _ds.read(userId, workspaceId);
    if (previous == null) return;
    if (previous.syncStatus == AccessSyncStatus.pendingSync) return;
    previous
      ..syncStatus = AccessSyncStatus.pendingSync
      ..lastError = null;
    await _ds.upsert(previous);
    if (currentSnapshot.value?.compositeKey == previous.compositeKey) {
      currentSnapshot.value = previous;
    }
    debugPrint('[ACCESS_SNAPSHOT] marked PENDING_SYNC '
        'uid=$userId workspaceId=$workspaceId');
  }

  /// Marca el snapshot existente como `syncFailed`. Caso de uso: el gateway
  /// detecta 5xx / red caída persistente sobre `/context`. NO usar para
  /// 401/403 — esos invalidan completamente vía `clearForWorkspace`.
  /// No-op si no hay snapshot.
  Future<void> markSyncFailed({
    required String userId,
    required String workspaceId,
    String? error,
  }) async {
    final previous = await _ds.read(userId, workspaceId);
    if (previous == null) return;
    previous
      ..syncStatus = AccessSyncStatus.syncFailed
      ..lastError = error;
    await _ds.upsert(previous);
    if (currentSnapshot.value?.compositeKey == previous.compositeKey) {
      currentSnapshot.value = previous;
    }
    debugPrint('[ACCESS_SNAPSHOT] marked SYNC_FAILED '
        'uid=$userId workspaceId=$workspaceId error=$error');
  }

  // ─── INVALIDACIÓN ─────────────────────────────────────────────────────────

  /// Borra el snapshot del par `(userId, workspaceId)`. Usar en workspace
  /// switch (el snapshot del workspace abandonado se invalida) y en
  /// 401/403 sobre ese workspace específico. El próximo refresh exitoso
  /// reconstruirá el snapshot.
  ///
  /// NO limpia los stores reactivos automáticamente — el caller decide
  /// si debe limpiarlos (ej. en logout sí; en workspace switch quizás
  /// quiere mantenerlos hasta hidratar el nuevo).
  Future<void> clearForWorkspace({
    required String userId,
    required String workspaceId,
  }) async {
    await _ds.deleteByWorkspace(userId, workspaceId);
    final key =
        AccessContextSnapshotModel.makeCompositeKey(userId, workspaceId);
    if (currentSnapshot.value?.compositeKey == key) {
      currentSnapshot.value = null;
    }
    debugPrint('[ACCESS_SNAPSHOT] cleared workspace '
        'uid=$userId workspaceId=$workspaceId');
  }

  /// Borra TODOS los snapshots del usuario y limpia stores reactivos.
  /// Usar exclusivamente en logout.
  Future<void> clearForUser(String userId) async {
    await _ds.deleteByUser(userId);
    _capabilitiesStore.clear();
    _providerContextStore.clear();
    currentSnapshot.value = null;
    debugPrint('[ACCESS_SNAPSHOT] cleared ALL for uid=$userId');
  }

  // ─── POLÍTICA DE STALENESS ────────────────────────────────────────────────

  bool isFresh(AccessContextSnapshotModel s) {
    final age = _clock().difference(s.fetchedAt);
    return age < AccessSnapshotPolicy.freshUntil;
  }

  bool isStale(AccessContextSnapshotModel s) {
    final age = _clock().difference(s.fetchedAt);
    return age >= AccessSnapshotPolicy.freshUntil &&
        age < AccessSnapshotPolicy.criticallyStaleAfter;
  }

  bool isCriticallyStale(AccessContextSnapshotModel s) {
    final age = _clock().difference(s.fetchedAt);
    return age >= AccessSnapshotPolicy.criticallyStaleAfter;
  }
}
