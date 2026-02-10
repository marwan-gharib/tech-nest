class Endpoints {
  const Endpoints._();

  static String get baseUrl =>
      "https://nonuniteable-uncontradicted-gennie.ngrok-free.dev/tech-nest-backend/";

  static String get signUp => "auth/register.php";
  static String get login => "auth/login.php";
  static String get verifyEmail => "auth/verify_email.php";
  static String get logout => "auth/logout.php";
  static String get socialLogin => "auth/social_login.php";
  static String get resetPassword => "auth/reset_password.php";

  static String get productsList => "products/list.php";

  static String get categoriesList => "categories/list.php";

  static String get addToCart => "cart/add.php";
  static String get removeFromCart => "cart/remove.php";
  static String get cartList => "cart/list.php";
  static String get updateItemQuantityFromCart => "cart/update_quantity.php";
}
