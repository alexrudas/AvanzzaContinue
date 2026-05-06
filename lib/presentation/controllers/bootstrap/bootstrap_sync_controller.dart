// ============================================================================
// lib/presentation/controllers/bootstrap/bootstrap_sync_controller.dart
// BOOTSTRAP SYNC CONTROLLER V2.1 — production-grade, deuda cero.
//
// QUÉ HACE:
//   Orquesta `POST /v1/bootstrap` en background tras "Ingresar a mi cuenta",
//   con state machine PERSISTIDO en Isar (sobrevive a kills, hot restarts y
//   app resumes), retry exponencial acotado, retry programado interno
//   (no depende solo de lifecycle externo), y logging estructurado.
//
// STATE MACHINE (espejo Rx + Isar):
//   IDLE → PENDING_SYNC → SYNCING → SYNCED        (terminal)
//                              ↘ FAILED            (retryable o terminal)
//
//   Reglas:
//     · `synced` es terminal: ningún `start()/retry()/lifecycle/timer` lo abandona.
//     · `syncing` jamás cuelga: en `onInit`, una fila persistida en `syncing`
//        se trata como `failed` (proceso muerto durante request).
//     · **SINGLE WRITE POR TRANSICIÓN**: `_persistTransition` se llama una
//        sola vez por cada cambio de estado válido, agrupando todos los
//        campos relacionados (status + attempts + lastAttemptAt + flags +
//        payloadJson) en un único upsert atómico de Isar.
//
// RETRY:
//   [0s, 2s, 10s, 30s, 120s] — máx 5 intentos.
//   Triggers:
//     · Iteración interna del while-loop dentro de `_run` (entre intentos
//        del mismo `_run`).
//     · `_scheduleRetryTimer(delay)` — Future.delayed que dispara `_run`
//        cuando el motor sale temprano (token refresh fail, max attempts
//        no alcanzado pero sin payload, etc.). Independiente de lifecycle.
//     · Lifecycle (resume, workspace enter) — siguen como triggers extra.
//
// PERSISTENCIA DEL PAYLOAD:
//   `UnifiedBootstrapRequestDto` se serializa a JSON y se guarda en
//   `BootstrapSyncStateModel.payloadJson`. Sobrevive a kills. En `onInit`
//   se rehidrata. Si la deserialización falla (corrupción), el payload se
//   trata como ausente y la fila queda en `failed` esperando un `start()`
//   con payload fresco.
//
// TOKEN REFRESH (CRÍTICO):
//   Si la API responde `requiresTokenRefresh=true`, antes del próximo intento
//   se invoca `getIdToken(forceRefresh: true)`. Si el refresh FALLA:
//     · NO se incrementa `attempts`.
//     · NO se transiciona estado.
//     · Se programa un timer al próximo backoff para reintentar.
//
// LIFECYCLE:
//   onInit:
//     · Suscribe a FirebaseAuth.authStateChanges → al obtener uid, hidrata.
//     · Suscribe a `WidgetsBinding.addObserver` (resume).
//   On uid:
//     · Carga fila + payloadJson de Isar; si null, deja `idle`.
//     · Si `pending|failed|syncing` → kick (syncing degradado a failed).
//   On AppLifecycleState.resumed:
//     · Si estado es retryable → `_kickIfRetryable()`.
//   onWorkspaceEnter (manual, vía `kickIfRetryable()`):
//     · Idéntico: pública API para que el shell la dispare en initState.
//
// IDEMPOTENCIA CLIENTE:
//   Antes de ejecutar `_run()`:
//     · `synced` → return (no-op).
//     · `_inFlight` → return (anti-reentrancia).
//
// PROVIDER READY GATE:
//   `isProviderReady` getter público que UI/lógica de proveedor consulta
//   antes de habilitar acciones críticas (crear cotización, responder PR,
//   replace specialties). NO bloquea navegación general.
//
// LOGGING:
//   Eventos estructurados via `_log({event, ...})`:
//     · BOOTSTRAP_START   — primer arranque o reanudación tras kill.
//     · BOOTSTRAP_SUCCESS — synced, con providerId/orgId/status del backend.
//     · BOOTSTRAP_FAILED  — terminal (max attempts o 4xx no recuperable).
//     · BOOTSTRAP_RETRY   — intento N de M agendado o disparado.
// ============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/models/bootstrap/bootstrap_sync_state_model.dart';
import '../../../data/sources/local/bootstrap/bootstrap_sync_state_local_ds.dart';
import '../../../data/sources/remote/bootstrap/bootstrap_api_client.dart';
import '../../../data/sources/remote/bootstrap/unified_bootstrap_dtos.dart';
import '../../../domain/errors/remote_exceptions.dart';

