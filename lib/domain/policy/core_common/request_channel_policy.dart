// ============================================================================
// lib/domain/policy/core_common/request_channel_policy.dart
// REQUEST CHANNEL POLICY — Core Common v1 / Blindaje F2.b
// ============================================================================
// QUÉ HACE:
//   - Valida que ciertos eventos del RequestStateMachine solo se inviten
//     desde canales que REALMENTE los soportan nativamente.
//   - Eventos sensibles a canal en v1:
//       · markDelivered  → requiere canal con ACK de entrega nativo.
//       · markSeen       → requiere canal con ACK de lectura nativo.
//
// QUÉ NO HACE:
//   - No vive dentro de RequestStateMachine: el motor permanece puro y agnóstico
//     del canal. La policy es un guard SEPARADO que los casos de uso invocan
//     ANTES de llamar al motor.
//   - No decide si un delivery es 'confirmedByEmitter': eso se maneja en el
//     caso de uso de registro de delivery (F6/F7), NO aquí.
//   - No valida el resto de eventos (send, markResponded, accept, reject,
//     expire, close): esos son agnósticos del canal y se resuelven en el motor.
//
// PRINCIPIOS:
//   - Dominio puro. Solo imports de value objects y de eventos del motor.
//   - Fail-hard: si el canal no soporta el evento, lanza
//     RequestChannelPolicyViolation con contexto completo. Sin fallback silencioso.
//   - Asimetría explícita entre 'delivered' y 'confirmedByEmitter':
//       · delivered           = ACK real del canal (autoridad del transporte).
//       · confirmedByEmitter  = afirmación del emisor, sin ACK del canal.
//     La Request solo escala a RequestState.delivered con la primera. Para la
//     segunda, la Request permanece en 'sent' y el RequestDelivery queda en
//     DeliveryStatus.confirmedByEmitter para trazabilidad.
//
// ENTERPRISE NOTES:
//   - En v1 solo DeliveryChannel.inApp tiene supportsNativeDeliveredAck=true
//     y supportsNativeSeenAck=true. whatsappExternal, emailExternal y manual
//     son rechazados por esta policy para markDelivered y markSeen.
//   - Si v1.x agrega integración con la API oficial de WhatsApp, bastará
//     actualizar DeliveryChannelX.supportsNativeDeliveredAck; esta policy
//     se adapta sin cambios.
//
// FLUJO DE USO (caso de uso F5+):
//   1) policy.guardChannelSupports(event, channel)   // lanza si no aplica
//   2) transitionRequest(current, event, now)        // motor puro
//   3) repo.save(...)                                // persistencia
// ============================================================================

import '../../entities/core_common/value_objects/delivery_channel.dart';
import '../../services/core_common/request_state_machine.dart';

/// Excepción tipada emitida por RequestChannelPolicy.
/// Lleva contexto suficiente para debugging y auditoría.
class RequestChannelPolicyViolation implements Exception {
  final RequestEvent event;
  final DeliveryChannel channel;
  final String reason;

  const RequestChannelPolicyViolation({
    required this.event,
    required this.channel,
    required this.reason,
  });

  @override
  String toString() =>
      'RequestChannelPolicyViolation(event=$event, channel=${channel.wireName}, reason=$reason)';
}

/// Policy que valida la compatibilidad entre evento de Request y canal de delivery.
/// Funciones puras. Invocación obligatoria ANTES del motor en casos de uso.
class RequestChannelPolicy {
  const RequestChannelPolicy();

  /// Eventos cuyo disparo depende del soporte nativo del canal.
  /// El resto de eventos del motor no consulta esta policy.
  static const Set<RequestEvent> channelSensitiveEvents = <RequestEvent>{
    RequestEvent.markDelivered,
    RequestEvent.markSeen,
  };

  /// Valida que el evento sea admisible para el canal dado.
  ///
  /// Reglas v1:
  ///   - markDelivered exige channel.supportsNativeDeliveredAck == true.
  ///   - markSeen      exige channel.supportsNativeSeenAck == true.
  ///   - cualquier otro evento pasa (no es sensible a canal).
  ///
  /// Lanza [RequestChannelPolicyViolation] si la combinación no es válida.
  void guardChannelSupports({
    required RequestEvent event,
    required DeliveryChannel channel,
  }) {
    if (!channelSensitiveEvents.contains(event)) {
      return; // Eventos no sensibles al canal: no-op.
    }

    switch (event) {
      case RequestEvent.markDelivered:
        if (!channel.supportsNativeDeliveredAck) {
          throw RequestChannelPolicyViolation(
            event: event,
            channel: channel,
            reason:
                'markDelivered exige canal con ACK nativo de entrega. '
                'El canal ${channel.wireName} no lo soporta. '
                'Para canales externos/manual, registra un RequestDelivery con '
                'status=confirmedByEmitter — confirmedByEmitter NO es equivalente '
                'a RequestState.delivered y NO debe dispararse markDelivered '
                'en esos canales.',
          );
        }
        return;

      case RequestEvent.markSeen:
        if (!channel.supportsNativeSeenAck) {
          throw RequestChannelPolicyViolation(
            event: event,
            channel: channel,
            reason:
                'markSeen exige canal con ACK nativo de lectura. '
                'El canal ${channel.wireName} no lo soporta. '
                'Los canales externos no reportan lectura automáticamente en v1.',
          );
        }
        return;

      // Los demás eventos no son sensibles a canal; no deberían llegar aquí
      // porque channelSensitiveEvents los descarta arriba. Defensa en profundidad.
      case RequestEvent.send:
      case RequestEvent.markResponded:
      case RequestEvent.accept:
      case RequestEvent.reject:
      case RequestEvent.expire:
      case RequestEvent.close:
        return;
    }
  }
}
