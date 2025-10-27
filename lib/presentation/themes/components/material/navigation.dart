// components/material/navigation.dart
import 'package:flutter/material.dart';
import '../../foundations/design_system.dart';

abstract class AppNavigationThemes {
  AppNavigationThemes._();

  static AppBarTheme appBar(ColorScheme scheme) {
    return AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      iconTheme: IconThemeData(color: scheme.onSurface),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: DS.typography.textTheme.titleLarge?.copyWith(color: scheme.onSurface),
    );
  }

  static BottomNavigationBarThemeData bottomNavigationBar(ColorScheme scheme) {
    return BottomNavigationBarThemeData(
      backgroundColor: scheme.surface,
      selectedItemColor: scheme.primary,
      unselectedItemColor: scheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: DS.elevation.value2,
    );
  }

  static NavigationRailThemeData navigationRail(ColorScheme scheme) {
    return NavigationRailThemeData(
      backgroundColor: scheme.surface,
      selectedIconTheme: IconThemeData(color: scheme.primary),
      unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      selectedLabelTextStyle:
          DS.typography.textTheme.labelMedium?.copyWith(color: scheme.primary),
      unselectedLabelTextStyle:
          DS.typography.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
    );
  }

  static DrawerThemeData drawer(ColorScheme scheme) {
    return DrawerThemeData(
      backgroundColor: scheme.surface,
      elevation: DS.elevation.value1,
    );
  }
}
