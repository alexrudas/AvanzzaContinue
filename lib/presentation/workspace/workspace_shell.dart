import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../core/theme/bottom_nav_theme.dart';
import '../../core/utils/workspace_normalizer.dart';
import '../../routes/app_pages.dart';
import '../auth/controllers/registration_controller.dart';
import '../controllers/session_context_controller.dart';
import '../widgets/workspace/workspace_drawer.dart';
import 'workspace_config.dart';

/// Simple controller for tab navigation within a workspace
class _TabNavigationController extends GetxController {
  final RxInt index = 0.obs;
  void setIndex(int value) => index.value = value;
}

class WorkspaceShell extends StatefulWidget {
  final WorkspaceConfig config;
  const WorkspaceShell({super.key, required this.config});

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  late final _TabNavigationController c;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    widget.config.onInit?.call();
    c = Get.put(_TabNavigationController(), permanent: false);
    _setupReactiveListeners();
  }

  @override
  void dispose() {
    Get.delete<_TabNavigationController>();
    super.dispose();
  }

  /// Configura listeners reactivos para detectar eliminación de workspace activo
  void _setupReactiveListeners() {
    // Listener para auth (SessionContextController)
    if (Get.isRegistered<SessionContextController>()) {
      final session = Get.find<SessionContextController>();
      ever(session.userRx, (_) {
        _checkAndNavigateIfNeeded();
      });
    }

    // Listener para guest (RegistrationController)
    if (Get.isRegistered<RegistrationController>()) {
      final reg = Get.find<RegistrationController>();
      ever(reg.progress, (_) {
        _checkAndNavigateIfNeeded();
      });
    }
  }

  /// Verifica si el workspace actual sigue siendo válido, si no navega a Home
  void _checkAndNavigateIfNeeded() {
    if (_isNavigating) return;

    // Detectar fuente y rol activo
    String? activeRole;
    bool isAuth = false;

    if (Get.isRegistered<SessionContextController>()) {
      final session = Get.find<SessionContextController>();
      final user = session.userRx.value;
      if (user != null) {
        activeRole = user.activeContext?.rol;
        isAuth = true;
      }
    }

    if (!isAuth && Get.isRegistered<RegistrationController>()) {
      final reg = Get.find<RegistrationController>();
      activeRole = reg.progress.value?.selectedRole;
    }

    // Si no hay rol activo o está vacío, navegar a Home
    if (activeRole == null || activeRole.isEmpty) {
      _navigateToHome();
      return;
    }

    // Verificar si el rol actual del shell coincide con el activo
    final currentRole = WorkspaceNormalizer.normalize(widget.config.roleKey);
    final normalizedActive = WorkspaceNormalizer.normalize(activeRole);

    if (currentRole != normalizedActive) {
      // El rol cambió, navegar a Home (que redirigirá al workspace correcto)
      _navigateToHome();
    }
  }

  /// Navega a Home de forma segura con anti-loop
  void _navigateToHome() {
    if (_isNavigating) return;

    _isNavigating = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute != Routes.home) {
        Get.offAllNamed(Routes.home);
      }

      // Reset flag después de timeout
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _isNavigating = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Parsear roleKey a UserRole para aplicar el tema correcto
    final userRole = parseUserRole(widget.config.roleKey);

    return Obx(() {
      final idx = c.index.value;

      // Reactive title: leer desde fuente dual
      String displayTitle = widget.config.roleKey;
      if (Get.isRegistered<SessionContextController>()) {
        final session = Get.find<SessionContextController>();
        displayTitle = session.userRx.value?.activeContext?.rol ?? widget.config.roleKey;
      } else if (Get.isRegistered<RegistrationController>()) {
        final reg = Get.find<RegistrationController>();
        displayTitle = reg.progress.value?.selectedRole ?? widget.config.roleKey;
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(displayTitle),
        ),
        drawer: const WorkspaceDrawer(),
        body: IndexedStack(
            index: idx, children: [for (final t in widget.config.tabs) t.page]),
        // Usar NavigationBar (M3) siempre para aprovechar el diseño de burbujas
        // Material 3 está habilitado globalmente en app_theme.dart
        bottomNavigationBar: AvanzzaNavigationBar(
          role: userRole,
          currentIndex: idx,
          destinations: [
            for (final t in widget.config.tabs)
              NavigationDestination(icon: Icon(t.icon), label: t.title)
          ],
          onDestinationSelected: c.setIndex,
        ),
      );
    });
  }
}
