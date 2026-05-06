// ============================================================================
// lib/presentation/controllers/splash_bootstrap_controller.dart
// SPLASH BOOTSTRAP CONTROLLER — Local-first (Presentation / Controller)
//
// QUÉ HACE:
// - Decide la ruta de entrada con DATOS LOCALES (Isar + SharedPreferences).
// - Si hay `user + activeContext.orgId`, navega al workspace en cuanto la
//   hidratación Isar termina, dándole un budget corto (≤500ms) a
//   `AccessGateway` para publicar capabilities antes de la nav (mejor UX en
//   redes rápidas) sin bloquear nunca cuando la red es lenta o falla.
// - Dispara `AccessGateway.ensureAccessReady()`, `providers/me` y la
//   validación de claims en BACKGROUND. El shell observa el estado.
//
// QUÉ NO HACE:
// - NO espera indefinidamente `GET /v1/access/me/context`.
// - NO espera `GET /v1/providers/me` para navegar (lectura local del store
//   + capability profiles del Organization local).
// - NO bloquea splash con `POST /bootstrap` (sigue corriendo en background;
//   el shell muestra `BootstrapSyncBanner` durante la convergencia).
// - NO enruta a wizards legacy por fallback (`createPortfolioStep1`,
//   `Routes.providerBootstrap`).
// - NO enruta a `Routes.welcome` cuando hay fbUser (regla I1).
//
// PRINCIPIOS:
// - Splash <500ms cuando hay contexto local válido.
// - `AccessGatewayBlocked` y `RequiresWorkspaceSelection` se manejan en el
//   shell (modal/banner) cuando ya hay workspace local. Si NO hay workspace
//   local utilizable, las rutas conservadoras (`countryCity`, `profile`)
//   las cubren sin esperar la red.
// - Telemetry preservada: cada gate emite `boot_gate`. Las decisiones
//   degraded llevan `reason='budget_exceeded'`.
// ============================================================================

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../application/services/access/access_gateway.dart';
import '../../application/services/access/access_snapshot_service.dart';
import '../../application/services/access/provider_context_store.dart';
import '../../core/di/container.dart';
import '../../data/datasources/local/registration_intent_ds.dart';
import '../../data/datasources/local/registration_progress_ds.dart';
import '../../data/models/auth/registration_progress_model.dart';
import '../../domain/entities/user/active_context.dart';
import '../../domain/entities/workspace/workspace_type.dart';
import '../../domain/services/access/post_bootstrap_router.dart';
import '../../domain/value/capability/profile_kind.dart';
import '../../domain/value/capability/provider_type.dart';
import '../../routes/app_pages.dart';
import '../../services/telemetry/telemetry_service.dart';
import '../auth/controllers/registration_controller.dart';
import '../workspace/workspace_config.dart';
import '../workspace/workspace_shell.dart';
import 'session_context_controller.dart';

class SplashBootstrapController extends GetxController {
  // Budget máximo que el splash le da a AccessGateway para publicar
  // capabilities antes de navegar. Si vence, navegamos degraded y el
  // gateway sigue en background — el shell rerenderiza cuando capabilities
  // estén listas.
  static const Duration _accessBudget = Duration(milliseconds: 400);

  bool _bootstrapInProgress = false;

  Future<void> bootstrap() async {
    if (_bootstrapInProgress) {
      _log('bootstrap() re-entry ignored (already in progress)');
      return;
    }
    _bootstrapInProgress = true;
    final stopwatch = Stopwatch()..start();

    try {
      await _runGates();
    } catch (e, st) {
      _log('FATAL error in bootstrap, redirecting to welcome. err=$e');
      if (kDebugMode) debugPrint('[BOOT] stacktrace: $st');
      Get.offAllNamed(Routes.welcome);
    } finally {
      stopwatch.stop();
      _log('bootstrap finished in ${stopwatch.elapsedMilliseconds}ms');
      _bootstrapInProgress = false;
    }
  }

