// ============================================================================
// lib/presentation/pages/splash/splash_bootstrap_page.dart
// SPLASH BOOTSTRAP PAGE — Enterprise Ultra Pro (Presentation / Pages)
//
// QUÉ HACE:
// - Primera pantalla visible al abrir la app.
// - Muestra branding (logo + nombre) + indicador de carga.
// - Delega TODA la lógica de routing a SplashBootstrapController.bootstrap().
//
// QUÉ NO HACE:
// - No contiene lógica de negocio ni de navegación.
// - No usa Future.delayed (el timing lo controla el controller vía streams).
// - No expone estado interno al árbol de widgets (onReady en controller).
//
// NOTAS:
// - SplashBootstrapController debe estar registrado en SplashBinding ANTES
//   de que este widget sea construido (garantizado por GetPage.binding).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splash_bootstrap_controller.dart';

class SplashBootstrapPage extends StatefulWidget {
  const SplashBootstrapPage({super.key});

  @override
  State<SplashBootstrapPage> createState() => _SplashBootstrapPageState();
}

class _SplashBootstrapPageState extends State<SplashBootstrapPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    // Fade-in suave de 350ms — invisible en bootstrap rápido (~0ms),
    // agradable en dispositivos lentos o con red fría.
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();

    // Bootstrap en el primer frame post-build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SplashBootstrapController>().bootstrap();
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo ──────────────────────────────────────────────────
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.directions_car_rounded,
                    size: 52,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Nombre ────────────────────────────────────────────────
                Text(
                  'Avanzza',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gestión inteligente de activos',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 40),

                // ── Loader ────────────────────────────────────────────────
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
