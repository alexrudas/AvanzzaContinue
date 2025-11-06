// ============================================================================
// components/chart/chart_presets.dart
// ============================================================================
//
// QUÉ ES:
//   Paletas de colores predefinidas para gráficos y dashboards.
//   Define colores armónicos para series de datos, paletas semánticas,
//   y variantes optimizadas para light/dark/highContrast.
//
// DÓNDE SE IMPORTA:
//   - components/chart/chart_theme.dart (usa estas paletas en AppChartTheme.light/dark/highContrast)
//   - Widgets de gráficos que necesiten acceso directo a paletas específicas
//
// QUÉ NO HACE:
//   - NO contiene lógica de renderizado de gráficos
//   - NO depende de librerías externas (fl_chart, syncfusion, etc.)
//   - NO sigue Dynamic Color (paletas fijas para consistencia cross-chart)
//
// USO ESPERADO:
//   // Acceso directo a paletas (SIEMPRE usa const en presets)
//   import 'package:avanzza/presentation/themes/components/chart/chart_presets.dart';
//
//   // Elegir color de serie n → palette[n]
//   final seriesColor = ChartPalettes.lightPrimary[seriesIndex];
//
//   // Uso típico a través de AppChartTheme
//   final chartTheme = Theme.of(context).extension<AppChartTheme>()!;
//   final color0 = chartTheme.primaryPalette[0]; // Primera serie
//   final color1 = chartTheme.primaryPalette[1]; // Segunda serie
//
//   // IMPORTANTE: Los presets internos usan const ChartColorPalette._internal([...]).
//   // Para runtime dinámico, usa ChartColorPalette([...]) que garantiza inmutabilidad.
//
// ANTIPATRONES (evitar):
//   ❌ Mezclar paletas light/dark manualmente en runtime
//   ❌ Modificar colors después de construcción (ya protegido con List.unmodifiable)
//   ❌ Crear paletas dinámicas basadas en user input sin validación
//
//   ✅ Usar paletas const predefinidas en ChartPalettes
//   ✅ Acceder vía Theme.of(context).extension<AppChartTheme>()
//   ✅ Dejar que lerp maneje transiciones de tema automáticamente
//
// ============================================================================

import 'package:flutter/material.dart';
import '../../tokens/semantic.dart';

/// Clase inmutable que representa una paleta de colores para gráficos.
///
/// Contiene una lista fija de colores distribuidos armónicamente que se
/// pueden usar de forma cíclica para series de datos en charts.
///
/// INMUTABILIDAD:
/// - Constructor const privado para presets (usa _internal)
/// - Constructor público que envuelve con List.unmodifiable
///
/// IMPORTANTE: En presets usa const ChartColorPalette._internal([...])
/// para máxima eficiencia. En runtime usa ChartColorPalette([...]).
@immutable
class ChartColorPalette {
  /// Lista de colores en la paleta (típicamente 10 colores).
  ///
  /// INMUTABLE: Garantizada por List.unmodifiable o listas const.
  final List<Color> colors;

  /// Constructor interno const para presets inmutables.
  ///
  /// Uso interno: const ChartColorPalette._internal([Color(0xFF...), ...])
  const ChartColorPalette._internal(this.colors);

  /// Constructor público que garantiza inmutabilidad real.
  ///
  /// Envuelve la lista en List.unmodifiable incluso si se pasa lista mutable.
  /// Uso: ChartColorPalette([Color(0xFF...), ...])
  factory ChartColorPalette(List<Color> colors) {
    assert(colors.isNotEmpty, 'ChartColorPalette no puede estar vacía');
    return ChartColorPalette._internal(List.unmodifiable(colors));
  }

  /// Acceso cíclico a colores por índice.
  ///
  /// Si el índice excede el tamaño de la paleta, cicla automáticamente.
  /// Ejemplo: con 10 colores, [15] retorna colors[5].
  Color operator [](int index) => colors[index % colors.length];

  /// Número de colores únicos en la paleta.
  int get length => colors.length;

