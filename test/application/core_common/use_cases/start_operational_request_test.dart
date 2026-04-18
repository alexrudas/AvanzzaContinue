// ============================================================================
// test/application/core_common/use_cases/start_operational_request_test.dart
// START OPERATIONAL REQUEST — F5 Hito 11 (alineado a backend canónico)
// ============================================================================
// Valida:
//   - Delega en CoordinationFlowRepository.startCoordinationFlow con los
//     params correctos (relationshipId, title, summary).
//   - No reimplementa lógica de dominio: el use case es un orquestador thin.
//   - Errores del repo propagan al caller (online-only).
// ============================================================================

import 'package:avanzza/application/core_common/use_cases/start_operational_request.dart';
import 'package:avanzza/domain/entities/core_common/coordination_flow_entity.dart';
import 'package:avanzza/domain/entities/core_common/operational_relationship_entity.dart';
import 'package:avanzza/domain/entities/core_common/operational_request_entity.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/coordination_flow_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/coordination_flow_status.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/request_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/request_origin_channel.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/request_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:avanzza/domain/repositories/core_common/coordination_flow_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _CapturedCall {
  final String relationshipId;
  final String title;
  final String? summary;
  final RequestKind? requestKind;
  final RequestOriginChannel? originChannel;
  final CoordinationFlowKind? flowKind;
  _CapturedCall({
    required this.relationshipId,
    required this.title,
    required this.summary,
    required this.requestKind,
    required this.originChannel,
    required this.flowKind,
  });
}

class _FakeFlowRepo implements CoordinationFlowRepository {
  final List<_CapturedCall> calls = [];
  Object? willThrow;

  CoordinationFlowEntity stubFlow({String id = 'flow-1'}) {
    final now = DateTime.utc(2026, 1, 1);
    return CoordinationFlowEntity(
      id: id,
      sourceWorkspaceId: 'ws-1',
      relationshipId: 'rel-1',
      startedBy: 'user-1',
      flowKind: CoordinationFlowKind.generic,
      status: CoordinationFlowStatus.draft,
      statusUpdatedAt: now,
      createdAt: now,
      updatedAt: now,
    );
  }

  OperationalRequestEntity stubRequest({String id = 'req-1', String flowId = 'flow-1'}) {
    final now = DateTime.utc(2026, 1, 1);
    return OperationalRequestEntity(
      id: id,
      sourceWorkspaceId: 'ws-1',
      relationshipId: 'rel-1',
      requestKind: RequestKind.generic,
      state: RequestState.draft,
      title: 'stub',
      createdBy: 'user-1',
      originChannel: RequestOriginChannel.inApp,
      createdAt: now,
      updatedAt: now,
      stateUpdatedAt: now,
    );
  }

  @override
  Future<StartCoordinationFlowResult> startCoordinationFlow({
    required String relationshipId,
    required String title,
    String? summary,
    RequestKind? requestKind,
    RequestOriginChannel? originChannel,
    CoordinationFlowKind? flowKind,
  }) async {
    calls.add(_CapturedCall(
      relationshipId: relationshipId,
      title: title,
      summary: summary,
      requestKind: requestKind,
      originChannel: originChannel,
      flowKind: flowKind,
    ));
    final err = willThrow;
    if (err != null) throw err;
    return StartCoordinationFlowResult(
      flow: stubFlow(),
      request: stubRequest(),
    );
  }

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('CoordinationFlowRepository.${invocation.memberName}');
}

OperationalRelationshipEntity _relationship() {
  final now = DateTime.utc(2026, 1, 1);
  return OperationalRelationshipEntity(
    id: 'rel-1',
    sourceWorkspaceId: 'ws-1',
    targetLocalKind: TargetLocalKind.contact,
    targetLocalId: 'c-1',
    state: RelationshipState.vinculada,
    createdAt: now,
    updatedAt: now,
    stateUpdatedAt: now,
    relationshipKind: RelationshipKind.generic,
    linkedAt: now,
  );
}

void main() {
  group('StartOperationalRequest — delegación al repo', () {
    test('llama startCoordinationFlow con relationshipId + title + summary',
        () async {
      final repo = _FakeFlowRepo();
      final uc = StartOperationalRequest(repo: repo);

      final result = await uc.execute(
        relationship: _relationship(),
        createdBy: 'user-1',
        title: '  Cotizar mantenimiento  ',
        summary: '  detalle breve  ',
      );

      expect(repo.calls, hasLength(1));
      final c = repo.calls.single;
      expect(c.relationshipId, 'rel-1');
      // El trim lo hace el repo impl (pre-HTTP); aquí el use case solo pasa
      // crudo. La invariante relevante: se envía tal cual al repo.
      expect(c.title.trim(), 'Cotizar mantenimiento');
      expect(c.summary, '  detalle breve  ');
      expect(result.flow.id, 'flow-1');
      expect(result.request.id, 'req-1');
    });

    test('propaga error del repo al caller (online-only, sin fallback)',
        () async {
      final repo = _FakeFlowRepo()..willThrow = StateError('network boom');
      final uc = StartOperationalRequest(repo: repo);

      await expectLater(
        uc.execute(
          relationship: _relationship(),
          createdBy: 'user-1',
          title: 'x',
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('createdBy del cliente es ignorado (lo deriva el backend)', () async {
      // El contrato post-D4: el backend usa el uid del Firebase ID token.
      // El parámetro createdBy del use case se mantiene por compat del caller
      // pero NO viaja al repo. Este test blinda esa invariante.
      final repo = _FakeFlowRepo();
      final uc = StartOperationalRequest(repo: repo);

      await uc.execute(
        relationship: _relationship(),
        createdBy: 'user-attacker',
        title: 'x',
      );

      expect(repo.calls.single.relationshipId, 'rel-1');
      // El payload capturado solo contiene lo que se envía al repo/HTTP. No
      // hay campo createdBy ahí — no se propaga por diseño.
    });
  });
}
