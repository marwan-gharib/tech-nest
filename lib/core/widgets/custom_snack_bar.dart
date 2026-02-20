import 'package:flutter/material.dart';

ScaffoldFeatureController customSnackBar(
  BuildContext context, {
  required String message,
  bool isAbove = false,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
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
      padding: const EdgeInsets.all(15),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: isAbove ? MediaQuery.of(context).size.height * 0.86 : 40,
        left: 30,
        right: 30,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      duration: const Duration(seconds: 3),
    ),
    snackBarAnimationStyle: const AnimationStyle(
      duration: Duration(seconds: 1),
      reverseDuration: Duration(seconds: 1),
    ),
  );
}
