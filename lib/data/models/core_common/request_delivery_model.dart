// ============================================================================
// lib/data/models/core_common/request_delivery_model.dart
// REQUEST DELIVERY MODEL — Data Layer / Isar + JSON
// ============================================================================
// QUÉ HACE:
//   - Persiste RequestDeliveryEntity en Isar.
//   - Habilita la consulta 'hasDispatchedOrConfirmed' por índice compuesto.
//
// QUÉ NO HACE:
//   - No decide transiciones de la Request ni de la Relación.
//
// PRINCIPIOS:
//   - Wire-stable.
//   - Índice compuesto (requestId + statusWire) para evaluar regla de activación.
//
// ENTERPRISE NOTES:
//   - Un delivery fallido NO se edita; se crea uno nuevo para reintentar.
// ============================================================================

// NOTA: import de isar_community sin alias — requerido por el codegen.
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/core_common/request_delivery_entity.dart';
import '../../../domain/entities/core_common/value_objects/delivery_channel.dart';
import '../../../domain/entities/core_common/value_objects/delivery_direction.dart';
import '../../../domain/entities/core_common/value_objects/delivery_status.dart';

part 'request_delivery_model.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class RequestDeliveryModel {
  Id? isarId;

  /// Unique sin replace: las colisiones de id deben resolverse explícitamente.
  @Index(unique: true)
  final String id;

  /// FK a la Request. Índice compuesto con statusWire habilita
  /// hasDispatchedOrConfirmed eficiente.
  @Index(composite: [CompositeIndex('statusWire')])
  final String requestId;

  final String channelWire;
  final String directionWire;
  final String statusWire;

  final DateTime createdAt;
  final DateTime updatedAt;

  final String? externalRef;
  final String? targetKeyValueUsed;
  final DateTime? dispatchedAt;
  final DateTime? deliveredAt;
  final String? failedReason;

  RequestDeliveryModel({
    this.isarId,
    required this.id,
    required this.requestId,
    required this.channelWire,
    required this.directionWire,
    required this.statusWire,
    required this.createdAt,
    required this.updatedAt,
    this.externalRef,
    this.targetKeyValueUsed,
    this.dispatchedAt,
    this.deliveredAt,
    this.failedReason,
  });

  RequestDeliveryEntity toEntity() => RequestDeliveryEntity(
        id: id,
        requestId: requestId,
        channel: DeliveryChannelX.fromWire(channelWire),
        direction: DeliveryDirectionX.fromWire(directionWire),
        status: DeliveryStatusX.fromWire(statusWire),
        createdAt: createdAt,
        updatedAt: updatedAt,
        externalRef: externalRef,
        targetKeyValueUsed: targetKeyValueUsed,
        dispatchedAt: dispatchedAt,
        deliveredAt: deliveredAt,
        failedReason: failedReason,
      );

  factory RequestDeliveryModel.fromEntity(RequestDeliveryEntity e) =>
      RequestDeliveryModel(
        id: e.id,
        requestId: e.requestId,
        channelWire: e.channel.wireName,
        directionWire: e.direction.wireName,
        statusWire: e.status.wireName,
        createdAt: e.createdAt.toUtc(),
        updatedAt: e.updatedAt.toUtc(),
        externalRef: e.externalRef,
        targetKeyValueUsed: e.targetKeyValueUsed,
        dispatchedAt: e.dispatchedAt?.toUtc(),
        deliveredAt: e.deliveredAt?.toUtc(),
        failedReason: e.failedReason,
      );

  factory RequestDeliveryModel.fromJson(Map<String, dynamic> json) =>
      _$RequestDeliveryModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDeliveryModelToJson(this);
}
