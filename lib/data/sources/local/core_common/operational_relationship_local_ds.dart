// ============================================================================
// lib/data/sources/local/core_common/operational_relationship_local_ds.dart
// OPERATIONAL RELATIONSHIP LOCAL DS — Data Layer / Sources / Local (F3.b)
// ============================================================================
// QUÉ HACE:
//   - Acceso a OperationalRelationshipModel en Isar.
//   - Queries por target local, por PlatformActor, por workspace + state.
//
// QUÉ NO HACE:
//   - No ejecuta transiciones: el motor (F2.a) es quien decide. El datasource
//     solo persiste el resultado via upsert.
//   - No expone deleteById: el contrato prohíbe borrado físico operativo.
//     El cierre va por máquina de estados (state='cerrada').
//   - No mapea a Entity (repo en F3.c).
//
// PRINCIPIOS:
//   - writeTxn atómico en upsert.
//   - Los enums viajan como wireName (String); las queries filtran por String.
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../models/core_common/operational_relationship_model.dart';

class OperationalRelationshipLocalDataSource {
  final Isar _isar;

  OperationalRelationshipLocalDataSource(this._isar);

  Future<OperationalRelationshipModel?> getById(String id) async {
    return _isar.operationalRelationshipModels
        .filter()
        .idEqualTo(id)
        .findFirst();
  }

  Stream<OperationalRelationshipModel?> watchById(String id) {
    return _isar.operationalRelationshipModels
        .filter()
        .idEqualTo(id)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  Future<OperationalRelationshipModel> upsert(
    OperationalRelationshipModel model,
  ) async {
    return _isar.writeTxn(() async {
      final existing = await _isar.operationalRelationshipModels
          .filter()
          .idEqualTo(model.id)
          .findFirst();

      final toSave = OperationalRelationshipModel(
        isarId: existing?.isarId,
        id: model.id,
        sourceWorkspaceId: model.sourceWorkspaceId,
        targetLocalKindWire: model.targetLocalKindWire,
        targetLocalId: model.targetLocalId,
        stateWire: model.stateWire,
        createdAt: existing?.createdAt ?? model.createdAt.toUtc(),
        updatedAt: model.updatedAt.toUtc(),
        stateUpdatedAt: model.stateUpdatedAt.toUtc(),
        relationshipKindWire: model.relationshipKindWire,
        targetPlatformActorId: model.targetPlatformActorId,
        matchTrustLevelWire: model.matchTrustLevelWire,
        suspensionReasonWire: model.suspensionReasonWire,
        activatedUnilaterallyAt: model.activatedUnilaterallyAt?.toUtc(),
        linkedAt: model.linkedAt?.toUtc(),
        suspendedAt: model.suspendedAt?.toUtc(),
        closedAt: model.closedAt?.toUtc(),
        lastInvitationId: model.lastInvitationId,
      );

      await _isar.operationalRelationshipModels.put(toSave);
      return toSave;
    });
  }

  Future<List<OperationalRelationshipModel>> listByWorkspace(
    String workspaceId,
  ) async {
    return _isar.operationalRelationshipModels
        .filter()
        .sourceWorkspaceIdEqualTo(workspaceId)
        .findAll();
  }

  Stream<List<OperationalRelationshipModel>> watchByWorkspace(
    String workspaceId,
  ) {
    return _isar.operationalRelationshipModels
        .filter()
        .sourceWorkspaceIdEqualTo(workspaceId)
        .watch(fireImmediately: true);
  }

  Future<OperationalRelationshipModel?> findByTarget(
    String workspaceId,
    TargetLocalKind targetLocalKind,
    String targetLocalId,
  ) async {
    return _isar.operationalRelationshipModels
        .filter()
        .sourceWorkspaceIdEqualTo(workspaceId)
        .targetLocalKindWireEqualTo(targetLocalKind.wireName)
        .targetLocalIdEqualTo(targetLocalId)
        .findFirst();
  }

  /// Watch reactivo del primer registro que coincide con el target local.
  /// Emite null cuando no hay Relación para ese target.
  Stream<OperationalRelationshipModel?> watchByTarget(
    String workspaceId,
    TargetLocalKind targetLocalKind,
    String targetLocalId,
  ) {
    return _isar.operationalRelationshipModels
        .filter()
        .sourceWorkspaceIdEqualTo(workspaceId)
        .targetLocalKindWireEqualTo(targetLocalKind.wireName)
        .targetLocalIdEqualTo(targetLocalId)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  Future<List<OperationalRelationshipModel>> findByPlatformActor(
    String workspaceId,
    String platformActorId,
  ) async {
    return _isar.operationalRelationshipModels
        .filter()
        .sourceWorkspaceIdEqualTo(workspaceId)
        .targetPlatformActorIdEqualTo(platformActorId)
        .findAll();
  }
}
