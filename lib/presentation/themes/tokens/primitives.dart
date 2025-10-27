// ============================================================================
// tokens/primitives.dart
// ============================================================================
//
// QUÉ ES:
//   Define los tokens de diseño primitivos (colores base, espaciado, radios,
//   breakpoints). Estos valores son la base atómica del design system y NO
//   dependen de contexto de tema claro/oscuro.
//
// DÓNDE SE IMPORTA:
//   - foundations/design_system.dart (DS expone estos valores)
//   - foundations/color_schemes.dart (usa colores base para generar ColorScheme)
//   - Componentes que necesiten acceso directo a primitivas
//
// QUÉ NO HACE:
//   - NO contiene ThemeData ni widgets
//   - NO tiene lógica de estado ni theming dinámico
//   - NO incluye colores semánticos (success, warning, info) → ver semantic.dart
//   - NO importa design_system.dart (relación unidireccional)
//
// USO ESPERADO:
//   // Consumo recomendado vía DS wrapper (ver design_system.dart)
//   final color = DS.colors.primary;
//   final spacing = DS.spacing.md;
//
//   // Acceso directo solo en contextos de configuración
//   import 'package:avanzza/presentation/themes/tokens/primitives.dart';
//   final primaryColor = ColorPrimitives.primary;
//
// ============================================================================

import 'package:flutter/material.dart';

/// Colores primitivos base del sistema.
/// Estos son los colores "semilla" desde los cuales se derivan paletas completas.
/// IMPORTANTE: El color primary debe ser consistente en todo el módulo.
abstract class ColorPrimitives {
  // Prevenir instanciación
  ColorPrimitives._();

  /// Color primario del brand (azul corporativo Avanzza).
  /// Este valor se usa como semilla para ColorScheme.fromSeed() en light/dark.
  /// CONGELADO: 0xFF1E88E5 (Material Blue 600) - NO cambiar sin revisión completa.
  static const Color primary = Color(0xFF1E88E5);

  /// Color secundario (acento complementario al primario).
  static const Color secondary = Color(0xFF388E3C); // Material Green 700

  /// Color terciario (acento adicional para variedad visual).
  static const Color tertiary = Color(0xFFFF6F00); // Material Orange 900

  /// Escala de grises neutral (usado para texto, bordes, fondos).
  static const Color neutral100 = Color(0xFFFAFAFA);
  static const Color neutral200 = Color(0xFFF5F5F5);
  static const Color neutral300 = Color(0xFFEEEEEE);
  static const Color neutral400 = Color(0xFFE0E0E0);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  /// Color para estados de error (destructivos, validaciones fallidas).
  static const Color error = Color(0xFFD32F2F); // Material Red 700
}

/// Escala de espaciado base (en logical pixels).
/// Sigue progresión visual armónica: 4, 8, 12, 16, 24, 32, 48, 64.
abstract class SpacingPrimitives {
  SpacingPrimitives._();

  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  /// Lista completa para iteración programática si se necesita.
  static const List<double> scale = [xxs, xs, sm, md, lg, xl, xxl, xxxl];
}

/// Radios de borde (border radius) para esquinas redondeadas.
/// Solo valores numéricos puros. Para BorderRadius helpers, ver DS en design_system.dart.
abstract class RadiusPrimitives {
  RadiusPrimitives._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;

  /// Radio "infinito" para crear bordes completamente circulares (ej: pills).
  static const double full = 999.0;
}

/// Breakpoints para diseño responsive.
/// Alineados con Material 3 (2025): mobile < 600, tablet < 840, desktop ≥ 1280.
/// Valores en logical pixels (dp).
abstract class BreakpointPrimitives {
  BreakpointPrimitives._();

  /// Móvil: 0 - 599 dp (típicamente smartphones en portrait).
  static const double mobile = 600.0;

  /// Tablet: 600 - 839 dp (tablets pequeñas, landscape phones).
  static const double tablet = 840.0;

  /// Desktop: 1280+ dp (tablets grandes en landscape, laptops, monitores).
  static const double desktop = 1280.0;

  /// Helper: determinar breakpoint actual dado un ancho.
  /// Uso: final bp = BreakpointPrimitives.fromWidth(MediaQuery.of(context).size.width);
  static BreakpointType fromWidth(double width) {
    if (width < mobile) return BreakpointType.mobile;
    if (width < tablet) return BreakpointType.tablet;
    return BreakpointType.desktop;
  }
}

/// Enum para tipo de breakpoint (facilita switch/case).
enum BreakpointType { mobile, tablet, desktop }
