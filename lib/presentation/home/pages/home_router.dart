import 'package:avanzza/presentation/auth/controllers/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../controllers/session_context_controller.dart';

class HomeRouter extends StatelessWidget {
  const HomeRouter({super.key});

  void _route() {
    final session = Get.find<SessionContextController>();
    final registrationController = Get.find<RegistrationController>();
    if (registrationController.progress.value == null) {}

    final ctx = session.user?.activeContext;
    final currentProgress = registrationController.progress.value;
    print("HomeRouter[_route][session.user?.activeContext] $ctx");
    print("HomeRouter[_route][currentProgress] $currentProgress");

    if (ctx == null && currentProgress == null) {
      // Primero país/ciudad para explorar sin fricción
      Get.offAllNamed(Routes.countryCity);
      return;
    }

    final rol = (ctx?.rol)?.toLowerCase() ?? "";
    if (rol.contains('admin') ||
        currentProgress?.selectedRole?.contains('admin') == true) {
      Get.offAllNamed(Routes.adminHome);
      return;
    }
    if (rol.contains('propietario') ||
        currentProgress?.selectedRole?.contains('propietario') == true) {
      Get.offAllNamed(Routes.wsOwner);
      return;
    }
    if (rol.contains('arrendatario') ||
        currentProgress?.selectedRole?.contains('arrendatario') == true) {
      Get.offAllNamed(Routes.wsRenter);
      return;
    }
    if (rol.contains('proveedor') ||
        currentProgress?.selectedRole?.contains('proveedor') == true) {
      final pt = (ctx?.providerType ?? '').toLowerCase();
      if (pt == 'articulos') {
        Get.offAllNamed(Routes.wsProviderArticles);
      } else {
        Get.offAllNamed(Routes.wsProviderServices);
      }
      return;
    }
    if (rol.contains('asesor') ||
        currentProgress?.selectedRole?.contains('asesor') == true) {
      Get.offAllNamed(Routes.wsInsuranceAdvisor);
      return;
    }
    if (rol.contains('aseguradora') ||
        rol.contains('broker') ||
        currentProgress?.selectedRole?.contains('aseguradora') == true ||
        currentProgress?.selectedRole?.contains('broker') == true) {
      Get.offAllNamed(Routes.wsInsurer);
      return;
    }
    if (rol.contains('abog') ||
        currentProgress?.selectedRole?.contains('abog') == true) {
      Get.offAllNamed(Routes.wsLegal);
      return;
    }
    // Fallback
    Get.offAllNamed(Routes.adminHome);
  }

  @override
  Widget build(BuildContext context) {
    // Desacople de build; enrutamos en el primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
