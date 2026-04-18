// ============================================================================
// lib/data/repositories/core_common/operational_relationship_repository_impl.dart
// OPERATIONAL RELATIONSHIP REPOSITORY IMPL — Data Layer (F5 Hito 13)
// ============================================================================
// QUÉ HACE:
//   - Implementa OperationalRelationshipRepository como CACHE LOCAL (Isar)
//     de las Relaciones canónicas que viven en Core API.
//   - hydrateFromRemote: única vía de escritura (invocada tras POST
//     /v1/.../resolve confirm). Local-only.
//   - Lecturas y streams sirven desde Isar para UI offline-first.
//
// QUÉ NO HACE:
//   - NO crea Relaciones localmente: Core API es SSOT.
//   - NO encola Firestore ni dispara mirror services. Esos caminos se
//     eliminaron junto con save() en F5 Hito 13.
//   - NO expone deleteById.
// ============================================================================

import '../../../domain/entities/core_common/operational_relationship_entity.dart';
import '../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../domain/repositories/core_common/operational_relationship_repository.dart';
import '../../models/core_common/operational_relationship_model.dart';
import '../../sources/local/core_common/operational_relationship_local_ds.dart';

class OperationalRelationshipRepositoryImpl
    implements OperationalRelationshipRepository {
  final OperationalRelationshipLocalDataSource _local;

  OperationalRelationshipRepositoryImpl({
    required OperationalRelationshipLocalDataSource local,
  }) : _local = local;

  @override
  Future<void> hydrateFromRemote(
    OperationalRelationshipEntity relationship,
  ) async {
    // Local-only: la Relación ya existe en el backend (creada por /resolve
    // confirm). El cliente solo cachea para UI offline-first.
    await _local.upsert(OperationalRelationshipModel.fromEntity(relationship));
  }

  @override
  Future<OperationalRelationshipEntity?> getById(String id) async {
    final m = await _local.getById(id);
    return m?.toEntity();
  }

  @override
  Stream<OperationalRelationshipEntity?> watchById(String id) {
    return _local.watchById(id).map((m) => m?.toEntity());
  }

  @override
  Future<List<OperationalRelationshipEntity>> listByWorkspace(
    String workspaceId,
  ) async {
    final models = await _local.listByWorkspace(workspaceId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<OperationalRelationshipEntity>> watchByWorkspace(
    String workspaceId,
  ) {
    return _local
        .watchByWorkspace(workspaceId)
        .map((list) => list.map((m) => m.toEntity()).toList());
  }

  @override
  Future<OperationalRelationshipEntity?> findByTarget(
    String workspaceId,
    TargetLocalKind targetLocalKind,
    String targetLocalId,
  ) async {
    final m = await _local.findByTarget(
      workspaceId,
      targetLocalKind,
      targetLocalId,
    );
    return m?.toEntity();
  }

  @override
  Stream<OperationalRelationshipEntity?> watchByTarget(
    String workspaceId,
    TargetLocalKind targetLocalKind,
    String targetLocalId,
  ) {
    return _local
        .watchByTarget(workspaceId, targetLocalKind, targetLocalId)
        .map((m) => m?.toEntity());
  }

  @override
  Future<List<OperationalRelationshipEntity>> findByPlatformActor(
    String workspaceId,
    String platformActorId,
  ) async {
    final models =
        await _local.findByPlatformActor(workspaceId, platformActorId);
    return models.map((m) => m.toEntity()).toList();
  }
}
