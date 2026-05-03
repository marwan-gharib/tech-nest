import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void log(Object message) {
    if (kDebugMode) {
      developer.log("APP LOG::  ${message.toString()}");
    }
  }

  static void info(Object message) {
    if (kDebugMode) {
      developer.log("INFO::  ${message.toString()}");
    }
  }

  static void warning(Object message) {
    if (kDebugMode) {
      developer.log("WARNING::  ${message.toString()}");
    }
  }

  static void error(Object message) {
    if (kDebugMode) {
      developer.log("ERROR::  ${message.toString()}");
    }
  }
}
