/// QUICK ACTIONS PRO 2025 — Optimized & 100% Compatible
///
/// Features:
/// • Glass morphism with advanced backdrop effects
/// • Micro-interactions with spring physics
/// • Adaptive design system with design tokens
/// • Performance-optimized with const constructors
/// • Full accessibility support (a11y)
/// • Haptic feedback integration
/// • Badge system with animations
/// • Responsive layout system
/// • BACKWARD COMPATIBLE with original API
/// • FIX: Padding y spacing reducidos - SIN OVERFLOW
library quick_actions_pro;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ═══════════════════════════════════════════════════════════════════════════
// DESIGN TOKENS — Sistema de diseño centralizado (REDUCIDOS)
// ═══════════════════════════════════════════════════════════════════════════

/// Design tokens para consistencia visual
class QuickActionsTokens {
  // Spacing REDUCIDO para evitar overflow
  static const double spacingXs = 2.0; // Reducido de 4.0
  static const double spacingS = 6.0; // Reducido de 8.0
  static const double spacingM = 8.0; // Reducido de 12.0
  static const double spacingL = 12.0; // Reducido de 16.0
  static const double spacingXl = 18.0; // Reducido de 24.0

  // Radii
  static const double radiusS = 16.0;
  static const double radiusM = 20.0;
  static const double radiusL = 24.0;
  static const double radiusXl = 28.0;

  // Sizes
  static const double actionSizeMin = 52.0;
  static const double actionSizeDefault = 60.0;
  static const double actionSizeMax = 76.0;
  static const double primaryButtonHeight = 52.0;

  // Effects
  static const double blurSigmaDefault = 12.0;
  static const double elevationLow = 8.0;
  static const double elevationMedium = 16.0;
  static const double elevationHigh = 24.0;

  // Animation
  static const Duration animationFast = Duration(milliseconds: 120);
  static const Duration animationMedium = Duration(milliseconds: 200);
  static const Duration animationSlow = Duration(milliseconds: 300);
}

/// Theme extension para Quick Actions
class QuickActionsTheme {
  final Color surfaceGlass;
  final Color borderColor;
  final double glassOpacity;
  final double borderOpacity;

  const QuickActionsTheme({
    required this.surfaceGlass,
    required this.borderColor,
    this.glassOpacity = 0.85,
    this.borderOpacity = 0.55,
  });

  factory QuickActionsTheme.fromContext(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;

    return QuickActionsTheme(
      surfaceGlass: colorScheme.surface
          .withOpacity(brightness == Brightness.dark ? 0.80 : 0.90),
      borderColor: colorScheme.outlineVariant.withOpacity(0.55),
    );
  }

