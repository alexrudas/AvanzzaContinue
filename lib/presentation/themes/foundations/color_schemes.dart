// ============================================================================
// foundations/color_schemes.dart
// ============================================================================
//
// QUÉ ES:
//   Define ColorScheme de Material 3 para light, dark y high contrast.
//   Usa ColorScheme.fromSeed() con el color primary de primitivas para generar
//   paletas completas y armónicas con surface tints.
//
// DÓNDE SE IMPORTA:
//   - presets/light_theme.dart, dark_theme.dart, high_contrast_theme.dart
//   - foundations/design_system.dart (DS.colors expone ColorScheme activo)
//
// QUÉ NO HACE:
//   - NO contiene ThemeData completo (esos están en presets/)
//   - NO incluye colores semánticos custom (success, warning, info → ver semantic.dart)
//   - NO tiene lógica de detección de tema del sistema
//
// USO ESPERADO:
//   // En presets/
//   import 'package:avanzza/presentation/themes/foundations/color_schemes.dart';
//   ThemeData(
//     colorScheme: AppColorSchemes.light,
//   )
//
//   // En widgets (runtime)
//   final scheme = Theme.of(context).colorScheme;
//   Container(color: scheme.primary)
//
//   // NOTA: surfaceContainer* (surfaceContainerLowest, surfaceContainerHigh, etc.)
//   //       solo están disponibles en Flutter 3.22+. Si usas SDK anterior, evita usarlos.
//
// ============================================================================

import 'package:flutter/material.dart';
import '../tokens/primitives.dart';

/// Esquemas de color de Material 3 basados en ColorPrimitives.primary (0xFF1E88E5).
/// IMPORTANTE: Todos los esquemas usan el mismo color seed para consistencia.
abstract class AppColorSchemes {
  AppColorSchemes._();

  /// ColorScheme light (tema claro estándar).
  /// Generado con ColorScheme.fromSeed() usando primary como semilla.
  /// Surface tints automáticos para elevación progresiva según Material 3.
  static final ColorScheme light = ColorScheme.fromSeed(
    seedColor: ColorPrimitives.primary,
    brightness: Brightness.light,
    // M3 usa surface tints por defecto, no es necesario especificar manualmente.
    // Containers, surfaces y backgrounds se calculan automáticamente.
  );

  /// ColorScheme dark (tema oscuro estándar).
  /// Generado con ColorScheme.fromSeed() usando primary como semilla.
  /// Surface tints y elevación tonal ajustados para fondo oscuro.
  static final ColorScheme dark = ColorScheme.fromSeed(
    seedColor: ColorPrimitives.primary,
    brightness: Brightness.dark,
    // M3 dark tiene surface tints más sutiles y mayor contraste en on* colors.
  );

  /// ColorScheme high contrast light (accesibilidad).
  /// Mayor contraste entre foreground/background, sin transparencias sutiles.
  /// Basado en light pero con ajustes manuales para WCAG AAA.
  static final ColorScheme highContrastLight = ColorScheme.fromSeed(
    seedColor: ColorPrimitives.primary,
    brightness: Brightness.light,
    // Override para mayor contraste (opcional, ajustar según WCAG)
    primary: ColorPrimitives.primary,
    onPrimary: Colors.white,
    secondary: ColorPrimitives.secondary,
    onSecondary: Colors.white,
    error: ColorPrimitives.error,
    onError: Colors.white,
    // Surface con mayor contraste (menos tints)
    surface: Colors.white,
    onSurface: Colors.black,
  );

  /// ColorScheme high contrast dark (accesibilidad en oscuro).
  /// Mayor contraste para usuarios con baja visión en modo oscuro.
  static final ColorScheme highContrastDark = ColorScheme.fromSeed(
    seedColor: ColorPrimitives.primary,
    brightness: Brightness.dark,
    // Override para mayor contraste en dark mode
    primary: ColorPrimitives.primary,
    onPrimary: Colors.white, // Blanco sobre tonos saturados en dark
    secondary: ColorPrimitives.secondary,
    onSecondary: Colors.white, // Blanco sobre secondary saturado
    error: ColorPrimitives.error,
    onError: Colors.white, // Blanco sobre error para máximo contraste
    // Surface con mayor contraste
    surface: const Color(0xFF121212), // Dark surface estándar
    onSurface: Colors.white,
  );

  /// Helper: Obtener ColorScheme por ThemeMode y contraste.
  /// Uso: AppColorSchemes.fromMode(ThemeMode.light, highContrast: false)
  static ColorScheme fromMode(ThemeMode mode, {bool highContrast = false}) {
    if (highContrast) {
      return mode == ThemeMode.dark ? highContrastDark : highContrastLight;
    }
    return mode == ThemeMode.dark ? dark : light;
  }
}

/// Extensión para acceder a colores custom adicionales desde ColorScheme.
/// NOTA: Para colores semánticos (success, warning, info), usar SemanticColors
/// o agregar como ThemeExtension (ver theme_extensions.dart).
extension ColorSchemeExtras on ColorScheme {
  /// Surface containers con elevación progresiva (M3 tonal elevation).
  /// Ya provistos por M3: surfaceContainerLowest, surfaceContainer, surfaceContainerHigh, etc.
  /// Acceder directamente: colorScheme.surfaceContainer

  /// Dividers y borders sutiles.
  Color get divider => onSurface.withValues(alpha: 0.12);

  /// Overlay para estados hover (8% del onSurface).
  Color get hoverOverlay => onSurface.withValues(alpha: 0.08);

  /// Overlay para estados pressed (12% del onSurface).
  Color get pressedOverlay => onSurface.withValues(alpha: 0.12);

  /// Overlay para estados disabled (38% del onSurface).
  Color get disabledOverlay => onSurface.withValues(alpha: 0.38);
}
