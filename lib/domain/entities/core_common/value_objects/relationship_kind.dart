// ============================================================================
// lib/domain/entities/core_common/value_objects/relationship_kind.dart
// Tipología semántica de la Relación Operativa (placeholder Core Common v1).
// ============================================================================
// Qué hace:
//   - Declara el placeholder tipado para el tipo de Relación.
//   - En v1 existe un único valor: 'generic'. Extensiones futuras (proveedor,
//     técnico, conductor, etc.) añaden nuevos wireNames manteniendo compatibilidad.
//
// Qué NO hace:
//   - No define módulos verticales (eso queda EXPLÍCITAMENTE fuera de Core Common v1).
//   - No cambia la máquina de estados: el motor es universal; la semántica vive acá.
//   - No afecta visibilidad ni matching.
//
// Principios:
//   - Dominio puro.
//   - Wire name estable: NUNCA renombrar 'generic'; solo agregar valores nuevos.
//   - @JsonValue sincronizado con wireName.
//   - Extensible por adición (open/closed): módulos futuros reciben su wireName.
//
// Enterprise Notes:
//   - Esta enumeración es el único punto donde Core Common "sabe" de tipos
//     verticales en el futuro. No añadir valores aquí sin cerrar antes el
//     payload tipado de su OperationalRequest asociada.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Tipología de una OperationalRelationship. Placeholder v1.
enum RelationshipKind {
  /// Relación genérica sin semántica vertical declarada. Único valor en v1.
  @JsonValue('generic')
  generic,
}

/// Extensión con wire names estables.
extension RelationshipKindX on RelationshipKind {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case RelationshipKind.generic:
        return 'generic';
    }
  }

  /// Parse estricto desde wire.
  /// Si aparece un wire desconocido de una versión futura, el cliente debe
  /// actualizar en lugar de asumir: lanzar es preferible a silenciar.
  static RelationshipKind fromWire(String raw) {
    switch (raw) {
      case 'generic':
        return RelationshipKind.generic;
      default:
        throw ArgumentError(
          'RelationshipKind desconocido (¿versión cliente desactualizada?): $raw',
        );
    }
  }
}