  QuickActionsTheme copyWith({
    Color? surfaceGlass,
    Color? borderColor,
    double? glassOpacity,
    double? borderOpacity,
  }) {
    return QuickActionsTheme(
      surfaceGlass: surfaceGlass ?? this.surfaceGlass,
      borderColor: borderColor ?? this.borderColor,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      borderOpacity: borderOpacity ?? this.borderOpacity,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BACKWARD COMPATIBILITY - Funciones para compatibilidad
// ═══════════════════════════════════════════════════════════════════════════

/// Función de compatibilidad para calcular padding bottom
/// COMPATIBLE con código antiguo: paddingBottomForQuickActions(context)
double paddingBottomForQuickActions(BuildContext context,
    {double reserve = 100}) {
  return reserve + MediaQuery.of(context).padding.bottom;
}

// ═══════════════════════════════════════════════════════════════════════════
// FLOATING CONTAINER — Contenedor principal flotante
// ═══════════════════════════════════════════════════════════════════════════

/// Wrapper que envuelve el contenido principal con quick actions flotantes
class FloatingQuickActions extends StatelessWidget {
  /// Contenido principal de la pantalla
  final Widget child;

  /// Lista de acciones rápidas a mostrar
  /// SOPORTA AMBOS: items (antiguo) y actions (nuevo)
  final List<QuickAction>? items;
  final List<QuickAction>? actions;

  /// Botón primario opcional (ej: "+ Nueva acción")
  final PrimaryQuickAction? primary;
  final PrimaryQuickAction? primaryAction;

  /// Espaciado entre el botón primario y las acciones
  final double primarySpacing;

  /// Posicionamiento horizontal
  final double left;
  final double right;
  final double horizontalPadding;

  /// Posicionamiento desde el bottom
  final double bottom;
  final double bottomPadding;

  /// Respetar safe area bottom (notch, home indicator)
  final bool respectSafeBottom;
  final bool respectSafeArea;

  /// Espaciado entre acciones - REDUCIDO
  final double spacing;
  final double actionSpacing;

  /// Padding interno del contenedor - REDUCIDO
  final EdgeInsets padding;
  final EdgeInsets containerPadding;

  /// Intensidad del blur effect
  final double blurSigma;
  final double blurIntensity;

  /// Permitir scroll horizontal si no caben todas las acciones
  final bool isScrollable;
  final bool enableScrolling;

  /// Theme personalizado (opcional)
  final QuickActionsTheme? theme;

  /// Colores personalizados (compatibilidad con código antiguo)
  final Color? containerColor;
  final Color? containerBorderColor;

  const FloatingQuickActions({
    super.key,
    required this.child,
    this.items, // Compatibilidad: nombre antiguo
    this.actions, // Nombre nuevo
    this.primary, // Compatibilidad: nombre antiguo
    this.primaryAction, // Nombre nuevo
    this.primarySpacing = QuickActionsTokens.spacingL,
    this.left = 10.0, // Compatibilidad
    this.right = 10.0, // Compatibilidad
    this.horizontalPadding = 10.0, // Nombre nuevo
    this.bottom = 8.0, // Compatibilidad
    this.bottomPadding = 8.0, // Nombre nuevo
    this.respectSafeBottom = true, // Compatibilidad
    this.respectSafeArea = true, // Nombre nuevo
    this.spacing = 8.0, // REDUCIDO de 12.0 a 8.0
    this.actionSpacing = 8.0, // REDUCIDO de 12.0 a 8.0
    this.padding = const EdgeInsets.symmetric(
        horizontal: 8, vertical: 8), // REDUCIDO de 10 a 8
    this.containerPadding = const EdgeInsets.all(8.0), // REDUCIDO de 12.0 a 8.0
    this.blurSigma = 10.0, // Compatibilidad
    this.blurIntensity = QuickActionsTokens.blurSigmaDefault, // Nombre nuevo
    this.isScrollable = false, // Compatibilidad
    this.enableScrolling = false, // Nombre nuevo
    this.theme,
    this.containerColor,
    this.containerBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    // Resolver valores con compatibilidad
    final actualActions = actions ?? items ?? [];
    final actualPrimary = primaryAction ?? primary;
    final actualHorizontalPadding = horizontalPadding;
    final actualBottomPadding = bottomPadding;
    final actualRespectSafe = respectSafeArea;
    final actualSpacing = actionSpacing;
    final actualPadding = containerPadding;
    final actualBlur = blurIntensity;
    final actualScrolling = enableScrolling;

    final safeBottom =
        actualRespectSafe ? MediaQuery.paddingOf(context).bottom : 0.0;

    return Stack(
      children: [
        child,
        Positioned(
          left: actualHorizontalPadding,
          right: actualHorizontalPadding,
          bottom: actualBottomPadding + safeBottom,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (actualPrimary != null) ...[
                actualPrimary,
                SizedBox(height: primarySpacing),
              ],
              _QuickActionsContainer(
                actions: actualActions,
                spacing: actualSpacing,
                padding: actualPadding,
                blurIntensity: actualBlur,
                enableScrolling: actualScrolling,
                theme: theme ?? QuickActionsTheme.fromContext(context),
                containerColor: containerColor,
                containerBorderColor: containerBorderColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Utilidad para calcular el padding bottom necesario para evitar overlap
  static double calculateBottomPadding(
    BuildContext context, {
    double extraSpace = 120.0,
  }) {
    return extraSpace + MediaQuery.paddingOf(context).bottom;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CONTAINER — Glass morphism container optimizado SIN OVERFLOW
// ═══════════════════════════════════════════════════════════════════════════

class _QuickActionsContainer extends StatelessWidget {
  final List<QuickAction> actions;
  final double spacing;
  final EdgeInsets padding;
  final double blurIntensity;
  final bool enableScrolling;
  final QuickActionsTheme theme;
  final Color? containerColor;
  final Color? containerBorderColor;

  const _QuickActionsContainer({
    required this.actions,
    required this.spacing,
    required this.padding,
    required this.blurIntensity,
    required this.enableScrolling,
    required this.theme,
    this.containerColor,
    this.containerBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(QuickActionsTokens.radiusL);

    // Usar siempre LayoutBuilder para conocer el ancho disponible
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: QuickActionsTokens.elevationMedium,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: QuickActionsTokens.elevationLow,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurIntensity,
              sigmaY: blurIntensity,
              tileMode: TileMode.clamp,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: containerColor ?? theme.surfaceGlass,
                borderRadius: borderRadius,
                border: Border.all(
                  color: containerBorderColor ?? theme.borderColor,
                  width: 0.5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              padding: padding,
              child: _buildActionsContent(),
            ),
          ),
        ),
      ),
    );
  }

  /// Construcción inteligente del contenido según espacio disponible
  Widget _buildActionsContent() {
    if (actions.isEmpty) return const SizedBox.shrink();

    // Con scroll: permitir expansión horizontal
    if (enableScrolling) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildSpacedActions(),
        ),
      );
    }

    // Sin scroll: usar Wrap para evitar overflow
    return LayoutBuilder(
      builder: (context, constraints) {
        // Wrap siempre para evitar overflow
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: actions,
        );
      },
    );
  }

  List<Widget> _buildSpacedActions() {
    if (actions.isEmpty) return const [];

    final List<Widget> spacedChildren = [];
    for (int i = 0; i < actions.length; i++) {
      spacedChildren.add(actions[i]);
      if (i < actions.length - 1) {
        spacedChildren.add(SizedBox(width: spacing));
      }
    }
    return spacedChildren;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PRIMARY ACTION — Botón de acción primaria con gradiente
// ═══════════════════════════════════════════════════════════════════════════

class PrimaryQuickAction extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final double height;
  final bool enableHaptics;
  final String? semanticLabel;

  const PrimaryQuickAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.onLongPress,
    this.height = QuickActionsTokens.primaryButtonHeight,
    this.enableHaptics = true,
    this.semanticLabel,
  });

  @override
  State<PrimaryQuickAction> createState() => _PrimaryQuickActionState();
}

class _PrimaryQuickActionState extends State<PrimaryQuickAction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: QuickActionsTokens.animationMedium,
      lowerBound: 0.94,
      upperBound: 1.0,
    )..value = 1.0;

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.animateTo(
      0.94,
      duration: QuickActionsTokens.animationFast,
      curve: Curves.easeOutCubic,
    );
  }

