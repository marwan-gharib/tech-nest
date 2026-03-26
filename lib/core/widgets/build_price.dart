import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_colors.dart';

class BuildPrice extends StatelessWidget {
  final double price;
  final bool isLabeled;
  final double size;
  final Color? numberColor;

  const BuildPrice({
    required this.price,
    this.size = 20,
    this.isLabeled = false,
    this.numberColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Text.rich(
      TextSpan(
        text: isLabeled ? "Price: " : "",
        style: theme.textTheme.labelLarge?.copyWith(
          fontSize: size * 0.8,
          fontWeight: FontWeight.w400,
          color: theme.shadowColor.withValues(alpha: 0.5),
        ),
        children: [
          TextSpan(
            text: price.toStringAsFixed(1),
            style: theme.textTheme.labelLarge!.copyWith(
              fontSize: size,
              fontWeight: FontWeight.bold,
              color: numberColor ?? AppColors.gray700,
            ),
          ),
          TextSpan(
            text: " \$",
            style: theme.textTheme.labelLarge!.copyWith(
              fontSize: size * 0.9,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
