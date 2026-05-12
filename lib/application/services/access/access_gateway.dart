// ============================================================================
// lib/application/services/access/access_gateway.dart
// ACCESS GATEWAY — orquestador del flujo proactivo del subsistema de acceso.
// ============================================================================
// QUÉ HACE:
// - Ejecuta el flujo proactivo §5 del contrato en app launch / post-login:
//     1. GET /v1/access/me/context
//     2. switch requiresAction:
//          · NONE              → publicar capabilities + estado ready.
//          · BOOTSTRAP_REQUIRED→ POST /v1/auth/bootstrap (+ refresh si aplica)
//                                → re-llamar /context → publicar estado.
//          · SELECT_WORKSPACE  → estado requiresWorkspaceSelection (sin
//                                navegar si no existe UI; no inventar
//                                workspace).
//          · CONTACT_SUPPORT   → estado blocked.
// - Expone `AccessGatewayState` reactivo para que la capa presentation
//   decida UX (splash, banners, redirección a workspace picker, etc.).
// - Resetea `AccessSessionState` + `SessionCapabilitiesStore` en logout.
//
// QUÉ NO HACE:
// - No es un Controller GetX. No pertenece a presentation. Es un servicio
//   de `application/services/access/` que cualquier Controller puede
//   invocar (Splash, AuthState, SessionContext).
// - No navega. Publica estado; la UI decide.
// - No duplica la lógica reactiva del interceptor. Si el gateway recibe un
//   error en /context, NO intenta bootstrapear desde aquí en paralelo al
//   interceptor: el flujo proactivo tiene reglas distintas del reactivo.
//
// PRINCIPIOS:
// - Context-first + bootstrap condicional: `ensureAccessReady()` SIEMPRE
//   llama GET /context, pero POST /bootstrap solo se dispara si el server
//   reporta `requiresAction == BOOTSTRAP_REQUIRED`.
// - Idempotente: llamar `ensureAccessReady()` N veces en la misma sesión no
//   dispara N bootstraps (el `AccessSessionState` lo impide).
// - Single-flight a nivel de gateway: dos invocaciones paralelas de
//   `ensureAccessReady()` comparten el mismo Future.
// - Deny-by-default: errores no modelados → estado `error(reason)`.
//
// ENTERPRISE NOTES:
// - Fuente: "Contrato de integración — Flutter ↔ Core API Access" §5.
// - La integración con `SessionContextController` se deja opcional — el
//   gateway solo lee capabilities localmente vía store; el Controller puede
//   observar el estado del gateway cuando se decida cablear en splash.
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/access/access_context.dart';
import '../../../domain/entities/access/access_enums.dart';
import '../../../domain/errors/access_exceptions.dart';
import '../../../domain/errors/remote_exceptions.dart';
import '../../../domain/repositories/access_repository.dart';
import 'access_session_state.dart';
import 'access_snapshot_service.dart';
import 'provider_context_store.dart';
import 'session_capabilities_store.dart';

/// Estado reactivo del gateway. La UI (splash, shell) lo observa para
/// decidir redirección / banner.
sealed class AccessGatewayState {
  const AccessGatewayState();
}

class AccessGatewayIdle extends AccessGatewayState {
  const AccessGatewayIdle();
}

class AccessGatewayLoading extends AccessGatewayState {
  const AccessGatewayLoading();
}

class AccessGatewayReady extends AccessGatewayState {
  final AccessContext context;
  const AccessGatewayReady(this.context);
}

class AccessGatewayRequiresWorkspaceSelection extends AccessGatewayState {
  final AccessContext context;
  const AccessGatewayRequiresWorkspaceSelection(this.context);
}

class AccessGatewayBlocked extends AccessGatewayState {
  final AccessContext context;
  const AccessGatewayBlocked(this.context);
}

class AccessGatewayError extends AccessGatewayState {
  final Object error;
  const AccessGatewayError(this.error);
}

