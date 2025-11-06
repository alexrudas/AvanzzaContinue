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

import '../tokens/typography_tokens.dart';

/// Tipografía de la aplicación basada en Material 3 Type Scale.
/// NOTA: Los colores NO se definen aquí, se heredan de Theme.of(context).colorScheme.
abstract class AppTypography {
  AppTypography._();

  /// Familia de fuente por defecto.
  ///
  /// Roboto está incluida por defecto en Flutter y NO requiere registro en pubspec.yaml.
  /// Si se cambia a una fuente custom (ej: 'Inter', 'Poppins'), se debe:
  /// 1. Descargar los archivos .ttf y colocarlos en assets/fonts/
  /// 2. Registrar en pubspec.yaml:
  ///    flutter:
  ///      fonts:
  ///        - family: [NombreFuente]
  ///          fonts:
  ///            - asset: assets/fonts/[NombreFuente]-Regular.ttf
  ///            - asset: assets/fonts/[NombreFuente]-Medium.ttf
  ///              weight: 500
  ///            - asset: assets/fonts/[NombreFuente]-Bold.ttf
  ///              weight: 700
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
          letterSpacing:
              LetterSpacingTokens.normal, // Eliminar tracking negativo
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

  // ========== NUMBER TYPOGRAPHY: Estilos optimizados para números ==========
  // Diseñados para valores monetarios, KPIs y contadores destacados.
  // Uso recomendado:
  //   - numberSM: badges, chips, subtotales compactos
  //   - numberMD: totales secundarios y KPIs en cards
  //   - numberLG: totales principales en secciones
  //   - numberXL: valores monetarios principales ($450.000)
  //   - numberXXL: números hero, contadores destacados
  //   - numberXXXL: valores extremadamente destacados (dashboard, analytics)
  //
  // Acceso vía NumberTypographyExtension:
  //   Theme.of(context).extension<NumberTypographyExtension>()?.numberXL

  /// Número small: para badges, chips y subtotales compactos
  static const TextStyle numberSM = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 14.0,
    fontWeight: FontWeightTokens.semiBold,
    height: 1.2,
    letterSpacing: -0.1,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Número medium: para totales secundarios y KPIs en cards
  static const TextStyle numberMD = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 20.0,
    fontWeight: FontWeightTokens.semiBold,
    height: 1.2,
    letterSpacing: -0.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Número large: para totales principales dentro de secciones
  static const TextStyle numberLG = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 28.0,
    fontWeight: FontWeightTokens.bold,
    height: 1.15,
    letterSpacing: -0.3,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Número extra-large: valores monetarios destacados y KPIs importantes
  static const TextStyle numberXL = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 40.0,
    fontWeight: FontWeightTokens.bold,
    height: 1.2,
    letterSpacing: -0.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Número extra-extra-large: contadores hero y valores muy destacados
  static const TextStyle numberXXL = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 56.0,
    fontWeight: FontWeightTokens.bold,
    height: 1.1,
    letterSpacing: -1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Número extra-extra-extra-large: dashboard analytics y métricas críticas
  static const TextStyle numberXXXL = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 72.0,
    fontWeight: FontWeightTokens.bold,
    height: 1.0,
    letterSpacing: -1.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