  Future<void> _runGates() async {
    // ── Gate 1: Auth ────────────────────────────────────────────────────────
    final fbUser = FirebaseAuth.instance.currentUser;
    if (fbUser == null) {
      _logGate('auth', Routes.welcome, reason: 'no_firebase_user');
      Get.offAllNamed(Routes.welcome);
      return;
    }
    final maskedUid =
        '${fbUser.uid.substring(0, fbUser.uid.length.clamp(0, 4))}***';
    _logGate('auth', 'pass', reason: 'uid=$maskedUid');

    // ── Onboarding restore (local) ──────────────────────────────────────────
    try {
      final restored =
          await DIContainer().onboardingSessionService.restore(fbUser.uid);
      if (restored != null) {
        _logGate(
          'onboarding',
          Routes.registerOnboarding,
          reason: 'in_progress_step=${restored.currentStep}',
        );
        Get.offAllNamed(Routes.registerOnboarding);
        return;
      }
    } catch (e) {
      _log('onboarding session check error (non-fatal): $e');
    }

    // ── Hidratación Isar (local-only; init no espera red) ───────────────────
    final session = Get.find<SessionContextController>();
    try {
      await session.init(fbUser.uid);
    } catch (e) {
      _log('session.init error (non-fatal): $e');
    }

    // ── Hidratar SessionCapabilitiesStore + ProviderContextStore desde el
    //    snapshot persistido en Isar para `(uid, activeOrgId)`. ANTES de
    //    cualquier llamada HTTP. Si el usuario creó el workspace localmente
    //    o ya tuvo un SERVER_REFRESH exitoso previo en este workspace, los
    //    stores quedan poblados sin red.
    //
    //    BACKFILL: si NO hay snapshot persistido (típicamente usuarios
    //    EXISTENTES que no pasaron por el onboarding V2.1, o que crearon
    //    su workspace antes de existir esta colección), sintetizamos uno
    //    LOCAL_BOOTSTRAP+pendingSync desde la evidencia local: si la
    //    Organization tiene `ownerUid == uid`, el usuario es OWNER por
    //    construcción local. Esto cierra el gap del banner "verificación
    //    falló" para usuarios pre-existentes.
    final preHydrateOrgId = session.user?.activeContext?.orgId;
    if (preHydrateOrgId != null &&
        preHydrateOrgId.isNotEmpty &&
        Get.isRegistered<AccessSnapshotService>()) {
      try {
        final svc = Get.find<AccessSnapshotService>();
        final hydrated = await svc.hydrate(fbUser.uid, preHydrateOrgId);
        if (hydrated == null) {
          // Backfill desde Org local. Lectura local-first del repo.
          final org =
              await DIContainer().orgRepository.getOrg(preHydrateOrgId);
          final isOwnerLocal = org?.ownerUid == fbUser.uid;
          await svc.backfillFromLocalOwnership(
            uid: fbUser.uid,
            workspaceId: preHydrateOrgId,
            org: org,
            isOwnerLocal: isOwnerLocal,
          );
        }
      } catch (e) {
        _log('access snapshot hydrate/backfill error (non-fatal): $e');
      }
    }

    // ── Kick AccessGateway en background INMEDIATAMENTE ─────────────────────
    // Capturamos el future para opcionalmente esperarlo con budget corto
    // antes de navegar (capabilities listas → mejor primer render). Si el
    // budget vence, dejamos que termine en background y navegamos degraded.
    final accessFuture = _kickAccessGateway();

    // ── Kick provider/me en background ──────────────────────────────────────
    // Refresca `ProviderContextStore`. Splash NO espera la respuesta.
    _kickProviderMeRefresh();

    // ── Gate 2: Profile (LOCAL) ─────────────────────────────────────────────
    final hydration = session.hydrationState.value;
    final user = session.user;

    if (hydration == HydrationState.authOkProfileEmpty ||
        (hydration == HydrationState.authOkProfileUnknown && user == null)) {
      _logGate('profile', Routes.countryCity, reason: 'no_local_profile');
      Get.offAllNamed(Routes.countryCity);
      return;
    }
    if (user == null) {
      _logGate('profile', Routes.countryCity,
          reason: 'user_null_fbUser_not_null');
      Get.offAllNamed(Routes.countryCity);
      return;
    }
    final ctx = user.activeContext;
    if (ctx == null || ctx.orgId.isEmpty) {
      _logGate('profile', Routes.profile, reason: 'no_active_context');
      Get.offAllNamed(Routes.profile);
      return;
    }
    _logGate('profile', 'pass', reason: 'orgId_present');

    // ── Budget corto para AccessGateway (no bloqueante) ─────────────────────
    // Le damos hasta `_accessBudget` para publicar capabilities. Si responde
    // a tiempo, perfecto: el shell renderiza con capabilities listas. Si no,
    // navegamos degraded y el shell rerenderiza cuando lleguen.
    if (accessFuture != null) {
      try {
        final state = await accessFuture.timeout(_accessBudget);
        _logAccessGate(state);
      } on TimeoutException {
        _logGate('access', 'budget_exceeded',
            reason: 'navigating_degraded ${_accessBudget.inMilliseconds}ms');
      } catch (e) {
        _log('access budget wait error (non-fatal): $e');
      }
    }

    // ── Gate 3: Provider (LOCAL-ONLY) ───────────────────────────────────────
    // No esperamos /providers/me. Derivamos isProvider desde:
    //   1. ProviderContextStore (si ya está resuelto en memoria).
    //   2. Local Organization.capabilityProfiles (kind=provider).
    //   3. providerOnboardingIntent (SharedPreferences).
    final providerStore = Get.isRegistered<ProviderContextStore>()
        ? Get.find<ProviderContextStore>()
        : null;

    final localProviderType = await _resolveProviderType(ctx.orgId);
    final providerIntent =
        await RegistrationIntentDS().getProviderOnboardingIntent();

    final bool? storeIsProvider =
        (providerStore != null && providerStore.isResolved)
            ? providerStore.isProvider
            : null;

    // Si el store ya respondió en esta sesión, es la fuente de verdad. Si no,
    // inferimos desde el Organization local (la presencia de un capability
    // profile de provider implica isProvider=true). El intent se evalúa
    // aparte por el router (segunda rama) — no se mezcla aquí para no
    // promover un intent stale a "es proveedor".
    final bool isProvider = storeIsProvider ?? (localProviderType != null);

    final route = PostBootstrapRouter.resolve(
      isProvider: isProvider,
      providerOnboardingIntent: providerIntent,
    );

    switch (route) {
      case PostBootstrapRoute.providerMe:
        final providerType = localProviderType;
        final providerRoute = providerType == ProviderType.articulos
            ? Routes.providerWorkspaceArticles
            : Routes.providerWorkspaceServices;
        _logGate(
          'provider',
          providerRoute,
          reason: 'isProvider=$isProvider '
              'storeResolved=${storeIsProvider != null} '
              'intent=$providerIntent '
              'providerType=${providerType?.wireName ?? 'unresolved'}',
        );
        Get.offAllNamed(providerRoute);
        return;
      case PostBootstrapRoute.workspaceShell:
        _logGate('workspace', 'routing',
            reason: 'default (no provider signal)');
        await _routeToWorkspace(ctx, session);
        return;
    }
  }

