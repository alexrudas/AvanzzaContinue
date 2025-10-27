// ============================================================================
// foundations/typography.dart
// ============================================================================
//
// QUÉ ES:
//   Construye TextTheme completo de Material 3 usando tokens tipográficos.
//   Incluye ajustes de peso, altura de línea, letter spacing por rol.
//
// DÓNDE SE IMPORTA:
//   - presets/light_theme.dart, dark_theme.dart, high_contrast_theme.dart
//   - foundations/design_system.dart (DS.typography expone TextTheme)
//
// QUÉ NO HACE:
//   - NO aplica colores (esos vienen de ColorScheme en runtime)
//   - NO ajusta textScaleFactor (eso es responsabilidad de MediaQuery en app)
//   - NO incluye estilos de componentes específicos (botones, inputs)
//
// USO ESPERADO:
//   // En presets/
//   import 'package:avanzza/presentation/themes/foundations/typography.dart';
//   ThemeData(
//     textTheme: AppTypography.textTheme,
//   )
//
//   // En widgets
//   Text('Título', style: Theme.of(context).textTheme.displayLarge)
//
//   // Vía DS
//   final theme = DS.typography.textTheme;
//   final highContrast = DS.typography.highContrast;
//
//   // IMPORTANTE: Registrar fuente en pubspec.yaml para evitar reflows:
//   // flutter:
//   //   fonts:
//   //     - family: Roboto
//   //       fonts:
//   //         - asset: assets/fonts/Roboto-Regular.ttf
//   //         - asset: assets/fonts/Roboto-Medium.ttf
//   //           weight: 500
//
//   // TODO: Añadir fallback por locale si usas árabe/japonés más adelante.
//   // TODO: Añadir pruebas golden con textScaler 1.0/1.2/1.4.
//
// ============================================================================

import 'package:flutter/material.dart';
import '../tokens/typography.dart';

/// Tipografía de la aplicación basada en Material 3 Type Scale.
/// NOTA: Los colores NO se definen aquí, se heredan de Theme.of(context).colorScheme.
abstract class AppTypography {
  AppTypography._();

  /// Familia de fuente por defecto.
  /// TODO: Reemplazar con fuente custom del brand si se requiere (ej: 'Inter', 'Poppins').
  static const String fontFamily = 'Roboto';

  /// Fallback fonts si fontFamily no está disponible (prevenir reflows).
  /// Orden: Roboto (Android), Helvetica (iOS), Arial (Windows), sans-serif (genérico).
  static const List<String> fontFamilyFallback = [
    'Roboto',
    'Helvetica',
    'Arial',
    'sans-serif'
  ];

  /// TextTheme completo con todos los roles de Material 3.
  /// Aplicar a ThemeData.textTheme en presets/.
  /// Expuesto vía DS.typography.textTheme para consumo global.
  static TextTheme get textTheme => const TextTheme(
        // ========== Display: Grandes títulos, hero text ==========
        displayLarge: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.displayLargeSize,
          fontWeight: FontWeightTokens.regular,
          height: LineHeightTokens.tight,
          letterSpacing: LetterSpacingTokens.tight,
        ),
        displayMedium: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.displayMediumSize,
          fontWeight: FontWeightTokens.regular,
          height: LineHeightTokens.tight,
          letterSpacing: LetterSpacingTokens.normal,
        ),
        displaySmall: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.displaySmallSize,
          fontWeight: FontWeightTokens.regular,
          height: LineHeightTokens.normal,
          letterSpacing: LetterSpacingTokens.normal,
        ),

        // ========== Headline: Títulos de sección (h1, h2, h3) ==========
        headlineLarge: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.headlineLargeSize,
          fontWeight: FontWeightTokens.regular,
          height: LineHeightTokens.normal,
          letterSpacing: LetterSpacingTokens.normal,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.headlineMediumSize,
          fontWeight: FontWeightTokens.regular,
          height: LineHeightTokens.normal,
          letterSpacing: LetterSpacingTokens.normal,
        ),
        headlineSmall: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.headlineSmallSize,
          fontWeight: FontWeightTokens.regular,
          height: LineHeightTokens.normal,
          letterSpacing: LetterSpacingTokens.normal,
        ),

        // ========== Title: Títulos de componentes (AppBar, Card header) ==========
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.titleLargeSize,
          fontWeight: FontWeightTokens.medium,
          height: LineHeightTokens.normal,
          letterSpacing: LetterSpacingTokens.normal,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.titleMediumSize,
          fontWeight: FontWeightTokens.medium,
          height: LineHeightTokens.relaxed,
          letterSpacing: LetterSpacingTokens.loose,
        ),
        titleSmall: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.titleSmallSize,
          fontWeight: FontWeightTokens.medium,
          height: LineHeightTokens.relaxed,
          letterSpacing: LetterSpacingTokens.loose,
        ),

        // ========== Body: Texto de párrafo, contenido principal ==========
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.bodyLargeSize,
          fontWeight: FontWeightTokens.regular,
          height: LineHeightTokens.relaxed,
          letterSpacing: LetterSpacingTokens.loose,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.bodyMediumSize,
          fontWeight: FontWeightTokens.regular,
          height: LineHeightTokens.relaxed,
          letterSpacing: LetterSpacingTokens.loose,
        ),
        bodySmall: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.bodySmallSize,
          fontWeight: FontWeightTokens.regular,
          height: LineHeightTokens.relaxed,
          letterSpacing: LetterSpacingTokens.normal,
        ),

        // ========== Label: Botones, tabs, chips ==========
        labelLarge: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.labelLargeSize,
          fontWeight: FontWeightTokens.medium,
          height: LineHeightTokens.normal,
          letterSpacing: LetterSpacingTokens.loose,
        ),
        labelMedium: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.labelMediumSize,
          fontWeight: FontWeightTokens.medium,
          height: LineHeightTokens.normal,
          letterSpacing: LetterSpacingTokens.wider,
        ),
        labelSmall: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: TypographyTokens.labelSmallSize,
          fontWeight: FontWeightTokens.medium,
          height: LineHeightTokens.normal,
          letterSpacing: LetterSpacingTokens.wider,
        ),
      );

  /// TextTheme optimizado para high contrast (mayor peso, sin letter spacing negativo).
  /// Usado en high_contrast_theme.dart para accesibilidad.
  /// Expuesto vía DS.typography.highContrast para consumo directo.
  static TextTheme get highContrastTextTheme => textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          fontWeight: FontWeightTokens.medium,
          letterSpacing: LetterSpacingTokens.normal, // Eliminar tracking negativo
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          fontWeight: FontWeightTokens.medium,
        ),
        displaySmall: textTheme.displaySmall?.copyWith(
          fontWeight: FontWeightTokens.medium,
        ),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeightTokens.medium,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeightTokens.medium,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeightTokens.semiBold,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeightTokens.semiBold,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeightTokens.semiBold,
        ),
        titleSmall: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeightTokens.semiBold,
        ),
      );
}
