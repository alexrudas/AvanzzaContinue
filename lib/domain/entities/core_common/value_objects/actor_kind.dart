// ============================================================================
// lib/domain/entities/core_common/value_objects/actor_kind.dart
// Discriminador de naturaleza del PlatformActor (Core Common v1).
// ============================================================================
// Qué hace:
//   - Distingue si un PlatformActor representa a una persona o una organización.
//
// Qué NO hace:
//   - No reemplaza OrganizationEntity (workspace tenant): ese es otro concepto.
//   - No modela LocalOrganization / LocalContact: esos viven en la red local.
//   - No lleva atributos específicos de verificación (matrícula, NIT, etc.):
//     esas son extensiones futuras por tipo de actor, no Core Common.
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//   - Un único PlatformActor por identidad verificada: sin duplicación entre kinds.
//
// Enterprise Notes:
//   - Cuando actorKind=person, el PlatformActor puede tener relación 1:1 opcional
//     con User (auth); el User es identidad de autenticación, PlatformActor es
//     identidad operativa en plataforma.
//   - Cuando actorKind=organization, el PlatformActor es autónomo en v1
//     (no existe entidad Organization global en Postgres todavía).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Naturaleza del actor registrado en la plataforma Avanzza.
enum ActorKind {
  /// Entidad jurídica: empresa, taller, CDA, casa comercial, etc.
  @JsonValue('organization')
  organization,

  /// Persona natural: vendedor, técnico, conductor, arrendatario, etc.
  @JsonValue('person')
  person,
}

/// Extensión con wire names estables.
extension ActorKindX on ActorKind {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case ActorKind.organization:
        return 'organization';
      case ActorKind.person:
        return 'person';
    }
  }

  /// Parse estricto desde wire.
  static ActorKind fromWire(String raw) {
    switch (raw) {
      case 'organization':
        return ActorKind.organization;
      case 'person':
        return ActorKind.person;
      default:
        throw ArgumentError('ActorKind desconocido: $raw');
    }
  }
}
