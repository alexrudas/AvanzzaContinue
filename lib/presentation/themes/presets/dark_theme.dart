// ============================================================================
// presets/dark_theme.dart
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

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: AppColorSchemes.dark,
  textTheme: AppTypography.textTheme,
  extensions: const [
    CustomThemeExtension.dark,
    AppChartTheme.dark,
  ],

  // Transitions & Loading
  pageTransitionsTheme: AppPageTransitions.theme,
  progressIndicatorTheme: AppLoadingThemes.progressIndicator(AppColorSchemes.dark),

  elevatedButtonTheme: AppButtonThemes.elevatedButton(AppColorSchemes.dark),
  textButtonTheme: AppButtonThemes.textButton(AppColorSchemes.dark),
  outlinedButtonTheme: AppButtonThemes.outlinedButton(AppColorSchemes.dark),
  filledButtonTheme: AppButtonThemes.filledButton(AppColorSchemes.dark),
  iconButtonTheme: AppButtonThemes.iconButton(AppColorSchemes.dark),

  inputDecorationTheme: AppInputThemes.inputDecoration(AppColorSchemes.dark),
  cardTheme: AppCardThemes.card(AppColorSchemes.dark),

  appBarTheme: AppNavigationThemes.appBar(AppColorSchemes.dark),
  bottomNavigationBarTheme: AppNavigationThemes.bottomNavigationBar(AppColorSchemes.dark),
  navigationRailTheme: AppNavigationThemes.navigationRail(AppColorSchemes.dark),
  drawerTheme: AppNavigationThemes.drawer(AppColorSchemes.dark),

  bottomSheetTheme: AppSurfaceThemes.bottomSheet(AppColorSchemes.dark),
  dialogTheme: AppSurfaceThemes.dialog(AppColorSchemes.dark),
  snackBarTheme: AppSurfaceThemes.snackBar(AppColorSchemes.dark),
  tooltipTheme: AppSurfaceThemes.tooltip(AppColorSchemes.dark),
);
