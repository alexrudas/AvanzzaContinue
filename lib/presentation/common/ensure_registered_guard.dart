import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../controllers/session_context_controller.dart';
import '../widgets/modal/confirmation_dialog.dart';

typedef WriteAction = Future<void> Function();

/// EnsureRegisteredGuard mejorado con diálogo de confirmación
/// - Si usuario ya está registrado (tiene activeContext), ejecuta la acción inmediatamente
/// - Si NO está registrado, muestra diálogo de confirmación antes de iniciar wizard
/// - Wizard completo con MFA, escaneo de documento, ubicación y términos
class EnsureRegisteredGuard {
  Future<void> run(WriteAction action) async {
    final session = Get.find<SessionContextController>();
    final user = session.user;
    final ctx = user?.activeContext;

    // Si ya está registrado con contexto activo → ejecutar acción directamente
    if (user != null &&
        ctx != null &&
        ctx.orgId.isNotEmpty &&
        ctx.rol.isNotEmpty) {
      await action();
      return;
    }

    // Usuario NO registrado → Mostrar diálogo de confirmación
    final result = await ConfirmationDialog.show(
      Get.context!,
      const ConfirmationDialogConfig(
        title: '¡Desbloquea todo el potencial de Avanzza!',
        message:
            'Regístrate para guardar tus datos, sincronizar entre dispositivos y acceder a todas las funcionalidades',
        confirmText: 'Registrarme ahora',
        cancelText: 'Ahora no',
        icon: Icons.rocket_launch,
        isDestructive: false,
      ),
    );

    // Si usuario cancela → NO ejecutar acción
    if (result == ConfirmationResult.cancelled) {
      Get.snackbar(
        'Acción cancelada',
        'Necesitas registrarte para realizar esta acción',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
        duration: const Duration(seconds: 3),
      );
      return; // Salir sin ejecutar
    }

    // Usuario acepta → Navegar al wizard de registro mejorado
    await Get.toNamed(Routes.enhancedRegistration);

    // Verificar que ahora SÍ haya contexto activo (registro completado)
    final updatedSession = Get.find<SessionContextController>();
    final updatedUser = updatedSession.user;
    final updatedCtx = updatedUser?.activeContext;

    if (updatedUser == null ||
        updatedCtx == null ||
        updatedCtx.orgId.isEmpty ||
        updatedCtx.rol.isEmpty) {
      // Usuario abandonó el registro sin completarlo
      Get.snackbar(
        'Registro incompleto',
        'Debes completar el registro para continuar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
      );
      return; // Salir sin ejecutar
    }

    // Registro completado exitosamente → Ejecutar acción original
    await action();
  }

}
