// ============================================================================
// lib/application/core_common/use_cases/start_operational_request.dart
// START OPERATIONAL REQUEST — F5 Hito 11 (alineado a backend canónico)
// ============================================================================
// QUÉ HACE:
//   - Inicia una OperationalRequest real creando su CoordinationFlow
//     contenedor vía POST /v1/coordination-flows en Core API.
//   - Retorna el resultado completo (flow + request) tras hidratarlo en
//     cache local (Isar).
//
// QUÉ NO HACE:
//   - NO crea la Request localmente: el cliente NO es fuente de verdad tras
//     la inversión de D4. Core API crea el par flow+request atómicamente.
//   - NO fuerza id, createdBy ni sourceWorkspaceId: los deriva el backend
//     del Firebase ID token activo.
//   - NO envía la Request (queda en draft). El envío es camino posterior.
//
// SEMÁNTICA DE ERRORES:
//   - title vacío → ArgumentError (pre-HTTP).
//   - Errores tipados del DS (Network/Unauthorized/Server/BadRequest) y
//     404 RELATIONSHIP_NOT_FOUND propagan al caller.
//   - Si el HTTP falla, NO hay persistencia local (consistencia fuerte).
// ============================================================================

import '../../../domain/entities/core_common/operational_relationship_entity.dart';
import '../../../domain/repositories/core_common/coordination_flow_repository.dart';

class StartOperationalRequest {
  final CoordinationFlowRepository _repo;

  const StartOperationalRequest({required CoordinationFlowRepository repo})
      : _repo = repo;

  /// Crea un CoordinationFlow draft con su primera OperationalRequest draft.
  /// Retorna el resultado tras hidratarlo en cache local.
  ///
  /// [createdBy] recibido por compatibilidad con el caller actual; NO se envía
  /// al backend (el backend lo deriva del JWT). Queda como no-op.
  Future<StartCoordinationFlowResult> execute({
    required OperationalRelationshipEntity relationship,
    required String createdBy,
    required String title,
    String? summary,
  }) {
    return _repo.startCoordinationFlow(
      relationshipId: relationship.id,
      title: title,
      summary: summary,
    );
  }
}
