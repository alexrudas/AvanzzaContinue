// ============================================================================
// lib/presentation/controllers/splash_bootstrap_controller.dart
// SPLASH BOOTSTRAP CONTROLLER — Enterprise Ultra Pro Premium (Presentation / Controller)
//
// QUÉ HACE:
// - Implementa la matriz S0–S3 de routing post-autenticación.
// - Lee HydrationState de SessionContextController para decidir ruta (sin timeout).
// - Gate 1 (Auth): fbUser == null → welcome.
// - Gate 2 (Profile): HydrationState-driven; authOkProfileEmpty → countryCity/profile.
// - Gate 3 (Assets): count Isar activos; 0 → createPortfolioStep1.
// - Gate 4 (Workspace): cadena canónica Fase 1:
//     activeWorkspaceContext → ContextValidator (síncrono) → NavigationRegistry → WorkspaceShell
//     Fallback 1: availableWorkspaceContexts (primer contexto válido)
//     Fallback 2: WorkspaceContextAdapter.fromLegacy (deriva desde ActiveContext)
//     Fallback 3: workspaceFor() legacy (solo si WorkspaceType != unknown)
//     Fallback final: Routes.profile (ruta segura, nunca welcome ni admin por defecto)
// QUÉ NO HACE:
// - NO usa userRx.stream.where(u!=null).first.timeout() (eliminado).
// - NO navega a Routes.home (evita loop bootstrap↔home).
// - NO toca RuntService, RuntRepository, RuntController.
// - NO abre workspace admin por defecto (WorkspaceType.unknown siempre falla).
// PRINCIPIOS:
// - I1: fbUser != null → NUNCA Routes.welcome (rutas conservadoras S1 en su lugar).
// - _bootstrapInProgress: previene re-entradas concurrentes.
// - Fallback 5s SOLO si hydrationState == authOkProfileUnknown (Isar failure path).
// - Gate 4: ContextValidator.validate() es SÍNCRONO — no se usa await.
// ENTERPRISE NOTES:
// - MATRIZ DE ESTADOS CANÓNICOS:
//     S0 NoAuth:            fbUser == null → Routes.welcome
//     S1 AuthButNoProfile:  fbUser OK, sin perfil Isar o contexto incompleto
//                           → Routes.countryCity / Routes.profile
//     S2 ProfileOkNoAssets: perfil OK, 0 portafolios ACTIVE → Routes.createPortfolioStep1
//     S3 Ready:             perfil OK + ≥1 portafolio ACTIVE → WorkspaceShell
// - countActiveByUser(): O(log n) via Isar .count() — sin deserializar objetos.
// - Logging enmascarado: uid truncado a 4 chars, sin tokens ni verificationId.
// ============================================================================

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../data/datasources/local/registration_progress_ds.dart';
import '../../data/models/auth/registration_progress_model.dart';
import '../../domain/adapters/workspace_context_adapter.dart';
import '../../domain/entities/user/active_context.dart';
import '../../domain/entities/workspace/workspace_context.dart';
import '../../domain/entities/workspace/workspace_type.dart';
import '../../domain/services/workspace/context_validator.dart';
import '../../routes/app_pages.dart';
import '../../services/telemetry/telemetry_service.dart';
import '../auth/controllers/registration_controller.dart';
import '../workspace/workspace_config.dart';
import '../workspace/workspace_shell.dart';
import 'session_context_controller.dart';

class SplashBootstrapController extends GetxController {
  // ─── Guard de re-entrada ────────────────────────────────────────────────────
  // Previene llamadas concurrentes a bootstrap() (ej. doble addPostFrameCallback).
  // Se resetea automáticamente al finalizar (éxito o error) para que
  // Routes.home → HomeRouter → bootstrap() funcione en re-routing post-logout.
  bool _bootstrapInProgress = false;

  // ─── Entrypoint público ─────────────────────────────────────────────────────

  Future<void> bootstrap() async {
    if (_bootstrapInProgress) {
      _log('bootstrap() re-entry ignored (already in progress)');
      return;
    }
    _bootstrapInProgress = true;

    try {
      await _runGates();
    } catch (e, st) {
      // Fallback seguro ante cualquier excepción no manejada.
      _log('FATAL error in bootstrap, redirecting to welcome. err=$e');
      if (kDebugMode) debugPrint('[BOOT] stacktrace: $st');
      Get.offAllNamed(Routes.welcome);
    } finally {
      _bootstrapInProgress = false;
    }
  }

