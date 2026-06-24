class RouteNames {
  const RouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String signUp = 'signUp';
  static const String onboarding = 'onboarding';
  static const String home = 'home';
  static const String cart = 'cart';
  static const String categories = 'categories';
  static const String productDetails = 'productDetails';
  static const String settings = 'settings';
  static const String orders = 'orders';
  static const String orderDetails = 'orderDetails';
  static const String checkout = 'checkout';
  static const String locationPicker = 'locationPicker';
  static const String notifications = 'notifications';
}

class RoutePaths {
  const RoutePaths._();

  static const String splash = "/";
  static const String login = "/login";
  static const String signUp = "/auth/signUp";
  static const String onboarding = "/onboarding";
  static const String home = "/home";
  static const String cart = "/cartItems";
  static const String categories = "/categories";
  static const String productDetails = "/product/:id";
  static const String settings = "/settings";
  static const String orders = "/orders";
  static const String orderDetails = "/order/:id";
  static const String checkout = "checkout";
  static const String locationPicker = "locationPicker";
  static const String notifications = "/notifications";
}
