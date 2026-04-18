// ============================================================================
// lib/domain/entities/core_common/value_objects/request_origin_channel.dart
// Canal de origen de una OperationalRequest (Core Common v1).
// ============================================================================
// Qué hace:
//   - Registra cómo se originó la Solicitud Estructurada.
//   - Distingue origen inApp puro vs origen asistido externo.
//
// Qué NO hace:
//   - No equivale a DeliveryChannel: el origen puede ser inApp mientras el
//     delivery termina siendo whatsappExternal (degradable).
//   - No implica transporte: una Request con origin=inApp puede tener deliveries
//     en whatsappExternal, emailExternal o manual.
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//   - Regla dura: la Solicitud SIEMPRE nace estructurada en Avanzza.
//     El origen externo puro NO existe; solo existen deliveries externos.
//
// Enterprise Notes:
//   - 'inApp' = el emisor creó la Request dentro de la app y la envió inApp
//     (requiere Relación vinculada para delivery inApp bilateral).
//   - 'externalAssisted' = el emisor creó la Request dentro de la app pero
//     optó desde origen por canal externo asistido (intent WhatsApp/email).
//     La Request existe con trazabilidad aunque el canal sea externo.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Canal con el que se ORIGINA (no transporta) una OperationalRequest.
enum RequestOriginChannel {
  /// Creada y emitida dentro de Avanzza con canal bilateral inApp.
  @JsonValue('inApp')
  inApp,

  /// Creada dentro de Avanzza con intención explícita de envío externo asistido.
  @JsonValue('externalAssisted')
  externalAssisted,
}

/// Extensión con wire names estables.
extension RequestOriginChannelX on RequestOriginChannel {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case RequestOriginChannel.inApp:
        return 'inApp';
      case RequestOriginChannel.externalAssisted:
        return 'externalAssisted';
    }
  }

  /// Parse estricto desde wire.
  static RequestOriginChannel fromWire(String raw) {
    switch (raw) {
      case 'inApp':
        return RequestOriginChannel.inApp;
      case 'externalAssisted':
        return RequestOriginChannel.externalAssisted;
      default:
        throw ArgumentError('RequestOriginChannel desconocido: $raw');
    }
  }

  /// Si el origen exige Relación = vinculada para poder emitir.
  /// 'inApp' lo exige; 'externalAssisted' no (degradable).
  bool get requiresLinkedRelationship => this == RequestOriginChannel.inApp;
}
