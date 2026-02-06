// lib/core/theme/app_theme.dart
// ============================================================================
// App Theme — Material 3 (Light/Dark)
// ============================================================================
// Objetivo:
// - Material 3 verdadero (useMaterial3 + ColorScheme.fromSeed)
// - CERO deuda técnica: NO llamar buildLightTheme() desde buildDarkTheme()
// - Un solo “pipeline” de construcción con helpers compartidos
// - Mantener tus decisiones actuales (NavigationBar + BottomNavigationBar + etc.)
// ============================================================================

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Entry points
ThemeData buildLightTheme() => _buildTheme(brightness: Brightness.light);
ThemeData buildDarkTheme() => _buildTheme(brightness: Brightness.dark);

/// Single source of truth for both themes.
ThemeData _buildTheme({required Brightness brightness}) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.seed,
    brightness: brightness,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    visualDensity: VisualDensity.standard,
  );

  // Shared component theming (same shape/sizing rules for both, colors come from ColorScheme)
  final inputDecorationTheme = _buildInputDecorationTheme(colorScheme);
  final elevatedButtonTheme = _buildElevatedButtonTheme();
  final filledButtonTheme = _buildFilledButtonTheme();
  final outlinedButtonTheme = _buildOutlinedButtonTheme();
  final tabBarTheme = _buildTabBarTheme(colorScheme);
  final cardTheme = _buildCardTheme(colorScheme);
  final chipTheme = _buildChipTheme(base, colorScheme);
  final listTileTheme = _buildListTileTheme(colorScheme);

  return base.copyWith(
    textTheme: buildTextTheme(base.textTheme),

    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: true,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.secondaryContainer,
      iconTheme: WidgetStatePropertyAll(
        IconThemeData(color: colorScheme.onSurface),
      ),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(color: colorScheme.onSurface),
      ),
    ),

    // Nota: estás usando ambos (NavigationBarThemeData + BottomNavigationBarThemeData).
    // Se respeta tu configuración actual.
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface.withValues(
        alpha: brightness == Brightness.light ? 0.6 : 0.7,
      ),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),

    tabBarTheme: tabBarTheme,
    cardTheme: cardTheme,
    inputDecorationTheme: inputDecorationTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    filledButtonTheme: filledButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    chipTheme: chipTheme,
    listTileTheme: listTileTheme,
    dividerColor: colorScheme.outlineVariant,
  );
}

// ============================================================================
// HELPERS (shared for Light/Dark)
// ============================================================================

InputDecorationTheme _buildInputDecorationTheme(ColorScheme cs) {
  return InputDecorationTheme(
    filled: true,
    fillColor: cs.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: cs.outlineVariant),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: cs.outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: cs.primary, width: 1.2),
    ),
    labelStyle: TextStyle(color: cs.onSurfaceVariant),
    hintStyle: TextStyle(color: cs.onSurfaceVariant),
  );
}

ElevatedButtonThemeData _buildElevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

FilledButtonThemeData _buildFilledButtonTheme() {
  return FilledButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

OutlinedButtonThemeData _buildOutlinedButtonTheme() {
  return OutlinedButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

TabBarTheme _buildTabBarTheme(ColorScheme cs) {
  return TabBarTheme(
    indicatorColor: cs.primary,
    labelColor: cs.primary,
    unselectedLabelColor: cs.onSurface.withValues(alpha: 0.7),
  );
}

CardTheme _buildCardTheme(ColorScheme cs) {
  return CardTheme(
    color: cs.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

ChipThemeData _buildChipTheme(ThemeData base, ColorScheme cs) {
  return base.chipTheme.copyWith(
    color: WidgetStatePropertyAll(cs.secondaryContainer),
    labelStyle: TextStyle(color: cs.onSecondaryContainer),
    shape: StadiumBorder(side: BorderSide(color: cs.outlineVariant)),
  );
}

ListTileThemeData _buildListTileTheme(ColorScheme cs) {
  return ListTileThemeData(
    iconColor: cs.onSurface,
    textColor: cs.onSurface,
    selectedColor: cs.primary,
  );
}
