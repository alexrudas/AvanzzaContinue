// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_delivery_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestDeliveryEntity _$RequestDeliveryEntityFromJson(
        Map<String, dynamic> json) =>
    _RequestDeliveryEntity(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      channel: $enumDecode(_$DeliveryChannelEnumMap, json['channel']),
      direction: $enumDecode(_$DeliveryDirectionEnumMap, json['direction']),
      status: $enumDecode(_$DeliveryStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      externalRef: json['externalRef'] as String?,
      targetKeyValueUsed: json['targetKeyValueUsed'] as String?,
      dispatchedAt: json['dispatchedAt'] == null
          ? null
          : DateTime.parse(json['dispatchedAt'] as String),
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
      failedReason: json['failedReason'] as String?,
    );

Map<String, dynamic> _$RequestDeliveryEntityToJson(
        _RequestDeliveryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'channel': _$DeliveryChannelEnumMap[instance.channel]!,
      'direction': _$DeliveryDirectionEnumMap[instance.direction]!,
      'status': _$DeliveryStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'externalRef': instance.externalRef,
      'targetKeyValueUsed': instance.targetKeyValueUsed,
      'dispatchedAt': instance.dispatchedAt?.toIso8601String(),
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'failedReason': instance.failedReason,
    };

const _$DeliveryChannelEnumMap = {
  DeliveryChannel.inApp: 'inApp',
  DeliveryChannel.whatsappExternal: 'whatsappExternal',
  DeliveryChannel.emailExternal: 'emailExternal',
  DeliveryChannel.manual: 'manual',
};

const _$DeliveryDirectionEnumMap = {
  DeliveryDirection.outbound: 'outbound',
  DeliveryDirection.inboundAck: 'inboundAck',
};

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.queued: 'queued',
  DeliveryStatus.dispatched: 'dispatched',
  DeliveryStatus.delivered: 'delivered',
  DeliveryStatus.failed: 'failed',
  DeliveryStatus.confirmedByEmitter: 'confirmedByEmitter',
};
