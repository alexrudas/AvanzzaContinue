// ============================================================================
// lib/data/repositories/core_common/operational_request_repository_impl.dart
// OPERATIONAL REQUEST REPOSITORY IMPL — Data Layer (F5 Hito 12)
// ============================================================================
// QUÉ HACE:
//   - Implementa OperationalRequestRepository como CACHE LOCAL (Isar) de las
//     Requests canónicas que viven en Core API.
//   - hydrateFromRemote: única vía de escritura. Se invoca tras POST
//     /v1/coordination-flows o POST /v1/.../resolve (confirm). Local-only.
//   - Lecturas (getById, listByRelationship, listByWorkspace + sus streams)
//     sirven desde Isar para UI offline-first.
//
// QUÉ NO HACE:
//   - NO crea Requests localmente: Core API es SSOT tras la inversión de D4.
//   - NO encola escrituras a Firestore ni dispara mirror service. Esos
//     caminos fueron eliminados con save() en F5 Hito 12 (cero doble camino).
//   - NO expone deleteById.
// ============================================================================

import '../../../domain/entities/core_common/operational_request_entity.dart';
import '../../../domain/repositories/core_common/operational_request_repository.dart';
import '../../models/core_common/operational_request_model.dart';
import '../../sources/local/core_common/operational_request_local_ds.dart';

class OperationalRequestRepositoryImpl implements OperationalRequestRepository {
  final OperationalRequestLocalDataSource _local;

  OperationalRequestRepositoryImpl({
    required OperationalRequestLocalDataSource local,
  }) : _local = local;

  @override
  Future<void> hydrateFromRemote(OperationalRequestEntity request) async {
    // Local-only: la Request ya fue creada server-side en la transacción de
    // start/resolve. No se encola Firestore (el backend es fuente de verdad)
    // ni se dispara mirror (sería circular).
    await _local.upsert(OperationalRequestModel.fromEntity(request));
  }

  @override
  Future<OperationalRequestEntity?> getById(String id) async {
    final m = await _local.getById(id);
    return m?.toEntity();
  }

  @override
  Stream<OperationalRequestEntity?> watchById(String id) {
    return _local.watchById(id).map((m) => m?.toEntity());
  }

  @override
  Future<List<OperationalRequestEntity>> listByRelationship(
    String relationshipId,
  ) async {
    final models = await _local.listByRelationship(relationshipId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<OperationalRequestEntity>> watchByRelationship(
    String relationshipId,
  ) {
    return _local
        .watchByRelationship(relationshipId)
        .map((list) => list.map((m) => m.toEntity()).toList());
  }

  @override
  Future<List<OperationalRequestEntity>> listByWorkspace(
    String workspaceId,
  ) async {
    final models = await _local.listByWorkspace(workspaceId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<OperationalRequestEntity>> watchByWorkspace(String workspaceId) {
    return _local
        .watchByWorkspace(workspaceId)
        .map((list) => list.map((m) => m.toEntity()).toList());
  }
}
