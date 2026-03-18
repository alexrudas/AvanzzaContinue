// ============================================================================
// lib/presentation/workspace/workspace_shell.dart
// WORKSPACE SHELL — Enterprise Ultra Pro Premium (Presentation / Workspace)
//
// QUÉ HACE:
// - Renderiza el shell visual del workspace activo usando WorkspaceConfig.
// - Muestra AppBar, Drawer y BottomNavigationBar según la configuración recibida.
// - Detecta cambios de contexto activo y redirige a Routes.home cuando el shell
//   abierto ya no coincide con el contexto vigente.
// - Usa SessionContextController.activeWorkspaceContext como fuente principal
//   de verdad durante Fase 1.
// - Mantiene compatibilidad transicional con activeContext.rol/selectedRole
//   solo como fallback legacy.
//
// QUÉ NO HACE:
// - NO decide qué workspace abrir inicialmente (eso es SplashBootstrapController).
// - NO persiste estado de tabs entre sesiones.
// - NO consulta repositorios ni lógica de dominio.
// - NO resuelve rutas finales de bootstrap.
// - NO construye WorkspaceContext.
//
// PRINCIPIOS:
// - THIN SHELL: solo coordinación visual + reacción a cambios de contexto.
// - PRIMARY SOURCE: activeWorkspaceContext manda; roleKey string queda como fallback.
// - ANTI-LOOP: _isNavigating previene reentradas concurrentes a Routes.home.
// - TRANSITION-SAFE: si el contexto aún está hidratándose, evita navegar prematuramente.
// - FASE 1: el navbar premium admin usa WorkspaceType.assetAdmin, no roleKey.
//
// NOTAS ENTERPRISE:
// - El shell compara principalmente widget.config.workspaceType vs
//   session.activeWorkspaceContext.value?.type.
// - Si activeWorkspaceContext aún es null, usa fallback conservador con rol legacy.
// - Si Firebase user existe pero el contexto aún no está listo, se asume estado
//   transicional y NO se navega inmediatamente.
// - Si el contexto activo se vuelve unknown o deja de coincidir, se redirige a
//   Routes.home para que HomeRouter/Bootstrap recompongan el flujo.
//
// DEPENDENCIAS:
// - WorkspaceConfig / WorkspaceType
// - SessionContextController
// - RegistrationController
// - WorkspaceDrawer
// - bottom_nav_theme (AvanzzaNavigationBar / parseUserRole)
// - WorkspaceNormalizer (solo fallback legacy)
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/theme/bottom_nav_theme.dart';
import '../../core/utils/workspace_normalizer.dart';
import '../../domain/entities/workspace/workspace_type.dart';
import '../../routes/app_pages.dart';
import '../auth/controllers/registration_controller.dart';
import '../controllers/session_context_controller.dart';
import '../widgets/workspace/workspace_drawer.dart';
import 'workspace_config.dart';

