// ============================================================================
// foundations/theme_extensions.dart
// ============================================================================
//
// QUÉ ES:
//   ThemeExtension custom para valores fuera de ColorScheme/TextTheme M3.
//   Incluye tipografía numérica (SM/MD/LG/XL/XXL/XXXL) y recursos visuales.
//
// DÓNDE SE IMPORTA:
//   - presets/ (OBLIGATORIO: registrar en cada theme)
//   - foundations/design_system.dart (DS.ext helper)
//
// USO ESPERADO:
//   // Registro OBLIGATORIO en presets/:
//   // light_theme.dart:
//   //   extensions: const [
//   //     NumberTypographyExtension.base,
//   //     CustomThemeExtension.light,
//   //   ]
//   // dark_theme.dart:
//   //   extensions: const [
//   //     NumberTypographyExtension.base,
//   //     CustomThemeExtension.dark,
//   //   ]
//   // high_contrast_theme.dart:
//   //   extensions: const [
//   //     NumberTypographyExtension.base,
//   //     CustomThemeExtension.highContrast,
//   //   ]
//
//   // Uso vía Theme.of(context):
//   // final nums = Theme.of(context).extension<NumberTypographyExtension>();
//   // Text(monto, style: nums?.numberMD)
//
//   // CUIDADO: Si usas accentShadow/softShadow, pon elevation: 0 en Card/Material.
//
// ============================================================================

import 'package:flutter/material.dart';

import '../tokens/primitives.dart';
import 'typography.dart';

/// Extensión interna para manipulación de colores (darken).
/// Usado para generar gradientes dinámicos desde ColorScheme.
extension _ColorShade on Color {
  /// Oscurece el color en un porcentaje dado (0.0 - 1.0).
  /// Ejemplo: primary.darken(0.2) → 20% más oscuro.
  ///
  /// Usado en CustomThemeExtension.fromScheme() para derivar gradientes
  /// dinámicamente desde el ColorScheme (compatible con Dynamic Color).
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    final hsl = HSLColor.fromColor(this);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }
}

/// ThemeExtension para tipografía numérica global.
/// Expone tamaños S, M, L, XL, XXL y XXXL basados en AppTypography.
@immutable
class NumberTypographyExtension
    extends ThemeExtension<NumberTypographyExtension> {
  /// Números pequeños: badges, chips, subtotales compactos.
  final TextStyle numberSM;

  /// Números medianos: KPIs y totales secundarios en cards.
  final TextStyle numberMD;

  /// Números grandes: totales principales de sección.
  final TextStyle numberLG;

  /// Números extra grandes: valores monetarios destacados.
  final TextStyle numberXL;

  /// Números hero.
  final TextStyle numberXXL;

  /// Números extra hero para dashboards.
  final TextStyle numberXXXL;

  const NumberTypographyExtension({
    required this.numberSM,
    required this.numberMD,
    required this.numberLG,
    required this.numberXL,
    required this.numberXXL,
    required this.numberXXXL,
  });

  /// Preset base tomado de AppTypography.
  static const NumberTypographyExtension base = NumberTypographyExtension(
    numberSM: AppTypography.numberSM,
    numberMD: AppTypography.numberMD,
    numberLG: AppTypography.numberLG,
    numberXL: AppTypography.numberXL,
    numberXXL: AppTypography.numberXXL,
    numberXXXL: AppTypography.numberXXXL,
  );

  @override
  NumberTypographyExtension copyWith({
    TextStyle? numberSM,
    TextStyle? numberMD,
    TextStyle? numberLG,
    TextStyle? numberXL,
    TextStyle? numberXXL,
    TextStyle? numberXXXL,
  }) {
    return NumberTypographyExtension(
      numberSM: numberSM ?? this.numberSM,
      numberMD: numberMD ?? this.numberMD,
      numberLG: numberLG ?? this.numberLG,
      numberXL: numberXL ?? this.numberXL,
      numberXXL: numberXXL ?? this.numberXXL,
      numberXXXL: numberXXXL ?? this.numberXXXL,
    );
  }

  @override
  NumberTypographyExtension lerp(
    covariant ThemeExtension<NumberTypographyExtension>? other,
    double t,
  ) {
    if (other is! NumberTypographyExtension) return this;
    return NumberTypographyExtension(
      numberSM: TextStyle.lerp(numberSM, other.numberSM, t) ?? numberSM,
      numberMD: TextStyle.lerp(numberMD, other.numberMD, t) ?? numberMD,
      numberLG: TextStyle.lerp(numberLG, other.numberLG, t) ?? numberLG,
      numberXL: TextStyle.lerp(numberXL, other.numberXL, t) ?? numberXL,
      numberXXL: TextStyle.lerp(numberXXL, other.numberXXL, t) ?? numberXXL,
      numberXXXL: TextStyle.lerp(numberXXXL, other.numberXXXL, t) ?? numberXXXL,
    );
  }
}

