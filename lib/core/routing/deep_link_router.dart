import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/utils/logger.dart';

/// Strategy Interface for handling deep links
abstract class DeepLinkRouter {
  /// Validates and navigates to the given route string
  void navigate(String route, {bool isGo = false});
}

/// Concrete Strategy that uses GoRouter for navigation
class GoRouterDeepLinkStrategy implements DeepLinkRouter {
  final GoRouter _router;

  GoRouterDeepLinkStrategy({required GoRouter router}) : _router = router;

  @override
  void navigate(String route, {bool isGo = false}) {
    if (_isValidRoute(route)) {
      AppLogger.info('DeepLinkRouter: Navigating to $route');
      if (isGo) {
        _router.go(route);
      } else {
        _router.push(route);
      }
    } else {
      AppLogger.warning('DeepLinkRouter: Invalid route format ($route). Falling back to home.');
      _router.push('/');
    }
  }

  bool _isValidRoute(String route) {
    return route.isNotEmpty && route.startsWith('/');
  }
}
