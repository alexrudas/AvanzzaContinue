// ============================================================================
// lib/data/sources/local/core_common/match_candidate_local_ds.dart
// MATCH CANDIDATE LOCAL DS — Data Layer / Sources / Local (F3.b)
// ============================================================================
// QUÉ HACE:
//   - Cache local de MatchCandidateModel expuestos al workspace.
//   - Queries para UI de resolución + hook D8 de colisiones marcadas.
//
// QUÉ NO HACE:
//   - No ejecuta el matcher (vive en NestJS).
//   - No expone 'detectedInternal' externos: el datasource remoto (F3.c)
//     solo replica al cliente los estados visibles (exposedToWorkspace,
//     confirmedIntoRelationship).
//   - No resuelve colisiones: los casos de uso F4 gestionan la resolución.
//
// PRINCIPIOS:
//   - writeTxn atómico en upsert.
//   - Las queries filtran por sourceWorkspaceId + state wire-stable.
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../../domain/entities/core_common/value_objects/match_candidate_state.dart';
import '../../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../models/core_common/match_candidate_model.dart';

class MatchCandidateLocalDataSource {
  final Isar _isar;

  MatchCandidateLocalDataSource(this._isar);

  Future<MatchCandidateModel?> getById(String id) async {
    return _isar.matchCandidateModels.filter().idEqualTo(id).findFirst();
  }

  Future<MatchCandidateModel> upsert(MatchCandidateModel model) async {
    return _isar.writeTxn(() async {
      final existing = await _isar.matchCandidateModels
          .filter()
          .idEqualTo(model.id)
          .findFirst();

      final toSave = MatchCandidateModel(
        isarId: existing?.isarId,
        id: model.id,
        sourceWorkspaceId: model.sourceWorkspaceId,
        localKindWire: model.localKindWire,
        localId: model.localId,
        platformActorId: model.platformActorId,
        matchedKeyTypeWire: model.matchedKeyTypeWire,
        matchedKeyValue: model.matchedKeyValue,
        trustLevelWire: model.trustLevelWire,
        stateWire: model.stateWire,
        detectedAt: existing?.detectedAt ?? model.detectedAt.toUtc(),
        updatedAt: model.updatedAt.toUtc(),
        exposedAt: model.exposedAt?.toUtc(),
        dismissedAt: model.dismissedAt?.toUtc(),
        confirmedAt: model.confirmedAt?.toUtc(),
        resultingRelationshipId: model.resultingRelationshipId,
        collisionKindWires: model.collisionKindWires,
        isConflictMarked: model.isConflictMarked,
        isCriticalConflict: model.isCriticalConflict,
      );

      await _isar.matchCandidateModels.put(toSave);
      return toSave;
    });
  }

  Future<List<MatchCandidateModel>> listExposedByWorkspace(
    String workspaceId,
  ) async {
    return _isar.matchCandidateModels
        .filter()
        .sourceWorkspaceIdEqualTo(workspaceId)
        .stateWireEqualTo(MatchCandidateState.exposedToWorkspace.wireName)
        .findAll();
  }

  Stream<List<MatchCandidateModel>> watchExposedByWorkspace(
    String workspaceId,
  ) {
    return _isar.matchCandidateModels
        .filter()
        .sourceWorkspaceIdEqualTo(workspaceId)
        .stateWireEqualTo(MatchCandidateState.exposedToWorkspace.wireName)
        .watch(fireImmediately: true);
  }

  Future<List<MatchCandidateModel>> listByLocal(
    String workspaceId,
    TargetLocalKind localKind,
    String localId,
  ) async {
    return _isar.matchCandidateModels
        .filter()
        .sourceWorkspaceIdEqualTo(workspaceId)
        .localKindWireEqualTo(localKind.wireName)
        .localIdEqualTo(localId)
        .findAll();
  }

  /// Elimina en un único writeTxn los candidatos cuyo business id (backendId)
  /// esté en [backendIds]. Usado por el diff stale del repo: tras un probe,
  /// los MCs locales del mismo (workspace, local) que no vinieron en la
  /// respuesta son eliminados puntualmente (NO wipe global).
  Future<int> deleteByBackendIds(List<String> backendIds) async {
    if (backendIds.isEmpty) return 0;
    return _isar.writeTxn(() async {
      var deleted = 0;
      for (final id in backendIds) {
        final existing = await _isar.matchCandidateModels
            .filter()
            .idEqualTo(id)
            .findFirst();
        if (existing == null || existing.isarId == null) continue;
        final ok = await _isar.matchCandidateModels.delete(existing.isarId!);
        if (ok) deleted++;
      }
      return deleted;
    });
  }

  Future<List<MatchCandidateModel>> listWithConflictsByWorkspace(
    String workspaceId,
  ) async {
    return _isar.matchCandidateModels
        .filter()
        .sourceWorkspaceIdEqualTo(workspaceId)
        .isConflictMarkedEqualTo(true)
        .findAll();
  }

  Stream<List<MatchCandidateModel>> watchWithConflictsByWorkspace(
    String workspaceId,
  ) {
    return _isar.matchCandidateModels
        .filter()
        .sourceWorkspaceIdEqualTo(workspaceId)
        .isConflictMarkedEqualTo(true)
        .watch(fireImmediately: true);
  }
}
