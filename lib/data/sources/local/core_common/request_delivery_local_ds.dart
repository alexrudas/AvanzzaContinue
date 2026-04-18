// ============================================================================
// lib/data/sources/local/core_common/request_delivery_local_ds.dart
// REQUEST DELIVERY LOCAL DS — Data Layer / Sources / Local (F3.b)
// ============================================================================
// QUÉ HACE:
//   - Acceso a RequestDeliveryModel en Isar.
//   - Implementa la consulta clave hasDispatchedOrConfirmed usada por el caso
//     de uso de activación real (regla de F2.a: Relación → activadaUnilateral
//     solo si existe un delivery en 'dispatched' o 'confirmedByEmitter').
//
// QUÉ NO HACE:
//   - No dispara transiciones de Relación ni Request.
//   - No expone delete: cada intento es histórico de transporte.
//
// PRINCIPIOS:
//   - writeTxn atómico para upsert.
//   - Un fallo se modela como delivery nuevo, no editando uno previo.
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../../domain/entities/core_common/value_objects/delivery_status.dart';
import '../../../models/core_common/request_delivery_model.dart';

class RequestDeliveryLocalDataSource {
  final Isar _isar;

  RequestDeliveryLocalDataSource(this._isar);

  Future<RequestDeliveryModel?> getById(String id) async {
    return _isar.requestDeliveryModels.filter().idEqualTo(id).findFirst();
  }

  Future<RequestDeliveryModel> upsert(RequestDeliveryModel model) async {
    return _isar.writeTxn(() async {
      final existing = await _isar.requestDeliveryModels
          .filter()
          .idEqualTo(model.id)
          .findFirst();

      final toSave = RequestDeliveryModel(
        isarId: existing?.isarId,
        id: model.id,
        requestId: model.requestId,
        channelWire: model.channelWire,
        directionWire: model.directionWire,
        statusWire: model.statusWire,
        createdAt: existing?.createdAt ?? model.createdAt.toUtc(),
        updatedAt: model.updatedAt.toUtc(),
        externalRef: model.externalRef,
        targetKeyValueUsed: model.targetKeyValueUsed,
        dispatchedAt: model.dispatchedAt?.toUtc(),
        deliveredAt: model.deliveredAt?.toUtc(),
        failedReason: model.failedReason,
      );

      await _isar.requestDeliveryModels.put(toSave);
      return toSave;
    });
  }

  Future<List<RequestDeliveryModel>> listByRequest(String requestId) async {
    return _isar.requestDeliveryModels
        .filter()
        .requestIdEqualTo(requestId)
        .sortByCreatedAt()
        .findAll();
  }

  Stream<List<RequestDeliveryModel>> watchByRequest(String requestId) {
    return _isar.requestDeliveryModels
        .filter()
        .requestIdEqualTo(requestId)
        .sortByCreatedAt()
        .watch(fireImmediately: true);
  }

  Future<RequestDeliveryModel?> latestByRequest(String requestId) async {
    return _isar.requestDeliveryModels
        .filter()
        .requestIdEqualTo(requestId)
        .sortByCreatedAtDesc()
        .findFirst();
  }

  /// Regla de activación real: true si existe al menos un delivery de la
  /// Request con status='dispatched' o 'confirmedByEmitter'.
  Future<bool> hasDispatchedOrConfirmed(String requestId) async {
    final dispatchedWire = DeliveryStatus.dispatched.wireName;
    final confirmedWire = DeliveryStatus.confirmedByEmitter.wireName;

    final count = await _isar.requestDeliveryModels
        .filter()
        .requestIdEqualTo(requestId)
        .group((q) => q
            .statusWireEqualTo(dispatchedWire)
            .or()
            .statusWireEqualTo(confirmedWire))
        .count();

    return count > 0;
  }
}
