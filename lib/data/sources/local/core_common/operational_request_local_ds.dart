// ============================================================================
// lib/data/sources/local/core_common/operational_request_local_ds.dart
// OPERATIONAL REQUEST LOCAL DS — Data Layer / Sources / Local (F3.b)
// ============================================================================
// QUÉ HACE:
//   - Acceso a OperationalRequestModel en Isar.
//   - Queries por Relación (outbox conversacional) y por workspace.
//
// QUÉ NO HACE:
//   - No ejecuta transiciones (motor F2.b lo hace).
//   - No expone deleteById: el cierre va por state='closed'.
//   - No maneja deliveries (RequestDeliveryLocalDataSource).
//
// PRINCIPIOS:
//   - writeTxn atómico.
//   - Ortogonal al estado de la Relación (el motor lo garantiza aguas arriba).
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../models/core_common/operational_request_model.dart';

class OperationalRequestLocalDataSource {
  final Isar _isar;

  OperationalRequestLocalDataSource(this._isar);

  Future<OperationalRequestModel?> getById(String id) async {
    return _isar.operationalRequestModels
        .filter()
        .idEqualTo(id)
        .findFirst();
  }

  Stream<OperationalRequestModel?> watchById(String id) {
    return _isar.operationalRequestModels
        .filter()
        .idEqualTo(id)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  Future<OperationalRequestModel> upsert(
    OperationalRequestModel model,
  ) async {
    return _isar.writeTxn(() async {
      final existing = await _isar.operationalRequestModels
          .filter()
          .idEqualTo(model.id)
          .findFirst();

      final toSave = OperationalRequestModel(
        isarId: existing?.isarId,
        id: model.id,
        sourceWorkspaceId: model.sourceWorkspaceId,
        relationshipId: model.relationshipId,
        requestKindWire: model.requestKindWire,
        stateWire: model.stateWire,
        title: model.title,
        createdBy: model.createdBy,
        originChannelWire: model.originChannelWire,
        createdAt: existing?.createdAt ?? model.createdAt.toUtc(),
        updatedAt: model.updatedAt.toUtc(),
        stateUpdatedAt: model.stateUpdatedAt.toUtc(),
        summary: model.summary,
        payloadJson: model.payloadJson,
        notesSource: model.notesSource,
        sentAt: model.sentAt?.toUtc(),
        respondedAt: model.respondedAt?.toUtc(),
        closedAt: model.closedAt?.toUtc(),
        expiresAt: model.expiresAt?.toUtc(),
      );

      await _isar.operationalRequestModels.put(toSave);
      return toSave;
    });
  }

  Future<List<OperationalRequestModel>> listByRelationship(
    String relationshipId,
  ) async {
    return _isar.operationalRequestModels
        .filter()
        .relationshipIdEqualTo(relationshipId)
        .findAll();
  }

  Stream<List<OperationalRequestModel>> watchByRelationship(
    String relationshipId,
  ) {
    return _isar.operationalRequestModels
        .filter()
        .relationshipIdEqualTo(relationshipId)
        .watch(fireImmediately: true);
  }

  Future<List<OperationalRequestModel>> listByWorkspace(
    String workspaceId,
  ) async {
    return _isar.operationalRequestModels
        .filter()
        .sourceWorkspaceIdEqualTo(workspaceId)
        .findAll();
  }

  Stream<List<OperationalRequestModel>> watchByWorkspace(
    String workspaceId,
  ) {
    return _isar.operationalRequestModels
        .filter()
        .sourceWorkspaceIdEqualTo(workspaceId)
        .watch(fireImmediately: true);
  }
}
