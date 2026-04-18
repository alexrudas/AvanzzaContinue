// ============================================================================
// lib/domain/entities/core_common/value_objects/request_state.dart
// Estados de la Solicitud Estructurada (Core Common v1).
// ============================================================================
// Qué hace:
//   - Declara el enum wire-stable de estados de OperationalRequest.
//   - Expone la tabla de transiciones permitidas (allowedNext).
//   - Expresa invariantes por estado (terminal, editable, finalizado).
//
// Qué NO hace:
//   - No conoce el estado de la Relación: el ciclo de vida es INDEPENDIENTE.
//     Una Request puede estar en 'sent' o 'delivered' mientras la Relación está
//     en 'referenciada' o 'activadaUnilateral' (degradable por canal externo).
//   - No maneja deliveries: RequestDelivery tiene su propia máquina (DeliveryStatus).
//   - No gestiona reintentos ni encolado; ese es el outbox / syncService.
//
// Principios:
//   - Dominio puro. Solo dart:core + freezed_annotation.
//   - Wire name estable.
//   - @JsonValue sincronizado con wireName manualmente.
//   - Independencia total del estado de la Relación (regla crítica v1).
//   - Terminales: accepted / rejected / expired / closed. Desde los tres primeros
//     se admite 'closed' como cierre administrativo explícito.
//
// Enterprise Notes:
//   - 'seen' solo aplica cuando el canal lo soporta (inApp). En canales externos
//     el emisor puede saltarse 'seen' y marcar 'responded' directamente.
//   - 'expired' se dispara por política temporal; es terminal salvo cierre admin.
//   - El payload no se puede editar tras 'sent'. Una Request enviada es inmutable
//     en contenido; solo cambia su estado y sus deliveries asociados.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Estados del ciclo de vida de una OperationalRequest.
/// Ortogonal al estado de la Relación. Ambos motores corren en paralelo.
enum RequestState {
  /// Creada, aún no emitida. Editable.
  @JsonValue('draft')
  draft,

  /// Emitida hacia al menos un canal (inApp o externo).
  @JsonValue('sent')
  sent,

  /// Confirmación de entrega disponible (automática o manual del emisor).
  @JsonValue('delivered')
  delivered,

  /// Confirmación de lectura del receptor. Solo canales que lo soporten (inApp).
  @JsonValue('seen')
  seen,

  /// El receptor generó una respuesta (estructurada o texto libre).
  @JsonValue('responded')
  responded,

  /// El receptor marcó aceptación operativa. Terminal suave.
  @JsonValue('accepted')
  accepted,

  /// El receptor marcó rechazo operativo. Terminal suave.
  @JsonValue('rejected')
  rejected,

  /// Venció el tiempo (expiresAt) sin respuesta. Terminal suave.
  @JsonValue('expired')
  expired,

  /// Cerrada por el emisor o por cierre administrativo. Terminal duro.
  @JsonValue('closed')
  closed,
}

/// Extensión con wire names estables, invariantes y tabla de transiciones.
extension RequestStateX on RequestState {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case RequestState.draft:
        return 'draft';
      case RequestState.sent:
        return 'sent';
      case RequestState.delivered:
        return 'delivered';
      case RequestState.seen:
        return 'seen';
      case RequestState.responded:
        return 'responded';
      case RequestState.accepted:
        return 'accepted';
      case RequestState.rejected:
        return 'rejected';
      case RequestState.expired:
        return 'expired';
      case RequestState.closed:
        return 'closed';
    }
  }

  /// Parse estricto desde wire. Lanza ArgumentError si es desconocido.
  static RequestState fromWire(String raw) {
    switch (raw) {
      case 'draft':
        return RequestState.draft;
      case 'sent':
        return RequestState.sent;
      case 'delivered':
        return RequestState.delivered;
      case 'seen':
        return RequestState.seen;
      case 'responded':
        return RequestState.responded;
      case 'accepted':
        return RequestState.accepted;
      case 'rejected':
        return RequestState.rejected;
      case 'expired':
        return RequestState.expired;
      case 'closed':
        return RequestState.closed;
      default:
        throw ArgumentError('RequestState desconocido: $raw');
    }
  }

  /// Terminal duro: no admite transiciones salientes.
  bool get isHardTerminal => this == RequestState.closed;

  /// Terminal suave: solo admite 'closed' como cierre administrativo.
  bool get isSoftTerminal =>
      this == RequestState.accepted ||
      this == RequestState.rejected ||
      this == RequestState.expired;

  /// Payload editable solo en 'draft'. Tras 'sent' el contenido es inmutable.
  bool get isPayloadEditable => this == RequestState.draft;

  /// Estados en los que es válido registrar un RequestDelivery nuevo
  /// (reenvío, canal adicional, confirmación cruzada).
  bool get allowsNewDelivery =>
      this == RequestState.sent ||
      this == RequestState.delivered ||
      this == RequestState.seen ||
      this == RequestState.responded;

  /// Tabla de transiciones permitidas desde este estado.
  /// Regla dura: 'closed' siempre alcanzable desde cualquier no-terminal duro.
  Set<RequestState> get allowedNext {
    switch (this) {
      case RequestState.draft:
        return const {RequestState.sent, RequestState.closed};
      case RequestState.sent:
        return const {
          RequestState.delivered,
          RequestState.responded,
          RequestState.expired,
          RequestState.closed,
        };
      case RequestState.delivered:
        return const {
          RequestState.seen,
          RequestState.responded,
          RequestState.expired,
          RequestState.closed,
        };
      case RequestState.seen:
        return const {
          RequestState.responded,
          RequestState.expired,
          RequestState.closed,
        };
      case RequestState.responded:
        return const {
          RequestState.accepted,
          RequestState.rejected,
          RequestState.expired,
          RequestState.closed,
        };
      case RequestState.accepted:
        return const {RequestState.closed};
      case RequestState.rejected:
        return const {RequestState.closed};
      case RequestState.expired:
        return const {RequestState.closed};
      case RequestState.closed:
        return const {};
    }
  }

  /// Chequeo rápido. El motor (F2.b) agrega guardas adicionales.
  bool canTransitionTo(RequestState target) => allowedNext.contains(target);
}
