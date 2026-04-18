// ============================================================================
// lib/domain/services/core_common/relationship_state_machine.dart
// RELATIONSHIP STATE MACHINE — Core Common v1 / Motor puro (F2.a)
// ============================================================================
// QUÉ HACE:
//   - Define el motor puro de transiciones de OperationalRelationship.
//   - Acepta un snapshot del estado + un evento + ahora, y retorna la
//     transición resultante (nuevo estado + diffs de timestamps/campos).
//   - Es función pura: sin I/O, sin Isar, sin Firestore, sin ambiente.
//
// QUÉ NO HACE:
//   - No persiste: el caller es responsable de aplicar la transición a la
//     entidad y persistir vía el repositorio.
//   - No conoce Requests ni Deliveries: motores independientes (F2.b).
//   - No orquesta: los casos de uso compondrán este motor con el matcher,
//     con el delivery dispatcher, con el outbox, etc.
//
// PRINCIPIOS:
//   - Dominio puro. Solo imports de value objects de Core Common v1.
//   - Invariantes validadas por evento:
//       · matcherConfirmedHighTrust: exige trustLevel=alto + platformActorId.
//       · invitationAccepted: exige targetPlatformActorId en snapshot (vinculada
//         requiere match confirmado).
//       · suspend: exige suspensionReason.
//   - Transiciones inválidas lanzan IllegalRelationshipTransition con contexto.
//   - Al volver a 'referenciada' desde activadaUnilateral o desde detectable,
//     se limpia platformActor + matchTrustLevel (clean slate semántico).
//   - 'cerrada' es terminal dura: no se expone evento que salga desde ella.
//   - 'close' admite cierre administrativo local desde cualquier estado no
//     terminal (referenciada, detectable, activadaUnilateral, vinculada,
//     suspendida). Desde referenciada/detectable es cierre local explícito sin
//     vínculo bilateral; el contexto del match (si existe) se preserva para
//     auditoría (no se limpia platformActor ni matchTrustLevel).
//
// ENTERPRISE NOTES:
//   - stateUpdatedAt siempre se setea al 'now' provisto por el caller.
//   - Los timestamps específicos (activatedUnilaterallyAt, linkedAt,
//     suspendedAt, closedAt) se setean solo en la transición que los dispara.
//   - resume NO cambia linkedAt: el vínculo recuperado conserva su fecha original.
// ============================================================================

import '../../entities/core_common/value_objects/match_trust_level.dart';
import '../../entities/core_common/value_objects/relationship_state.dart';
import '../../entities/core_common/value_objects/relationship_suspension_reason.dart';

/// Eventos que pueden disparar una transición de la Relación.
/// El motor decide el estado siguiente y los diffs que el caller debe aplicar.
enum RelationshipEvent {
  /// El matcher confirmó un match con trustLevel=alto. Desde 'referenciada'.
  matcherConfirmedHighTrust,

  /// El match se invalidó (llave revocada, reasignación). Desde 'detectable'.
  matcherInvalidated,

  /// Un RequestDelivery quedó en 'dispatched' o 'confirmedByEmitter'.
  /// Desde 'referenciada' o 'detectable'. Regla de activación real.
  deliveryDispatched,

  /// La contraparte aceptó formalmente la invitación. Desde 'activadaUnilateral'.
  invitationAccepted,

  /// La invitación venció sin aceptación. Desde 'activadaUnilateral'.
  invitationExpired,

  /// El emisor revocó la invitación. Desde 'activadaUnilateral'.
  invitationRevoked,

  /// Suspensión explícita del vínculo. Desde 'vinculada'.
  suspend,

  /// Reactivación desde suspensión. Desde 'suspendida'.
  resume,

  /// Cierre definitivo. Desde 'activadaUnilateral', 'vinculada' o 'suspendida'.
  close,
}

/// Vista mínima del estado actual necesaria para decidir una transición.
/// No es la entidad completa: solo los campos que el motor consulta.
class RelationshipSnapshot {
  final RelationshipState state;
  final String? targetPlatformActorId;
  final MatchTrustLevel? matchTrustLevel;

