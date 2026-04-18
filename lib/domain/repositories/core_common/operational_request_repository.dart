// ============================================================================
// lib/domain/repositories/core_common/operational_request_repository.dart
// OPERATIONAL REQUEST REPOSITORY — Core Common v1 / Contrato (F5 Hito 12)
// ============================================================================
// Qué hace:
//   - Define el contrato de CACHE LOCAL + consulta de OperationalRequest.
//   - Único punto de escritura: hydrateFromRemote (local-only).
//   - Consultas scoped por workspace/relationship para UI offline-first.
//
// Qué NO hace:
//   - No crea Requests: Core API es fuente de verdad (POST /v1/coordination-flows).
//   - No ejecuta transiciones (las gestiona server-side).
//   - No maneja deliveries: los expone RequestDeliveryRepository.
//   - NO expone save() ni deleteById.
//
// Principios:
//   - Core API es SSOT; este repo es cache Isar.
//   - Scoped por sourceWorkspaceId.
//   - NO-DIRECTORIO BY DESIGN: ningún método permite listar Requests fuera
//     del workspace emisor.
//
// Borrado controlado:
//   - Eliminación física restringida a procesos de mantenimiento; NO existe
//     en el contrato del flujo operativo.
//   - El cierre se realiza server-side (state='closed'); el cliente solo
//     refleja el cambio vía hydrateFromRemote.
// ============================================================================

import '../../entities/core_common/operational_request_entity.dart';

/// Contrato de cache local + consulta de OperationalRequest.
/// Scoped por sourceWorkspaceId.
///
/// NO incluye save() ni deleteById: la creación y el cierre son server-side
/// (Core API). El cliente solo cachea el estado vía hydrateFromRemote.
abstract class OperationalRequestRepository {
  /// Hidrata localmente una Request recibida desde backend (POST
  /// /v1/coordination-flows o el futuro resolve). Local-only: NO encola
  /// Firestore ni dispara mirror service. El backend ya es la fuente de
  /// verdad.
  Future<void> hydrateFromRemote(OperationalRequestEntity request);

  /// Retorna la entidad por id o null si no existe.
  Future<OperationalRequestEntity?> getById(String id);

  /// Stream reactivo por id. Emite null si se pierde visibilidad.
  Stream<OperationalRequestEntity?> watchById(String id);

  /// Lista todas las Requests ancladas a una Relación.
  Future<List<OperationalRequestEntity>> listByRelationship(
    String relationshipId,
  );

  /// Stream reactivo de Requests de una Relación.
  Stream<List<OperationalRequestEntity>> watchByRelationship(
    String relationshipId,
  );

  /// Lista todas las Requests emitidas por el workspace (outbox view).
  Future<List<OperationalRequestEntity>> listByWorkspace(String workspaceId);

  /// Stream reactivo de Requests del workspace.
  Stream<List<OperationalRequestEntity>> watchByWorkspace(String workspaceId);
}
