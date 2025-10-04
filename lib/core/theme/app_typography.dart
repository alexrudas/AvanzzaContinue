import 'package:flutter/material.dart';

TextTheme buildTextTheme(TextTheme base) {
  // If you add a custom font, set fontFamily in ThemeData and adjust here
  return base.copyWith(
    displayLarge: base.displayLarge,
    displayMedium: base.displayMedium,
    displaySmall: base.displaySmall,
    headlineLarge: base.headlineLarge,
    headlineMedium: base.headlineMedium,
    headlineSmall: base.headlineSmall,
    titleLarge: base.titleLarge,
    titleMedium: base.titleMedium,
    titleSmall: base.titleSmall,
    bodyLarge: base.bodyLarge,
    bodyMedium: base.bodyMedium,
    bodySmall: base.bodySmall,
    labelLarge: base.labelLarge,
    labelMedium: base.labelMedium,
    labelSmall: base.labelSmall,
  );
}
