// ============================================================================
// lib/domain/entities/core_common/value_objects/collision_kind.dart
// Tipos de colisión de identidad detectados por el matcher (Core Common v1).
// ============================================================================
// Qué hace:
//   - Clasifica las colisiones posibles entre registros locales y PlatformActors.
//   - Declara cuáles colisiones son críticas (afectan routing/identidad activa)
//     y por tanto sí suspenden la Relación; el resto solo marca conflicto.
//
// Qué NO hace:
//   - No ejecuta resolución: la regla D8 prohíbe resolución automática destructiva.
//   - No maneja la cola de conflictos: esa es una entidad futura (hook listo).
//   - No dicta UI: en v1 no hay pantalla de resolución; solo queda el hook.
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//   - Ajuste D8: solo colisiones críticas suspenden; colisiones no críticas
//     dejan operar la Relación mientras el conflicto quede marcado.
//   - Resolución explícita por parte del workspace es obligatoria para
//     promover un candidato tras colisión.
//
// Enterprise Notes:
//   - 'duplicateLocalMatch': dos LocalOrganization/LocalContact del mismo
//     workspace matchean al mismo PlatformActor. NO crítica por defecto:
//     no afecta routing activo, pero requiere que el workspace resuelva
//     duplicación local antes de permitir confirmación de match.
//   - 'platformKeyReassigned': un phoneE164 (u otra llave) cambió de dueño
//     en plataforma. Crítica SI la Relación estaba en 'detectable' o
//     'vinculada' con el dueño previo (afecta routing e identidad activa).
//     No crítica si la Relación estaba en 'referenciada' (no hay routing).
//   - 'localToMultiplePlatform': un mismo registro local matchea múltiples
//     PlatformActors con trustLevel=alto. Crítica: no se puede elegir
//     automáticamente; requiere resolución explícita del workspace.
//   - 'lowConfidenceAmbiguous': varios candidatos medio/bajo. No crítica:
//     no se expone ninguno, no afecta Relación.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Tipos de colisión detectados por el matcher al evaluar candidatos.
enum CollisionKind {
  /// Dos registros locales del mismo workspace matchean al mismo PlatformActor.
  @JsonValue('duplicateLocalMatch')
  duplicateLocalMatch,

  /// La llave verificada cambió de PlatformActor en plataforma (reciclaje).
  @JsonValue('platformKeyReassigned')
  platformKeyReassigned,

  /// Un registro local matchea múltiples PlatformActors con trustLevel=alto.
  @JsonValue('localToMultiplePlatform')
  localToMultiplePlatform,

  /// Ambigüedad entre candidatos de trustLevel medio/bajo.
  @JsonValue('lowConfidenceAmbiguous')
  lowConfidenceAmbiguous,
}

/// Extensión con wire names estables y clasificación de criticidad.
extension CollisionKindX on CollisionKind {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case CollisionKind.duplicateLocalMatch:
        return 'duplicateLocalMatch';
      case CollisionKind.platformKeyReassigned:
        return 'platformKeyReassigned';
      case CollisionKind.localToMultiplePlatform:
        return 'localToMultiplePlatform';
      case CollisionKind.lowConfidenceAmbiguous:
        return 'lowConfidenceAmbiguous';
    }
  }

  /// Parse estricto desde wire.
  static CollisionKind fromWire(String raw) {
    switch (raw) {
      case 'duplicateLocalMatch':
        return CollisionKind.duplicateLocalMatch;
      case 'platformKeyReassigned':
        return CollisionKind.platformKeyReassigned;
      case 'localToMultiplePlatform':
        return CollisionKind.localToMultiplePlatform;
      case 'lowConfidenceAmbiguous':
        return CollisionKind.lowConfidenceAmbiguous;
      default:
        throw ArgumentError('CollisionKind desconocido: $raw');
    }
  }

  /// Ajuste D8: si la colisión es crítica por naturaleza (afecta identidad activa).
  /// IMPORTANTE: el motor debe combinar esta propiedad con el estado actual de
  /// la Relación. 'platformKeyReassigned' es crítica solo si la Relación estaba
  /// en 'detectable' o 'vinculada' (routing activo). En 'referenciada' no suspende.
  bool get isInherentlyCritical =>
      this == CollisionKind.localToMultiplePlatform;

  /// Si la colisión puede escalar a crítica según el estado de la Relación.
  /// Se evalúa en el motor/caso de uso al determinar si suspende o solo marca.
  bool get canBecomeCriticalByRelationshipState =>
      this == CollisionKind.platformKeyReassigned;

  /// Si la colisión requiere resolución explícita del workspace antes de
  /// permitir confirmación de match, aunque no suspenda la Relación.
  bool get requiresExplicitResolution =>
      this == CollisionKind.duplicateLocalMatch ||
      this == CollisionKind.localToMultiplePlatform ||
      this == CollisionKind.platformKeyReassigned;
}
