// ============================================================================
// lib/data/models/network/network_actor_ref.dart
// NETWORK ACTOR REF — Parser del string `ref` del contrato Core API v1
// ============================================================================
// QUÉ HACE:
//   - Parsea y representa el campo `ref` que viaja como string colon-separated
//     en NetworkActorSummaryDto (red externa) y TeamMemberSummaryDto (equipo).
//   - Tres formatos canónicos definidos por Core API:
//       · "platform:<uuid>"           — actor verificado en plataforma.
//       · "local:<kind>:<id>"         — referencia a libreta local del workspace.
//       · "user:<userId>"             — miembro de equipo interno.
//   - El subkind de "local:" puede ser "organization" o "contact".
//
// QUÉ NO HACE:
//   - No reemplaza `ActorRef` legacy (lib/domain/entities/core_common/actor_ref.dart),
//     que usa formato JSON object con `kind` discriminator. Aquel viaja en otros
//     contratos (OperationalRelationship). Este parser es exclusivo de los DTOs
//     de Mi Red Operativa, donde el wire es string.
//   - No valida existencia server-side; solo forma sintáctica.
//
// INVARIANTES (enforced en parse):
//   - kind ∈ {platform, local, user}.
//   - Si kind=platform: exactamente 2 segmentos (platform:<id>).
//   - Si kind=local:    exactamente 3 segmentos (local:<subkind>:<id>),
//                       subkind ∈ {organization, contact}.
//   - Si kind=user:     exactamente 2 segmentos (user:<id>).
//   - id no vacío.
// ============================================================================

/// Tipo de referencia a actor en el contrato Mi Red Operativa.
enum NetworkActorRefKind {
  platform('platform'),
  local('local'),
  user('user');

  final String wireName;
  const NetworkActorRefKind(this.wireName);

  static NetworkActorRefKind? tryFromWire(String value) {
    for (final k in NetworkActorRefKind.values) {
      if (k.wireName == value) return k;
    }
    return null;
  }
}

/// Subkind aplicable solo cuando `kind=local`. Espejo de TargetLocalKind backend.
enum NetworkLocalRefKind {
  organization('organization'),
  contact('contact');

  final String wireName;
  const NetworkLocalRefKind(this.wireName);

  static NetworkLocalRefKind? tryFromWire(String value) {
    for (final k in NetworkLocalRefKind.values) {
      if (k.wireName == value) return k;
    }
    return null;
  }
}

/// Value object inmutable que representa un `ref` ya parseado.
///
/// Construir vía [NetworkActorRef.parse]. Provee acceso a los componentes y
/// preserva la forma canónica (`raw`) para round-trip exacto.
class NetworkActorRef {
  /// Forma canónica (lo que vino en el wire). Útil para round-trip y logging.
  final String raw;

  /// Tipo de referencia.
  final NetworkActorRefKind kind;

  /// Identificador concreto:
  ///   - kind=platform → uuid del PlatformActor.
  ///   - kind=local    → id local (organization/contact id).
  ///   - kind=user     → userId.
  final String id;

  /// Solo presente cuando `kind=local`.
  final NetworkLocalRefKind? localSubKind;

  const NetworkActorRef._({
    required this.raw,
    required this.kind,
    required this.id,
    this.localSubKind,
  });

  /// Parsea un `ref` string. Lanza [FormatException] si no cumple el contrato.
  factory NetworkActorRef.parse(String raw) {
    if (raw.isEmpty) {
      throw const FormatException('NetworkActorRef vacío');
    }

    final parts = raw.split(':');
    if (parts.length < 2) {
      throw FormatException('NetworkActorRef sin separador `:`: "$raw"');
    }

    final kind = NetworkActorRefKind.tryFromWire(parts[0]);
    if (kind == null) {
      throw FormatException(
        'NetworkActorRef kind desconocido: "${parts[0]}" en "$raw"',
      );
    }

    switch (kind) {
      case NetworkActorRefKind.platform:
      case NetworkActorRefKind.user:
        if (parts.length != 2) {
          throw FormatException(
            'NetworkActorRef "${kind.wireName}" requiere 2 segmentos, '
            'recibido ${parts.length}: "$raw"',
          );
        }
        final id = parts[1];
        if (id.isEmpty) {
          throw FormatException(
            'NetworkActorRef "${kind.wireName}" con id vacío: "$raw"',
          );
        }
        return NetworkActorRef._(raw: raw, kind: kind, id: id);

      case NetworkActorRefKind.local:
        if (parts.length != 3) {
          throw FormatException(
            'NetworkActorRef "local" requiere 3 segmentos '
            '(local:<kind>:<id>), recibido ${parts.length}: "$raw"',
          );
        }
        final subKind = NetworkLocalRefKind.tryFromWire(parts[1]);
        if (subKind == null) {
          throw FormatException(
            'NetworkActorRef local subkind desconocido: "${parts[1]}" en "$raw"',
          );
        }
        final id = parts[2];
        if (id.isEmpty) {
          throw FormatException(
            'NetworkActorRef local con id vacío: "$raw"',
          );
        }
        return NetworkActorRef._(
          raw: raw,
          kind: kind,
          id: id,
          localSubKind: subKind,
        );
    }
  }

  /// Variante segura: retorna null en lugar de lanzar.
  static NetworkActorRef? tryParse(String raw) {
    try {
      return NetworkActorRef.parse(raw);
    } on FormatException {
      return null;
    }
  }

  bool get isPlatform => kind == NetworkActorRefKind.platform;
  bool get isLocal => kind == NetworkActorRefKind.local;
  bool get isUser => kind == NetworkActorRefKind.user;

  @override
  String toString() => raw;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NetworkActorRef && other.raw == raw);

  @override
  int get hashCode => raw.hashCode;
}
