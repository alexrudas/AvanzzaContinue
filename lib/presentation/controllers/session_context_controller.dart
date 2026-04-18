// ============================================================================
// lib/presentation/controllers/session_context_controller.dart
// QUÉ HACE:
// - Gestiona el estado de sesión del usuario autenticado (UserEntity + memberships).
// - Expone HydrationState como fuente de verdad para routing en bootstrap.
// - Hidratación atómica Isar-only (< 200ms, cero red) antes de iniciar streams.
// - Single-flight init: previene doble-init de Bootstrap + AuthStateObserver.
// QUÉ NO HACE:
// - No navega ni decide rutas (eso es responsabilidad de SplashBootstrapController).
// - No toca RuntService, RuntRepository, ni lógica de registro.
// PRINCIPIOS:
// - A2: emit null del watcher NO sobrescribe perfil hidratado desde Isar.
// - Isar falla → hydrationState=authOkProfileUnknown (nunca Empty por error).
// - authOkProfileEmpty SOLO si Isar respondió OK y UserModel no existe.
// ENTERPRISE NOTES:
// - _initUid / _initializedUid / _initFuture: guards del single-flight.
// - _streamsActive: true solo tras _doInit() completado exitosamente.
// ============================================================================

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../application/factories/product_access_context_factory.dart';
import '../../core/di/container.dart';
import '../../core/session/org_switch_exceptions.dart';
import '../../core/session/org_switch_state.dart';
import '../../core/network/connectivity_service.dart';
import '../../core/utils/workspace_normalizer.dart';
import '../../domain/adapters/workspace_context_adapter.dart';
import '../../domain/entities/user/active_context.dart';
import '../../domain/entities/user/membership_entity.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../domain/entities/workspace/workspace_context.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/value/product_access_context.dart';
import '../../data/datasources/local/isar_session_ds.dart';
import '../../data/models/user_session_model.dart';
import '../../routes/app_pages.dart';
import '../../services/telemetry/telemetry_service.dart';
import 'workspace_controller.dart';

enum HydrationState { authNone, authOkProfileUnknown, authOkProfileEmpty, authOkProfileReady }

/// SessionContextController
/// - Loads and observes the current user and memberships
/// - Updates activeContext both locally (Isar) and remotely (Firestore)
/// - Uses UserRepository which implements offline-first policies
class SessionContextController extends GetxController {
  final UserRepository userRepository;
  final ConnectivityService? _connectivity;

  SessionContextController({
    required this.userRepository,
    ConnectivityService? connectivity,
  }) : _connectivity = connectivity;

  final Rxn<UserEntity> _user = Rxn<UserEntity>();
  UserEntity? get user => _user.value;

  /// Estado reactivo del cambio de organización activa.
  ///
  /// Delegado al [OrgSwitchStateHolder] singleton — el mismo estado que
  /// observa [OrgSwitchInterceptor] en CoreApiClient.
  /// La UI puede observar este valor con Obx() para mostrar indicadores de
  /// switching/failed sin polling.
  Rx<OrgSwitchState> get orgSwitchState => OrgSwitchStateHolder().state;

  final RxList<MembershipEntity> _memberships = <MembershipEntity>[].obs;
  List<MembershipEntity> get memberships => _memberships;

  // MERGE: version bump para invalidar Drawer cuando lista es mutada internamente
  final RxInt membershipsVersion = 0.obs;

  // ─── Fase 1: Workspace context canónico ─────────────────────────────────────

  /// Contexto de workspace activo en la sesión UX.
  /// Reconstruido en cada hidratación desde user.activeContext + memberships.
  /// null = sin sesión autenticada o contexto aún no resuelto.
  final Rxn<WorkspaceContext> activeWorkspaceContext = Rxn<WorkspaceContext>();

  /// Lista de todos los WorkspaceContexts disponibles para el usuario.
  /// Reconstruida desde memberships activas en cada hidratación.
  final RxList<WorkspaceContext> availableWorkspaceContexts =
      <WorkspaceContext>[].obs;

  /// Alias para activeWorkspaceContext.value (shorthand para ContextSwitchService).
  WorkspaceContext? get current => activeWorkspaceContext.value;

  // Anti-race lock para eliminación de workspace
  bool _isRemovingWorkspace = false;

  // C-2: guard contra switches concurrentes. Seteado síncronamente al inicio de
  // switchOrganization() — antes del primer await — para que no haya gap de interleave.
  bool _switchInProgress = false;

  /// Último error tipado de org switch.
  ///
  /// Publicado ANTES de relanzar en [switchOrganization()] — canal secundario de error.
  /// Reseteado a null al inicio de cada nuevo intento, antes del primer await.
  ///
  /// Complementa la excepción tipada: callers que no hacen try/catch pueden observar
  /// este valor con ever() o Obx() y mostrar feedback al usuario sin depender solo
  /// de [orgSwitchState] (que no distingue entre éxito y persistenceFailed).
  ///
  /// Patrón de uso:
  ///   ever(session.lastSwitchError, (e) { if (e != null) showErrorSnackbar(e); })
  final Rxn<SwitchOrganizationException> lastSwitchError = Rxn();

