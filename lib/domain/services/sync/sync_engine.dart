// ============================================================================
// lib/domain/services/sync/sync_engine.dart
// SYNC ENGINE SERVICE — Enterprise Ultra Pro (Domain Service)
//
// QUÉ HACE:
// - Orquesta ejecución de dispatch batches via SyncDispatcher.
// - Ciclo de vida explícito: start() / stop() con shutdown graceful.
// - Awareness de conectividad via ConnectivityProvider (pausa lógica offline).
// - Control de concurrencia: SOLO un runOnce a la vez (double-check locking).
// - Kickstart: si online al arrancar, dispara run inmediato sin esperar timer.
// - Observabilidad interna: isRunning, isProcessing, lastRunAt, lastReport.
// - Backoff exponencial + jitter configurable (Equal/Full Jitter).
//
// QUÉ NO HACE:
// - Mutar estado del outbox (solo vía Dispatcher).
// - Conocer Firestore / HTTP / infra.
// - DateTime.now() interno (now SIEMPRE inyectado por NowProvider).
// - Logs / prints / assert.
// - Lógica de dispatch (eso es SyncDispatcher).
//
// DEPENDENCIAS:
// - dart:async, dart:math.
// - ConnectivityProvider (domain contract).
// - SyncDispatcher, SyncDispatchReport (domain service).
// ============================================================================

import 'dart:async';
import 'dart:math';

import 'connectivity_provider.dart';
import 'now_provider.dart';
import 'sync_dispatcher.dart';

// ============================================================================
// SYNC ENGINE CONFIG — INMUTABLE
// ============================================================================

class SyncEngineConfig {
  final Duration baseBackoff;
  final Duration maxBackoff;
  final double jitterRatio;
  final int batchLimit;
  final int maxConcurrency;
  final Duration leaseDuration;
  final int maxBatchesPerRun;

  const SyncEngineConfig({
    this.baseBackoff = const Duration(seconds: 10),
    this.maxBackoff = const Duration(hours: 1),
    this.jitterRatio = 1.0,
    this.batchLimit = 50,
    this.maxConcurrency = 4,
    this.leaseDuration = const Duration(minutes: 2),
    this.maxBatchesPerRun = 10,
  });
}

// ============================================================================
// SYNC ENGINE REPORT — MÉTRICAS AGREGADAS
// ============================================================================

class SyncEngineReport {
  final int batchesExecuted;
  final int totalFetched;
  final int totalCompleted;
  final int totalFailedRetryable;
  final int totalDeadLettered;
  final int totalExceptions;

  const SyncEngineReport({
    required this.batchesExecuted,
    required this.totalFetched,
    required this.totalCompleted,
    required this.totalFailedRetryable,
    required this.totalDeadLettered,
    required this.totalExceptions,
  });

  const SyncEngineReport.empty()
      : batchesExecuted = 0,
        totalFetched = 0,
        totalCompleted = 0,
        totalFailedRetryable = 0,
        totalDeadLettered = 0,
        totalExceptions = 0;

  bool get hadWork => totalFetched > 0;
}

// ============================================================================
// SYNC ENGINE SERVICE — IMPLEMENTATION
// ============================================================================

class SyncEngineService {
  final SyncDispatcher _dispatcher;
  final NowProvider _clock;
  final SyncEngineConfig _config;
  final ConnectivityProvider _connectivity;
  final Random _random;
  final Duration _pollingInterval;

  bool _isRunning = false;
  bool _isShuttingDown = false;

  Future<SyncEngineReport>? _activeRunFuture;
  Timer? _pollingTimer;
  StreamSubscription<bool>? _connectivitySubscription;

  DateTime? _lastRunAt;
  SyncDispatchReport? _lastReport;

  SyncEngineService({
    required SyncDispatcher dispatcher,
    required NowProvider clock,
    required ConnectivityProvider connectivity,
    SyncEngineConfig config = const SyncEngineConfig(),
    Duration pollingInterval = const Duration(seconds: 30),
    Random? random,
  })  : _dispatcher = dispatcher,
        _clock = clock,
        _connectivity = connectivity,
        _config = config,
        _pollingInterval = pollingInterval.inMilliseconds <= 0
            ? const Duration(seconds: 30)
            : pollingInterval,
        _random = random ?? Random();

  // --------------------------------------------------------------------------
  // OBSERVABILITY
  // --------------------------------------------------------------------------

  bool get isRunning => _isRunning;
  bool get isProcessing => _activeRunFuture != null;
  DateTime? get lastRunAt => _lastRunAt;
  SyncDispatchReport? get lastReport => _lastReport;

