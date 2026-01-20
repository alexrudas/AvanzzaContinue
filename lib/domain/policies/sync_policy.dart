// lib/domain/policies/sync_policy.dart

library;

import 'policy_context_v2.dart';

/// Resultado de evaluación de política de sincronización.
///
/// Contiene la decisión (permitir/denegar) y metadatos para diagnóstico.
class SyncPolicyResult {
  /// ¿Se permite la sincronización?
  final bool allowed;

  /// Razón legible del resultado (para logging/UI)
  final String reason;

  /// Código de razón del contexto que produjo este resultado
  final ContextReasonCode reasonCode;

  /// Timestamp de evaluación
  final DateTime evaluatedAt;

  const SyncPolicyResult._({
    required this.allowed,
    required this.reason,
    required this.reasonCode,
    required this.evaluatedAt,
  });

  /// Resultado: Sync PERMITIDO
  factory SyncPolicyResult.allow({
    required String reason,
    required ContextReasonCode reasonCode,
  }) {
    return SyncPolicyResult._(
      allowed: true,
      reason: reason,
      reasonCode: reasonCode,
      evaluatedAt: DateTime.now(),
    );
  }

  /// Resultado: Sync DENEGADO
  factory SyncPolicyResult.deny({
    required String reason,
    required ContextReasonCode reasonCode,
  }) {
    return SyncPolicyResult._(
      allowed: false,
      reason: reason,
      reasonCode: reasonCode,
      evaluatedAt: DateTime.now(),
    );
  }

  @override
  String toString() =>
      'SyncPolicyResult(allowed: $allowed, reason: $reason, code: ${reasonCode.wireName})';
}

/// Política de sincronización.
///
/// Evalúa si el contexto actual permite realizar sincronización con la nube.
/// Consume PolicyContextV2 y produce SyncPolicyResult.
///
/// REGLAS CEO (NO NEGOCIABLE):
/// - Offline → NO SYNC
/// - AuthExpired → NO SYNC
/// - HardDeadlineExpired → NO SYNC
/// - ContractBlocked → NO SYNC
/// - capabilities.canSyncCloud == false → NO SYNC
class SyncPolicy {
  const SyncPolicy();

  /// Evalúa si el contexto permite sincronización.
  SyncPolicyResult evaluate(PolicyContextV2 context) {
    // ─────────────────────────────────────────────────────────────────────────
    // 1) CONTEXT BLOCKED CHECK
    // ─────────────────────────────────────────────────────────────────────────
    if (context.isBlocked) {
      return SyncPolicyResult.deny(
        reason: 'Context is blocked',
        reasonCode: context.reasonCode,
      );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 2) CAPABILITIES CHECK (FUENTE DE VERDAD PARA SYNC)
    // ─────────────────────────────────────────────────────────────────────────
    if (!context.capabilities.canSyncCloud) {
      return SyncPolicyResult.deny(
        reason: 'Sync capability disabled',
        reasonCode: context.reasonCode,
      );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 3) AUTH STATE CHECK
    // ─────────────────────────────────────────────────────────────────────────
    if (context.authState != AuthState.authenticated) {
      final reason = switch (context.authState) {
        AuthState.expired => 'Auth session expired',
        AuthState.unauthenticated => 'User not authenticated',
        AuthState.unknown => 'Auth state unknown',
        AuthState.authenticated => 'Authenticated',
      };
      return SyncPolicyResult.deny(
        reason: reason,
        reasonCode: context.reasonCode,
      );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // DEFAULT: ALLOW
    // ─────────────────────────────────────────────────────────────────────────
    return SyncPolicyResult.allow(
      reason: 'All checks passed',
      reasonCode: context.reasonCode,
    );
  }
}
