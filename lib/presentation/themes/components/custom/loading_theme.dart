// ============================================================================
// components/custom/loading_theme.dart
// ============================================================================

import 'package:flutter/material.dart';

abstract class AppLoadingThemes {
  AppLoadingThemes._();

  static ProgressIndicatorThemeData progressIndicator(ColorScheme scheme) {
    return ProgressIndicatorThemeData(
      color: scheme.primary,
      linearTrackColor: scheme.surfaceContainerHighest,
      linearMinHeight: 4.0,
      refreshBackgroundColor: scheme.surface,
    );
  }
}
