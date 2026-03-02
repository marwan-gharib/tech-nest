class Routers {
  const Routers._();

  // main routes
  static String get loginScreenPath => "/auth/login";
  static String get signUpScreenPath => "/auth/signUp";
  static String get homeScreenPath => "/home";
  static String get cartScreenPath => "/cartItemsScreen";
  static String get categoriesScreenPath => "/categoriesScreen";

  // child routes
  static String get productDetailsScreen => "productDetails";
}
