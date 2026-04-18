// ============================================================================
// test/data/repositories/core_common/match_candidate_resolve_flow_test.dart
// MATCH CANDIDATE RESOLVE FLOW — F5 Hito 4 / Deudas 2 y 3
// ============================================================================
// QUÉ HACE:
//   - Cubre dos deudas del Hito 4 con Isar REAL (no mocks de persistencia):
//     1. hydrateFromRemote idempotente: múltiples invocaciones con la misma
//        entity NO duplican registros locales. Identidad por backendId.
//     2. Flujo observable confirm: antes de resolver hay MatchCandidate
//        expuesto y NO hay Relación; tras confirm el MC deja de exponerse
//        Y la Relación existe localmente, vía streams.
//
// QUÉ NO HACE:
//   - No toca Firestore ni NestJS reales.
//   - No testea UI: valida los streams que la UI consume.
//
// PRINCIPIOS:
//   - Isar real abierto en directorio temporal (aislado por test).
//   - Stubs explícitos para el DS NestJS y el mirror remoto — ninguno escribe.
// ============================================================================

import 'dart:io';

import 'package:avanzza/application/core_common/use_cases/resolve_match_candidate.dart';
import 'package:avanzza/data/models/core_common/match_candidate_model.dart';
import 'package:avanzza/data/models/core_common/operational_relationship_model.dart';
import 'package:avanzza/data/repositories/core_common/match_candidate_repository_impl.dart';
import 'package:avanzza/data/repositories/core_common/operational_relationship_repository_impl.dart';
import 'package:avanzza/data/sources/local/core_common/match_candidate_local_ds.dart';
import 'package:avanzza/data/sources/local/core_common/operational_relationship_local_ds.dart';
import 'package:avanzza/data/sources/remote/core_common/match_candidate_nestjs_ds.dart';
import 'package:avanzza/domain/entities/core_common/match_candidate_entity.dart';
import 'package:avanzza/domain/entities/core_common/operational_relationship_entity.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/match_candidate_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/match_trust_level.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/normalized_key.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/verified_key_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Stubs
// ─────────────────────────────────────────────────────────────────────────────

/// Stub del DS NestJS. `submitResolution` devuelve el result configurado en
/// [stubResult]; `probe` / `fetchExposedByWorkspace` no se usan aquí.
class _StubMatchCandidateNestJs implements MatchCandidateNestJsDataSource {
  ResolveMatchCandidateResult? stubResult;
  int submitCalls = 0;

  @override
  Future<ResolveMatchCandidateResult> submitResolution(
    MatchCandidateEntity entity,
  ) async {
    submitCalls++;
    final r = stubResult;
    if (r == null) {
      throw StateError('stubResult no configurado');
    }
    return r;
  }

  @override
  Future<List<MatchCandidateEntity>> probe({
    required TargetLocalKind localKind,
    required String localId,
    required List<NormalizedKey> probes,
  }) =>
      throw UnimplementedError();

  @override
  Future<List<MatchCandidateEntity>> fetchExposedByWorkspace(
    String workspaceId,
  ) =>
      throw UnimplementedError();
}

// ─────────────────────────────────────────────────────────────────────────────
// Fixtures
// ─────────────────────────────────────────────────────────────────────────────

bool _isarCoreInitialized = false;

Future<Isar> _openTestIsar() async {
  if (!_isarCoreInitialized) {
    _isarCoreInitialized = true;
    try {
      await Isar.initializeIsarCore(download: true);
    } catch (_) {
      // Ya inicializado en sesión previa — seguro ignorar.
    }
  }
  final dir = Directory.systemTemp.createTempSync('isar_resolve_flow_');
  return Isar.open(
    [MatchCandidateModelSchema, OperationalRelationshipModelSchema],
    directory: dir.path,
    name: 'resolve_${dir.path.hashCode.abs()}',
  );
}

