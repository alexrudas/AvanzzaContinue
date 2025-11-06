import 'package:flutter/material.dart';

/// Breakpoints responsivos del proyecto (Material Design 3)
class Breakpoints {
  Breakpoints._();

  static const double xs = 360.0; // Teléfonos muy pequeños
  static const double sm = 600.0; // Teléfonos normales
  static const double md = 840.0; // Tablets pequeñas
  static const double lg = 1200.0; // Tablets / Desktop
  static const double xl = 1600.0; // Desktop grande
}

/// Sistema unificado de tamaños de íconos PRO 2025
/// Principio: todas las variantes contextuales derivan de la escala base
class IconSizesPro {
  IconSizesPro._();

  // Escala base
  static const double xs = 12.0;
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double normal = 24.0; // baseline Material
  static const double lg = 32.0;
  static const double xl = 40.0;
  static const double xxl = 48.0;

  // Contextuales (derivadas)
  static const double buttonSmall = sm;
  static const double buttonNormal = md;
  static const double buttonLarge = normal;

  static const double chip = sm;

  static const double avatarSmall = md;
  static const double avatarMedium = normal;
  static const double avatarLarge = lg;

  static const double listTileLeading = normal;

  /// 28.0 derivado entre normal (24) y lg (32)
  static const double cardHeader = (normal + lg) / 2;

  static const double appBarAction = normal;
  static const double navigationBar = normal;
  static const double navigationDrawer = normal;

  static const double fab = normal;
  static const double fabLarge = 36.0; // spec FAB extendido

  static const double emptyState = xl;
  static const double errorState = 56.0;
  static const double successState = 56.0;

  static const double kpiSmall = 18.0;
  static const double kpiMedium = 22.0;
  static const double kpiLarge = cardHeader;
  static const double dashboardMetric = normal;

  // Helpers
  static double scale(double multiplier) {
    assert(multiplier > 0, 'IconSizesPro.scale: multiplier debe ser > 0');
    return normal * multiplier;
  }

  static double fromString(String size) {
    final key = size.toLowerCase().trim();
    switch (key) {
      case 'xs':
      case 'extra-small':
        return xs;
      case 'sm':
      case 'small':
        return sm;
      case 'md':
      case 'medium':
        return md;
      case 'normal':
      case 'default':
        return normal;
      case 'lg':
      case 'large':
        return lg;
      case 'xl':
      case 'extra-large':
        return xl;
      case 'xxl':
      case '2x':
        return xxl;
      default:
        assert(
            false,
            'IconSizesPro.fromString: descriptor desconocido "$key". '
            'Usando "normal" como fallback.');
        return normal;
    }
  }

  // Responsive
  static double forScreenWidth(double width) {
    if (width < Breakpoints.xs) return sm;
    if (width < Breakpoints.sm) return md;
    if (width < Breakpoints.md) return normal;
    if (width < Breakpoints.lg) return lg;
    return xl;
  }

  static double forBreakpoint(BuildContext context) =>
      forScreenWidth(MediaQuery.of(context).size.width);
}

/// IconTheme helpers para ThemeData
class AppIconTheme {
  AppIconTheme._();

  static IconThemeData base({double size = IconSizesPro.normal, Color? color}) {
    return IconThemeData(size: size, color: color);
  }

  static IconThemeData small({Color? color}) =>
      base(size: IconSizesPro.sm, color: color);

  static IconThemeData normal({Color? color}) =>
      base(size: IconSizesPro.normal, color: color);

  static IconThemeData large({Color? color}) =>
      base(size: IconSizesPro.lg, color: color);
}

/// Widget helper semántico
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  const AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  // Escala base
  const AppIcon.xs(this.icon, {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.xs;
  const AppIcon.sm(this.icon, {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.sm;
  const AppIcon.md(this.icon, {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.md;
  const AppIcon.normal(this.icon, {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.normal;
  const AppIcon.lg(this.icon, {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.lg;
  const AppIcon.xl(this.icon, {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.xl;
  const AppIcon.xxl(this.icon, {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.xxl;

  // Contextuales
  const AppIcon.button(this.icon, {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.buttonNormal;
  const AppIcon.fab(this.icon, {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.fab;
  const AppIcon.chip(this.icon, {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.chip;
  const AppIcon.kpi(this.icon, {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.kpiMedium;
  const AppIcon.cardHeader(this.icon,
      {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.cardHeader;
  const AppIcon.emptyState(this.icon,
      {super.key, this.color, this.semanticLabel})
      : size = IconSizesPro.emptyState;

  @override
  Widget build(BuildContext context) {
    assert(size == null || (size! > 0 && size!.isFinite),
        'AppIcon.size debe ser > 0 y finito');
    // Recomendación de accesibilidad:
    // - Íconos interactivos >= 40px o envolver en SizedBox 44x44 para touch target.
    return Icon(
      icon,
      size: size ?? IconSizesPro.normal,
      color: color,
      semanticLabel: semanticLabel,
    );
  }
}
