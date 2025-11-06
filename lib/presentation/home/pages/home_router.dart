// lib/tools/seed_geo.dart
import 'package:avanzza/presentation/auth/controllers/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../data/datasources/local/registration_progress_ds.dart';
import '../../../data/models/auth/registration_progress_model.dart';
import '../../../routes/app_pages.dart';
import '../../controllers/session_context_controller.dart';
import '../../workspace/workspace_config.dart';
import '../../workspace/workspace_shell.dart';

class HomeRouter extends StatelessWidget {
  const HomeRouter({super.key});

  String _normalizeOrgType(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final v = raw.toLowerCase().trim();
    if (v == 'empresa') return 'empresa';
    if (v == 'persona' || v == 'personal') return 'personal';
    debugPrint('[HomeRouter] WARN orgType unexpected=$v');
    return 'personal';
  }

  String? _normalizeProviderType(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return raw.toLowerCase().trim();
  }

  Future<void> _route() async {
    final session = Get.find<SessionContextController>();

    // 1) Con sesión activa y activeContext → enrutar por rol
    final ctx = session.user?.activeContext;
    if (ctx != null) {
      String orgType = '';
      String source = 'default';

      try {
        final di = DIContainer();
        final org = await di.orgRepository.getOrg(ctx.orgId);
        orgType = _normalizeOrgType(org?.tipo); // 'personal' | 'empresa'
        if (orgType.isNotEmpty) source = 'org';
      } catch (_) {}

      if (orgType.isEmpty) {
        try {
          if (Get.isRegistered<RegistrationController>()) {
            final reg = Get.find<RegistrationController>();
            reg.progress.value ??= await reg.progressDS.get('current');
            orgType = _normalizeOrgType(reg.progress.value?.titularType);
            if (orgType.isNotEmpty) source = 'progress';
          } else {
            final ds = RegistrationProgressDS(DIContainer().isar);
            final RegistrationProgressModel? p = await ds.get('current');
            orgType = _normalizeOrgType(p?.titularType);
            if (orgType.isNotEmpty) source = 'progress';
          }
        } catch (_) {}
      }

      if (orgType.isEmpty) {
        orgType = 'personal';
        source = 'default';
      }

      final pt = _normalizeProviderType(ctx.providerType);
      debugPrint(
          '[HomeRouter] role=${ctx.rol}, providerType=$pt, orgType=$orgType, source=$source');

      final cfg = workspaceFor(
        rol: ctx.rol,
        providerType: pt,
        orgType: orgType,
      );
      Get.offAll(() => WorkspaceShell(config: cfg));
      return;
    }

    // 2) Sin sesión: intentar leer progreso desde controller o Isar (preview)
    String? selectedRole;
    String? providerType;
    String orgType = 'personal';
    String source = 'default';

    try {
      if (Get.isRegistered<RegistrationController>()) {
        final reg = Get.find<RegistrationController>();
        reg.progress.value ??= await reg.progressDS.get('current');
        selectedRole = reg.progress.value?.selectedRole;
        providerType = _normalizeProviderType(reg.progress.value?.providerType);
        final t = _normalizeOrgType(reg.progress.value?.titularType);
        if (t.isNotEmpty) {
          orgType = t;
          source = 'progress';
        }
      } else {
        final ds = RegistrationProgressDS(DIContainer().isar);
        final RegistrationProgressModel? p = await ds.get('current');
        selectedRole = p?.selectedRole;
        providerType = _normalizeProviderType(p?.providerType);
        final t = _normalizeOrgType(p?.titularType);
        if (t.isNotEmpty) {
          orgType = t;
          source = 'progress';
        }
      }
    } catch (_) {}

    // 3) Si no hay rol de exploración, iniciar onboarding
    if (selectedRole == null || selectedRole.isEmpty) {
      Get.offAllNamed(Routes.countryCity);
      return;
    }

    debugPrint(
        '[HomeRouter] role=$selectedRole, providerType=$providerType, orgType=$orgType, source=$source');

    // 4) Construir workspace por rol/providerType/orgType
    final cfg = workspaceFor(
      rol: selectedRole,
      providerType: providerType,
      orgType: orgType,
    );
    Get.offAll(() => WorkspaceShell(config: cfg));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _route();
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
