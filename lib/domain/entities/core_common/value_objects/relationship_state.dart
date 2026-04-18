// ============================================================================
// lib/domain/entities/core_common/value_objects/relationship_state.dart
// Estados de la Relación Operativa (Core Common v1).
// ============================================================================
// Qué hace:
//   - Declara el enum wire-stable de estados de OperationalRelationship.
//   - Expone la tabla de transiciones permitidas (allowedNext).
//   - Expresa invariantes mínimas por estado (terminal, requiere PlatformActor).
//
// Qué NO hace:
//   - No valida eventos (eso es el motor puro de F2.a: RelationshipStateMachine).
//   - No tiene efectos de lado, ni persistencia, ni notifica.
//   - No conoce nada de Isar, Firestore, NestJS ni UI.
//   - No mezcla reglas de Request: Relación y Request son motores independientes.
//
// Principios:
//   - Dominio puro. Solo dart:core + freezed_annotation (solo anotaciones).
//   - Wire name estable: persistencia externa NUNCA usa enum.name.
//   - @JsonValue y wireName se mantienen sincronizados manualmente.
//   - Transiciones declaradas como data table; el motor decide con base en ella.
//
// Enterprise Notes:
//   - La promoción a `detectable` es disparada por el matcher con trustLevel=alto.
//   - `activadaUnilateral` NO requiere PlatformActor (permite degradable externo).
//   - `detectable` y `vinculada` SÍ requieren PlatformActor vinculado.
//   - `cerrada` es terminal duro: no se reabre; nueva Relación si es necesario.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Estados del ciclo de vida de una OperationalRelationship.
///
/// Orden semántico (no es orden de transición forzosa):
/// referenciada → detectable → activadaUnilateral → vinculada →
/// suspendida → cerrada.
enum RelationshipState {
  /// Existe solo como registro local. Sin match confirmado, sin acción bilateral.
  @JsonValue('referenciada')
  referenciada,

  /// Matcher confirmó un PlatformActor con trustLevel=alto. No expuesto al otro lado.
  @JsonValue('detectable')
  detectable,

  /// El workspace emitió al menos una acción dirigida al target
  /// (invitación formal o delivery despachado). Sin confirmación bilateral aún.
  @JsonValue('activadaUnilateral')
  activadaUnilateral,

  /// Doble consentimiento registrado. Canal bilateral habilitado.
  @JsonValue('vinculada')
  vinculada,

  /// Vínculo pausado por cualquiera de los dos lados o por política de sistema.
  @JsonValue('suspendida')
  suspendida,

  /// Vínculo terminado definitivamente. El registro local persiste.
  @JsonValue('cerrada')
  cerrada,
}

/// Extensión con wire names estables, invariantes y tabla de transiciones.
extension RelationshipStateX on RelationshipState {
  /// Wire name estable para persistencia externa (Firestore / NestJS / Isar).
  /// No cambiar: rompe compatibilidad con snapshots existentes.
  String get wireName {
    switch (this) {
      case RelationshipState.referenciada:
        return 'referenciada';
      case RelationshipState.detectable:
        return 'detectable';
      case RelationshipState.activadaUnilateral:
        return 'activadaUnilateral';
      case RelationshipState.vinculada:
        return 'vinculada';
      case RelationshipState.suspendida:
        return 'suspendida';
      case RelationshipState.cerrada:
        return 'cerrada';
    }
  }

  /// Parse estricto desde wire. Lanza ArgumentError si el valor es desconocido.
  /// Nunca usar enum.name como llave de lectura: puede variar con refactors.
  static RelationshipState fromWire(String raw) {
    switch (raw) {
      case 'referenciada':
        return RelationshipState.referenciada;
      case 'detectable':
        return RelationshipState.detectable;
      case 'activadaUnilateral':
        return RelationshipState.activadaUnilateral;
      case 'vinculada':
        return RelationshipState.vinculada;
      case 'suspendida':
        return RelationshipState.suspendida;
      case 'cerrada':
        return RelationshipState.cerrada;
      default:
        throw ArgumentError('RelationshipState desconocido: $raw');
    }
  }

  /// Estado terminal: no permite transiciones salientes.
  bool get isTerminal => this == RelationshipState.cerrada;

  /// Invariante: estos estados exigen que la Relación tenga targetPlatformActorId.
  /// Verificar en el motor antes de transicionar.
  bool get requiresPlatformActor =>
      this == RelationshipState.detectable ||
      this == RelationshipState.vinculada;

  /// Si este estado permite emitir una OperationalRequest por canal inApp bilateral.
  /// Solo 'vinculada' habilita canal bilateral: es el efecto útil del handshake.
  bool get allowsInAppBilateralRequests =>
      this == RelationshipState.vinculada;

  /// Si este estado permite emitir OperationalRequest por canales externos
  /// (whatsappExternal / emailExternal / manual).
  /// Disponible desde referenciada: la Solicitud Estructurada degradable funciona
  /// antes de cualquier handshake. Enviar externamente desde 'referenciada' o
  /// 'detectable' dispara la transición a 'activadaUnilateral' solo cuando el
  /// delivery queda en status=dispatched (regla de activación real).
  bool get allowsExternalRequests =>
      this != RelationshipState.suspendida &&
      this != RelationshipState.cerrada;

  /// Tabla de transiciones permitidas desde este estado.
  /// Data table: el motor (F2.a) decide con base en esta tabla más reglas
  /// adicionales (invariantes de evento, existencia de PlatformActor, etc.).
  Set<RelationshipState> get allowedNext {
    switch (this) {
      case RelationshipState.referenciada:
        return const {
          RelationshipState.detectable,
          RelationshipState.activadaUnilateral,
          // Cierre administrativo local: el workspace puede cerrar una Relación
          // en estado pre-acción sin requerir vínculo bilateral ni platformActor.
          RelationshipState.cerrada,
        };
      case RelationshipState.detectable:
        return const {
          RelationshipState.activadaUnilateral,
          RelationshipState.referenciada,
          // Cierre administrativo local: puede cerrarse aunque haya match
          // confirmado; el contexto del match se preserva para auditoría.
          RelationshipState.cerrada,
        };
      case RelationshipState.activadaUnilateral:
        return const {
          RelationshipState.vinculada,
          RelationshipState.referenciada,
          RelationshipState.cerrada,
        };
      case RelationshipState.vinculada:
        return const {
          RelationshipState.suspendida,
          RelationshipState.cerrada,
        };
      case RelationshipState.suspendida:
        return const {
          RelationshipState.vinculada,
          RelationshipState.cerrada,
        };
      case RelationshipState.cerrada:
        return const {};
    }
  }

  /// Chequeo rápido a nivel de tabla. El motor completo agrega guardas adicionales.
  bool canTransitionTo(RelationshipState target) =>
      allowedNext.contains(target);
}
