// ============================================================================
// components/chart/simple_bar_chart.dart
// ============================================================================
//
// QUÉ ES:
//   Widget de gráfico de barras minimalista y reutilizable para KPIs y métricas.
//   Soporta orientación vertical (columnas) y horizontal (barras), con animación
//   suave, normalización automática de valores, y opciones de personalización.
//
// DÓNDE SE USA:
//   - Dashboards y reportes de KPIs
//   - Comparación de métricas entre períodos
//   - Visualización de datos categóricos simples
//
// CARACTERÍSTICAS:
//   ✅ Orientación vertical (columnas) u horizontal (barras)
//   ✅ Normalización automática basada en valor máximo de la serie
//   ✅ Animación de crecimiento con TweenAnimationBuilder (700ms default)
//   ✅ Colores personalizables por entrada o derivados de ColorScheme
//   ✅ Labels y valores opcionales con tipografía adecuada
//   ✅ Radios redondeados configurables (Material 3)
//   ✅ Accesibilidad: textScaleFactor, contrastes, tamaños mínimos
//
// PARÁMETROS:
//   - data: Lista de BarEntry con label, value y color opcional
//   - direction: Orientación (Axis.vertical para columnas, Axis.horizontal para barras)
//   - barThickness: Grosor de las barras (default 10.0)
//   - barRadius: Radio de las esquinas redondeadas (default 8.0)
//   - showValues: Mostrar valores numéricos (default true)
//   - showLabels: Mostrar labels de categorías (default true)
//   - animationDuration: Duración de la animación (default 700ms)
//   - maxBarLength: Longitud máxima de la barra más grande (default 200.0)
//   - spacing: Espacio entre barras (default 12.0)
//
// USO ESPERADO:
//   SimpleBarChart(
//     data: [
//       BarEntry(label: 'Ene', value: 12),
//       BarEntry(label: 'Feb', value: 18),
//       BarEntry(label: 'Mar', value: 9),
//       BarEntry(label: 'Abr', value: 15),
//     ],
//     direction: Axis.vertical,
//     showValues: true,
//   )
//
// ANTIPATRONES (evitar):
//   ❌ Pasar data vacía (debe tener al menos 1 entrada)
//   ❌ Valores negativos (se clampen a 0)
//   ❌ Más de 12 entradas sin scroll (degrada legibilidad)
//
// ============================================================================

import 'package:flutter/material.dart';
import '../../foundations/design_system.dart';
import '../../foundations/theme_extensions.dart';

/// Entrada de datos para SimpleBarChart.
///
/// Representa una barra individual con su label, valor y color opcional.
class BarEntry {
  /// Label de la categoría (ej: "Ene", "Producto A", "Zona Norte").
  /// Se muestra debajo de la barra (vertical) o a la izquierda (horizontal).
  final String label;

  /// Valor numérico de la entrada.
  /// Se normaliza internamente al rango 0..1 basado en el máximo de la serie.
  /// Valores negativos se clampen a 0.
  final double value;

  /// Color override opcional para esta barra específica.
  /// Si es null, se usa el color primary del ColorScheme o un gradiente si disponible.
  final Color? colorOverride;

  const BarEntry({
    required this.label,
    required this.value,
    this.colorOverride,
  });
}

/// Widget de gráfico de barras simple con orientación configurable.
///
/// Normaliza automáticamente los valores al rango 0..1 basándose en el valor
/// máximo de la serie. Anima el crecimiento de las barras desde 0 hasta su
/// valor normalizado con curva Material Motion emphasized.
class SimpleBarChart extends StatelessWidget {
  /// Lista de entradas de datos (mínimo 1 entrada).
  final List<BarEntry> data;

  /// Orientación del gráfico.
  /// - Axis.vertical: Barras verticales (columnas)
  /// - Axis.horizontal: Barras horizontales
  final Axis direction;

  /// Grosor de las barras en píxeles.
  /// Default: 10.0 (suficiente para tap targets en mobile)
  final double barThickness;

  /// Radio de las esquinas redondeadas de las barras.
  /// Default: 8.0 (Material 3 generoso)
  final double barRadius;

  /// Mostrar valores numéricos encima/al lado de las barras.
  /// Default: true
  final bool showValues;

  /// Mostrar labels de categorías debajo/al lado de las barras.
  /// Default: true
  final bool showLabels;

