// ============================================================================
// lib/domain/repositories/core_common/coordination_flow_repository.dart
// COORDINATION FLOW REPOSITORY — Core Common v1 (F5 Hito 11)
// ============================================================================
// QUÉ HACE:
//   - Define el contrato del repo de CoordinationFlow para el cliente.
//   - startCoordinationFlow: crea flow + primer OperationalRequest en una
//     transacción server-side (POST /v1/coordination-flows) y retorna la
//     respuesta; el impl hidrata ambas entidades en cache local (Isar).
//
// QUÉ NO HACE:
//   - No expone save(): Core API es fuente de verdad, no se crea flows local.
//   - No expone transiciones de status: el motor vive server-side.
//   - No encola escrituras: start es online-only por diseño (requiere la
//     transacción backend).
//
// PRINCIPIOS:
//   - Los streams/queries usan la cache local hidratada.
// ============================================================================

import '../../entities/core_common/coordination_flow_entity.dart';
import '../../entities/core_common/operational_request_entity.dart';
import '../../entities/core_common/value_objects/coordination_flow_kind.dart';
import '../../entities/core_common/value_objects/request_kind.dart';
import '../../entities/core_common/value_objects/request_origin_channel.dart';

/// Resultado de startCoordinationFlow (espejo del contrato backend).
class StartCoordinationFlowResult {
  final CoordinationFlowEntity flow;
  final OperationalRequestEntity request;

  const StartCoordinationFlowResult({
    required this.flow,
    required this.request,
  });
}

abstract class CoordinationFlowRepository {
  /// Crea un CoordinationFlow + OperationalRequest inicial vía
  /// POST /v1/coordination-flows y hidrata ambas entidades en cache local.
  ///
  /// [title] es obligatorio (trim no vacío).
  /// [originChannel] es metadata: default 'inApp' si se omite. NO influye en
  /// la lógica de dominio, ni server-side ni local.
  ///
  /// Errores:
  /// - 400 INVALID_INPUT (title vacío, DTO inválido).
  /// - 401/403 sin sesión Firebase válida.
  /// - 404 RELATIONSHIP_NOT_FOUND: relationshipId inexistente o cross-tenancy.
  /// - NetworkException / ServerException en fallos de transporte.
  Future<StartCoordinationFlowResult> startCoordinationFlow({
    required String relationshipId,
    required String title,
    String? summary,
    RequestKind? requestKind,
    RequestOriginChannel? originChannel,
    CoordinationFlowKind? flowKind,
  });

  /// Retorna el flow por id desde cache local (null si aún no se ha hidratado).
  Future<CoordinationFlowEntity?> getById(String id);

  /// Stream reactivo del flow por id (cache local).
  Stream<CoordinationFlowEntity?> watchById(String id);

  /// Lista flows locales asociados a una Relación.
  Future<List<CoordinationFlowEntity>> listByRelationship(String relationshipId);

  /// Stream reactivo de flows por Relación.
  Stream<List<CoordinationFlowEntity>> watchByRelationship(
    String relationshipId,
  );
}
