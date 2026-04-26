import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/extensions/app_colors_extension.dart';

extension ThemeContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  AppColorsExtension get colors => theme.extension<AppColorsExtension>()!;
}
