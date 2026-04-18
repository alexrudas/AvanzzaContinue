// ============================================================================
// lib/domain/entities/core_common/value_objects/target_local_kind.dart
// Discriminador del target local de una OperationalRelationship (Core Common v1).
// ============================================================================
// Qué hace:
//   - Indica si el target local de una Relación es una LocalOrganization
//     o un LocalContact.
//
// Qué NO hace:
//   - No modela las entidades locales en sí: solo discrimina cuál referenciar.
//   - No mezcla con ActorKind (plataforma) ni con RelationshipKind.
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//   - Patrón polimórfico por discriminador: targetLocalKind + targetLocalId.
//
// Enterprise Notes:
//   - LocalContact puede pertenecer 1:N a LocalOrganization, pero la Relación
//     apunta a uno u otro; si se quiere vincular ambos por separado se crean
//     dos Relaciones distintas (regla explícita del contrato).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Tipo del target local al que apunta una OperationalRelationship.
enum TargetLocalKind {
  /// La Relación apunta a una LocalOrganization.
  @JsonValue('organization')
  organization,

  /// La Relación apunta a un LocalContact (puede o no pertenecer a una LocalOrganization).
  @JsonValue('contact')
  contact,
}

/// Extensión con wire names estables.
extension TargetLocalKindX on TargetLocalKind {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case TargetLocalKind.organization:
        return 'organization';
      case TargetLocalKind.contact:
        return 'contact';
    }
  }

  /// Parse estricto desde wire.
  static TargetLocalKind fromWire(String raw) {
    switch (raw) {
      case 'organization':
        return TargetLocalKind.organization;
      case 'contact':
        return TargetLocalKind.contact;
      default:
        throw ArgumentError('TargetLocalKind desconocido: $raw');
    }
  }
}
