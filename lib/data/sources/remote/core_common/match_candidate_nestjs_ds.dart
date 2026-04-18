// ============================================================================
// lib/data/sources/remote/core_common/match_candidate_nestjs_ds.dart
// MATCH CANDIDATE NESTJS DS — Contrato remoto (F4.c + F5.4)
// ============================================================================
// QUÉ HACE:
//   - Define el contrato del datasource remoto contra NestJS para
//     /v1/core-common/match-candidates (probe, list, resolve).
//   - F5.4: submitResolution ahora retorna ResolveMatchCandidateResult
//     con el MatchCandidate actualizado Y la OperationalRelationship creada
//     (null en dismiss).
//
// QUÉ NO HACE:
//   - No ejecuta el matcher (vive en el backend).
//   - No persiste local (eso es MatchCandidateLocalDataSource + repo).
//
// GUARDRAILS F5:
//   - Sin try/catch silencioso.
//   - No retorna null como fallback de error.
//   - Propaga excepciones tipadas (nestjs_exceptions.dart).
// ============================================================================

import '../../../../domain/entities/core_common/match_candidate_entity.dart';
import '../../../../domain/entities/core_common/value_objects/normalized_key.dart';
import '../../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../../domain/repositories/core_common/match_candidate_repository.dart'
    show ResolveMatchCandidateResult;

export '../../../../domain/repositories/core_common/match_candidate_repository.dart'
    show ResolveMatchCandidateResult;

abstract class MatchCandidateNestJsDataSource {
  /// POST /v1/core-common/match-candidates/probe
  Future<List<MatchCandidateEntity>> probe({
    required TargetLocalKind localKind,
    required String localId,
    required List<NormalizedKey> probes,
  });

  /// GET /v1/core-common/match-candidates
  Future<List<MatchCandidateEntity>> fetchExposedByWorkspace(
    String workspaceId,
  );

  /// POST /v1/core-common/match-candidates/:id/resolve
  ///
  /// F5.4: síncrono. Retorna el MatchCandidate actualizado Y la relación
  /// creada/reutilizada (null en dismiss). El caller (repo) persiste ambos
  /// localmente a partir del resultado.
  Future<ResolveMatchCandidateResult> submitResolution(
    MatchCandidateEntity entity,
  );
}
