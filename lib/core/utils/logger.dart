import 'dart:developer';

class Logger {
  const Logger._();

  static void logg(Object message) {
    log("APP LOG::  ${message.toString()}");
  }
}
