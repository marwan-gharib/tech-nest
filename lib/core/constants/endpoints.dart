import 'package:tech_nest/core/constants/app_config.dart';

class Endpoints {
  const Endpoints._();

  static String get baseUrl => "${AppConfig.baseUrl}/tech-nest-backend";

  static String get apiUserBase => '$baseUrl/api/user/';

  static String get signUp => "auth/register.php";
  static String get login => "auth/login.php";
  static String get verifyEmail => "auth/verify_email.php";
  static String get logout => "auth/logout.php";
  static String get forgetPassword => "auth/forget_password.php";
  static String get resetPassword => "auth/reset_password.php";

  static String get productsList => "products/list.php";
  static String get searchingSuggestions =>
      "products/searching_suggestions.php";

  static String get categoriesList => "categories/list.php";

  static String get addToCart => "cart/add.php";
  static String get cartList => "cart/list.php";
  static String get removeFromCart => "cart/remove.php";
  static String get updateItemQuantityFromCart => "cart/update_quantity.php";

  static String get createOrder => "orders/create.php";
  static String get listOrders => "orders/list.php";
  static String get orderDetails => "orders/details.php";
  static String get cancelOrder => "orders/cancel.php";
}
