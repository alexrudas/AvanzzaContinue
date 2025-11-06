// ============================================================================
// foundations/design_system.dart
// ============================================================================
//
// QUÉ ES:
//   Hub central del design system. Expone todos los tokens y fundaciones
//   mediante una API unificada (DS).
//
// DÓNDE SE IMPORTA:
//   - Páginas y widgets que necesiten acceso directo a tokens
//   - Componentes custom
//
// IMPORTANTE: NO importar DS en tokens/ ni en foundations/ para evitar ciclos.
//
// USO ESPERADO:
//   import 'package:avanzza/presentation/themes/foundations/design_system.dart';
//
//   Container(
//     padding: DS.insetsAll(DS.spacing.md),
//     decoration: BoxDecoration(
//       borderRadius: DS.radii.mdRadius,
//       boxShadow: DS.elevation.level2,
//     ),
//     child: Column(
//       children: [
//         Text('Hello', style: DS.text(context).bodyLarge),
//         DS.gapH(DS.spacing.sm),
//         ElevatedButton(onPressed: () {}, child: Text('Click')),
//       ],
//     ),
//   )
//
// ============================================================================

import 'package:flutter/material.dart';
import '../tokens/primitives.dart';
import '../tokens/semantic.dart';
import '../tokens/motion.dart';
import '../tokens/elevation.dart';
import '../components/chart/chart_theme.dart';
import 'typography.dart';
import 'color_schemes.dart';
import 'theme_extensions.dart';

/// Design System (DS): Hub central de acceso a todos los tokens y fundaciones.
abstract class DS {
  DS._();

  static const colors = ColorPrimitives;
  static const semantic = _SemanticWrapper();
  static const spacing = SpacingPrimitives;
  static const radii = _RadiiWrapper();
  static const breakpoints = BreakpointPrimitives;
  static const motion = _MotionWrapper();
  static const elevation = _ElevationWrapper();
  static const typography = _TypographyWrapper();
  static const colorSchemes = AppColorSchemes;

  // ========== Theme Extensions ==========
  static CustomThemeExtension ext(BuildContext context) {
    final ext = Theme.of(context).extension<CustomThemeExtension>();
    assert(ext != null, 'CustomThemeExtension no registrada en ThemeData.extensions');
    return ext!;
  }

  /// Helper para acceder a AppChartTheme.
  ///
  /// Uso: final chartTheme = DS.chart(context);
  ///
  /// IMPORTANTE: Requiere que AppChartTheme esté registrado en extensions de presets.
  static AppChartTheme chart(BuildContext context) {
    final chartTheme = Theme.of(context).extension<AppChartTheme>();
    assert(
      chartTheme != null,
      'AppChartTheme no encontrado. Verifica registro en presets light/dark/highContrast.',
    );
    return chartTheme!;
  }

  // ========== Helpers de Theme activo ==========
  static ThemeData theme(BuildContext context) => Theme.of(context);
  static ColorScheme scheme(BuildContext context) => Theme.of(context).colorScheme;
  static TextTheme text(BuildContext context) => Theme.of(context).textTheme;
  static MediaQueryData mq(BuildContext context) => MediaQuery.of(context);
  static BreakpointType bp(BuildContext context) {
    return BreakpointPrimitives.fromWidth(mq(context).size.width);
  }

  // ========== Helpers ergonómicos ==========
  static EdgeInsets insetsAll(double v) => EdgeInsets.all(v);
  static EdgeInsets insetsSym({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: h, vertical: v);
  static EdgeInsets insetsOnly({double l = 0, double t = 0, double r = 0, double b = 0}) =>
      EdgeInsets.only(left: l, top: t, right: r, bottom: b);

  static SizedBox gapH(double v) => SizedBox(height: v);
  static SizedBox gapW(double v) => SizedBox(width: v);

  static ShapeBorder rounded(double r) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r),
      );
}

// ============================================================================
// Wrappers
// ============================================================================

class _SemanticWrapper {
  const _SemanticWrapper();

  Color get success => SemanticColors.success;
  Color get warning => SemanticColors.warning;
  Color get info => SemanticColors.info;
  Color get error => SemanticColors.error;
  Color get successLight => SemanticColors.successLight;
  Color get warningLight => SemanticColors.warningLight;
  Color get infoLight => SemanticColors.infoLight;
  Color get errorLight => SemanticColors.errorLight;