/// Estado canónico Rx del controller. Espejo de
/// `BootstrapSyncStatusModel` (Isar) y wire-stable porque puede aparecer
/// en logs/analytics.
enum BootstrapSyncStatus {
  idle,
  pendingSync,
  syncing,
  synced,
  failed,
}

class BootstrapSyncController extends GetxController
    with WidgetsBindingObserver {
  final BootstrapApiClient _api;
  final BootstrapSyncStateLocalDS _localDs;

  /// Backoff por intento ya consumido. Índice = `attempts` previo.
  static const List<Duration> _backoffSchedule = <Duration>[
    Duration.zero, // Intento 1: sin espera (primer tap).
    Duration(seconds: 2), // Intento 2.
    Duration(seconds: 10), // Intento 3.
    Duration(seconds: 30), // Intento 4.
    Duration(seconds: 120), // Intento 5.
  ];

  static const int _maxAttempts = 5;

  BootstrapSyncController({
    required BootstrapApiClient api,
    required BootstrapSyncStateLocalDS localDs,
  })  : _api = api,
        _localDs = localDs;

  // ─── Estado público (Rx) ────────────────────────────────────────────────

  final Rx<BootstrapSyncStatus> status =
      Rx<BootstrapSyncStatus>(BootstrapSyncStatus.idle);

  final RxnString lastError = RxnString();

  final Rxn<UnifiedBootstrapResultDto> lastResult =
      Rxn<UnifiedBootstrapResultDto>();

  /// Conteo público de intentos consumidos (espejo de Isar).
  final RxInt attempts = 0.obs;

  /// **Provider Ready Gate.**
  ///
  /// `true` cuando el sync terminó exitosamente Y el backend devolvió un
  /// `providerId`. La UI de proveedor (botones de "Crear cotización",
  /// "Responder PR", "Reemplazar especialidades", etc.) DEBE consultar
  /// este getter antes de habilitar acciones — sin él, el usuario podría
  /// operar como provider sin tener su `ProviderProfile` provisionado en
  /// Core API y los endpoints fallarían con 403.
  ///
  /// **No bloquea navegación general** — el shell sigue accesible.
  bool get isProviderReady {
    return status.value == BootstrapSyncStatus.synced &&
        (lastResult.value?.providerId != null);
  }

  // ─── Estado interno ─────────────────────────────────────────────────────

  /// Snapshot del último payload conocido. Se inicializa desde Isar en
  /// `_hydrateFromIsar` o desde un `start(payload)` reciente. El controller
  /// NO opera sin payload — sin él el retry queda inerte hasta que la UI
  /// llame a `start()` otra vez.
  UnifiedBootstrapRequestDto? _lastPayload;

  /// `uid` actual de Firebase. Se actualiza vía `authStateChanges`.
  String? _currentUid;

  /// Anti-reentrancia: solo un `_run()` activo a la vez.
  bool _inFlight = false;

  /// Timer del retry programado interno. Cancelable en cada transición
  /// terminal (`synced`, `failed` por max attempts) o logout.
  Timer? _scheduledRetry;

  StreamSubscription<User?>? _authSub;

  // ─── Lifecycle ──────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _authSub = FirebaseAuth.instance.authStateChanges().listen(_onAuthChanged);
    final initialUser = FirebaseAuth.instance.currentUser;
    if (initialUser != null) {
      unawaited(_onAuthChanged(initialUser));
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _scheduledRetry?.cancel();
    _scheduledRetry = null;
    _authSub?.cancel();
    _authSub = null;
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _kickIfRetryable();
    }
  }

  // ─── API pública ────────────────────────────────────────────────────────

  Future<void> start(UnifiedBootstrapRequestDto payload) async {
    _lastPayload = payload;

    final uid = _currentUid ?? FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      _log(event: 'BOOTSTRAP_DEFER', reason: 'no_firebase_uid');
      return;
    }

    if (status.value == BootstrapSyncStatus.synced) {
      _log(event: 'BOOTSTRAP_NOOP', userId: uid, reason: 'already_synced');
      return;
    }
    if (_inFlight) {
      _log(event: 'BOOTSTRAP_NOOP', userId: uid, reason: 'in_flight');
      return;
    }

    // Persiste payload + transición a pendingSync en UN solo write.
    // Si veníamos de idle, esto crea la fila; si veníamos de failed,
    // esto la actualiza limpiando el error y persistiendo el payload
    // recién provisto (puede haber cambiado entre intentos).
    final payloadJson = jsonEncode(payload.toJson());
    if (status.value != BootstrapSyncStatus.pendingSync) {
      await _persistTransition(
        uid: uid,
        next: BootstrapSyncStatusModel.pendingSync,
        payloadJson: payloadJson,
        clearError: true,
      );
      status.value = BootstrapSyncStatus.pendingSync;
    } else {
      // Ya en pending — solo actualizar el payloadJson sin transición.
      // (Mantiene "single write per transition": esto NO es transición.)
      await _localDs.upsert(userId: uid, payloadJson: payloadJson);
    }

    _log(event: 'BOOTSTRAP_START', userId: uid, attempt: attempts.value);
    await _run(uid);
  }

  Future<void> retry() async {
    if (_inFlight) return;
    if (status.value == BootstrapSyncStatus.synced) return;
    if (_currentUid == null || _lastPayload == null) {
      _log(event: 'BOOTSTRAP_RETRY_SKIP', reason: 'missing_uid_or_payload');
      return;
    }
    _log(event: 'BOOTSTRAP_RETRY', userId: _currentUid, attempt: attempts.value);
    await _run(_currentUid!);
  }

  /// Hook público para llamar desde el workspace shell en su `initState`.
  Future<void> kickIfRetryable() async {
    _kickIfRetryable();
  }

  /// Reset completo (logout). Borra fila Isar + estado en memoria + timer.
  Future<void> resetForLogout() async {
    final uid = _currentUid;
    _scheduledRetry?.cancel();
    _scheduledRetry = null;
    status.value = BootstrapSyncStatus.idle;
    lastError.value = null;
    lastResult.value = null;
    attempts.value = 0;
    _lastPayload = null;
    _inFlight = false;
    if (uid != null && uid.isNotEmpty) {
      await _localDs.deleteByUserId(uid);
    }
  }

  // ─── Internal: hidratación ──────────────────────────────────────────────

  Future<void> _onAuthChanged(User? user) async {
    final uid = user?.uid;
    if (uid == null || uid.isEmpty) {
      _currentUid = null;
      _scheduledRetry?.cancel();
      _scheduledRetry = null;
      return;
    }
    if (_currentUid == uid) return;
    _currentUid = uid;
    await _hydrateFromIsar(uid);
  }

  Future<void> _hydrateFromIsar(String uid) async {
    // Lectura con eviction de payload stale: si la fila lleva más de
    // `defaultPayloadTtl` sin transiciones, el `payloadJson` se descarta
    // (limpieza segura write-back). El controller hereda la fila ya
    // saneada y el caller no puede resucitar payloads obsoletos contra
    // el backend.
    final row = await _localDs.getByUserIdEvictingStalePayload(uid);
    if (row == null) {
      status.value = BootstrapSyncStatus.idle;
      lastError.value = null;
      lastResult.value = null;
      attempts.value = 0;
      _lastPayload = null;
      return;
    }

    // Rehidratar payload persistido (si existe y NO fue evictado por TTL).
    if (row.payloadJson != null) {
      try {
        final raw = jsonDecode(row.payloadJson!) as Map<String, dynamic>;
        _lastPayload = UnifiedBootstrapRequestDto.fromJson(raw);
      } catch (e) {
        // Payload corrupto — lo descartamos y dejamos null. La fila queda
        // en su estado actual; UI muestra failed/banner; usuario tendrá
        // que volver al onboarding o tocar el botón con payload fresco.
        _log(
          event: 'BOOTSTRAP_PAYLOAD_CORRUPT',
          userId: uid,
          error: e.toString(),
        );
        _lastPayload = null;
      }
    }

    // Caso especial: una fila en `syncing` significa que el proceso murió
    // a mitad de request HTTP. Una sola transición síngle-write a `failed`.
    if (row.status == BootstrapSyncStatusModel.syncing) {
      await _persistTransition(
        uid: uid,
        next: BootstrapSyncStatusModel.failed,
        lastError: 'Interrumpido — reintentando…',
      );
      status.value = BootstrapSyncStatus.failed;
      lastError.value = 'Interrumpido — reintentando…';
      attempts.value = row.attempts;
    } else {
      status.value = _toRx(row.status);
      lastError.value = row.lastError;
      attempts.value = row.attempts;
    }

    _kickIfRetryable();
  }

  void _kickIfRetryable() {
    if (_inFlight) return;
    final s = status.value;
    final shouldKick = s == BootstrapSyncStatus.pendingSync ||
        s == BootstrapSyncStatus.failed;
    if (!shouldKick) return;
    if (_currentUid == null) return;
    if (_lastPayload == null) return; // sin payload no hay retry posible.
    if (attempts.value >= _maxAttempts) return;
    unawaited(_run(_currentUid!));
  }

  /// Programa una llamada a `_run` después de `delay`. Reemplaza cualquier
  /// timer previo. Cancelable vía `_scheduledRetry?.cancel()` en
  /// transiciones terminales o logout.
  void _scheduleRetryTimer(Duration delay, String uid) {
    _scheduledRetry?.cancel();
    if (attempts.value >= _maxAttempts) return;
    _log(
      event: 'BOOTSTRAP_RETRY',
      userId: uid,
      attempt: attempts.value,
      reason: 'scheduled_in_${delay.inSeconds}s',
    );
    _scheduledRetry = Timer(delay, () {
      if (_inFlight) return;
      if (_currentUid != uid) return;
      if (status.value == BootstrapSyncStatus.synced) return;
      unawaited(_run(uid));
    });
  }

  // ─── Internal: motor de ejecución ───────────────────────────────────────

  Future<void> _run(String uid) async {
    if (_inFlight) return;
    final payload = _lastPayload;
    if (payload == null) return;
    if (status.value == BootstrapSyncStatus.synced) return;
    if (attempts.value >= _maxAttempts) {
      // Defensa: ya en max, garantizar terminal failed con single write.
      await _persistTransition(
        uid: uid,
        next: BootstrapSyncStatusModel.failed,
        lastError:
            lastError.value ?? 'Se agotaron los intentos automáticos.',
      );
      status.value = BootstrapSyncStatus.failed;
      _log(event: 'BOOTSTRAP_FAILED', userId: uid,
          attempt: attempts.value, error: 'max_attempts_exhausted');
      return;
    }

    // Limpiar cualquier timer programado: ahora ejecutamos sincrónicamente.
    _scheduledRetry?.cancel();
    _scheduledRetry = null;

    _inFlight = true;
    try {
      while (attempts.value < _maxAttempts) {
        final delay = _backoffSchedule[attempts.value];
        if (delay > Duration.zero) {
          await Future<void>.delayed(delay);
        }

        if (_currentUid != uid) return; // logout durante espera.

        // Token refresh si lo pidió la respuesta anterior. Si falla,
        // programamos retry futuro y salimos sin tocar attempts/estado.
        if (await _refreshTokenIfNeeded(uid) == false) {
          final nextDelay =
              _backoffSchedule[attempts.value.clamp(0, _maxAttempts - 1)];
          _scheduleRetryTimer(nextDelay, uid);
          return;
        }

        // SINGLE WRITE: pendingSync→syncing con todos los campos juntos.
        await _persistTransition(
          uid: uid,
          next: BootstrapSyncStatusModel.syncing,
          attempts: attempts.value + 1,
          lastAttemptAt: DateTime.now().toUtc(),
          requiresTokenRefresh: false, // limpio tras refresh exitoso.
          clearError: true,
        );
        status.value = BootstrapSyncStatus.syncing;
        attempts.value += 1;

        try {
          final result = await _api.bootstrap(payload);
          lastResult.value = result;
          // SINGLE WRITE: syncing→synced terminal.
          await _persistTransition(
            uid: uid,
            next: BootstrapSyncStatusModel.synced,
            requiresTokenRefresh: result.requiresTokenRefresh,
            clearError: true,
          );
          status.value = BootstrapSyncStatus.synced;
          _scheduledRetry?.cancel();
          _scheduledRetry = null;
          _log(
            event: 'BOOTSTRAP_SUCCESS',
            userId: uid,
            attempt: attempts.value,
            extra:
                'orgId=${result.orgId} providerId=${result.providerId ?? "null"} status=${result.status.name}',
          );
          return;
        } on BadRequestException catch (e) {
          // 4xx determinístico: terminal, no retry.
          final msg = e.message;
          await _persistTransition(
            uid: uid,
            next: BootstrapSyncStatusModel.failed,
            lastError: msg,
          );
          status.value = BootstrapSyncStatus.failed;
          lastError.value = msg;
          _log(
            event: 'BOOTSTRAP_FAILED',
            userId: uid,
            attempt: attempts.value,
            error: 'BadRequest code=${e.code} msg=$msg',
          );
          return;
        } on UnauthorizedException catch (e) {
          // 401/403: marcar token-refresh-needed; iterar si hay intentos.
          await _persistTransition(
            uid: uid,
            next: BootstrapSyncStatusModel.failed,
            lastError: 'Sesión inválida: ${e.message}',
            requiresTokenRefresh: true,
          );
          status.value = BootstrapSyncStatus.failed;
          lastError.value = e.message;
          if (attempts.value >= _maxAttempts) {
            _log(event: 'BOOTSTRAP_FAILED', userId: uid,
                attempt: attempts.value, error: 'unauthorized_max');
            return;
          }
          // Continúa el while → siguiente iteración refresca + reintenta.
        } on ServerException catch (e) {
          await _persistTransition(
            uid: uid,
            next: BootstrapSyncStatusModel.failed,
            lastError: 'Error del servidor (${e.statusCode}).',
          );
          status.value = BootstrapSyncStatus.failed;
          lastError.value = 'Error del servidor (${e.statusCode}).';
          if (attempts.value >= _maxAttempts) {
            _log(event: 'BOOTSTRAP_FAILED', userId: uid,
                attempt: attempts.value, error: '5xx_max');
            return;
          }
        } on NetworkException catch (e) {
          await _persistTransition(
            uid: uid,
            next: BootstrapSyncStatusModel.failed,
            lastError: e.message,
          );
          status.value = BootstrapSyncStatus.failed;
          lastError.value = e.message;
          if (attempts.value >= _maxAttempts) {
            _log(event: 'BOOTSTRAP_FAILED', userId: uid,
                attempt: attempts.value, error: 'network_max');
            return;
          }
        } on RequestCancelledException {
          return; // logout / explicit cancel.
        } catch (e) {
          await _persistTransition(
            uid: uid,
            next: BootstrapSyncStatusModel.failed,
            lastError: 'Error inesperado: $e',
          );
          status.value = BootstrapSyncStatus.failed;
          lastError.value = e.toString();
          _log(event: 'BOOTSTRAP_FAILED', userId: uid,
              attempt: attempts.value, error: 'unexpected: $e');
          return;
        }
      }
    } finally {
      _inFlight = false;
      // Si salimos del while sin synced y aún hay margen, programar retry
      // independiente de lifecycle (regla §2 — no depender solo de triggers
      // externos). El timer respeta el backoff del próximo intento.
      if (status.value != BootstrapSyncStatus.synced &&
          attempts.value < _maxAttempts &&
          _currentUid == uid &&
          _lastPayload != null) {
        final nextDelay =
            _backoffSchedule[attempts.value.clamp(0, _maxAttempts - 1)];
        _scheduleRetryTimer(nextDelay, uid);
      }
    }
  }

  /// Refresh de token si la fila persistida lo solicita. Retorna `false`
  /// si el refresh falla (caller debe abortar y reintentar después).
  Future<bool> _refreshTokenIfNeeded(String uid) async {
    final row = await _localDs.getByUserId(uid);
    if (row == null) return true;
    if (!row.requiresTokenRefresh) return true;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    try {
      await user.getIdToken(true);
      // El flag se limpia DENTRO de la próxima transición (a `syncing`)
      // — single write per transition. No escribimos aquí.
      return true;
    } catch (e) {
      _log(event: 'BOOTSTRAP_TOKEN_REFRESH_FAIL',
          userId: uid, error: e.toString());
      return false;
    }
  }

  // ─── Internal: persistencia (single write per transition) ───────────────

  Future<void> _persistTransition({
    required String uid,
    required BootstrapSyncStatusModel next,
    int? attempts,
    DateTime? lastAttemptAt,
    String? lastError,
    bool? requiresTokenRefresh,
    String? payloadJson,
    bool clearError = false,
  }) async {
    await _localDs.upsert(
      userId: uid,
      status: next,
      attempts: attempts,
      lastAttemptAt: lastAttemptAt,
      lastError: lastError,
      requiresTokenRefresh: requiresTokenRefresh,
      payloadJson: payloadJson,
      clearLastError: clearError,
    );
  }

  // ─── Internal: logging estructurado ─────────────────────────────────────

  /// Emite un log estructurado. En debug imprime via `debugPrint` con
  /// formato `[BootstrapSync] event=X userId=Y attempt=Z error=W`. En
  /// producción podría enrutarse a Crashlytics / Datadog vía un sink
  /// inyectable; por ahora deja el formato listo para grep en logs locales.
  void _log({
    required String event,
    String? userId,
    int? attempt,
    String? error,
    String? reason,
    String? extra,
  }) {
    if (!kDebugMode && event != 'BOOTSTRAP_SUCCESS' &&
        event != 'BOOTSTRAP_FAILED' &&
        event != 'BOOTSTRAP_START' &&
        event != 'BOOTSTRAP_RETRY') {
      // En release solo emitimos los 4 canónicos del contrato.
      return;
    }
    final parts = <String>[
      'event=$event',
      if (userId != null) 'userId=${_maskUid(userId)}',
      if (attempt != null) 'attempt=$attempt/$_maxAttempts',
      if (reason != null) 'reason=$reason',
      if (error != null) 'error=$error',
      if (extra != null) extra,
    ];
    debugPrint('[BootstrapSync] ${parts.join(" ")}');
  }

  String _maskUid(String uid) =>
      uid.length <= 4 ? '****' : '${uid.substring(0, 4)}***';

  static BootstrapSyncStatus _toRx(BootstrapSyncStatusModel s) {
    return switch (s) {
      BootstrapSyncStatusModel.idle => BootstrapSyncStatus.idle,
      BootstrapSyncStatusModel.pendingSync => BootstrapSyncStatus.pendingSync,
      BootstrapSyncStatusModel.syncing => BootstrapSyncStatus.syncing,
      BootstrapSyncStatusModel.synced => BootstrapSyncStatus.synced,
      BootstrapSyncStatusModel.failed => BootstrapSyncStatus.failed,
    };
  }
}
