// ============================================================================
// lib/domain/entities/core_common/value_objects/match_candidate_state.dart
// Estados de un MatchCandidate (Core Common v1).
// ============================================================================
// Qué hace:
//   - Declara los estados por los que pasa una coincidencia detectada por
//     el matcher, desde detección interna hasta confirmación en Relación.
//
// Qué NO hace:
//   - No ejecuta el matcher ni decide trustLevel (F4).
//   - No expone identidades: el cambio a 'exposedToWorkspace' solo gatilla
//     visibilidad al workspace dueño del registro local, jamás a la contraparte.
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//   - Detección interna ≠ exposición: es posible que existan candidatos
//     'detectedInternal' que nunca lleguen a exponerse (trustLevel insuficiente,
//     conflicto no resuelto, colisión activa).
//
// Enterprise Notes:
//   - 'exposedToWorkspace' es el único estado que el cliente Flutter observa.
//   - 'confirmedIntoRelationship' significa que el workspace promovió el match
//     a una OperationalRelationship (la Relación mantiene la vinculación).
//   - 'dismissedByWorkspace' sirve para que el matcher no re-proponga el mismo
//     candidato hasta que cambie la evidencia (nueva llave verificada).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Estados por los que pasa un MatchCandidate.
enum MatchCandidateState {
  /// Detectado internamente por el matcher. No visible al workspace.
  /// Solo se eleva a 'exposedToWorkspace' si trustLevel=alto y no hay colisión crítica.
  @JsonValue('detectedInternal')
  detectedInternal,

  /// Visible al workspace dueño del registro local. Aún no confirmado ni descartado.
  @JsonValue('exposedToWorkspace')
  exposedToWorkspace,

  /// El workspace descartó explícitamente el candidato. El matcher no re-propone
  /// hasta que cambie la evidencia subyacente (nueva VerifiedKey, etc.).
  @JsonValue('dismissedByWorkspace')
  dismissedByWorkspace,

  /// El workspace confirmó el match y se promovió a OperationalRelationship
  /// (o la Relación existente quedó ligada a este PlatformActor).
  @JsonValue('confirmedIntoRelationship')
  confirmedIntoRelationship,
}

/// Extensión con wire names estables.
extension MatchCandidateStateX on MatchCandidateState {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case MatchCandidateState.detectedInternal:
        return 'detectedInternal';
      case MatchCandidateState.exposedToWorkspace:
        return 'exposedToWorkspace';
      case MatchCandidateState.dismissedByWorkspace:
        return 'dismissedByWorkspace';
      case MatchCandidateState.confirmedIntoRelationship:
        return 'confirmedIntoRelationship';
    }
  }

  /// Parse estricto desde wire.
  static MatchCandidateState fromWire(String raw) {
    switch (raw) {
      case 'detectedInternal':
        return MatchCandidateState.detectedInternal;
      case 'exposedToWorkspace':
        return MatchCandidateState.exposedToWorkspace;
      case 'dismissedByWorkspace':
        return MatchCandidateState.dismissedByWorkspace;
      case 'confirmedIntoRelationship':
        return MatchCandidateState.confirmedIntoRelationship;
      default:
        throw ArgumentError('MatchCandidateState desconocido: $raw');
    }
  }

  /// Si el candidato es visible al workspace (única puerta de exposición).
  bool get isVisibleToWorkspace =>
      this == MatchCandidateState.exposedToWorkspace ||
      this == MatchCandidateState.confirmedIntoRelationship;

  /// Si el candidato está cerrado (no vuelve a cambiar salvo nueva evidencia).
  bool get isResolved =>
      this == MatchCandidateState.dismissedByWorkspace ||
      this == MatchCandidateState.confirmedIntoRelationship;
}