  double get paddingScreen => SemanticSpacing.paddingScreen;
  double get paddingVertical => SemanticSpacing.paddingVertical;
  double get gapSmall => SemanticSpacing.gapSmall;
  double get gapMedium => SemanticSpacing.gapMedium;
  double get gapLarge => SemanticSpacing.gapLarge;
  double get minTouchTarget => SemanticSpacing.minTouchTarget;

  double get hoverOpacity => InteractionStates.hoverOpacity;
  double get pressedOpacity => InteractionStates.pressedOpacity;
  double get focusedOpacity => InteractionStates.focusedOpacity;
  double get disabledOpacity => InteractionStates.disabledOpacity;
  double get dividerOpacity => InteractionStates.dividerOpacity;

  Color hover(Color surface, Color tint) => StateOverlay.hover(surface, tint);
  Color pressed(Color surface, Color tint) => StateOverlay.pressed(surface, tint);
  Color focused(Color surface, Color tint) => StateOverlay.focused(surface, tint);
  Color disabled(Color surface, Color onSurface) => StateOverlay.disabled(surface, onSurface);
}

class _RadiiWrapper {
  const _RadiiWrapper();

  double get xs => RadiusPrimitives.xs;
  double get sm => RadiusPrimitives.sm;
  double get md => RadiusPrimitives.md;
  double get lg => RadiusPrimitives.lg;
  double get xl => RadiusPrimitives.xl;
  double get full => RadiusPrimitives.full;

  BorderRadius get xsRadius => BorderRadius.circular(xs);
  BorderRadius get smRadius => BorderRadius.circular(sm);
  BorderRadius get mdRadius => BorderRadius.circular(md);
  BorderRadius get lgRadius => BorderRadius.circular(lg);
  BorderRadius get xlRadius => BorderRadius.circular(xl);
  BorderRadius get fullRadius => BorderRadius.circular(full);
}

class _MotionWrapper {
  const _MotionWrapper();

  Duration get veryFast => MotionDurations.veryFast;
  Duration get fast => MotionDurations.fast;
  Duration get normal => MotionDurations.normal;
  Duration get slow => MotionDurations.slow;
  Duration get verySlow => MotionDurations.verySlow;
  Duration get instant => MotionDurations.instant;

  Curve get easeIn => MotionCurves.easeIn;
  Curve get easeOut => MotionCurves.easeOut;
  Curve get easeInOut => MotionCurves.easeInOut;
  Curve get easeInOutCubic => MotionCurves.easeInOutCubic;
  Curve get easeInOutCubicEmphasized => MotionCurves.easeInOutCubicEmphasized;
  Curve get linear => MotionCurves.linear;
  Curve get fastOutSlowIn => MotionCurves.fastOutSlowIn;
  Curve get elastic => MotionCurves.elastic;
  Curve get decelerate => MotionCurves.decelerate;

  Duration get feedbackDuration => MotionPresets.feedbackDuration;
  Curve get feedbackCurve => MotionPresets.feedbackCurve;
  Duration get navigationDuration => MotionPresets.navigationDuration;
  Curve get navigationCurve => MotionPresets.navigationCurve;
  Duration get overlayDuration => MotionPresets.overlayDuration;
  Curve get overlayEnterCurve => MotionPresets.overlayEnterCurve;
  Curve get overlayExitCurve => MotionPresets.overlayExitCurve;
  Duration get expansionDuration => MotionPresets.expansionDuration;
  Curve get expansionCurve => MotionPresets.expansionCurve;
  Duration get fadeDuration => MotionPresets.fadeDuration;
  Curve get fadeCurve => MotionPresets.fadeCurve;
}

class _ElevationWrapper {
  const _ElevationWrapper();

  List<BoxShadow> get level0 => ElevationLevels.level0;
  List<BoxShadow> get level1 => ElevationLevels.level1;
  List<BoxShadow> get level2 => ElevationLevels.level2;
  List<BoxShadow> get level3 => ElevationLevels.level3;
  List<BoxShadow> get level4 => ElevationLevels.level4;
  List<BoxShadow> get level5 => ElevationLevels.level5;

  List<BoxShadow> byLevel(int level) => ElevationLevels.byLevel(level);

  double get value0 => ElevationValues.level0;
  double get value1 => ElevationValues.level1;
  double get value2 => ElevationValues.level2;
  double get value3 => ElevationValues.level3;
  double get value4 => ElevationValues.level4;
  double get value5 => ElevationValues.level5;

  double valueByLevel(int level) => ElevationValues.byLevel(level);
}

class _TypographyWrapper {
  const _TypographyWrapper();

  TextTheme get textTheme => AppTypography.textTheme;
  TextTheme get highContrast => AppTypography.highContrastTextTheme;
}
