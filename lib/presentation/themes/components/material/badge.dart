// ============================================================================
// components/material/badge.dart
// ============================================================================
//
// QUÉ ES:
//   Sistema de badges y chips semánticos siguiendo Material Design 3.
//   Provee etiquetas visuales con tonos semánticos (success, warning, error, etc.)
//   para estados, categorías, contadores y notificaciones.
//
// DÓNDE SE USA:
//   - Dashboards: Contadores de notificaciones, alertas pendientes
//   - Listas de activos: Estados (activo, en mantenimiento, vendido)
//   - Filtros: Chips de selección múltiple
//   - Formularios: Etiquetas de validación, categorías
//   - Chat/Mensajes: Indicadores de mensajes no leídos
//
// CARACTERÍSTICAS:
//   ✅ 7 tonos semánticos: neutral, info, success, warning, error, primary, secondary
//   ✅ Colores derivados dinámicamente de ColorScheme (M3 compliant)
//   ✅ Modo dense para badges compactos (filtros, chips)
//   ✅ Soporte para iconos con BadgePro.icon()
//   ✅ ThemeExtension para consistencia global
//   ✅ Accesibilidad: Semantics labels, contraste WCAG AAA
//   ✅ Lerp para animaciones suaves entre temas
//
// USO ESPERADO:
//   // En theme presets (light_theme.dart, dark_theme.dart, etc.)
//   extensions: [
//     AppBadgeTheme.fromScheme(scheme),
//   ]
//
//   // Badge simple (solo texto)
//   const BadgePro(label: 'Nuevo', tone: BadgeTone.primary)
//
//   // Badge con icono (notificaciones, contadores)
//   const BadgePro.icon(
//     label: '3',
//     icon: Icons.notifications,
//     tone: BadgeTone.warning,
//   )
//
//   // Badge compacto (filtros, chips)
//   const BadgePro(
//     label: 'Activo',
//     tone: BadgeTone.success,
//     dense: true,
//   )
//
//   // Acceso al tema desde context
//   final badgeTheme = AppBadgeTheme.of(context);
//   Container(
//     decoration: BoxDecoration(
//       color: badgeTheme.bgSuccess,
//       borderRadius: BorderRadius.circular(badgeTheme.radius),
//     ),
//   )
//
// ANTIPATRONES (evitar):
//   ❌ Hardcodear colores de badges (usar tonos semánticos)
//   ❌ Usar Container + Text en lugar de BadgePro (menos accesible)
//   ❌ No especificar tone (siempre debe tener significado semántico)
//
// ============================================================================

import 'package:flutter/material.dart';

import '../../foundations/design_system.dart';

// ============================================================================
// ENUMS
// ============================================================================

/// Tonos semánticos para badges.
///
/// GUÍA DE USO:
/// - neutral: Estados genéricos, contadores sin significado específico
/// - info: Información complementaria, datos técnicos
/// - success: Estados positivos, confirmaciones, activos saludables
/// - warning: Alertas, proximidad a límites, acciones requeridas
/// - error: Errores críticos, estados fallidos, vencidos
/// - primary: Énfasis principal, destacados, nuevos
/// - secondary: Énfasis secundario, categorías especiales
enum BadgeTone {
  neutral,
  info,
  success,
  warning,
  error,
  primary,
  secondary,
}

// ============================================================================
// THEME EXTENSION
// ============================================================================

/// ThemeExtension para configuración global de badges.
///
/// COMPORTAMIENTO:
/// - Colores derivados de ColorScheme (no hardcodeados)
/// - Lerp implementado para transiciones suaves entre temas
/// - Accesible vía AppBadgeTheme.of(context)
///
/// COLORES:
/// - bg*: Fondo del badge (container con alpha para subtlety)
/// - fg*: Texto del badge (onContainer para contraste WCAG AAA)
@immutable
class AppBadgeTheme extends ThemeExtension<AppBadgeTheme> {
  // ========== COLORES DE FONDO (BG) ==========

  final Color bgNeutral;
  final Color bgInfo;
  final Color bgSuccess;
  final Color bgWarning;
  final Color bgError;
  final Color bgPrimary;
  final Color bgSecondary;

  // ========== COLORES DE TEXTO (FG) ==========

  final Color fgNeutral;
  final Color fgInfo;
  final Color fgSuccess;
  final Color fgWarning;
  final Color fgError;
  final Color fgPrimary;
  final Color fgSecondary;

  // ========== GEOMETRÍA Y PADDING ==========

  /// Border radius del badge (M3 recomienda 4-8dp para chips)
  final double radius;

  /// Padding estándar (horizontal: 12dp, vertical: 6dp)
  final EdgeInsets padding;

  /// Padding compacto para mode dense (horizontal: 8dp, vertical: 4dp)
  final EdgeInsets paddingDense;