/// Controller simple para navegación entre tabs dentro del shell.
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

  /// Guard anti-loop para navegación a home.
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
    if (Get.isRegistered<_TabNavigationController>()) {
      Get.delete<_TabNavigationController>();
    }
    super.dispose();
  }

  /// Configura listeners reactivos para detectar invalidación del shell actual.
  void _setupReactiveListeners() {
    if (Get.isRegistered<SessionContextController>()) {
      final session = Get.find<SessionContextController>();

      // Fuente principal de verdad en Fase 1.
      ever(session.activeWorkspaceContext, (_) {
        _checkAndNavigateIfNeeded();
      });

      // Compatibilidad transicional con el modelo legacy.
      ever(session.userRx, (_) {
        _checkAndNavigateIfNeeded();
      });
    }

    // Compatibilidad guest / onboarding.
    if (Get.isRegistered<RegistrationController>()) {
      final reg = Get.find<RegistrationController>();
      ever(reg.progress, (_) {
        _checkAndNavigateIfNeeded();
      });
    }
  }

  /// Verifica si el shell actual sigue alineado con el contexto activo.
  ///
  /// Regla principal:
  /// - comparar `widget.config.workspaceType` con `activeWorkspaceContext.type`
  ///
  /// Fallback transicional:
  /// - comparar roleKey vs selectedRole/activeContext.rol solo si todavía no hay
  ///   activeWorkspaceContext disponible.
  void _checkAndNavigateIfNeeded() {
    if (_isNavigating) return;

    final hasFirebaseUser = FirebaseAuth.instance.currentUser != null;

    SessionContextController? session;
    if (Get.isRegistered<SessionContextController>()) {
      session = Get.find<SessionContextController>();
    }

    final activeWorkspaceContext = session?.activeWorkspaceContext.value;

    // -----------------------------------------------------------------------
    // CAMINO PRINCIPAL — WorkspaceContext tipado
    // -----------------------------------------------------------------------
    if (activeWorkspaceContext != null) {
      final activeType = activeWorkspaceContext.type;

      // Unknown nunca debe sostener un shell operativo.
      if (activeType == WorkspaceType.unknown) {
        _log(
          'activeWorkspaceContext.type = unknown → redirigiendo a Routes.home',
        );
        _navigateToHome();
        return;
      }

      // Si el shell abierto ya no coincide con el tipo activo, redirigir.
      if (widget.config.workspaceType != activeType) {
        _log(
          'workspaceType mismatch '
          'shell=${widget.config.workspaceType.wireName} '
          'active=${activeType.wireName} '
          '→ redirigiendo a Routes.home',
        );
        _navigateToHome();
        return;
      }

      // El shell sigue válido.
      return;
    }

    // -----------------------------------------------------------------------
    // FALLBACK TRANSICIONAL — modelo legacy
    // Solo se usa mientras activeWorkspaceContext aún no esté disponible.
    // -----------------------------------------------------------------------
    String? activeRole;
    bool isAuthenticatedSession = false;

    if (session != null) {
      final user = session.userRx.value;
      if (user != null) {
        activeRole = user.activeContext?.rol;
        isAuthenticatedSession = true;
      }
    }

    if (!isAuthenticatedSession && Get.isRegistered<RegistrationController>()) {
      final reg = Get.find<RegistrationController>();
      activeRole = reg.progress.value?.selectedRole;
    }

    // Si no hay rol activo, distinguir entre estado transicional y sesión inválida.
    if (activeRole == null || activeRole.isEmpty) {
      if (hasFirebaseUser) {
        _log(
          'activeWorkspaceContext=null y activeRole vacío, '
          'pero Firebase user activo → estado transicional, no navegar',
        );
        return;
      }

      _log(
        'sin activeWorkspaceContext y sin activeRole, '
        'Firebase user nulo → redirigiendo a Routes.home',
      );
      _navigateToHome();
      return;
    }

    final currentRole = WorkspaceNormalizer.normalize(widget.config.roleKey);
    final normalizedActiveRole = WorkspaceNormalizer.normalize(activeRole);

    if (currentRole != normalizedActiveRole) {
      _log(
        'fallback legacy mismatch '
        'shellRole=$currentRole activeRole=$normalizedActiveRole '
        '→ redirigiendo a Routes.home',
      );
      _navigateToHome();
    }
  }

  /// Navega a Home de forma segura con anti-loop.
  ///
  /// HomeRouter / SplashBootstrapController reencaminarán al shell correcto.
  void _navigateToHome() {
    if (_isNavigating) return;

    _isNavigating = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (kDebugMode) {
        final fbUid = FirebaseAuth.instance.currentUser?.uid;
        debugPrint(
          '[NAV][HOME] WorkspaceShell → Routes.home '
          'firebaseUser=${fbUid != null ? '${fbUid.substring(0, fbUid.length.clamp(0, 4))}***' : 'null'} '
          'currentRoute=${Get.currentRoute}',
        );
      }

      if (Get.currentRoute != Routes.home) {
        Get.offAllNamed(Routes.home);
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _isNavigating = false;
        }
      });
    });
  }

  void _log(String msg) {
    if (kDebugMode || kProfileMode) {
      debugPrint('[WORKSPACE_SHELL] $msg');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRole = parseUserRole(widget.config.roleKey);
    final isAdmin = widget.config.workspaceType == WorkspaceType.assetAdmin;

    return Obx(() {
      final idx = c.index.value;
      final tabs = widget.config.tabs;

      final currentTitle = (tabs.isNotEmpty && idx >= 0 && idx < tabs.length)
          ? tabs[idx].title
          : 'Inicio';

      return Scaffold(
        appBar: AppBar(
          title: Text(currentTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              tooltip: 'Alertas',
              onPressed: () {
                HapticFeedback.lightImpact();
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline_rounded),
              tooltip: 'Perfil',
              onPressed: () {
                HapticFeedback.lightImpact();
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
        drawer: const WorkspaceDrawer(),
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
          index: idx,
          children: [for (final t in tabs) t.page],
        ),
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
                  for (final t in tabs)
                    NavigationDestination(
                      icon: Icon(t.icon),
                      label: t.title,
                    ),
                ],
                onDestinationSelected: c.setIndex,
              ),
      );
    });
  }
}

// ============================================================================
// CUSTOM FLOATING NAV BAR — Premium Ultra Pro (Solo para assetAdmin)
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
// NAV BAR ITEM — Item individual con animaciones y accesibilidad
// ============================================================================

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int badgeCount;

  const _NavBarItem({
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
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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
                      maxLines: 1,
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
                  right: -5,
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