  /// Interpolación entre dos paletas para transiciones de tema.
  ///
  /// IMPORTANTE: El tamaño de la paleta resultante es max(a.length, b.length).
  /// Si las paletas tienen tamaños diferentes, el resultado puede diferir
  /// del tamaño de entrada.
  ///
  /// RENDIMIENTO: Cachea el resultado si usas lerp en animaciones para
  /// evitar GC excesivo en frames consecutivos.
  ///
  /// NOTA: Solo se usa dentro de ThemeExtension.lerp para transiciones
  /// automáticas de tema. NO llamar manualmente por frame.
  static ChartColorPalette? lerp(ChartColorPalette? a, ChartColorPalette? b, double t) {
    if (a == null) return b;
    if (b == null) return a;

    final maxLength = a.length > b.length ? a.length : b.length;
    return ChartColorPalette(List<Color>.generate(maxLength, (i) {
      final colorA = a.colors[i % a.length];
      final colorB = b.colors[i % b.length];
      return Color.lerp(colorA, colorB, t)!;
    }));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChartColorPalette) return false;
    if (other.colors.length != colors.length) return false;
    for (int i = 0; i < colors.length; i++) {
      if (colors[i] != other.colors[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(colors);
}

/// Paletas de colores predefinidas para gráficos.
///
/// Incluye paletas optimizadas para:
/// - Light theme (colores saturados, legibles en fondo claro)
/// - Dark theme (colores desaturados, legibles en fondo oscuro)
/// - High contrast theme (optimizada para alto contraste)
/// - Paleta semántica universal (success, warning, error, info)
///
/// BRAND CONSISTENCY: El primer color de cada paleta primaria está alineado
/// con ColorPrimitives.primary (0xFF1E88E5) o su variante tonal correspondiente.
/// Mantén esta regla en futuras revisiones del brand.
abstract class ChartPalettes {
  ChartPalettes._();

  // ========== PALETAS PRIMARIAS ==========

  /// Paleta primaria para light theme (10 colores saturados).
  ///
  /// Colores distribuidos en el espectro cromático para máxima diferenciación.
  /// Optimizados para legibilidad en fondos claros (surface light).
  ///
  /// Primer color alineado a ColorPrimitives.primary (0xFF1E88E5).
  static const ChartColorPalette lightPrimary = ChartColorPalette._internal([
    Color(0xFF1E88E5), // Blue (brand primary)
    Color(0xFF43A047), // Green
    Color(0xFFFB8C00), // Orange
    Color(0xFFE53935), // Red
    Color(0xFF8E24AA), // Purple
    Color(0xFF00ACC1), // Cyan
    Color(0xFFF4511E), // Deep orange
    Color(0xFF5E35B1), // Deep purple
    Color(0xFF00897B), // Teal
    Color(0xFFFDD835), // Yellow
  ]);

  /// Paleta primaria para dark theme (10 colores desaturados).
  ///
  /// Tonos más suaves para evitar fatiga visual en fondos oscuros.
  /// Mantiene diferenciación cromática con luminosidad reducida.
  ///
  /// Primer color alineado tonalmente a ColorPrimitives.primary.
  static const ChartColorPalette darkPrimary = ChartColorPalette._internal([
    Color(0xFF64B5F6), // Light blue (tonal de brand primary)
    Color(0xFF81C784), // Light green
    Color(0xFFFFB74D), // Light orange
    Color(0xFFEF5350), // Light red
    Color(0xFFBA68C8), // Light purple
    Color(0xFF4DD0E1), // Light cyan
    Color(0xFFFF8A65), // Light deep orange
    Color(0xFF9575CD), // Light deep purple
    Color(0xFF4DB6AC), // Light teal
    Color(0xFFFFEE58), // Light yellow
  ]);

  /// Paleta primaria para high contrast theme (10 colores optimizados).
  ///
  /// Optimizada para alto contraste con colores puros y saturados.
  /// Evita tonos intermedios para máxima diferenciación visual.
  ///
  /// TODO: Validar amarillo (0xFFF9A825) sobre blanco y cian (0xFF006064)
  /// sobre negro con un checker WCAG antes de cierre de sprint.
  ///
  /// Primer color alineado tonalmente a ColorPrimitives.primary.
  static const ChartColorPalette highContrastPrimary = ChartColorPalette._internal([
    Color(0xFF0D47A1), // Dark blue (tonal oscuro de brand primary)
    Color(0xFF1B5E20), // Dark green
    Color(0xFFE65100), // Dark orange
    Color(0xFFB71C1C), // Dark red
    Color(0xFF4A148C), // Dark purple
    Color(0xFF006064), // Dark cyan (validar contraste)
    Color(0xFFBF360C), // Very dark orange
    Color(0xFF311B92), // Very dark purple
    Color(0xFF004D40), // Very dark teal
    Color(0xFFF9A825), // Amber (validar contraste)
  ]);

  // ========== PALETAS SECUNDARIAS ==========

  /// Paleta secundaria para light theme (8 colores pasteles).
  ///
  /// Útil para comparaciones o series secundarias que no deben competir
  /// visualmente con la paleta primaria.
  static const ChartColorPalette lightSecondary = ChartColorPalette._internal([
    Color(0xFF90CAF9), // Very light blue
    Color(0xFFA5D6A7), // Very light green
    Color(0xFFFFCC80), // Very light orange
    Color(0xFFEF9A9A), // Very light red
    Color(0xFFCE93D8), // Very light purple
    Color(0xFF80DEEA), // Very light cyan
    Color(0xFFFFAB91), // Very light deep orange
    Color(0xFFB39DDB), // Very light deep purple
  ]);

  /// Paleta secundaria para dark theme (8 colores oscuros).
  static const ChartColorPalette darkSecondary = ChartColorPalette._internal([
    Color(0xFF42A5F5), // Medium blue
    Color(0xFF66BB6A), // Medium green
    Color(0xFFFF9800), // Medium orange
    Color(0xFFE57373), // Medium red
    Color(0xFFAB47BC), // Medium purple
    Color(0xFF26C6DA), // Medium cyan
    Color(0xFFFF7043), // Medium deep orange
    Color(0xFF7E57C2), // Medium deep purple
  ]);

  /// Paleta secundaria para high contrast (8 colores contrastantes).
  static const ChartColorPalette highContrastSecondary = ChartColorPalette._internal([
    Color(0xFF1565C0), // Strong blue
    Color(0xFF2E7D32), // Strong green
    Color(0xFFEF6C00), // Strong orange
    Color(0xFFC62828), // Strong red
    Color(0xFF6A1B9A), // Strong purple
    Color(0xFF00838F), // Strong cyan
    Color(0xFFD84315), // Strong deep orange
    Color(0xFF4527A0), // Strong deep purple
  ]);

  // ========== PALETA SEMÁNTICA ==========

  /// Paleta semántica universal (4 colores fijos).
  ///
  /// NO varía entre temas light/dark/highContrast para mantener consistencia
  /// semántica (éxito siempre verde, error siempre rojo, etc.).
  ///
  /// IMPORTANTE: Esta paleta NO sigue Dynamic Color. Los valores son fijos
  /// derivados de SemanticColors para garantizar reconocimiento inmediato.
  ///
  /// Mapeo de índices (documentado también en chart_theme.dart):
  /// - [0] success: métricas positivas, estados ok, incrementos
  /// - [1] warning: alertas, umbrales cerca de límite, cambios pendientes
  /// - [2] error: fallos, métricas críticas, decrementos negativos
  /// - [3] info: datos neutrales, información general, valores de referencia
  static const ChartColorPalette semantic = ChartColorPalette._internal([
    SemanticColors.success,  // Verde
    SemanticColors.warning,  // Naranja/Amarillo
    SemanticColors.error,    // Rojo
    SemanticColors.info,     // Azul
  ]);
}
