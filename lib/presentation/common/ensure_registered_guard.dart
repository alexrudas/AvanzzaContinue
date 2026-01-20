import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../domain/entities/org/organization_entity.dart';
import '../../domain/entities/user/active_context.dart';
import '../../routes/app_pages.dart';
import '../auth/controllers/registration_controller.dart';
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

  /// Método legacy para retrocompatibilidad con flujo antiguo
  /// TODO: Remover cuando se migre completamente al nuevo wizard
  @Deprecated('Use run() with enhanced registration wizard instead')
  Future<void> _runLegacyFlow(WriteAction action) async {
    final session = Get.find<SessionContextController>();
    final user = session.user;
    final ctx = user?.activeContext;
    if (user != null &&
        ctx != null &&
        ctx.orgId.isNotEmpty &&
        ctx.rol.isNotEmpty) {
      await action();
      return;
    }

    final reg = Get.find<RegistrationController>();

    // Onboarding común sin fricción: primero país/ciudad, luego titular y rol
    await Get.toNamed(Routes.countryCity);
    await Get.toNamed(Routes.holderType);
    await Get.toNamed(Routes.role);

    if ((reg.progress.value?.selectedRole ?? '') == 'proveedor') {
      await Get.toNamed(Routes.providerProfile);

      await Get.toNamed(Routes.providerCoverage);
    } else {
      final p = reg.progress.value;
      if ((p?.countryId ?? '').isEmpty || (p?.cityId ?? '').isEmpty) {
        await Get.toNamed(Routes.countryCity);
      }
    }

    // Persistencia mínima: crear Organization y setActiveContext
    final di = DIContainer();
    final p = reg.progress.value!;
    final orgId = 'org_${DateTime.now().millisecondsSinceEpoch}';
    final org = OrganizationEntity(
      id: orgId,
      nombre: (p.titularType == 'empresa')
          ? (p.username ?? 'Empresa')
          : (p.username ?? 'Personal'),
      tipo: p.titularType == 'empresa' ? 'empresa' : 'personal',
      countryId: p.countryId ?? 'CO',
      regionId: p.regionId,
      cityId: p.cityId,
      ownerUid: user?.uid,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
    await di.orgRepository.upsertOrg(org);

    final newCtx = ActiveContext(
      orgId: org.id,
      orgName: org.nombre,
      rol: p.selectedRole ?? 'admin_activos_ind',
      providerType: p.providerType,
      categories: const [],
      assetTypes: p.assetTypeIds,
    );

    await session.setActiveContext(newCtx);

    await action();
  }
}