class AccessGateway {
  final AccessRepository _repository;
  final AccessSessionState _sessionState;
  final SessionCapabilitiesStore _capabilitiesStore;
  final ProviderContextStore? _providerContextStore;
  final AccessSnapshotService? _snapshotService;
  final Future<String?> Function({bool forceRefresh}) _refreshIdToken;
  final String? Function() _resolveLocalOrgId;
  final String? Function()? _resolveCurrentUid;

  final ValueNotifier<AccessGatewayState> _state =
      ValueNotifier<AccessGatewayState>(const AccessGatewayIdle());

  Future<AccessGatewayState>? _inFlight;

  AccessGateway({
    required AccessRepository repository,
    required AccessSessionState sessionState,
    required SessionCapabilitiesStore capabilitiesStore,
    ProviderContextStore? providerContextStore,
    AccessSnapshotService? snapshotService,
    required Future<String?> Function({bool forceRefresh}) refreshIdToken,
    required String? Function() resolveLocalOrgId,
    String? Function()? resolveCurrentUid,
  })  : _repository = repository,
        _sessionState = sessionState,
        _capabilitiesStore = capabilitiesStore,
        _providerContextStore = providerContextStore,
        _snapshotService = snapshotService,
        _refreshIdToken = refreshIdToken,
        _resolveLocalOrgId = resolveLocalOrgId,
        _resolveCurrentUid = resolveCurrentUid;

  /// Estado actual (observable con `ValueListenableBuilder` o `.addListener`).
  ValueListenable<AccessGatewayState> get state => _state;

  /// Asegura que el estado de acceso del caller quede resuelto contra Core API,
  /// siguiendo el flujo proactivo §5 del contrato:
  ///
  ///   1. SIEMPRE llama GET /v1/access/me/context (único request garantizado).
  ///   2. Según `requiresAction`:
  ///        · NONE               → ready. NO hay POST /bootstrap.
  ///        · BOOTSTRAP_REQUIRED → POST /v1/auth/bootstrap + refresh + re-fetch /context.
  ///        · SELECT_WORKSPACE   → estado terminal "requiresWorkspaceSelection".
  ///                               NO hay POST /bootstrap.
  ///        · CONTACT_SUPPORT    → estado terminal bloqueante.
  ///                               NO hay POST /bootstrap.
  ///
  /// Idempotente + single-flight: N invocaciones paralelas comparten el mismo
  /// Future. Tras completarse, una llamada posterior re-ejecuta el flujo (lo
  /// cual es barato si /context devuelve NONE; el contrato §5 exige consultar
  /// /context en cada arranque para detectar mutaciones server-side).
  ///
  /// Puntos de invocación esperados:
  /// - App launch (cold start + hot restart) — vía SplashBootstrapController.
  /// - Tras workspace switch exitoso (post-`resetForWorkspaceSwitch`).
  /// - Tras login OTP/federated si se quiere validación explícita inmediata.
  Future<AccessGatewayState> ensureAccessReady() {
    final pending = _inFlight;
    if (pending != null) return pending;
    final future = _run();
    _inFlight = future;
    return future.whenComplete(() => _inFlight = null);
  }

  /// Reset al hacer logout. Limpia flags, capabilities, provider context y
  /// estado observable. También invalida el snapshot persistido del usuario
  /// para que un re-login con la misma cuenta no arranque con permisos
  /// viejos antes de un refresh.
  void resetForLogout() {
    _sessionState.resetForLogout();
    _capabilitiesStore.clear();
    _providerContextStore?.clear();
    final uid = _resolveCurrentUid?.call();
    if (uid != null && uid.isNotEmpty) {
      // Fire-and-forget: el logout no debe bloquearse por una escritura Isar.
      _snapshotService?.clearForUser(uid).catchError((e) {
        _log('snapshot clear on logout failed (non-fatal): $e');
      });
    }
    _state.value = const AccessGatewayIdle();
    _log('gateway reset (logout)');
  }

