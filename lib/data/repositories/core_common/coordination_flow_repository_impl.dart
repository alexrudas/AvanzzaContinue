// ============================================================================
// lib/data/repositories/core_common/coordination_flow_repository_impl.dart
// COORDINATION FLOW REPOSITORY IMPL — Data Layer (F5 Hito 11)
// ============================================================================
// QUÉ HACE:
//   - Implementa CoordinationFlowRepository.
//   - startCoordinationFlow: HTTP síncrono contra backend (POST
//     /v1/coordination-flows). Hidrata flow + request en cache local antes
//     de retornar. Orden: request primero, flow después, para que cuando un
//     stream emita el flow la request anclada ya sea resolvible.
//
// QUÉ NO HACE:
//   - No encola escrituras a Firestore para flow/request (Core API es SSOT).
//   - No crea flows localmente: si el HTTP falla, no hay persistencia local.
// ============================================================================

import '../../../domain/entities/core_common/coordination_flow_entity.dart';
import '../../../domain/entities/core_common/value_objects/coordination_flow_kind.dart';
import '../../../domain/entities/core_common/value_objects/request_kind.dart';
import '../../../domain/entities/core_common/value_objects/request_origin_channel.dart';
import '../../../domain/repositories/core_common/coordination_flow_repository.dart';
import '../../../domain/repositories/core_common/operational_request_repository.dart';
import '../../models/core_common/coordination_flow_model.dart';
import '../../sources/local/core_common/coordination_flow_local_ds.dart';
import '../../sources/remote/core_common/coordination_flow_api_client.dart';

class CoordinationFlowRepositoryImpl implements CoordinationFlowRepository {
  final CoordinationFlowLocalDataSource _local;
  final CoordinationFlowApiClient _remote;
  final OperationalRequestRepository _requestRepo;

  CoordinationFlowRepositoryImpl({
    required CoordinationFlowLocalDataSource local,
    required CoordinationFlowApiClient remote,
    required OperationalRequestRepository requestRepo,
  })  : _local = local,
        _remote = remote,
        _requestRepo = requestRepo;

  @override
  Future<StartCoordinationFlowResult> startCoordinationFlow({
    required String relationshipId,
    required String title,
    String? summary,
    RequestKind? requestKind,
    RequestOriginChannel? originChannel,
    CoordinationFlowKind? flowKind,
  }) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      throw ArgumentError.value(title, 'title', 'no puede ser vacío');
    }
    final trimmedSummary = summary?.trim();

    // Llamada HTTP — las excepciones tipadas del DS propagan al caller si fallan.
    final response = await _remote.startFlow(
      StartCoordinationFlowRequest(
        relationshipId: relationshipId,
        initialRequest: InitialRequestPayload(
          title: trimmedTitle,
          summary: (trimmedSummary == null || trimmedSummary.isEmpty)
              ? null
              : trimmedSummary,
          requestKind: requestKind,
          originChannel: originChannel,
        ),
        flowKind: flowKind,
      ),
    );

    // Hidratación local: request primero (para que un stream del flow, que
    // incluye request.coordinationFlowId, ya tenga la request resolvible al
    // emitir).
    await _requestRepo.hydrateFromRemote(response.request);
    await _local.upsert(CoordinationFlowModel.fromEntity(response.flow));

    return StartCoordinationFlowResult(
      flow: response.flow,
      request: response.request,
    );
  }

  @override
  Future<CoordinationFlowEntity?> getById(String id) async {
    final m = await _local.getById(id);
    return m?.toEntity();
  }

  @override
  Stream<CoordinationFlowEntity?> watchById(String id) {
    return _local.watchById(id).map((m) => m?.toEntity());
  }

  @override
  Future<List<CoordinationFlowEntity>> listByRelationship(
    String relationshipId,
  ) async {
    final models = await _local.listByRelationship(relationshipId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<CoordinationFlowEntity>> watchByRelationship(
    String relationshipId,
  ) {
    return _local
        .watchByRelationship(relationshipId)
        .map((list) => list.map((m) => m.toEntity()).toList());
  }
}
