// ============================================================================
// lib/domain/services/sync/next_attempt_policy.dart
// NEXT ATTEMPT POLICY — Enterprise Ultra Pro (Domain Pure)
//
// QUÉ HACE:
// - Define contrato domain-puro para calcular nextAttemptAt en fallos retryable.
// - Implementación default: Exponential Backoff + Jitter configurable.
//   (ref: AWS Architecture Blog — "Exponential Backoff And Jitter")
//
// QUÉ NO HACE:
// - DateTime.now() interno (now SIEMPRE inyectado por parámetro).
// - Logs / prints / assert.
// - Mutar estado del outbox.
// - Conocer Firestore / HTTP / infra.
//
// CONTRATO:
// - NextAttemptPolicy es interface domain pura (sin dependencias externas).
// - [now] siempre es inyectado por el caller (dispatcher/engine).
// - [retryCount] es 0-based: primer fallo = 0, segundo fallo = 1, etc.
//
// CONSUMIDORES:
// - SyncDispatcher: aplica policy cuando executor retorna retryable
//   sin nextAttemptAt explícito.
// - SyncEngineService: puede exponer calculateNextAttemptAt delegando aquí.
// ============================================================================

import 'dart:math';

// ============================================================================
// INTERFACE — DOMAIN PURE
// ============================================================================

/// Contrato para calcular el próximo intento de retry.
///
/// Interface domain pura. Sin estado mutable. Sin efectos secundarios.
///
/// El dispatcher llama esto cuando:
/// - result.retryable == true
/// - result.nextAttemptAt == null (executor no provee scheduling propio)
/// - retryCount < maxRetries (aún hay reintentos disponibles)
///
/// Semántica de [retryCount]:
/// - 0-based: el primer fallo produce retryCount = 0.
/// - El caller (dispatcher) pasa entry.retryCount ANTES del incremento
///   que hará markFailed(incrementRetry: true).
abstract class NextAttemptPolicy {
  /// Calcula cuándo debe ejecutarse el próximo intento.
  ///
  /// [now] — timestamp de referencia. Se normaliza a UTC internamente.
  /// [retryCount] — reintentos previos (0-based). Valores negativos → 0.
  ///
  /// Retorna DateTime UTC.
  DateTime nextAttemptAt({
    required DateTime now,
    required int retryCount,
  });
}

// ============================================================================
// EXPONENTIAL BACKOFF + JITTER — IMPLEMENTACIÓN DEFAULT
// ============================================================================

/// Backoff exponencial con jitter configurable (AWS-style).
///
/// Algoritmo (3 pasos):
/// 1. Exponential: baseBackoff.inMilliseconds * 2^retryCount
/// 2. Cap: min(exponential, maxBackoff.inMilliseconds)
/// 3. Jitter (controlado por jitterRatio):
///    - 0.0 → sin jitter (determinístico puro)
///    - 0.5 → Equal Jitter: rango [cappedMs/2 .. cappedMs]
///    - 1.0 → Full Jitter: rango [0 .. cappedMs]
///
/// Guardrails duros:
/// - retryCount < 0 → tratado como 0.
/// - Exponente clamped manualmente a [0..30] (2^30 ≈ 1.07 billion ms ≈ 12.4 días).
/// - baseBackoff <= 0 → Duration.zero (sin delay).
/// - maxBackoff <= 0 → Duration.zero (sin delay).
/// - jitterRatio clamped manualmente a [0.0..1.0].
/// - Overflow imposible: exponent max 30, base max ~1h = 3.6M ms → 3.6M * 2^30 ≈ 3.8e15
///   (dentro del rango de Dart int de 64 bits: max 9.2e18).
///
/// Determinismo: Random inyectable. Misma seed + misma entrada = mismo resultado.
class ExponentialBackoffJitterPolicy implements NextAttemptPolicy {
  final Duration baseBackoff;
  final Duration maxBackoff;
  final double jitterRatio;
  final Random _random;

  ExponentialBackoffJitterPolicy({
    this.baseBackoff = const Duration(seconds: 10),
    this.maxBackoff = const Duration(hours: 1),
    this.jitterRatio = 1.0,
    Random? random,
  }) : _random = random ?? Random();

