// ============================================================================
// lib/domain/repositories/core_common/match_candidate_repository.dart
// MATCH CANDIDATE REPOSITORY — Core Common v1 / Contrato
// ============================================================================
// Qué hace:
//   - Define el contrato de acceso a MatchCandidate desde el cliente.
//   - Expone solo candidatos cuyo state permite visibilidad al workspace
//     (exposedToWorkspace / confirmedIntoRelationship).
//   - Provee queries para el hook D8 (candidatos con colisión marcada).
//
// Qué NO hace:
//   - No ejecuta el matcher: el matcher vive en NestJS.
//   - No escribe candidatos internos: el cliente nunca ve 'detectedInternal'
//     de otros workspaces ni de él mismo sin exposición.
//   - No resuelve colisiones: la resolución es caso de uso explícito.
//   - No expone delete: la trazabilidad del matcher es histórico de dominio.
//
// Principios:
//   - Offline-first para los candidatos expuestos (cache delgado en Isar).
//   - NO-DIRECTORIO BY DESIGN: el workspace NUNCA descubre actores no
//     referenciados; el listado siempre se origina en registros locales
//     propios del workspace. Los candidatos 'detectedInternal' NO son
//     accesibles desde este contrato.
//
// Borrado controlado:
//   - No se expone delete: los candidatos son histórico del matcher. Un
//     candidato descartado transiciona a 'dismissedByWorkspace', no se borra.
//
// Enterprise Notes:
//   - resultingRelationshipId se pobla cuando un candidato se promueve a Relación.
//   - collisionKinds / isConflictMarked / isCriticalConflict son el hook D8.
// ============================================================================

import '../../entities/core_common/match_candidate_entity.dart';
import '../../entities/core_common/operational_relationship_entity.dart';
import '../../entities/core_common/value_objects/normalized_key.dart';
import '../../entities/core_common/value_objects/target_local_kind.dart';

/// Resultado de submitResolution (F5 Hito 4).
///
/// - confirm: [relationship] contiene la OperationalRelationship creada o
///   reutilizada por el backend (state=vinculada, mirror local ya hidratado
///   por el repo antes de retornar).
/// - dismiss: [relationship] = null.
class ResolveMatchCandidateResult {
  final MatchCandidateEntity matchCandidate;
  final OperationalRelationshipEntity? relationship;

  const ResolveMatchCandidateResult({
    required this.matchCandidate,
    required this.relationship,
  });
}

/// Contrato de acceso a MatchCandidate desde el cliente.
/// Solo expone candidatos visibles al workspace.
abstract class MatchCandidateRepository {
  /// Persiste localmente un candidato recibido desde backend.
  /// Típicamente llamado por el sync que replica los candidatos expuestos.
  /// NO encola nada a NestJS (hidratación pura).
  Future<void> save(MatchCandidateEntity candidate);

  /// Envía al backend NestJS la resolución de un candidato (dismiss o confirm)
  /// de forma SÍNCRONA. F5 Hito 4:
  ///   - confirm: el backend crea/reutiliza la OperationalRelationship dentro
  ///     de la misma transacción. El repo hidrata localmente el MC actualizado
  ///     Y la relationship recibida antes de retornar.
  ///   - dismiss: solo se actualiza el MC; relationship = null.
  ///
  /// El caller es responsable de transicionar el state del candidato a
  /// dismissedByWorkspace o confirmedIntoRelationship ANTES de llamar.
  ///
  /// Excepciones del DS (Network/Unauthorized/Server/BadRequest) se propagan
  /// tal cual — el caller decide UX. NO hay enqueue: la resolución es
  /// transaccional online-only porque depende del estado remoto.
  Future<ResolveMatchCandidateResult> submitResolution(
    MatchCandidateEntity candidate,
  );

  /// Dispara el matcher remoto sobre el registro local (localKind, localId)
  /// con las [probes] ya normalizadas por KeyNormalizer. El backend crea/
  /// actualiza MatchCandidates y el repo sincroniza el estado local de
  /// expuestos del workspace inmediatamente después.
  ///
  /// Guardrail F5 Hito 1:
  ///   - El DS remoto NO captura; cualquier fallo (Network/Unauthorized/
  ///     Server/BadRequest) se propaga tal cual al caller.
  ///   - El repo NO reintenta; el caller decide (v1: sin retry — el siguiente
  ///     update del registro local volverá a disparar el probe naturalmente).
  Future<List<MatchCandidateEntity>> triggerProbe({
    required String workspaceId,
    required TargetLocalKind localKind,
    required String localId,
    required List<NormalizedKey> probes,
  });

  /// Descarga del backend la lista actual de MatchCandidate en state=
  /// exposedToWorkspace para el [workspaceId] y la persiste en cache local
  /// (upsert). Útil tras un probe o como pull manual desde UI.
  Future<List<MatchCandidateEntity>> refreshExposedByWorkspace(
    String workspaceId,
  );

  /// Retorna el candidato por id o null.
  Future<MatchCandidateEntity?> getById(String id);

  /// Lista los candidatos con state 'exposedToWorkspace' para el workspace.
  /// Estos son los que el usuario debe resolver (aceptar o descartar).
  Future<List<MatchCandidateEntity>> listExposedByWorkspace(
    String workspaceId,
  );

  /// Stream reactivo de candidatos expuestos al workspace.
  Stream<List<MatchCandidateEntity>> watchExposedByWorkspace(
    String workspaceId,
  );

  /// Lista todos los candidatos (de cualquier state visible) asociados a un
  /// registro local concreto del workspace.
  /// Útil cuando el usuario inspecciona un LocalOrganization o LocalContact.
  Future<List<MatchCandidateEntity>> listByLocal(
    String workspaceId,
    TargetLocalKind localKind,
    String localId,
  );

  /// Lista los candidatos expuestos al workspace que tienen alguna colisión
  /// marcada (hook D8). La resolución es acción explícita del caso de uso.
  Future<List<MatchCandidateEntity>> listWithConflictsByWorkspace(
    String workspaceId,
  );

  /// Stream reactivo de candidatos con conflicto marcado. Permite que la UI
  /// reaccione cuando se detecta una colisión nueva sin suspender la Relación.
  Stream<List<MatchCandidateEntity>> watchWithConflictsByWorkspace(
    String workspaceId,
  );
}
