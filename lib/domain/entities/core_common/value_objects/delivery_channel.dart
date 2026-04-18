// ============================================================================
// lib/domain/entities/core_common/value_objects/delivery_channel.dart
// Canales de transporte de una OperationalRequest (Core Common v1).
// ============================================================================
// Qué hace:
//   - Declara el enum wire-stable de canales disponibles para RequestDelivery.
//   - Expone si el canal requiere Relación vinculada y si soporta 'seen' nativo.
//
// Qué NO hace:
//   - No integra APIs externas de WhatsApp / Email (v1 usa intents asistidos).
//   - No decide políticas de reintento (eso es del syncService).
//   - No mezcla con DeliveryStatus: canal y estado son dimensiones distintas.
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//   - La Solicitud SIEMPRE nace estructurada en Avanzza; el canal puede degradar.
//
// Enterprise Notes:
//   - 'inApp' es el único canal que requiere Relación = vinculada.
//   - Canales externos funcionan desde Relación = referenciada (degradable).
//   - 'manual' es fallback: el emisor reporta que envió por otro medio.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Canal de transporte de una RequestDelivery.
enum DeliveryChannel {
  /// Canal bilateral dentro de Avanzza. Exige Relación = vinculada.
  @JsonValue('inApp')
  inApp,

  /// WhatsApp vía intent asistido (v1: wa.me / wa.me/send, no API oficial).
  @JsonValue('whatsappExternal')
  whatsappExternal,

  /// Email externo vía intent (mailto:). v1: sin tracking automático.
  @JsonValue('emailExternal')
  emailExternal,

  /// Reporte manual: el emisor envió por otro medio y deja constancia.
  @JsonValue('manual')
  manual,
}

/// Extensión con wire names estables y reglas mínimas del canal.
extension DeliveryChannelX on DeliveryChannel {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case DeliveryChannel.inApp:
        return 'inApp';
      case DeliveryChannel.whatsappExternal:
        return 'whatsappExternal';
      case DeliveryChannel.emailExternal:
        return 'emailExternal';
      case DeliveryChannel.manual:
        return 'manual';
    }
  }

  /// Parse estricto desde wire.
  static DeliveryChannel fromWire(String raw) {
    switch (raw) {
      case 'inApp':
        return DeliveryChannel.inApp;
      case 'whatsappExternal':
        return DeliveryChannel.whatsappExternal;
      case 'emailExternal':
        return DeliveryChannel.emailExternal;
      case 'manual':
        return DeliveryChannel.manual;
      default:
        throw ArgumentError('DeliveryChannel desconocido: $raw');
    }
  }

  /// Si el canal requiere que la Relación esté en estado 'vinculada'.
  /// Solo inApp lo exige: canales externos permiten degradación temprana.
  bool get requiresLinkedRelationship => this == DeliveryChannel.inApp;

  /// Si el canal soporta confirmación nativa de 'delivered' sin intervención del emisor.
  /// En v1 solo inApp lo soporta; los externos requieren marca manual del emisor.
  bool get supportsNativeDeliveredAck => this == DeliveryChannel.inApp;

  /// Si el canal soporta 'seen' (confirmación de lectura automática).
  /// En v1 solo inApp lo soporta.
  bool get supportsNativeSeenAck => this == DeliveryChannel.inApp;

  /// Si el canal es externo a Avanzza (requiere acción fuera de la app).
  bool get isExternal =>
      this == DeliveryChannel.whatsappExternal ||
      this == DeliveryChannel.emailExternal ||
      this == DeliveryChannel.manual;
}