  // ─── Flujo de gates ─────────────────────────────────────────────────────────

  Future<void> _runGates() async {
    // ── Gate 1: Auth ──────────────────────────────────────────────────────────
    final fbUser = FirebaseAuth.instance.currentUser;
    if (fbUser == null) {
      _logGate('auth', Routes.welcome, reason: 'no_firebase_user');
      Get.offAllNamed(Routes.welcome);
      return;
    }
    // UID enmascarado: solo primeros 4 chars para logs seguros.
    final maskedUid =
        '${fbUser.uid.substring(0, fbUser.uid.length.clamp(0, 4))}***';
    _logGate('auth', 'pass', reason: 'uid=$maskedUid');

    // ── Guard: Registro en progreso ───────────────────────────────────────────
    // Si el usuario tiene un registro iniciado (step > 0), el wizard de registro
    // es la fuente de verdad. No ejecutar Gates 2-4 para evitar el loop.
    try {
      final progressDS = RegistrationProgressDS(DIContainer().isar);
      final regProgress = await progressDS.get('current');
      if (regProgress != null && regProgress.step > 0) {
        final resumeRoute = _routeForRegistrationStep(regProgress.step);
        _logGate('registration', resumeRoute,
            reason: 'in_progress_step=${regProgress.step}');
        Get.offAllNamed(resumeRoute);
        return;
      }
    } catch (e) {
      _log('registration progress check error (non-fatal): $e');
    }

    // ── Hidratación de sesión (state-driven, sin stream timeout) ─────────────
    final session = Get.find<SessionContextController>();

    // init() es idempotente (single-flight guard): seguro llamar siempre
    try {
      await session.init(fbUser.uid);
    } catch (e) {
      _log('session.init error (non-fatal): $e');
    }

    // Fallback: si Isar falló y hydrationState aún es desconocido, esperar máx 5s
    if (session.hydrationState.value == HydrationState.authOkProfileUnknown) {
      try {
        await session.hydrationState.stream
            .where((s) => s != HydrationState.authOkProfileUnknown)
            .first
            .timeout(const Duration(seconds: 5));
        _log('hydrationState resolved after fallback wait');
      } on TimeoutException {
        _log('hydrationState timeout (5s), proceeding with current state');
      }
    }

    // ── Gate 2: Profile ───────────────────────────────────────────────────────
    // Guard I1: fbUser != null → NEVER Routes.welcome
    final hydration = session.hydrationState.value;
    final user = session.user;

    if (hydration == HydrationState.authOkProfileEmpty ||
        (hydration == HydrationState.authOkProfileUnknown && user == null)) {
      // S1: Firebase user existe pero sin perfil en Isar.
      // Enviar a selección de país/ciudad para iniciar onboarding sin password.
      _logGate('profile', Routes.countryCity, reason: 'no_local_profile');
      Get.offAllNamed(Routes.countryCity);
      return;
    }

    if (user == null) {
      // Guard I1: fbUser != null → onboarding mínimo en lugar de welcome.
      _logGate('profile', Routes.countryCity,
          reason: 'user_null_fbUser_not_null');
      Get.offAllNamed(Routes.countryCity);
      return;
    }

    final ctx = user.activeContext;
    if (ctx == null || ctx.orgId.isEmpty) {
      // S1: Usuario Firebase existe pero contexto incompleto → seleccionar perfil.
      _logGate('profile', Routes.profile, reason: 'no_active_context');
      Get.offAllNamed(Routes.profile);
      return;
    }

    // Rol vacío ocurre cuando el usuario borra su último workspace.
    if (ctx.rol.isEmpty) {
      _logGate('profile', Routes.profile, reason: 'empty_rol');
      Get.offAllNamed(Routes.profile);
      return;
    }
    _logGate('profile', 'pass', reason: 'rol=${ctx.rol}');

    // ── Gate 3: Assets ────────────────────────────────────────────────────────
    try {
      // O(log n): Isar count() sin deserializar objetos.
      final activeCount =
          await DIContainer().portfolioLocal.countActiveByUser(user.uid);
      if (activeCount == 0) {
        _logGate('assets', Routes.createPortfolioStep1,
            reason: 'no_active_portfolios');
        Get.offAllNamed(Routes.createPortfolioStep1);
        return;
      }
      _logGate('assets', 'pass', reason: 'count=$activeCount');
    } catch (e) {
      // Non-blocking: error en gate de activos no bloquea el workspace.
      // El usuario llega al workspace y puede gestionar sus activos desde ahí.
      _logGate('assets', 'pass_on_error', reason: 'isar_error');
      _log('gate=assets error (non-blocking): $e');
    }

    // ── Gate 4: Workspace ─────────────────────────────────────────────────────
    _logGate('workspace', 'routing', reason: 'all_gates_passed');
    await _routeToWorkspace(ctx, session);
  }

