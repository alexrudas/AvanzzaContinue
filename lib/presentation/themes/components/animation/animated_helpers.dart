// ============================================================================
// components/animation/animated_helpers.dart
// ============================================================================

import 'package:flutter/material.dart';
import '../../foundations/design_system.dart';

/// Helper para aplicar animación fade-in a un widget.
///
/// Respeta [MediaQuery.disableAnimations] para accesibilidad.
/// Si las animaciones están deshabilitadas, retorna el [child] sin animar.
///
/// Parámetros:
/// - [child]: Widget a animar
/// - [duration]: Duración de la animación (default: DS.motion.normal = 250ms)
/// - [curve]: Curva de easing (default: DS.motion.easeInOut)
/// - [delay]: Delay opcional antes de iniciar la animación
///
/// Ejemplo:
/// ```dart
/// fadeIn(
///   duration: DS.motion.normal,
///   curve: DS.motion.easeInOut,
///   delay: DS.motion.fast,
///   child: Text('Hello World'),
/// )
/// ```
Widget fadeIn({
  required Widget child,
  Duration? duration,
  Curve? curve,
  Duration? delay,
}) {
  return Builder(
    builder: (context) {
      if (MediaQuery.of(context).disableAnimations) {
        return child;
      }

      final effectiveDuration = duration ?? DS.motion.normal;
      final effectiveCurve = curve ?? DS.motion.easeInOut;
      final totalDuration = delay != null
          ? Duration(milliseconds: effectiveDuration.inMilliseconds + delay.inMilliseconds)
          : effectiveDuration;

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: totalDuration,
        curve: delay != null
            ? Interval(
                delay.inMilliseconds / totalDuration.inMilliseconds,
                1.0,
                curve: effectiveCurve,
              )
            : effectiveCurve,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        },
        child: child,
      );
    },
  );
}

/// Helper para aplicar animación slide-up a un widget.
///
/// Respeta [MediaQuery.disableAnimations] para accesibilidad.
/// Si las animaciones están deshabilitadas, retorna el [child] sin animar.
///
/// Parámetros:
/// - [child]: Widget a animar
/// - [duration]: Duración de la animación (default: DS.motion.slow = 350ms)
/// - [curve]: Curva de easing (default: DS.motion.easeInOutCubicEmphasized)
/// - [offset]: Píxeles a deslizar desde abajo (default: 50.0)
/// - [delay]: Delay opcional antes de iniciar la animación
///
/// Ejemplo:
/// ```dart
/// slideUp(
///   offset: 50.0,
///   duration: DS.motion.slow,
///   curve: DS.motion.easeInOutCubicEmphasized,
///   child: Card(child: ListTile(title: Text('Item'))),
/// )
/// ```
Widget slideUp({
  required Widget child,
  Duration? duration,
  Curve? curve,
  double offset = 50.0,
  Duration? delay,
}) {
  return Builder(
    builder: (context) {
      if (MediaQuery.of(context).disableAnimations) {
        return child;
      }

      final effectiveDuration = duration ?? DS.motion.slow;
      final effectiveCurve = curve ?? DS.motion.easeInOutCubicEmphasized;
      final totalDuration = delay != null
          ? Duration(milliseconds: effectiveDuration.inMilliseconds + delay.inMilliseconds)
          : effectiveDuration;

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: offset, end: 0.0),
        duration: totalDuration,
        curve: delay != null
            ? Interval(
                delay.inMilliseconds / totalDuration.inMilliseconds,
                1.0,
                curve: effectiveCurve,
              )
            : effectiveCurve,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, value),
            child: child,
          );
        },
        child: child,
      );
    },
  );
}

/// Helper para aplicar animación scale-in a un widget.
///
/// Respeta [MediaQuery.disableAnimations] para accesibilidad.
/// Si las animaciones están deshabilitadas, retorna el [child] sin animar.
///
/// Parámetros:
/// - [child]: Widget a animar
/// - [duration]: Duración de la animación (default: DS.motion.normal = 250ms)
/// - [curve]: Curva de easing (default: DS.motion.easeInOutCubicEmphasized)
/// - [initialScale]: Escala inicial 0.0-1.0 (default: 0.85 = 85%)
/// - [delay]: Delay opcional antes de iniciar la animación
///
/// Ejemplo:
/// ```dart
/// scaleIn(
///   initialScale: 0.85,
///   duration: DS.motion.normal,
///   curve: DS.motion.easeInOutCubicEmphasized,
///   child: FloatingActionButton(
///     onPressed: () {},
///     child: Icon(Icons.add),
///   ),
/// )
/// ```
Widget scaleIn({
  required Widget child,
  Duration? duration,
  Curve? curve,
  double initialScale = 0.85,
  Duration? delay,
}) {
  return Builder(
    builder: (context) {
      if (MediaQuery.of(context).disableAnimations) {
        return child;
      }

      final effectiveDuration = duration ?? DS.motion.normal;
      final effectiveCurve = curve ?? DS.motion.easeInOutCubicEmphasized;
      final totalDuration = delay != null
          ? Duration(milliseconds: effectiveDuration.inMilliseconds + delay.inMilliseconds)
          : effectiveDuration;

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: initialScale, end: 1.0),
        duration: totalDuration,
        curve: delay != null
            ? Interval(
                delay.inMilliseconds / totalDuration.inMilliseconds,
                1.0,
                curve: effectiveCurve,
              )
            : effectiveCurve,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: child,
      );
    },
  );
}

