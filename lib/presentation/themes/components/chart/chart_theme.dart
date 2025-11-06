// ============================================================================
// components/chart/chart_theme.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'chart_presets.dart';

@immutable
class AppChartTheme extends ThemeExtension<AppChartTheme> {
  final ChartColorPalette primaryPalette;
  final ChartColorPalette secondaryPalette;
  final ChartColorPalette semanticPalette;
  final Color gridColor;
  final Color axisColor;
  final Color tooltipBackground;
  final Color tooltipText;
  final double strokeWidth;
  final double gridStrokeWidth;
  final double barRadius;
  final double markerSize;
  final double tickSize;
  final double barGap;
  final Gradient? areaGradient;
  final List<BoxShadow> chartShadow;

  const AppChartTheme({
    required this.primaryPalette,
    required this.secondaryPalette,
    required this.semanticPalette,
    required this.gridColor,
    required this.axisColor,
    required this.tooltipBackground,
    required this.tooltipText,
    required this.strokeWidth,
    required this.gridStrokeWidth,
    required this.barRadius,
    required this.markerSize,
    required this.tickSize,
    required this.barGap,
    this.areaGradient,
    required this.chartShadow,
  });

  static AppChartTheme of(BuildContext context) {
    final theme = Theme.of(context).extension<AppChartTheme>();
    assert(theme != null, 'AppChartTheme no encontrado');
    return theme!;
  }

  // ========== GAUGE COLORS (para SemiCircularGaugeChart) ==========

  /// Color de fondo del gauge (arco no lleno).
  /// Deriva del gridColor para consistencia visual con otros charts.
  Color get gaugeBackground => gridColor;

  /// Color primario del gauge (ejecución saludable ≤ 85%).
  /// Deriva del primer color de primaryPalette.
  Color get gaugePrimary => primaryPalette[0];

  /// Color de warning del gauge (ejecución > 85% y ≤ 100%).
  /// Deriva del color warning de semanticPalette.
  Color get gaugeWarning => semanticPalette[1]; // Warning es índice 1 en semantic

  /// Color de error del gauge (sobre-ejecución > 100%).
  /// Deriva del color error de semanticPalette.
  Color get gaugeError => semanticPalette[0]; // Error es índice 0 en semantic

  // ========== BAR COLORS (para SimpleBarChart) ==========

  /// Color base de barras (usado por defecto si no hay colorOverride).
  /// Deriva del primer color de primaryPalette.
  Color get barBase => primaryPalette[0];

  /// Color de acento de barras (para variación o destacados).
  /// Deriva del primer color de secondaryPalette.
  Color get barAccent => secondaryPalette[0];

