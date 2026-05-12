// ============================================================================
// lib/domain/entities/core_common/value_objects/actor_ref_kind_value.dart
// ActorRefKindValue — discriminator del ActorRef cuando viaja como COLUMNA
// ============================================================================
// QUÉ HACE:
//   - Espejo del enum Prisma `ActorRefKind` del backend.
//   - Usado por AssetActorLinkEntity (la tabla persiste el discriminator como
//     columna `actorRefKind`, a diferencia del wire del create DTO donde
//     viaja como `kind` dentro de un objeto ActorRef — ver actor_ref.dart).
//
// QUÉ NO HACE:
//   - No se confunde con `ActorRef` (value object union en wire de DTOs).
//     Aquí el discriminator es un enum plano porque acompaña a columnas
//     hermanas (platformActorId, localKind, localId) en la fila persistida.
//
// See docs/adr/0001-actor-canon.md §3.1 — nomenclatura en persistencia.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Discriminator del ActorRef persistido en columnas.
/// Wire-stable con el enum `ActorRefKind` del backend (Prisma).
enum ActorRefKindValue {
  @JsonValue('platform')
  platform,

  @JsonValue('local')
  local,
}

extension ActorRefKindValueX on ActorRefKindValue {
  String get wireName {
    switch (this) {
      case ActorRefKindValue.platform:
        return 'platform';
      case ActorRefKindValue.local:
        return 'local';
    }
  }

  static ActorRefKindValue fromWire(String raw) {
    switch (raw) {
      case 'platform':
        return ActorRefKindValue.platform;
      case 'local':
        return ActorRefKindValue.local;
      default:
        throw ArgumentError('ActorRefKindValue desconocido: $raw');
    }
  }
}
