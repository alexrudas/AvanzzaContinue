// ============================================================================
// tokens/typography.dart
// ============================================================================
//
// QUÉ ES:
//   Define la escala tipográfica base del sistema (tamaños, pesos, alturas de línea)
//   sin aplicar ThemeData. Estos son tokens puros para construir TextTheme después.
//
// DÓNDE SE IMPORTA:
//   - foundations/typography.dart (construye TextTheme M3 desde estos tokens)
//   - foundations/design_system.dart (DS.typography expone valores finales)
//
// QUÉ NO HACE:
//   - NO contiene TextTheme (ese está en foundations/typography.dart)
//   - NO tiene lógica de textScaleFactor ni MediaQuery
//   - NO incluye estilos específicos de componentes
//
// USO ESPERADO:
//   // Acceso directo a tokens (raro, mejor usar DS.typography)
//   import 'package:avanzza/presentation/themes/tokens/typography.dart';
//   final size = TypographyTokens.displayLargeSize;
//
//   // Consumo normal via TextTheme en presets/
//   Text('Título', style: Theme.of(context).textTheme.displayLarge)
//
// ============================================================================

import 'package:flutter/material.dart';

/// Tokens tipográficos base: tamaños de fuente en logical pixels.
/// Escala alineada con Material 3 Type Scale.
abstract class TypographyTokens {
  TypographyTokens._();

  // ========== Display (grandes títulos, headers de pantalla) ==========
  static const double displayLargeSize = 57.0;
  static const double displayMediumSize = 45.0;
  static const double displaySmallSize = 36.0;

  // ========== Headline (títulos de sección, h1-h3) ==========
  static const double headlineLargeSize = 32.0;
  static const double headlineMediumSize = 28.0;
  static const double headlineSmallSize = 24.0;

  // ========== Title (títulos de componentes, app bar, card headers) ==========
  static const double titleLargeSize = 22.0;
  static const double titleMediumSize = 16.0;
  static const double titleSmallSize = 14.0;

  // ========== Body (texto de cuerpo, párrafos, contenido principal) ==========
  static const double bodyLargeSize = 16.0;
  static const double bodyMediumSize = 14.0;
  static const double bodySmallSize = 12.0;

  // ========== Label (botones, tabs, chips, small UI elements) ==========
  static const double labelLargeSize = 14.0;
  static const double labelMediumSize = 12.0;
  static const double labelSmallSize = 11.0;
}

/// Pesos de fuente (font weights).
abstract class FontWeightTokens {
  FontWeightTokens._();

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

/// Altura de línea (line height) como multiplicadores.
/// Material 3 usa ratios en lugar de valores absolutos para escalabilidad.
abstract class LineHeightTokens {
  LineHeightTokens._();

  /// Line height compacto: 1.2x (para títulos grandes sin envolver).
  static const double tight = 1.2;

  /// Line height normal: 1.4x (para títulos medianos, labels).
  static const double normal = 1.4;

  /// Line height relajado: 1.5x (para body text, legibilidad óptima).
  static const double relaxed = 1.5;

  /// Line height amplio: 1.6x (para párrafos largos, accesibilidad).
  static const double loose = 1.6;
}

/// Espaciado entre letras (letter spacing) en logical pixels.
/// Material 3 usa tracking para mejorar legibilidad en diferentes tamaños.
abstract class LetterSpacingTokens {
  LetterSpacingTokens._();

  /// Tracking negativo: para display/headline grandes (óptica visual).
  static const double tight = -0.5;

  /// Tracking neutro: sin ajuste.
  static const double normal = 0.0;

  /// Tracking positivo mínimo: para body text pequeño.
  static const double loose = 0.25;

  /// Tracking positivo acentuado: para labels en uppercase.
  static const double wider = 0.5;
}