/// Recursos visuales globales no cubiertos por ColorScheme/TextTheme.
/// Gradientes y sombras para acentos y superficies.
///
/// IMPORTANTE: Para compatibilidad con Dynamic Color (Android 12+), usar
/// la fábrica fromScheme() que genera gradientes desde ColorScheme en runtime.
@immutable
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Gradient primaryGradient;
  final Gradient accentGradient;
  final List<BoxShadow> accentShadow;
  final List<BoxShadow> softShadow;

  const CustomThemeExtension({
    required this.primaryGradient,
    required this.accentGradient,
    required this.accentShadow,
    required this.softShadow,
  });

  /// Fábrica para generar extensión desde ColorScheme (Dynamic Color compatible).
  /// Deriva gradientes dinámicamente desde scheme.primary y scheme.secondary.
  ///
  /// Uso en presets:
  /// ```dart
  /// extensions: [
  ///   CustomThemeExtension.fromScheme(AppColorSchemes.light),
  /// ]
  /// ```
  ///
  /// NOTA: Esta fábrica reemplaza los presets estáticos (light/dark/highContrast)
  /// cuando se active Dynamic Color. Por ahora, los presets estáticos siguen
  /// siendo el estándar para mantener consistencia visual del brand.
  factory CustomThemeExtension.fromScheme(
    ColorScheme scheme, {
    bool isHighContrast = false,
  }) {
    // High contrast elimina gradientes (colores sólidos para accesibilidad)
    if (isHighContrast) {
      return CustomThemeExtension(
        primaryGradient: LinearGradient(
          colors: [scheme.primary, scheme.primary],
        ),
        accentGradient: LinearGradient(
          colors: [scheme.secondary, scheme.secondary],
        ),
        accentShadow: const [
          BoxShadow(color: Color(0x80000000), offset: Offset(0, 2), blurRadius: 8),
        ],
        softShadow: const [],
      );
    }

    // Generar gradientes dinámicos para light/dark usando darken/lighten
    final isDark = scheme.brightness == Brightness.dark;

    return CustomThemeExtension(
      primaryGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [scheme.primary, scheme.primary.darken(0.15)]
            : [scheme.primary, scheme.primary.darken(0.10)],
      ),
      accentGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [scheme.secondary, scheme.secondary.darken(0.15)]
            : [scheme.secondary, scheme.secondary.darken(0.10)],
      ),
      accentShadow: isDark
          ? const [
              BoxShadow(color: Color(0x66000000), offset: Offset(0, 4), blurRadius: 12),
            ]
          : const [
              BoxShadow(color: Color(0x33000000), offset: Offset(0, 4), blurRadius: 12),
            ],
      softShadow: isDark
          ? const [
              BoxShadow(color: Color(0x1F000000), offset: Offset(0, 1), blurRadius: 3),
            ]
          : const [
              BoxShadow(color: Color(0x0F000000), offset: Offset(0, 1), blurRadius: 3),
            ],
    );
  }

  /// Preset estático light (mantiene consistencia con brand colors).
  /// Para Dynamic Color, usar CustomThemeExtension.fromScheme() en su lugar.
  static const CustomThemeExtension light = CustomThemeExtension(
    primaryGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorPrimitives.primary, Color(0xFF1565C0)],
    ),
    accentGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorPrimitives.secondary, Color(0xFF2E7D32)],
    ),
    accentShadow: [
      BoxShadow(color: Color(0x33000000), offset: Offset(0, 4), blurRadius: 12),
    ],
    softShadow: [
      BoxShadow(color: Color(0x0F000000), offset: Offset(0, 1), blurRadius: 3),
    ],
  );

  static const CustomThemeExtension dark = CustomThemeExtension(
    primaryGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorPrimitives.primary, Color(0xFF0D47A1)],
    ),
    accentGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorPrimitives.secondary, Color(0xFF1B5E20)],
    ),
    accentShadow: [
      BoxShadow(color: Color(0x66000000), offset: Offset(0, 4), blurRadius: 12),
    ],
    softShadow: [
      BoxShadow(color: Color(0x1F000000), offset: Offset(0, 1), blurRadius: 3),
    ],
  );

  static const CustomThemeExtension highContrast = CustomThemeExtension(
    primaryGradient: LinearGradient(
      colors: [ColorPrimitives.primary, ColorPrimitives.primary],
    ),
    accentGradient: LinearGradient(
      colors: [ColorPrimitives.secondary, ColorPrimitives.secondary],
    ),
    accentShadow: [
      BoxShadow(color: Color(0x80000000), offset: Offset(0, 2), blurRadius: 8),
    ],
    softShadow: [],
  );

  @override
  CustomThemeExtension copyWith({
    Gradient? primaryGradient,
    Gradient? accentGradient,
    List<BoxShadow>? accentShadow,
    List<BoxShadow>? softShadow,
  }) {
    return CustomThemeExtension(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      accentGradient: accentGradient ?? this.accentGradient,
      accentShadow: accentShadow ?? this.accentShadow,
      softShadow: softShadow ?? this.softShadow,
    );
  }

  @override
  CustomThemeExtension lerp(
    covariant ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) return this;
    return CustomThemeExtension(
      primaryGradient:
          Gradient.lerp(primaryGradient, other.primaryGradient, t) ??
              primaryGradient,
      accentGradient: Gradient.lerp(accentGradient, other.accentGradient, t) ??
          accentGradient,
      accentShadow: BoxShadow.lerpList(accentShadow, other.accentShadow, t) ??
          accentShadow,
      softShadow:
          BoxShadow.lerpList(softShadow, other.softShadow, t) ?? softShadow,
    );
  }
}
