import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.seed,
    brightness: Brightness.light,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    visualDensity: VisualDensity.standard,
  );
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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: colorScheme.primary,
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.7),
    ),
    cardTheme: CardTheme(
      color: colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.2),
      ),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      color: WidgetStatePropertyAll(colorScheme.secondaryContainer),
      labelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
      shape: StadiumBorder(side: BorderSide(color: colorScheme.outlineVariant)),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.onSurface,
      textColor: colorScheme.onSurface,
      selectedColor: colorScheme.primary,
    ),
    dividerColor: colorScheme.outlineVariant,
  );
}

ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.seed,
    brightness: Brightness.dark,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    visualDensity: VisualDensity.standard,
  );
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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.7),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    inputDecorationTheme: buildLightTheme().inputDecorationTheme,
    elevatedButtonTheme: buildLightTheme().elevatedButtonTheme,
    filledButtonTheme: buildLightTheme().filledButtonTheme,
    outlinedButtonTheme: buildLightTheme().outlinedButtonTheme,
    chipTheme: buildLightTheme().chipTheme,
    tabBarTheme: buildLightTheme().tabBarTheme,
    cardTheme: buildLightTheme().cardTheme,
    listTileTheme: buildLightTheme().listTileTheme,
    dividerColor: colorScheme.outlineVariant,
  );
}
