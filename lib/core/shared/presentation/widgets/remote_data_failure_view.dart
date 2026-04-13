import 'package:flutter/material.dart';
import 'package:tech_nest/i18n/strings.g.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/network_failure.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

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
    final theme = Theme.of(context);
    final isNetworkFailure = failure is NetworkFailure;
    final title = titleOverride ??
        (isNetworkFailure
            ? context.t.errors.noInternet
            : context.t.errors.requestFailed);
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
              color: theme.colorScheme.error,
            ),
            SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (!isNetworkFailure && failure.message.isNotEmpty) ...[
              SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
              Text(
                failure.message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
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
