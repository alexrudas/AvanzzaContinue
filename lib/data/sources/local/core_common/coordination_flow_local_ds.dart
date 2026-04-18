// ============================================================================
// lib/data/sources/local/core_common/coordination_flow_local_ds.dart
// COORDINATION FLOW LOCAL DS — Cache Isar (F5 Hito 11)
// ============================================================================
// QUÉ HACE:
//   - Persiste CoordinationFlowModel en Isar como cache offline.
//   - Expone upsert + getById + listByRelationship + watchById para la UI.
//
// QUÉ NO HACE:
//   - No es fuente de verdad: el backend la tiene.
//   - No expone delete: los flows se cierran server-side por estado.
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../models/core_common/coordination_flow_model.dart';

class CoordinationFlowLocalDataSource {
  final Isar _isar;

  CoordinationFlowLocalDataSource(this._isar);

  Future<CoordinationFlowModel?> getById(String id) async {
    return _isar.coordinationFlowModels.filter().idEqualTo(id).findFirst();
  }

  Stream<CoordinationFlowModel?> watchById(String id) {
    return _isar.coordinationFlowModels
        .filter()
        .idEqualTo(id)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  Future<CoordinationFlowModel> upsert(CoordinationFlowModel model) async {
    return _isar.writeTxn(() async {
      final existing = await _isar.coordinationFlowModels
          .filter()
          .idEqualTo(model.id)
          .findFirst();

      final toSave = CoordinationFlowModel(
        isarId: existing?.isarId,
        id: model.id,
        sourceWorkspaceId: model.sourceWorkspaceId,
        relationshipId: model.relationshipId,
        startedBy: model.startedBy,
        flowKindWire: model.flowKindWire,
        statusWire: model.statusWire,
        statusUpdatedAt: model.statusUpdatedAt.toUtc(),
        createdAt: existing?.createdAt ?? model.createdAt.toUtc(),
        updatedAt: model.updatedAt.toUtc(),
        startedAt: model.startedAt?.toUtc(),
        completedAt: model.completedAt?.toUtc(),
        cancelledAt: model.cancelledAt?.toUtc(),
      );

      await _isar.coordinationFlowModels.put(toSave);
      return toSave;
    });
  }

  Future<List<CoordinationFlowModel>> listByRelationship(
    String relationshipId,
  ) async {
    return _isar.coordinationFlowModels
        .filter()
        .relationshipIdEqualTo(relationshipId)
        .findAll();
  }

  Stream<List<CoordinationFlowModel>> watchByRelationship(
    String relationshipId,
  ) {
    return _isar.coordinationFlowModels
        .filter()
        .relationshipIdEqualTo(relationshipId)
        .watch(fireImmediately: true);
  }
}
