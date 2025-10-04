import 'package:avanzza/presentation/auth/controllers/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../controllers/session_context_controller.dart';
import '../../workspace/workspace_config.dart';
import '../../workspace/workspace_shell.dart';

class HomeRouter extends StatelessWidget {
  const HomeRouter({super.key});

  void _route() {
    final session = Get.find<SessionContextController>();
    final registrationController = Get.find<RegistrationController>();

    final ctx = session.user?.activeContext;
    final currentProgress = registrationController.progress.value;

    if (ctx == null && currentProgress == null) {
      // Primero país/ciudad para explorar sin fricción
      Get.offAllNamed(Routes.countryCity);
      return;
    }

    // Resolver rol + providerType desde ctx o desde progreso
    final rol = (ctx?.rol)?.toLowerCase() ??
        (currentProgress?.selectedRole ?? '').toLowerCase();
    final providerType = ctx?.providerType ?? currentProgress?.providerType;

    // Construir config y montar WorkspaceShell
    final cfg = workspaceFor(rol: rol, providerType: providerType);
    Get.offAll(() => WorkspaceShell(config: cfg));
  }

  @override
  Widget build(BuildContext context) {
    // Desacople de build; enrutamos en el primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
