// ============================================================================
// lib/domain/services/core_common/request_state_machine.dart
// REQUEST STATE MACHINE — Core Common v1 / Motor puro (F2.b)
// ============================================================================
// QUÉ HACE:
//   - Define el motor puro de transiciones de OperationalRequest.
//   - Acepta snapshot del estado + evento + ahora, retorna transición resultante.
//   - Es función pura: sin I/O, sin Isar, sin Firestore, sin ambiente.
//
// QUÉ NO HACE:
//   - No conoce el estado de la Relación ni recibe RelationshipState / contexto
//     de Relación como input. INDEPENDENCIA TOTAL (regla crítica v1).
//   - No maneja deliveries (esos tienen su propia máquina, DeliveryStatus).
//   - No valida qué canal soporta 'seen' (eso es del caller, via DeliveryChannel).
//   - No persiste: el caller aplica la transición a la entidad y persiste vía repo.
//
// PRINCIPIOS:
//   - Dominio puro. Solo imports de value objects de Request.
//   - Invariantes de evento validadas:
//       · send exige estado=draft.
//       · markDelivered/markSeen/markResponded exigen estados origen válidos.
//       · expire solo aplica a estados 'en vuelo' (sent, delivered, seen, responded).
//         NO aplica a draft (sin enviar nada que expirar) ni a accepted/rejected
//         (terminales suaves finales).
//       · close admite desde cualquier estado no cerrado (incluido draft:
//         cancelación de borrador; incluido accepted/rejected/expired como
//         cierre administrativo explícito).
//   - Transiciones inválidas lanzan IllegalRequestTransition con contexto.
//   - 'closed' es terminal dura. No se expone evento que salga desde ella.
//
// ENTERPRISE NOTES:
//   - stateUpdatedAt siempre al 'now' provisto por el caller.
//   - sentAt solo en send; respondedAt solo en markResponded; closedAt solo en close.
//   - El motor NO setea expiresAt: esa fecha se decide al enviar (política del
//     requestKind) y se preserva en la entidad. El evento 'expire' no la recalcula.
//   - El payload de la Request es inmutable tras 'sent': este motor no lo toca.
// ============================================================================

import '../../entities/core_common/value_objects/request_state.dart';

/// Eventos que pueden disparar una transición de la Request.
enum RequestEvent {
  /// Emisión inicial. Desde 'draft'.
  send,

  /// Confirmación de entrega (ACK del canal o marca manual del emisor). Desde 'sent'.
  markDelivered,

  /// Confirmación de lectura (solo canales que lo soporten, responsabilidad del caller).
  /// Desde 'delivered'.
  markSeen,

  /// El receptor respondió. Desde 'sent', 'delivered' o 'seen'.
  markResponded,

  /// El receptor aceptó operativamente. Desde 'responded'. Terminal suave.
  accept,

  /// El receptor rechazó operativamente. Desde 'responded'. Terminal suave.
  reject,

  /// Expiración por política temporal. Desde 'sent', 'delivered', 'seen' o 'responded'.
  expire,

  /// Cierre administrativo explícito. Desde cualquier estado excepto 'closed'.
  close,
}

/// Vista mínima del estado actual para decidir la transición.
/// No incluye campos de Relación ni de deliveries: motores independientes.
class RequestSnapshot {
  final RequestState state;

  const RequestSnapshot({required this.state});
}

/// Resultado de una transición válida. Describe el estado siguiente y los
/// diffs de timestamps que el caller debe aplicar a la entidad.
class RequestTransition {
  final RequestState nextState;
  final DateTime stateUpdatedAt;

  final DateTime? sentAt;
  final DateTime? respondedAt;
  final DateTime? closedAt;

  const RequestTransition({
    required this.nextState,
    required this.stateUpdatedAt,
    this.sentAt,
    this.respondedAt,
    this.closedAt,
  });
}

/// Excepción tipada para transiciones inválidas.
class IllegalRequestTransition implements Exception {
  final RequestState from;
  final RequestEvent event;
  final String reason;

  const IllegalRequestTransition({
    required this.from,
    required this.event,
    required this.reason,
  });

