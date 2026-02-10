class Endpoints {
  const Endpoints._();

  static String get baseUrl => "http://192.168.1.13/";

  static String get signUp => "auth/register.php";
  static String get login => "auth/login.php";
  static String get verifyEmail => "auth/verify_email.php";
  static String get logout => "auth/logout.php";
  static String get socialLogin => "auth/social_login.php";

  static String get productsList => "products/list.php";

  static String get categoriesList => "categories/list.php";

  static String get addToCart => "cart/add.php";
  static String get removeFromCart => "cart/remove.php";
  static String get cartList => "cart/list.php";
  static String get updateItemQuantityFromCart => "cart/update_quantity.php";
}
