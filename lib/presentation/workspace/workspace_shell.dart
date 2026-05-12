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

import '../../core/config/feature_flags.dart';
import '../../domain/entities/workspace/workspace_type.dart';
import '../../routes/app_pages.dart';
import '../auth/controllers/registration_controller.dart';
import '../controllers/session_context_controller.dart';
import '../widgets/workspace/workspace_drawer.dart';
import 'workspace_config.dart';
import 'workspace_shell_bootstrap_layer.dart';

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

  // ── Swipe shell (FeatureFlags.useSwipeableShell) ──────────────────────────
  // PageController + Worker viven SOLO en el path nuevo. Cuando la flag está
  // OFF se mantienen en null y el shell sigue usando `_LazyIndexedStack`.
  PageController? _pageController;
  Worker? _indexWorker;

  /// Anti-reentrada: `true` mientras un cambio de página originado por
  /// `onPageChanged` está propagándose a `c.setIndex`. Evita que el worker
  /// reaccione y vuelva a llamar `animateToPage` sobre la misma página.
  bool _syncingFromPageView = false;

  @override
  void initState() {
    super.initState();
    widget.config.onInit?.call();
    c = Get.put(_TabNavigationController(), permanent: false);

    // Path nuevo: PageView + Worker. Si la flag está OFF, no instanciamos
    // nada — el `_LazyIndexedStack` no necesita controller ni worker.
    if (FeatureFlags.useSwipeableShell) {
      _pageController = PageController(initialPage: c.index.value);
      _indexWorker = ever<int>(c.index, _syncPageFromIndex);
    }

    _setupReactiveListeners();
  }

  @override
  void dispose() {
    // Orden estricto: cancelar worker → dispose PageController → delete
    // _TabNavigationController → super. Si el orden se altera (p.ej. delete
    // antes de cancelar el worker), el worker puede dispararse contra un
    // controller ya eliminado.
    _indexWorker?.dispose();
    _indexWorker = null;
    _pageController?.dispose();
    _pageController = null;
    if (Get.isRegistered<_TabNavigationController>()) {
      Get.delete<_TabNavigationController>();
    }
    super.dispose();
  }

  /// Sincroniza `_pageController` cuando el índice canónico (`c.index`)
  /// cambia por una vía distinta al propio PageView — típicamente tap en
  /// el NavigationBar.
  ///
  /// Reglas:
  /// - Salta si el cambio vino del propio PageView (`_syncingFromPageView`).
  /// - Salta si el shell ya no está montado o el controller no tiene clients.
  /// - Salta si la página actual ya coincide con el target.
  /// - Para saltos lejanos (|target - current| > 1) usa `jumpToPage` para no
  ///   atravesar visualmente las tabs intermedias (y no forzar su lazy build
  ///   simplemente por estar de paso).
  /// - Para adyacentes usa `animateToPage` con 220ms / easeOutCubic.
  void _syncPageFromIndex(int target) {
    if (_syncingFromPageView) return;
    if (!mounted) return;
    final controller = _pageController;
    if (controller == null || !controller.hasClients) return;

    final current = controller.page?.round() ?? c.index.value;
    if (current == target) return;

    if ((target - current).abs() > 1) {
      controller.jumpToPage(target);
    } else {
      controller.animateToPage(
        target,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    }
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
    // Fase 2 (KILL SWITCH ROL LEGACY): el fallback por `activeContext.rol`
    // / `selectedRole` fue retirado. Sin `activeWorkspaceContext` y sin
    // sesión Firebase, redirige al Splash via Routes.home (HomeRouter
    // reencamina al shell correcto). Si hay sesión Firebase pero el contexto
    // canónico aún no resolvió, se considera estado transicional y NO se
    // navega para evitar loops.
    // -----------------------------------------------------------------------
    if (!hasFirebaseUser) {
      _log(
        'sin activeWorkspaceContext y sin Firebase user → '
        'redirigiendo a Routes.home',
      );
      _navigateToHome();
      return;
    }

    _log(
      'activeWorkspaceContext=null pero Firebase user activo → '
      'estado transicional, no navegar',
    );
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

  /// Body alternativo bajo `FeatureFlags.useSwipeableShell = true`.
  ///
  /// Usa `PageView.builder` para habilitar swipe horizontal entre las tabs
  /// principales. Estrategia:
  /// - LAZY NATURAL: `itemBuilder` sólo se invoca cuando la página entra en
  ///   viewport (visible o adyacente durante swipe). No se montan las 5 tabs
  ///   upfront. Aceptamos que un peek + cancel construya la adyacente — es
  ///   el coste del lazy natural y evita el flicker que generaría un
  ///   placeholder plano.
  /// - KEEP-ALIVE: cada page se envuelve en `_KeepAliveTab` para preservar
  ///   estado (scroll, FAB visibility, `bucketsRx` de Mi Red, workers de
  ///   Home) cuando la página queda fuera del cache window de PageView.
  /// - SYNC NavigationBar ↔ PageView: `onPageChanged` propaga el índice al
  ///   `_TabNavigationController`; el worker `_indexWorker` propaga taps
  ///   del navbar al PageController. El guard `_syncingFromPageView` rompe
  ///   el ciclo bidireccional.
  Widget _buildSwipeBody(List<WorkspaceTab> tabs) {
    final controller = _pageController;
    // Safety: si la flag se activó mid-build o el controller no se creó por
    // alguna razón, caer al path estático. No debería ocurrir bajo el flujo
    // normal, pero evita crash si algún caller manipula la flag en runtime
    // sin hot-restart.
    if (controller == null) {
      return _LazyIndexedStack(
        index: c.index.value,
        children: [for (final t in tabs) t.page],
      );
    }
    return PageView.builder(
      controller: controller,
      itemCount: tabs.length,
      onPageChanged: (i) {
        if (c.index.value == i) return;
        _syncingFromPageView = true;
        c.setIndex(i);
        _syncingFromPageView = false;
      },
      itemBuilder: (ctx, i) => _KeepAliveTab(child: tabs[i].page),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Get.toNamed(Routes.account);
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
        drawer: const WorkspaceDrawer(),
        resizeToAvoidBottomInset: false,
        // TODO(perf): este `Obx` reconstruye AppBar + drawer + body +
        // bottomNavigationBar cada vez que cambia `c.index.value`, aunque
        // sólo el title del AppBar y el `currentIndex` del navbar dependen
        // realmente del índice. Bajo PageView esto no se agrava (PageView
        // absorbe los rebuilds del body gracias a KeepAlive), pero si
        // DevTools muestra costo perceptible en swipe rápido, granularizar
        // en un PR posterior: mover el reactivo sólo al `title:` del AppBar
        // y al `currentIndex:` del navbar; sacar el `PageView` del Obx.
        body: WorkspaceShellBootstrapLayer(
          child: FeatureFlags.useSwipeableShell
              ? _buildSwipeBody(tabs)
              : _LazyIndexedStack(
                  index: idx,
                  children: [for (final t in tabs) t.page],
                ),
        ),
        bottomNavigationBar: WorkspaceBottomNav(
          tabs: tabs,
          currentIndex: idx,
          onTap: c.setIndex,
        ),
      );
    });
  }
}

