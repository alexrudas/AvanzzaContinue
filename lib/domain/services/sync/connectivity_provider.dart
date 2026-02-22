// ============================================================================
// lib/domain/services/sync/connectivity_provider.dart
// CONNECTIVITY PROVIDER — Enterprise Ultra Pro (Domain Contract)
//
// QUÉ HACE:
// - Define contrato domain-puro para observar conectividad de red.
// - Permite al SyncEngineService pausar/reanudar dispatch según estado de red.
//
// QUÉ NO HACE:
// - Implementación (eso es Infrastructure: connectivity_plus, platform channels, etc.).
// - Lógica de retry / backoff.
// - DateTime.now() interno.
// - Logs / prints / assert.
// - Conocer Firestore / HTTP / plugins Flutter.
//
// SEMÁNTICA:
// - true  → dispositivo online (al menos una ruta de red disponible).
// - false → dispositivo offline (sin conectividad conocida).
//
// CONSUMIDORES:
// - SyncEngineService: se suscribe a onConnectivityChanged y consulta isConnected
//   para decidir si ejecutar dispatcher.dispatchEligibleBatch().
// ============================================================================

// ============================================================================
// INTERFACE — DOMAIN PURE
// ============================================================================

/// Contrato para observar el estado de conectividad de red.
///
/// Interface domain pura. Sin dependencias de plataforma.
/// La implementación concreta vive en Infrastructure y usa el plugin
/// adecuado (connectivity_plus, NetworkInfo, etc.).
///
/// El SyncEngineService usa este contrato para:
/// - Consultar estado actual antes de ejecutar un batch.
/// - Suscribirse a cambios para trigger de re-sync (offline→online).
///
/// Invariantes:
/// - [isConnected] refleja el último estado conocido.
/// - [onConnectivityChanged] emite cada vez que cambia el estado.
/// - El stream NO debe emitir valores duplicados consecutivos
///   (la implementación debe deduplicar si el plugin no lo hace).
/// - El stream debe ser broadcast (múltiples listeners permitidos).
abstract class ConnectivityProvider {
  /// Estado actual de conectividad.
  ///
  /// Retorna true si hay al menos una ruta de red disponible.
  /// Retorna false si no hay conectividad conocida.
  Future<bool> get isConnected;

  /// Stream de cambios de conectividad.
  ///
  /// Emite true cuando el dispositivo pasa a online.
  /// Emite false cuando el dispositivo pasa a offline.
  ///
  /// Contrato:
  /// - Broadcast stream (múltiples suscriptores).
  /// - Sin duplicados consecutivos.
  /// - Emite el estado actual al suscribirse (opcional, depende de la impl).
  Stream<bool> get onConnectivityChanged;
}

// ============================================================================
// CHECKLIST FINAL
// ============================================================================
// [x] Interface domain pura: ConnectivityProvider
// [x] 2 miembros: isConnected (Future<bool>), onConnectivityChanged (Stream<bool>)
// [x] Semántica: true=online, false=offline
// [x] Sin duplicados consecutivos (contrato)
// [x] Broadcast stream (contrato)
// [x] CERO implementación (solo contrato)
// [x] CERO dependencias externas
// [x] CERO dependencias Flutter / plugins
// [x] CERO DateTime.now()
// [x] CERO logs / prints / assert
// [x] Domain puro — production-ready FASE 6
