import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

void customSnackBar(
  BuildContext context, {
  required String message,
  bool isAbove = false,
}) {
  final massenger = ScaffoldMessenger.of(context);

  massenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.all(AppSpacing.md),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: isAbove ? MediaQuery.of(context).size.height * 0.86 : 40,
          left: 30,
          right: 30,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardLg),
        duration: const Duration(seconds: 3),
      ),
      snackBarAnimationStyle: const AnimationStyle(
        duration: Duration(seconds: 1),
        reverseDuration: Duration(seconds: 1),
      ),
    );
}
