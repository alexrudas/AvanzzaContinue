// ============================================================================
// tokens/elevation.dart
// ============================================================================
//
// QUÉ ES:
//   Define niveles de elevación (sombras) para profundidad visual según
//   Material 3. Cada nivel contiene listas de BoxShadow con blur, offset
//   y color calculados según la especificación de Material Design.
//
// DÓNDE SE IMPORTA:
//   - foundations/design_system.dart (DS.elevation expone estos valores)
//   - components/material/*.dart (Card, AppBar, BottomSheet, Dialog)
//   - Widgets customizados que necesiten sombras consistentes
//
// QUÉ NO HACE:
//   - NO contiene widgets ni decoradores (esos van en components/)
//   - NO tiene lógica de tema claro/oscuro (el color de sombra se ajusta en runtime)
//   - NO define surface tints (esos están en ColorScheme.surfaceTint)
//
// USO ESPERADO:
//   // Consumo recomendado vía DS wrapper
//   Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       boxShadow: DS.elevation.level2,
//     ),
//   )
//
//   // Acceso directo
//   import 'package:avanzza/presentation/themes/tokens/elevation.dart';
//   Card(
//     elevation: 0, // Desactivar sombra default de Card
//     child: Container(
//       decoration: BoxDecoration(
//         boxShadow: ElevationLevels.level3,
//       ),
//     ),
//   )
//
// ============================================================================

import 'package:flutter/material.dart';

/// Niveles de elevación según Material 3.
/// Cada nivel representa una altura z-index con sombras correspondientes.
/// Material 3 usa surface tints además de sombras, pero aquí solo definimos sombras.
abstract class ElevationLevels {
  ElevationLevels._();

  /// Nivel 0: Sin elevación (superficie base, flush con background).
  /// Uso: Scaffold background, superficie base sin jerarquía.
  static const List<BoxShadow> level0 = [];

  /// Nivel 1: Elevación mínima (1dp).
  /// Uso: Cards de contenido, lista items con separación sutil.
  /// Shadow: Key light (offset Y=1, blur=3) + Ambient light (blur=1).
  static const List<BoxShadow> level1 = [
    BoxShadow(
      color: Color(0x1F000000), // Negro al 12% (~0.12 opacity)
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000), // Negro al 8% (~0.08 opacity)
      offset: Offset(0, 1),
      blurRadius: 1,
      spreadRadius: 0,
    ),
  ];

  /// Nivel 2: Elevación baja (3dp).
  /// Uso: Cards hover, botones elevados, chips.
  /// Shadow: Key light (offset Y=2, blur=6) + Ambient light (blur=2).
  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  /// Nivel 3: Elevación media (6dp).
  /// Uso: FAB (floating action button), snackbar, app bar con scroll.
  /// Shadow: Key light (offset Y=3, blur=8) + Ambient light (blur=4).
  static const List<BoxShadow> level3 = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 3),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  /// Nivel 4: Elevación alta (8dp).
  /// Uso: Navigation drawer, bottom app bar, modals.
  /// Shadow: Key light (offset Y=4, blur=10) + Ambient light (blur=6).
  static const List<BoxShadow> level4 = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 4),
      blurRadius: 10,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  /// Nivel 5: Elevación máxima (12dp).
  /// Uso: Dialogs, bottom sheets, menus flotantes críticos.
  /// Shadow: Key light (offset Y=6, blur=16) + Ambient light (blur=10).
  static const List<BoxShadow> level5 = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 6),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 3),
      blurRadius: 10,
      spreadRadius: 0,
    ),
  ];

  /// Helper: Obtener sombras por índice numérico (0-5).
  /// Uso: ElevationLevels.byLevel(2) → level2 shadows.
  static List<BoxShadow> byLevel(int level) {
    switch (level) {
      case 0:
        return level0;
      case 1:
        return level1;
      case 2:
        return level2;
      case 3:
        return level3;
      case 4:
        return level4;
      case 5:
        return level5;
      default:
        assert(level >= 0 && level <= 5, 'Elevation level must be 0-5');
        return level0;
    }
  }
}

/// Valores numéricos de elevación (en dp) para uso con Material widgets.
/// Algunos widgets de Material (Card, AppBar) aceptan double elevation en lugar de BoxShadow.
/// Estos valores corresponden a los niveles definidos arriba.
abstract class ElevationValues {
  ElevationValues._();

  static const double level0 = 0.0;
  static const double level1 = 1.0;
  static const double level2 = 3.0;
  static const double level3 = 6.0;
  static const double level4 = 8.0;
  static const double level5 = 12.0;

  /// Helper: Obtener valor numérico por nivel.
  static double byLevel(int level) {
    switch (level) {
      case 0:
        return level0;
      case 1:
        return level1;
      case 2:
        return level2;
      case 3:
        return level3;
      case 4:
        return level4;
      case 5:
        return level5;
      default:
        assert(level >= 0 && level <= 5, 'Elevation level must be 0-5');
        return level0;
    }
  }
}
