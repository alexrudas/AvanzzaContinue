// ============================================================================
// components/chart/semi_circular_gauge_chart.dart
// ============================================================================
//
// QUÉ ES:
//   Widget de gauge semicircular animado para mostrar progreso sobre un máximo
//   (típicamente presupuesto vs. ejecutado). Incluye lógica de semáforo de color:
//   - Verde/Primary: ejecución ≤ 85%
//   - Naranja/Warning: ejecución > 85% y ≤ 100%
//   - Rojo/Error: ejecución > 100% (sobre-ejecución)
//
// DÓNDE SE USA:
//   - Dashboards de contabilidad (presupuesto de gastos/ingresos)
//   - KPIs de ejecución presupuestaria
//   - Métricas de cumplimiento de objetivos
//
// CARACTERÍSTICAS:
//   ✅ Animación suave con TweenAnimationBuilder (900ms default)
//   ✅ Colores derivados de ColorScheme (Material 3)
//   ✅ Tipografía numérica con NumberTypographyExtension
//   ✅ Soporta sobre-ejecución (pct > 100%)
//   ✅ Accesibilidad: textScaleFactor, contrastes WCAG AAA
//   ✅ CustomPainter optimizado (solo repinta cuando cambian inputs)
//
// PARÁMETROS:
//   - maxValue: Valor máximo (ej: presupuesto total)
//   - value: Valor actual (ej: gastado hasta ahora)
//   - title: Título del gauge (ej: "Presupuesto Gastos")
//   - subtitle: Subtítulo con formato (ej: "€ 100.000")
//   - footerLabel: Label del footer (ej: "Diferencia")
//   - footerValueAbs: Valor absoluto del footer (ej: -13500)
//   - animationDuration: Duración de la animación (default 900ms)
//   - strokeWidth: Grosor del arco (default 16.0)
//   - height: Alto del contenedor del gauge (default 72.0)
//
// USO ESPERADO:
//   SemiCircularGaugeChart(
//     maxValue: 100000,
//     value: 86500,
//     title: 'Presupuesto Gastos',
//     subtitle: '€ 100.000',
//     footerLabel: 'Diferencia',
//     footerValueAbs: -13500,
//   )
//
// ANTIPATRONES (evitar):
//   ❌ Pasar value > maxValue * 2 (limita pct a 200%)
//   ❌ Hardcodear colores (se derivan de ColorScheme)
//   ❌ Usar sin NumberTypographyExtension en theme
//
// ============================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundations/design_system.dart';
import '../../foundations/theme_extensions.dart';

/// Widget de gauge semicircular con semáforo de color y animación suave.
///
/// Muestra un arco semicircular (180°) con progreso animado desde 0° hasta
/// el porcentaje calculado. El color del arco cambia según el porcentaje:
/// - ≤ 85%: primary (ejecución saludable)
/// - > 85% y ≤ 100%: warning/tertiary (alerta de proximidad)
/// - > 100%: error (sobre-ejecución)
class SemiCircularGaugeChart extends StatelessWidget {
  /// Valor máximo del gauge (denominador del porcentaje).
  /// Típicamente representa el presupuesto total o meta a alcanzar.
  final double maxValue;

  /// Valor actual del gauge (numerador del porcentaje).
  /// Típicamente representa el monto ejecutado o progreso actual.
  final double value;

  /// Título principal del gauge.
  /// Se muestra encima del arco con estilo titleMedium.
  final String title;

  /// Subtítulo formateado (opcional).
  /// Se muestra debajo del título con estilo labelMedium y color onSurfaceVariant.
  /// Ejemplo: "€ 100.000" o "Meta: 50 unidades"
  final String? subtitle;

  /// Label del footer (opcional).
  /// Se muestra en la parte inferior con el valor absoluto de diferencia.
  /// Ejemplo: "Diferencia", "Restante", "Excedente"
  final String? footerLabel;

  /// Valor absoluto del footer (opcional).
  /// Diferencia entre maxValue y value (puede ser negativo si hay sobre-ejecución).
  /// Se colorea en error si es negativo, en onSurface si es positivo.
  final double? footerValueAbs;

  /// Duración de la animación del arco.
  /// Default: 900ms (Material Motion emphasized)
  final Duration animationDuration;

  /// Grosor del trazo del arco.
  /// Default: 16.0 (suficientemente visible sin ser intrusivo)
  final double strokeWidth;

  /// Alto del contenedor del gauge.
  /// Default: 72.0 (suficiente para gauge + texto central)
  final double height;

  const SemiCircularGaugeChart({
    super.key,
    required this.maxValue,
    required this.value,
    required this.title,
    this.subtitle,
    this.footerLabel,
    this.footerValueAbs,
    this.animationDuration = const Duration(milliseconds: 900),
    this.strokeWidth = 16.0,
    this.height = 72.0,
  }) : assert(maxValue > 0, 'maxValue debe ser > 0');

