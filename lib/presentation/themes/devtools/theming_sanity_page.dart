// ============================================================================
// devtools/theming_sanity_page.dart
// ============================================================================
//
// QUÉ ES:
//   Página de desarrollo para validar visual y funcionalmente todos los
//   componentes del sistema de themes. Incluye demos de:
//   - Charts (SemiCircularGaugeChart, SimpleBarChart)
//   - Color schemes (paletas light/dark/high contrast)
//   - Typography (estilos de texto estándar y numéricos)
//   - Material components (botones, cards, inputs)
//
// DÓNDE SE USA:
//   - Solo en desarrollo (debug builds)
//   - Acceso vía ruta de devtools o menú de depuración
//
// CARACTERÍSTICAS:
//   ✅ Demos interactivos de todos los componentes temáticos
//   ✅ Soporta cambio de tema en tiempo real
//   ✅ Ejemplos prácticos de uso de AppChartTheme
//   ✅ Validación visual de accesibilidad (contraste WCAG AAA)
//
// CÓMO USAR:
//   1. En debug builds, navegar a /theming-sanity
//   2. Cambiar entre light/dark/high contrast para validar
//   3. Verificar que todos los componentes renderizen correctamente
//   4. Validar animaciones y transiciones
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/chart/semi_circular_gauge_chart.dart';
import '../components/chart/simple_bar_chart.dart';
import '../components/material/inputs.dart';
import '../components/material/badge.dart';
import '../foundations/design_system.dart';
import '../foundations/theme_extensions.dart';
import '../presets/dark_theme.dart';
import '../presets/high_contrast_theme.dart';
import '../presets/light_theme.dart';

/// Página de sanity check para validar todos los componentes del sistema de themes.
///
/// NOTA: Esta página es solo para desarrollo y debugging.
/// No debe ser accesible en producción.
class ThemingSanityPage extends StatelessWidget {
  const ThemingSanityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = DS.scheme(context);
    final textTheme = DS.text(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Theme System Sanity Check',
          style: textTheme.titleLarge?.copyWith(
            color: scheme.onSurface,
          ),
        ),
        backgroundColor: scheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === SECTION: Charts ===
            const _SectionHeader(title: 'Charts'),
            const SizedBox(height: 16.0),

            // Demo 1: SemiCircularGaugeChart
            const _DemoCard(
              title: 'SemiCircularGaugeChart',
              description:
                  'Gauge semicircular con semáforo de color para KPIs presupuestarios.',
              child: SemiCircularGaugeChart(
                maxValue: 100000,
                value: 86500,
                title: 'Presupuesto Gastos',
                subtitle: '€ 100.000',
                footerLabel: 'Diferencia',
                footerValueAbs: -13500,
              ),
            ),

            const SizedBox(height: 24.0),

