// ============================================================================
// lib/domain/policy/feature_evaluator.dart
// FEATURE EVALUATOR — strategy contract (Domain)
//
// QUÉ HACE:
// - Define FeatureEvaluator: contrato de evaluación de una feature individual.
// - Re-exporta access_types.dart: los evaluators pueden importar SOLO este archivo
//   y obtienen FeatureKey/AccessDecision/AccessReasonCodes sin imports extra.
//
// QUÉ NO HACE:
// - No implementa lógica de evaluación.
// - No importa nada de Application ni de Infrastructure.
// - No aplica guards universales (assetContextMissing, restrictedContract).
//
// CONTRATO DE PRE-CONDICIONES (garantizado por ProductAccessPolicy.evaluate):
// - Si feature.requiresAssetContext == true, assetId != null.
// - context.isRestrictedContract == false.
// El evaluator implementa SOLO la lógica específica de la feature.
// ============================================================================

import '../value/product_access_context.dart';
import 'access_types.dart'; // OBLIGATORIO: este archivo usa FeatureKey/AccessDecision

export 'access_types.dart'; // OBLIGATORIO: barrel para consumidores externos

abstract interface class FeatureEvaluator {
  AccessDecision evaluate({
    required FeatureKey feature,
    required ProductAccessContext context,
    String? assetId,
  });
}
