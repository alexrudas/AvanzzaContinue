// ============================================================================
// lib/domain/policy/product_access_policy.dart
// PRODUCT ACCESS POLICY — Fase 1 + modo transición Fase 2
//
// QUÉ HACE:
// - Motor determinista de decisiones de acceso a features del producto.
// - Fase 1: switch exhaustivo sobre FeatureKey (comportamiento original intacto).
// - Fase 2 (transición): registry opcional de FeatureEvaluator por tipo de feature.
//   Features sin evaluator registrado caen al switch de Fase 1 (strictEvaluators=false)
//   o retornan deny(evaluatorMissing) (strictEvaluators=true).
// - Re-exporta access_types.dart y feature_evaluator.dart: todo código que ya
//   importaba este archivo sigue compilando sin cambios.
//
// QUÉ NO HACE:
// - No persiste, no hace IO, no depende de UI.
// - No importa nada de Application ni de Infrastructure.
//
// ORDEN DE EVALUACIÓN (invariante entre todos los modos):
// (i)   Resolver evaluator del registry (lookup por feature.runtimeType).
// (ii)  Guard estructural: requiresAssetContext && assetId == null → deny(assetContextMissing).
// (iii) Deny-by-default: isRestrictedContract → deny(restrictedContract).
// (iv)  Si evaluator != null → delegar a evaluator.evaluate(...).
// (v)   Si evaluator == null:
//         - evaluators != null && strictEvaluators == true → deny(evaluatorMissing).
//         - else (Fase 1 o transición) → switch exhaustivo (_resolveFeature).
// ============================================================================

export 'access_types.dart';
export 'feature_evaluator.dart';

import '../value/product_access_context.dart';
import 'feature_evaluator.dart';

// ── ProductAccessPolicy ──────────────────────────────────────────────────────

/// Motor de decisiones de acceso a features del producto.
///
/// **Fase 1 — sin evaluators (comportamiento original):**
/// ```dart
/// const policy = ProductAccessPolicy();
/// ```
///
/// **Fase 2 — transición parcial (strictEvaluators=false, default):**
/// ```dart
/// final policy = ProductAccessPolicy(
///   evaluators: {SyncData: SyncDataEvaluator()},
/// );
/// // SyncData → usa evaluator; resto → switch Fase 1.
/// ```
///
/// **Fase 2 — strict (migración completa):**
/// ```dart
/// const policy = ProductAccessPolicy(
///   evaluators: { /* todos los evaluators */ },
///   strictEvaluators: true,
/// );
/// // Feature sin evaluator → deny(evaluatorMissing).
/// ```
class ProductAccessPolicy {
  /// Registry de evaluators por tipo de feature.
  ///
  /// - `null` (default) → Fase 1 pura; switch exhaustivo para todas las features.
  /// - No-null → Fase 2; las features con entrada usan su evaluator,
  ///   las demás dependen de [strictEvaluators].
  final Map<Type, FeatureEvaluator>? evaluators;

  /// Controla el comportamiento cuando una feature no tiene evaluator registrado
  /// y [evaluators] no es null.
  ///
  /// - `false` (default) → fallback al switch de Fase 1. Seguro para transición.
  /// - `true` → deny(evaluatorMissing). Usar solo cuando todos los evaluators
  ///   estén registrados y se quiera fail-closed ante features no registradas.
  final bool strictEvaluators;

  const ProductAccessPolicy({
    this.evaluators,
    this.strictEvaluators = false,
  });

  /// Roles con privilegios de gestión — fallback Fase 1.
  static const Set<String> _privilegedRoles = {'owner', 'admin'};

  /// Evalúa si [context] puede acceder a [feature].
  ///
  /// Ver orden de evaluación en la cabecera del archivo.
  AccessDecision evaluate({
    required FeatureKey feature,
    required ProductAccessContext context,
    String? assetId,
  }) {
    // (i) Resolver evaluator — lazy, no ejecuta aún.
    final evaluator = evaluators?[feature.runtimeType];

    // (ii) Guard estructural — universal, antes de cualquier lógica de negocio.
    if (feature.requiresAssetContext && assetId == null) {
      return AccessDecision.deny(
          feature, AccessReasonCodes.assetContextMissing);
    }

    // (iii) Deny-by-default — universal.
    if (context.isRestrictedContract) {
      return AccessDecision.deny(feature, AccessReasonCodes.restrictedContract);
    }

    // (iv) Delegar al evaluator registrado.
    if (evaluator != null) {
      return evaluator.evaluate(
          feature: feature, context: context, assetId: assetId);
    }

    // (v) No hay evaluator para esta feature.
    if (evaluators != null && strictEvaluators) {
      // Strict mode: feature no registrada es error de configuración.
      return AccessDecision.deny(feature, AccessReasonCodes.evaluatorMissing);
    }

    // Fallback Fase 1 — cubre: evaluators==null, transición parcial (strict=false).
    return _resolveFeature(feature, context, assetId);
  }

  // ---------------------------------------------------------------------------
  // FALLBACK FASE 1 — switch exhaustivo
  //
  // El switch garantiza exhaustividad por compilador.
  // Añadir una subclase de FeatureKey sin su caso aquí es error de compilación.
  //
  // En Fase 2 completa (todos los evaluators + strictEvaluators=true),
  // este método queda inalcanzable y podrá eliminarse.
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
          feature, AccessReasonCodes.contractNoIntelligence);
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
          feature, AccessReasonCodes.membershipScopeRestricted);
    }
    return AccessDecision.allow(feature);
  }

  // CreateAccountingEntry — gate por rol mínimo (Fase 1).
  AccessDecision _evalCreateAccountingEntry(
    FeatureKey feature,
    ProductAccessContext context,
  ) {
    if (!context.roles.any(_privilegedRoles.contains)) {
      return AccessDecision.deny(feature, AccessReasonCodes.roleInsufficient);
    }
    return AccessDecision.allow(feature);
  }

  // ManageOrganization — gate por rol mínimo.
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
          feature, AccessReasonCodes.contractNoCollaboration);
    }
    return AccessDecision.allow(feature);
  }
}
