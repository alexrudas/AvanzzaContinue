// ============================================================================
// tokens/semantic.dart
// ============================================================================
//
// QUÉ ES:
//   Define tokens semánticos derivados de primitivas: colores de estado
//   (success, warning, info), espaciado contextual (paddingScreen, gaps),
//   y estados de interacción (hover, pressed, disabled, focused).
//
// DÓNDE SE IMPORTA:
//   - foundations/design_system.dart (DS.semantic expone estos valores)
//   - Componentes que necesiten colores/estados semánticos específicos
//   - Páginas que usen spacing contextual (paddingScreen)
//
// QUÉ NO HACE:
//   - NO contiene ThemeData ni ColorScheme (esos están en presets/)
//   - NO tiene widgets ni lógica de estado dinámico
//   - NO reemplaza ColorScheme.primary/secondary (esos vienen de color_schemes.dart)
//
// USO ESPERADO:
//   // Consumo recomendado vía DS wrapper
//   final successColor = DS.semantic.success;
//   final padding = DS.semantic.paddingScreen;
//   final hoverOpacity = DS.semantic.hoverOpacity;
//
//   // Ejemplo en widget
//   Container(
//     color: DS.semantic.success,
//     padding: EdgeInsets.all(DS.semantic.paddingScreen),
//   )
//
// ============================================================================

import 'package:flutter/material.dart';
import 'primitives.dart';

/// Colores semánticos para estados y feedback visual.
/// Derivados de primitivas para consistencia con el brand.
abstract class SemanticColors {
  SemanticColors._();

  /// Color de éxito (operaciones completadas, validaciones correctas).
  /// Derivado de secondary para mantener coherencia con paleta base.
  static const Color success = ColorPrimitives.secondary;

  /// Color de advertencia (situaciones que requieren atención pero no son errores).
  /// Derivado de tertiary.
  static const Color warning = ColorPrimitives.tertiary;

  /// Color informativo (mensajes neutrales, ayudas contextuales).
  /// Derivado de primary para mantener jerarquía visual.
  static const Color info = ColorPrimitives.primary;

  /// Color de error (derivado de primitivas para simetría con errorLight).
  static const Color error = ColorPrimitives.error;

  /// Variantes light para contenedores/backgrounds de estados (tonos suaves).
  /// NOTA: Estos son colores "contenedor" semánticos, NO reemplazan ColorScheme.surfaceContainer*.
  /// TODO: Derivar dinámicamente con tonal palettes si más adelante usas Dynamic Color.
  /// Por ahora son constantes para performance y compatibilidad con tema estático.
  static const Color successLight = Color(0xFFE8F5E9); // Green 50
  static const Color warningLight = Color(0xFFFFF3E0); // Orange 50
  static const Color infoLight = Color(0xFFE3F2FD); // Blue 50
  static const Color errorLight = Color(0xFFFFEBEE); // Red 50
}

/// Espaciado semántico contextual (derivado de primitivas con semántica).
/// Usado para layouts consistentes en toda la app.
abstract class SemanticSpacing {
  SemanticSpacing._();

  /// Padding horizontal estándar de pantalla (bordes laterales).
  /// Recomendado: usar en Scaffold body, Card margins, etc.
  static const double paddingScreen = SpacingPrimitives.md; // 16.0

  /// Separación vertical estándar entre pantallas en scroll views.
  static const double paddingVertical = SpacingPrimitives.lg; // 24.0

  /// Gap pequeño entre elementos relacionados (ej: icon + label en botón).
  static const double gapSmall = SpacingPrimitives.xs; // 8.0

  /// Gap mediano entre secciones o grupos de widgets.
  static const double gapMedium = SpacingPrimitives.md; // 16.0

  /// Gap grande entre secciones principales de pantalla.
  static const double gapLarge = SpacingPrimitives.lg; // 24.0

  /// Margen mínimo para elementos touch según Material Design (48x48 dp).
  static const double minTouchTarget = 48.0;
}

/// Estados de interacción UI (opacidades, flags).
/// Usado para efectos hover, pressed, disabled en componentes.
/// Duración de transiciones sincronizada con DS.motion.fast (150ms).
abstract class InteractionStates {
  InteractionStates._();

  /// Opacidad para estado hover (mouse sobre elemento interactivo).
  /// Aplicar tinte sobre surface: Color.alphaBlend(tint.withOpacity(hoverOpacity), surface).
  static const double hoverOpacity = 0.08;

  /// Opacidad para estado pressed (tap activo).
  static const double pressedOpacity = 0.12;

  /// Opacidad para estado focused (elemento con foco de teclado).
  static const double focusedOpacity = 0.12;

  /// Opacidad para estado disabled (elemento no interactivo).
  /// Aplicar onSurface sobre surface: Color.alphaBlend(onSurface.withOpacity(disabledOpacity), surface).
  static const double disabledOpacity = 0.38;

  /// Opacidad para dividers y bordes sutiles.
  static const double dividerOpacity = 0.12;
}

/// Overlay de estado (colores superpuestos para feedback visual).
/// Material 3 usa estos overlays sobre surface colors.
/// IMPORTANTE: surface es el color base (background), tint es el color del estado.
abstract class StateOverlay {
  StateOverlay._();

  /// Crear color overlay para estado hover.
  /// Uso: StateOverlay.hover(Colors.white, theme.colorScheme.primary)
  /// → surface + overlay de primary con opacity de hover.
  static Color hover(Color surface, Color tint) {
    return Color.alphaBlend(
      tint.withValues(alpha: InteractionStates.hoverOpacity),
      surface,
    );
  }

  /// Crear color overlay para estado pressed.
  static Color pressed(Color surface, Color tint) {
    return Color.alphaBlend(
      tint.withValues(alpha: InteractionStates.pressedOpacity),
      surface,
    );
  }

  /// Crear color overlay para estado focused.
  static Color focused(Color surface, Color tint) {
    return Color.alphaBlend(
      tint.withValues(alpha: InteractionStates.focusedOpacity),
      surface,
    );
  }

  /// Crear color disabled (mezclar onSurface sobre surface con opacidad reducida).
  /// Material 3: elementos disabled muestran onSurface al 38% sobre surface.
  static Color disabled(Color surface, Color onSurface) {
    return Color.alphaBlend(
      onSurface.withValues(alpha: InteractionStates.disabledOpacity),
      surface,
    );
  }
}