  /// Snapshot de acceso a producto para la sesión activa.
  /// null = sin sesión autenticada (deslogueado o userId aún no disponible).
  /// Reconstruido por [_rebuildAccessContext] ante cualquier cambio relevante.
  final Rx<ProductAccessContext?> accessContext = Rx<ProductAccessContext?>(null);

  // Exponer Rx para reactividad en otros controladores
  Rxn<UserEntity> get userRx => _user;
  RxList<MembershipEntity> get membershipsRx => _memberships;

  StreamSubscription<UserEntity?>? _userSub;
  StreamSubscription<List<MembershipEntity>>? _mbrSub;
  StreamSubscription<bool>? _connectivitySub;

  // Hydration state: source of truth for bootstrap routing
  final Rx<HydrationState> hydrationState = Rx<HydrationState>(HydrationState.authNone);

  // Single-flight init guards (prevents double-init race from Bootstrap + AuthStateObserver)
  String? _initUid;
  String? _initializedUid;
  Future<void>? _initFuture;
  bool _streamsActive = false;

  Future<void> init(String uid) async {
    // Single-flight: si ya estamos inicializando este uid, esperar mismo future
    if (_initUid == uid && _initFuture != null) {
      debugPrint('[SessionContext] init($uid) single-flight: awaiting in-progress future');
      return _initFuture!;
    }
    // Si ya está completamente inicializado para este uid, no hacer nada
    if (_initializedUid == uid && _streamsActive) {
      debugPrint('[SessionContext] init($uid) ya inicializado, skipping');
      return;
    }
    _initUid = uid;
    _initFuture = _doInit(uid);
    try {
      await _initFuture!;
    } finally {
      _initFuture = null;
    }
  }

  Future<void> _doInit(String uid) async {
    debugPrint('[SessionContext] _doInit uid=$uid');
    _userSub?.cancel();
    _mbrSub?.cancel();
    _connectivitySub?.cancel();
    _connectivitySub = null;
    _streamsActive = false;

    // Marcar perfil como desconocido hasta completar hidratación
    hydrationState.value = HydrationState.authOkProfileUnknown;

    // ATOMIC HYDRATION: Isar-only, zero network, < 200ms
    // T2: Isar error → queda Unknown; Empty SOLO si Isar OK y modelo no existe.
    try {
      final localUser = await _getLocalUserOnly(uid);
      if (localUser != null) {
        _user.value = localUser;
        hydrationState.value = HydrationState.authOkProfileReady;
        debugPrint('[SessionContext] Hydration: perfil local encontrado → authOkProfileReady');
        // Zero Trust: validar en background que el contexto Isar sea coherente
        // con los claims JWT actuales. Bloquea escrituras hasta completar.
        _startContextValidation(uid);
      } else {
        hydrationState.value = HydrationState.authOkProfileEmpty;
        debugPrint('[SessionContext] Hydration: sin perfil local → authOkProfileEmpty');
      }
    } catch (e) {
      // Isar inaccesible: mantener Unknown; bootstrap rutea S1 conservador.
      debugPrint('[SessionContext] Hydration: Isar error → authOkProfileUnknown ($e)');
    }

    // Iniciar streams para observar cambios en tiempo real
    _userSub = userRepository.watchUser(uid).listen((u) {
      // T1/A2: null emit NO sobrescribe perfil ya hidratado desde Isar.
      if (u == null) {
        debugPrint('[SessionContext] watchUser: null emit ignorado (hydrationState=${hydrationState.value})');
        return;
      }
      _user.value = u;
      hydrationState.value = HydrationState.authOkProfileReady;
      _rebuildAccessContext();
      // PERSISTIR: Guardar sesión actualizada en cache local
      _persistSession(uid);
    });

    _mbrSub = userRepository.watchMemberships(uid).listen((list) {
      _memberships.assignAll(list);
      membershipsVersion.value++; // fuerza re-render dependientes
      _rebuildAccessContext();
      // Sync workspaces to WorkspaceController
      _syncWorkspacesToController();
    });

    // Suscribir a cambios de conectividad para invalidar el snapshot.
    _connectivitySub = _connectivity?.online$.listen((_) {
      _rebuildAccessContext();
    });

    _initializedUid = uid;
    _streamsActive = true;
    debugPrint('[SessionContext] Streams iniciados correctamente');
  }

  // T2: NO atrapa excepción — lanza para que _doInit distinga Empty vs Unknown.
  Future<UserEntity?> _getLocalUserOnly(String uid) async {
    if (!DIContainer().isar.isOpen) throw StateError('Isar not open');
    final model = await DIContainer().userLocal.getUser(uid);
    return model?.toEntity();
  }

  /// Persistir sesión actual en Isar para acceso offline
  Future<void> _persistSession(String uid) async {
    try {
      if (!DIContainer().isar.isOpen) return;

      final isarSession = IsarSessionDS(DIContainer().isar);
      final session = UserSessionModel()
        ..uid = uid
        ..lastLoginAt = DateTime.now().toUtc();

      await isarSession.saveSession(session);
      debugPrint('[SessionContext] Sesión persistida en cache local');
    } catch (e) {
      debugPrint('[SessionContext] Error al persistir sesión: $e');
    }
  }