  const RelationshipSnapshot({
    required this.state,
    this.targetPlatformActorId,
    this.matchTrustLevel,
  });
}

/// Resultado de una transición válida. Describe el estado siguiente y los
/// diffs que el caller debe aplicar a la entidad antes de persistir.
///
/// Los flags clear* indican que el campo correspondiente de la entidad debe
/// quedar en null tras aplicar la transición.
class RelationshipTransition {
  final RelationshipState nextState;
  final DateTime stateUpdatedAt;

  final DateTime? activatedUnilaterallyAt;
  final DateTime? linkedAt;
  final DateTime? suspendedAt;
  final DateTime? closedAt;

  final RelationshipSuspensionReason? suspensionReason;

  /// Nuevo targetPlatformActorId a setear. Null = sin cambio (o clear).
  final String? targetPlatformActorId;

  /// Nuevo matchTrustLevel a setear. Null = sin cambio (o clear).
  final MatchTrustLevel? matchTrustLevel;

  /// Si true, el caller debe setear targetPlatformActorId=null tras aplicar.
  final bool clearPlatformActor;

  /// Si true, el caller debe setear matchTrustLevel=null tras aplicar.
  final bool clearMatchTrustLevel;

  /// Si true, el caller debe setear suspensionReason=null tras aplicar.
  final bool clearSuspensionReason;

  const RelationshipTransition({
    required this.nextState,
    required this.stateUpdatedAt,
    this.activatedUnilaterallyAt,
    this.linkedAt,
    this.suspendedAt,
    this.closedAt,
    this.suspensionReason,
    this.targetPlatformActorId,
    this.matchTrustLevel,
    this.clearPlatformActor = false,
    this.clearMatchTrustLevel = false,
    this.clearSuspensionReason = false,
  });
}

/// Excepción tipada para transiciones inválidas.
/// Lleva contexto suficiente para que el caller decida cómo manejarla.
class IllegalRelationshipTransition implements Exception {
  final RelationshipState from;
  final RelationshipEvent event;
  final String reason;

  const IllegalRelationshipTransition({
    required this.from,
    required this.event,
    required this.reason,
  });

  @override
  String toString() =>
      'IllegalRelationshipTransition(from=${from.wireName}, event=$event, reason=$reason)';
}

