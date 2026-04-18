// ============================================================================
// lib/domain/entities/core_common/request_delivery_entity.dart
// REQUEST DELIVERY ENTITY — Core Common v1 / Transporte de la Solicitud
// ============================================================================
// QUÉ HACE:
//   - Modela un intento de transporte de una OperationalRequest.
//   - Permite múltiples deliveries por Request (re-envíos, canal dual,
//     confirmación cruzada) manteniendo trazabilidad completa.
//
// QUÉ NO HACE:
//   - No muta: los reintentos se modelan como deliveries nuevos, no editando
//     el estado de uno fallido.
//   - No dicta el estado de la Request: la Request sube de estado por la
//     combinación de deliveries, no por un solo delivery.
//   - No integra APIs externas (v1: solo intents asistidos + manual).
//
// PRINCIPIOS:
//   - Dominio puro + freezed + json_serializable.
//   - status = dispatched | confirmedByEmitter dispara la transición de la
//     Relación a 'activadaUnilateral' si aún no lo estaba (regla de activación
//     real, ejecutada por el caso de uso correspondiente).
//   - externalRef / targetKeyValueUsed aplican a canales externos; en 'inApp'
//     pueden quedar nulos.
//   - Enums serializados vía @JsonValue (wire-stable).
//
// ENTERPRISE NOTES:
//   - Un Request con origen 'externalAssisted' siempre tendrá al menos un
//     delivery externo (whatsappExternal | emailExternal | manual).
//   - En canales externos, la confirmación de entrega puede provenir del
//     emisor (confirmedByEmitter) al no haber ACK nativo.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'value_objects/delivery_channel.dart';
import 'value_objects/delivery_direction.dart';
import 'value_objects/delivery_status.dart';

part 'request_delivery_entity.freezed.dart';
part 'request_delivery_entity.g.dart';

/// Intento de transporte de una OperationalRequest.
/// Inmutable en intención: un delivery fallido no se edita; se crea uno nuevo.
@freezed
abstract class RequestDeliveryEntity with _$RequestDeliveryEntity {
  const factory RequestDeliveryEntity({
    required String id,

    /// FK obligatoria a la Request transportada.
    required String requestId,

    /// Canal del intento (inApp / whatsappExternal / emailExternal / manual).
    required DeliveryChannel channel,

    /// Dirección del delivery (envío saliente o acuse entrante).
    required DeliveryDirection direction,

    /// Estado del delivery.
    required DeliveryStatus status,

    required DateTime createdAt,
    required DateTime updatedAt,

    /// Referencia externa (URL de wa.me, threadId de email, id manual libre).
    String? externalRef,

    /// Valor concreto de llave usada para el envío externo (teléfono/email).
    /// Trazabilidad fina sin exponer otras llaves del destinatario.
    String? targetKeyValueUsed,

    DateTime? dispatchedAt,
    DateTime? deliveredAt,

    /// Motivo de fallo en texto humano-legible. Solo si status = failed.
    String? failedReason,
  }) = _RequestDeliveryEntity;

  factory RequestDeliveryEntity.fromJson(Map<String, dynamic> json) =>
      _$RequestDeliveryEntityFromJson(json);
}
