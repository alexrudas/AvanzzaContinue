// ============================================================================
// tokens/motion.dart
// ============================================================================
//
// QUÉ ES:
//   Define tokens de animación y transiciones: duraciones estándar y curvas
//   de easing para movimiento consistente en toda la aplicación.
//
// DÓNDE SE IMPORTA:
//   - foundations/design_system.dart (DS.motion expone estos valores)
//   - Componentes animados (PageRoute, transiciones, loaders)
//   - Widgets con estados interactivos (botones, drawers, modales)
//
// QUÉ NO HACE:
//   - NO contiene widgets animados ni AnimationController
//   - NO define animaciones específicas de componentes (esas van en components/)
//   - NO tiene helpers con lógica (ver design_system.dart para MotionHelpers)
//
// USO ESPERADO:
//   // Consumo recomendado vía DS wrapper
//   AnimatedContainer(
//     duration: DS.motion.normal,
//     curve: DS.motion.easeOut,
//   )
//
//   // Acceso directo en transiciones
//   import 'package:avanzza/presentation/themes/tokens/motion.dart';
//   PageRouteBuilder(
//     transitionDuration: MotionDurations.normal,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return FadeTransition(
//         opacity: animation.drive(CurveTween(curve: MotionCurves.easeOut)),
//         child: child,
//       );
//     },
//   )
//
// ============================================================================

import 'package:flutter/animation.dart';

/// Duraciones estándar de animaciones y transiciones.
/// Alineadas con Material Motion System (Material 3).
abstract class MotionDurations {
  MotionDurations._();

  /// Duración muy rápida (100ms): micro-interacciones mínimas.
  /// Uso: cambios de color sutiles, ripple inicial, hover feedback mínimo.
  static const Duration veryFast = Duration(milliseconds: 100);

  /// Duración rápida (150ms): micro-interacciones, hover, pressed.
  /// Uso: feedback inmediato en botones, cambios de color, ripples.
  static const Duration fast = Duration(milliseconds: 150);

  /// Duración normal (250ms): transiciones estándar, slide, fade.
  /// Uso: navegación entre vistas, modales, drawers, expansión de paneles.
  static const Duration normal = Duration(milliseconds: 250);

  /// Duración lenta (350ms): transiciones complejas, animaciones grandes.
  /// Uso: page transitions elaboradas, animaciones hero, transformaciones grandes.
  static const Duration slow = Duration(milliseconds: 350);

  /// Duración extra lenta (500ms): animaciones enfáticas o ilustrativas.
  /// Uso: onboarding, animaciones de celebración, cambios estructurales mayores.
  static const Duration verySlow = Duration(milliseconds: 500);

  /// Sin duración (0ms): cambios instantáneos sin animación.
  /// Uso: casos edge donde la animación degrada UX (ej: scroll durante drag).
  static const Duration instant = Duration.zero;
}

/// Curvas de easing para animaciones naturales.
/// Basadas en Material Motion y principios de física perceptual.
abstract class MotionCurves {
  MotionCurves._();

  /// Ease In: aceleración gradual desde reposo.
  /// Uso: elementos que SALEN de pantalla (exit animations).
  /// Ejemplo: drawer cerrándose, modal desapareciendo.
  static const Curve easeIn = Curves.easeIn;

  /// Ease Out: desaceleración gradual hacia reposo.
  /// Uso: elementos que ENTRAN a pantalla (enter animations).
  /// Ejemplo: drawer abriéndose, modal apareciendo, snackbar subiendo.
  static const Curve easeOut = Curves.easeOut;

  /// Ease In Out: aceleración al inicio y desaceleración al final.
  /// Uso: transiciones bidireccionales, cambios de estado simétricos.
  /// Ejemplo: page transitions, fade in/out, expansión/contracción.
  static const Curve easeInOut = Curves.easeInOut;

  /// Ease In Out Cubic: versión más suave de easeInOut (recomendada M3).
  /// Uso: transiciones principales de navegación, cambios de layout.
  static const Curve easeInOutCubic = Curves.easeInOutCubic;

  /// Ease In Out Cubic Emphasized: curva enfática M3 2025 (más energética).
  /// Uso: navegación principal, transiciones hero, cambios de modo (light/dark).
  static const Curve easeInOutCubicEmphasized = Curves.easeInOutCubicEmphasized;

  /// Linear: sin aceleración (velocidad constante).
  /// Uso: loaders circulares, progress bars, animaciones mecánicas.
  /// EVITAR: en animaciones de entrada/salida (se ve robótico).
  static const Curve linear = Curves.linear;

  /// Fast Out Slow In: Material standard (rápido al salir, lento al entrar).
  /// Uso: transición recomendada por defecto en Material 3.
  /// Ejemplo: navegación push/pop, expansión de FAB a screen.
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  /// Elastic: rebote al final (spring physics).
  /// EXPERIMENTAL: puede ser molesto si se abusa, usar con moderación.
  /// Uso: animaciones playful, feedback enfático en gestos no críticos.
  static const Curve elastic = Curves.elasticOut;

  /// Decelerate: desaceleración más marcada (Material legacy).
  /// Uso: compatibilidad con Material 2, scroll physics.
  static const Curve decelerate = Curves.decelerate;
}

/// Configuraciones de animaciones específicas por tipo de transición.
/// Combinaciones pre-diseñadas de duración + curva para casos comunes.
abstract class MotionPresets {
  MotionPresets._();

  /// Feedback interactivo (hover, pressed, focus).
  static const Duration feedbackDuration = MotionDurations.fast;
  static const Curve feedbackCurve = MotionCurves.easeOut;

  /// Navegación entre páginas (push, pop) - M3 2025 emphasized.
  static const Duration navigationDuration = MotionDurations.normal;
  static const Curve navigationCurve = MotionCurves.easeInOutCubicEmphasized;

  /// Modales y overlays (dialogs, bottom sheets).
  static const Duration overlayDuration = MotionDurations.normal;
  static const Curve overlayEnterCurve = MotionCurves.easeOut;
  static const Curve overlayExitCurve = MotionCurves.easeIn;

  /// Expansión/colapso (expansion tiles, accordions).
  static const Duration expansionDuration = MotionDurations.normal;
  static const Curve expansionCurve = MotionCurves.easeInOutCubicEmphasized;

  /// Fade in/out (opacity transitions).
  static const Duration fadeDuration = MotionDurations.fast;
  static const Curve fadeCurve = MotionCurves.easeInOut;
}