  // ─── Background kicks ──────────────────────────────────────────────────────

  /// Dispara `AccessGateway.ensureAccessReady()` SIN await. Devuelve el
  /// future por si el caller quiere darle un budget corto antes de navegar.
  /// Cualquier excepción se atrapa: el gateway nunca debería lanzar
  /// (envuelve todo en `AccessGatewayError`), pero protegemos por si acaso.
  Future<AccessGatewayState>? _kickAccessGateway() {
    if (!Get.isRegistered<AccessGateway>()) {
      _log('AccessGateway no registrado — saltando background kick');
      return null;
    }
    try {
      final future = Get.find<AccessGateway>().ensureAccessReady();
      // Asegurar que un timeout/skip del caller no deje un error sin atrapar.
      future.then(_logAccessGate).catchError((e) {
        _log('access background error (non-fatal): $e');
      });
      return future;
    } catch (e) {
      _log('access kick error (non-fatal): $e');
      return null;
    }
  }

  /// Dispara `providerSelfRepository.me()` en background para refrescar
  /// `ProviderContextStore`. Splash nunca espera. Si falla, el store queda
  /// como estaba (resolved=false en cold start) y el shell renderiza
  /// degraded — un retry posterior puede repoblarlo.
  void _kickProviderMeRefresh() {
    unawaited(() async {
      try {
        final providerMe = await DIContainer().providerSelfRepository.me();
        if (Get.isRegistered<ProviderContextStore>()) {
          Get.find<ProviderContextStore>().set(
            isProvider: providerMe.isProvider,
            workspaceId: providerMe.workspaceId,
          );
        }
        if (kDebugMode) {
          debugPrint('[ProviderContext] background refresh '
              'isProvider=${providerMe.isProvider} '
              'workspaceId=${providerMe.workspaceId}');
        }
      } catch (e) {
        _log('providers/me background refresh error (non-fatal): $e');
      }
    }());
  }

