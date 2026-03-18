// ============================================================================
// lib/presentation/home/pages/home_router.dart
// HOME ROUTER — Enterprise Ultra Pro Premium (Presentation / Home)
//
// QUÉ HACE:
// - Actúa como pantalla de tránsito mientras SplashBootstrapController
//   ejecuta bootstrap y decide el destino correcto.
// - Dispara bootstrap una sola vez por ciclo de vida del widget.
// - Mantiene una UI mínima, limpia y consistente con el branding/tema de Avanzza
//   mientras el sistema resuelve el routing inicial.
//
// QUÉ NO HACE:
// - NO contiene lógica de routing.
// - NO resuelve gates de auth/profile/assets/workspace.
// - NO navega directamente a workspaces ni flujos de onboarding.
// - NO usa Future.delayed ni temporizadores artificiales.
//
// PRINCIPIOS:
// - THIN ROUTER: toda la lógica vive en SplashBootstrapController.
// - SINGLE TRIGGER: bootstrap se dispara en initState(), no en cada build().
// - FAIL-FAST: si SplashBootstrapController no está registrado, el error debe
//   emerger inmediatamente.
// - DETERMINISMO: mientras bootstrap corre, solo muestra loading shell.
// - CONSISTENCIA VISUAL: usa el fondo del tema para una transición suave.
//
// NOTAS ENTERPRISE:
// - SplashBootstrapController debe estar registrado antes de construir este widget.
// - El guard anti-reentrada vive en SplashBootstrapController, no aquí.
// - Este widget no observa estado; solo inicia el flujo y muestra loading.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splash_bootstrap_controller.dart';

class HomeRouter extends StatefulWidget {
  const HomeRouter({super.key});

  @override
  State<HomeRouter> createState() => _HomeRouterState();
}

class _HomeRouterState extends State<HomeRouter> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SplashBootstrapController>().bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Semantics(
          label: 'Cargando',
          child: const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }
}
