// ============================================================================
// components/material/buttons.dart
// ============================================================================

import 'package:flutter/material.dart';

import '../../foundations/design_system.dart';
import '../../tokens/semantic.dart';

abstract class AppButtonThemes {
  AppButtonThemes._();

  static ElevatedButtonThemeData elevatedButton(ColorScheme scheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: scheme.onPrimary,
        backgroundColor: scheme.primary,
        disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
        disabledBackgroundColor:
            StateOverlay.disabled(scheme.surface, scheme.onSurface),
        elevation: DS.elevation.value1,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        minimumSize: Size.square(DS.semantic.minTouchTarget),
      ),
    );
  }

  static TextButtonThemeData textButton(ColorScheme scheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        minimumSize: Size.square(DS.semantic.minTouchTarget),
      ),
    );
  }

  static OutlinedButtonThemeData outlinedButton(ColorScheme scheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        minimumSize: Size.square(DS.semantic.minTouchTarget),
      ),
    );
  }

  static FilledButtonThemeData filledButton(ColorScheme scheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        foregroundColor: scheme.onPrimary,
        backgroundColor: scheme.primary,
        disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
        disabledBackgroundColor:
            StateOverlay.disabled(scheme.surface, scheme.onSurface),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        minimumSize: Size.square(DS.semantic.minTouchTarget),
      ),
    );
  }

  static IconButtonThemeData iconButton(ColorScheme scheme) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: scheme.onSurfaceVariant,
        disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
        padding: EdgeInsets.zero,
        minimumSize: Size.square(DS.semantic.minTouchTarget),
      ),
    );
  }
}
