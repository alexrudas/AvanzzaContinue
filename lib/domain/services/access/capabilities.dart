// ============================================================================
// lib/domain/services/access/capabilities.dart
// CAPABILITIES — constantes wire-stable de capability ids canónicos.
//
// QUÉ HACE:
// - Define los ids semánticos de Capability tal como Core API los emite.
// - Provee helpers de lectura sobre [SessionCapabilitiesStore] para evitar
//   magic strings en widgets y controllers.
// - Permite checks idiomáticos: `Capabilities.has(store, Capabilities.providerCreate)`.
//
// QUÉ NO HACE:
// - No muta el store (la escritura es responsabilidad del AccessGateway).
// - No replica enums "rol" legacy. El concepto de "rol UI" se deriva de
//   capabilities + isProvider, NO de strings tipo "proveedor"/"administrador".
// - No persiste a disco. Las capabilities son derivadas en cada login (§9.2
//   del contrato Core API Access).
//
// PRINCIPIOS:
// - Wire-stable: cada constante coincide LITERALMENTE con el id que devuelve
//   `GET /v1/access/me/context.capabilities[]` y `POST /v1/auth/bootstrap.
//   capabilities[]`.
// - Source of truth canónica: ver
//   `avanzza-core-api/src/modules/auth-bootstrap/services/auth-bootstrap.service.ts`
//   (BOOTSTRAP_DEFAULT_CAPABILITIES + HIGH_TRUST_CAPABILITIES).
// - Cualquier capability nueva en backend exige agregar la constante aquí
//   antes de usarla en UI; nunca usar string literal en presentation/.
//
// ENTERPRISE NOTES:
// - El catálogo del backend se versiona vía migraciones. Cualquier edición
//   en este archivo debe acompañarse del código que la consuma — no agregar
//   constantes "por si acaso".
// - Las capabilities `provider.claim` y `provider.agent_invitation.read`
//   están marcadas como high-trust en backend: existen en el catálogo pero
//   NO se otorgan por bootstrap default. Solo aparecen en `capabilities[]`
//   cuando ops asigna un role dedicado.
// ============================================================================

import '../../../application/services/access/session_capabilities_store.dart';

/// Catálogo de capability ids canónicos de Avanzza Core API.
///
/// Cada constante es el `Capability.id` semántico tal como lo emite el
/// backend. NO renombrar sin coordinar migración del backend.
class Capabilities {
  Capabilities._();

  // ── Default (otorgadas por POST /v1/auth/bootstrap → bootstrap_default_role)

  /// Lectura del estado del circuit breaker RUNT (admin / ops observability).
  static const String vehicleBatchCircuitRead = 'vehicle_batch.circuit.read';

  /// Listar y ver purchase requests del workspace activo.
  static const String purchaseRequestRead = 'purchase_request.read';

  /// Crear una nueva purchase request en el workspace activo.
  static const String purchaseRequestCreate = 'purchase_request.create';

  /// Cerrar una purchase request (PR-level) o un item con outcome.
  static const String purchaseRequestClose = 'purchase_request.close';

  /// Adjudicar items a un target (POST /v1/purchase-requests/:id/award).
  static const String purchaseRequestAward = 'purchase_request.award';

  /// Submit Quote sobre una PR del workspace activo.
  static const String purchaseRequestRespond = 'purchase_request.respond';

  /// Reemplazar specialties de un ProviderProfile en el workspace activo.
  static const String providerSpecialtyReplace = 'provider_specialty.replace';

  /// Provisionar (crear o reusar) un ProviderProfile en el workspace activo.
  /// Cubre `POST /v1/providers`, `POST /v1/providers/bootstrap` y
  /// `POST /v1/providers/local`.
  static const String providerCreate = 'provider.create';

  /// Leer un ProviderProfile en el workspace activo, incluyendo specialties.
  /// Necesaria para `GET /v1/providers/me` y `GET /v1/providers/:id`.
  static const String providerRead = 'provider.read';

  /// Leer los AssetTypes canónicos que opera el workspace activo
  /// (derivados de `AssetActorLink` activos).
  static const String workspaceAssetTypeRead = 'workspace_asset_type.read';

  /// Declarar un AssetActorLink en el workspace activo (onboarding).
  static const String assetActorLinkCreate = 'asset_actor_link.create';

  /// Invitar a un User a actuar como agente (advisor/admin) de un
  /// ProviderProfile (`POST /v1/providers/:id/invite-agent`).
  static const String providerInviteAgent = 'provider.invite_agent';

  /// Revocar un ActorProviderLink (`POST /v1/providers/:id/revoke-agent`).
  static const String providerRevokeAgent = 'provider.revoke_agent';

  // ── High-trust (existen en catálogo pero NO se otorgan por default).
  //    Solo aparecen en `capabilities[]` cuando ops asigna un role dedicado.

  /// Reclamar un ProviderProfile UNCLAIMED creado por otro workspace
  /// (`POST /v1/providers/:id/claim`).
  static const String providerClaim = 'provider.claim';

  /// Listar invitaciones emitidas por un ProviderProfile
  /// (`GET /v1/providers/:id/agent-invitations`). Doble gate: capability +
  /// binding ADMIN ACTIVE.
  static const String providerAgentInvitationRead =
      'provider.agent_invitation.read';

  // ── Helpers de lectura sobre SessionCapabilitiesStore ─────────────────────

  /// `true` si `store` contiene la capability `id`. Lectura síncrona.
  static bool has(SessionCapabilitiesStore store, String id) =>
      store.hasCapability(id);

  /// `true` si `store` contiene TODAS las capabilities listadas en `ids`.
  static bool hasAll(SessionCapabilitiesStore store, Iterable<String> ids) {
    for (final id in ids) {
      if (!store.hasCapability(id)) return false;
    }
    return true;
  }

  /// `true` si `store` contiene AL MENOS UNA capability listada en `ids`.
  static bool hasAny(SessionCapabilitiesStore store, Iterable<String> ids) {
    for (final id in ids) {
      if (store.hasCapability(id)) return true;
    }
    return false;
  }
}
