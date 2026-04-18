// ============================================================================
// lib/data/repositories/core_common/request_delivery_repository_impl.dart
// REQUEST DELIVERY REPOSITORY IMPL — Data Layer (F3.c)
// ============================================================================
// QUÉ HACE:
//   - Implementa RequestDeliveryRepository (F1.c).
//   - Escritura y lectura local (Isar).
//   - Expone hasDispatchedOrConfirmed (consulta delegada al DS local) para
//     que los casos de uso apliquen la regla de activación real (F2.a).
//
// QUÉ NO HACE:
//   - No encola Firestore aquí: la entity RequestDelivery NO transporta
//     workspaceId (lo posee la Request padre). Pedirle al repo resolver el
//     workspace obligaría a depender de OperationalRequestRepository, lo cual
//     viola la regla F3.c "sin dependencias entre repos". Por tanto, el
//     espejado a Firestore es responsabilidad del caso de uso de delivery
//     (F6/F7), que ya conoce el workspaceId por contexto.
//   - No promueve transiciones de Relación ni de Request: los casos de uso
//     deciden con hasDispatchedOrConfirmed si aplica la activación real.
//   - No va a NestJS (regla v1: deliveries son locales/Firestore).
// ============================================================================

import '../../../domain/entities/core_common/request_delivery_entity.dart';
import '../../../domain/repositories/core_common/request_delivery_repository.dart';
import '../../models/core_common/request_delivery_model.dart';
import '../../sources/local/core_common/request_delivery_local_ds.dart';

class RequestDeliveryRepositoryImpl implements RequestDeliveryRepository {
  final RequestDeliveryLocalDataSource _local;

  RequestDeliveryRepositoryImpl({
    required RequestDeliveryLocalDataSource local,
  }) : _local = local;

  @override
  Future<void> save(RequestDeliveryEntity delivery) async {
    final model = RequestDeliveryModel.fromEntity(delivery);
    await _local.upsert(model);
    // Espejado a Firestore deliberadamente omitido aquí: el caso de uso
    // (F6/F7) encola la acción remota con el workspaceId correspondiente.
  }

  @override
  Future<RequestDeliveryEntity?> getById(String id) async {
    final m = await _local.getById(id);
    return m?.toEntity();
  }

  @override
  Future<List<RequestDeliveryEntity>> listByRequest(String requestId) async {
    final models = await _local.listByRequest(requestId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<RequestDeliveryEntity>> watchByRequest(String requestId) {
    return _local
        .watchByRequest(requestId)
        .map((list) => list.map((m) => m.toEntity()).toList());
  }

  @override
  Future<RequestDeliveryEntity?> latestByRequest(String requestId) async {
    final m = await _local.latestByRequest(requestId);
    return m?.toEntity();
  }

  @override
  Future<bool> hasDispatchedOrConfirmed(String requestId) {
    return _local.hasDispatchedOrConfirmed(requestId);
  }
}
