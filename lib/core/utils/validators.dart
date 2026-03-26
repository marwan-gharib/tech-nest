import 'package:email_validator/email_validator.dart';

class Validators {
  const Validators._();

  static String? fullNameValidator(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "Please enter your name";
      }
      if (value.trim().split(" ").length != 2) {
        return "Name must be first and last name separation by space";
      }
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email address";
    } else if (!EmailValidator.validate(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    } else if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  static String? confirmPasswordValidator(
    String? value, {
    required String password,
  }) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    } else if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }
}
