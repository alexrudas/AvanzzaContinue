// ============================================================================
// lib/domain/entities/core_common/value_objects/relationship_suspension_reason.dart
// Razones codificadas de suspensión de una OperationalRelationship (Core Common v1).
// ============================================================================
// Qué hace:
//   - Declara el catálogo de razones por las que una Relación puede quedar
//     en estado 'suspendida'.
//   - Permite auditoría estructurada y reactivación condicionada a la razón.
//
// Qué NO hace:
//   - No ejecuta la suspensión: eso es responsabilidad del motor y casos de uso.
//   - No mapea a i18n (se hace en presentación).
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//   - Toda suspensión debe llevar una razón; no se permite suspender sin motivo.
//   - Ajuste D8: 'platformKeyReassignedCritical' cubre el único caso de
//     suspensión automática por colisión; colisiones no críticas NO suspenden,
//     solo marcan conflicto (ver CollisionKind).
//
// Enterprise Notes:
//   - 'platformActorRemoved' aparece cuando el PlatformActor objetivo desaparece.
//   - 'platformKeyReassignedCritical' se dispara solo cuando el reciclaje de
//     llave afecta el routing o la identidad activa de la Relación.
//   - 'userRequested' y 'systemPolicy' son razones explícitas sin match.
//   - 'unknown' es fallback y debería quedar vacío en operación normal.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Razones por las que una OperationalRelationship puede suspenderse.
enum RelationshipSuspensionReason {
  /// El PlatformActor referenciado fue removido o desactivado.
  @JsonValue('platformActorRemoved')
  platformActorRemoved,

  /// Reciclaje de llave que afecta routing/identidad activa (D8).
  /// Único caso de suspensión automática por colisión en Core Common v1.
  @JsonValue('platformKeyReassignedCritical')
  platformKeyReassignedCritical,

  /// El emisor solicitó suspender la relación explícitamente.
  @JsonValue('userRequested')
  userRequested,

  /// Política de sistema (no identificada como colisión crítica).
  @JsonValue('systemPolicy')
  systemPolicy,

  /// Fallback para casos no clasificados. Evitar en operación normal.
  @JsonValue('unknown')
  unknown,
}

/// Extensión con wire names estables.
extension RelationshipSuspensionReasonX on RelationshipSuspensionReason {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case RelationshipSuspensionReason.platformActorRemoved:
        return 'platformActorRemoved';
      case RelationshipSuspensionReason.platformKeyReassignedCritical:
        return 'platformKeyReassignedCritical';
      case RelationshipSuspensionReason.userRequested:
        return 'userRequested';
      case RelationshipSuspensionReason.systemPolicy:
        return 'systemPolicy';
      case RelationshipSuspensionReason.unknown:
        return 'unknown';
    }
  }

  /// Parse estricto desde wire.
  static RelationshipSuspensionReason fromWire(String raw) {
    switch (raw) {
      case 'platformActorRemoved':
        return RelationshipSuspensionReason.platformActorRemoved;
      case 'platformKeyReassignedCritical':
        return RelationshipSuspensionReason.platformKeyReassignedCritical;
      case 'userRequested':
        return RelationshipSuspensionReason.userRequested;
      case 'systemPolicy':
        return RelationshipSuspensionReason.systemPolicy;
      case 'unknown':
        return RelationshipSuspensionReason.unknown;
      default:
        throw ArgumentError('RelationshipSuspensionReason desconocido: $raw');
    }
  }

  /// Si la suspensión puede revertirse sin intervención manual del usuario.
  /// 'platformActorRemoved' y 'platformKeyReassignedCritical' requieren resolución
  /// explícita: no se auto-reactivan, aunque la evidencia vuelva a aparecer.
  bool get isReversibleWithoutUserAction =>
      this == RelationshipSuspensionReason.systemPolicy ||
      this == RelationshipSuspensionReason.unknown;
}
