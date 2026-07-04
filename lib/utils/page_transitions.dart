import 'package:flutter/material.dart';

/// Custom page transitions for seamless navigation
/// Following update_design.md specifications
class PageTransitions {
  /// Fade transition for smooth screen changes
  static PageRouteBuilder<T> fadeTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Slide transition from right (for forward navigation)
  static PageRouteBuilder<T> slideTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Offset begin = const Offset(1.0, 0.0),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: begin,
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOutCubic));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Scale transition with fade (for camera/result screens)
  static PageRouteBuilder<T> scaleTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleTween = Tween<double>(begin: 0.9, end: 1.0);
        final fadeTween = Tween<double>(begin: 0.0, end: 1.0);

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: ScaleTransition(
            scale: animation.drive(
              scaleTween.chain(CurveTween(curve: Curves.easeOutCubic)),
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Combined slide and fade transition
  static PageRouteBuilder<T> slideAndFadeTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final slideTween = Tween(begin: begin, end: end);
        final fadeTween = Tween<double>(begin: 0.0, end: 1.0);
        
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );

        return SlideTransition(
          position: curvedAnimation.drive(slideTween),
          child: FadeTransition(
            opacity: curvedAnimation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }
}
