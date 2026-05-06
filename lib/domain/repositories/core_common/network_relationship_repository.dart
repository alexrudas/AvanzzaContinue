// ============================================================================
// lib/domain/repositories/core_common/network_relationship_repository.dart
// NetworkRelationshipRepository — interfaz (hito 5b)
// ============================================================================
// QUÉ HACE:
//   - Contrato del CRUD operativo de OperationalRelationship contra core-api.
//   - Se llama "network" para NO colisionar con OperationalRelationshipRepository
//     preexistente, que sirve al sync con Firestore (distinto caso de uso).
//
// QUÉ NO HACE:
//   - No crea relationships: el nacimiento es implícito vía match-candidate
//     resolve (ADR §2.8). Solo list / findById / suspend / reactivate / close.
//
// See docs/adr/0001-actor-canon.md §5 (CRUD hito 3).
// ============================================================================

import '../../entities/core_common/operational_relationship_entity.dart';
import '../../entities/core_common/value_objects/relationship_state.dart';
import '../../entities/core_common/value_objects/relationship_suspension_reason.dart';
import '../../entities/core_common/value_objects/target_local_kind.dart';

class OperationalRelationshipPage {
  final List<OperationalRelationshipEntity> items;
  final String? nextCursor;
  const OperationalRelationshipPage({required this.items, this.nextCursor});
}

abstract class NetworkRelationshipRepository {
  /// Lista relationships del workspace con filtros combinables.
  Future<OperationalRelationshipPage> list({
    RelationshipState? state,
    TargetLocalKind? localKind,
    String? localId,
    String? cursor,
    int? limit,
  });

  /// Detalle con tenancy. Lanza BadRequestException(code=RELATIONSHIP_NOT_FOUND).
  Future<OperationalRelationshipEntity> findById(String id);

  /// Transición vinculada|suspendida → suspendida con reason obligatoria.
  /// Idempotente sobre suspendida (actualiza reason si difiere).
  /// Prohibido desde cerrada → 409 RELATIONSHIP_INVALID_TRANSITION.
  Future<OperationalRelationshipEntity> suspend(
    String id,
    RelationshipSuspensionReason reason,
  );

  /// Transición suspendida → vinculada. Idempotente sobre vinculada.
  Future<OperationalRelationshipEntity> reactivate(String id);

  /// Transición → cerrada (terminal). reason opcional (default userRequested
  /// del lado backend). Idempotente sobre cerrada.
  Future<OperationalRelationshipEntity> close(
    String id, {
    RelationshipSuspensionReason? reason,
  });
}
