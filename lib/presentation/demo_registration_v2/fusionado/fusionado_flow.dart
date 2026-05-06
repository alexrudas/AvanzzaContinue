// ============================================================================
// DEMO REGISTRATION V2 — FUSIONADO FLOW (TEMPORARY, SAFE TO DELETE)
//
// Variante experimental del registro. Versión corregida tras la auditoría
// que detectó el riesgo de abuso del RUNT/SIMIT temprano (anyone consultas
// gratis sin registrarse). El wow se mueve a Q5, post-commit de identidad.
//
// Pasos lógicos:
//   0 Q1 Phone + Terms              (reuso P1Welcome)
//   1 Q2 OTP                         (reuso P2Otp)
//   2 Q3 Intent + Relación inline    (NUEVO — cards expandibles con relación)
//   3 Q4 Tu negocio                  (reuso P5Business — captura identidad
//                                      Y dispara el commit final + nav)
//
// Routing:
//   - Q1 → Q2 → Q3 → Q4 → (commit) → workspace real.
//
// SUBMIT FINAL (1-tap, local-first):
//   El antiguo paso Q6 ("Mi espacio · Proveedor"), el wizard `/provider/
//   bootstrap` (3 pasos duplicados) y el gate bloqueante `EnsureUserProvisioned`
//   fueron eliminados. Hoy el botón "Ingresar a mi cuenta" de Q4 ejecuta:
//     (1) CompleteOnboardingUC — crea local org/user/portfolio (Isar+Firestore).
//     (2) Limpieza idempotente de intent + onboarding session.
//     (3) Dispara `BootstrapSyncController.start()` en BACKGROUND
//         (fire-and-forget) — único endpoint `POST /v1/bootstrap` que
//         orquesta server-side User+Workspace+Membership+(opcional)Provider
//         con idempotencia por authUid y retry 3× con backoff (0.5/1/2 s).
//     (4) `Get.offAllNamed` INMEDIATA al destino del resolver. El usuario
//         entra al workspace en <1s; el shell observa `BootstrapSyncController.
//         status` y muestra banner "Preparando tu cuenta…" sin bloquear.
//   `_isWorking` cubre solo los pasos 1–4 (commit + cleanup) — micro-delay
//   evitar doble-tap. La sincronización con backend NO es esperada por la UI.
//   En error de commit local, snackbar post-frame y reintento sobre el botón.
//
// Registro de activos:
//   - Q5 fue eliminado (era mock con _mockRuntDb hardcoded de 4 placas).
//     El VRC/RUNT/SIMIT real requiere orgId + portfolioId, que solo existen
//     post-CompleteOnboardingUC. Tras el commit, el resolver
//     ([onboarding_navigation_resolver.dart]) navega a `Routes.assetRegister`
//     con un `AssetRegistrationContext` tipado emitido por
//     [mapBootstrapToAssetRegistrationContext]. Owner/Admin de vehículos
//     caen ahí en el flujo de producción canónico (`AssetRegistrationPage`
//     + `VrcBatchController` + `PortfolioAssetLivePage`); inmueble/
//     maquinaria/equipo caen en `_NonVehiclePlaceholder` ("Próximamente"),
//     mismo dead-end que en producción legacy.
//
// Diferencias clave vs Demo 1:
//   - Lenguaje de acción ("¿Qué quieres hacer?" vs "¿Cuál es tu perfil?")
//   - Q3 captura intent + relación en una sola pantalla (Demo 1 lo hace en
//     P3 con scope inline; aquí es relación con activo específico)
//
// Borrar junto con `lib/presentation/demo_registration_v2/`.
// ============================================================================

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../data/datasources/local/registration_intent_ds.dart';
import '../../../data/sources/remote/bootstrap/unified_bootstrap_dtos.dart';
import '../../../domain/services/onboarding/onboarding_session_service.dart';
import '../../../domain/usecases/onboarding/complete_onboarding_uc.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/bootstrap/bootstrap_sync_controller.dart';
import '../../controllers/session_context_controller.dart';
import '../demo_state.dart';
import '../screens/p1_welcome.dart';
import '../screens/p2_otp.dart';
import '../screens/p5_business.dart';
import 'onboarding_commit_controller.dart';
import 'screens/q3_intent.dart';

class FusionadoFlow extends StatefulWidget {
  const FusionadoFlow({super.key});

  @override
  State<FusionadoFlow> createState() => _FusionadoFlowState();
}

