import 'package:flutter/widgets.dart';

import 'package:tech_nest/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