// ============================================================================
// WORKSPACE BOTTOM NAV — Enterprise flat navbar (unificado para TODOS los
// workspaces: admin / owner / renter / provider / insurer / legal / advisor).
// ----------------------------------------------------------------------------
// Diseño plano, integrado al sistema. Sin cápsula flotante, sin sombras.
// Inspiración: Linear / Stripe / Ramp / Notion Mobile / Uber Driver.
// - Fondo sólido alineado a colorScheme.surface.
// - Hairline superior 0.5px como única separación visual.
// - Indicador activo: pill sutil detrás del ícono (primary @ ~12%) +
//   ícono filled + label semibold. Sin barra superior (evita doble indicador).
// - SafeArea inferior interna (bottom only) para no fragmentar el layout.
//
// DATA-DRIVEN: las tabs (íconos, labels, activeIcon, navLabel) vienen del
// `WorkspaceConfig` correspondiente. El widget no conoce roles ni hardcodea
// items; cada workspace declara su contenido y el shell renderiza el mismo
// componente visual.
// ============================================================================

class WorkspaceBottomNav extends StatelessWidget {
  final List<WorkspaceTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const WorkspaceBottomNav({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.6),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                Expanded(
                  child: _NavTab(
                    tab: tabs[i],
                    isActive: currentIndex == i,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// NAV BAR ITEM — Item individual con animaciones y accesibilidad
// ============================================================================

// ============================================================================
// LAZY INDEXED STACK — Construcción diferida de tabs
// ============================================================================
// Reemplaza IndexedStack para evitar construir todos los tabs al montar el shell.
// Un tab solo se construye la primera vez que el usuario lo selecciona.
// Una vez construido, se mantiene vivo (state preservado) vía IndexedStack interno.
// Esto evita que controllers/streams/sync de tabs no visitados se disparen al arranque.

class _LazyIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const _LazyIndexedStack({required this.index, required this.children});

  @override
  State<_LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<_LazyIndexedStack> {
  /// Conjunto de índices que ya fueron visitados al menos una vez.
  /// El tab 0 (Inicio) siempre se construye desde el arranque.
  late final Set<int> _activated = {widget.index};

  @override
  void didUpdateWidget(_LazyIndexedStack old) {
    super.didUpdateWidget(old);
    // Marcar el nuevo índice como activado si es la primera visita.
    _activated.add(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      children: [
        for (int i = 0; i < widget.children.length; i++)
          if (_activated.contains(i))
            widget.children[i]
          else
            const SizedBox.shrink(),
      ],
    );
  }
}

// ============================================================================
// KEEP ALIVE TAB — Preserva estado de la tab cuando sale del viewport
// ----------------------------------------------------------------------------
// Wrapper trivial usado SÓLO por el path `FeatureFlags.useSwipeableShell`.
// Sin este mixin, `PageView` puede descartar la `State` de la página cuando
// queda fuera de su cache window — eso rehace `initState`, vuelve a llamar
// `loadInitial()` en Mi Red, resetea scroll, etc.
//
// REGLA CRÍTICA: `wantKeepAlive => true` no basta; el `build` debe llamar
// `super.build(context)` para que el mixin registre el keep-alive con el
// SliverChildBuilderDelegate de PageView. Olvidarlo es el bug clásico.
// ============================================================================

class _KeepAliveTab extends StatefulWidget {
  final Widget child;

  const _KeepAliveTab({required this.child});

  @override
  State<_KeepAliveTab> createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab>
    with AutomaticKeepAliveClientMixin<_KeepAliveTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

// ============================================================================
// NAV TAB — Item individual plano, enterprise
// ----------------------------------------------------------------------------
// - Estado inactivo: ícono outlined gris medio + label w500.
// - Estado activo: pill sutil detrás del ícono (primary @ 12%) + ícono filled
//   color primario + label w600.
// - El pill envuelve SÓLO al ícono (no toda la celda). Tamaño contenido,
//   padding horizontal moderado, bordes muy redondeados.
// - Sin barra superior, sin glow, sin sombras, sin gradientes.
// - Transiciones cortas (180ms) y discretas: sólo color de fondo del pill.
//   La altura de la fila se mantiene estable porque el padding del pill es
//   constante; sólo cambia el color (transparent ↔ tint) → cero jitter de
//   layout entre tabs y al alternar selección.
// - Arquitectura preparada para badges (dot/contador) sin romper limpieza.
// ============================================================================

class _NavTab extends StatelessWidget {
  final WorkspaceTab tab;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTab({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    const inactiveColor = Color(0xFF6B7280);
    final color = isActive ? activeColor : inactiveColor;

    // Pill tint: derivado del primary del tema, opacidad baja para mantener
    // tono enterprise. ~12% sobre superficies claras, evita ruido visual.
    final pillColor =
        isActive ? activeColor.withValues(alpha: 0.12) : Colors.transparent;

    final label = tab.bottomNavLabel;

    return Semantics(
      selected: isActive,
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          splashColor: activeColor.withValues(alpha: 0.06),
          highlightColor: activeColor.withValues(alpha: 0.04),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // PILL INDICATOR: fondo sutil alrededor del ícono activo.
                // Padding constante para que la altura de la fila sea
                // independiente del estado (no salta al cambiar de tab).
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: pillColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    tab.iconFor(isActive: isActive),
                    size: 22,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.0,
                    letterSpacing: 0.1,
                    color: color,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
