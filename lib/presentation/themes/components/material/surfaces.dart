// components/material/surfaces.dart
import 'package:flutter/material.dart';
import '../../foundations/design_system.dart';

abstract class AppSurfaceThemes {
  AppSurfaceThemes._();

  static BottomSheetThemeData bottomSheet(ColorScheme scheme) {
    return BottomSheetThemeData(
      backgroundColor: scheme.surface,
      elevation: DS.elevation.value3,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
    );
  }

  static DialogTheme dialog(ColorScheme scheme) {
    return DialogTheme(
      backgroundColor: scheme.surface,
      elevation: DS.elevation.value3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    );
  }

  static SnackBarThemeData snackBar(ColorScheme scheme) {
    return SnackBarThemeData(
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: DS.typography.textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      behavior: SnackBarBehavior.floating,
    );
  }

  static TooltipThemeData tooltip(ColorScheme scheme) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: scheme.inverseSurface,
        borderRadius: BorderRadius.circular(4.0),
      ),
      textStyle: DS.typography.textTheme.bodySmall?.copyWith(color: scheme.onInverseSurface),
    );
  }
}