  /// Syncs current memberships/roles to WorkspaceController (legacy)
  /// y reconstruye los WorkspaceContext canónicos (Fase 1).
  Future<void> _syncWorkspacesToController() async {
    // Reconstruir contextos canónicos (Fase 1)
    _rebuildWorkspaceContexts();

    if (!Get.isRegistered<WorkspaceController>()) return;

    try {
      final workspaceController = Get.find<WorkspaceController>();

      // Extract all active roles from memberships (estatus normalizado)
      final roles = _memberships
          .where((m) => m.estatus.trim().toLowerCase() == 'activo')
          .expand((m) => m.roles)
          .toList();

      // Sync to WorkspaceController (uses WorkspaceNormalizer internally)
      await workspaceController.syncFromMemberships(roles);

      // Update active workspace if exists
      final activeRole = user?.activeContext?.rol;
      if (activeRole != null && activeRole.isNotEmpty) {
        await workspaceController.setActiveWorkspace(
          activeRole,
          source: 'auth',
        );
      }
    } catch (e) {
      debugPrint('[SessionContext] Error syncing workspaces: $e');
    }
  }

  /// Reconstruye [availableWorkspaceContexts] y [activeWorkspaceContext]
  /// desde las memberships activas y el activeContext legacy.
  ///
  /// Llamado en cada cambio de memberships o de user.activeContext.
  /// No navega ni persiste — solo actualiza el estado reactivo en memoria.
  void _rebuildWorkspaceContexts() {
    final u = user;
    if (u == null) {
      availableWorkspaceContexts.clear();
      activeWorkspaceContext.value = null;
      return;
    }

    // Reconstruir lista completa desde memberships activas
    final ctx = u.activeContext;
    final providerType = ctx?.providerType;

    final all = WorkspaceContextAdapter.fromMemberships(
      memberships: _memberships,
      providerType: providerType,
    );
    availableWorkspaceContexts.assignAll(all);

    // Resolver el activo desde activeContext legacy
    if (ctx != null && ctx.orgId.isNotEmpty && ctx.rol.isNotEmpty) {
      final membershipId = '${u.uid}_${ctx.orgId}';
      final active = WorkspaceContextAdapter.fromLegacy(
        orgId: ctx.orgId,
        orgName: ctx.orgName,
        roleCode: ctx.rol,
        membershipId: membershipId,
        providerType: ctx.providerType,
        source: WorkspaceContextSource.derivedFromLegacy,
      );
      activeWorkspaceContext.value = active;
    } else {
      activeWorkspaceContext.value = null;
    }
  }

  /// Actualiza el contexto activo del usuario para cambios de workspace DENTRO
  /// de la misma organización (cambio de rol, providerType, etc.).
  ///
  /// M-2 HARD THROW: lanza [StateError] si [ctx.orgId] difiere del orgId actual.
  /// Para cambiar de organización usa [switchOrganization], que ejecuta la
  /// secuencia completa de backend + JWT sync antes de persistir.
  ///
  /// CASOS VÁLIDOS para esta API:
  /// - Cambio de workspace role dentro de la misma org.
  /// - Actualización de providerType/categories dentro de la misma org.
  /// - Setup inicial de contexto cuando no hay org activa aún (currentOrgId vacío).
  Future<void> setActiveContext(ActiveContext ctx) async {
    // M-2: hard throw — org change requires switchOrganization().
    // El throw protege contra rutas laterales que cambiarían tenancy sin JWT sync.
    // Callers legítimos que cambian orgId deben usar switchOrganization().
    // Callers internos validados usan _setActiveContextInternal() directamente.
    final currentOrgId = user?.activeContext?.orgId ?? '';
    if (currentOrgId.isNotEmpty && ctx.orgId.isNotEmpty && ctx.orgId != currentOrgId) {
      throw StateError(
        'setActiveContext: cannot change orgId ($currentOrgId → ${ctx.orgId}) '
        'without JWT sync. Use switchOrganization() instead.',
      );
    }
    await _setActiveContextInternal(ctx);
  }

  /// Implementación interna de persistencia de contexto activo.
  ///
  /// NO tiene guard de orgId — llamar solo desde rutas que ya garantizan
  /// que el cambio de org fue validado (JWT claims, backend confirmado) o
  /// que son same-org por diseño:
  /// - [_applyValidatedContext]: post-switch validado contra JWT claims.
  /// - [appendWorkspaceToActiveOrg]: mismo-org por diseño (busca membership activo).
  /// - [removeWorkspaceFromActiveOrg] rol-clear: mismo-org (copyWith preserva orgId).
  /// - [setActiveContextFromLegacyBridge]: bridge transicional Type C.
  Future<void> _setActiveContextInternal(ActiveContext ctx) async {
    final uid = user?.uid;
    if (uid == null) return;
    // Repository will persist to Isar and mirror to Firestore (write-through)
    await userRepository.updateActiveContext(uid, ctx);
    // Local observable update (optimistic)
    final current = user;
    if (current != null) {
      _user.value = current.copyWith(
          activeContext: ctx, updatedAt: DateTime.now().toUtc());
      _user.refresh();
    }
  }