            // Demo 2: SimpleBarChart (Vertical)
            _DemoCard(
              title: 'SimpleBarChart (Vertical)',
              description:
                  'Gráfico de barras vertical con normalización automática.',
              child: SizedBox(
                height: 250,
                child: SimpleBarChart(
                  data: const [
                    BarEntry(label: 'Ene', value: 12),
                    BarEntry(label: 'Feb', value: 18),
                    BarEntry(label: 'Mar', value: 9),
                    BarEntry(label: 'Abr', value: 15),
                  ],
                  direction: Axis.vertical,
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // Demo 3: SimpleBarChart (Horizontal)
            _DemoCard(
              title: 'SimpleBarChart (Horizontal)',
              description:
                  'Gráfico de barras horizontal con normalización automática.',
              child: SizedBox(
                height: 116,
                child: SimpleBarChart(
                  data: const [
                    BarEntry(label: 'Ventas', value: 45),
                    BarEntry(label: 'Marketing', value: 30),
                    BarEntry(label: 'Operaciones', value: 60),
                    BarEntry(label: 'Desarrollo', value: 25),
                  ],
                  direction: Axis.horizontal,
                ),
              ),
            ),

            const SizedBox(height: 32.0),

            // === SECTION: Color Scheme ===
            const _SectionHeader(title: 'Color Scheme'),
            const SizedBox(height: 16.0),

            _DemoCard(
              title: 'ColorScheme Preview',
              description: 'Principales colores del tema activo.',
              child: Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: [
                  _ColorSwatch(label: 'Primary', color: scheme.primary),
                  _ColorSwatch(label: 'Secondary', color: scheme.secondary),
                  _ColorSwatch(label: 'Tertiary', color: scheme.tertiary),
                  _ColorSwatch(label: 'Error', color: scheme.error),
                  _ColorSwatch(label: 'Surface', color: scheme.surface),
                  _ColorSwatch(label: 'Background', color: scheme.surface),
                ],
              ),
            ),

            const SizedBox(height: 32.0),

            // === SECTION: Buttons ===
            const _SectionHeader(title: 'Buttons'),
            const SizedBox(height: 16.0),

            _DemoCard(
              title: 'Material 3 Button Styles',
              description: 'Elevated, Filled, Outlined y Text buttons.',
              child: Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Elevated'),
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Filled'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Text'),
                  ),
                  const ElevatedButton(
                    onPressed: null,
                    child: Text('Disabled'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32.0),

            // === SECTION: Inputs ===
            const _SectionHeader(title: 'Text Inputs'),
            const SizedBox(height: 16.0),

            _DemoCard(
              title: 'TextField States (Theme Default)',
              description: 'Estados derivados del InputDecorationTheme global.',
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Normal State',
                      hintText: 'Enter text',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Error State',
                      hintText: 'Invalid input',
                      errorText: 'Este campo es requerido',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    readOnly: true,
                    decoration: AppInputThemes.readOnlyDecoration(
                      context,
                      label: 'ReadOnly State',
                      hint: 'No editable',
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    decoration: AppInputThemes.compact(
                      context,
                      label: 'Compact Mode',
                      hint: 'Dense padding',
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32.0),

            // === SECTION: Badges ===
            const _SectionHeader(title: 'Badges & Chips'),
            const SizedBox(height: 16.0),

            _DemoCard(
              title: 'Badge Tones (Semantic)',
              description: 'Badges con tonos semánticos derivados de ColorScheme.',
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: const [
                  BadgePro(label: 'Neutral', tone: BadgeTone.neutral),
                  BadgePro(label: 'Info', tone: BadgeTone.info),
                  BadgePro(label: 'Success', tone: BadgeTone.success),
                  BadgePro(label: 'Warning', tone: BadgeTone.warning),
                  BadgePro(label: 'Error', tone: BadgeTone.error),
                  BadgePro(label: 'Primary', tone: BadgeTone.primary),
                  BadgePro(label: 'Secondary', tone: BadgeTone.secondary),
                ],
              ),
            ),

            const SizedBox(height: 24.0),

            _DemoCard(
              title: 'Badge Variants',
              description: 'Con íconos, modo dense y casos de uso.',
              child: Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: const [
                  // Con ícono
                  BadgePro.icon(
                    label: '3',
                    icon: Icons.notifications,
                    tone: BadgeTone.warning,
                  ),
                  BadgePro.icon(
                    label: '12',
                    icon: Icons.mail,
                    tone: BadgeTone.primary,
                  ),
                  // Dense mode
                  BadgePro(label: 'Activo', tone: BadgeTone.success, dense: true),
                  BadgePro(label: 'Pendiente', tone: BadgeTone.warning, dense: true),
                  BadgePro(label: 'Vencido', tone: BadgeTone.error, dense: true),
                  // Uso real
                  BadgePro(label: 'En Mantenimiento', tone: BadgeTone.info),
                  BadgePro(label: 'Nuevo', tone: BadgeTone.primary),
                  BadgePro(label: 'Vendido', tone: BadgeTone.neutral),
                ],
              ),
            ),

            const SizedBox(height: 32.0),

            // === SECTION: Cards ===
            const _SectionHeader(title: 'Cards & Elevations'),
            const SizedBox(height: 16.0),

            _DemoCard(
              title: 'Card Variants',
              description: 'Diferentes elevaciones y tonal surfaces.',
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: scheme.surfaceContainerLowest,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Elevation 0 - Surface Container Lowest',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Card(
                    elevation: 2,
                    color: scheme.surfaceContainerLow,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Elevation 2 - Surface Container Low',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Card(
                    elevation: 4,
                    color: scheme.surfaceContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Elevation 4 - Surface Container',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32.0),

            // === SECTION: Typography ===
            const _SectionHeader(title: 'Typography'),
            const SizedBox(height: 16.0),

            _DemoCard(
              title: 'Text Styles',
              description: 'Roles tipográficos de Material 3.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Display Large', style: textTheme.displayLarge),
                  const SizedBox(height: 8.0),
                  Text('Headline Medium', style: textTheme.headlineMedium),
                  const SizedBox(height: 8.0),
                  Text('Title Large', style: textTheme.titleLarge),
                  const SizedBox(height: 8.0),
                  Text('Body Large', style: textTheme.bodyLarge),
                  const SizedBox(height: 8.0),
                  Text('Label Medium', style: textTheme.labelMedium),
                ],
              ),
            ),

