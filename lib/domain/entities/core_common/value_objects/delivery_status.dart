// ============================================================================
// lib/domain/entities/core_common/value_objects/delivery_status.dart
// Estados de un RequestDelivery (Core Common v1).
// ============================================================================
// Qué hace:
//   - Declara el enum wire-stable de estados de un intento de transporte.
//   - Declara qué estado dispara la regla de activación real de la Relación.
//
// Qué NO hace:
//   - No maneja reintentos ni backoff (eso lo hace OfflineSyncService).
//   - No mezcla con RequestState: un Request puede estar 'sent' con un Delivery
//     'failed' y otro Delivery 'dispatched'. Son dimensiones ortogonales.
//   - No persiste ni hace I/O.
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//   - REGLA CRÍTICA (v1): la Relación pasa a 'activadaUnilateral' solo cuando
//     existe al menos un RequestDelivery en 'dispatched' o 'confirmedByEmitter'.
//     Abrir un intent de WhatsApp NO es dispatched: dispatched se registra
//     cuando el sistema confirma que el intent fue invocado correctamente.
//
// Enterprise Notes:
//   - 'queued' cubre delays del outbox / falta de red.
//   - 'failed' es operacional; el delivery puede reintentarse como nuevo registro,
//     no como mutación del fallido (trazabilidad completa).
//   - 'confirmedByEmitter' cubre canales externos/manual donde no hay ACK nativo.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Estados de un intento de transporte (RequestDelivery) para una
/// OperationalRequest. Una misma Request puede tener N deliveries.
enum DeliveryStatus {
  /// Encolado. Aún no despachado (sin red, en outbox, etc.).
  @JsonValue('queued')
  queued,

  /// Despachado: el sistema entregó al canal correspondiente
  /// (inApp escrito / intent externo invocado / endpoint aceptado).
  @JsonValue('dispatched')
  dispatched,

  /// Entregado con confirmación del canal (solo inApp en v1).
  @JsonValue('delivered')
  delivered,

  /// Falló el despacho. No muta: para reintentar se crea un delivery nuevo.
  @JsonValue('failed')
  failed,

  /// Canal externo/manual: el emisor confirma explícitamente que envió.
  @JsonValue('confirmedByEmitter')
  confirmedByEmitter,
}

/// Extensión con wire names estables y reglas clave.
extension DeliveryStatusX on DeliveryStatus {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case DeliveryStatus.queued:
        return 'queued';
      case DeliveryStatus.dispatched:
        return 'dispatched';
      case DeliveryStatus.delivered:
        return 'delivered';
      case DeliveryStatus.failed:
        return 'failed';
      case DeliveryStatus.confirmedByEmitter:
        return 'confirmedByEmitter';
    }
  }

  /// Parse estricto desde wire.
  static DeliveryStatus fromWire(String raw) {
    switch (raw) {
      case 'queued':
        return DeliveryStatus.queued;
      case 'dispatched':
        return DeliveryStatus.dispatched;
      case 'delivered':
        return DeliveryStatus.delivered;
      case 'failed':
        return DeliveryStatus.failed;
      case 'confirmedByEmitter':
        return DeliveryStatus.confirmedByEmitter;
      default:
        throw ArgumentError('DeliveryStatus desconocido: $raw');
    }
  }

  /// REGLA CRÍTICA de activación real de la Relación (v1):
  /// la Relación pasa a 'activadaUnilateral' solo cuando un delivery asociado
  /// queda en 'dispatched' o 'confirmedByEmitter'.
  /// Abrir un intent externo NO cuenta: debe registrarse el despacho exitoso.
  bool get triggersUnilateralActivation =>
      this == DeliveryStatus.dispatched ||
      this == DeliveryStatus.confirmedByEmitter;

  /// Estados que cuentan como "entregado efectivamente" para métricas operativas.
  bool get isEffectivelyDelivered =>
      this == DeliveryStatus.delivered ||
      this == DeliveryStatus.confirmedByEmitter;

  /// Estados terminales del delivery (no mutan; un nuevo intento es un nuevo delivery).
  bool get isTerminal =>
      this == DeliveryStatus.delivered ||
      this == DeliveryStatus.failed ||
      this == DeliveryStatus.confirmedByEmitter;
}
