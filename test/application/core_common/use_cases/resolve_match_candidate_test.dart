// ============================================================================
// test/application/core_common/use_cases/resolve_match_candidate_test.dart
// RESOLVE MATCH CANDIDATE — F5 Hito 3 + F5 Hito 4
// ============================================================================
// QUÉ HACE:
//   - Valida la transición de state del MC local antes de llamar al repo.
//   - Valida que el use case propaga el ResolveMatchCandidateResult del repo
//     (con la OperationalRelationship creada por el backend en confirm, o null
//     en dismiss).
//
// QUÉ NO HACE:
//   - No valida el comportamiento del repo impl (HTTP, hidratación local):
//     eso pertenece a tests del impl. Aquí solo se stubea el repo vía fake.
// ============================================================================

import 'package:avanzza/application/core_common/use_cases/resolve_match_candidate.dart';
import 'package:avanzza/domain/entities/core_common/match_candidate_entity.dart';
import 'package:avanzza/domain/entities/core_common/operational_relationship_entity.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/match_candidate_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/match_trust_level.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/verified_key_type.dart';
import 'package:avanzza/domain/repositories/core_common/match_candidate_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fake del repo: captura el MC enviado a submitResolution y devuelve un
/// ResolveMatchCandidateResult configurable. Si [stubRelationship] es null
/// simula dismiss o confirm sin mirror (caso borde).
class _FakeMatchRepo implements MatchCandidateRepository {
  final List<MatchCandidateEntity> submitted = [];
  Object? submitWillThrow;

  /// Si se setea, el resultado del repo incluirá esta Relación (confirm).
  OperationalRelationshipEntity? stubRelationship;

  @override
  Future<ResolveMatchCandidateResult> submitResolution(
    MatchCandidateEntity candidate,
  ) async {
    final err = submitWillThrow;
    if (err != null) throw err;
    submitted.add(candidate);
    return ResolveMatchCandidateResult(
      matchCandidate: candidate,
      relationship: stubRelationship,
    );
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'MatchCandidateRepository.${invocation.memberName}');
}

MatchCandidateEntity exposedCandidate({String id = 'mc-1'}) {
  final now = DateTime.utc(2026, 1, 1);
  return MatchCandidateEntity(
    id: id,
    sourceWorkspaceId: 'ws-1',
    localKind: TargetLocalKind.contact,
    localId: 'c-1',
    platformActorId: 'actor-X',
    matchedKeyType: VerifiedKeyType.phoneE164,
    matchedKeyValue: '+573001234567',
    trustLevel: MatchTrustLevel.alto,
    state: MatchCandidateState.exposedToWorkspace,
    detectedAt: now,
    updatedAt: now,
    exposedAt: now,
  );
}

OperationalRelationshipEntity stubRelationship({
  String id = 'rel-42',
  String? localId,
}) {
  final now = DateTime.utc(2026, 1, 1);
  return OperationalRelationshipEntity(
    id: id,
    sourceWorkspaceId: 'ws-1',
    targetLocalKind: TargetLocalKind.contact,
    targetLocalId: localId ?? 'c-1',
    state: RelationshipState.vinculada,
    createdAt: now,
    updatedAt: now,
    stateUpdatedAt: now,
    relationshipKind: RelationshipKind.generic,
    linkedAt: now,
  );
}

void main() {
  group('ResolveMatchCandidate — confirm', () {
    test('transiciona state a confirmedIntoRelationship con confirmedAt',
        () async {
      final repo = _FakeMatchRepo()..stubRelationship = stubRelationship();
      final uc = ResolveMatchCandidate(repo: repo);

      final before = DateTime.now();
      await uc.execute(
        candidate: exposedCandidate(),
        decision: ResolveDecision.confirm,
      );
      final after = DateTime.now();

      expect(repo.submitted, hasLength(1));
      final resolved = repo.submitted.single;
      expect(resolved.state, MatchCandidateState.confirmedIntoRelationship);
      expect(resolved.confirmedAt, isNotNull);
      expect(
        resolved.confirmedAt!
                .isAfter(before.subtract(const Duration(seconds: 1))) &&
            resolved.confirmedAt!.isBefore(after.add(const Duration(seconds: 1))),
        isTrue,
      );
      expect(resolved.dismissedAt, isNull);
      expect(resolved.id, 'mc-1');
    });

    test('propaga resultingRelationshipId al repo cuando se provee', () async {
      final repo = _FakeMatchRepo()..stubRelationship = stubRelationship();
      final uc = ResolveMatchCandidate(repo: repo);

      await uc.execute(
        candidate: exposedCandidate(),
        decision: ResolveDecision.confirm,
        resultingRelationshipId: 'rel-42',
      );

      expect(repo.submitted.single.resultingRelationshipId, 'rel-42');
    });

    test('retorna la OperationalRelationship creada por el backend (F5 Hito 4)',
        () async {
      final rel = stubRelationship(id: 'rel-from-backend');
      final repo = _FakeMatchRepo()..stubRelationship = rel;
      final uc = ResolveMatchCandidate(repo: repo);

      final result = await uc.execute(
        candidate: exposedCandidate(),
        decision: ResolveDecision.confirm,
      );

      expect(result.relationship, isNotNull);
      expect(result.relationship!.id, 'rel-from-backend');
      expect(result.relationship!.state, RelationshipState.vinculada);
      expect(result.matchCandidate.state,
          MatchCandidateState.confirmedIntoRelationship);
    });
  });

  group('ResolveMatchCandidate — dismiss', () {
    test('transiciona state a dismissedByWorkspace con dismissedAt', () async {
      final repo = _FakeMatchRepo();
      final uc = ResolveMatchCandidate(repo: repo);

      await uc.execute(
        candidate: exposedCandidate(),
        decision: ResolveDecision.dismiss,
      );

      expect(repo.submitted, hasLength(1));
      final resolved = repo.submitted.single;
      expect(resolved.state, MatchCandidateState.dismissedByWorkspace);
      expect(resolved.dismissedAt, isNotNull);
      expect(resolved.confirmedAt, isNull);
    });

    test('dismiss retorna relationship=null (F5 Hito 4)', () async {
      final repo = _FakeMatchRepo(); // stubRelationship=null por defecto
      final uc = ResolveMatchCandidate(repo: repo);

      final result = await uc.execute(
        candidate: exposedCandidate(),
        decision: ResolveDecision.dismiss,
      );

      expect(result.relationship, isNull);
      expect(result.matchCandidate.state,
          MatchCandidateState.dismissedByWorkspace);
    });
  });

  group('propagación de errores', () {
    test('error del repo propaga al caller (no silent fail en resolve)',
        () async {
      final repo = _FakeMatchRepo()..submitWillThrow = StateError('local io');
      final uc = ResolveMatchCandidate(repo: repo);

      await expectLater(
        uc.execute(
          candidate: exposedCandidate(),
          decision: ResolveDecision.confirm,
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
