// ============================================================================
// lib/application/core_common/use_cases/resolve_match_candidate.dart
// RESOLVE MATCH CANDIDATE — F5 Hito 3 + F5 Hito 4
// ============================================================================
// QUÉ HACE:
//   - Convierte un MatchCandidate en state=exposedToWorkspace en uno de dos
//     terminales resolutivos:
//       · ResolveDecision.confirm  → state=confirmedIntoRelationship
//       · ResolveDecision.dismiss  → state=dismissedByWorkspace
//   - Delega en MatchCandidateRepository.submitResolution(candidate), que
//     es SÍNCRONO (F5 Hito 4): el backend crea/reutiliza la
//     OperationalRelationship en la misma transacción y el repo la hidrata
//     local-only antes de retornar.
//   - Retorna ResolveMatchCandidateResult (MC actualizado + Relación o null).
//
// QUÉ NO HACE:
//   - NO crea la OperationalRelationship localmente: la crea el backend en
//     /resolve; este use case solo consume el resultado.
//   - NO crea pantallas ni flujos complejos. Es pura transición de estado +
//     propagación del resultado del backend.
//   - NO valida el state de entrada del candidato: el UI solo expone la acción
//     sobre candidatos expuestos (el indicator filtra), y el backend re-valida
//     al recibir el /resolve.
//
// SEMÁNTICA DE ERRORES:
//   - Excepciones del DS (Network/Unauthorized/Server/BadRequest) propagan al
//     caller — la UI decide UX (snackbar / reintento manual).
//   - Si el HTTP falla, el estado local NO se modifica (consistencia fuerte
//     local↔remoto por diseño de F5 Hito 4).
// ============================================================================

import '../../../domain/entities/core_common/match_candidate_entity.dart';
import '../../../domain/entities/core_common/value_objects/match_candidate_state.dart';
import '../../../domain/repositories/core_common/match_candidate_repository.dart';

enum ResolveDecision { confirm, dismiss }

class ResolveMatchCandidate {
  final MatchCandidateRepository _repo;

  const ResolveMatchCandidate({required MatchCandidateRepository repo})
      : _repo = repo;

  /// Transiciona [candidate] al terminal correspondiente y envía la resolución
  /// al backend vía el repo (síncrono). Retorna el resultado con el MC
  /// canónico del servidor y, si confirm, la OperationalRelationship creada.
  ///
  /// [resultingRelationshipId] opcional: si el UI quiere forzar un id concreto
  /// (p.ej. continuidad de un draft); en general se omite y el backend genera
  /// el id.
  Future<ResolveMatchCandidateResult> execute({
    required MatchCandidateEntity candidate,
    required ResolveDecision decision,
    String? resultingRelationshipId,
  }) async {
    final now = DateTime.now().toUtc();

    final MatchCandidateState nextState = decision == ResolveDecision.confirm
        ? MatchCandidateState.confirmedIntoRelationship
        : MatchCandidateState.dismissedByWorkspace;

    final resolved = candidate.copyWith(
      state: nextState,
      confirmedAt: decision == ResolveDecision.confirm
          ? now
          : candidate.confirmedAt,
      dismissedAt: decision == ResolveDecision.dismiss
          ? now
          : candidate.dismissedAt,
      resultingRelationshipId:
          resultingRelationshipId ?? candidate.resultingRelationshipId,
      updatedAt: now,
    );

    return _repo.submitResolution(resolved);
  }
}