  /// API exclusiva para [LegacyActiveContextBridgeImpl].
  ///
  /// El bridge traduce WorkspaceContext → ActiveContext legacy. Es llamado
  /// únicamente por [ContextSwitchService.switchTo()], que ya validó el
  /// contexto objetivo contra memberships antes de invocar el bridge.
  /// [ContextSwitchService] actualmente no tiene callers externos de producción
  /// (verificado con grep 2026-04), por lo que esta ruta no ejecuta hoy.
  ///
  /// Usa [_setActiveContextInternal] — no dispara el hard throw de [setActiveContext].
  /// Documentado explícitamente para que cualquier nuevo caller tenga evidencia
  /// de por qué no usa [setActiveContext] directamente.
  ///
  /// Cuando el sistema opere 100% sobre WorkspaceContext (sin legacy ActiveContext),
  /// este método y [LegacyActiveContextBridgeImpl] deben eliminarse juntos.
  Future<void> setActiveContextFromLegacyBridge(ActiveContext ctx) async {
    // TRIP WIRE — vigilancia del bypass Type C.
    //
    // Este bridge está justificado SOLO mientras ContextSwitchService.switchTo()
    // tenga CERO callers externos de producción (verificado con grep 2026-04).
    // Si alguien añade un caller real a ContextSwitchService y ese caller cruza org,
    // este guard lo detecta antes de ejecutar el bypass sin JWT sync.
    //
    // En debug: assert(false) explota inmediatamente — el desarrollador lo ve en tests.
    // En release: log crítico + return — no ejecuta el bypass cross-org, no rompe producción.
    // Si dispara: revisar qué caller originó el switchTo() y migrar a switchOrganization().
    final currentOrgId = user?.activeContext?.orgId ?? '';
    if (currentOrgId.isNotEmpty && ctx.orgId.isNotEmpty && ctx.orgId != currentOrgId) {
      assert(
        false,
        '[SessionContext] setActiveContextFromLegacyBridge TRIP WIRE: '
        'cross-org switch detectado ($currentOrgId → ${ctx.orgId}). '
        'El bridge Type C no está justificado para cross-org. '
        'Migrar a switchOrganization().',
      );
      debugPrint(
        '[SessionContext][CRITICAL] setActiveContextFromLegacyBridge: '
        'cross-org detectado ($currentOrgId → ${ctx.orgId}) — abortando. '
        'Reportar bug: este path no debe ejecutar en producción.',
      );
      return;
    }
    debugPrint(
      '[SessionContext] setActiveContextFromLegacyBridge: '
      'orgId=${ctx.orgId} rol=${ctx.rol} (bridge transicional Type C)',
    );
    await _setActiveContextInternal(ctx);
  }

  // ---------------------------------------------------------------------------
  // ORG SWITCH — Flujo remoto + JWT refresh + rehidratación de sesión
  // ---------------------------------------------------------------------------

