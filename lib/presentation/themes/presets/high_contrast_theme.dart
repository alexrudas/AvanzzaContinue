// ============================================================================
// presets/high_contrast_theme.dart
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
import '../components/material/cards.dart';
import '../components/material/navigation.dart';
import '../components/material/surfaces.dart';

final ThemeData highContrastTheme = ThemeData(
  useMaterial3: true,
  colorScheme: AppColorSchemes.highContrastLight,
  textTheme: AppTypography.highContrastTextTheme,
  // FIX: Registro de extensiones obligatorias para high contrast.
  // NumberTypographyExtension.base agregado para evitar fallos en KPIs y componentes numéricos.
  extensions: [
    CustomThemeExtension.highContrast,
    AppChartTheme.highContrast,
    NumberTypographyExtension.base, // FIX: Added for high contrast support
    AppBadgeTheme.fromScheme(AppColorSchemes.highContrastLight),
  ],

  // Transitions & Loading
  pageTransitionsTheme: AppPageTransitions.theme,
  progressIndicatorTheme: AppLoadingThemes.progressIndicator(AppColorSchemes.highContrastLight),

  elevatedButtonTheme: AppButtonThemes.elevatedButton(AppColorSchemes.highContrastLight),
  textButtonTheme: AppButtonThemes.textButton(AppColorSchemes.highContrastLight),
  outlinedButtonTheme: AppButtonThemes.outlinedButton(AppColorSchemes.highContrastLight),
  filledButtonTheme: AppButtonThemes.filledButton(AppColorSchemes.highContrastLight),
  iconButtonTheme: AppButtonThemes.iconButton(AppColorSchemes.highContrastLight),

  inputDecorationTheme: AppInputThemes.inputDecoration(AppColorSchemes.highContrastLight),
  cardTheme: AppCardThemes.card(AppColorSchemes.highContrastLight),

  appBarTheme: AppNavigationThemes.appBar(AppColorSchemes.highContrastLight),
  bottomNavigationBarTheme: AppNavigationThemes.bottomNavigationBar(AppColorSchemes.highContrastLight),
  navigationRailTheme: AppNavigationThemes.navigationRail(AppColorSchemes.highContrastLight),
  drawerTheme: AppNavigationThemes.drawer(AppColorSchemes.highContrastLight),

  bottomSheetTheme: AppSurfaceThemes.bottomSheet(AppColorSchemes.highContrastLight),
  dialogTheme: AppSurfaceThemes.dialog(AppColorSchemes.highContrastLight),
  snackBarTheme: AppSurfaceThemes.snackBar(AppColorSchemes.highContrastLight),
  tooltipTheme: AppSurfaceThemes.tooltip(AppColorSchemes.highContrastLight),
);