  // ─── Workspace routing (local) ─────────────────────────────────────────────

  Future<void> _routeToWorkspace(
    ActiveContext ctx,
    SessionContextController session,
  ) async {
    final orgType = await _resolveOrgType(ctx);
    _logGate('workspace', 'pass_asset_admin_default',
        reason: 'orgId=${ctx.orgId} orgType=$orgType');
    final cfg = NavigationRegistry.configFor(
          WorkspaceType.assetAdmin,
          orgType: orgType,
        ) ??
        workspaceFor(
          rol: 'admin_activos_ind',
          providerType: null,
          orgType: orgType,
        );
    Get.offAll(() => WorkspaceShell(config: cfg));
  }

  /// Lee el [ProviderType] del primer [CapabilityProfile] con
  /// `kind == provider` en la organización local. Retorna null si la org
  /// no se encuentra o no tiene un capability profile de provider con
  /// providerType resoluble.
  Future<ProviderType?> _resolveProviderType(String orgId) async {
    try {
      final org = await DIContainer().orgRepository.getOrg(orgId);
      if (org == null) return null;
      for (final cap in org.capabilityProfiles) {
        if (cap.kind == ProfileKind.provider) {
          return cap.providerSpec?.providerType;
        }
      }
      return null;
    } catch (e) {
      _log('provider type resolve error (non-fatal): $e');
      return null;
    }
  }

  Future<String> _resolveOrgType(ActiveContext ctx) async {
    String orgType = '';
    String source = 'default';

    try {
      final org = await DIContainer().orgRepository.getOrg(ctx.orgId);
      orgType = _normalizeOrgType(org?.tipo);
      if (orgType.isNotEmpty) source = 'org';
    } catch (_) {}

    if (orgType.isEmpty) {
      try {
        if (Get.isRegistered<RegistrationController>()) {
          final reg = Get.find<RegistrationController>();
          reg.progress.value ??= await reg.progressDS.get('current');
          final t = _normalizeOrgType(reg.progress.value?.titularType);
          if (t.isNotEmpty) {
            orgType = t;
            source = 'progress';
          }
        } else {
          final ds = RegistrationProgressDS(DIContainer().isar);
          final RegistrationProgressModel? p = await ds.get('current');
          final t = _normalizeOrgType(p?.titularType);
          if (t.isNotEmpty) {
            orgType = t;
            source = 'progress';
          }
        }
      } catch (_) {}
    }

    if (orgType.isEmpty) {
      orgType = 'personal';
      source = 'default_fallback';
    }

    _log('gate=workspace orgType=$orgType source=$source');
    return orgType;
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  void _log(String msg) {
    if (kDebugMode || kProfileMode) {
      debugPrint('[BOOT] $msg');
    }
  }

  void _logGate(String gate, String result, {String reason = ''}) {
    _log('gate=$gate result=$result reason=$reason');
    try {
      if (Get.isRegistered<TelemetryService>()) {
        Get.find<TelemetryService>().log('boot_gate', {
          'gate': gate,
          'result': result,
          if (reason.isNotEmpty) 'reason': reason,
        });
      }
    } catch (_) {}
  }

  void _logAccessGate(dynamic accessState) {
    final kind = accessState.runtimeType.toString();
    switch (kind) {
      case 'AccessGatewayReady':
        _logGate('access', 'ready', reason: 'context_none');
        break;
      case 'AccessGatewayRequiresWorkspaceSelection':
        _logGate('access', 'workspace_required', reason: 'select_workspace');
        break;
      case 'AccessGatewayBlocked':
        _logGate('access', 'blocked', reason: 'contact_support');
        break;
      case 'AccessGatewayError':
        _logGate('access', 'error', reason: 'gateway_error_non_fatal');
        break;
      default:
        _logGate('access', 'unexpected', reason: 'state=$kind');
    }
  }

  String _normalizeOrgType(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final v = raw.toLowerCase().trim();
    if (v == 'empresa') return 'empresa';
    if (v == 'personal' || v == 'persona') return 'personal';
    _log('WARN orgType unexpected=$v → defaulting to personal');
    return 'personal';
  }
}
