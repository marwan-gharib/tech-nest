import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void log(Object message) {
    if (kDebugMode) {
      developer.log("APP LOG::  ${message.toString()}");
    }
  }
}
