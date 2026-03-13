// ============================================================================
// lib/core/theme/radius.dart
// APP RADIUS — Design System Avanzza
//
// Escala de border-radius estándar del proyecto.
// Usar siempre estas constantes. Nunca hardcodear valores.
// ============================================================================

/// Escala de border-radius estándar de Avanzza.
class AppRadius {
  /// 4 dp — elementos muy pequeños (chips micro, badges)
  static const double xs = 4;

  /// 8 dp — elementos pequeños (chips, tags, pills)
  static const double sm = 8;

  /// 12 dp — botones, inputs, cards compactos
  static const double md = 12;

  /// 16 dp — cards estándar, modales pequeños
  static const double lg = 16;

  /// 24 dp — cards grandes, bottom sheets, overlays
  static const double xl = 24;

  /// 999 dp — elementos completamente circulares (avatares, FAB)
  static const double full = 999;
}
