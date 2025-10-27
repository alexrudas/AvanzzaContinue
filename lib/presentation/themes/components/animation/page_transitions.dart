// ============================================================================
// components/animation/page_transitions.dart
// ============================================================================

import 'package:flutter/material.dart';
import '../../foundations/design_system.dart';

class _FadeScalePageTransitionsBuilder extends PageTransitionsBuilder {
  const _FadeScalePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: DS.motion.navigationCurve,
      reverseCurve: DS.motion.navigationCurve.flipped,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1.0).animate(curvedAnimation),
        child: child,
      ),
    );
  }
}

abstract class AppPageTransitions {
  AppPageTransitions._();

  static const PageTransitionsTheme theme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: _FadeScalePageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: _FadeScalePageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: _FadeScalePageTransitionsBuilder(),
      TargetPlatform.fuchsia: _FadeScalePageTransitionsBuilder(),
    },
  );
}
