// ============================================================================
// lib/domain/services/access/owner_default_capabilities.dart
// OwnerDefaultCapabilities — espejo local de BOOTSTRAP_DEFAULT_CAPABILITIES.
// ============================================================================
// QUÉ HACE:
//   Define el set de capabilities que el backend otorga por default al rol
//   bootstrap (OWNER recién creado vía POST /v1/auth/bootstrap). Se usa
//   EXCLUSIVAMENTE para hidratar `AccessContextSnapshotModel.capabilities`
//   con `source=localBootstrap` cuando el usuario crea su workspace en esta
//   app antes de que Core API confirme.
//
// QUÉ NO HACE:
//   - NO reemplaza al servidor: el primer `SERVER_REFRESH` exitoso sobrescribe
//     completamente este set con el `capabilities[]` canónico del backend.
//   - NO incluye HIGH_TRUST capabilities (provider.claim,
//     provider.agent_invitation.read). Esas SOLO se otorgan vía role
//     dedicado por ops y NUNCA se infieren localmente.
//
// PRINCIPIOS:
//   - Wire-stable: cada string coincide con `Capabilities.*`.
//   - Drift defense: si backend cambia su default, el primer refresh corrige.
//   - Source of truth backend: `auth-bootstrap.service.ts ::
//     BOOTSTRAP_DEFAULT_CAPABILITIES` en `avanzza-core-api`.
// ============================================================================

import 'capabilities.dart';

class OwnerDefaultCapabilities {
  OwnerDefaultCapabilities._();

  /// Set inmutable de capability ids que un OWNER recibe por bootstrap
  /// default. Espejo local de `BOOTSTRAP_DEFAULT_CAPABILITIES` del backend.
  ///
  /// Mantener en sincronía con `auth-bootstrap.service.ts` cada vez que el
  /// backend modifique el set. La divergencia local→backend se autocorrige
  /// en el primer SERVER_REFRESH, pero hasta entonces la UI puede mostrar
  /// acciones que el backend rechazará — preferimos sub-set conservador
  /// frente a super-set optimista.
  static const List<String> set = <String>[
    Capabilities.vehicleBatchCircuitRead,
    Capabilities.purchaseRequestRead,
    Capabilities.purchaseRequestCreate,
    Capabilities.purchaseRequestClose,
    Capabilities.purchaseRequestAward,
    Capabilities.purchaseRequestRespond,
    Capabilities.providerSpecialtyReplace,
    Capabilities.providerCreate,
    Capabilities.providerRead,
    Capabilities.workspaceAssetTypeRead,
    Capabilities.assetActorLinkCreate,
    Capabilities.providerInviteAgent,
    Capabilities.providerRevokeAgent,
  ];
}
