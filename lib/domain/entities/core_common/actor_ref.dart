// ============================================================================
// lib/domain/entities/core_common/actor_ref.dart
// ActorRef — contrato transversal de referencia a actores (ADR actor-canon)
// ============================================================================
// QUÉ HACE:
//   - Define el value object ActorRef como union discriminada por `kind`:
//       * ActorRef.platform(platformActorId)
//       * ActorRef.local(localKind, localId)
//   - Espejo exacto del ActorRefDto del backend (avanzza-core-api).
//     Wire JSON: { "kind": "platform"|"local", ... }.
//
// QUÉ NO HACE:
//   - No persiste ni consulta. Es solo estructura inmutable.
//   - No valida existencia server-side (eso lo hace el backend por attestation).
//   - No mezcla con libreta local: LocalContact/LocalOrganization se traducen
//     a ActorRef.local en el caller — ese es el único contrato que viaja en wire.
//
// PRINCIPIOS:
//   - Freezed sealed union: pattern matching en Dart 3 garantiza exhaustividad.
//   - Wire-stable: los valores de `kind` coinciden exactamente con ActorRefKind
//     del backend ('platform' | 'local').
//   - NO reciclar strings opacos tipo vendorContactId en código nuevo.
//
// See docs/adr/0001-actor-canon.md (regla 2.5 — contrato ActorRef único).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'actor_ref.freezed.dart';
part 'actor_ref.g.dart';

/// Tipo de registro local al que apunta `ActorRef.local`. Alinea 1:1 con
/// `TargetLocalKind` del backend (Core Common v1).
enum LocalKind {
  contact('contact'),
  organization('organization');

  final String wireName;
  const LocalKind(this.wireName);

  static LocalKind fromWire(String raw) {
    for (final v in LocalKind.values) {
      if (v.wireName == raw) return v;
    }
    throw ArgumentError('LocalKind desconocido: $raw');
  }
}

/// Referencia transversal a un actor del workspace.
///
/// Dos variantes, exactamente una aplicable:
///   - `ActorRef.platform(platformActorId)` — actor verificado en plataforma.
///   - `ActorRef.local(localKind, localId)` — referencia a la libreta del
///     workspace (LocalContact / LocalOrganization) que aún no tiene match
///     confirmado server-side, o que no se consulta vía match.
@Freezed(unionKey: 'kind', unionValueCase: FreezedUnionCase.none)
abstract class ActorRef with _$ActorRef {
  /// Variante platform: apunta a un PlatformActor existente.
  /// El backend valida existencia al insertar (FK).
  @FreezedUnionValue('platform')
  const factory ActorRef.platform({
    required String platformActorId,
  }) = ActorRefPlatform;

  /// Variante local: apunta a un registro de la libreta del workspace.
  /// El backend requiere attestation previa (probe o attestSelf).
  @FreezedUnionValue('local')
  const factory ActorRef.local({
    required LocalKind localKind,
    required String localId,
  }) = ActorRefLocal;

  factory ActorRef.fromJson(Map<String, dynamic> json) =>
      _$ActorRefFromJson(json);
}

/// Helper semántico: construye `ActorRef.local` desde un contacto de la libreta.
ActorRef actorRefFromLocalContactId(String localContactId) =>
    ActorRef.local(localKind: LocalKind.contact, localId: localContactId);

/// Helper semántico: construye `ActorRef.local` desde una organización local.
ActorRef actorRefFromLocalOrganizationId(String localOrgId) =>
    ActorRef.local(localKind: LocalKind.organization, localId: localOrgId);