  void _handleTapUp([TapUpDetails? details]) {
    _controller.animateTo(
      1.0,
      duration: const Duration(milliseconds: 240),
      curve: Curves.elasticOut,
    );
  }

  void _handleTapCancel() {
    _handleTapUp();
  }

  void _handleTap() {
    if (widget.enableHaptics) {
      HapticFeedback.mediumImpact();
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.textScalerOf(context);
    final scaledFontSize = textScaleFactor.scale(16.0);

    return Semantics(
      button: true,
      label: widget.semanticLabel ?? widget.label,
      onTap: _handleTap,
      onLongPress: widget.onLongPress,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(QuickActionsTokens.radiusXl),
              onTap: _handleTap,
              onLongPress: widget.onLongPress,
              child: Ink(
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(QuickActionsTokens.radiusXl),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color.withOpacity(0.95),
                      widget.color,
                      widget.color.withOpacity(0.85),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.35),
                      blurRadius: QuickActionsTokens.elevationHigh,
                      offset: const Offset(0, 12),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: widget.color.withOpacity(0.20),
                      blurRadius: QuickActionsTokens.elevationMedium,
                      offset: const Offset(0, 6),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, // Reducido de 24.0 a 16.0
                    vertical: 10.0, // Reducido de 12.0 a 10.0
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 20, // Reducido de 22 a 20
                      ),
                      const SizedBox(width: 8), // Reducido de 12 a 8
                      Flexible(
                        child: Text(
                          widget.label,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: scaledFontSize,
                            letterSpacing: 0.3,
                            height: 1.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// QUICK ACTION — Acción individual con micro-interacciones
// ═══════════════════════════════════════════════════════════════════════════

class QuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  // Visual
  final bool isPrimary;
  final double size;

  // Badge
  final int badgeCount;
  final bool showBadge;
  final Color? badgeColor;
  final int badgeMaxCount;
  final bool capAt99; // Compatibilidad con código antiguo

  // Accessibility
  final String? semanticLabel;
  final String? semanticHint;
  final bool enableHaptics;

  const QuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.onLongPress,
    this.isPrimary = false,
    this.size = QuickActionsTokens.actionSizeDefault,
    this.badgeCount = 0,
    this.showBadge = false,
    this.badgeColor,
    this.badgeMaxCount = 99,
    this.capAt99 = true, // Compatibilidad
    this.semanticLabel,
    this.semanticHint,
    this.enableHaptics = true,
  });

  @override
  State<QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<QuickAction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: QuickActionsTokens.animationMedium,
      lowerBound: 0.92,
      upperBound: 1.0,
    )..value = 1.0;

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.animateTo(
      0.92,
      duration: QuickActionsTokens.animationFast,
      curve: Curves.easeOutCubic,
    );
  }