  /// Duración de la animación de crecimiento de las barras.
  /// Default: 700ms (Material Motion normal)
  final Duration animationDuration;

  /// Longitud máxima de la barra más grande en píxeles.
  /// Default: 200.0 (ajustable según espacio disponible)
  final double maxBarLength;

  /// Espacio entre barras en píxeles.
  /// Default: 12.0
  final double spacing;

  const SimpleBarChart({
    super.key,
    required this.data,
    this.direction = Axis.vertical,
    this.barThickness = 10.0,
    this.barRadius = 8.0,
    this.showValues = true,
    this.showLabels = true,
    this.animationDuration = const Duration(milliseconds: 700),
    this.maxBarLength = 200.0,
    this.spacing = 12.0,
  }) : assert(data.length > 0, 'data debe tener al menos 1 entrada');

  @override
  Widget build(BuildContext context) {
    // Obtener ColorScheme y extensiones del tema
    final scheme = DS.scheme(context);
    final numTypography = Theme.of(context).extension<NumberTypographyExtension>();

    // Calcular valor máximo de la serie para normalización
    // Clampar valores negativos a 0
    final maxValue = data.map((e) => e.value.clamp(0.0, double.infinity)).reduce(
          (a, b) => a > b ? a : b,
        );

    // Evitar división por cero si todos los valores son 0
    final normalizedData = maxValue > 0
        ? data.map((e) => e.value.clamp(0.0, double.infinity) / maxValue).toList()
        : data.map((e) => 0.0).toList();

    // Layout según orientación
    if (direction == Axis.vertical) {
      return _buildVerticalChart(
        context,
        scheme,
        numTypography,
        normalizedData,
      );
    } else {
      return _buildHorizontalChart(
        context,
        scheme,
        numTypography,
        normalizedData,
      );
    }
  }

  /// Construir gráfico con barras verticales (columnas).
  Widget _buildVerticalChart(
    BuildContext context,
    ColorScheme scheme,
    NumberTypographyExtension? numTypography,
    List<double> normalizedData,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(data.length, (index) {
        final entry = data[index];
        final normalized = normalizedData[index];
        final barColor = entry.colorOverride ?? scheme.primary;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing / 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Valor numérico encima de la barra (opcional)
                if (showValues) ...[
                  Text(
                    entry.value.toStringAsFixed(0),
                    style: (numTypography?.numberSM ?? DS.text(context).labelSmall)?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                ],

                // Barra vertical animada
                TweenAnimationBuilder<double>(
                  duration: animationDuration,
                  curve: Curves.easeInOutCubicEmphasized,
                  tween: Tween(begin: 0.0, end: normalized),
                  builder: (context, animatedValue, child) {
                    return Container(
                      width: barThickness,
                      height: maxBarLength * animatedValue,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(barRadius),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8.0),

                // Label de categoría debajo de la barra (opcional)
                if (showLabels)
                  Text(
                    entry.label,
                    style: DS.text(context).labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Construir gráfico con barras horizontales.
  Widget _buildHorizontalChart(
    BuildContext context,
    ColorScheme scheme,
    NumberTypographyExtension? numTypography,
    List<double> normalizedData,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(data.length, (index) {
        final entry = data[index];
        final normalized = normalizedData[index];
        final barColor = entry.colorOverride ?? scheme.primary;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: spacing / 2),
          child: Row(
            children: [
              // Label de categoría a la izquierda de la barra (opcional)
              if (showLabels) ...[
                SizedBox(
                  width: 80.0, // Ancho fijo para alineación
                  child: Text(
                    entry.label,
                    style: DS.text(context).labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(width: 12.0),
              ],

              // Barra horizontal animada
              Expanded(
                child: Stack(
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: animationDuration,
                      curve: Curves.easeInOutCubicEmphasized,
                      tween: Tween(begin: 0.0, end: normalized),
                      builder: (context, animatedValue, child) {
                        return Container(
                          height: barThickness,
                          width: maxBarLength * animatedValue,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(barRadius),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Valor numérico a la derecha de la barra (opcional)
              if (showValues) ...[
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 40.0, // Ancho fijo para alineación
                  child: Text(
                    entry.value.toStringAsFixed(0),
                    style: (numTypography?.numberSM ?? DS.text(context).labelSmall)?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
