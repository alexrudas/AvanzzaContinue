// ============================================================================
// lib/presentation/demo_registration_v2/fusionado/onboarding_navigation_resolver.dart
// resolveOnboardingNavigation — función pura que decide a qué ruta navegar
// tras CompleteOnboardingUC.execute().
// ============================================================================
// QUÉ HACE:
//   - Dado un [WorkspaceBootstrapResult] + el [DemoRegistrationState] que
//     produjo ese resultado, retorna el `routeName` + `arguments` para
//     `Get.offAllNamed(...)`.
//
// POLÍTICA (orden de precedencia, INVARIANTE):
//   *Readiness > role*: el role declarado en el state NO es suficiente
//   para enrutar a un workspace concreto si las señales canónicas de
//   "configuración mínima" del rol no están presentes. Sin readiness, la
//   ruta segura es `Routes.home` — el shell del home muestra empty-state
//   y CTAs para completar la configuración pendiente.
//
//   1. **`state.role == DemoRoleCode.provider`**:
//        · CON `state.providerOfferType` declarado:
//            - `productos` → `Routes.providerWorkspaceArticles`
//            - `servicios` → `Routes.providerWorkspaceServices`
//          NUNCA `Routes.assetRegister` (regression guard: aunque
//          `result.portfolio` venga poblado por accidente, el resolver
//          NO rebota al wizard de registro de activo).
//        · SIN `providerOfferType` → `Routes.home` (readiness gap:
//          falta declarar el offer type del proveedor; el shell del
//          home muestra el CTA correspondiente).
//   2. Otros roles + `result.portfolio != null` → `Routes.assetRegister`
//      con un [AssetRegistrationContext] tipado.
//   3. Otros roles + sin portfolio → `Routes.home`.
//
// QUÉ NO HACE:
//   - NO navega. Es función pura — el caller (controller del flow) toma
//     el resultado y ejecuta `Get.offAllNamed`.
//   - NO emite `Map<String, dynamic>` sueltos. El payload de assetRegister
//     viaja como [AssetRegistrationContext] tipado (ADR §2 — no free maps
//     en handoffs entre capas).
//   - NO accede a Get / repos / Firestore.
//   - NO llama `mapBootstrapToAssetRegistrationContext` cuando el role es
//     proveedor (corta-circuito explícito).
//
// PRINCIPIOS:
//   - Testeable sin levantar GetX ni UI.
//   - Mismo input ⇒ misma ruta. El `registrationSessionId` dentro del
//     contexto (cuando aplica) es UUID fresco por contrato.
// ============================================================================

import '../../../domain/usecases/onboarding/workspace_bootstrap_result.dart';
import '../../../domain/value/registration/asset_registration_context.dart';
import '../../../routes/app_routes.dart';
import '../demo_state.dart';
import 'onboarding_asset_handoff_mapper.dart';

/// Decisión de navegación post-bootstrap.
class OnboardingNavigationDecision {
  /// Nombre de ruta canónico (de [Routes]).
  final String routeName;

  /// Argumento tipado para `Get.offAllNamed`.
  ///
  /// - `null` cuando la ruta no requiere args (ej: [Routes.home]).
  /// - [AssetRegistrationContext] cuando la ruta es [Routes.assetRegister].
  ///
  /// El tipo es `Object?` (no `Map<String,dynamic>`) porque GetX acepta
  /// argumentos arbitrarios y el receptor (`AssetRegistrationController`)
  /// hace `is AssetRegistrationContext` para validar.
  final Object? arguments;

  const OnboardingNavigationDecision({
    required this.routeName,
    this.arguments,
  });

  /// True si la decisión apunta al flujo de registro de activos (portfolio
  /// creado en DRAFT y se debe registrar el primer asset).
  bool get goesToAssetRegistration => routeName == Routes.assetRegister;

  /// Acceso tipado al contexto de registro de activo. Null cuando la
  /// decisión no apunta a [Routes.assetRegister].
  AssetRegistrationContext? get assetRegistrationContext {
    final args = arguments;
    return args is AssetRegistrationContext ? args : null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnboardingNavigationDecision &&
          other.routeName == routeName &&
          _argsEqual(other.arguments, arguments));

  @override
  int get hashCode => Object.hash(routeName, arguments);

  @override
  String toString() => 'OnboardingNavigationDecision('
      'route: $routeName, '
      'args: ${arguments?.runtimeType ?? 'none'})';
}

/// Resuelve la siguiente ruta tras `CompleteOnboardingUC.execute()`.
///
/// Pure function: no I/O, no efectos.
OnboardingNavigationDecision resolveOnboardingNavigation({
  required WorkspaceBootstrapResult result,
  required DemoRegistrationState state,
}) {
  // ── Regla 1 (readiness > role): provider necesita `providerOfferType`
  //    declarado para enrutar a un workspace concreto. Sin él, falta la
  //    señal mínima para elegir Articles vs Services y rebotamos a
  //    `Routes.home` — el shell del home muestra empty-state con CTA
  //    para completar el onboarding pendiente. NUNCA `Routes.assetRegister`
  //    aunque `result.portfolio` venga poblado por accidente (regression
  //    guard del flujo zombie del wizard legacy).
  if (state.role == DemoRoleCode.provider) {
    final offerType = state.providerOfferType;
    if (offerType == null) {
      return const OnboardingNavigationDecision(routeName: Routes.home);
    }
    final providerRoute = offerType == DemoProviderOfferType.productos
        ? Routes.providerWorkspaceArticles
        : Routes.providerWorkspaceServices;
    return OnboardingNavigationDecision(routeName: providerRoute);
  }

  // ── Regla 2 + 3: roles no-provider — comportamiento previo intacto.
  final ctx = mapBootstrapToAssetRegistrationContext(
    result: result,
    state: state,
  );
  if (ctx == null) {
    return const OnboardingNavigationDecision(routeName: Routes.home);
  }
  return OnboardingNavigationDecision(
    routeName: Routes.assetRegister,
    arguments: ctx,
  );
}

/// Compara dos argumentos de navegación. Para [AssetRegistrationContext]
/// la igualdad considera todos los campos EXCEPTO `registrationSessionId`,
/// porque ese campo es UUID fresco por contrato y no debería romper la
/// semántica de "misma decisión".
bool _argsEqual(Object? a, Object? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a is AssetRegistrationContext && b is AssetRegistrationContext) {
    return a.portfolioId == b.portfolioId &&
        a.portfolioName == b.portfolioName &&
        a.countryId == b.countryId &&
        a.cityId == b.cityId &&
        a.assetType == b.assetType &&
        a.initialPlate == b.initialPlate &&
        a.expectedRelationKind == b.expectedRelationKind &&
        _mapStringStringEqual(a.vrcSnapshot, b.vrcSnapshot);
  }
  return a == b;
}

bool _mapStringStringEqual(Map<String, String>? a, Map<String, String>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}
