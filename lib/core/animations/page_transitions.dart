import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/animations/app_animations.dart';

class PageTransitions {
  const PageTransitions._();

  static CustomTransitionPage fadeTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: AppAnimations.standardCurve,
          ),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage slideTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Offset begin = const Offset(1, 0),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: AppAnimations.standardCurve,
            ),
          ),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage slideUpTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return slideTransition<T>(
      context: context,
      state: state,
      child: child,
      begin: const Offset(0, 0.1),
    );
  }
}