  /// Reset al cambiar workspace. No limpia capabilities (el próximo
  /// `ensureAccessReady()` las publicará de nuevo). Limpia el provider
  /// context: el nuevo workspace puede tener `isProvider` distinto.
  ///
  /// V2.1 (composite key): los snapshots persistidos NO se purgan en
  /// workspace switch — viven keyed por (uid, workspaceId), así que cada
  /// workspace conserva su propia caché. El próximo `hydrate()` con el
  /// nuevo workspaceId encuentra (o no) su snapshot independiente. Esto
  /// permite cold starts local-first incluso después de switching entre
  /// workspaces sin perder caché.
  void resetForWorkspaceSwitch() {
    _sessionState.resetForWorkspaceSwitch();
    _providerContextStore?.clear();
    _state.value = const AccessGatewayIdle();
    _log('gateway reset (workspace switch) — snapshots preservados');
  }

  /// Hidrata `SessionCapabilitiesStore` y `ProviderContextStore` desde el
  /// snapshot persistido en Isar para el par `(uid, workspaceId)`. Si
  /// existe y no está críticamente vencido, los stores quedan poblados
  /// ANTES de cualquier llamada a Core API — el shell renderiza con
  /// permisos completos sin esperar red.
  ///
  /// El `state` reactivo del gateway NO se modifica: este método es solo
  /// pre-fetch local. El gateway sigue mostrando `Idle` hasta que
  /// `ensureAccessReady()` resuelva contra el servidor.
  ///
  /// Invocar desde el splash ANTES de `ensureAccessReady()`. Idempotente.
  Future<void> hydrateFromLocal(String uid, String workspaceId) async {
    final svc = _snapshotService;
    if (svc == null) return;
    if (workspaceId.isEmpty) return;
    try {
      await svc.hydrate(uid, workspaceId);
    } catch (e) {
      _log('hydrateFromLocal error (non-fatal): $e');
    }
  }

  // --------------------------------------------------------------------------
  // Internals
  // --------------------------------------------------------------------------

  Future<AccessGatewayState> _run() async {
    _state.value = const AccessGatewayLoading();
    debugPrint('[ACCESS_GATEWAY] remote refresh started');

    try {
      final ctx = await _repository.getContext();
      _log('access context loaded: $ctx');
      return _handleContext(ctx);
    } on UnauthorizedException catch (e) {
      debugPrint('[ACCESS_GATEWAY] remote refresh failed reason=401_403 '
          'detail=$e');
      _markSnapshotSyncFailedIfPossible('401_403');
      final next = AccessGatewayError(e);
      _state.value = next;
      return next;
    } on CoreCommonRemoteException catch (e) {
      debugPrint('[ACCESS_GATEWAY] remote refresh failed reason=remote_error '
          'detail=$e');
      _markSnapshotSyncFailedIfPossible('remote_error');
      final next = AccessGatewayError(e);
      _state.value = next;
      return next;
    } catch (e) {
      // Heurística para distinguir red/timeout de otros — útil en logs.
      final reason = e.toString().toLowerCase().contains('timeout')
          ? 'timeout'
          : (e.toString().toLowerCase().contains('socket')
              ? 'network'
              : 'unexpected');
      debugPrint('[ACCESS_GATEWAY] remote refresh failed reason=$reason '
          'detail=$e');
      _markSnapshotSyncFailedIfPossible(reason);
      final next = AccessGatewayError(e);
      _state.value = next;
      return next;
    }
  }

  /// Best-effort: si hay snapshot persistido para el workspace activo,
  /// marcarlo `syncFailed` con la razón humana. Permite UI fina (banner
  /// suave en lugar de hard error). No-op si no hay snapshot o si no
  /// podemos resolver uid/wsId.
  void _markSnapshotSyncFailedIfPossible(String reason) {
    final svc = _snapshotService;
    if (svc == null) return;
    final uid = _resolveCurrentUid?.call();
    final wsId = _resolveLocalOrgId();
    if (uid == null || uid.isEmpty || wsId == null || wsId.isEmpty) return;
    svc
        .markSyncFailed(userId: uid, workspaceId: wsId, error: reason)
        .catchError((e) {
      _log('markSyncFailed failed (non-fatal): $e');
    });
  }

