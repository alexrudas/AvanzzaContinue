// ============================================================================
// lib/presentation/home/pages/home_router.dart
// HOME ROUTER — Enterprise Ultra Pro (Presentation / Home)
//
// QUÉ HACE:
// - Muestra CircularProgressIndicator mientras SplashBootstrapController
//   resuelve las gates y enruta al destino correcto.
// - Delega toda la lógica de routing a SplashBootstrapController.
//
// QUÉ NO HACE:
// - No contiene lógica de routing (movida a SplashBootstrapController).
// - No usa Future.delayed (eliminado; reemplazado por stream determinista).
//
// NOTAS:
// - SplashBootstrapController debe estar registrado en HomeBinding antes
//   de que este widget sea construido.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splash_bootstrap_controller.dart';

class HomeRouter extends StatelessWidget {
  const HomeRouter({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SplashBootstrapController>().bootstrap();
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