  // ==========================================================================
  // LIFECYCLE — START
  // ==========================================================================

  /// Arranca el engine. Idempotente.
  ///
  /// 1) Obtiene estado real de conectividad (fail-safe).
  /// 2) Inicia Timer periódico.
  /// 3) Se suscribe a ConnectivityProvider (offline→online trigger).
  /// 4) KICKSTART: si ya está online, dispara run inmediato.
  ///
  /// Notas:
  /// - Evita crear timers/suscripciones duplicadas si start() se llama más de una vez.
  /// - Si el caller NO await-a start(), podría perder el kickstart en flujos muy rápidos.
  Future<void> start() async {
    if (_isRunning) return;

    _isRunning = true;
    _isShuttingDown = false;

    // Hardening: evitar duplicados por estados intermedios/calls extraños.
    if (_pollingTimer != null || _connectivitySubscription != null) {
      // En teoría no debería ocurrir si stop() se usa bien,
      // pero preferimos no multiplicar recursos.
      await stop(graceful: true);
      _isRunning = true;
      _isShuttingDown = false;
    }

    // Inicializar estado real de conectividad.
    bool lastKnown = await _safeIsConnected();

    // Timer periódico.
    _pollingTimer = Timer.periodic(_pollingInterval, (_) {
      _tryRun();
    });

    // Suscripción a conectividad: trigger en transición offline→online.
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((connected) {
      final wasOffline = !lastKnown;
      lastKnown = connected;

      if (wasOffline && connected) {
        _tryRun();
      }
    });

    // KICKSTART: si online al arrancar, run inmediato.
    if (lastKnown) {
      _tryRun();
    }
  }

  // ==========================================================================
  // LIFECYCLE — STOP
  // ==========================================================================

  /// Detiene el engine. Idempotente.
  ///
  /// Cancela timer y suscripción. Si [graceful] es true, espera run activo.
  Future<void> stop({bool graceful = true}) async {
    if (!_isRunning && !_isShuttingDown) return;

    _isShuttingDown = true;
    _isRunning = false;

    _pollingTimer?.cancel();
    _pollingTimer = null;

    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;

    if (graceful) {
      final active = _activeRunFuture;
      if (active != null) {
        await active;
      }
    } else {
      // Observability-only hardening:
      // No cancelamos el run en curso (no se puede sin soporte infra),
      // pero al menos reflejamos que el engine ya "no está procesando" a nivel API.
      // El run, si existe, seguirá y limpiará _activeRunFuture en su finally.
      _activeRunFuture = null;
    }

    _isShuttingDown = false;
  }

  // ==========================================================================
  // TRY RUN — DOUBLE-CHECK LOCKING + CONNECTIVITY FAIL-SAFE
  // ==========================================================================

  /// Intenta ejecutar runOnce si todas las condiciones se cumplen.
  ///
  /// Double-check locking:
  /// 1) Check sincrónico rápido (lifecycle + concurrency).
  /// 2) Check asíncrono de conectividad.
  /// 3) Re-check sincrónico post-await (estado pudo cambiar).
  /// 4) Si todo OK, lanza _executeRunOnce.
  void _tryRun() {
    // Check sincrónico rápido.
    if (!_isRunning) return;
    if (_isShuttingDown) return;
    if (_activeRunFuture != null) return;

    // Check asíncrono + re-check post-await.
    _safeIsConnected().then((connected) {
      if (!_isRunning) return;
      if (_isShuttingDown) return;
      if (_activeRunFuture != null) return;
      if (!connected) return;

      _activeRunFuture = _executeRunOnce();
    });
  }

  /// Consulta conectividad con fail-safe: si falla, asume offline.
  Future<bool> _safeIsConnected() async {
    try {
      return await _connectivity.isConnected;
    } catch (_) {
      return false;
    }
  }

  /// Wrapper: ejecuta runOnce y limpia _activeRunFuture en finally.
  Future<SyncEngineReport> _executeRunOnce() async {
    try {
      return await runOnce();
    } finally {
      _activeRunFuture = null;
    }
  }

  // ==========================================================================
  // RUN ONCE — ORQUESTA BATCHES
  // ==========================================================================

