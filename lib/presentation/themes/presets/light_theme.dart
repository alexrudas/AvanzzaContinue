// ============================================================================
// presets/light_theme.dart
// ============================================================================
//
// QUÉ ES:
//   ThemeData completo para tema light (Material 3).
//
// DÓNDE SE IMPORTA:
//   - main.dart o MaterialApp.theme
//
// USO ESPERADO:
//   MaterialApp(theme: lightTheme, themeMode: ThemeMode.light)
//
// ============================================================================

import 'package:flutter/material.dart';
import '../foundations/color_schemes.dart';
import '../foundations/typography.dart';
import '../foundations/theme_extensions.dart';
import '../components/chart/chart_theme.dart';
import '../components/animation/page_transitions.dart';
import '../components/custom/loading_theme.dart';
import '../components/material/buttons.dart';
import '../components/material/inputs.dart';
import '../components/material/cards.dart';
import '../components/material/navigation.dart';
import '../components/material/surfaces.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: AppColorSchemes.light,
  textTheme: AppTypography.textTheme,
  extensions: const [
    CustomThemeExtension.light,
    AppChartTheme.light,
  ],

  // Transitions & Loading
  pageTransitionsTheme: AppPageTransitions.theme,
  progressIndicatorTheme: AppLoadingThemes.progressIndicator(AppColorSchemes.light),

  // Buttons
  elevatedButtonTheme: AppButtonThemes.elevatedButton(AppColorSchemes.light),
  textButtonTheme: AppButtonThemes.textButton(AppColorSchemes.light),
  outlinedButtonTheme: AppButtonThemes.outlinedButton(AppColorSchemes.light),
  filledButtonTheme: AppButtonThemes.filledButton(AppColorSchemes.light),
  iconButtonTheme: AppButtonThemes.iconButton(AppColorSchemes.light),

  // Inputs
  inputDecorationTheme: AppInputThemes.inputDecoration(AppColorSchemes.light),

  // Cards
  cardTheme: AppCardThemes.card(AppColorSchemes.light),

  // Navigation
  appBarTheme: AppNavigationThemes.appBar(AppColorSchemes.light),
  bottomNavigationBarTheme: AppNavigationThemes.bottomNavigationBar(AppColorSchemes.light),
  navigationRailTheme: AppNavigationThemes.navigationRail(AppColorSchemes.light),
  drawerTheme: AppNavigationThemes.drawer(AppColorSchemes.light),

  // Surfaces
  bottomSheetTheme: AppSurfaceThemes.bottomSheet(AppColorSchemes.light),
  dialogTheme: AppSurfaceThemes.dialog(AppColorSchemes.light),
  snackBarTheme: AppSurfaceThemes.snackBar(AppColorSchemes.light),
  tooltipTheme: AppSurfaceThemes.tooltip(AppColorSchemes.light),
);