  @override
  String toString() =>
      'IllegalRequestTransition(from=${from.wireName}, event=$event, reason=$reason)';
}

/// Motor puro de transiciones de Request.
///
/// Lanza [IllegalRequestTransition] si el evento no es admisible desde
/// el estado actual.
RequestTransition transitionRequest({
  required RequestSnapshot current,
  required RequestEvent event,
  required DateTime now,
}) {
  switch (event) {
    case RequestEvent.send:
      if (current.state != RequestState.draft) {
        throw IllegalRequestTransition(
          from: current.state,
          event: event,
          reason:
              'send solo aplica desde draft; actual=${current.state.wireName}',
        );
      }
      return RequestTransition(
        nextState: RequestState.sent,
        stateUpdatedAt: now,
        sentAt: now,
      );

    case RequestEvent.markDelivered:
      if (current.state != RequestState.sent) {
        throw IllegalRequestTransition(
          from: current.state,
          event: event,
          reason:
              'markDelivered solo aplica desde sent; actual=${current.state.wireName}',
        );
      }
      return RequestTransition(
        nextState: RequestState.delivered,
        stateUpdatedAt: now,
      );

    case RequestEvent.markSeen:
      if (current.state != RequestState.delivered) {
        throw IllegalRequestTransition(
          from: current.state,
          event: event,
          reason:
              'markSeen solo aplica desde delivered; actual=${current.state.wireName}. '
              'El soporte de seen es responsabilidad del canal (caller).',
        );
      }
      return RequestTransition(
        nextState: RequestState.seen,
        stateUpdatedAt: now,
      );

    case RequestEvent.markResponded:
      const allowed = <RequestState>{
        RequestState.sent,
        RequestState.delivered,
        RequestState.seen,
      };
      if (!allowed.contains(current.state)) {
        throw IllegalRequestTransition(
          from: current.state,
          event: event,
          reason:
              'markResponded solo aplica desde sent, delivered o seen; actual=${current.state.wireName}',
        );
      }
      return RequestTransition(
        nextState: RequestState.responded,
        stateUpdatedAt: now,
        respondedAt: now,
      );

    case RequestEvent.accept:
      if (current.state != RequestState.responded) {
        throw IllegalRequestTransition(
          from: current.state,
          event: event,
          reason:
              'accept solo aplica desde responded; actual=${current.state.wireName}',
        );
      }
      return RequestTransition(
        nextState: RequestState.accepted,
        stateUpdatedAt: now,
      );

    case RequestEvent.reject:
      if (current.state != RequestState.responded) {
        throw IllegalRequestTransition(
          from: current.state,
          event: event,
          reason:
              'reject solo aplica desde responded; actual=${current.state.wireName}',
        );
      }
      return RequestTransition(
        nextState: RequestState.rejected,
        stateUpdatedAt: now,
      );

    case RequestEvent.expire:
      // expire aplica solo a estados 'en vuelo'. Excluye draft (nada enviado)
      // y terminales suaves (accepted/rejected): ya resueltos. Tampoco closed.
      const expirable = <RequestState>{
        RequestState.sent,
        RequestState.delivered,
        RequestState.seen,
        RequestState.responded,
      };
      if (!expirable.contains(current.state)) {
        throw IllegalRequestTransition(
          from: current.state,
          event: event,
          reason:
              'expire solo aplica desde sent, delivered, seen o responded; actual=${current.state.wireName}',
        );
      }
      return RequestTransition(
        nextState: RequestState.expired,
        stateUpdatedAt: now,
      );

    case RequestEvent.close:
      // Cierre administrativo explícito. Válido desde cualquier estado no-terminal-duro.
      // Incluye draft (cancelar borrador) y los terminales suaves
      // (accepted/rejected/expired) como cierre administrativo.
      if (current.state == RequestState.closed) {
        throw IllegalRequestTransition(
          from: current.state,
          event: event,
          reason: 'close no aplica desde closed (terminal dura)',
        );
      }
      return RequestTransition(
        nextState: RequestState.closed,
        stateUpdatedAt: now,
        closedAt: now,
      );
  }
}
