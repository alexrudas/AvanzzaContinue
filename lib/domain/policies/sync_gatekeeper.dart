// lib/domain/policies/sync_gatekeeper.dart

library;

import 'policy_context_v2.dart';
import 'real_policy_context_factory.dart';
import 'sync_policy.dart';

/// Resultado del gatekeeper de sincronización.
///
/// Encapsula la decisión final y el contexto que la produjo.
class SyncGatekeeperResult {
  /// Resultado de la evaluación de política
  final SyncPolicyResult policyResult;

  /// Contexto que fue evaluado
  final PolicyContextV2 context;

  const SyncGatekeeperResult({
    required this.policyResult,
    required this.context,
  });

  /// ¿Se permite la sincronización? (delegado a policyResult)
  bool get allowed => policyResult.allowed;

  @override
  String toString() =>
      'SyncGatekeeperResult(allowed: $allowed, reason: ${policyResult.reason})';
}

/// Gatekeeper de sincronización.
///
/// Orquesta la construcción del contexto y la evaluación de la política.
/// Punto de entrada único para decisiones de sincronización.
///
/// Arquitectura:
/// 1. Construye PolicyContextV2 via RealPolicyContextFactory
/// 2. Evalúa el contexto via SyncPolicy
/// 3. Retorna SyncGatekeeperResult con decisión final
class SyncGatekeeper {
  final RealPolicyContextFactory _contextFactory;
  final SyncPolicy _syncPolicy;
  final Duration _timeout;

  const SyncGatekeeper({
    required RealPolicyContextFactory contextFactory,
    required SyncPolicy syncPolicy,
    Duration timeout = const Duration(seconds: 30),
  })  : _contextFactory = contextFactory,
        _syncPolicy = syncPolicy,
        _timeout = timeout;

  /// Evalúa si se permite sincronización.
  ///
  /// Construye el contexto y aplica la política en un solo paso.
  /// En caso de error, retorna DENY con reasonCode constructionError.
  Future<SyncGatekeeperResult> canSync() async {
    try {
      final context = await _contextFactory.build().timeout(_timeout);
      final policyResult = _syncPolicy.evaluate(context);

      return SyncGatekeeperResult(
        policyResult: policyResult,
        context: context,
      );
    } on Object catch (e) {
      _logSyncFailure(error: e, source: 'SyncGatekeeper.canSync');
      final failSafeContext = PolicyContextV2.failSafe(
        reasonCode: ContextReasonCode.constructionError,
      );
      final failSafeResult = SyncPolicyResult.deny(
        reason: 'Context construction failed',
        reasonCode: ContextReasonCode.constructionError,
      );
      return SyncGatekeeperResult(
        policyResult: failSafeResult,
        context: failSafeContext,
      );
    }
  }

  /// Ejecuta sincronización solo si está permitida.
  ///
  /// Retorna el resultado del gatekeeper.
  /// Si está permitida, ejecuta el callback [onAllowed].
  /// Si está denegada, ejecuta el callback opcional [onDenied].
  Future<SyncGatekeeperResult> guardSync({
    required Future<void> Function() onAllowed,
    Future<void> Function(SyncGatekeeperResult result)? onDenied,
  }) async {
    final result = await canSync();

    if (result.allowed) {
      await onAllowed();
    } else if (onDenied != null) {
      await onDenied(result);
    }

    return result;
  }
}

void _logSyncFailure({
  required Object error,
  required String source,
}) {
  assert(() {
    // ignore: avoid_print
    print(
      '[SYNC_FAILURE] source: $source | type: ${error.runtimeType} | at: ${DateTime.now().toIso8601String()}',
    );
    return true;
  }());
}