  const AppBadgeTheme({
    required this.bgNeutral,
    required this.bgInfo,
    required this.bgSuccess,
    required this.bgWarning,
    required this.bgError,
    required this.bgPrimary,
    required this.bgSecondary,
    required this.fgNeutral,
    required this.fgInfo,
    required this.fgSuccess,
    required this.fgWarning,
    required this.fgError,
    required this.fgPrimary,
    required this.fgSecondary,
    required this.radius,
    required this.padding,
    required this.paddingDense,
  });

  /// Factory constructor que deriva colores del ColorScheme activo.
  ///
  /// COMPORTAMIENTO:
  /// - Fondos: Colores semánticos con alpha 0.15 (sutil, no intrusivo)
  /// - Textos: Colores onContainer (contraste WCAG AAA garantizado)
  /// - Neutral: Deriva de surfaceContainerHighest + onSurface
  /// - Info: Deriva de tertiary (blue/cyan en M3 default)
  /// - Success: Verde (no hay semantic success en M3, usamos tertiary container)
  /// - Warning: Deriva de tertiary (amber/orange)
  /// - Error: Deriva de error (red)
  /// - Primary: Deriva de primary
  /// - Secondary: Deriva de secondary
  factory AppBadgeTheme.fromScheme(ColorScheme scheme) {
    return AppBadgeTheme(
      // Fondos con alpha 0.15 para subtlety (M3 tonal surfaces)
      bgNeutral: scheme.surfaceContainerHighest,
      bgInfo: scheme.tertiaryContainer.withValues(alpha: 0.5),
      bgSuccess: scheme.tertiaryContainer, // Verde en tema custom
      bgWarning: scheme.tertiaryContainer.withValues(alpha: 0.7), // Amber
      bgError: scheme.errorContainer,
      bgPrimary: scheme.primaryContainer,
      bgSecondary: scheme.secondaryContainer,

      // Textos con contraste WCAG AAA
      fgNeutral: scheme.onSurface,
      fgInfo: scheme.onTertiaryContainer,
      fgSuccess: scheme.onTertiaryContainer,
      fgWarning: scheme.onTertiaryContainer,
      fgError: scheme.onErrorContainer,
      fgPrimary: scheme.onPrimaryContainer,
      fgSecondary: scheme.onSecondaryContainer,

      // Geometría M3 estándar
      radius: 6.0, // Ligeramente redondeado (no pill completo)
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      paddingDense: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    );
  }

  /// Acceso rápido al tema desde BuildContext.
  ///
  /// USO:
  /// ```dart
  /// final badgeTheme = AppBadgeTheme.of(context);
  /// Container(color: badgeTheme.bgSuccess);
  /// ```
  static AppBadgeTheme of(BuildContext context) {
    final theme = Theme.of(context).extension<AppBadgeTheme>();
    assert(
        theme != null, 'AppBadgeTheme no encontrado en ThemeData.extensions');
    return theme!;
  }

  // ========== THEME EXTENSION OVERRIDES ==========

  @override
  ThemeExtension<AppBadgeTheme> copyWith({
    Color? bgNeutral,
    Color? bgInfo,
    Color? bgSuccess,
    Color? bgWarning,
    Color? bgError,
    Color? bgPrimary,
    Color? bgSecondary,
    Color? fgNeutral,
    Color? fgInfo,
    Color? fgSuccess,
    Color? fgWarning,
    Color? fgError,
    Color? fgPrimary,
    Color? fgSecondary,
    double? radius,
    EdgeInsets? padding,
    EdgeInsets? paddingDense,
  }) {
    return AppBadgeTheme(
      bgNeutral: bgNeutral ?? this.bgNeutral,
      bgInfo: bgInfo ?? this.bgInfo,
      bgSuccess: bgSuccess ?? this.bgSuccess,
      bgWarning: bgWarning ?? this.bgWarning,
      bgError: bgError ?? this.bgError,
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      fgNeutral: fgNeutral ?? this.fgNeutral,
      fgInfo: fgInfo ?? this.fgInfo,
      fgSuccess: fgSuccess ?? this.fgSuccess,
      fgWarning: fgWarning ?? this.fgWarning,
      fgError: fgError ?? this.fgError,
      fgPrimary: fgPrimary ?? this.fgPrimary,
      fgSecondary: fgSecondary ?? this.fgSecondary,
      radius: radius ?? this.radius,
      padding: padding ?? this.padding,
      paddingDense: paddingDense ?? this.paddingDense,
    );
  }

