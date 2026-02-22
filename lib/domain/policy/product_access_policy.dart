// ============================================================================
// lib/domain/policy/product_access_policy.dart
// PRODUCT ACCESS POLICY — Fase 1 MVP (Domain / Policy)
//
// QUÉ HACE:
// - Motor determinista de decisiones de acceso a features del producto.
// - Recibe ProductAccessContext + FeatureKey → devuelve AccessDecision.
// - Lógica pura de dominio: sin async, sin repos, sin infra.
//
// QUÉ NO HACE:
// - No persiste, no hace IO, no depende de UI.
// - No duplica el contrato: usa únicamente ProductAccessContext.
//
// ARQUITECTURA (Phase-2-ready):
// - FeatureKey: sealed → exhaustividad garantizada por compilador.
//   En Fase 2, subclases pueden portar data propia (ej: ManageAsset con assetId).
// - _resolveFeature: punto de delegación aislado. En Fase 2 puede reemplazarse por
//   un registry/matrix inyectable (ProductAccessMatrix) sin tocar evaluate().
//   Nota: mientras exista el switch, agregar una nueva FeatureKey requiere modificar
//   ESTE archivo (por exhaustividad), lo cual es intencional en Fase 1.
// - AccessReasonCodes: fuente única de strings; la Policy solo usa constantes.
// - _privilegedRoles: Set const de clase; lookup O(1), sin allocations por llamada.
// ============================================================================

import '../value/product_access_context.dart';

// ── FeatureKey ───────────────────────────────────────────────────────────────

/// Clave de feature. Sealed para exhaustividad en switch + extensibilidad por tipo.
///
/// Cada subclase concreta es una capacidad del producto con semántica propia.
/// La jerarquía sealed garantiza que todo `switch` sobre FeatureKey sea exhaustivo:
/// añadir una subclase obliga al compilador a exigir su caso en todos los switches.
sealed class FeatureKey {
  const FeatureKey();

  /// True si la evaluación requiere un [assetId] concreto.
  ///
  /// [ProductAccessPolicy.evaluate] niega con [AccessReasonCodes.assetContextMissing]
  /// antes de evaluar reglas de negocio cuando este getter retorna true y assetId == null.
  bool get requiresAssetContext => false;
}

final class SyncData extends FeatureKey {
  const SyncData();
}

final class IntelligenceAnalytics extends FeatureKey {
  const IntelligenceAnalytics();
}

final class ManageAsset extends FeatureKey {
  const ManageAsset();

  @override
  bool get requiresAssetContext => true;
}

final class CreateAccountingEntry extends FeatureKey {
  const CreateAccountingEntry();
}

final class ManageOrganization extends FeatureKey {
  const ManageOrganization();
}

final class CollaborateUsers extends FeatureKey {
  const CollaborateUsers();
}

// ── AccessReasonCodes ────────────────────────────────────────────────────────

/// Fuente única de reason codes para decisiones de acceso.
///
/// La Policy DEBE referenciar estas constantes; nunca strings literales dispersos.
abstract final class AccessReasonCodes {
  static const String allowed = 'allowed';
  static const String restrictedContract = 'restricted_contract';
  static const String offlineMode = 'offline_mode';
  static const String contractNoSync = 'contract_no_sync';
  static const String contractNoIntelligence = 'contract_no_intelligence';
  static const String membershipScopeRestricted = 'membership_scope_restricted';
  static const String assetContextMissing = 'asset_context_missing';
  static const String roleInsufficient = 'role_insufficient';
  static const String contractNoCollaboration = 'contract_no_collaboration';
}

// ── AccessDecision ───────────────────────────────────────────────────────────

/// Resultado inmutable de una evaluación de acceso.
///
/// Igualdad estructural basada en [allowed], [feature.runtimeType] y [reasonCode].
/// Permite comparar decisiones en tests y en lógica de throttling/audit.
class AccessDecision {
  final bool allowed;
  final FeatureKey feature;
  final String reasonCode;

  const AccessDecision._({
    required this.allowed,
    required this.feature,
    required this.reasonCode,
  });

  factory AccessDecision.allow(FeatureKey feature) => AccessDecision._(
        allowed: true,
        feature: feature,
        reasonCode: AccessReasonCodes.allowed,
      );

  factory AccessDecision.deny(FeatureKey feature, String reasonCode) =>
      AccessDecision._(
        allowed: false,
        feature: feature,
        reasonCode: reasonCode,
      );

  /// Igualdad basada en [feature.runtimeType] (no en identidad de instancia).
  ///
  /// Fase 1: FeatureKey no porta estado propio, por lo que runtimeType es suficiente
  /// para discriminar features. Si en Fase 2 alguna subclase incorpora payload
  /// (ej: ManageAsset con assetId), esta igualdad deberá revisarse para incluir el
  /// payload en el hash y la comparación.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AccessDecision) return false;
    return allowed == other.allowed &&
        feature.runtimeType == other.feature.runtimeType &&
        reasonCode == other.reasonCode;
  }

  @override
  int get hashCode => Object.hash(allowed, feature.runtimeType, reasonCode);

  @override
  String toString() => 'AccessDecision(allowed=$allowed, '
      'feature=${feature.runtimeType}, '
      'reason=$reasonCode)';
}

// ── ProductAccessPolicy ──────────────────────────────────────────────────────

