// ============================================================================
// lib/domain/value/product_access_context.dart
// PRODUCT ACCESS CONTEXT — Enterprise Ultra Pro (Domain / Runtime Snapshot)
//
// QUÉ ES:
// - Snapshot canónico de acceso en runtime para una sesión autenticada.
// - Agrega señales de: identidad, organización, roles, scope de assets,
//   contrato de organización y conectividad.
//
// QUÉ NO ES:
// - No se persiste (NO JSON, NO .g.dart).
// - No ejecuta enforcement complejo (eso vive en policies / app layer).
// - No contiene clocks/timestamps (evita churn de equality en Rx).
//
// REGLAS DURAS:
// - Construir exclusivamente vía ProductAccessContextFactory.build()
// - En estado deslogueado: NO se instancia. El controller debe usar null.
// - roles debe ser Set.unmodifiable(...) garantizado por la factory.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'membership_scope.dart';
import 'organization_contract/organization_access_contract.dart';

part 'product_access_context.freezed.dart';

@freezed
abstract class ProductAccessContext with _$ProductAccessContext {
  const ProductAccessContext._();

  const factory ProductAccessContext({
    required String userId,
    required String orgId,

    /// Roles activos del usuario en la organización.
    ///
    /// Contrato: esta colección DEBE llegar como Set.unmodifiable(...)
    /// desde ProductAccessContextFactory.
    required Set<String> roles,

    /// Alcance de acceso a activos.
    /// Nunca null; fallback seguro (en factory): MembershipScope().
    required MembershipScope membershipScope,

    /// Contrato de acceso de la organización.
    /// Nunca null; fallback seguro (en factory): OrganizationAccessContract.defaultRestricted().
    required OrganizationAccessContract organizationContract,

    /// Estado de conectividad en el momento de construcción del snapshot.
    required bool isOnline,
  }) = _ProductAccessContext;

  // ── Convenience queries (NO enforcement complejo) ─────────────────────────

  /// True si el contrato permite sincronización cloud Y el dispositivo está online.
  bool get canSync => organizationContract.canSync && isOnline;

  /// True si el contrato habilita inteligencia/IA.
  bool get hasIntelligence => organizationContract.hasIntelligence;

  /// True si el scope concede acceso al asset con el id indicado.
  bool canAccessAsset(String assetId) =>
      membershipScope.canAccessAsset(assetId);

  /// True si el contrato soporta colaboración estructural.
  bool get supportsCollaboration => organizationContract.supportsCollaboration;

  /// True si el contrato es el default más restrictivo (deny-by-default).
  bool get isRestrictedContract => organizationContract.isDefaultRestricted;

  /// Solo para diagnóstico. No usar para decisiones de UI/persistencia.
  String toDebugString() {
    return 'ProductAccessContext('
        'userId=$userId, '
        'orgId=$orgId, '
        'roles=${roles.length}, '
        'online=$isOnline, '
        'canSync=$canSync, '
        'hasIntelligence=$hasIntelligence, '
        'restrictedContract=$isRestrictedContract'
        ')';
  }
}