  /// Cambia la organización activa del usuario con Zero Trust.
  ///
  /// Secuencia completa:
  ///   1. Llama Firebase backend switchActiveOrganization.
  ///   2. Valida claims frescos contra orgId confirmado.
  ///   3. Resuelve orgName desde memberships locales.
  ///   4. Persiste y actualiza sesión en memoria.
  ///
  /// Estados de [orgSwitchState] durante y después del switch:
  ///   - Durante el proceso: `switching` → requests Core API bloqueados.
  ///   - En éxito: `idle`.
  ///   - En fallo de backend/claims (UC falla): `failed`, contexto previo intacto.
  ///     Persiste hasta el próximo intento de switch.
  ///   - En fallo de persistencia local: `idle` (JWT claims son correctos;
  ///     startup validation repara la divergencia Isar/claims en el próximo arranque).
  ///   - En fallo `notAuthenticated` (sin uid): `idle` vía finally (switching fue seteado
  ///     por el controller antes del uid-check; el UC nunca corrió).
  ///
  /// CONTRATO DEL CALLER — CRÍTICO:
  /// Siempre envolver en try-catch. Hay dos canales de error complementarios:
  ///   1. La excepción [SwitchOrganizationException] (fiable en todos los casos).
  ///   2. [lastSwitchError] observable: publicado antes del rethrow — permite reaccionar
  ///      al error con ever() o Obx() aunque el caller no haga try-catch explícito.
  /// Observar solo [orgSwitchState] es insuficiente: termina en `idle` tanto en éxito
  /// como en fallo de persistencia.
  ///
  /// [organizationId]: org destino.
  /// [targetWorkspaceRole]: workspace role con el que entra a la nueva org (elección UX).
  ///
  /// Lanza [SwitchOrganizationException] con razón tipada en caso de fallo.
  Future<void> switchOrganization({
    required String organizationId,
    required String targetWorkspaceRole,
  }) async {
    // C-2: guard contra switches concurrentes.
    // Seteado antes del primer await — no hay gap de interleave en Dart single-thread.
    if (_switchInProgress) {
      throw const SwitchOrganizationException(
        'Switch already in progress — wait for current switch to complete',
        SwitchOrganizationFailureReason.unknown,
      );
    }
    _switchInProgress = true;
    lastSwitchError.value = null; // reset — nuevo intento limpio
    // Transición explícita a `switching` antes de cualquier await.
    // El controller es dueño de este estado — no depende de que el UC lo haga primero.
    // Garantiza que `failed` del switch anterior nunca sea observable durante el arranque
    // del nuevo intento, independientemente del orden interno del UC.
    // El UC también setea `switching` en su primera línea (idempotente, sin efecto aquí).
    OrgSwitchStateHolder().state.value = OrgSwitchState.switching;

    try {
      final uid = user?.uid;
      if (uid == null) {
        throw const SwitchOrganizationException(
          'No authenticated user',
          SwitchOrganizationFailureReason.notAuthenticated,
        );
      }

      final useCase = DIContainer().switchActiveOrganizationUc;
      final result = await useCase.execute(
        organizationId: organizationId,
        targetWorkspaceRole: targetWorkspaceRole,
        uid: uid,
      );

      // C-1: persistencia tipada — si falla, estado termina en idle pero la excepción
      // tipada se propaga. El caller DEBE hacer try-catch; no confiar solo en orgSwitchState.
      try {
        await _applyValidatedContext(result.newContext);
      } catch (e) {
        debugPrint(
          '[SessionContext] switchOrganization: persistence failed after '
          'successful backend switch (orgId=$organizationId): $e',
        );
        // Relanzar como excepción tipada con razón persistenceFailed.
        // El estado irá a idle en el finally — no a failed — porque JWT claims son correctos.
        throw SwitchOrganizationException(
          'Local persistence failed after backend switch confirmed: $e',
          SwitchOrganizationFailureReason.persistenceFailed,
        );
      }

      debugPrint('[SessionContext] switchOrganization completed → orgId=$organizationId');
    } on SwitchOrganizationException catch (e) {
      // F-3: publicar al observable ANTES de relanzar.
      // Callers que no hacen try/catch pueden observar lastSwitchError con ever() o Obx()
      // sin depender del estado de orgSwitchState.
      lastSwitchError.value = e;
      rethrow;
    } finally {
      // C-1: reset condicional — solo resetear a idle si el estado aún es `switching`.
      //
      // Por qué condicional y no siempre idle:
      // - Si el UC falló (backend/claims), ya seteó `failed` antes de lanzar.
      //   Preservar ese `failed` para que la UI pueda reaccionar al estado de error.
      // - Si el fallo fue en persistencia local, el UC completó y el estado sigue
      //   siendo `switching` → resetear a `idle` (JWT claims son válidos).
      // - Si el fallo fue `notAuthenticated`, el controller ya había seteado `switching`
      //   (línea explícita antes del try) → el finally lo resetea correctamente a `idle`.
      // - En éxito: el UC nunca setea `idle` (responsabilidad del controller) → `idle` aquí.
      if (OrgSwitchStateHolder().state.value == OrgSwitchState.switching) {
        OrgSwitchStateHolder().state.value = OrgSwitchState.idle;
      }
      // C-2: liberar flag de concurrent guard.
      _switchInProgress = false;
    }
  }

  /// Aplica un [ActiveContext] ya validado contra JWT claims.
  ///
  /// Idempotente: si el contexto en memoria ya es equivalente (mismo orgId + rol),
  /// no dispara escrituras ni notificaciones innecesarias.
  ///
  /// Uso exclusivo del flujo de org switch y startup validation.
  /// Para cambios de workspace dentro de la misma org, usar [setActiveContext].
  Future<void> _applyValidatedContext(ActiveContext ctx) async {
    final current = user?.activeContext;

    // Idempotency check: evitar escrituras/notificaciones si el contexto no cambió
    if (current?.orgId == ctx.orgId && current?.rol == ctx.rol) {
      debugPrint('[SessionContext] _applyValidatedContext: no-op (context unchanged)');
      return;
    }

    // Delegar a _setActiveContextInternal — el contexto ya fue validado contra JWT claims.
    // No pasa por setActiveContext() para no disparar el hard throw de M-2.
    await _setActiveContextInternal(ctx);
    debugPrint(
      '[SessionContext] _applyValidatedContext: applied orgId=${ctx.orgId} rol=${ctx.rol}',
    );
  }

  // ---------------------------------------------------------------------------
  // STARTUP CONTEXT VALIDATION — Zero Trust: Isar tentativo hasta validar claims
  // ---------------------------------------------------------------------------

