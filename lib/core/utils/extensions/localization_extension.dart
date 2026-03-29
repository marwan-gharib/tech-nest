import 'package:flutter/material.dart';

extension LocalizationExtension on BuildContext {
  _L10n get l10n => const _L10n();
}

class _L10n {
  const _L10n();
  
  String get errorNoInternetConnection => "No Internet Connection";
  String get errorRequestFailed => "Request Failed";
  String get actionRetry => "Retry";
}
