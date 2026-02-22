// ============================================================================
// lib/infrastructure/sync/system_now_provider.dart
// SYSTEM NOW PROVIDER — Enterprise Ultra Pro (Infrastructure)
//
// QUÉ HACE:
// - Implementa NowProvider usando el reloj del sistema.
// - Retorna DateTime.now().toUtc() (siempre UTC).
//
// QUÉ NO HACE:
// - Lógica de dominio.
// - Logs / prints / assert.
//
// CONSUMIDORES:
// - SyncEngineService: clock inyectable para timestamps de batch.
// ============================================================================

import '../../domain/services/sync/now_provider.dart';

// ============================================================================
// IMPLEMENTATION
// ============================================================================

/// Implementación de NowProvider que usa el reloj del sistema.
///
/// Retorna siempre UTC para consistencia con el dominio de sync.
class SystemNowProvider implements NowProvider {
  @override
  DateTime now() => DateTime.now().toUtc();
}
