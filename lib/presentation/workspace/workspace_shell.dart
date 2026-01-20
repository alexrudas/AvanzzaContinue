import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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
    final isAdmin = widget.config.roleKey == 'admin_activos';

    return Obx(() {
      final idx = c.index.value;

      // Obtener título del tab actual con fallback seguro
      final tabs = widget.config.tabs;
      final currentTitle = (tabs.isNotEmpty && idx >= 0 && idx < tabs.length)
          ? tabs[idx].title
          : 'Inicio'; // Fallback seguro si idx está fuera de rango

      return Scaffold(
        appBar: AppBar(
          title: Text(currentTitle),
          actions: [
            // Botón de Alertas
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              tooltip: 'Alertas',
              onPressed: () {
                // TODO: Navegar a página de alertas
                HapticFeedback.lightImpact();
              },
            ),
            // Botón de Perfil
            IconButton(
              icon: const Icon(Icons.person_outline_rounded),
              tooltip: 'Perfil',
              onPressed: () {
                // TODO: Navegar a perfil o abrir menú
                HapticFeedback.lightImpact();
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
        drawer: const WorkspaceDrawer(),
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
            index: idx, children: [for (final t in widget.config.tabs) t.page]),
        // Para admin: usar CustomFloatingNavBar (Premium Ultra-Pro)
        // Para otros roles: usar AvanzzaNavigationBar estándar
        bottomNavigationBar: isAdmin
            ? SafeArea(
                child: CustomFloatingNavBar(
                  currentIndex: idx,
                  onTap: c.setIndex,
                ),
              )
            : AvanzzaNavigationBar(
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

// ============================================================================
// CUSTOM FLOATING NAV BAR - Premium Ultra-Pro (Solo para Admin)
// ============================================================================
class CustomFloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomFloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      height: 76,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0xFF4F5CFF).withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: _NavBarItem(
                icon: Icons.grid_view_rounded,
                label: 'Inicio',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
            ),
            Expanded(
              child: _NavBarItem(
                icon: Icons.engineering_rounded,
                label: 'Mttos.',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
            ),
            Expanded(
              child: _NavBarItem(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Contabilidad',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ),
            Expanded(
              child: _NavBarItem(
                icon: Icons.inventory_2_rounded,
                label: 'Pedidos',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
                badgeCount: 0,
              ),
            ),
            Expanded(
              child: _NavBarItem(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Chat',
                isSelected: currentIndex == 4,
                onTap: () => onTap(4),
                badgeCount: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// NAV BAR ITEM - Item individual con animaciones y accesibilidad
// ============================================================================
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int badgeCount;

  const _NavBarItem({
    super.key, // Agregado super.key buena práctica
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    const selectedColor = Color(0xFF4F5CFF);
    const unselectedColor = Color(0xFFB0B8C8);

    // 1. ELIMINADO EL WIDGET EXPANDED QUE ESTABA AQUÍ
    // Retornamos directamente el Material/InkWell para que el padre decida el tamaño
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(30),
        splashColor: selectedColor.withValues(alpha: 0.1),
        highlightColor: selectedColor.withValues(alpha: 0.05),
        child: Container(
          // Quitamos constraints de altura forzada para que se adapte mejor
          // o mantenemos minHeight si prefieres que no colapse
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center, // Asegura centrado del stack
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize:
                    MainAxisSize.min, // Importante para que no se estire de más
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.all(isSelected ? 6 : 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? selectedColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? selectedColor : unselectedColor,
                      size: isSelected ? 26 : 24,
                      semanticLabel: label,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isSelected ? 1.0 : 0.6,
                    child: Text(
                      label,
                      maxLines: 1, // Evita que textos largos rompan el diseño
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected ? selectedColor : unselectedColor,
                        fontSize: isSelected ? 11 : 10,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
              if (badgeCount > 0)
                Positioned(
                  right: -5, // Ajustado ligeramente
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3D00),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      badgeCount > 9 ? '9+' : badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
