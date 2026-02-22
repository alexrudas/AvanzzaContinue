// ============================================================================
// lib/infrastructure/sync/connectivity_service_adapter.dart
// CONNECTIVITY SERVICE ADAPTER — Enterprise Ultra Pro (Infrastructure)
//
// QUÉ HACE:
// - Adapta ConnectivityService (core/network) al contrato domain
//   ConnectivityProvider para inyección en SyncEngineService.
//
// QUÉ NO HACE:
// - Lógica de dominio.
// - Logs / prints / assert.
// - Gestionar el ciclo de vida de ConnectivityService (eso es Bootstrap).
// - Timers / heartbeats.
//
// PATRÓN:
// - Adapter Pattern: traduce la API concreta del proyecto al contrato domain.
// - Hardening: asegura broadcast + deduplicación defensiva.
// ============================================================================

import '../../core/network/connectivity_service.dart';
import '../../domain/services/sync/connectivity_provider.dart';

// ============================================================================
// IMPLEMENTATION
// ============================================================================

/// Adapter que conecta [ConnectivityService] (core) con [ConnectivityProvider]
/// (domain contract) para inyección en SyncEngineService.
///
/// Hardening:
/// - Garantiza broadcast (contrato domain), incluso si el core cambia a futuro.
/// - Deduplicación defensiva con distinct() (no depende del core).
class ConnectivityServiceAdapter implements ConnectivityProvider {
  final ConnectivityService _service;

  ConnectivityServiceAdapter({required ConnectivityService service})
      : _service = service;

  @override
  Future<bool> get isConnected => Future.value(_service.isOnline);

  @override
  Stream<bool> get onConnectivityChanged =>
      _service.online$.asBroadcastStream().distinct();
}
