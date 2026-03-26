import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class CategorySkeletonList extends StatelessWidget {
  const CategorySkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Skeletonizer(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            height: 40,
            width: double.infinity,
            color: Theme.of(context).colorScheme.outline,
          ),
        );
      },
    );
  }
}
