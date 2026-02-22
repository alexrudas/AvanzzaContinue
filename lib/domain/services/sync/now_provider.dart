// ============================================================================
// lib/domain/services/sync/now_provider.dart
// NOW PROVIDER — Enterprise Ultra Pro (Domain Contract)
//
// QUÉ HACE:
// - Define contrato domain-puro para inyectar un reloj.
// - Permite al SyncEngineService obtener timestamps sin DateTime.now().
//
// QUÉ NO HACE:
// - Implementación (eso es Infrastructure: SystemNowProvider).
// - Lógica de negocio.
// - Logs / prints / assert.
//
// CONSUMIDORES:
// - SyncEngineService: clock inyectable para timestamps de batch.
// ============================================================================

/// Contrato para proveer el timestamp actual.
///
/// Guardrail: el engine NO llama DateTime.now(). El caller inyecta el clock.
/// La implementación del sistema vive en Infrastructure.
abstract class NowProvider {
  /// Retorna el timestamp actual.
  ///
  /// La implementación DEBE retornar UTC para consistencia con el dominio.
  DateTime now();
}