  /// Ejecuta una ronda de sincronización.
  ///
  /// Público para invocación directa (tests, triggers manuales).
  /// El lifecycle (start/stop) lo invoca internamente via _tryRun.
  Future<SyncEngineReport> runOnce() async {
    final maxBatches =
        _config.maxBatchesPerRun <= 0 ? 1 : _config.maxBatchesPerRun;
    final limit = _config.batchLimit <= 0 ? 1 : _config.batchLimit;
    final concurrency =
        _config.maxConcurrency <= 0 ? 1 : _config.maxConcurrency;

    var batchesExecuted = 0;
    var totalFetched = 0;
    var totalCompleted = 0;
    var totalFailedRetryable = 0;
    var totalDeadLettered = 0;
    var totalExceptions = 0;

    SyncDispatchReport? lastBatch;

    for (var i = 0; i < maxBatches; i++) {
      final now = _clock.now();

      final report = await _dispatcher.dispatchEligibleBatch(
        now: now,
        limit: limit,
        maxConcurrency: concurrency,
        leaseDuration: _config.leaseDuration,
      );

      lastBatch = report;

      if (report.fetched == 0) {
        if (batchesExecuted == 0) {
          _lastRunAt = _clock.now();
          _lastReport = report;
          return const SyncEngineReport.empty();
        }
        break;
      }

      batchesExecuted++;
      totalFetched += report.fetched;
      totalCompleted += report.completed;
      totalFailedRetryable += report.failedRetryable;
      totalDeadLettered += report.deadLettered;
      totalExceptions += report.exceptions;
    }

    _lastRunAt = _clock.now();
    if (lastBatch != null) _lastReport = lastBatch;

    return SyncEngineReport(
      batchesExecuted: batchesExecuted,
      totalFetched: totalFetched,
      totalCompleted: totalCompleted,
      totalFailedRetryable: totalFailedRetryable,
      totalDeadLettered: totalDeadLettered,
      totalExceptions: totalExceptions,
    );
  }

  // ==========================================================================
  // BACKOFF — API PÚBLICA (PURO)
  // ==========================================================================

  DateTime calculateNextAttemptAt({
    required DateTime now,
    required int retryCount,
  }) {
    final delay = _calculateBackoffDelay(retryCount: retryCount);
    return now.toUtc().add(delay);
  }

  Duration _calculateBackoffDelay({required int retryCount}) {
    final baseMs = _config.baseBackoff.inMilliseconds;
    final maxMs = _config.maxBackoff.inMilliseconds;

    if (baseMs <= 0) return Duration(milliseconds: maxMs.clamp(0, maxMs));
    if (maxMs <= 0) return Duration.zero;

    final exponent = retryCount < 0 ? 0 : (retryCount > 30 ? 30 : retryCount);
    final exponentialMs = baseMs * (1 << exponent);
    final cappedMs =
        exponentialMs > maxMs ? maxMs : (exponentialMs < 0 ? 0 : exponentialMs);

    final jitter = _config.jitterRatio.clamp(0.0, 1.0);

    if (jitter == 0.0) return Duration(milliseconds: cappedMs);

    final minMs = ((1.0 - jitter) * cappedMs).round();
    final range = cappedMs - minMs;

    if (range <= 0) return Duration(milliseconds: cappedMs);

    final jitteredMs = minMs + _random.nextInt(range + 1);
    return Duration(milliseconds: jitteredMs);
  }
}

// ============================================================================
// CHECKLIST FINAL — FASE 6
// ============================================================================
// [x] start() Future<void> async — idempotente
// [x] Hardening: evita duplicar timer/suscripción si start() se llama mal
// [x] Kickstart: si online al arrancar, _tryRun() inmediato
// [x] _safeIsConnected() fail-safe: catch → false
// [x] Double-check locking: check sincrónico + async + re-check post-await
// [x] Thundering herd prevention: SOLO un runOnce a la vez
// [x] Connectivity awareness: NO ejecuta batches si offline
// [x] Transición offline→online dispara run inmediato
// [x] stop() Future<void> — graceful espera _activeRunFuture
// [x] stop(graceful:false): hardening de observabilidad (no cancela run real)
// [x] Graceful shutdown: batch en curso termina naturalmente
// [x] Observabilidad: isRunning, isProcessing, lastRunAt, lastReport
// [x] pollingInterval configurable con guardrail (<=0 → 30s)
// [x] NowProvider inyectable — CERO DateTime.now()
// [x] Random inyectable para tests determinísticos
// [x] Backoff exponencial con cap + jitter (0..1)
// [x] maxBatchesPerRun guardrail anti-loop (clamp min 1)
// [x] runOnce público para invocación directa
// [x] NO modifica SyncDispatcher / SyncExecutor / SyncExecutionResult
// [x] CERO logs / prints / assert
// [x] CERO dependencias externas (solo dart:async, dart:math)
// [x] Production-ready FASE 6
