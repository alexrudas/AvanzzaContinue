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
import '../components/material/badge.dart';
import '../components/material/navigation.dart';
import '../components/material/surfaces.dart';
import '../components/material/icon_sizes_pro.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: AppColorSchemes.dark,
  textTheme: AppTypography.textTheme,

  // Global icon theme
  iconTheme: AppIconTheme.normal(color: AppColorSchemes.dark.onSurface),

  extensions: [
    CustomThemeExtension.dark,
    AppChartTheme.dark,
    NumberTypographyExtension.base,
    AppBadgeTheme.fromScheme(AppColorSchemes.dark),
  ],

  // Transitions & Loading
  pageTransitionsTheme: AppPageTransitions.theme,
  progressIndicatorTheme:
      AppLoadingThemes.progressIndicator(AppColorSchemes.dark),

  elevatedButtonTheme: AppButtonThemes.elevatedButton(AppColorSchemes.dark),
  textButtonTheme: AppButtonThemes.textButton(AppColorSchemes.dark),
  outlinedButtonTheme: AppButtonThemes.outlinedButton(AppColorSchemes.dark),
  filledButtonTheme: AppButtonThemes.filledButton(AppColorSchemes.dark),
  iconButtonTheme: AppButtonThemes.iconButton(AppColorSchemes.dark),

  inputDecorationTheme: AppInputThemes.inputDecoration(AppColorSchemes.dark),
  cardTheme: CardThemeData(
    color: AppColorSchemes.dark.surfaceContainerLow,
    shadowColor: AppColorSchemes.dark.shadow,
    surfaceTintColor: AppColorSchemes.dark.surfaceTint,
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    margin: const EdgeInsets.all(8.0),
  ),

  appBarTheme: AppNavigationThemes.appBar(AppColorSchemes.dark),
  bottomNavigationBarTheme:
      AppNavigationThemes.bottomNavigationBar(AppColorSchemes.dark),
  navigationRailTheme: AppNavigationThemes.navigationRail(AppColorSchemes.dark),
  drawerTheme: AppNavigationThemes.drawer(AppColorSchemes.dark),

  bottomSheetTheme: AppSurfaceThemes.bottomSheet(AppColorSchemes.dark),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColorSchemes.dark.surface,
    elevation: 6.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
  ),
  snackBarTheme: AppSurfaceThemes.snackBar(AppColorSchemes.dark),
  tooltipTheme: AppSurfaceThemes.tooltip(AppColorSchemes.dark),
);