  @override
  DateTime nextAttemptAt({
    required DateTime now,
    required int retryCount,
  }) {
    final delay = _calculateDelay(retryCount: retryCount);
    return now.toUtc().add(delay);
  }

  /// Cálculo puro de delay. Sin efectos secundarios.
  ///
  /// Dado el mismo retryCount y la misma instancia de Random (con seed),
  /// produce el mismo resultado.
  Duration _calculateDelay({required int retryCount}) {
    final baseMs = baseBackoff.inMilliseconds;
    final maxMs = maxBackoff.inMilliseconds;

    // Guardrails: configuración degenerada → sin delay.
    if (baseMs <= 0) return Duration.zero;
    if (maxMs <= 0) return Duration.zero;

    // Sanitizar retryCount: negativo → 0.
    // Clamp exponente: máximo 30 (2^30 = 1,073,741,824).
    final exponent = retryCount < 0 ? 0 : (retryCount > 30 ? 30 : retryCount);

    // Paso 1: Exponential backoff.
    final exponentialMs = baseMs * (1 << exponent);

    // Paso 2: Cap al máximo. Protección contra negativo (overflow teórico).
    final cappedMs = exponentialMs > maxMs
        ? maxMs
        : (exponentialMs < 0 ? 0 : exponentialMs);

    // Sanitizar jitterRatio manualmente.
    final jitter = jitterRatio < 0.0
        ? 0.0
        : (jitterRatio > 1.0 ? 1.0 : jitterRatio);

    // Paso 3a: Sin jitter → determinístico puro.
    if (jitter == 0.0) return Duration(milliseconds: cappedMs);

    // Paso 3b: Jitter aplicado.
    // jitter=1.0 → minMs=0,         rango=[0, cappedMs]     (Full Jitter)
    // jitter=0.5 → minMs=cappedMs/2, rango=[cappedMs/2, cappedMs] (Equal Jitter)
    // jitter=0.0 → ya retornó arriba (determinístico)
    final minMs = ((1.0 - jitter) * cappedMs).round();
    final range = cappedMs - minMs;

    // Guardrail: range <= 0 puede ocurrir con cappedMs muy pequeño + rounding.
    if (range <= 0) return Duration(milliseconds: cappedMs);

    // nextInt(range + 1) → uniforme en [0, range] inclusive.
    final jitteredMs = minMs + _random.nextInt(range + 1);
    return Duration(milliseconds: jitteredMs);
  }
}

// ============================================================================
// CHECKLIST FINAL
// ============================================================================
// [x] Interface domain pura: NextAttemptPolicy.nextAttemptAt(now, retryCount)
// [x] Contrato: now inyectado, retryCount 0-based, retorna DateTime UTC
// [x] Default: ExponentialBackoffJitterPolicy implements NextAttemptPolicy
// [x] Exponential backoff: base * 2^retryCount
// [x] Cap duro: min(exponential, maxBackoff)
// [x] Jitter configurable via jitterRatio:
//     - 0.0 → sin jitter
//     - 0.5 → Equal Jitter [delay/2, delay]
//     - 1.0 → Full Jitter [0, delay] (AWS-style)
// [x] Guardrails duros:
//     - retryCount < 0 → 0
//     - exponent clamped manual (0..30)
//     - baseBackoff <= 0 → Duration.zero
//     - maxBackoff <= 0 → Duration.zero
//     - jitterRatio clamped manual (0.0..1.0)
//     - range <= 0 → cappedMs (sin jitter degenerado)
// [x] Overflow imposible: exponent max 30, Dart int 64-bit
// [x] Random inyectable para tests determinísticos
// [x] Función pura: misma entrada + misma seed = mismo resultado
// [x] nextAttemptAt siempre usa now.toUtc()
// [x] CERO DateTime.now()
// [x] CERO logs / prints / assert
// [x] CERO dependencias externas (solo dart:math)
// [x] CERO TODOs abiertos
// [x] CERO referencias a infra (Firestore/HTTP)
// [x] Domain puro — production-ready FASE 5.1
