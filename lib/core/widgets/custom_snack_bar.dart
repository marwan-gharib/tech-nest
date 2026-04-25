import 'package:flutter/material.dart';
import 'package:tech_nest/core/error/failures/cache_failure.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class CustomSnackBar {
  const CustomSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    bool isAbove = false,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
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
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          padding: const EdgeInsets.all(AppSpacing.md),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: isAbove
                ? MediaQuery.of(context).size.height * 0.86
                : AppSpacing.xxl,
            left: AppSpacing.xl,
            right: AppSpacing.xl,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardLg),
          duration: const Duration(seconds: 3),
        ),
        snackBarAnimationStyle: const AnimationStyle(
          duration: Duration(seconds: 1),
          reverseDuration: Duration(seconds: 1),
        ),
      );
  }

  static void showError(
    BuildContext context, {
    required Failure failure,
    bool isAbove = false,
  }) {
    final t = context.t;
    String message = failure.message;

    if (failure is NetworkFailure) {
      message = t.errors.noInternet;
    } else if (failure is CacheFailure) {
      message = t.errors.cacheError;
    } else if (failure is ServerFailure || failure is UnknownFailure) {
      if (failure.message.isEmpty ||
          failure.message == "An unexpected error occurred. Please try again.") {
        message = t.errors.unknownError;
      }
    }

    show(context, message: message, isAbove: isAbove);
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    bool isAbove = false,
  }) {
    show(context, message: message, isAbove: isAbove);
  }
}