  /// Valida en background que el contexto cargado desde Isar sea coherente
  /// con los claims JWT actuales.
  ///
  /// Zero Trust startup:
  /// - Marca [OrgSwitchState.validating] → [OrgSwitchInterceptor] bloquea escrituras.
  /// - Lecturas (GET) se permiten para no degradar UX de arranque.
  /// - Si claims y Isar divergen: corrige silenciosamente desde claims.
  /// - Si falla la validación: libera el lock (no bloquea al usuario por error).
  ///
  /// Fire-and-forget — no bloquea el arranque de la UI.
  void _startContextValidation(String uid) {
    OrgSwitchStateHolder().state.value = OrgSwitchState.validating;
    debugPrint('[SessionContext] Startup validation started');

    Future.microtask(() async {
      // C-3: snapshot del orgId local al inicio del microtask.
      // Si un switch concurrente modifica el contexto mientras la validación corre,
      // el guard posterior lo detecta y aborta la corrección para no sobrescribir
      // el contexto recién switchiado con datos stale de la validación.
      final snapshotOrgId = user?.activeContext?.orgId;

      try {
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser == null) {
          debugPrint('[SessionContext] Startup validation: no Firebase user — skipping');
          return;
        }

        // Usar token cacheado (sin force refresh) — no bloqueante ni costoso
        final idTokenResult = await firebaseUser.getIdTokenResult(false);
        final claims = idTokenResult.claims ?? {};
        final activeCtxClaims = claims['activeContext'] as Map<String, dynamic>?;
        final claimsOrgId = activeCtxClaims?['organizationId'] as String?;

        final localOrgId = user?.activeContext?.orgId;

        if (claimsOrgId == null || claimsOrgId.isEmpty) {
          // Sin org en claims — el usuario no ha seleccionado org aún; OK
          debugPrint('[SessionContext] Startup validation: no org in claims — OK');
          return;
        }

        if (localOrgId == claimsOrgId) {
          debugPrint('[SessionContext] Startup validation: context OK (orgId match)');
          return;
        }

        // Divergencia detectada — forzar refresh y corregir desde claims
        debugPrint(
          '[SessionContext] Startup validation: mismatch '
          '(local=$localOrgId, claims=$claimsOrgId) — correcting',
        );

        final freshResult = await firebaseUser.getIdTokenResult(true);
        final freshClaims = freshResult.claims ?? {};
        final freshActive = freshClaims['activeContext'] as Map<String, dynamic>?;
        final freshOrgId = freshActive?['organizationId'] as String?;

        if (freshOrgId != null && freshOrgId.isNotEmpty && freshOrgId != localOrgId) {
          final memberships = await userRepository.fetchMemberships(uid);
          final membership = memberships.firstWhereOrNull(
            (m) => m.orgId == freshOrgId,
          );

          if (membership != null) {
            // Preservar workspace rol si existe; si no, usar el primer rol disponible
            final preservedRol = user?.activeContext?.rol;
            final resolvedRol = (preservedRol != null && preservedRol.isNotEmpty)
                ? preservedRol
                : (membership.roles.firstOrNull ?? '');

            final correctedContext = ActiveContext(
              orgId: freshOrgId,
              orgName: membership.orgName,
              rol: resolvedRol,
            );

            // C-3: abort si el contexto cambió mientras la validación corría.
            // Un switch concurrente ya aplicó el contexto correcto — no sobrescribir.
            if (user?.activeContext?.orgId != snapshotOrgId) {
              debugPrint(
                '[SessionContext] Startup validation: context changed during validation '
                '(snapshot=$snapshotOrgId, current=${user?.activeContext?.orgId}) '
                '— aborting correction to avoid overwriting concurrent switch',
              );
              return;
            }

            await _applyValidatedContext(correctedContext);
            debugPrint('[SessionContext] Startup validation: context corrected from claims');
          } else {
            debugPrint(
              '[SessionContext] Startup validation: membership not found for '
              'claims orgId=$freshOrgId — keeping Isar context',
            );
          }
        }
      } catch (e) {
        // Non-fatal: un error en startup validation no debe bloquear al usuario
        debugPrint('[SessionContext] Startup validation error (non-fatal): $e');
      } finally {
        // Siempre liberar el lock — no dejar al usuario atrapado en validating
        if (OrgSwitchStateHolder().state.value == OrgSwitchState.validating) {
          OrgSwitchStateHolder().state.value = OrgSwitchState.idle;
          debugPrint('[SessionContext] Startup validation: lock released');
        }
      }
    });
  }

  // MERGE: fix append workspace - recargar memberships desde repo
  Future<void> reloadMembershipsFromRepo() async {
    final uid = user?.uid;
    if (uid == null) return;
    try {
      final all = await userRepository.fetchMemberships(uid);
      _memberships.assignAll(all);
      membershipsVersion.value++; // fuerza re-render dependientes
      _memberships.refresh(); // Force GetX reactive update
    } catch (e) {
      debugPrint('[SessionContext] Error reloading memberships: $e');
    }
  }

  /// Añade un nuevo workspace (rol) a la organización activa del usuario
  /// y actualiza el contexto activo para usar ese rol
  /// MERGE: fix append workspace - con refresh reactivo y telemetría
  Future<void> appendWorkspaceToActiveOrg({
    required String role,
    String? providerType,
  }) async {
    final u = user;
    if (u == null) return;

    // Buscar membership elegible:
    // 1. Membership de la organización activa
    // 2. Si no existe, tomar el primer membership con roles
    // 3. Si no existe, tomar el primer membership
    final m = _memberships.firstWhereOrNull(
          (x) => x.orgId == u.activeContext?.orgId,
        ) ??
        _memberships.firstWhereOrNull((x) => x.roles.isNotEmpty) ??
        _memberships.firstOrNull;

    if (m == null) return;

    // Normalizar el rol para evitar duplicados
    final normalizedRole = WorkspaceNormalizer.normalize(role);
    final normalizedRoles = m.roles.map(WorkspaceNormalizer.normalize).toSet();

    // MERGE: roles antes de la operación (para telemetría)
    final rolesBefore = List<String>.from(m.roles);

    // MERGE: Solo agregar si no existe ya (guardar ROL CANÓNICO)
    final isNoop = normalizedRoles.contains(normalizedRole);
    final mergedRoles = isNoop ? m.roles : [...m.roles, normalizedRole];

    // MERGE: si es no-op, loguear y salir
    if (isNoop) {
      _logTelemetry('profile_add_workspace_noop', {
        'uid': u.uid,
        'orgId': m.orgId,
        'role_attempted': role,
        'roles_existing': rolesBefore.join(','),
      });
      return;
    }

    try {
      // MERGE: actualizar con roles fusionados (repo normaliza internamente también)
      await userRepository.updateMembershipRoles(u.uid, m.orgId, mergedRoles);

      // Si es proveedor, actualizar perfil con arrayUnion
      if (_isProveedor(role) &&
          providerType != null &&
          providerType.isNotEmpty) {
        await userRepository.updateProviderProfile(
            u.uid, m.orgId, providerType);
      }

      // MERGE: recargar memberships para reflejar cambios
      await reloadMembershipsFromRepo();

      // Crear contexto activo con el nuevo rol
      final newContext = ActiveContext(
        orgId: m.orgId,
        orgName: m.orgName,
        rol: normalizedRole,
        providerType: _isProveedor(role) ? providerType : null,
      );

      // Actualizar contexto activo.
      // _setActiveContextInternal: appendWorkspaceToActiveOrg es mismo-org por diseño
      // (busca membership de la org activa primero). Si el fallback lleva a otra org,
      // es recuperación de inconsistencia de datos, no un user-initiated switch.
      await _setActiveContextInternal(newContext);

      // MERGE: telemetría de éxito
      _logTelemetry('profile_add_workspace_success', {
        'uid': u.uid,
        'orgId': m.orgId,
        'role_added': normalizedRole,
        'roles_before': rolesBefore.join(','),
        'roles_after': mergedRoles.join(','),
      });
    } catch (e) {
      // MERGE: telemetría de error
      _logTelemetry('profile_add_workspace_error', {
        'uid': u.uid,
        'orgId': m.orgId,
        'role_attempted': role,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  // MERGE: fix append workspace - helper para detectar roles de proveedor
  bool _isProveedor(String role) {
    return role.toLowerCase().contains('proveedor') ||
        role.toLowerCase().contains('provider');
  }

  // MERGE: fix append workspace - helper para telemetría
  void _logTelemetry(String event, Map<String, dynamic> extras) {
    try {
      if (Get.isRegistered<TelemetryService>()) {
        Get.find<TelemetryService>().log(event, extras);
      }
    } catch (e) {
      debugPrint('[SessionContext] Telemetry error: $e');
    }
  }

  // Elimina un workspace (rol) de la organización activa
  // - Firestore: arrayRemove
  // - Cache: recarga memberships
  // - Contexto: si el rol eliminado era el activo, ajustar al siguiente disponible o limpiar
  // - WorkspaceController: sincroniza cambios con source:'auth'
  Future<void> removeWorkspaceFromActiveOrg({required String role}) async {
    // Anti-race: si ya hay una eliminación en curso, salir
    if (_isRemovingWorkspace) {
      debugPrint('[SessionContext] Remove already in progress, skipping');
      return;
    }

    final u = user;
    final ctx = user?.activeContext;
    if (u == null || ctx == null || ctx.orgId.isEmpty) return;

    final normalized = WorkspaceNormalizer.normalize(role);
    final wasActive = WorkspaceNormalizer.areEqual(ctx.rol, role);

    _isRemovingWorkspace = true;

    try {
      final startTime = DateTime.now();

      await userRepository.removeRoleFromMembership(
        uid: u.uid,
        orgId: ctx.orgId,
        role: normalized,
      );

      // Recargar memberships (o confiar en stream y solo bump)
      await reloadMembershipsFromRepo();

      final latency = DateTime.now().difference(startTime).inMilliseconds;

      // Si borramos el rol activo, seleccionar siguiente con política determinística
      String? newActiveRole;
      String? selectionRule;

      if (wasActive) {
        final currentMembership = memberships.firstWhereOrNull(
          (m) => m.orgId == ctx.orgId,
        );

        if (currentMembership != null) {
          // Política: alfabético de la misma org → alfabético de otras orgs → vacío
          final sameOrgRoles = currentMembership.roles
              .where((r) => !WorkspaceNormalizer.areEqual(r, role))
              .toList();

          if (sameOrgRoles.isNotEmpty) {
            newActiveRole = WorkspaceNormalizer.findNextAlphabetic(
              sameOrgRoles,
            );
            selectionRule = 'same_org_alpha';
          } else {
            // Buscar en otras orgs
            final otherOrgRoles = memberships
                .where((m) => m.orgId != ctx.orgId && m.estatus.trim().toLowerCase() == 'activo')
                .expand((m) => m.roles)
                .toList();

            if (otherOrgRoles.isNotEmpty) {
              newActiveRole = WorkspaceNormalizer.findNextAlphabetic(
                otherOrgRoles,
              );
              selectionRule = 'other_org_alpha';
            }
          }
        }

        // Actualizar contexto
        if (newActiveRole != null && newActiveRole.isNotEmpty) {
          // Encontrar la org del nuevo rol
          final newOrgMembership = memberships.firstWhereOrNull(
            (m) => m.roles
                .any((r) => WorkspaceNormalizer.areEqual(r, newActiveRole!)),
          );

          if (newOrgMembership != null) {
            // Org switch real — el rol eliminado era el último en la org activa,
            // y el fallback es un rol en OTRA org. Debe pasar por switchOrganization()
            // para sincronizar backend (user_active_contexts) + JWT claims.
            try {
              await switchOrganization(
                organizationId: newOrgMembership.orgId,
                targetWorkspaceRole: newActiveRole,
              );
            } catch (e) {
              // Si el switch falla (red, backend), limpiar rol en org actual para
              // que el usuario pueda decidir su próximo workspace manualmente.
              debugPrint(
                '[SessionContext] removeWorkspace: fallback org switch failed — '
                'clearing role in current org: $e',
              );
              await _setActiveContextInternal(ctx.copyWith(rol: ''));
            }

            // Forzar navegación al nuevo workspace (cierra vista del eliminado)
            // HomeRouter redirigirá automáticamente al workspace correcto
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (Get.currentRoute != Routes.home) {
                Get.offAllNamed(Routes.home);
              }
            });
          }
        } else {
          // No hay roles en ninguna org — limpiar rol (mismo-org, orgId preservado).
          await _setActiveContextInternal(ctx.copyWith(rol: ''));
          selectionRule = 'empty';

          // Navegar a pantalla segura (sin workspaces)
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(Routes.home);
          });
        }

        _logTelemetry('workspace_switched_auto', {
          'from': normalized,
          'to': newActiveRole ?? '',
          'cause': 'deleted_active',
          'rule': selectionRule ?? 'none',
          'ctx': 'auth',
        });
      }

      membershipsVersion.value++;

      // Sincronizar con WorkspaceController
      await _syncWorkspacesToController();

      _logTelemetry('workspace_delete_success', {
        'orgId': ctx.orgId,
        'role': normalized,
        'wasActive': wasActive,
        'newActiveRole': newActiveRole,
        'rule': selectionRule,
        'latency_ms': latency,
        'ctx': 'auth',
      });
    } catch (e) {
      _logTelemetry('workspace_delete_error', {
        'orgId': ctx.orgId,
        'role': normalized,
        'error': e.toString(),
        'ctx': 'auth',
      });
      rethrow;
    } finally {
      _isRemovingWorkspace = false;
    }
  }

  /// Reconstruye [accessContext] con el estado actual de sesión y conectividad.
  ///
  /// Reglas:
  /// - Si [user?.uid] es null → [accessContext] = null (sin sesión).
  /// - membershipScope: del membership activo (por orgId). Fallback: [MembershipScope()].
  /// - organizationContract: no cargado en este controller → fallback via factory.
  /// - isOnline: del [_connectivity] real. Fallback: false (offline-safe).
  void _rebuildAccessContext() {
    final uid = user?.uid;

    if (uid == null || uid.isEmpty) {
      accessContext.value = null;
      return;
    }

    final orgId = user?.activeContext?.orgId ?? '';

    final roles = _memberships
        .where((m) => m.estatus.trim().toLowerCase() == 'activo')
        .expand((m) => m.roles)
        .toSet();

    final activeMembership = _memberships.firstWhereOrNull(
      (m) => m.orgId == orgId,
    );

    accessContext.value = ProductAccessContextFactory.build(
      userId: uid,
      orgId: orgId,
      roles: roles,
      scope: activeMembership?.scope,
      contract: null, // No org contract in this controller — factory uses defaultRestricted()
      isOnline: _connectivity?.isOnline ?? false,
    );
  }

  /// Limpia el estado de sesión al hacer logout sin remover el controller del DI.
  /// Usar en lugar de onClose() cuando el controller es permanent: true.
  void resetForLogout() {
    _userSub?.cancel();
    _mbrSub?.cancel();
    _connectivitySub?.cancel();
    _userSub = null;
    _mbrSub = null;
    _connectivitySub = null;
    _user.value = null;
    _memberships.clear();
    accessContext.value = null;
    membershipsVersion.value = 0;
    activeWorkspaceContext.value = null;
    availableWorkspaceContexts.clear();
    _isRemovingWorkspace = false;
    hydrationState.value = HydrationState.authNone;
    _initUid = null;
    _initializedUid = null;
    _initFuture = null;
    _streamsActive = false;
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _mbrSub?.cancel();
    _connectivitySub?.cancel();
    super.onClose();
  }
}
