// ============================================================================
// lib/presentation/demo_registration_v2/fusionado/onboarding_asset_handoff_mapper.dart
// mapBootstrapToAssetRegistrationContext — función pura
// ============================================================================
// QUÉ HACE:
//   - Convierte (WorkspaceBootstrapResult + DemoRegistrationState) en un
//     [AssetRegistrationContext] tipado, listo para usarse como argumento de
//     navegación a [Routes.assetRegister].
//   - Genera `registrationSessionId` (UUID v4) en cada llamada — invariante
//     crítica del subsistema RUNT (NUNCA debe ser igual a `portfolioId`).
//   - Propaga `vrcSnapshot` (copia inmutable de `state.assetData`) y
//     `expectedRelationKind` (desde `Portfolio.expectedRelationKind`).
//
// QUÉ NO HACE:
//   - NO emite mapas sueltos (`Map<String,dynamic>` está prohibido por ADR).
//   - NO toca GetX, Firestore, Isar ni navegación. Es función pura.
//   - NO crea AssetActorLink — eso lo hace VRC al añadir el primer asset
//     usando `expectedRelationKind` como hint.
//
// PRINCIPIOS:
//   - Pure function: mismo input ⇒ mismo output (excepto `registrationSessionId`,
//     que por contrato es UUID fresco por llamada).
//   - Retorna `null` cuando `result.portfolio == null` — el caller decide
//     que NO hay handoff a asset register (probablemente va a home).
//   - `vrcSnapshot` se materializa como COPIA defensiva (`Map.from`); el
//     caller puede mutarla sin afectar el state original.
//   - `vrcSnapshot` queda `null` cuando `state.assetData.isEmpty`. Vacío
//     mapeado a null preserva la semántica "nada capturado".
// ============================================================================

import 'package:uuid/uuid.dart';

import '../../../domain/usecases/onboarding/workspace_bootstrap_result.dart';
import '../../../domain/value/registration/asset_registration_context.dart';
import '../../../domain/shared/enums/asset_type.dart';
import '../demo_state.dart';

const Uuid _uuid = Uuid();

/// Construye el contexto de registro de activo a partir del resultado del
/// bootstrap del onboarding.
///
/// Retorna `null` si el bootstrap NO creó portfolio (caso provider/advisor/
/// broker/legal/insurer): no hay handoff a asset register, el caller debe
/// navegar a [Routes.home].
///
/// Cuando hay portfolio, el contexto retornado incluye:
/// - `portfolioId`, `portfolioName`, `countryId`, `cityId` ← [PortfolioEntity].
/// - `assetType` ← [DemoRegistrationState.assetType] convertido a
///   [AssetRegistrationType]. Si el state no tiene assetType (caso degenerado),
///   se usa `AssetRegistrationType.otro` para mantener el contrato no-null.
/// - `registrationSessionId` ← UUID v4 fresco (jamás `portfolioId`).
/// - `vrcSnapshot` ← copia de `state.assetData` o null si vacío.
/// - `expectedRelationKind` ← `portfolio.expectedRelationKind`.
AssetRegistrationContext? mapBootstrapToAssetRegistrationContext({
  required WorkspaceBootstrapResult result,
  required DemoRegistrationState state,
}) {
  final portfolio = result.portfolio;
  if (portfolio == null) return null;

  final assetData = state.assetData;
  final snapshot = assetData.isEmpty
      ? null
      : Map<String, String>.from(assetData);

  return AssetRegistrationContext(
    portfolioId: portfolio.id,
    portfolioName: portfolio.portfolioName,
    countryId: portfolio.countryId,
    cityId: portfolio.cityId,
    assetType: _mapAssetType(state.assetType),
    registrationSessionId: _uuid.v4(),
    vrcSnapshot: snapshot,
    expectedRelationKind: portfolio.expectedRelationKind,
  );
}

/// Mapea el enum demo (`DemoAssetType`) al enum canónico del wizard
/// (`AssetRegistrationType`). Ambos comparten nombres por construcción.
///
/// Si `demo` es null, se asume `otro` para preservar el contrato no-null
/// del campo `AssetRegistrationContext.assetType`. Este caso es defensivo
/// — ocurre solo si el bootstrap creó portfolio sin que el state declarara
/// assetType (escenario raro, no esperado en flujos normales).
AssetRegistrationType _mapAssetType(DemoAssetType? demo) {
  switch (demo) {
    case DemoAssetType.vehiculo:
      return AssetRegistrationType.vehiculo;
    case DemoAssetType.inmueble:
      return AssetRegistrationType.inmueble;
    case DemoAssetType.maquinaria:
      return AssetRegistrationType.maquinaria;
    case DemoAssetType.equipo:
      return AssetRegistrationType.equipo;
    case DemoAssetType.otro:
    case null:
      return AssetRegistrationType.otro;
  }
}