            const SizedBox(height: 32.0),

            // === SECTION: Number Typography (KPIs) ===
            const _SectionHeader(title: 'Number Typography (KPIs)'),
            const SizedBox(height: 16.0),

            _DemoCard(
              title: 'Numeric Styles',
              description:
                  'Tipografía optimizada para valores monetarios y KPIs.',
              child: Builder(
                builder: (context) {
                  final numTypography =
                      Theme.of(context).extension<NumberTypographyExtension>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('€ 1,234,567', style: numTypography?.numberXXXL),
                      const SizedBox(height: 8.0),
                      Text('€ 456,789', style: numTypography?.numberXXL),
                      const SizedBox(height: 8.0),
                      Text('€ 98,765', style: numTypography?.numberXL),
                      const SizedBox(height: 8.0),
                      Text('€ 12,345', style: numTypography?.numberLG),
                      const SizedBox(height: 8.0),
                      Text('€ 2,468', style: numTypography?.numberMD),
                      const SizedBox(height: 8.0),
                      Text('€ 123', style: numTypography?.numberSM),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 32.0),

            // === SECTION: Gradients ===
            const _SectionHeader(title: 'Gradients'),
            const SizedBox(height: 16.0),

            _DemoCard(
              title: 'Theme Gradients',
              description: 'Gradientes derivados del ColorScheme activo.',
              child: Builder(
                builder: (context) {
                  final customExt =
                      Theme.of(context).extension<CustomThemeExtension>();
                  return Column(
                    children: [
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: customExt?.primaryGradient,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'Primary Gradient',
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: customExt?.accentGradient,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'Accent Gradient',
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 24.0),

            // === FOOTER ===
            const SizedBox(height: 32.0),
            Center(
              child: Text(
                '✅ Theme System v2.1.0',
                style: textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
      // === FAB PARA CAMBIAR TEMA ===
      floatingActionButton: _ThemeSwitcherFAB(),
    );
  }
}

/// FAB para cambiar entre Light, Dark y High Contrast themes.
class _ThemeSwitcherFAB extends StatefulWidget {
  @override
  State<_ThemeSwitcherFAB> createState() => _ThemeSwitcherFABState();
}

class _ThemeSwitcherFABState extends State<_ThemeSwitcherFAB> {
  int _currentThemeIndex = 0;
  final List<String> _themeNames = ['Light', 'Dark', 'High Contrast'];
  final List<ThemeData> _themes = [lightTheme, darkTheme, highContrastTheme];

  void _switchTheme() {
    setState(() {
      _currentThemeIndex = (_currentThemeIndex + 1) % _themes.length;
    });
    Get.changeTheme(_themes[_currentThemeIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _switchTheme,
      icon: const Icon(Icons.palette),
      label: Text(_themeNames[_currentThemeIndex]),
      tooltip: 'Cambiar tema (Light/Dark/High Contrast)',
    );
  }
}

/// Widget para encabezado de sección.
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final scheme = DS.scheme(context);
    final textTheme = DS.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          color: scheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Widget para tarjeta de demo con título y descripción.
class _DemoCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const _DemoCard({
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = DS.scheme(context);
    final textTheme = DS.text(context);

    return Card(
      elevation: 2.0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del demo
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4.0),

            // Descripción
            Text(
              description,
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16.0),

            // Contenido del demo
            child,
          ],
        ),
      ),
    );
  }
}

/// Widget para muestra de color (swatch).
class _ColorSwatch extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorSwatch({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = DS.text(context);
    final scheme = DS.scheme(context);

    // Determinar si usar texto blanco o negro basado en luminancia del color
    final textColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: scheme.outline.withValues(alpha: 0.3),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              '#${color.a.toInt().toRadixString(16).padLeft(2, '0')}${color.r.toInt().toRadixString(16).padLeft(2, '0')}${color.g.toInt().toRadixString(16).padLeft(2, '0')}${color.b.toInt().toRadixString(16).padLeft(2, '0')}'
                  .substring(2)
                  .toUpperCase(),
              style: textTheme.labelSmall?.copyWith(
                color: textColor,
                fontSize: 10.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }
}
