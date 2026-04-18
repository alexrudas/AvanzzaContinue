// ============================================================================
// lib/domain/entities/core_common/value_objects/delivery_direction.dart
// Dirección de un RequestDelivery (Core Common v1 — complemento de F1.a).
// ============================================================================
// Qué hace:
//   - Distingue si un RequestDelivery representa un envío (outbound) o un
//     acuse de recibo del receptor (inboundAck).
//
// Qué NO hace:
//   - No modela respuestas estructuradas (eso es RequestState → responded).
//   - No ejecuta transporte; es solo el catálogo tipado.
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//
// Enterprise Notes:
//   - En v1 'inboundAck' aplica principalmente a confirmaciones manuales del
//     emisor sobre canales externos ("cliente me contestó por WhatsApp").
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Dirección de un RequestDelivery.
enum DeliveryDirection {
  /// Delivery saliente: el workspace envía hacia el target.
  @JsonValue('outbound')
  outbound,

  /// Acuse o respuesta de entrada registrada sobre el delivery.
  @JsonValue('inboundAck')
  inboundAck,
}

/// Extensión con wire names estables.
extension DeliveryDirectionX on DeliveryDirection {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case DeliveryDirection.outbound:
        return 'outbound';
      case DeliveryDirection.inboundAck:
        return 'inboundAck';
    }
  }

  /// Parse estricto desde wire.
  static DeliveryDirection fromWire(String raw) {
    switch (raw) {
      case 'outbound':
        return DeliveryDirection.outbound;
      case 'inboundAck':
        return DeliveryDirection.inboundAck;
      default:
        throw ArgumentError('DeliveryDirection desconocido: $raw');
    }
  }
}
