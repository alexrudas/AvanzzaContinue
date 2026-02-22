// ============================================================================
// lib/domain/services/sync/sync_executor.dart
// SYNC EXECUTOR — Enterprise Ultra Pro (Domain Contract)
//
// QUÉ HACE:
// - Define contrato domain-puro para ejecutar operaciones de sync contra backend.
//
// QUÉ NO HACE:
// - Implementación (eso es Infrastructure: FirestoreSyncExecutor, etc.).
// - Mutar estado del outbox.
// - DateTime.now() interno.
// - Logs / prints / assert.
//
// CONSUMIDORES:
// - SyncDispatcher: inyecta executor y llama execute() por entry.
// - FirestoreSyncExecutor: implementa este contrato en Infrastructure.
// ============================================================================

import 'dart:async';

import '../../entities/sync/sync_outbox_entry.dart';
import 'sync_execution_result.dart';

/// Contrato para ejecutar una operación de sync contra backend.
///
/// Excepciones permitidas (el dispatcher las maneja explícitamente):
/// - FormatException → deadLetter
/// - ArgumentError → deadLetter
/// - otras → el dispatcher las clasifica como excepción no tipificada
abstract class SyncExecutor {
  Future<SyncExecutionResult> execute({
    required SyncOutboxEntry entry,
    required DateTime now,
  });
}