class _FusionadoFlowState extends State<FusionadoFlow> {
  /// Loading agregado del submit final ("Ingresar a mi cuenta"). Cubre la
  /// secuencia COMPLETA: commit → ensureUserProvisioned → (provider
  /// bootstrap) → navegación. El botón se deshabilita mientras esté en
  /// `true` para impedir doble-tap. NO confundir con
  /// `_commitController.isCommitting`, que solo cubre el step 1.
  bool _isWorking = false;

  late final DemoRegistrationState _state;
  late final OnboardingCommitController _commitController;
  late final OnboardingSessionService _sessionService;
  Worker? _statusWorker;

  /// Debounce de persistencia. Cada notificación de `_state` reagenda este
  /// timer; solo el último cambio en la ventana llega a Isar. Evita
  /// hammering al mover sliders/inputs.
  Timer? _persistDebounce;
  static const _kPersistDebounce = Duration(milliseconds: 500);

  // Constantes de pasos lógicos del flujo fusionado.
  // Q6 (workspace mock) fue eliminado: era una pantalla intermedia que
  // mostraba "Aquí abriríamos tu espacio de trabajo real" antes de entrar
  // al workspace. Ahora Q4 es el último paso y su botón "Ingresar a mi
  // cuenta" dispara el commit + navegación directa.
  static const _stepQ1 = 0; // phone + terms
  static const _stepQ2 = 1; // OTP
  static const _stepQ3 = 2; // intent + relación inline
  static const _stepQ4 = 3; // identity (tu negocio) — submit final

  /// Pasos visibles para el indicador "Paso N de M". Q1..Q4 = 4.
  static const _visibleSteps = 4;

  @override
  void initState() {
    super.initState();
    _state = DemoRegistrationState();
    _state.addListener(_onStateChanged);
    _state.addListener(_onStateChangedForPersistence);

    // ── Wiring del commit final del onboarding (ítem 11 v3.1) ────────────
    final di = DIContainer();
    _sessionService = di.onboardingSessionService;
    _commitController = OnboardingCommitController(
      useCase: CompleteOnboardingUC(
        orgRepository: di.orgRepository,
        userRepository: di.userRepository,
        portfolioRepository: di.portfolioRepository,
      ),
    );

    // Re-render del flow cuando el status del controller cambie. P5Business
    // hoy recibe `isCommitting: _isWorking` (gate del orquestador), no el
    // status del controller — el `_statusWorker` queda como mecanismo
    // genérico de rebuild ante cualquier cambio del controller (idempotente).
    //
    // La navegación post-commit NO vive en este worker. Vive en
    // `_onTapIngresar` después de cada step: garantiza que
    // (1) la sesión persistida en Isar se borre, (2) el provider intent se
    // marque, y (3) el SessionContextController se rehidrate ANTES de que
    // `Get.offAllNamed` dispare un nuevo bootstrap. Sin este orden estricto,
    // `HomeRouter → bootstrap` corre con sesión vacía/UserModel ausente y
    // devuelve al usuario al inicio del flow.
    _statusWorker = ever(_commitController.status, (_) {
      if (mounted) setState(() {});
    });

    // Restauración: si hay un usuario autenticado y existe una sesión
    // previa válida (no expirada, no corrupta), aplicarla al state y
    // posicionar el wizard en `currentStep`. Si no hay sesión, el flow
    // arranca por defecto en Q1 (state.step = 0).
    _restorePersistedSessionIfAny();
  }

  @override
  void dispose() {
    _persistDebounce?.cancel();
    _statusWorker?.dispose();
    _commitController.onClose();
    _state.removeListener(_onStateChanged);
    _state.removeListener(_onStateChangedForPersistence);
    _state.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  /// Listener dedicado a persistencia. Se reagenda con cada notificación;
  /// solo el último cambio dentro de la ventana de debounce alcanza Isar.
  void _onStateChangedForPersistence() {
    _persistDebounce?.cancel();
    _persistDebounce = Timer(_kPersistDebounce, _persistSnapshot);
  }

  Future<void> _persistSnapshot() async {
    if (!mounted) return;
    // Aislamiento por usuario: sin uid de Firebase no hay sujeto al cual
    // ligar el snapshot. Q1 (phone + terms) es pre-auth y NO se persiste:
    // re-introducir el teléfono es trivial frente al riesgo de huérfanos.
    final uid = _resolveUserId();
    if (uid == null || uid.isEmpty) return;
    if (!_state.firebaseAuthenticated) return;
    await _sessionService.save(userId: uid, state: _state);
  }

  Future<void> _restorePersistedSessionIfAny() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;
    final restored = await _sessionService.restore(uid);
    if (!mounted || restored == null) return;
    // Aplicar el snapshot al state actual (en lugar de reemplazar la
    // instancia) preserva los listeners ya enganchados (`_onStateChanged`
    // y `_onStateChangedForPersistence`).
    _state.applyJson(restored.state.toJson());
    _state.goTo(restored.currentStep);
  }

