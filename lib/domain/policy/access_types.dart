// ============================================================================
// lib/domain/policy/access_types.dart
// ACCESS DECISION — tipos fundamentales de la policy de acceso
//
// QUÉ HACE:
// - Define FeatureKey (sealed) + sus subclases concretas de Fase 1.
// - Define AccessReasonCodes: fuente única de reason strings.
// - Define AccessDecision: resultado inmutable de una evaluación de acceso.
//
// QUÉ NO HACE:
// - No evalúa nada.
// - No depende de Application ni de Infrastructure.
// - No depende de ProductAccessContext.
//
// NOTA DE MIGRACIÓN:
// Este archivo fue extraído de product_access_policy.dart en Fase 2 para
// romper la dependencia circular entre ProductAccessPolicy y FeatureEvaluator.
// product_access_policy.dart re-exporta este archivo para backward compatibility.
// ============================================================================

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
  /// antes de evaluar reglas de negocio cuando retorna true y assetId == null.
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
/// La Policy y todos los FeatureEvaluators DEBEN referenciar estas constantes;
/// nunca strings literales dispersos.
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

  /// Retornado en strict mode cuando no existe [FeatureEvaluator] registrado
  /// para la feature solicitada. Indica error de configuración (no de negocio).
  static const String evaluatorMissing = 'evaluator_missing';
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