/// Motor puro de transiciones.
///
/// Recibe el [current] snapshot + [event] disparador + [now] y retorna la
/// transición válida. Los parámetros opcionales aportan datos específicos
/// del evento (ej. matcherConfirmedHighTrust requiere incomingPlatformActorId
/// e incomingTrustLevel).
///
/// Lanza [IllegalRelationshipTransition] si el evento no es admisible desde
/// el estado actual o si faltan datos de invariante.
RelationshipTransition transitionRelationship({
  required RelationshipSnapshot current,
  required RelationshipEvent event,
  required DateTime now,
  String? incomingPlatformActorId,
  MatchTrustLevel? incomingTrustLevel,
  RelationshipSuspensionReason? suspensionReason,
}) {
  switch (event) {
    case RelationshipEvent.matcherConfirmedHighTrust:
      if (current.state != RelationshipState.referenciada) {
        throw IllegalRelationshipTransition(
          from: current.state,
          event: event,
          reason:
              'matcherConfirmedHighTrust solo aplica desde referenciada; actual=${current.state.wireName}',
        );
      }
      if (incomingPlatformActorId == null || incomingTrustLevel == null) {
        throw IllegalRelationshipTransition(
          from: current.state,
          event: event,
          reason:
              'matcherConfirmedHighTrust requiere incomingPlatformActorId e incomingTrustLevel',
        );
      }
      if (incomingTrustLevel != MatchTrustLevel.alto) {
        throw IllegalRelationshipTransition(
          from: current.state,
          event: event,
          reason:
              'solo trustLevel=alto promueve a detectable; recibido=${incomingTrustLevel.wireName}',
        );
      }
      return RelationshipTransition(
        nextState: RelationshipState.detectable,
        stateUpdatedAt: now,
        targetPlatformActorId: incomingPlatformActorId,
        matchTrustLevel: incomingTrustLevel,
      );

    case RelationshipEvent.matcherInvalidated:
      if (current.state != RelationshipState.detectable) {
        throw IllegalRelationshipTransition(
          from: current.state,
          event: event,
          reason:
              'matcherInvalidated solo aplica desde detectable; actual=${current.state.wireName}',
        );
      }
      return RelationshipTransition(
        nextState: RelationshipState.referenciada,
        stateUpdatedAt: now,
        clearPlatformActor: true,
        clearMatchTrustLevel: true,
      );

    case RelationshipEvent.deliveryDispatched:
      final allowedFrom = current.state == RelationshipState.referenciada ||
          current.state == RelationshipState.detectable;
      if (!allowedFrom) {
        throw IllegalRelationshipTransition(
          from: current.state,
          event: event,
          reason:
              'deliveryDispatched solo aplica desde referenciada o detectable; actual=${current.state.wireName}',
        );
      }
      return RelationshipTransition(
        nextState: RelationshipState.activadaUnilateral,
        stateUpdatedAt: now,
        activatedUnilaterallyAt: now,
      );

    case RelationshipEvent.invitationAccepted:
      if (current.state != RelationshipState.activadaUnilateral) {
        throw IllegalRelationshipTransition(
          from: current.state,
          event: event,
          reason:
              'invitationAccepted solo aplica desde activadaUnilateral; actual=${current.state.wireName}',
        );
      }
      if (current.targetPlatformActorId == null) {
        throw IllegalRelationshipTransition(
          from: current.state,
          event: event,
          reason:
              'invitationAccepted requiere targetPlatformActorId presente (vinculada exige match confirmado)',
        );
      }
      return RelationshipTransition(
        nextState: RelationshipState.vinculada,
        stateUpdatedAt: now,
        linkedAt: now,
      );

    case RelationshipEvent.invitationExpired:
    case RelationshipEvent.invitationRevoked:
      if (current.state != RelationshipState.activadaUnilateral) {
        throw IllegalRelationshipTransition(
          from: current.state,
          event: event,
          reason:
              '${event.name} solo aplica desde activadaUnilateral; actual=${current.state.wireName}',
        );
      }
      return RelationshipTransition(
        nextState: RelationshipState.referenciada,
        stateUpdatedAt: now,
        clearPlatformActor: true,
        clearMatchTrustLevel: true,
      );

    case RelationshipEvent.suspend:
      if (current.state != RelationshipState.vinculada) {
        throw IllegalRelationshipTransition(
          from: current.state,
          event: event,
          reason:
              'suspend solo aplica desde vinculada; actual=${current.state.wireName}',
        );
      }
      if (suspensionReason == null) {
        throw IllegalRelationshipTransition(
          from: current.state,
          event: event,
          reason: 'suspend requiere suspensionReason explícita',
        );
      }
      return RelationshipTransition(
        nextState: RelationshipState.suspendida,
        stateUpdatedAt: now,
        suspendedAt: now,
        suspensionReason: suspensionReason,
      );

    case RelationshipEvent.resume:
      if (current.state != RelationshipState.suspendida) {
        throw IllegalRelationshipTransition(
          from: current.state,
          event: event,
          reason:
              'resume solo aplica desde suspendida; actual=${current.state.wireName}',
        );
      }
      return RelationshipTransition(
        nextState: RelationshipState.vinculada,
        stateUpdatedAt: now,
        clearSuspensionReason: true,
      );

    case RelationshipEvent.close:
      // Cierre administrativo local permitido desde cualquier estado no terminal.
      // Preserva targetPlatformActorId y matchTrustLevel si existen: el cierre
      // es terminal pero el contexto histórico del match se conserva para auditoría.
      if (current.state == RelationshipState.cerrada) {
        throw IllegalRelationshipTransition(
          from: current.state,
          event: event,
          reason: 'close no aplica desde cerrada (terminal dura)',
        );
      }
      return RelationshipTransition(
        nextState: RelationshipState.cerrada,
        stateUpdatedAt: now,
        closedAt: now,
      );
  }
}
