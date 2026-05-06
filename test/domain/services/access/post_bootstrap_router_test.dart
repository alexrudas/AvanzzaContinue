// ============================================================================
// test/domain/services/access/post_bootstrap_router_test.dart
//
// QUÉ HACE:
// - Verifica el árbol de decisión simplificado (2 veredictos) tras
//   /v1/auth/bootstrap + /v1/providers/me.
//
// CAMBIOS (2026-05):
//   · Retirado `PostBootstrapRoute.createPortfolio`: el splash ya no
//     enruta automáticamente al wizard `createPortfolioStep1`.
//   · Retirado `PostBootstrapRoute.providerBootstrap`: el intent rutea
//     DIRECTO a `providerMe` (workspace de proveedor); la convergencia con
//     Core API la maneja `BootstrapSyncController` en background.
//   · Retirado parámetro `activePortfoliosCount`: ya no influye en routing.
//
// REGLAS NUEVAS:
//   1. `isProvider == true`               → providerMe
//   2. `providerOnboardingIntent == true` → providerMe (DIRECTO, sin wizard)
//   3. default                            → workspaceShell
// ============================================================================
import 'package:flutter_test/flutter_test.dart';

import 'package:avanzza/domain/services/access/post_bootstrap_router.dart';

void main() {
  group('PostBootstrapRouter — orden de prioridad', () {
    test('isProvider=true SIEMPRE rutea a providerMe', () {
      final route = PostBootstrapRouter.resolve(
        isProvider: true,
        providerOnboardingIntent: true,
      );
      expect(route, PostBootstrapRoute.providerMe);
    });

    test('isProvider=true gana incluso sin intent', () {
      final route = PostBootstrapRouter.resolve(
        isProvider: true,
        providerOnboardingIntent: false,
      );
      expect(route, PostBootstrapRoute.providerMe);
    });

    // ── REGLA NUEVA: intent rutea DIRECTO a workspace, NO al wizard ────────
    test(
        'providerOnboardingIntent=true + isProvider=false '
        '→ providerMe (DIRECTO al workspace; wizard descartado)', () {
      final route = PostBootstrapRouter.resolve(
        isProvider: false,
        providerOnboardingIntent: true,
      );
      expect(
        route,
        PostBootstrapRoute.providerMe,
        reason:
            'El intent provider debe enrutar al workspace de proveedor '
            'directamente. La provisión backend converge en background via '
            'BootstrapSyncController; el banner del shell muestra el '
            'estado. NUNCA al wizard `Routes.providerBootstrap` (zombie).',
      );
    });

    // ── REGLA NUEVA: sin intent y sin asset count → workspace shell ────────
    test('sin intent → workspaceShell (no más createPortfolio)', () {
      final route = PostBootstrapRouter.resolve(
        isProvider: false,
        providerOnboardingIntent: false,
      );
      expect(
        route,
        PostBootstrapRoute.workspaceShell,
        reason:
            'El gate "0 activos → createPortfolio" fue retirado. El user '
            'entra al workspace siempre que haya pasado el Gate 2 '
            '(activeContext.orgId hidratado); el empty-state lo maneja '
            'el shell con CTA "Registrar activo".',
      );
    });
  });

  group('PostBootstrapRouter — invariantes del enum', () {
    test('enum solo expone destinos canónicos (no zombie routes)', () {
      // Si en el futuro alguien agrega un nuevo veredicto al enum, este
      // test debe romperse intencionalmente para forzar revisión: ningún
      // valor del enum debe apuntar a un wizard legacy o ruta muerta.
      expect(PostBootstrapRoute.values, hasLength(2));
      expect(
        PostBootstrapRoute.values,
        containsAll(<PostBootstrapRoute>[
          PostBootstrapRoute.providerMe,
          PostBootstrapRoute.workspaceShell,
        ]),
      );
    });
  });
}
