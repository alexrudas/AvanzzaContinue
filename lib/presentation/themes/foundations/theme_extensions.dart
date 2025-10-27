// ============================================================================
// foundations/theme_extensions.dart
// ============================================================================
//
// QUÉ ES:
//   ThemeExtension custom para valores fuera de ColorScheme/TextTheme M3.
//
// DÓNDE SE IMPORTA:
//   - presets/ (OBLIGATORIO: registrar en cada theme)
//   - foundations/design_system.dart (DS.ext helper)
//
// USO ESPERADO:
//   // Registro OBLIGATORIO en presets/:
//   // light_theme.dart: extensions: const [CustomThemeExtension.light]
//   // dark_theme.dart: extensions: const [CustomThemeExtension.dark]
//   // high_contrast_theme.dart: extensions: const [CustomThemeExtension.highContrast]
//
//   // Uso via DS
//   final ext = DS.ext(context);
//   Container(decoration: BoxDecoration(gradient: ext.primaryGradient))
//
//   // TODO: Derivar gradientes desde Theme.of(context).colorScheme.primary cuando actives dynamic color.
//   // CUIDADO: Si usas accentShadow/softShadow, pon elevation: 0 en Card/Material.
//
// ============================================================================

import 'package:flutter/material.dart';
import '../tokens/primitives.dart';

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
  ThemeExtension<CustomThemeExtension> copyWith({
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
  ThemeExtension<CustomThemeExtension> lerp(
    covariant ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) return this;
    return CustomThemeExtension(
      primaryGradient: Gradient.lerp(primaryGradient, other.primaryGradient, t) ?? primaryGradient,
      accentGradient: Gradient.lerp(accentGradient, other.accentGradient, t) ?? accentGradient,
      accentShadow: BoxShadow.lerpList(accentShadow, other.accentShadow, t) ?? accentShadow,
      softShadow: BoxShadow.lerpList(softShadow, other.softShadow, t) ?? softShadow,
    );
  }
}