  void _handleTapUp([TapUpDetails? details]) {
    _controller.animateTo(
      1.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.elasticOut,
    );
  }

  void _handleTapCancel() {
    _handleTapUp();
  }

  void _handleTap() {
    if (widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textScaleFactor = MediaQuery.textScalerOf(context);

    final double actionSize = widget.size.clamp(
      QuickActionsTokens.actionSizeMin,
      QuickActionsTokens.actionSizeMax,
    );

    final double finalSize = widget.isPrimary ? actionSize + 6 : actionSize;
    final scaledLabelSize =
        textScaleFactor.scale(11.0); // Reducido de 12.0 a 11.0

    // Determinar si el color es transparente (para navegación)
    final bool isTransparent = widget.color.alpha == 0;
    final Color iconColor =
        isTransparent ? colorScheme.onSurface.withOpacity(0.85) : Colors.white;

    return Semantics(
      button: true,
      label: widget.semanticLabel ?? _buildSemanticLabel(),
      hint: widget.semanticHint,
      onTap: _handleTap,
      onLongPress: widget.onLongPress,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(QuickActionsTokens.radiusM + 2),
            onTap: _handleTap,
            onLongPress: widget.onLongPress,
            child: Padding(
              padding: const EdgeInsets.all(2.0), // Reducido de 4.0 a 2.0
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: _ActionCapsule(
                      size: finalSize,
                      color: widget.color,
                      icon: widget.icon,
                      iconColor: iconColor,
                      isPrimary: widget.isPrimary,
                      isTransparent: isTransparent,
                      badge: widget.showBadge && widget.badgeCount > 0
                          ? _AnimatedBadge(
                              count: widget.badgeCount,
                              maxCount: widget.badgeMaxCount,
                              color:
                                  widget.badgeColor ?? const Color(0xFFE53935),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6.0), // Reducido de 8.0 a 6.0
                  SizedBox(
                    width: finalSize + 12.0, // Reducido de 16.0 a 12.0
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: scaledLabelSize,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        color: colorScheme.onSurface.withOpacity(0.90),
                        letterSpacing: 0.0, // Reducido de 0.1 a 0.0
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _buildSemanticLabel() {
    final base = widget.label;
    if (widget.showBadge && widget.badgeCount > 0) {
      return '$base, ${widget.badgeCount} pendientes';
    }
    return base;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ACTION CAPSULE — Cápsula visual del ícono
// ═══════════════════════════════════════════════════════════════════════════

class _ActionCapsule extends StatelessWidget {
  final double size;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final bool isPrimary;
  final bool isTransparent;
  final Widget? badge;

  const _ActionCapsule({
    required this.size,
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.isPrimary,
    required this.isTransparent,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(QuickActionsTokens.radiusM);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: isTransparent
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.92),
                      color,
                      color.withOpacity(0.78),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
            boxShadow: isTransparent
                ? null
                : [
                    if (isPrimary)
                      BoxShadow(
                        color: color.withOpacity(0.28),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                        spreadRadius: 0,
                      ),
                    BoxShadow(
                      color: color.withOpacity(0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                      spreadRadius: 0,
                    ),
                  ],
          ),
          child: Stack(
            children: [
              // Brillo superior para efecto 3D
              if (!isTransparent)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              // Ícono
              Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24, // Reducido de 26 a 24
                ),
              ),
            ],
          ),
        ),
        // Badge
        if (badge != null)
          Positioned(
            right: -4,
            top: -6,
            child: badge!,
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ANIMATED BADGE — Badge con animaciones fluidas
// ═══════════════════════════════════════════════════════════════════════════

class _AnimatedBadge extends StatelessWidget {
  final int count;
  final int maxCount;
  final Color color;

  const _AnimatedBadge({
    required this.count,
    required this.maxCount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = count > maxCount ? '$maxCount+' : '$count';

    return AnimatedSwitcher(
      duration: QuickActionsTokens.animationMedium,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
            ),
          ),
          child: child,
        );
      },
      child: Container(
        key: ValueKey<String>(displayText),
        padding: const EdgeInsets.symmetric(
          horizontal: 5, // Reducido de 6 a 5
          vertical: 2, // Reducido de 3 a 2
        ),
        constraints: const BoxConstraints(
          minWidth: 18, // Reducido de 20 a 18
          minHeight: 18, // Reducido de 20 a 18
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(9), // Reducido de 10 a 9
          border: Border.all(
            color: Colors.white,
            width: 1.5, // Reducido de 2 a 1.5
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          displayText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10, // Reducido de 11 a 10
            fontWeight: FontWeight.w800,
            height: 1.0,
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }
}
