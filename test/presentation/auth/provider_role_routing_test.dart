// ============================================================================
// test/presentation/auth/provider_role_routing_test.dart
//
// Verifica el invariante de routing tras la corrección MF1:
//   "Empresa + Proveedor" jamás navega al legacy `Routes.providerProfile`
//   (`/auth/provider/profile`). Las pantallas afectadas redirigen al
//   wizard nuevo `Routes.providerBootstrap` o (en registro inicial) a
//   `Routes.registerSummary` para completar el bootstrap base primero.
//
// Patrón: assertion estructural sobre el código fuente. Los routings
// viven dentro de closures (`routeForWorkspaces`) en widgets, lo cual
// hace inviable un test unitario tradicional sin refactor; el assertion
// estructural es suficiente para detectar regresiones donde alguien
// vuelva a apuntar la ruta legacy.
// ============================================================================

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _projectRoot = '.';

String _readSource(String relativePath) {
  final f = File('$_projectRoot/$relativePath');
  expect(f.existsSync(), isTrue, reason: 'Archivo ausente: $relativePath');
  return f.readAsStringSync();
}

void main() {
  group('Provider role routing — invariantes post-MF1', () {
    test(
      'select_profile_page.dart NO referencia Routes.providerProfile',
      () {
        final src = _readSource(
          'lib/presentation/auth/pages/select_profile_page.dart',
        );
        expect(
          src.contains('Routes.providerProfile'),
          isFalse,
          reason:
              'select_profile_page.dart no debe navegar al legacy '
              '/auth/provider/profile. Use Routes.providerBootstrap '
              '(append-mode) o Routes.registerSummary (registro inicial).',
        );
      },
    );

    test(
      'select_profile_page.dart redirige proveedor (append) a Routes.providerBootstrap',
      () {
        final src = _readSource(
          'lib/presentation/auth/pages/select_profile_page.dart',
        );
        expect(
          src.contains('Routes.providerBootstrap'),
          isTrue,
          reason:
              'En append-mode, proveedor debe redirigir al wizard nuevo '
              '(Routes.providerBootstrap).',
        );
        expect(
          src.contains('Routes.registerSummary'),
          isTrue,
          reason:
              'En registro inicial, todos los roles (incluido proveedor) '
              'deben pasar por registerSummary para bootstrap base.',
        );
      },
    );

    test(
      'select_profile_page.dart contiene log [AuthRoleSelection] continue tapped',
      () {
        final src = _readSource(
          'lib/presentation/auth/pages/select_profile_page.dart',
        );
        expect(
          src.contains('[AuthRoleSelection] continue tapped'),
          isTrue,
          reason:
              'Debe loguear selectedUserType, selectedRole y targetRoute en '
              'el continue.',
        );
        // Verificar que el log incluye los 3 campos requeridos.
        expect(src.contains('selectedUserType='), isTrue);
        expect(src.contains('selectedRole='), isTrue);
        expect(src.contains('targetRoute='), isTrue);
      },
    );

    test(
      'select_profile_page.dart muestra Snackbar cuando la navegación falla',
      () {
        final src = _readSource(
          'lib/presentation/auth/pages/select_profile_page.dart',
        );
        // Forma robusta: la frase aparece en el snackbar del fallback.
        expect(
          src.contains('No pudimos continuar'),
          isTrue,
          reason: 'El catch del Get.toNamed debe disparar Snackbar UX.',
        );
        expect(
          src.contains('Get.snackbar'),
          isTrue,
          reason: 'Debe usar Get.snackbar, no solo debugPrint.',
        );
      },
    );

    test(
      'select_role_page.dart NO referencia Routes.providerProfile',
      () {
        final src = _readSource(
          'lib/presentation/auth/pages/select_role_page.dart',
        );
        expect(
          src.contains('Routes.providerProfile'),
          isFalse,
          reason:
              'En el flujo de exploración pre-registro, proveedor sigue el '
              'mismo camino que los demás roles (Routes.home).',
        );
      },
    );

    test(
      'workspace_drawer.dart NO referencia Routes.providerProfile (solo el .backup permitido)',
      () {
        final src = _readSource(
          'lib/presentation/widgets/workspace/workspace_drawer.dart',
        );
        expect(
          src.contains('Routes.providerProfile'),
          isFalse,
          reason:
              'El drawer activo debe redirigir el workspace Proveedor al '
              'wizard nuevo (Routes.providerBootstrap).',
        );
        expect(
          src.contains('Routes.providerBootstrap'),
          isTrue,
          reason: 'El drawer activo debe usar Routes.providerBootstrap.',
        );
      },
    );

    test(
      'ProviderBootstrapController es idempotente: redirige al workspace de proveedor si ya es proveedor',
      () {
        // Garantía estructural: el controller llama me() en onInit y
        // redirige a Routes.providerWorkspaceServices cuando
        // isProvider=true (refactor S9: la ruta canónica de entrada del
        // proveedor ya provisionado es el workspace shell, no la vista
        // /provider/me que era una landing intermedia).
        final src = _readSource(
          'lib/presentation/controllers/provider/bootstrap/'
          'provider_bootstrap_controller.dart',
        );
        expect(
          src.contains('Routes.providerWorkspaceServices'),
          isTrue,
          reason: 'Bootstrap controller debe poder redirigir al workspace de '
              'proveedor cuando me().isProvider=true.',
        );
        expect(
          src.contains('_runIdempotentCheck'),
          isTrue,
          reason:
              'Bootstrap controller debe ejecutar un check idempotente en '
              'onInit antes de mostrar el wizard.',
        );
      },
    );
  });
}
