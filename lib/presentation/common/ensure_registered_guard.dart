import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../domain/entities/org/organization_entity.dart';
import '../../domain/entities/user/active_context.dart';
import '../../routes/app_pages.dart';
import '../auth/controllers/registration_controller.dart';
import '../controllers/session_context_controller.dart';

typedef WriteAction = Future<void> Function();

/// EnsureRegisteredGuard mejorado
/// - Si no hay activeContext, orquesta wizard mínimo y persiste contexto/org.
class EnsureRegisteredGuard {
  Future<void> run(WriteAction action) async {
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