  Future<AccessGatewayState> _handleContext(AccessContext ctx) async {
    switch (ctx.requiresAction) {
      case RequiresAction.none:
        _capabilitiesStore.set(ctx.capabilities);
        // [AuthBootstrap] log canónico — visible cuando /context resuelve
        // sin necesidad de POST /bootstrap (caller ya provisionado).
        if (kDebugMode) {
          debugPrint('[AuthBootstrap] '
              'activeOrgId=${ctx.activeOrgId} '
              'workspaceId=${ctx.activeWorkspace?.id} '
              'membershipId=${ctx.membership?.id} '
              'capabilities=${ctx.capabilities} '
              'source=context_none');
        }
        // Persistir snapshot SERVER_REFRESH para acelerar próximos cold
        // starts. Fire-and-forget: la respuesta al caller no debe esperar
        // la escritura Isar.
        _persistSnapshotFromContext(ctx);
        if (ctx.requiresTokenRefresh) {
          _log('token refresh required by /context');
          await _refreshIdToken(forceRefresh: true);
        }
        final next = AccessGatewayReady(ctx);
        _state.value = next;
        return next;

      case RequiresAction.bootstrapRequired:
        return _handleBootstrapRequired(ctx);

      case RequiresAction.selectWorkspace:
        _log('context requires workspace selection');
        _capabilitiesStore.clear();
        final next = AccessGatewayRequiresWorkspaceSelection(ctx);
        _state.value = next;
        return next;

      case RequiresAction.contactSupport:
        _log('context blocked state');
        _capabilitiesStore.clear();
        final next = AccessGatewayBlocked(ctx);
        _state.value = next;
        return next;
    }
  }