/// Helper para aplicar animación escalonada (staggered) a una lista de widgets.
///
/// Respeta [MediaQuery.disableAnimations] para accesibilidad.
/// Si las animaciones están deshabilitadas, retorna los [children] sin animar.
///
/// Cada elemento aparece con un retraso incremental de [staggerDelay] respecto al anterior.
///
/// Parámetros:
/// - [children]: Lista de widgets a animar
/// - [staggerDelay]: Delay entre cada elemento (default: DS.motion.fast = 150ms)
/// - [animationDuration]: Duración de animación de cada elemento (default: DS.motion.normal = 250ms)
/// - [curve]: Curva de easing (default: DS.motion.easeInOut)
///
/// Ejemplo:
/// ```dart
/// staggeredList(
///   staggerDelay: DS.motion.fast,
///   animationDuration: DS.motion.normal,
///   curve: DS.motion.easeInOut,
///   children: [
///     ListTile(title: Text('Item 1')),
///     ListTile(title: Text('Item 2')),
///     ListTile(title: Text('Item 3')),
///   ],
/// )
/// ```
Widget staggeredList({
  required List<Widget> children,
  Duration? staggerDelay,
  Duration? animationDuration,
  Curve? curve,
}) {
  return Builder(
    builder: (context) {
      if (MediaQuery.of(context).disableAnimations) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      }

      final effectiveStaggerDelay = staggerDelay ?? DS.motion.fast;
      final effectiveAnimationDuration = animationDuration ?? DS.motion.normal;
      final effectiveCurve = curve ?? DS.motion.easeInOut;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(children.length, (index) {
          return fadeIn(
            duration: effectiveAnimationDuration,
            curve: effectiveCurve,
            delay: Duration(milliseconds: effectiveStaggerDelay.inMilliseconds * index),
            child: children[index],
          );
        }),
      );
    },
  );
}

/// Helper para aplicar animación escalonada (staggered) a una lista grande usando builder.
///
/// Respeta [MediaQuery.disableAnimations] para accesibilidad.
/// Si las animaciones están deshabilitadas, retorna los items sin animar.
///
/// Optimizado para grandes volúmenes de datos mediante lazy building.
/// Cada elemento aparece con un retraso incremental de [staggerDelay] respecto al anterior.
///
/// Parámetros:
/// - [itemCount]: Número total de items
/// - [itemBuilder]: Función que construye cada item
/// - [staggerDelay]: Delay entre cada elemento (default: DS.motion.fast = 150ms)
/// - [animationDuration]: Duración de animación de cada elemento (default: DS.motion.normal = 250ms)
/// - [curve]: Curva de easing (default: DS.motion.easeInOut)
///
/// Ejemplo:
/// ```dart
/// staggeredListBuilder(
///   itemCount: 100,
///   staggerDelay: DS.motion.veryFast,
///   animationDuration: DS.motion.normal,
///   itemBuilder: (context, index) {
///     return ListTile(
///       leading: CircleAvatar(child: Text('${index + 1}')),
///       title: Text('Item ${index + 1}'),
///     );
///   },
/// )
/// ```
Widget staggeredListBuilder({
  required int itemCount,
  required Widget Function(BuildContext context, int index) itemBuilder,
  Duration? staggerDelay,
  Duration? animationDuration,
  Curve? curve,
}) {
  return Builder(
    builder: (context) {
      if (MediaQuery.of(context).disableAnimations) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        );
      }

      final effectiveStaggerDelay = staggerDelay ?? DS.motion.fast;
      final effectiveAnimationDuration = animationDuration ?? DS.motion.normal;
      final effectiveCurve = curve ?? DS.motion.easeInOut;

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return fadeIn(
            duration: effectiveAnimationDuration,
            curve: effectiveCurve,
            delay: Duration(milliseconds: effectiveStaggerDelay.inMilliseconds * index),
            child: itemBuilder(context, index),
          );
        },
      );
    },
  );
}