  static const AppChartTheme light = AppChartTheme(
    primaryPalette: ChartPalettes.lightPrimary,
    secondaryPalette: ChartPalettes.lightSecondary,
    semanticPalette: ChartPalettes.semantic,
    gridColor: Color(0xFFE0E0E0),
    axisColor: Color(0xFF9E9E9E),
    tooltipBackground: Color(0xE6FFFFFF),
    tooltipText: Color(0xFF212121),
    strokeWidth: 2.5,
    gridStrokeWidth: 0.8,
    barRadius: 6.0,
    markerSize: 5.0,
    tickSize: 5.0,
    barGap: 6.0,
    areaGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x801E88E5), Color(0x001E88E5)],
    ),
    chartShadow: [BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 8)],
  );

  static const AppChartTheme dark = AppChartTheme(
    primaryPalette: ChartPalettes.darkPrimary,
    secondaryPalette: ChartPalettes.darkSecondary,
    semanticPalette: ChartPalettes.semantic,
    gridColor: Color(0xFF424242),
    axisColor: Color(0xFF757575),
    tooltipBackground: Color(0xE6424242),
    tooltipText: Color(0xFFEEEEEE),
    strokeWidth: 2.5,
    gridStrokeWidth: 0.8,
    barRadius: 6.0,
    markerSize: 5.0,
    tickSize: 5.0,
    barGap: 6.0,
    areaGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x8064B5F6), Color(0x0064B5F6)],
    ),
    chartShadow: [BoxShadow(color: Color(0x33000000), offset: Offset(0, 2), blurRadius: 8)],
  );

  static const AppChartTheme highContrast = AppChartTheme(
    primaryPalette: ChartPalettes.highContrastPrimary,
    secondaryPalette: ChartPalettes.highContrastSecondary,
    semanticPalette: ChartPalettes.semantic,
    gridColor: Color(0xFF616161),
    axisColor: Color(0xFF212121),
    tooltipBackground: Color(0xFFFFFFFF),
    tooltipText: Color(0xFF000000),
    strokeWidth: 3.0,
    gridStrokeWidth: 1.2,
    barRadius: 4.0,
    markerSize: 6.0,
    tickSize: 6.0,
    barGap: 8.0,
    areaGradient: null,
    chartShadow: [BoxShadow(color: Color(0x4D000000), offset: Offset(0, 2), blurRadius: 6)],
  );

  @override
  ThemeExtension<AppChartTheme> copyWith({
    ChartColorPalette? primaryPalette,
    ChartColorPalette? secondaryPalette,
    ChartColorPalette? semanticPalette,
    Color? gridColor,
    Color? axisColor,
    Color? tooltipBackground,
    Color? tooltipText,
    double? strokeWidth,
    double? gridStrokeWidth,
    double? barRadius,
    double? markerSize,
    double? tickSize,
    double? barGap,
    Gradient? areaGradient,
    List<BoxShadow>? chartShadow,
  }) {
    return AppChartTheme(
      primaryPalette: primaryPalette ?? this.primaryPalette,
      secondaryPalette: secondaryPalette ?? this.secondaryPalette,
      semanticPalette: semanticPalette ?? this.semanticPalette,
      gridColor: gridColor ?? this.gridColor,
      axisColor: axisColor ?? this.axisColor,
      tooltipBackground: tooltipBackground ?? this.tooltipBackground,
      tooltipText: tooltipText ?? this.tooltipText,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      gridStrokeWidth: gridStrokeWidth ?? this.gridStrokeWidth,
      barRadius: barRadius ?? this.barRadius,
      markerSize: markerSize ?? this.markerSize,
      tickSize: tickSize ?? this.tickSize,
      barGap: barGap ?? this.barGap,
      areaGradient: areaGradient ?? this.areaGradient,
      chartShadow: chartShadow ?? this.chartShadow,
    );
  }

  @override
  ThemeExtension<AppChartTheme> lerp(covariant ThemeExtension<AppChartTheme>? other, double t) {
    if (other is! AppChartTheme) return this;
    return AppChartTheme(
      primaryPalette: ChartColorPalette.lerp(primaryPalette, other.primaryPalette, t) ?? primaryPalette,
      secondaryPalette: ChartColorPalette.lerp(secondaryPalette, other.secondaryPalette, t) ?? secondaryPalette,
      semanticPalette: ChartColorPalette.lerp(semanticPalette, other.semanticPalette, t) ?? semanticPalette,
      gridColor: Color.lerp(gridColor, other.gridColor, t) ?? gridColor,
      axisColor: Color.lerp(axisColor, other.axisColor, t) ?? axisColor,
      tooltipBackground: Color.lerp(tooltipBackground, other.tooltipBackground, t) ?? tooltipBackground,
      tooltipText: Color.lerp(tooltipText, other.tooltipText, t) ?? tooltipText,
      strokeWidth: strokeWidth + (other.strokeWidth - strokeWidth) * t,
      gridStrokeWidth: gridStrokeWidth + (other.gridStrokeWidth - gridStrokeWidth) * t,
      barRadius: barRadius + (other.barRadius - barRadius) * t,
      markerSize: markerSize + (other.markerSize - markerSize) * t,
      tickSize: tickSize + (other.tickSize - tickSize) * t,
      barGap: barGap + (other.barGap - barGap) * t,
      areaGradient: Gradient.lerp(areaGradient, other.areaGradient, t),
      chartShadow: BoxShadow.lerpList(chartShadow, other.chartShadow, t) ?? chartShadow,
    );
  }

  @override
  String toString() => 'AppChartTheme(primaryPalette: ${primaryPalette.length} colors)';
}
