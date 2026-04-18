import 'package:flutter/foundation.dart';

// Note: This is a ChangeNotifier instead of a Cubit because GoRouter's
// refreshListenable requires a Listenable object to trigger redirects.
class AuthNotifier extends ChangeNotifier {
  bool _isAuth = false;

  bool get isAuth => _isAuth;

  void login() {
    _isAuth = true;
    notifyListeners();
  }

  void logout() {
    _isAuth = false;
    notifyListeners();
  }
}
