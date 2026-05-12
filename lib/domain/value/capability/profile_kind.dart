// ============================================================================
// lib/domain/value/capability/profile_kind.dart
// ProfileKind — discriminator obligatorio de CapabilityProfile
// ============================================================================
// QUÉ HACE:
//   - Define los kinds canónicos de CapabilityProfile (lo que un Workspace
//     ofrece al mercado): provider | advisor | broker | legal | insurer.
//   - Wire-stable: cada valor expone wireName y se parsea desde wire vía
//     fromWire/tryFromWire.
//
// QUÉ NO HACE:
//   - NO modela permisos internos de un miembro: eso es MembershipRole.
//   - NO modela la relación con un activo: eso es AssetActorRole.
//
// REGLA CANÓNICA:
//   CapabilityProfile.kind es el ÚNICO source-of-truth para decidir qué spec
//   debe estar poblada (ProviderSpec | AdvisorSpec | BrokerSpec | LegalSpec |
//   InsurerSpec). Todas las demás specs DEBEN ser null.
//
// FRONTERA broker vs insurer (decidida v3.1, opción B):
//   - broker  = intermediario / corredor (incluye corredor de seguros).
//   - insurer = aseguradora / emisor de póliza (carrier o reasegurador).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

enum ProfileKind {
  /// Proveedor de productos o servicios (oferta operativa al mercado).
  @JsonValue('provider')
  provider,

  /// Asesor especializado (asesoría comercial, consultiva).
  @JsonValue('advisor')
  advisor,

  /// Intermediario / corredor (incluye corredor de seguros, broker
  /// inmobiliario, etc.). NO emite póliza; conecta partes.
  @JsonValue('broker')
  broker,

  /// Servicios legales (abogado / firma).
  @JsonValue('legal')
  legal,

  /// Aseguradora emisora de pólizas (carrier o reasegurador).
  /// Un corredor de seguros NO entra aquí — eso es [broker].
  @JsonValue('insurer')
  insurer,
}

extension ProfileKindX on ProfileKind {
  /// Identificador estable usado en JSON / Firestore / Isar.
  String get wireName {
    switch (this) {
      case ProfileKind.provider:
        return 'provider';
      case ProfileKind.advisor:
        return 'advisor';
      case ProfileKind.broker:
        return 'broker';
      case ProfileKind.legal:
        return 'legal';
      case ProfileKind.insurer:
        return 'insurer';
    }
  }

  /// Parsea wire name a su valor canónico. Throws [ArgumentError] si el
  /// string no está en el catálogo.
  static ProfileKind fromWire(String raw) {
    final parsed = tryFromWire(raw);
    if (parsed == null) {
      throw ArgumentError('ProfileKind desconocido: $raw');
    }
    return parsed;
  }

  /// Versión no-throw de [fromWire].
  static ProfileKind? tryFromWire(String raw) {
    switch (raw) {
      case 'provider':
        return ProfileKind.provider;
      case 'advisor':
        return ProfileKind.advisor;
      case 'broker':
        return ProfileKind.broker;
      case 'legal':
        return ProfileKind.legal;
      case 'insurer':
        return ProfileKind.insurer;
      default:
        return null;
    }
  }

  static bool isValidWireName(String raw) => tryFromWire(raw) != null;

  static List<String> get allWireNames =>
      ProfileKind.values.map((k) => k.wireName).toList(growable: false);
}
