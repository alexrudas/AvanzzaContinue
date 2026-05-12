// ============================================================================
// lib/domain/services/access/post_bootstrap_router.dart
// POST-BOOTSTRAP ROUTER — decisión pura de routing tras /v1/auth/bootstrap.
//
// QUÉ HACE:
// - Concentra la lógica de decisión que el `SplashBootstrapController` aplica
//   tras resolver `AccessGateway` y `GET /v1/providers/me`.
// - Devuelve un veredicto enumerado (`PostBootstrapRoute`) que el caller
//   traduce a `Routes.*` y `Get.offAllNamed`. Mantener el helper puro permite
//   testear el árbol completo de decisiones sin `Get`, sin Firebase, sin Dio.
//
// QUÉ NO HACE:
// - No navega ni toca presentación.
// - No hace HTTP. Solo recibe los flags ya resueltos.
// - No persiste ni limpia el `providerOnboardingIntent`. Esa responsabilidad
//   vive en `RegistrationIntentDS` (set en finalize, clear tras provider
//   bootstrap exitoso).
//
// PRINCIPIOS:
// - Función pura: dada la misma entrada, siempre el mismo veredicto.
// - Cero dependencias fuera de `dart:core`.
// - Reglas explícitas y trazables — cualquier cambio de orden modifica el
//   contrato y debe acompañarse de tests.
//
// EVOLUCIÓN (2026-05) — DEUDA RETIRADA:
//   Versión legacy retornaba 4 veredictos:
//     · `providerMe`         (isProvider=true)
//     · `providerBootstrap`  (intent=true, isProvider=false) → wizard legacy
//     · `createPortfolio`    (count<=0)                       → wizard legacy
//     · `workspaceShell`     (default)
//
//   Ambos wizards (`/provider/bootstrap` y `/portfolio/create/step1`) fueron
//   declarados rutas zombie. Política producto:
//     · El user entra al workspace en cuanto tenga `activeContext.orgId`.
//     · Provider intent rutea DIRECTO al workspace de proveedor (no wizard).
//     · El portfolio default se crea automáticamente en `CompleteOnboardingUC`;
//       las "flotas con nombre" pasan a ser opt-in, no prerrequisito.
//     · Empty-state de assets se maneja DENTRO del workspace shell con CTA
//       "Registrar activo" — sin redirigir a wizard.
//
//   Resultado: enum reducido a 2 veredictos. Sin destinos zombie.
// ============================================================================

/// Veredicto canónico del routing post-bootstrap.
///
/// Cualquier nuevo veredicto DEBE corresponder a una pantalla CANÓNICA del
/// producto. No agregar valores que apunten a wizards legacy o flujos
/// muertos — la regla "no zombie routes as canonical destination" es
/// invariante del módulo.
enum PostBootstrapRoute {
  /// Workspace de proveedor (`Routes.providerMe` / `providerWorkspaceServices`
  /// / `providerWorkspaceArticles` — el splash discrimina por `providerType`).
  ///
  /// Activado cuando:
  ///   · `isProvider == true` (provisión confirmada por Core API), O
  ///   · `providerOnboardingIntent == true` (registró como provider; el
  ///     `BootstrapSyncController` está convergiendo en background — el
  ///     shell muestra banner "Preparando tu cuenta…" sin bloquear).
  providerMe,

  /// Shell de "Administrador de activos" (workspace canónico para roles
  /// no-provider). Default cuando no hay señales específicas. El empty
  /// state de assets se maneja dentro del shell con CTA propio.
  workspaceShell,
}

class PostBootstrapRouter {
  PostBootstrapRouter._();

  /// Resuelve el destino canónico. Orden de prioridad invariante:
  ///
  ///   1. `isProvider == true`        → `providerMe`
  ///   2. `providerOnboardingIntent`  → `providerMe` (DIRECTO al workspace,
  ///                                    NO al wizard).
  ///   3. caso por defecto             → `workspaceShell`
  ///
  /// **NO recibe `activePortfoliosCount`**. La presencia/ausencia de
  /// portafolios NO determina la entrada al workspace bajo el modelo nuevo;
  /// el shell maneja el empty-state.
  static PostBootstrapRoute resolve({
    required bool isProvider,
    required bool providerOnboardingIntent,
  }) {
    if (isProvider) return PostBootstrapRoute.providerMe;
    if (providerOnboardingIntent) return PostBootstrapRoute.providerMe;
    return PostBootstrapRoute.workspaceShell;
  }
}
