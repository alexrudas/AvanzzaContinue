// ============================================================================
// theme_module.dart
// ============================================================================
//
// QUÉ ES:
//   Barrel export del módulo completo de theming UI PRO 2025.
//
// DÓNDE SE IMPORTA:
//   - Cualquier archivo que necesite acceso al design system
//
// USO ESPERADO:
//   import 'package:avanzza/presentation/themes/theme_module.dart';
//
//   // Acceso a DS
//   Container(padding: DS.insetsAll(DS.spacing.md))
//
//   // Acceso a presets
//   MaterialApp(theme: lightTheme, darkTheme: darkTheme)
//
//   // Acceso a ThemeManager
//   final manager = ThemeManager();
//
// ============================================================================

// Tokens
export 'tokens/primitives.dart';
export 'tokens/semantic.dart';
export 'tokens/motion.dart';
export 'tokens/elevation.dart';
export 'tokens/typography.dart';

// Foundations
export 'foundations/typography.dart';
export 'foundations/color_schemes.dart';
export 'foundations/design_system.dart';
export 'foundations/theme_extensions.dart';

// Components - Material
export 'components/material/buttons.dart';
export 'components/material/inputs.dart';
export 'components/material/cards.dart';
export 'components/material/navigation.dart';
export 'components/material/surfaces.dart';

// Components - Chart
export 'components/chart/chart_theme.dart';
export 'components/chart/chart_presets.dart';

// Components - Animation
export 'components/animation/page_transitions.dart';
export 'components/animation/animated_helpers.dart';

// Components - Custom (Loading)
export 'components/custom/loading_theme.dart';

// Presets
export 'presets/light_theme.dart';
export 'presets/dark_theme.dart';
export 'presets/high_contrast_theme.dart';

// Theme Manager
export 'theme_manager.dart';