  Future<AccessGatewayState> _handleBootstrapRequired(
      AccessContext ctx) async {
    // ── Terminal check: bootstrap ya fue exitoso, pero el backend sigue
    //    reportando BOOTSTRAP_REQUIRED → inconsistencia de estado.
    if (_sessionState.bootstrapSucceeded) {
      _log('post-success /context still reports BOOTSTRAP_REQUIRED — '
          'inconsistent backend state');
      const err = AccessBootstrapExhaustedException(
        'Backend reports BOOTSTRAP_REQUIRED after a successful bootstrap '
        'in this session.',
      );
      const next = AccessGatewayError(err);
      _state.value = next;
      return next;
    }

    // ── Terminal check: intento previo falló con razón terminal (policy
    //    blocker u otro error no recuperable). No reintentar hasta logout.
    if (_sessionState.bootstrapTerminal) {
      _log('previous bootstrap failure was terminal — not retrying');
      const err = AccessBootstrapExhaustedException(
        'Previous bootstrap attempt failed with a terminal reason '
        'in this session.',
      );
      const next = AccessGatewayError(err);
      _state.value = next;
      return next;
    }

    // Resolver orgId: preferir el activeOrgId reportado por /context
    // (puede venir del claim aunque no exista workspace todavía); si no,
    // caer al orgId local (activeContext.orgId o primera membership).
    final orgIdFromContext = ctx.activeOrgId;
    final orgIdFromLocal = _resolveLocalOrgId();
    final orgId = (orgIdFromContext != null && orgIdFromContext.isNotEmpty)
        ? orgIdFromContext
        : (orgIdFromLocal != null && orgIdFromLocal.isNotEmpty
            ? orgIdFromLocal
            : null);

    // ── PRE-CHECK: si no hay orgId disponible, NO llamar a /bootstrap.
    //    El server devolvería 400 ACTIVE_ORG_ID_MISSING y antes quemábamos
    //    el flag bloqueando reintentos legítimos tras onboarding. Ahora:
    //      · marcamos outcome = failedMissingOrgId (RECUPERABLE),
    //      · emitimos RequiresWorkspaceSelection para que UI pueda decidir,
    //      · NO llamamos backend — cuando el orgId aparezca, un nuevo
    //        trigger (manual o reactivo) podrá intentar bootstrap.
    if (orgId == null) {
      _log('bootstrap skipped: no orgId available (missing_active_org, '
          'recoverable)');
      _sessionState.markBootstrapFailedMissingOrgId();
      _capabilitiesStore.clear();
      final next = AccessGatewayRequiresWorkspaceSelection(ctx);
      _state.value = next;
      return next;
    }

    _log('bootstrap required; calling POST /v1/auth/bootstrap (orgId=$orgId)');

    try {
      final result = await _repository.bootstrap(orgId: orgId);
      _log('bootstrap completed (orgIdSource=${result.orgIdSource.name})');

      // [AuthBootstrap] log canónico — observabilidad del onboarding sin
      // exponer el orgId completo en producción si fuera sensible.
      if (kDebugMode) {
        debugPrint('[AuthBootstrap] '
            'activeOrgId=${result.activeOrgId} '
            'workspaceId=${result.workspaceId} '
            'membershipId=${result.membershipId} '
            'capabilities=${result.capabilities}');
      }

      if (result.requiresTokenRefresh) {
        _log('token refresh required post-bootstrap');
        await _refreshIdToken(forceRefresh: true);
      }

      _sessionState.markBootstrapSucceeded();

      // Re-fetch /context para confirmar NONE (contrato §5 STEP E → STEP B).
      final refreshed = await _repository.getContext();
      _log('post-bootstrap /context: $refreshed');
      return _handleContext(refreshed);
    } on BadRequestException catch (e) {
      _log('bootstrap 400 code=${e.code}: $e');
      if (e.code == AccessErrorCode.activeOrgIdMissing) {
        // Edge case: pasamos un orgId pero el server lo rechazó como missing
        // (raro, pero posible si el server cambió reglas). Tratamos como
        // RECUPERABLE igual que el pre-check, no quemamos flag terminal.
        _sessionState.markBootstrapFailedMissingOrgId();
        final next = AccessGatewayRequiresWorkspaceSelection(ctx);
        _state.value = next;
        return next;
      }
      // Otras 400 (validation errors) → terminal no recuperable.
      _sessionState.markBootstrapFailedOther();
      final next = AccessGatewayError(e);
      _state.value = next;
      return next;
    } on UnauthorizedException catch (e) {
      // 401/403 durante bootstrap = policy blocker (USER_SUSPENDED/INACTIVE/
      // PENDING_ACTIVATION/MEMBERSHIP_INACTIVE). TERMINAL por sesión; el
      // usuario debe contactar soporte.
      _log('bootstrap 401/403 — policy blocker: $e');
      _sessionState.markBootstrapFailedBlockingPolicy();
      final next = AccessGatewayError(e);
      _state.value = next;
      return next;
    } on CoreCommonRemoteException catch (e) {
      _log('bootstrap remote error: $e');
      _sessionState.markBootstrapFailedOther();
      final next = AccessGatewayError(e);
      _state.value = next;
      return next;
    } catch (e) {
      _log('bootstrap unexpected error: $e');
      _sessionState.markBootstrapFailedOther();
      final next = AccessGatewayError(e);
      _state.value = next;
      return next;
    }
  }

  /// Persiste un snapshot SERVER_REFRESH+CONFIRMED a partir del [ctx]
  /// canónico. No awaiteado por el caller — escribir Isar nunca debe
  /// retrasar la resolución del estado del gateway. Errores se loguean
  /// y se ignoran.
  void _persistSnapshotFromContext(AccessContext ctx) {
    final svc = _snapshotService;
    if (svc == null) return;
    final uid = _resolveCurrentUid?.call();
    if (uid == null || uid.isEmpty) return;
    svc.persistServerRefresh(userId: uid, ctx: ctx).catchError((e) {
      _log('snapshot persist failed (non-fatal): $e');
    });
  }

  void _log(String msg) {
    if (kDebugMode) debugPrint('[ACCESS] $msg');
  }
}
