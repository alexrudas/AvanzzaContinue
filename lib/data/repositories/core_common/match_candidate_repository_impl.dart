// ============================================================================
// lib/data/repositories/core_common/match_candidate_repository_impl.dart
// MATCH CANDIDATE REPOSITORY IMPL — Data Layer (F3.c + F5 Hito 4)
// ============================================================================
// QUÉ HACE:
//   - Implementa MatchCandidateRepository.
//   - save: hidratación pura (solo local, sin enqueue).
//   - submitResolution (F5 Hito 4): SÍNCRONO. HTTP directo contra NestJS,
//     hidrata el MatchCandidate actualizado Y la OperationalRelationship
//     devuelta (si confirm) en local antes de retornar.
//
// QUÉ NO HACE:
//   - No ejecuta el matcher (vive en NestJS).
//   - No va a Firestore para MatchCandidate: vive solo en Isar + NestJS.
//   - No decide el state del candidato: el caller lo transiciona antes.
//   - NO encola submitResolution: la transacción backend requiere online;
//     si falla, propaga la excepción al caller (UI decide UX).
//
// Enterprise Notes:
//   - La Relación se hidrata vía OperationalRelationshipRepository.hydrateFromRemote
//     (local-only). El backend ya la creó transaccionalmente; no se re-escribe
//     a Firestore ni se vuelve a disparar el mirror NestJS (sería circular).
// ============================================================================

import '../../../domain/entities/core_common/match_candidate_entity.dart';
import '../../../domain/entities/core_common/value_objects/normalized_key.dart';
import '../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../domain/repositories/core_common/match_candidate_repository.dart';
import '../../../domain/repositories/core_common/operational_relationship_repository.dart';
import '../../models/core_common/match_candidate_model.dart';
import '../../sources/local/core_common/match_candidate_local_ds.dart';
import '../../sources/remote/core_common/match_candidate_nestjs_ds.dart';

class MatchCandidateRepositoryImpl implements MatchCandidateRepository {
  final MatchCandidateLocalDataSource _local;
  final MatchCandidateNestJsDataSource _remote;
  final OperationalRelationshipRepository _relationshipRepo;

  MatchCandidateRepositoryImpl({
    required MatchCandidateLocalDataSource local,
    required MatchCandidateNestJsDataSource remote,
    required OperationalRelationshipRepository relationshipRepo,
  })  : _local = local,
        _remote = remote,
        _relationshipRepo = relationshipRepo;

  @override
  Future<void> save(MatchCandidateEntity candidate) async {
    // Hidratación pura desde backend: solo local, sin enqueue.
    await _local.upsert(MatchCandidateModel.fromEntity(candidate));
  }

  @override
  Future<ResolveMatchCandidateResult> submitResolution(
    MatchCandidateEntity candidate,
  ) async {
    // F5 Hito 4: síncrono. El backend crea/reutiliza la OperationalRelationship
    // dentro de la misma transacción que actualiza el MC. Si el HTTP falla,
    // la excepción tipada del DS propaga — el caller NO ve el MC actualizado
    // localmente (consistencia local↔remoto por diseño).
    final result = await _remote.submitResolution(candidate);

    // Orden de hidratación local:
    //   1. Relación primero (si existe): asegura que cuando el stream emita
    //      el MC con resultingRelationshipId, la Relación ya esté resolvible.
    //   2. MC después con los campos devueltos por el backend (confirmedAt/
    //      dismissedAt/resultingRelationshipId canónicos del servidor).
    final relationship = result.relationship;
    if (relationship != null) {
      await _relationshipRepo.hydrateFromRemote(relationship);
    }
    await _local.upsert(MatchCandidateModel.fromEntity(result.matchCandidate));

    return result;
  }

  @override
  Future<List<MatchCandidateEntity>> triggerProbe({
    required String workspaceId,
    required TargetLocalKind localKind,
    required String localId,
    required List<NormalizedKey> probes,
  }) async {
    // Guardrail F5: el DS remoto propaga excepciones tipadas
    // (NetworkException / UnauthorizedException / ServerException /
    // BadRequestException). El repo NO captura, NO reintenta, NO encola.
    // El caso de uso aguas arriba decide UX (silent fail + log en v1);
    // el siguiente update del registro local volverá a disparar el probe
    // naturalmente.
    final affected = await _remote.probe(
      localKind: localKind,
      localId: localId,
      probes: probes,
    );

    // ----------------------------------------------------------------------
    // DIFF STALE POR SCOPE DEL LOCAL (NO wipe global):
    // los MCs locales para este (workspace, localKind, localId) que NO
    // vinieron en la respuesta del backend son stale y se eliminan
    // puntualmente por ids. El scope está acotado al local afectado —
    // MCs de otros locales o de otros workspaces NO se tocan.
    // ----------------------------------------------------------------------
    final affectedBackendIds = affected.map((e) => e.id).toSet();
    final currentLocal =
        await _local.listByLocal(workspaceId, localKind, localId);
    final staleBackendIds = <String>[];
    for (final mc in currentLocal) {
      if (!affectedBackendIds.contains(mc.id)) {
        staleBackendIds.add(mc.id);
      }
    }
    if (staleBackendIds.isNotEmpty) {
      await _local.deleteByBackendIds(staleBackendIds);
    }

    // Persistencia local: upsert por cada candidato afectado. El índice
    // unique sobre backendId (MatchCandidateModel.id) descarta duplicados.
    for (final cand in affected) {
      await _local.upsert(MatchCandidateModel.fromEntity(cand));
    }
    return affected;
  }

  @override
  Future<List<MatchCandidateEntity>> refreshExposedByWorkspace(
    String workspaceId,
  ) async {
    // El backend solo retorna state=exposedToWorkspace (no-directorio).
    // Si un MC dejó de estar expuesto remotamente, su copia local puede quedar
    // "stale" hasta que un nuevo probe / refresh actualice su state. v1 acepta
    // esa stale-window; v1.x puede añadir delete-on-refresh cuando el DS local
    // exponga un método delete.
    final exposed = await _remote.fetchExposedByWorkspace(workspaceId);
    for (final cand in exposed) {
      await _local.upsert(MatchCandidateModel.fromEntity(cand));
    }
    return exposed;
  }

  @override
  Future<MatchCandidateEntity?> getById(String id) async {
    final m = await _local.getById(id);
    return m?.toEntity();
  }

  @override
  Future<List<MatchCandidateEntity>> listExposedByWorkspace(
    String workspaceId,
  ) async {
    final models = await _local.listExposedByWorkspace(workspaceId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<MatchCandidateEntity>> watchExposedByWorkspace(
    String workspaceId,
  ) {
    return _local
        .watchExposedByWorkspace(workspaceId)
        .map((list) => list.map((m) => m.toEntity()).toList());
  }

  @override
  Future<List<MatchCandidateEntity>> listByLocal(
    String workspaceId,
    TargetLocalKind localKind,
    String localId,
  ) async {
    final models = await _local.listByLocal(workspaceId, localKind, localId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<MatchCandidateEntity>> listWithConflictsByWorkspace(
    String workspaceId,
  ) async {
    final models = await _local.listWithConflictsByWorkspace(workspaceId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<MatchCandidateEntity>> watchWithConflictsByWorkspace(
    String workspaceId,
  ) {
    return _local
        .watchWithConflictsByWorkspace(workspaceId)
        .map((list) => list.map((m) => m.toEntity()).toList());
  }
}