  // ─── Workspace routing ──────────────────────────────────────────────────────
  //
  // Cadena de resolución (Fase 1):
  //   1. session.activeWorkspaceContext → ContextValidator → NavigationRegistry
  //   2. session.availableWorkspaceContexts (primer candidato válido por orgId)
  //   3. WorkspaceContextAdapter.fromLegacy (deriva WorkspaceContext de ActiveContext)
  //   4. workspaceFor() legacy (solo si WorkspaceType != unknown)
  //   Fallback final: Routes.profile (nunca welcome, nunca admin por defecto)

  Future<void> _routeToWorkspace(
    ActiveContext ctx,
    SessionContextController session,
  ) async {
    // ── Paso 1: activeWorkspaceContext canónico (Fase 1) ─────────────────────
    final activeWCtx = session.activeWorkspaceContext.value;
    if (activeWCtx != null) {
      final validation = ContextValidator.validate(
        context: activeWCtx,
        memberships: session.memberships,
      );
      if (validation.isValid) {
        final cfg = NavigationRegistry.configFor(
          activeWCtx.type,
          orgType: activeWCtx.orgType,
        );
        if (cfg != null) {
          _logGate('workspace', 'pass_active_ctx',
              reason: 'type=${activeWCtx.type.wireName}');
          Get.offAll(() => WorkspaceShell(config: cfg));
          return;
        }
        _log(
            'WARN gate=workspace NavigationRegistry null type=${activeWCtx.type.wireName}');
      } else {
        _log(
            'WARN gate=workspace activeWorkspaceContext invalid: ${validation.reasonCode}');
      }
    }

    // ── Paso 2: availableWorkspaceContexts (primer candidato válido) ──────────
    final available = session.availableWorkspaceContexts;
    if (available.isNotEmpty) {
      final candidate = available.firstWhere(
        (w) => w.orgId == ctx.orgId,
        orElse: () => available.first,
      );
      final validation = ContextValidator.validate(
        context: candidate,
        memberships: session.memberships,
      );
      if (validation.isValid) {
        final cfg = NavigationRegistry.configFor(
          candidate.type,
          orgType: candidate.orgType,
        );
        if (cfg != null) {
          _logGate('workspace', 'pass_available_fallback',
              reason: 'type=${candidate.type.wireName}');
          Get.offAll(() => WorkspaceShell(config: cfg));
          return;
        }
      } else {
        _log(
            'WARN gate=workspace available candidate invalid: ${validation.reasonCode}');
      }
    }

    // ── Paso 3: WorkspaceContext derivado de ActiveContext legacy ─────────────
    final legacyWCtx = _buildLegacyContext(ctx, session);
    if (legacyWCtx != null) {
      final validation = ContextValidator.validate(
        context: legacyWCtx,
        memberships: session.memberships,
      );
      if (validation.isValid) {
        final cfg = NavigationRegistry.configFor(
              legacyWCtx.type,
              orgType: legacyWCtx.orgType,
            ) ??
            workspaceFor(
              rol: ctx.rol,
              providerType: legacyWCtx.providerType,
              orgType: legacyWCtx.orgType,
            );
        _logGate('workspace', 'pass_legacy_ctx',
            reason: 'type=${legacyWCtx.type.wireName}');
        Get.offAll(() => WorkspaceShell(config: cfg));
        return;
      } else {
        _log(
            'WARN gate=workspace legacy ctx invalid: ${validation.reasonCode}');
      }
    }

    // ── Paso 4: workspaceFor() legacy (solo si WorkspaceType != unknown) ──────
    // WorkspaceType.unknown NUNCA abre un workspace por defecto.
    final workspaceType = WorkspaceContextAdapter.resolveType(
      normalizedRole: WorkspaceContextAdapter.normalizeRole(ctx.rol),
      normalizedProviderType:
          WorkspaceContextAdapter.normalizeProviderType(ctx.providerType),
    );
    if (workspaceType != WorkspaceType.unknown) {
      final orgType = await _resolveOrgType(ctx);
      final pt = _normalizeProviderType(ctx.providerType);
      _logGate('workspace', 'pass_workspaceFor_legacy',
          reason: 'rol=${ctx.rol} orgType=$orgType');
      final cfg = workspaceFor(rol: ctx.rol, providerType: pt, orgType: orgType);
      Get.offAll(() => WorkspaceShell(config: cfg));
      return;
    }

    // ── Fallback final: ruta segura (nunca welcome, nunca admin por defecto) ──
    _logGate('workspace', Routes.profile,
        reason: 'no_valid_context_resolved rol=${ctx.rol}');
    Get.offAllNamed(Routes.profile);
  }

