// components/material/cards.dart
import 'package:flutter/material.dart';
import '../../foundations/design_system.dart';

abstract class AppCardThemes {
  AppCardThemes._();

  static CardTheme card(ColorScheme scheme) {
    return CardTheme(
      color: scheme.surfaceContainerLow,
      shadowColor: scheme.shadow,
      surfaceTintColor: scheme.surfaceTint,
      elevation: DS.elevation.value1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(8.0),
    );
  }
}
