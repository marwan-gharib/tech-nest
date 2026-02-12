import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  String? _googleId;

  String? get googleId => _googleId;

  bool _initialized = false;

  Future<void> _init() async {
    try {
      if (_initialized) return;
      await _googleSignIn.initialize().then((value) => _initialized = true);
    } catch (e) {
      log('Google Initialization failed: ${e.toString()}');
    }
  }

  Future<void> signIn() async {
    await _init();
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      _googleId = googleUser.id;
      log('User Google ID: $_googleId');

      log('Display Name: ${googleUser.displayName}');
      log('Email: ${googleUser.email}');
      log('Photo URL: ${googleUser.photoUrl}');
    } catch (e) {
      log('Google Sign-In failed: ${e.toString()}');
    }
  }
}
