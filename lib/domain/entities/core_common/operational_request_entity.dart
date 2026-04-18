// ============================================================================
// lib/domain/entities/core_common/operational_request_entity.dart
// OPERATIONAL REQUEST ENTITY — Core Common v1 / Solicitud Estructurada
// ============================================================================
// QUÉ HACE:
//   - Modela la Solicitud Estructurada: moneda de cambio del sistema.
//   - Anclada a una Relación Operativa vía relationshipId (obligatorio).
//   - Ciclo de vida gobernado por RequestStateMachine (F2.b) INDEPENDIENTE
//     del ciclo de vida de la Relación.
//
// QUÉ NO HACE:
//   - No contiene sus deliveries embebidos (RequestDelivery es entidad aparte).
//   - No valida transiciones: eso es F2.b.
//   - No tipa el payload: en v1 es opaco (payloadJson). Extensiones por
//     requestKind llegan después.
//   - No condiciona el estado de la Relación: motores ortogonales.
//
// PRINCIPIOS:
//   - Dominio puro + freezed + json_serializable.
//   - Payload mínimo obligatorio (ajuste explícito del usuario):
//       id, requestKind, title, createdBy, originChannel, createdAt, state
//     Interpretación de "title o summary": title obligatorio, summary opcional.
//   - Origen SIEMPRE estructurado (originChannel); el transporte puede degradar
//     vía RequestDelivery con canales externos.
//   - Enums serializados vía @JsonValue (wire-stable).
//
// ENTERPRISE NOTES:
//   - sourceWorkspaceId ≡ orgId del tenant emisor.
//   - createdBy es el userId del miembro del workspace que creó la Request.
//   - payloadJson permanece opaco hasta que un requestKind vertical defina esquema.
//   - Enviar una Request desde Relación = referenciada por canal externo dispara
//     la transición a activadaUnilateral SOLO si el delivery queda en
//     dispatched | confirmedByEmitter (regla de activación real).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'value_objects/request_kind.dart';
import 'value_objects/request_origin_channel.dart';
import 'value_objects/request_state.dart';

part 'operational_request_entity.freezed.dart';
part 'operational_request_entity.g.dart';

/// Solicitud Estructurada emitida por un workspace, anclada a una Relación.
/// Ciclo de vida INDEPENDIENTE del estado de la Relación.
@freezed
abstract class OperationalRequestEntity with _$OperationalRequestEntity {
  const factory OperationalRequestEntity({
    required String id,

    /// Workspace emisor. ≡ orgId del tenant.
    required String sourceWorkspaceId,

    /// FK obligatoria a la Relación a la que pertenece la Solicitud.
    /// Obligatorio incluso si la Relación está en 'referenciada'.
    required String relationshipId,

    /// Tipología semántica. En v1 siempre 'generic'.
    @Default(RequestKind.generic) RequestKind requestKind,

    /// Estado actual de la Solicitud. Gobierno por F2.b, ortogonal a la Relación.
    required RequestState state,

    /// Título de la solicitud. Campo mínimo obligatorio (ajuste del usuario).
    required String title,

    /// userId del miembro del workspace que creó la Solicitud.
    required String createdBy,

    /// Canal con el que se originó la Solicitud (no confundir con transporte).
    required RequestOriginChannel originChannel,

    required DateTime createdAt,
    required DateTime updatedAt,

    /// Timestamp de la última transición de estado.
    required DateTime stateUpdatedAt,

    /// Resumen breve adicional al título. Opcional.
    String? summary,

    /// Payload JSON opaco. Extensible por requestKind en fases posteriores.
    /// Su contenido NO se interpreta en Core Common v1.
    String? payloadJson,

    /// Nota libre del emisor incluida con la emisión. Opcional.
    String? notesSource,

    /// Timestamps de transiciones clave para trazabilidad.
    DateTime? sentAt,
    DateTime? respondedAt,
    DateTime? closedAt,

    /// Expiración configurada en el momento de envío (política futura).
    DateTime? expiresAt,
  }) = _OperationalRequestEntity;

  factory OperationalRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$OperationalRequestEntityFromJson(json);
}