  // ─── Workspace context helpers ───────────────────────────────────────────────

  /// Construye un [WorkspaceContext] transitorio derivado del [ActiveContext] legacy.
  /// Retorna null si el contexto no tiene datos mínimos (orgId + rol + uid).
  WorkspaceContext? _buildLegacyContext(
    ActiveContext ctx,
    SessionContextController session,
  ) {
    if (ctx.orgId.isEmpty || ctx.rol.isEmpty) return null;
    final uid = session.user?.uid;
    if (uid == null) return null;
    try {
      return WorkspaceContextAdapter.fromLegacy(
        orgId: ctx.orgId,
        orgName: ctx.orgName,
        roleCode: ctx.rol,
        membershipId: '${uid}_${ctx.orgId}',
        providerType: ctx.providerType,
        source: WorkspaceContextSource.derivedFromLegacy,
      );
    } catch (e) {
      _log('_buildLegacyContext error (non-fatal): $e');
      return null;
    }
  }

  /// Resuelve orgType desde el org repository, con fallback a RegistrationProgress.
  /// Retorna 'personal' como fallback seguro final.
  Future<String> _resolveOrgType(ActiveContext ctx) async {
    String orgType = '';
    String source = 'default';

    // Primary: org repository
    try {
      final org = await DIContainer().orgRepository.getOrg(ctx.orgId);
      orgType = _normalizeOrgType(org?.tipo);
      if (orgType.isNotEmpty) source = 'org';
    } catch (_) {}

    // Fallback: RegistrationController o RegistrationProgressDS
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

  /// Log estructurado con prefijo [BOOT]. Solo imprime en debug/profile.
  void _log(String msg) {
    if (kDebugMode || kProfileMode) {
      debugPrint('[BOOT] $msg');
    }
  }

  /// Envía un evento de gate a TelemetryService para observabilidad en producción.
  /// Separado de [_log] para que el backend de telemetría (Crashlytics/Sentry)
  /// pueda activarse independientemente del modo de build.
  ///
  /// Parámetros:
  /// - [gate]:   'auth' | 'profile' | 'assets' | 'workspace'
  /// - [result]: 'pass' | nombre de la ruta destino
  /// - [reason]: descripción corta del motivo
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
    } catch (_) {
      // Telemetría nunca bloquea el flujo de bootstrap.
    }
  }

  /// Mapea un step de registro al route canónico del siguiente paso a completar.
  ///
  /// NOTA: step 0 (registerUsername / flujo email+password) fue eliminado del
  /// onboarding principal. El default apunta a countryCity para que usuarios
  /// con un progress incompleto del flujo viejo inicien el onboarding moderno.
  String _routeForRegistrationStep(int step) {
    switch (step) {
      case 1:
        return Routes.registerEmail;
      case 2:
        return Routes.registerIdScan;
      case 3:
        return Routes.countryCity;
      case 4:
        return Routes.profile;
      case 5:
        return Routes.registerSummary;
      case 6:
        return Routes.registerSummary;
      // step 0 (legacy: registerUsername) → redirigir a onboarding moderno.
      default:
        return Routes.countryCity;
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

  String? _normalizeProviderType(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return raw.toLowerCase().trim();
  }
}