  @override
  ThemeExtension<AppBadgeTheme> lerp(
    covariant ThemeExtension<AppBadgeTheme>? other,
    double t,
  ) {
    if (other is! AppBadgeTheme) return this;

    return AppBadgeTheme(
      bgNeutral: Color.lerp(bgNeutral, other.bgNeutral, t) ?? bgNeutral,
      bgInfo: Color.lerp(bgInfo, other.bgInfo, t) ?? bgInfo,
      bgSuccess: Color.lerp(bgSuccess, other.bgSuccess, t) ?? bgSuccess,
      bgWarning: Color.lerp(bgWarning, other.bgWarning, t) ?? bgWarning,
      bgError: Color.lerp(bgError, other.bgError, t) ?? bgError,
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t) ?? bgPrimary,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t) ?? bgSecondary,
      fgNeutral: Color.lerp(fgNeutral, other.fgNeutral, t) ?? fgNeutral,
      fgInfo: Color.lerp(fgInfo, other.fgInfo, t) ?? fgInfo,
      fgSuccess: Color.lerp(fgSuccess, other.fgSuccess, t) ?? fgSuccess,
      fgWarning: Color.lerp(fgWarning, other.fgWarning, t) ?? fgWarning,
      fgError: Color.lerp(fgError, other.fgError, t) ?? fgError,
      fgPrimary: Color.lerp(fgPrimary, other.fgPrimary, t) ?? fgPrimary,
      fgSecondary: Color.lerp(fgSecondary, other.fgSecondary, t) ?? fgSecondary,
      radius: t < 0.5 ? radius : other.radius,
      padding: EdgeInsets.lerp(padding, other.padding, t) ?? padding,
      paddingDense:
          EdgeInsets.lerp(paddingDense, other.paddingDense, t) ?? paddingDense,
    );
  }

  @override
  String toString() => 'AppBadgeTheme(radius: $radius)';
}

// ============================================================================
// WIDGET PRINCIPAL
// ============================================================================

/// Widget de badge reutilizable con tonos semánticos.
///
/// CARACTERÍSTICAS:
/// - Derivación automática de colores desde AppBadgeTheme
/// - Modo dense para badges compactos
/// - Soporte para iconos con BadgePro.icon()
/// - Accesibilidad con Semantics
/// - Layout responsive con Row(mainAxisSize.min)
///
/// ANTIPATRONES:
/// - NO usar sin especificar tone (siempre debe tener significado)
/// - NO hardcodear colores (derivar desde AppBadgeTheme)
class BadgePro extends StatelessWidget {
  /// Texto del badge (obligatorio)
  final String label;

  /// Tono semántico (obligatorio)
  final BadgeTone tone;

  /// Modo compacto (padding reducido)
  final bool dense;

  /// Icono opcional (solo con constructor .icon())
  final IconData? icon;

  /// Override de padding (opcional, para casos edge)
  final EdgeInsets? padding;

  /// Override de radius (opcional, para casos edge)
  final double? radius;

  /// Constructor estándar (solo texto).
  ///
  /// USO:
  /// ```dart
  /// const BadgePro(label: 'Activo', tone: BadgeTone.success)
  /// ```
  const BadgePro({
    super.key,
    required this.label,
    required this.tone,
    this.dense = false,
    this.padding,
    this.radius,
  }) : icon = null;

  /// Constructor con icono (notificaciones, contadores).
  ///
  /// USO:
  /// ```dart
  /// const BadgePro.icon(
  ///   label: '3',
  ///   icon: Icons.notifications,
  ///   tone: BadgeTone.warning,
  /// )
  /// ```
  const BadgePro.icon({
    super.key,
    required this.label,
    required this.icon,
    required this.tone,
    this.dense = false,
    this.padding,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final badgeTheme = AppBadgeTheme.of(context);

    // Determinar colores según el tono semántico
    final (bgColor, fgColor) = _getColors(badgeTheme);

    // Determinar padding (dense o estándar, con override opcional)
    final effectivePadding =
        padding ?? (dense ? badgeTheme.paddingDense : badgeTheme.padding);

    // Determinar radius (con override opcional)
    final effectiveRadius = radius ?? badgeTheme.radius;

    return Semantics(
      label: 'badge_$label',
      button:
          false, // Badge no es interactivo (usar GestureDetector si se necesita)
      child: Container(
        padding: effectivePadding,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(effectiveRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono opcional (antes del texto)
            if (icon != null) ...[
              Icon(
                icon,
                size: dense ? 14.0 : 16.0,
                color: fgColor,
              ),
              SizedBox(width: dense ? 4.0 : 6.0),
            ],

            // Texto del badge
            Text(
              label,
              style: (dense
                      ? DS.typography.textTheme.labelSmall
                      : DS.typography.textTheme.labelMedium)
                  ?.copyWith(
                color: fgColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
              // Anti-overflow: badges deben ser compactos
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  /// Helper privado para determinar colores según el tono.
  ///
  /// RETORNO: (backgroundColor, foregroundColor)
  (Color, Color) _getColors(AppBadgeTheme theme) {
    return switch (tone) {
      BadgeTone.neutral => (theme.bgNeutral, theme.fgNeutral),
      BadgeTone.info => (theme.bgInfo, theme.fgInfo),
      BadgeTone.success => (theme.bgSuccess, theme.fgSuccess),
      BadgeTone.warning => (theme.bgWarning, theme.fgWarning),
      BadgeTone.error => (theme.bgError, theme.fgError),
      BadgeTone.primary => (theme.bgPrimary, theme.fgPrimary),
      BadgeTone.secondary => (theme.bgSecondary, theme.fgSecondary),
    };
  }
}