  // ── Commit final ───────────────────────────────────────────────────────

  /// Resuelve el userId desde la sesión activa (preferido) o Firebase Auth
  /// (fallback). Retorna null si no hay sesión.
  String? _resolveUserId() {
    try {
      final session = Get.find<SessionContextController>();
      final uid = session.user?.uid;
      if (uid != null && uid.isNotEmpty) return uid;
    } catch (_) {
      // SessionContextController no registrado en GetX — caemos a Firebase.
    }
    return FirebaseAuth.instance.currentUser?.uid;
  }

  // ─── Helpers para provider bootstrap (uso post-gate) ────────────────────

  /// Compone E.164 a partir del dial code + número nacional. Limpia
  /// caracteres no numéricos. `null` si cualquiera está vacío.
  static String? _composePhoneE164({
    required String dialCode,
    required String national,
  }) {
    final dial = dialCode.replaceAll(RegExp(r'[^0-9]'), '');
    final num_ = national.replaceAll(RegExp(r'[^0-9]'), '');
    if (dial.isEmpty || num_.isEmpty) return null;
    return '+$dial$num_';
  }

  /// Mapea el `DemoAssetType` del mercado del proveedor al id raíz canónico
  /// del backend (`AssetClassCatalog`). `null` si no hay mercado.
  static List<String>? _providerAssetTypeIds(DemoAssetType? market) {
    if (market == null) return null;
    final id = switch (market) {
      DemoAssetType.vehiculo => 'vehicle',
      DemoAssetType.inmueble => 'real_estate',
      DemoAssetType.maquinaria => 'machinery',
      DemoAssetType.equipo => 'equipment',
      DemoAssetType.otro => 'other',
    };
    return <String>[id];
  }

  /// Lee `activeOrgId` del SSOT (SessionContextController). `null` si no
  /// está registrado o si el contexto no tiene org.
  String? _readOrgIdFromSession() {
    if (!Get.isRegistered<SessionContextController>()) return null;
    try {
      final s = Get.find<SessionContextController>();
      final id = s.user?.activeContext?.orgId;
      if (id == null || id.isEmpty) return null;
      return id;
    } catch (_) {
      return null;
    }
  }

