// ============================================================================
// lib/presentation/view_models/network/network_actor_vm.dart
// NETWORK ACTOR VM — Contrato base para actores de "Mi red operativa"
//
// QUÉ HACE:
// - Define el contrato mínimo que todo actor de la red operativa debe cumplir.
// - Provee [ActorType] para tipar los actores sin exponerlos en UI hasta que
//   existan datos reales.
//
// QUÉ NO HACE:
// - No persiste datos ni accede a Isar/Firebase.
// - No contiene lógica de negocio ni de UI.
//
// PRINCIPIOS:
// - Sprint 1 implementa solo [ActorType.owner] (Propietarios).
// - Arrendatarios, conductores, proveedores, etc. se añaden en Sprint 2+
//   implementando esta misma interfaz con su propio VM y fuente de datos.
// - El enum ActorType es la única referencia interna al tipo — no exponer
//   en UI actores sin datos reales.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Sprint 1 módulo "Mi red operativa" — Propietarios.
// ============================================================================

/// Tipos de actor en la red operativa del administrador.
///
/// Solo [owner] tiene implementación completa en Sprint 1.
/// Los demás valores están declarados para tipar el contrato sin exponer UI.
enum ActorType {
  owner,
  tenant,
  driver,
  client,
  provider,
  technician,
  other,
}

/// Contrato base para cualquier actor de "Mi red operativa".
///
/// Cada actor (Propietario, Arrendatario, Conductor, etc.) implementa
/// esta interfaz con su propio [actorKey] de deduplicación.
abstract class NetworkActorVm {
  /// Clave única de deduplicación del actor.
  /// Para propietarios: documento normalizado (trim + lowercase).
  String get actorKey;

  /// Nombre visible en la UI.
  String get displayName;

  /// Tipo de actor — usado internamente para routing y lógica de filtrado.
  ActorType get actorType;
}