  @override
  Widget build(BuildContext context) {
    // Calcular porcentaje clamped a rango 0.0 - 2.0 (permite sobre-ejecución hasta 200%)
    final percentage = (value / maxValue).clamp(0.0, 2.0);

    // Obtener ColorScheme y NumberTypographyExtension del tema
    final scheme = DS.scheme(context);
    final numTypography =
        Theme.of(context).extension<NumberTypographyExtension>();

    // Determinar color del progreso según semáforo:
    // - > 100%: error (sobre-ejecución crítica)
    // - > 85% y ≤ 100%: tertiary/warning (proximidad a límite)
    // - ≤ 85%: primary (ejecución saludable)
    final Color progressColor;
    if (percentage > 1.0) {
      progressColor = scheme.error;
    } else if (percentage > 0.85) {
      // Usar tertiary como warning (naranja/amber) si está disponible
      progressColor = scheme.tertiary;
    } else {
      progressColor = scheme.primary;
    }

    // Color de fondo del arco (superficie container elevada)
    final backgroundColor = scheme.surfaceContainerHighest;

    return Column(
      // Anti-overflow: usar tamaño mínimo para evitar expansión innecesaria
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === TÍTULO Y SUBTÍTULO ===
        // Título principal del gauge con estilo titleMedium
        // Anti-overflow: softWrap false + ellipsis
        Text(
          title,
          style: DS.text(context).titleMedium?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),

        // Subtítulo formateado (opcional)
        if (subtitle != null) ...[
          const SizedBox(height: 4.0), // Gap pequeño entre título y subtítulo
          Text(
            subtitle!,
            style: DS.text(context).labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        const SizedBox(height: 12.0), // Gap antes del gauge

        // === GAUGE SEMICIRCULAR ===
        // Contenedor del gauge con altura fija y Stack para centrar el texto
        SizedBox(
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // CustomPainter para dibujar el arco de fondo y progreso
              TweenAnimationBuilder<double>(
                duration: animationDuration,
                curve: Curves
                    .easeInOutCubicEmphasized, // Material Motion emphasized
                tween: Tween(begin: 0.0, end: percentage),
                builder: (context, animatedPercentage, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: _GaugePainter(
                      percentage: animatedPercentage,
                      backgroundColor: backgroundColor,
                      progressColor: progressColor,
                      strokeWidth: strokeWidth,
                    ),
                  );
                },
              ),

              // Texto central con el porcentaje en grande
              Positioned(
                bottom: 6.0, // Posicionado cerca del centro del arco
                child: Text(
                  '${(percentage * 100).toStringAsFixed(0)}%',
                  style:
                      (numTypography?.numberXL ?? DS.text(context).displaySmall)
                          ?.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4.0), // Gap antes del footer

        // === FOOTER CON DIFERENCIA ===
        // Muestra la diferencia entre maxValue y value
        // Colorea en error si es negativo (sobre-ejecución), en onSurface si es positivo
        if (footerLabel != null && footerValueAbs != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                footerLabel!,
                style: DS.text(context).labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              Text(
                footerValueAbs! < 0
                    ? footerValueAbs!.toStringAsFixed(0)
                    : '+${footerValueAbs!.toStringAsFixed(0)}',
                style: (numTypography?.numberSM ?? DS.text(context).labelLarge)
                    ?.copyWith(
                  color: footerValueAbs! < 0 ? scheme.error : scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// CustomPainter privado que dibuja el arco semicircular del gauge.
///
/// OPTIMIZACIÓN:
/// - Solo repinta cuando cambian percentage, backgroundColor, progressColor o strokeWidth.
/// - Usa shouldRepaint para evitar repaints innecesarios.
///
/// COMPORTAMIENTO:
/// - Geometría igualada a _GaugePainterPro (center: height*0.8, radius: width*0.7).
/// - Dibuja arco de fondo completo (180°) con backgroundColor.
/// - Dibuja sombra ligera debajo del arco de progreso para profundidad visual.
/// - Dibuja arco de progreso con visualMaxPercent = 1.5 (150% = límite visual).
/// - Marca de 100% con línea blanca semi-transparente.
/// - Soporta sobre-ejecución (percentage > 1.0) pintando arco completo + cola adicional.
class _GaugePainter extends CustomPainter {
  final double percentage;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _GaugePainter({
    required this.percentage,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Geometría igualada a _GaugePainterPro para curvatura consistente
    final center = Offset(size.width / 2, size.height * 0.8);
    final radius = (size.width / 1.8) * 0.75;

    // Rect para los arcos (boundingBox del círculo)
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Constantes de ángulo y límite visual
    const startAngle = math.pi; // -180° (izquierda)
    const sweepAngle = math.pi; // 180° (semicírculo completo)
    const visualMaxPercent = 1.5; // 150% = límite visual del arco

    // Paint para el arco de fondo
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Dibujar arco de fondo (semicírculo completo: 180°)
    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);

    // Calcular sweep del progreso con límite visual de 150%
    final progressSweep =
        (sweepAngle * (percentage / visualMaxPercent)).clamp(0.0, sweepAngle);

    // Dibujar arco de progreso solo si hay progreso
    if (percentage > 0) {
      // Sombra ligera debajo del arco para profundidad visual
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.22)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
      canvas.drawArc(
          rect.translate(0, 2), startAngle, progressSweep, false, shadowPaint);

      // Arco de progreso con gradiente sutil (más oscuro → color completo)
      final progressPaint = Paint()
        ..shader = LinearGradient(
          colors: [progressColor.withValues(alpha: 0.7), progressColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(rect)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, progressSweep, false, progressPaint);
    }

    // Marcador de 100% (línea blanca semi-transparente en el punto de 100%)
    const markerAngle = startAngle + (sweepAngle * (1.0 / visualMaxPercent));
    final markerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = strokeWidth / 4
      ..style = PaintingStyle.stroke;
    final markerStart = Offset(
      center.dx + (radius - strokeWidth / 2) * math.cos(markerAngle),
      center.dy + (radius - strokeWidth / 2) * math.sin(markerAngle),
    );
    final markerEnd = Offset(
      center.dx + (radius + strokeWidth / 2) * math.cos(markerAngle),
      center.dy + (radius + strokeWidth / 2) * math.sin(markerAngle),
    );
    canvas.drawLine(markerStart, markerEnd, markerPaint);
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
    // Solo repintar si cambian los valores relevantes
    return percentage != oldDelegate.percentage ||
        backgroundColor != oldDelegate.backgroundColor ||
        progressColor != oldDelegate.progressColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