  /// Defiere un snackbar al post-frame para evitar el crash
  /// "No Overlay widget found" cuando el árbol está en transición.
  void _showErrorPostFrame(String title, String body) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Get.snackbar(title, body, snackPosition: SnackPosition.BOTTOM);
    });
  }

  // ── Routing actions ───────────────────────────────────────────────────────

  void _next() => _state.next();
  void _back() => _state.back();

  /// Desde Q3: usuario seleccionó intención (con relación si era activo, o
  /// rol directo si era servicio). Avanza a Q4 Tu negocio para identity.
  void _onIntentSelected() => _state.goTo(_stepQ4);

  /// Submit final del onboarding (botón "Ingresar a mi cuenta" en Q4).
  ///
  /// Orquestador lineal "1-tap": ejecuta toda la secuencia con un único
  /// punto de entrada/salida y un único guard de loading (`_isWorking`)
  /// que cubre TODAS las etapas para impedir doble-tap durante cualquier
  /// step. El usuario ve un solo spinner del principio al fin.
  ///
  /// Secuencia (LOCAL-FIRST, orden invariante):
  ///   1. Guards: Firebase auth completa + uid resoluble.
  ///   2. CompleteOnboardingUC — crea LOCAL org/user/portfolio en
  ///      Isar+Firestore. Único paso "lento" del flujo (cientos de ms).
  ///   3. Limpieza idempotente del intent residual y OnboardingSession.
  ///   4. **Background sync** vía `BootstrapSyncController.start(payload)`:
  ///      `POST /v1/bootstrap` único, idempotente por authUid, con retry
  ///      3× backoff (0.5/1/2 s). Fire-and-forget — NO awaiteamos.
  ///   5. `Get.offAllNamed` INMEDIATO al destino del resolver puro. El
  ///      shell observa `BootstrapSyncController.status` y pinta banner
  ///      "Preparando tu cuenta…" sin bloquear navegación.
  ///
  /// Errores de commit local: snackbar post-frame, usuario reintenta.
  /// Errores de sync con backend: NO bloquean entrada — el banner del
  /// shell muestra "Reintentar" cuando el state machine cae en FAILED.
  Future<void> _onTapIngresar() async {
    if (_isWorking) return; // anti-doble-tap reentrante

    setState(() => _isWorking = true);
    try {
      _state.update(() {
        _state.configCompleted = true;
        _state.configSkipped = false;
      });

      // (1) Guards de auth.
      if (!_state.firebaseAuthenticated) {
        _showErrorPostFrame(
          'Falta verificar tu teléfono',
          'Vuelve atrás y completa la verificación SMS antes de continuar.',
        );
        return;
      }
      final uid = _resolveUserId();
      if (uid == null || uid.isEmpty) {
        _showErrorPostFrame(
          'Sesión expirada',
          'Tu sesión Firebase se perdió. Vuelve a iniciar el registro.',
        );
        return;
      }

      // (2) CompleteOnboardingUC.
      await _commitController.commit(userId: uid, state: _state);
      if (!_commitController.isSuccess) {
        _showErrorPostFrame(
          'No pudimos crear tu espacio',
          _commitController.lastError.value ??
              'Intenta de nuevo en unos segundos.',
        );
        return;
      }

      // (3) Limpieza defensiva. Hacerla ANTES del gate evita que el splash
      //     subsecuente reanude el flow ya completado o ruede al wizard.
      await RegistrationIntentDS().clear();
      await _sessionService.markCompletedAndClear(uid);

      // (3.5) **REHIDRATACIÓN FORZADA del SessionContextController**.
      //
      // Causa raíz que cierra el círculo vicioso del orgId vacío:
      //
      // - `CompleteOnboardingUC` acaba de escribir `UserModel` en Isar con
      //   `activeContext.orgId` poblado.
      // - `SessionContextController` tiene un watcher reactivo sobre
      //   `userRepository.watchUser(uid)` que EVENTUALMENTE recibe ese
      //   cambio, pero la latencia del stream de Isar (variable, decenas
      //   a cientos de ms) es mayor que el tiempo entre este punto y el
      //   `Get.offAllNamed` que sigue.
      // - Si navegamos sin esperar la rehidratación, la siguiente página
      //   (asset_registration / vrc_batch / portfolio_asset_live) llama
      //   a `_resolveOrgId()` que lee `session.user.activeContext.orgId`
      //   y obtiene `""` (el user pre-commit, sin activeContext).
      // - Resultado conocido: activos persistidos con `orgId=""`,
      //   `assetsCount=0` al reabrir la app, redirects a `Routes.countryCity`
      //   en `asset_registration_controller`, sync con Core API roto.
      //
      // Fix: `resetForLogout()` cancela los watchers stale + limpia el
      // `_user.value` pre-commit; `init(uid)` re-lee Isar SÍNCRONAMENTE
      // y publica el UserModel actualizado con `activeContext.orgId`. La
      // navegación que sigue ya encuentra `session.user.activeContext.orgId`
      // poblado.
      //
      // No hace HTTP. Toma decenas de ms (lectura local de Isar). Single-flight
      // garantizado por el propio `init`.
      if (Get.isRegistered<SessionContextController>()) {
        try {
          final session = Get.find<SessionContextController>();
          session.resetForLogout();
          await session.init(uid);
          if (kDebugMode) {
            final orgId = session.user?.activeContext?.orgId;
            debugPrint(
                '[FusionadoFlow] session rehydrated — activeOrgId='
                '${(orgId == null || orgId.isEmpty) ? "(empty!)" : orgId}');
          }
        } catch (e) {
          // No fatal: si la rehidratación falla, el splash subsiguiente
          // reintenta. Pero en ese caso el orgId puede llegar vacío al
          // primer registro de activo — visible en logs.
          debugPrint(
              '[FusionadoFlow] session rehydration error (non-fatal): $e');
        }
      }

      // (4) Disparar el bootstrap unificado en BACKGROUND (fire-and-forget).
      //     ARQUITECTURA LOCAL-FIRST: el usuario YA tiene workspace local
      //     (CompleteOnboardingUC creó org/user/portfolio en Isar+Firestore).
      //     El sync con Core API converge en background; el state machine
      //     del `BootstrapSyncController` muestra "Preparando tu cuenta…"
      //     en el shell sin bloquear la navegación.
      //
      //     UN SOLO endpoint: POST /v1/bootstrap orquesta server-side todas
      //     las creaciones (User+Workspace+Membership+Provider). Idempotente
      //     por `authUid` — reintentos siempre seguros.
      final localOrgId = _readOrgIdFromSession();
      final providerPayload = _state.role == DemoRoleCode.provider
          ? UnifiedBootstrapProviderDto(
              name: _state.fullNameOrCompany.trim(),
              phone: _composePhoneE164(
                dialCode: _state.countryDialCode,
                national: _state.phone,
              ),
              // Sin specialties en onboarding (activación progresiva).
              assetTypeIds: _providerAssetTypeIds(_state.providerMarket),
            )
          : null;
      final bootstrapPayload = UnifiedBootstrapRequestDto(
        orgId: localOrgId, // fallback dev — backend prioriza claim del JWT.
        provider: providerPayload,
      );
      // Fire-and-forget: NO awaiteamos. La UI navega ya y el banner del
      // shell observa `BootstrapSyncController.status`.
      unawaited(
        Get.find<BootstrapSyncController>().start(bootstrapPayload),
      );

      // (5) NAVEGACIÓN FORZADA — sin splash, sin resolver, sin condicional.
      //
      //     PROHIBIDO:
      //       · Routes.home (dispara SplashBootstrapController → puede
      //         redirigir a Routes.profile o Routes.countryCity por
      //         hydration race).
      //       · Routes.providerBootstrap (wizard legacy — debe estar muerto).
      //       · Cualquier resolver que pueda devolver ruta legacy.
      //
      //     OBLIGATORIO:
      //       · Provider → providerWorkspace{Articles|Services} DIRECTO.
      //       · Otros roles → decision.routeName del resolver (sus flujos
      //         legacy no son objeto de este fix; se auditan aparte).
      if (!mounted) return;
      final String targetRoute;
      Object? targetArgs;
      if (_state.role == DemoRoleCode.provider) {
        targetRoute = _state.providerOfferType ==
                DemoProviderOfferType.productos
            ? Routes.providerWorkspaceArticles
            : Routes.providerWorkspaceServices;
        targetArgs = null;
      } else {
        final decision = _commitController.lastNavigation.value;
        if (decision == null) return;
        targetRoute = decision.routeName;
        targetArgs = decision.arguments;
      }
      debugPrint(
          '[FusionadoFlow] event=BOOTSTRAP_NAVIGATION_TRIGGERED '
          'to=$targetRoute role=${_state.role?.name}');
      Get.offAllNamed(targetRoute, arguments: targetArgs);
    } catch (e, st) {
      debugPrint('[FusionadoFlow] onTapIngresar unexpected error: $e\n$st');
      _showErrorPostFrame(
        'Algo salió mal',
        'Intenta de nuevo. Si persiste, contacta soporte.',
      );
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  // ── Helpers de copy contextual para Q4 ────────────────────────────────────

  /// Título dinámico de Q4 que combina rol + tipo de activo/mercado.
  /// - Asset path (owner/admin): "Propietario de vehículos", etc.
  /// - Renter: "Arrendatario de vehículo" usando renterMarket
  /// - Broker: "Gestión inmobiliaria" / "Gestión de vehículos" usando brokerMarket
  /// - Service path: usa el rol genérico ("Proveedor", "Asesor comercial", etc.)
  static String _q4ContextualTitle(DemoRegistrationState s) {
    if (s.assetType != null && s.role != null) {
      return _assetSpecificRoleLabel(s.role!, s.assetType!);
    }
    // Renter: usa renterMarket para personalizar el title.
    if (s.role == DemoRoleCode.renter && s.renterMarket != null) {
      return 'Arrendatario de ${_marketSingular(s.renterMarket!)}';
    }
    // Broker: usa brokerMarket para personalizar el title del workspace.
    if (s.role == DemoRoleCode.broker && s.brokerMarket != null) {
      return switch (s.brokerMarket!) {
        DemoAssetType.inmueble => 'Gestión inmobiliaria',
        DemoAssetType.vehiculo => 'Gestión de vehículos',
        DemoAssetType.maquinaria => 'Gestión de maquinaria',
        DemoAssetType.equipo => 'Gestión de equipos',
        DemoAssetType.otro => 'Gestión de activos',
      };
    }
    // Fallback service path: rol genérico
    return switch (s.role) {
      DemoRoleCode.provider => 'Proveedor',
      DemoRoleCode.asesor => 'Asesor comercial',
      DemoRoleCode.insurer => 'Asegurador / Broker',
      DemoRoleCode.broker => 'Gestor de activos',
      DemoRoleCode.legal => 'Abogado / Firma legal',
      DemoRoleCode.renter => 'Arrendatario',
      _ => 'Mi negocio',
    };
  }

  /// Subtítulo de Q4 contextual al asset (si lo hay) o genérico.
  static String _q4ContextualSubtitle(DemoRegistrationState s) {
    if (s.assetType != null) {
      final asset = _assetSingular(s.assetType!);
      return 'Configura tu espacio de trabajo para registrar tu $asset.';
    }
    return 'Cuéntanos cómo opera tu negocio para conectarte con la red de '
        'Avanzza.';
  }

  /// Subtítulo FUERTE contextual — refuerza la identidad específica del usuario
  /// según rol + sub-rol/mercado/especialidad. Se renderiza con peso fuerte
  /// (titleMedium w700 primary) PEGADO al título principal (gap mínimo).
  ///
  /// Cobertura por rol:
  ///   - Owner/Admin → null (el title ya dice "Propietario de X")
  ///   - Renter → "Conductor de vehículo" / "Inquilino" / "Cliente de maquinaria" / "Cliente de equipo"
  ///   - Provider productos → "Especialista en productos para vehículos"
  ///   - Provider servicios → "Especialista en servicios para inmuebles"
  ///   - Asesor → "Especialista comercial en productos para vehículos"
  ///   - Insurer → "Corredor de seguros" / "Corredor inmobiliario" (outlier intencional)
  ///   - Legal → "Especialista en derecho civil/penal/civil y penal"
  static String? _q4StrongSubtitle(DemoRegistrationState s) {
    // Renter: combina sub-rol con mercado para personalización máxima.
    if (s.role == DemoRoleCode.renter &&
        s.renterSubrole != null &&
        s.renterMarket != null) {
      final mkt = _marketSingular(s.renterMarket!);
      return switch (s.renterSubrole!) {
        DemoRenterSubrole.conductor => 'Conductor de $mkt',
        DemoRenterSubrole.inquilino => 'Inquilino',
        DemoRenterSubrole.cliente => 'Cliente de $mkt',
      };
    }
    // Provider: oferta + mercado. Tono "Especialista en" refuerza
    // profesionalismo y diferencia de Asesor (que también vende productos
    // pero como vendedor independiente, no como negocio con inventario).
    if (s.role == DemoRoleCode.provider && s.providerMarket != null) {
      final mktPlural = _marketPlural(s.providerMarket!);
      return switch (s.providerOfferType) {
        DemoProviderOfferType.productos =>
          'Especialista en productos para $mktPlural',
        DemoProviderOfferType.servicios =>
          'Especialista en servicios para $mktPlural',
        null => null,
      };
    }
    // Asesor: mercado. "Especialista comercial" mantiene el matiz "comercial"
    // que diferencia del Provider (negocio con inventario) — el asesor es
    // vendedor profesional sin local físico fijo.
    if (s.role == DemoRoleCode.asesor && s.asesorMarket != null) {
      return 'Especialista comercial en productos para '
          '${_marketPlural(s.asesorMarket!)}';
    }
    // Broker: gestor/comercializador de activos (intermediación).
    // 2 dominios HOY: inmobiliario + vehículos.
    if (s.role == DemoRoleCode.broker && s.brokerMarket != null) {
      return switch (s.brokerMarket!) {
        DemoAssetType.inmueble => 'Corredor inmobiliario',
        DemoAssetType.vehiculo => 'Comercializador de vehículos',
        // Maquinaria + equipo en backlog. Si se reactivan, agregar copy aquí.
        DemoAssetType.maquinaria => 'Comercializador de maquinaria',
        DemoAssetType.equipo => 'Comercializador de equipos',
        DemoAssetType.otro => 'Gestor de activos',
      };
    }
    // Insurer: especialidad.
    // NOTA estratégica 2026-05: la card de Asegurador/Broker está REMOVIDA
    // de Q3 (modelo "Invisible Broker" para seguros — ver q3_intent.dart
    // Bloque 5). El case queda vivo en código pero inalcanzable hasta
    // reactivación tras Fase 0 con corredor de seguros real.
    if (s.role == DemoRoleCode.insurer && s.insurerSpecialty != null) {
      return switch (s.insurerSpecialty!) {
        DemoInsurerSpecialty.seguros => 'Corredor de seguros',
        DemoInsurerSpecialty.inmobiliario => 'Corredor inmobiliario',
      };
    }
    // Legal: especialidad.
    if (s.role == DemoRoleCode.legal && s.legalSpecialty != null) {
      return switch (s.legalSpecialty!) {
        DemoLegalSpecialty.civil => 'Especialista en derecho civil',
        DemoLegalSpecialty.penal => 'Especialista en derecho penal',
        DemoLegalSpecialty.ambas => 'Especialista en civil y penal',
      };
    }
    // Owner/Admin: el title ya es contextual (Propietario de vehículos), no
    // necesita strong subtitle adicional. Devolver null evita ruido.
    return null;
  }

  /// Combina rol con tipo de activo en plural. Ej: "Propietario de vehículos".
  static String _assetSpecificRoleLabel(
    DemoRoleCode role,
    DemoAssetType asset,
  ) {
    final assetPlural = _marketPlural(asset);
    return switch (role) {
      DemoRoleCode.owner => 'Propietario de $assetPlural',
      DemoRoleCode.assetAdmin => 'Administrador de $assetPlural',
      DemoRoleCode.renter => 'Arrendatario de $assetPlural',
      _ => 'Mi negocio',
    };
  }

  static String _assetSingular(DemoAssetType t) => _marketSingular(t);

  /// Singular gramatical del tipo de activo/mercado.
  static String _marketSingular(DemoAssetType t) => switch (t) {
        DemoAssetType.vehiculo => 'vehículo',
        DemoAssetType.inmueble => 'inmueble',
        DemoAssetType.maquinaria => 'maquinaria',
        DemoAssetType.equipo => 'equipo',
        DemoAssetType.otro => 'activo',
      };

  /// Plural gramatical del tipo de activo/mercado.
  /// Maquinaria es invariante (singular = plural).
  static String _marketPlural(DemoAssetType t) => switch (t) {
        DemoAssetType.vehiculo => 'vehículos',
        DemoAssetType.inmueble => 'inmuebles',
        DemoAssetType.maquinaria => 'maquinaria',
        DemoAssetType.equipo => 'equipos',
        DemoAssetType.otro => 'activos',
      };

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final child = _buildStep();

    return PopScope(
      canPop: _state.step == _stepQ1,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_state.step > _stepQ1) _state.back();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(_state.step),
          child: child,
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_state.step) {
      case _stepQ1:
        return P1Welcome(
          state: _state,
          onNext: _next,
          totalSteps: _visibleSteps,
        );
      case _stepQ2:
        return P2Otp(
          state: _state,
          onNext: _next,
          onBack: _back,
          totalSteps: _visibleSteps,
        );
      case _stepQ3:
        return Q3Intent(
          state: _state,
          onContinue: _onIntentSelected,
          onBack: _back,
        );
      case _stepQ4:
      default:
        // Q4 es el último paso. El botón "Ingresar a mi cuenta" dispara
        // el orquestador `_onTapIngresar` (1-tap): commit →
        // ensureUserProvisioned (gate) → provider bootstrap diferido →
        // navegación. `_isWorking` cubre toda la secuencia (no solo el
        // commit) para impedir doble-tap durante cualquier step.
        return P5Business(
          state: _state,
          onContinue: _onTapIngresar,
          onBack: () => _state.goTo(_stepQ3),
          // Demo 2 fusionado: sin eyebrow, título contextual con asset type,
          // subtítulo asset-aware. SIN onSkip — la identidad es commitment
          // obligatorio (sin nombre/ciudad/NIT no hay matching downstream).
          eyebrow: '',
          titleOverride: _q4ContextualTitle(_state),
          subtitleOverride: _q4ContextualSubtitle(_state),
          strongSubtitle: _q4StrongSubtitle(_state),
          totalSteps: _visibleSteps,
          submitLabel: 'Ingresar a mi cuenta',
          isCommitting: _isWorking,
        );
    }
  }
}
