import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/notifications/domain/entities/notification_entity.dart';
import 'package:tech_nest/features/notifications/presentation/notification_cubit/notification_cubit.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationItem({required this.notification, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardMd),
      color: notification.isRead
          ? context.colorScheme.surface
          : context.colorScheme.primaryContainer.withValues(alpha: 0.1),
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        title: Text(
          notification.title,
          style: context.titleMedium.copyWith(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            Text(
              notification.body,
              style: context.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              DateFormat.yMMMd().add_jm().format(notification.createdAt),
              style: context.labelSmall.copyWith(
                color: context.colors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : IconButton(
                icon: Icon(
                  Icons.mark_email_read_rounded,
                  color: context.colorScheme.primary,
                ),
                onPressed: () {
                  context.read<NotificationCubit>().markAsRead(notification.id);
                },
              ),
      ),
    );
  }
}
