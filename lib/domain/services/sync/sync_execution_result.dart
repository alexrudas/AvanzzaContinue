// ============================================================================
// lib/domain/services/sync/sync_execution_result.dart
// SYNC EXECUTION RESULT — Enterprise Ultra Pro (Domain DTO)
//
// QUÉ HACE:
// - DTO inmutable para describir el outcome de un SyncExecutor.
//
// QUÉ NO HACE:
// - Lógica de retries/backoff (eso es policy/engine).
// - Mutar outbox (eso lo hace el dispatcher).
// - DateTime.now() interno.
// ============================================================================

import '../../entities/sync/sync_outbox_entry.dart';

/// Resultado de la ejecución de una entrada por el executor.
///
/// El dispatcher usa estos campos para decidir la transición de estado:
/// - success=true  → markCompleted
/// - terminal=true → moveToDeadLetter
/// - retryable=true → markFailed (con nextAttemptAt si viene)
/// - default (success=false, terminal=false, retryable=false) → deadLetter
class SyncExecutionResult {
  final bool success;
  final int? httpStatus;
  final String? errorMessage;
  final SyncErrorCode? errorCode;
  final bool retryable;
  final bool terminal;

  /// Si el executor o el engine calculan el próximo intento, lo pasan aquí.
  /// Si es null, el dispatcher/policy pueden calcularlo.
  final DateTime? nextAttemptAt;

  const SyncExecutionResult({
    required this.success,
    this.httpStatus,
    this.errorMessage,
    this.errorCode,
    this.retryable = false,
    this.terminal = false,
    this.nextAttemptAt,
  });

  /// Factory: éxito limpio.
  const SyncExecutionResult.ok()
      : success = true,
        httpStatus = null,
        errorMessage = null,
        errorCode = null,
        retryable = false,
        terminal = false,
        nextAttemptAt = null;

  /// Factory: fallo retryable.
  const SyncExecutionResult.retryableError({
    required String message,
    SyncErrorCode? code,
    int? httpStatus,
    DateTime? nextAttemptAt,
  })  : success = false,
        errorMessage = message,
        errorCode = code,
        retryable = true,
        terminal = false,
        nextAttemptAt = nextAttemptAt,
        httpStatus = httpStatus;

  /// Factory: fallo terminal (deadLetter).
  const SyncExecutionResult.terminalError({
    required String message,
    SyncErrorCode? code,
    int? httpStatus,
  })  : success = false,
        errorMessage = message,
        errorCode = code,
        retryable = false,
        terminal = true,
        nextAttemptAt = null,
        httpStatus = httpStatus;
}