MatchCandidateEntity _exposedCandidate({
  String id = 'mc-1',
  String workspaceId = 'ws-1',
  String localId = 'c-1',
  TargetLocalKind kind = TargetLocalKind.contact,
}) {
  final now = DateTime.utc(2026, 1, 1);
  return MatchCandidateEntity(
    id: id,
    sourceWorkspaceId: workspaceId,
    localKind: kind,
    localId: localId,
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

OperationalRelationshipEntity _stubRelationship({
  String id = 'rel-42',
  String workspaceId = 'ws-1',
  String localId = 'c-1',
  TargetLocalKind kind = TargetLocalKind.contact,
}) {
  final now = DateTime.utc(2026, 1, 1);
  return OperationalRelationshipEntity(
    id: id,
    sourceWorkspaceId: workspaceId,
    targetLocalKind: kind,
    targetLocalId: localId,
    state: RelationshipState.vinculada,
    createdAt: now,
    updatedAt: now,
    stateUpdatedAt: now,
    relationshipKind: RelationshipKind.generic,
    linkedAt: now,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  late Isar isar;
  late OperationalRelationshipRepositoryImpl relationshipRepo;
  late MatchCandidateRepositoryImpl matchRepo;
  late MatchCandidateLocalDataSource matchLocal;
  late OperationalRelationshipLocalDataSource relLocal;
  late _StubMatchCandidateNestJs nestjsStub;

  setUp(() async {
    isar = await _openTestIsar();
    matchLocal = MatchCandidateLocalDataSource(isar);
    relLocal = OperationalRelationshipLocalDataSource(isar);

    relationshipRepo = OperationalRelationshipRepositoryImpl(local: relLocal);

    nestjsStub = _StubMatchCandidateNestJs();
    matchRepo = MatchCandidateRepositoryImpl(
      local: matchLocal,
      remote: nestjsStub,
      relationshipRepo: relationshipRepo,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('hydrateFromRemote idempotencia', () {
    test('3 llamadas con la misma entity → 1 solo registro local', () async {
      final rel = _stubRelationship();

      await relationshipRepo.hydrateFromRemote(rel);
      await relationshipRepo.hydrateFromRemote(rel);
      await relationshipRepo.hydrateFromRemote(rel);

      final count = await isar.operationalRelationshipModels.count();
      expect(count, 1, reason: 'backendId debe ser identidad única');

      final persisted = await isar.operationalRelationshipModels
          .filter()
          .idEqualTo('rel-42')
          .findAll();
      expect(persisted, hasLength(1));
      expect(persisted.single.stateWire, RelationshipState.vinculada.wireName);
    });

    test('segunda llamada con updatedAt distinto actualiza en lugar de duplicar',
        () async {
      final first = _stubRelationship();
      await relationshipRepo.hydrateFromRemote(first);

      final laterStamp = DateTime.utc(2026, 6, 1);
      final updated = first.copyWith(
        updatedAt: laterStamp,
        stateUpdatedAt: laterStamp,
      );
      await relationshipRepo.hydrateFromRemote(updated);

      final all = await isar.operationalRelationshipModels.where().findAll();
      expect(all, hasLength(1));
      expect(all.single.updatedAt.toUtc(), laterStamp);
    });
  });

  group('Flujo observable — confirm', () {
    test(
        'ANTES: MC expuesto + sin Relación; DESPUÉS (confirm): Relación '
        'existe y MC deja de emitirse como expuesto', () async {
      const ws = 'ws-1';
      const cid = 'c-1';
      final mc = _exposedCandidate(workspaceId: ws, localId: cid);

      // Seed: MC expuesto persistido local (simulando hidratación previa del
      // probe / refresh).
      await matchLocal.upsert(MatchCandidateModel.fromEntity(mc));

      // Observadores que consumirá la UI. Recolecto emisiones.
      final exposedEmissions = <List<String>>[];
      final relEmissions = <String?>[];

      final exposedSub = matchRepo.watchExposedByWorkspace(ws).listen((list) {
        exposedEmissions.add(list.map((e) => e.id).toList());
      });
      final relSub = relationshipRepo
          .watchByTarget(ws, TargetLocalKind.contact, cid)
          .listen((rel) {
        relEmissions.add(rel?.id);
      });

      // Deja que fluyan los valores iniciales (fireImmediately).
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // ESTADO ANTES:
      expect(exposedEmissions.last, ['mc-1'],
          reason: 'MC expuesto visible antes de confirmar');
      expect(relEmissions.last, isNull,
          reason: 'No hay Relación antes de confirmar');

      // Stub del backend: confirm → MC actualizado + Relación creada.
      final rel = _stubRelationship(workspaceId: ws, localId: cid);
      final confirmedMc = mc.copyWith(
        state: MatchCandidateState.confirmedIntoRelationship,
        confirmedAt: DateTime.utc(2026, 3, 1),
        resultingRelationshipId: rel.id,
        updatedAt: DateTime.utc(2026, 3, 1),
      );
      nestjsStub.stubResult = ResolveMatchCandidateResult(
        matchCandidate: confirmedMc,
        relationship: rel,
      );

      // ACCIÓN: el usuario presiona "Vincular".
      final uc = ResolveMatchCandidate(repo: matchRepo);
      final result = await uc.execute(
        candidate: mc,
        decision: ResolveDecision.confirm,
      );

      // Deja que los watchers reciban los cambios.
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // ESTADO DESPUÉS:
      expect(result.relationship?.id, 'rel-42');
      expect(result.matchCandidate.state,
          MatchCandidateState.confirmedIntoRelationship);

      expect(relEmissions.last, 'rel-42',
          reason: 'Relación vigente para el target debe emitirse local');

      expect(exposedEmissions.last, isEmpty,
          reason:
              'MC ya no está en exposedToWorkspace, el stream debe vaciarse');

      // Persistencia local consistente con el resultado remoto.
      final storedRel = await relLocal.findByTarget(
        ws,
        TargetLocalKind.contact,
        cid,
      );
      expect(storedRel, isNotNull);
      expect(storedRel!.id, 'rel-42');

      final storedMc = await matchLocal.getById(mc.id);
      expect(storedMc, isNotNull);
      expect(storedMc!.stateWire,
          MatchCandidateState.confirmedIntoRelationship.wireName);
      expect(storedMc.resultingRelationshipId, 'rel-42');

      await exposedSub.cancel();
      await relSub.cancel();
    });
  });
}
