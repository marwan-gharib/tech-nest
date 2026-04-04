import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class SettingsSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const SettingsSection({required this.children, super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.sm,
              bottom: AppSpacing.sm,
              top: AppSpacing.lg,
            ),
            child: Text(
              title!.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.2,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
        ...children,
      ],
    );
  }
}
