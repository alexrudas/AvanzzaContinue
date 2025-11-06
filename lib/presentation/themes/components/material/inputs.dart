// components/material/inputs.dart
import 'package:flutter/material.dart';
import '../../foundations/design_system.dart';

abstract class AppInputThemes {
  AppInputThemes._();

  static InputDecorationTheme inputDecoration(ColorScheme scheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      hintStyle: DS.typography.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      labelStyle: DS.typography.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: scheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: scheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: scheme.error),
      ),
      contentPadding: const EdgeInsets.all(16.0),
    );
  }
}
