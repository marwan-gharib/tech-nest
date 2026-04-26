import 'package:flutter/material.dart';
import 'package:tech_nest/core/error/failures/cache_failure.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class RemoteDataFailureView extends StatelessWidget {
  const RemoteDataFailureView({
    required this.failure,
    required this.onRetry,
    this.titleOverride,
    this.compact = false,
    super.key,
  });

  final Failure failure;
  final VoidCallback onRetry;
  final String? titleOverride;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isNetworkFailure = failure is NetworkFailure;
    final t = context.t;

    final title =
        titleOverride ??
        (isNetworkFailure ? t.errors.noInternet : t.errors.requestFailed);

    String? displayMessage;
    if (!isNetworkFailure) {
      if (failure is CacheFailure) {
        displayMessage = t.errors.cacheError;
      } else if (failure is ServerFailure || failure is UnknownFailure) {
        if (failure.message.isEmpty ||
            failure.message ==
                "An unexpected error occurred. Please try again.") {
          displayMessage = t.errors.unknownError;
        } else {
          displayMessage = failure.message;
        }
      } else {
        displayMessage = failure.message.isNotEmpty ? failure.message : null;
      }
    }
    final iconSize = compact ? AppSpacing.iconMd : AppSpacing.iconXl;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isNetworkFailure
                  ? Icons.wifi_off_rounded
                  : Icons.error_outline_rounded,
              size: iconSize,
              color: context.colorScheme.error,
            ),
            SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.bodyLarge,
            ),
            if (displayMessage != null) ...[
              SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
              Text(
                displayMessage,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall!,
              ),
            ],
            SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
            Semantics(
              button: true,
              label: context.t.common.retry,
              child: FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.t.common.retry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