/// Motor de decisiones de acceso a features del producto.
///
/// Uso:
/// ```dart
/// const policy = ProductAccessPolicy();
/// final decision = policy.evaluate(
///   feature: const SyncData(),
///   context: accessContext,
/// );
/// if (decision.allowed) { ... }
/// ```
class ProductAccessPolicy {
  const ProductAccessPolicy();

  /// Roles con privilegios de gestión.
  ///
  /// Set const: lookup O(1), sin re-allocations.
  static const Set<String> _privilegedRoles = {'owner', 'admin'};

  /// Evalúa si [context] puede acceder a [feature].
  ///
  /// Orden de evaluación garantizado:
  /// 1. Guardia estructural: [FeatureKey.requiresAssetContext] sin [assetId] → deny.
  /// 2. Deny-by-default: contrato restrictivo bloquea toda feature.
  /// 3. Dispatch específico por tipo de feature → [_resolveFeature].
  AccessDecision evaluate({
    required FeatureKey feature,
    required ProductAccessContext context,
    String? assetId,
  }) {
    // 1) Guard estructural: assetId obligatorio para features que lo requieren.
    if (feature.requiresAssetContext && assetId == null) {
      return AccessDecision.deny(
          feature, AccessReasonCodes.assetContextMissing);
    }

    // 2) Deny-by-default: contrato restrictivo bloquea toda feature sin excepción.
    if (context.isRestrictedContract) {
      return AccessDecision.deny(feature, AccessReasonCodes.restrictedContract);
    }

    // 3) Evaluación específica por feature.
    return _resolveFeature(feature, context, assetId);
  }

  // ---------------------------------------------------------------------------
  // DISPATCH — Phase-2-ready
  //
  // Fase 1: el switch garantiza exhaustividad por compilador.
  //   Añadir una subclase de FeatureKey sin su caso aquí es error de compilación.
  //
  // Fase 2 — ProductAccessMatrix:
  //   Este switch puede reemplazarse por un registry/matrix inyectable.
  //   Mientras tanto, este archivo DEBE modificarse si se agregan nuevas FeatureKey.
  // ---------------------------------------------------------------------------
  AccessDecision _resolveFeature(
    FeatureKey feature,
    ProductAccessContext context,
    String? assetId,
  ) {
    return switch (feature) {
      SyncData() => _evalSync(feature, context),
      IntelligenceAnalytics() => _evalIntelligence(feature, context),
      ManageAsset() => _evalManageAsset(feature, context, assetId!),
      CreateAccountingEntry() => _evalCreateAccountingEntry(feature, context),
      ManageOrganization() => _evalManageOrganization(feature, context),
      CollaborateUsers() => _evalCollaboration(feature, context),
    };
  }

  // SyncData:
  // - El contrato restrictivo ya fue denegado globalmente en evaluate().
  // - Aquí solo llegan contextos con contrato no-restrictivo.
  // - Se evalúa offline antes que canSync para retornar la reason más específica.
  AccessDecision _evalSync(FeatureKey feature, ProductAccessContext context) {
    if (!context.isOnline) {
      return AccessDecision.deny(feature, AccessReasonCodes.offlineMode);
    }
    if (!context.canSync) {
      return AccessDecision.deny(feature, AccessReasonCodes.contractNoSync);
    }
    return AccessDecision.allow(feature);
  }

  // IntelligenceAnalytics
  AccessDecision _evalIntelligence(
    FeatureKey feature,
    ProductAccessContext context,
  ) {
    if (!context.hasIntelligence) {
      return AccessDecision.deny(
        feature,
        AccessReasonCodes.contractNoIntelligence,
      );
    }
    return AccessDecision.allow(feature);
  }

  // ManageAsset
  // assetId garantizado non-null: la guardia estructural rechazó el null antes.
  AccessDecision _evalManageAsset(
    FeatureKey feature,
    ProductAccessContext context,
    String assetId,
  ) {
    if (!context.canAccessAsset(assetId)) {
      return AccessDecision.deny(
        feature,
        AccessReasonCodes.membershipScopeRestricted,
      );
    }
    return AccessDecision.allow(feature);
  }

  // CreateAccountingEntry (Fase 1: gate por rol mínimo)
  // Fase 2: la Matrix puede añadir gating por contrato/tier.
  AccessDecision _evalCreateAccountingEntry(
    FeatureKey feature,
    ProductAccessContext context,
  ) {
    if (!context.roles.any(_privilegedRoles.contains)) {
      return AccessDecision.deny(feature, AccessReasonCodes.roleInsufficient);
    }
    return AccessDecision.allow(feature);
  }

  // ManageOrganization (gate por rol mínimo)
  // roles ya normalizados a lowercase por ProductAccessContextFactory.
  AccessDecision _evalManageOrganization(
    FeatureKey feature,
    ProductAccessContext context,
  ) {
    if (!context.roles.any(_privilegedRoles.contains)) {
      return AccessDecision.deny(feature, AccessReasonCodes.roleInsufficient);
    }
    return AccessDecision.allow(feature);
  }

  // CollaborateUsers
  AccessDecision _evalCollaboration(
    FeatureKey feature,
    ProductAccessContext context,
  ) {
    if (!context.supportsCollaboration) {
      return AccessDecision.deny(
        feature,
        AccessReasonCodes.contractNoCollaboration,
      );
    }
    return AccessDecision.allow(feature);
  }
}
