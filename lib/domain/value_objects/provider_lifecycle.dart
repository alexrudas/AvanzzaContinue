// ============================================================================
// lib/domain/value_objects/provider_lifecycle.dart
// PROVIDER LIFECYCLE — Enums wire-stable del backend Core API.
//
// QUÉ HACE:
// - Define enums que reflejan el lifecycle multi-actor del Core API:
//     * ActorProviderLinkStatus  (PENDING/ACTIVE/REJECTED/REVOKED/UNVERIFIED)
//     * ActorProviderLinkRole    (ADVISOR/ADMIN/OTHER)
//     * ProviderProfileClaimStatus (SELF/UNCLAIMED/CLAIMED)
// - Cada enum expone `wireName` (string canónico backend) y `fromWire(s)`
//   que devuelve null cuando el string no corresponde a ningún variant
//   reconocido (defensa frente a wire-versioning futuro — el cliente no
//   crashea si el backend agrega un valor nuevo).
//
// QUÉ NO HACE:
// - NO contiene lógica de negocio: solo tipos.
// - NO valida transiciones de estado: eso vive en backend.
//
// CONVENCIÓN (CLAUDE.md):
// - wireName/fromWire estables. Renombrar el enum DART NUNCA cambia el
//   wireName.
//
// USO:
// - Consumido por mappers de PurchaseRequest, ActorProviderLink (MF2+),
//   ProviderProfile y por el agregado /v1/providers/me (MF1).
// ============================================================================

/// Status del binding User ↔ PlatformActor (ActorProviderLink). Backend
/// es la fuente de verdad; el cliente solo refleja.
enum ActorProviderLinkStatus {
  pending('PENDING'),
  active('ACTIVE'),
  rejected('REJECTED'),
  revoked('REVOKED'),
  unverified('UNVERIFIED');

  final String wireName;
  const ActorProviderLinkStatus(this.wireName);

  static ActorProviderLinkStatus? fromWire(String? s) {
    if (s == null) return null;
    for (final v in ActorProviderLinkStatus.values) {
      if (v.wireName == s) return v;
    }
    return null;
  }
}

/// Rol declarado en el binding (informativo en MF1; gate operativo se
/// resuelve en backend).
enum ActorProviderLinkRole {
  advisor('ADVISOR'),
  admin('ADMIN'),
  other('OTHER');

  final String wireName;
  const ActorProviderLinkRole(this.wireName);

  static ActorProviderLinkRole? fromWire(String? s) {
    if (s == null) return null;
    for (final v in ActorProviderLinkRole.values) {
      if (v.wireName == s) return v;
    }
    return null;
  }
}

/// Estado de propiedad del ProviderProfile (claim lifecycle).
enum ProviderProfileClaimStatus {
  self('SELF'),
  unclaimed('UNCLAIMED'),
  claimed('CLAIMED');

  final String wireName;
  const ProviderProfileClaimStatus(this.wireName);

  static ProviderProfileClaimStatus? fromWire(String? s) {
    if (s == null) return null;
    for (final v in ProviderProfileClaimStatus.values) {
      if (v.wireName == s) return v;
    }
    return null;
  }
}
